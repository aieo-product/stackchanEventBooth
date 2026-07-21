# フォトウォール更新手順（当日運用）

`https://stackchan-event-booth.pages.dev/photowall/` に X の
`#ｽﾀｯｸﾁｬﾝ写真館 #AIDevDay` 付き投稿写真をスライドショー表示する。
表示側は静的ページ + `posts.json`。更新は「Claude in Chrome でスクレイピング →
merge → deploy」を人手トリガー（or /loop）で回す。

## 表示側の仕様

- URL: `/photowall/`（プレビュー: `/photowall/?data=posts.sample.json`）
- 1画像 10 秒表示（複数画像ポストは 1 枚ずつ順に表示）・クロスフェード・ループ
- 画面下部にポスト本文＋表示名＋@アカウント名（ハッシュタグは青ハイライト）
- posts.json を 60 秒ごとに再取得 → デプロイすればリロード不要で反映
- `F` キー or ダブルクリックで全画面。`←`/`→` で手動送り
- 投稿 0 件のときは「投稿してね」誘導画面

## 更新手順（Claude が実行）

1. **スクレイピング（Claude in Chrome）**
   - タブを開く: `https://x.com/search?q=%23ｽﾀｯｸﾁｬﾝ写真館%20%23AIDevDay&src=typed_query&f=live`
     （`f=live`=最新タブ。X ログイン済みの Chrome 必須）
   - `javascript_tool` で `scripts/photowall/extract_tweets.js` の中身を実行 → JSON 配列が返る
   - 件数が多い日はスクロール（`computer` の scroll）→ 再実行を繰り返し、結果を連結
     （merge 側で id 重複排除されるので雑に連結してよい）
2. **マージ（画像DL + posts.json 更新）**
   - 取得 JSON をスクラッチパッドに保存して:
     ```bash
     python3 scripts/photowall/merge_posts.py /path/to/scraped.json
     ```
   - 画像は `docs/public/photowall/images/<tweetid>_<n>.jpg` に保存され、
     posts.json はローカルパス参照になる（会場で X が重くても表示は安定）
3. **デプロイ**（HANDOVER の定型作業と同じ）
   ```bash
   export PATH="$HOME/.nvm/versions/node/v24.14.1/bin:$PATH"
   cd docs && npm run build
   export CLOUDFLARE_API_TOKEN=$(security find-generic-password -s CLOUDFLARE_API_TOKEN -w)
   export CLOUDFLARE_ACCOUNT_ID=$(security find-generic-password -s CLOUDFLARE_ACCOUNT_ID -w)
   npx wrangler@latest pages deploy .vitepress/dist --project-name=stackchan-event-booth --commit-dirty=true
   ```

## 不適切投稿の除外

`docs/public/photowall/ban.json` にツイート id の配列を書いて merge を再実行:

```json
["1234567890123456789"]
```

既に posts.json に入っている分も除外される。緊急時は posts.json から該当エントリを
手で消して即デプロイでもよい。

## 当日のブース側操作

1. 表示用 PC のブラウザで `/photowall/` を開き `F` で全画面 — これだけ
2. 更新したくなったら Claude に「フォトウォール更新して」（この README の手順を実行）
   or `/loop 10m` で定期実行
