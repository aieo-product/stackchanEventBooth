#!/usr/bin/env python3
"""スクレイピング結果を posts.json にマージし、画像をローカル保存する。

usage:
  python3 scripts/photowall/merge_posts.py scraped.json   # ファイルから
  cat scraped.json | python3 scripts/photowall/merge_posts.py  # stdinから

- 入力: extract_tweets.js が返す配列 [{id, user, name, text, images[]}]
- 画像は docs/public/photowall/images/<id>_<n>.<ext> にダウンロード(既存はスキップ)
- posts.json に id で重複排除してマージ、id昇順(=投稿時刻順)でソート
- docs/public/photowall/ban.json (idの配列) にある投稿は除外・削除
"""
import json
import re
import sys
import urllib.request
from datetime import datetime, timezone, timedelta
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
WALL = ROOT / "docs/public/photowall"
IMAGES = WALL / "images"
POSTS = WALL / "posts.json"
BAN = WALL / "ban.json"

UA = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36"


def download(url: str, dest: Path) -> bool:
    if dest.exists() and dest.stat().st_size > 0:
        return True
    try:
        req = urllib.request.Request(url, headers={"User-Agent": UA})
        with urllib.request.urlopen(req, timeout=30) as r:
            dest.write_bytes(r.read())
        return True
    except Exception as e:
        print(f"  ! download failed: {url} ({e})", file=sys.stderr)
        return False


def ext_of(url: str) -> str:
    m = re.search(r"format=(\w+)", url)
    if m:
        return m.group(1)
    m = re.search(r"\.(jpg|jpeg|png|webp)", url)
    return m.group(1) if m else "jpg"


def main() -> None:
    raw = Path(sys.argv[1]).read_text() if len(sys.argv) > 1 else sys.stdin.read()
    scraped = json.loads(raw)
    if isinstance(scraped, str):  # javascript_tool が二重JSON文字列で返した場合
        scraped = json.loads(scraped)

    banned = set(json.loads(BAN.read_text())) if BAN.exists() else set()
    current = json.loads(POSTS.read_text()) if POSTS.exists() else {"posts": []}
    by_id = {p["id"]: p for p in current.get("posts", [])}

    IMAGES.mkdir(parents=True, exist_ok=True)
    added = 0
    for p in scraped:
        pid = str(p.get("id", ""))
        if not pid or pid in banned:
            continue
        local_images = []
        for i, url in enumerate(p.get("images", []), 1):
            if url.startswith("images/"):  # 既にローカル化済み
                local_images.append(url)
                continue
            dest = IMAGES / f"{pid}_{i}.{ext_of(url)}"
            if download(url, dest):
                local_images.append(f"images/{dest.name}")
        if not local_images:
            continue
        if pid not in by_id:
            added += 1
        by_id[pid] = {
            "id": pid,
            "user": p.get("user", ""),
            "name": p.get("name", ""),
            "text": p.get("text", ""),
            "images": local_images,
        }

    # ban 反映(後からbanに追加された既存投稿も落とす)
    for pid in list(by_id):
        if pid in banned:
            del by_id[pid]

    def sort_key(p):
        return int(p["id"]) if p["id"].isdigit() else 0

    posts = sorted(by_id.values(), key=sort_key)  # id昇順 = 投稿時刻順
    jst = timezone(timedelta(hours=9))
    out = {"updatedAt": datetime.now(jst).isoformat(timespec="seconds"), "posts": posts}
    POSTS.write_text(json.dumps(out, ensure_ascii=False, indent=2) + "\n")
    total_imgs = sum(len(p["images"]) for p in posts)
    print(f"posts: {len(posts)} (+{added} new) / images: {total_imgs} -> {POSTS}")


if __name__ == "__main__":
    main()
