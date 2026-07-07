#!/usr/bin/env python3
"""
印刷ファイルの入手ヘルパー
============================================
print-list.yaml を見て、print/files/ に不足しているモデルファイルの
「入手先URL」を一覧表示する。--open でブラウザに一括で開く。

MakerWorld のデータDLはログインが必要（Print Profile を Bambu Studio に
送るのが最も確実）。本スクリプトはリンクを提示するだけで、規約に反する
自動スクレイピングは行わない。ダウンロードした .gcode.3mf を print-list.yaml
の `file`（例: files/hat-generator.gcode.3mf）の名前で保存すればよい。

使い方:
  python3 download.py            # 不足ファイルと入手先URLを一覧
  python3 download.py --open     # 入手先をブラウザで開く（macOS: open）
  python3 download.py --all      # 全ジョブ（配置済み含む）を一覧
"""
from __future__ import annotations
import argparse
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
LIST_PATH = HERE / "print-list.yaml"


def load_jobs() -> tuple[list[dict], dict]:
    try:
        import yaml
    except ImportError:
        print("[ERROR] PyYAML が必要: pip install -r requirements.txt", file=sys.stderr)
        sys.exit(1)
    data = yaml.safe_load(LIST_PATH.read_text(encoding="utf-8"))
    return data.get("jobs", []), data


def main():
    ap = argparse.ArgumentParser(description="不足モデルファイルの入手先を表示")
    ap.add_argument("--open", action="store_true", help="入手先URLをブラウザで開く")
    ap.add_argument("--all", action="store_true", help="配置済みも含め全件表示")
    args = ap.parse_args()

    jobs, _ = load_jobs()
    urls: list[str] = []
    print("状態  key                file                         入手先")
    print("-" * 88)
    for j in jobs:
        f = HERE / j.get("file", "")
        present = f.exists()
        if present and not args.all:
            continue
        mark = "✓有" if present else "✗無"
        url = j.get("url", "(入手先未定)")
        print(f" {mark}  {j.get('key',''):<18} {j.get('file',''):<28} {url}")
        if not present and url.startswith("http"):
            urls.append(url)

    if not urls:
        print("\n不足ファイルはありません。auto_print.py --go で印刷できます。")
        return

    print(f"\n不足 {len(urls)} 件。ダウンロード後、print-list.yaml の `file` 名で "
          "print/files/ に保存してください（Print Profile の .gcode.3mf 推奨）。")
    if args.open:
        opener = "open" if sys.platform == "darwin" else "xdg-open"
        for u in urls:
            try:
                subprocess.run([opener, u], check=False)
            except Exception as e:
                print(f"  open 失敗: {u} ({e})")


if __name__ == "__main__":
    main()
