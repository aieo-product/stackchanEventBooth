#!/usr/bin/env python3
"""
スタックチャン ブース用 自動印刷ランナー
============================================
print-list.yaml を読み、Bambu Lab X2D へ 1 ジョブずつ送って印刷する。

前提:
  - X2D が LAN モード（Bambu Studio > プリンター > 「LAN Only Mode / 開発者モード」）で
    同一ネットワーク上にいること。MQTT(8883) と FTPS(990) を使う。
  - print/files/ に、各ジョブの `file`（MakerWorld の Print Profile = 事前スライス済み
    .gcode.3mf 推奨）が置かれていること。未配置は download.py で入手先を確認。
  - 接続情報は macOS Keychain（サービス名のみ）から取得。値はファイルに書かない。
      BAMBU_PRINTER_IP    例: 192.168.1.50
      BAMBU_ACCESS_CODE   プリンターの「アクセスコード」(LAN画面に表示)
      BAMBU_SERIAL        例: 01P00A2B0300123
    未登録なら README の手順で `security add-generic-password` / `akc set` で登録。

安全上の注意（重要）:
  - 3Dプリンターの連続運転は火災・造形失敗のリスクがある。**無人運転は禁止**。
    本スクリプトは 1 ジョブ完了ごとに次へ進む逐次実行で、必ず立ち会って使うこと。
  - 実際に印刷を開始するには `--go` が必要（既定は dry-run）。

使い方:
  python3 auto_print.py                 # dry-run（何を刷るか表示するだけ）
  python3 auto_print.py --only hat-generator
  python3 auto_print.py --go            # 実行（要立ち会い）
  python3 auto_print.py --go --yes      # 開始確認プロンプトを省略
"""
from __future__ import annotations
import argparse
import os
import subprocess
import sys
import time
from pathlib import Path

HERE = Path(__file__).resolve().parent
LIST_PATH = HERE / "print-list.yaml"


def die(msg: str, code: int = 1):
    print(f"[ERROR] {msg}", file=sys.stderr)
    sys.exit(code)


def load_yaml(path: Path) -> dict:
    try:
        import yaml  # PyYAML
    except ImportError:
        die("PyYAML が必要です: pip install -r requirements.txt")
    with path.open("r", encoding="utf-8") as f:
        return yaml.safe_load(f)


def keychain(name: str) -> str | None:
    """macOS Keychain からサービス名のみで取得（-a は付けない・CLAUDE.md 準拠）。"""
    v = os.environ.get(name)
    if v:
        return v
    try:
        out = subprocess.run(
            ["security", "find-generic-password", "-s", name, "-w"],
            capture_output=True, text=True, check=True,
        )
        return out.stdout.strip() or None
    except Exception:
        return None


def get_printer_conn() -> tuple[str, str, str]:
    ip = keychain("BAMBU_PRINTER_IP")
    code = keychain("BAMBU_ACCESS_CODE")
    serial = keychain("BAMBU_SERIAL")
    missing = [n for n, v in (("BAMBU_PRINTER_IP", ip),
                              ("BAMBU_ACCESS_CODE", code),
                              ("BAMBU_SERIAL", serial)) if not v]
    if missing:
        die("Keychain に接続情報がありません: " + ", ".join(missing)
            + "\n  README の『プリンター接続情報の登録』を参照。")
    return ip, code, serial


def resolve_jobs(data: dict, only: str | None) -> list[dict]:
    jobs = data.get("jobs", [])
    if only:
        jobs = [j for j in jobs if j.get("key") == only]
        if not jobs:
            die(f"key='{only}' のジョブが print-list.yaml に見つかりません")
    else:
        jobs = [j for j in jobs if j.get("enabled")]
    return jobs


def print_plan(jobs: list[dict], defaults: dict):
    total = sum(int(j.get("copies", 1)) for j in jobs)
    print("=" * 64)
    print(f"印刷プラン（{len(jobs)} 種 / 合計 {total} 個） 送信先: "
          f"{defaults.get('printer', 'X2D')}")
    print("=" * 64)
    for j in jobs:
        f = HERE / j.get("file", "")
        present = "✓" if f.exists() else "✗未配置"
        print(f"  [{present}] {j['key']:<18} x{j.get('copies',1):<2} "
              f"色:{j.get('color','-'):<12} "
              f"lic:{j.get('license','-'):<10} {j.get('name','')}")
    print("-" * 64)


