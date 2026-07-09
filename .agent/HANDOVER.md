# HANDOVER — stackchanEventBooth

> 最終更新: 2026-07-09 (JST) / 更新者セッション: LTスライド(HTML)完成＋READMEにPagesリンク追加まで

## ゴール
- AI Dev Day 2026(7/24・13:00–17:00・1Fコミュニティショーケース)のスタックチャンブース企画/運営。
- アクセサリー(許諾前提)・撮影ブース・必要スペース・経費・プリント自動化・当日LT を、公開Pagesで関係者共有。

## 完了 ✅
- 提案サイト(VitePress→Cloudflare Pages)公開: https://stackchan-event-booth.pages.dev/（概要/accessories/photobooth/space/schedule/printing/expenses/lt/concerns/ideas）
- アクセサリー再定義: connpass参加者照合で「着せ替え」と「非アクセ(乗物/スタンド等)」を分離(371de53)
- MakerWorld起点の印刷戦略＋全ライセンス確認(b1314f8)。フィラメント: X2D保有、6色¥13,100(c767ad8/22a03b4)
- print/ 自動印刷システム(2f060d1): print-list.yaml + auto_print.py(LAN MQTT+FTP) + download.py
- LTスライド: リッチHTML /slides/lt.html (f48489b,17de53d) ＋企画ページ docs/lt.md。電子工作素人の苦労(サーボ/ケーブル)＋制作写真入り
- README にPagesリンク追加(cef8465)

## 進行中 🚧
- なし（各コミットは完結・main はクリーンで origin と同期）

## 未着手 📋
- 各制作者への**許諾依頼文面**の作成（送信は私→ユーザーが実施。最優先=@mongonta555/@murasametech の透明シェル・猫耳）
- print/files/ に実データ配置→ `auto_print.py --go` 通しテスト（未実施）
- LTスライドに aieo-stack-chan アーキ図(architecture-overview.svg)を1枚追加
- README のディレクトリ構成表に print/・slides/ を追記（未反映）

## ブロッカー ⛔
- 許諾依頼は「送信」判断がユーザー領域（外部発信）。文面用意までは可、送信は不可。
- auto_print実機テストは X2D の LANモード設定＋Keychain(BAMBU_*)登録が前提。

## 次アクション（再開したら最初にやること）
1. 状態確認: `bash /Volumes/AIWorkSSD/AIWorkSpace/Skills/session-handover/scripts/state-dump.sh .`
2. 未着手の優先順を確認 → 既定は「許諾依頼文面リスト作成」（research/accessories.md の★表を参照）
3. サイト更新時: `cd docs && npm run build` → `export CLOUDFLARE_API_TOKEN=$(security find-generic-password -s CLOUDFLARE_API_TOKEN -w); export CLOUDFLARE_ACCOUNT_ID=$(security find-generic-password -s CLOUDFLARE_ACCOUNT_ID -w); npx wrangler@latest pages deploy .vitepress/dist --project-name=stackchan-event-booth --commit-dirty=true`

## 参照
| 項目 | 値 |
|---|---|
| ブランチ | `main`（直コミット運用）|
| Issue | #2(制作者/許諾) 他 |
| Pages(本番) | https://stackchan-event-booth.pages.dev/ ／ LT: /slides/lt.html |
| 調査資料 | `research/accessories.md`(connpass照合★), `research/model-data.md`(MakerWorldライセンス) |
| 印刷 | `print/README.md`, `print/print-list.yaml` |
| LT | `docs/public/slides/lt.html`, `docs/lt.md`（Marp旧版 `slides/lt-stackchan-ai-agent.md`)|
| 実開発リポ | aieo-product/aieo-stack-chan（LTのレイテンシー実話の出典 #54/#70/#87/#55/#56）|

## 検証状態
- build: 済（`npm run build` 通過）／ deploy: 済（本番反映）
- HTMLスライド: ヘッドレスChromeでレンダリング確認済 / PDF出力(16:9)確認済
- auto_print.py: dry-run のみ確認。**実機印刷は未検証**

## 申し送り・注意点
- 秘密情報はmacOS Keychainから「サービス名のみ」で取得（-a付けない）。デプロイ=CLOUDFLARE_*、印刷=BAMBU_PRINTER_IP/ACCESS_CODE/SERIAL。
- **許諾優先の方針**: 造形/画像は各制作者の権利物。CCライセンスでもクレジット必須、NC=物販不可。第三者画像の公開はユーザー了承済(内部確認済のもの)。
- 3Dモデル実バイナリは再配布制限のため `print/files/` を .gitignore 管理外。
- 会場は混雑Wi-Fi懸念→LTデモは録画バックアップ推奨（懸念点ページ参照）。
