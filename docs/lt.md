# LT（ライトニングトーク）企画

当日行う **15分LT** の企画・構成・進め方をまとめます。テーマは
**「スタックチャンの歴史 → 電子工作素人が作ってみた → AIエージェントと会話する実践（レイテンシーとの戦い）」**。

::: tip 🖥️ スライド本体（リッチHTML・そのまま投影可）
**<a href="/slides/lt.html" target="_blank">/slides/lt.html を開く</a>**（別タブ）
CDN非依存の**自己完結HTML**なので、会場のWi-Fi不調でも**オフラインで動作**します。`←/→`・スペースでめくり、`F`で全画面、`P`でPDF出力。制作写真（サーボ・配線・完成）入り。
:::

## 狙い・ターゲット

- 来場者の**大多数はスタックチャンを知らない**前提で、「**スタックチャンとは何か**」から入る。
- 「**AIエージェントを使って何ができるか**」を、実開発の体験として語る。
- 本ブースの世界観＝**自分で育てたAIエージェントが、物理的に呼び出せる**フィジカルな体験を推す。
- 実開発リポジトリ [aieo-product/aieo-stack-chan](https://github.com/aieo-product/aieo-stack-chan) の**苦労話（レイテンシー）**を主役に、"生々しさ"で惹きつける。

::: tip キーメッセージ
**育てたAIエージェントが、顔と声と体を持つと "相棒" になる。** その実現を阻む最大の壁が「返事までの間（レイテンシー）」で、それをどう削ったか——を軸に語る。
:::

## 15分の時間配分

| # | パート | 目安 | 要点 |
|---|---|--:|---|
| 1 | つかみ・ゴール提示 | 1分 | 自己紹介は一言。「歴史→実践」の地図を見せる |
| 2 | スタックチャンとは | 2分 | OSSのカワイイ手乗りロボット・5歳・コミュニティ |
| 3 | 歴史（2021→2026）| 1.5分 | ChatGPT連携で"会話する相棒"へ／2026 Module-LLM |
| 4 | なぜ"物理"なのか | 1.5分 | 画面の中の道具 → 顔・声・体で"相棒"に |
| 5 | **作ってみた：電子工作素人の壁** | **2.5分** | 初めての電子工作／ケーブルの海／サーボとの格闘／動いた感動（制作写真） |
| 6 | 会話の仕組み | 2分 | 聞く/考える/話す＝どこで動かすか。我々の構成 |
| 7 | **実践：レイテンシーとの戦い** | **3.5分** | ★本番。7秒の沈黙 → 対策の積み上げ |
| 8 | まとめ・ブース誘導 | 1分 | 世界観の再掲＋実機に会いに来てね |

> 合計15分。**第5章（電子工作の苦労）と第7章（レイテンシー）が山場**。スライドは全28枚（セクション扉含む）で、扉は数秒で流す。写真スライドは"語り"中心に。

## 山場：レイテンシー物語（実話・出典付き）

実開発で計測した数字をそのまま使う。ストーリーは「**7秒の沈黙**をどう埋めたか」。

| 対策 | 効果 | 出典(issue) |
|---|---|---|
| **問題**：クラウド往復で応答7秒（Claude APIが3–4秒で最大ボトルネック）| — | #54 |
| ① モデル選び：Sonnet → **Haiku 4.5** | 7秒 → **5秒** | #54 |
| ② **ストリーミングTTS**（文境界ごとに即発話）| 喋り始めを前倒し | #87 |
| ③ **"間つなぎ"応答**（文脈ワード抽出＝mecab・オンデバイス）| 4秒 → **1秒** | #70 / #71 |
| ④ **オンデバイスTTS**（MeloTTS/NPU）＋ session/cache | PCM転送 **1–2秒削減** | #55 / #56 |

> オチ：「**速くする**」だけでなく「**待たせない**（間つなぎ・ストリーミング）」の総力戦。レイテンシーは**数字と体感の両面**で戦う。これは本ブースの [懸念点＝混雑会場のネットワーク](/concerns) 対策（🟡Degradedモード）にも直結する。

## スライドの作り方・進め方

スライドは **リッチHTML**（[`docs/public/slides/lt.html`](https://github.com/aieo-product/stackchanEventBooth/blob/main/docs/public/slides/lt.html)）を正とします。1ファイル自己完結で**オフライン投影可**、公開サイトからも **[/slides/lt.html](/slides/lt.html)** で開けます。

- **投影**：ブラウザで開いて `F` で全画面。`←/→`・スペースでめくる。タッチスワイプ対応。
- **編集**：HTMLを直接編集（各スライドは `<section class="slide">`）。制作写真は `docs/public/slides/assets/`。
- **PDF化**：ブラウザで `P`（印刷→PDFで保存）。または Chromeヘッドレスで書き出し可。

```bash
# PDF書き出し（Chromeヘッドレス・任意）
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --headless=new --print-to-pdf=lt.pdf --no-pdf-header-footer \
  "http://localhost:5173/slides/lt.html"   # ローカル配信 or 公開URLでも可
```

> 旧Marp版 [`slides/lt-stackchan-ai-agent.md`](https://github.com/aieo-product/stackchanEventBooth/blob/main/slides/lt-stackchan-ai-agent.md) も残置（テキスト管理したい場合の代替）。内容の正はHTML版。

### これから詰める作業（チェックリスト）

- [x] **制作写真**（組み立て・ケーブル・サーボ・完成）を差し込み ✅
- [x] レイテンシーの **体感が伝わる図**（声→間つなぎ→本答えのタイムライン）✅
- [ ] aieo-stack-chan の **アーキテクチャ図**を1枚追加（`architecture-overview.svg` を assets へ）
- [ ] **リハーサルで15分に収める**（セクション扉は数秒で流す。第5章・第7章に時間を残す）
- [ ] 可能なら**ライブデモ**（実機で1往復）。失敗に備え**録画バックアップ**を用意
- [ ] 会場PCで**事前に表示確認**（フォント・全画面・めくり）

::: warning 当日の保険
会場は混雑Wi-Fiが想定される（[懸念点](/concerns)）。**ライブ会話デモはネット不調で失敗し得る**ため、
🟡Degradedモード（オンデバイスのみ）でのデモ、または**録画**を必ず用意しておく。
:::

## 関連

- 🖥️ **スライド本体（リッチHTML）**: [/slides/lt.html](/slides/lt.html)
- スライド旧版（Marp）: [`slides/lt-stackchan-ai-agent.md`](https://github.com/aieo-product/stackchanEventBooth/blob/main/slides/lt-stackchan-ai-agent.md)
- 実開発リポジトリ: [aieo-product/aieo-stack-chan](https://github.com/aieo-product/aieo-stack-chan)
- ブースのアイディア（LLM Moduleデモ）: [/ideas](/ideas)
- 事前に潰す懸念点（ネットワーク）: [/concerns](/concerns)