def ensure_files(jobs: list[dict]) -> list[dict]:
    missing = [j for j in jobs if not (HERE / j.get("file", "")).exists()]
    if missing:
        print("\n[!] 次のファイルが print/files/ にありません（入手して配置してください）:")
        for j in missing:
            print(f"    - {j['file']}  <=  {j.get('url','(入手先未定)')}")
        print("    → download.py で入手先URLを一覧表示できます。\n")
    return [j for j in jobs if (HERE / j.get("file", "")).exists()]


def run_prints(jobs: list[dict], defaults: dict, assume_yes: bool):
    try:
        import bambulabs_api as bl
    except ImportError:
        die("bambulabs_api が必要です: pip install -r requirements.txt")

    ip, code, serial = get_printer_conn()
    printable = ensure_files(jobs)
    if not printable:
        die("印刷可能なファイルが1つもありません。")

    if not assume_yes:
        ans = input(f"\nX2D({ip}) で {len(printable)} 種の印刷を開始します。"
                    "プリンターに立ち会っていますか？ [y/N] ").strip().lower()
        if ans != "y":
            print("中止しました。")
            return

    print(f"\n接続中… {ip}")
    printer = bl.Printer(ip, code, serial)
    printer.connect()
    time.sleep(2)

    wait_between = int(defaults.get("wait_between_sec", 30))
    plate = int(defaults.get("plate", 1))
    use_ams = bool(defaults.get("use_ams", True))

    try:
        for j in printable:
            copies = int(j.get("copies", 1))
            local = HERE / j["file"]
            remote = Path(j["file"]).name
            ams_map = j.get("ams_mapping", [0])
            for n in range(1, copies + 1):
                label = f"{j['key']} ({n}/{copies})"
                print(f"\n▶ {label}: アップロード {remote} …")
                with local.open("rb") as fh:
                    printer.upload_file(fh, remote)
                print(f"▶ {label}: 印刷開始（plate={plate}, ams={ams_map}）")
                printer.start_print(remote, plate, use_ams=use_ams,
                                    ams_mapping=ams_map)
                _wait_until_done(printer, label)
                print(f"✓ {label}: 完了")
                if not (j is printable[-1] and n == copies):
                    print(f"  次まで {wait_between}s 待機（造形の取り外し等）…")
                    time.sleep(wait_between)
    finally:
        try:
            printer.disconnect()
        except Exception:
            pass
    print("\nすべてのジョブが完了しました。")


def _wait_until_done(printer, label: str, timeout_sec: int = 6 * 3600):
    """状態が FINISH/IDLE になるまでポーリング。ライブラリ差異に耐えるよう防御的に。"""
    start = time.time()
    last = None
    while True:
        state = None
        pct = None
        try:
            state = str(printer.get_state())
        except Exception:
            pass
        try:
            pct = printer.get_percentage()
        except Exception:
            pass
        if state != last:
            print(f"    {label}: state={state} {pct if pct is not None else ''}")
            last = state
        s = (state or "").upper()
        if any(k in s for k in ("FINISH", "IDLE", "SUCCESS")):
            return
        if "FAIL" in s or "ERROR" in s:
            raise RuntimeError(f"{label}: プリンターがエラー状態 ({state})")
        if time.time() - start > timeout_sec:
            raise TimeoutError(f"{label}: タイムアウト")
        time.sleep(10)


def main():
    ap = argparse.ArgumentParser(description="print-list.yaml から X2D へ自動印刷")
    ap.add_argument("--go", action="store_true", help="実際に印刷する（既定は dry-run）")
    ap.add_argument("--only", metavar="KEY", help="指定 key のジョブだけ実行")
    ap.add_argument("--yes", action="store_true", help="開始確認を省略")
    ap.add_argument("--list", dest="list_path", default=str(LIST_PATH))
    args = ap.parse_args()

    data = load_yaml(Path(args.list_path))
    defaults = data.get("defaults", {})
    jobs = resolve_jobs(data, args.only)
    if not jobs:
        die("実行対象のジョブがありません（enabled:true か --only を指定）。")

    print_plan(jobs, defaults)

    if not args.go:
        ensure_files(jobs)
        print("これは dry-run です。実際に印刷するには --go を付けてください。")
        return
    run_prints(jobs, defaults, assume_yes=args.yes)


if __name__ == "__main__":
    main()
