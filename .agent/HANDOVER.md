# HANDOVER — stackchanEventBooth

> 最終更新: 2026-07-15 (JST) / 更新者セッション: 観覧車(#12)・撮影ブース3Dプリント化(#13)の設計をdev-workflowで実施（PR #14/#15 レビュー中）

## ゴール
- AI Dev Day 2026(7/24・13:00–17:00・1Fコミュニティショーケース)のスタックチャンブース企画/運営。
- 当日15分LTを、@UtaAoya(A-Utaさん)の**ローカルLLM展示**をメインに据えた2人リレー構成で実施。

## 完了 ✅
- LTスライドを全面改訂(全20枚): `docs/public/slides/lt.html`。テーマ「スタックチャンの歴史 → Module-LLMの苦労話 → ローカルLLM実装(A-Utaさん・メイン)」
  - 旧「電子工作素人の苦労(サーボ/ケーブル)」章＋レイテンシー詳細4枚を削除、大谷パートを前フリに凝縮
  - ②Module-LLM苦労話を実issueベースで新作(UART #29 / マイクゲイン #76 / 黙り込み #127 / MeloTTS #55)
  - バトンタッチスライド(13枚目)＋話者交代を示す紫グラデ扉(`.section.handoff`)
  - ③A-Utaさんパート(14–18枚目)を出典ポストからドラフト作成: CPU=Whisper/NPU=gpt-oss-20b(FLM)/GPU=LLM2、EVO X2+RTX5070Ti×2(OCuLink)
- `docs/lt.md` を新構成に更新(時間配分・A-Utaさん調整事項をチェックリスト化)
- build通過＋ヘッドレスChromeで表示確認済＋Cloudflare Pagesへデプロイ済

## 進行中 🚧
- **観覧車（Issue #12 / PR #14）**: 電動回転・虹色LED・実機搭乗の卓上観覧車。設計ページ `docs/ferris-wheel.md`（Ø300・ゴンドラ4基・ウォームギヤ12V・WS2812B・BOM約¥9,800・統合印刷スケジュール）。**PR #14 マージ待ち**
- **撮影ブース3Dプリント化（Issue #13 / PR #15）**: 学校ジオラマ（床タイル8＋壁パネル8＋MakerWorld小物4点採用）。`docs/photobooth.md` 全面改訂・space.md 3ゾーン化。**PR #15 は #14 の後にマージ（スタックPR）**
- 追加調査: `research/makerworld-props-20260715.md`（学校小物/汎用小物/観覧車 計26件）
- 物理作業の期限: 電装発注7/16・CAD→7/19仮組立・印刷は7/15〜7/23で観覧車46h+ブース25h+アクセ25h≒95h（1日12h立ち会い枠）
- **注意**: docs系5ページでCJK括弧隣接の`**`強調が生テキスト化するmarkdown-it問題を`<b>`で修正済み（今後も `**…（…）**+CJK` パターンは避ける）

## 完了（このセッション）✅
- 前セッションの未コミット分をcommit&push（b5664e3）→ 未コミット問題は解消
- 設計書nav/サイドバー/トップにLTスライド直リンク追加（e8bf868）＋Pages再デプロイ済（本番反映確認済）
- MakerWorldスタックチャン関連の全数調査33件: `research/makerworld-survey-20260713.md`（6123fed）
  - 量産候補の優先度整理（CC0/BY=即量産可、BY-NC=許諾推奨、版権パロディ3件=非推奨）
  - print-list.yaml への新規追加候補5件（stackchancover, neck hanging parts, 公式デコ3種 等）
- LT表紙の登壇者表記修正（476c362, 4bce415）→ デプロイ・本番反映確認済
- **docs/accessories.md に調査結果を反映（ecf05b0）**: 「MakerWorldで今すぐ印刷できる」セクションを優先度付き量産候補15件＋展示非推奨3件に全面更新 → デプロイ済

## 未着手 📋
- **量産対象の取捨選択（ユーザー判断待ち）** → 決定後 print-list.yaml へ統合・docs/accessories or printing への反映
- super-saiyan（版権パロディ）の print-list 掲載継続可否の再評価
- A-Utaさんへメインパート(14–18枚目)の内容確認・持ち時間・デモ有無・展示写真提供を依頼
- 18枚目「実装の流れ・デモ」は丸ごと差し替え前提のプレースホルダ
- (旧セッション残)各制作者への許諾依頼文面作成／auto_print実機テスト／READMEディレクトリ構成表に print/・slides/ 追記

## ブロッカー ⛔
- A-Utaさんパートは**本人未確認のドラフト**。公開サイトには反映済のため、内容修正要望が来たら差し替え→再デプロイが必要。
- 許諾依頼・A-Utaさんへの連絡は「送信」判断がユーザー領域（外部発信）。

## 次アクション（再開したら最初にやること）
1. 状態確認: `bash /Volumes/AIWorkSSD/AIWorkSpace/Skills/session-handover/scripts/state-dump.sh .`
2. **未コミット変更の確認**: `git diff --stat`（docs/lt.md, docs/public/slides/lt.html）→ 内容OKなら commit＆push
   - 例: `git add docs/lt.md docs/public/slides/lt.html && git commit -m "feat(lt): A-Utaさんメインの2人リレー構成へLTスライドを全面改訂"`
3. サイト再デプロイ時: `cd docs && npm run build` → `export CLOUDFLARE_API_TOKEN=$(security find-generic-password -s CLOUDFLARE_API_TOKEN -w); export CLOUDFLARE_ACCOUNT_ID=$(security find-generic-password -s CLOUDFLARE_ACCOUNT_ID -w); npx wrangler@latest pages deploy .vitepress/dist --project-name=stackchan-event-booth --commit-dirty=true`

## 参照
| 項目 | 値 |
|---|---|
| ブランチ | `main`（直コミット運用）|
| Pages(本番) | https://stackchan-event-booth.pages.dev/ ／ LTスライド: /slides/lt.html ／ LT企画: /lt |
| A-Uta出典ポスト | https://x.com/UtaAoya/status/1997262915846705625 (2025-12-06「ローカルAIに向き合う展示会」) |
| LTファイル | `docs/public/slides/lt.html`(本体), `docs/lt.md`(企画), 旧Marp版 `slides/lt-stackchan-ai-agent.md`(旧構成のまま残置) |
| 実開発リポ | aieo-product/aieo-stack-chan（Module-LLM苦労話の出典 #29/#76/#127/#55/#54/#70/#71/#87）|

## 検証状態
- build: 済（`npm run build` 通過）／ deploy: 済（本番反映・デプロイ直リンク 566b2e2f.stackchan-event-booth.pages.dev）
- スライド: ヘッドレスChromeで表紙/時間配分/バトンタッチ/分散アーキを確認済
- git: **未コミット**（M docs/lt.md, M docs/public/slides/lt.html）

## 申し送り・注意点
- 秘密情報はmacOS Keychainから「サービス名のみ」で取得（-a付けない）。デプロイ=CLOUDFLARE_API_TOKEN/CLOUDFLARE_ACCOUNT_ID。
- スライド構成: A-Utaさんメインが山場(6.5分)。大谷パートは前フリで、時間が押したら歴史(②)を削る方針。
- A-Utaさんパートの数字/構成はポスト記載のまま(gpt-oss-20b, FLM, EVO X2, RTX5070Ti×2, OCuLink)。本人確認で変わり得る。
- 過去セッションからの継続注意: 造形/画像は各制作者の権利物(CCでもクレジット必須, NC=物販不可)。3Dモデル実バイナリは `print/files/` を .gitignore 管理外。会場は混雑Wi-Fi懸念→デモは録画バックアップ推奨。