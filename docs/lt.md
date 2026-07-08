# LT（ライトニングトーク）企画

当日行う **15分LT** の企画・構成・進め方をまとめます。テーマは
**「スタックチャンの歴史 → AIエージェントと会話する実践（レイテンシーとの戦い）」**。
スライド本体は [`slides/lt-stackchan-ai-agent.md`](https://github.com/aieo-product/stackchanEventBooth/blob/main/slides/lt-stackchan-ai-agent.md)（Marp）。

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
| 3 | 歴史（2021→2026）| 2分 | ChatGPT連携で"会話する相棒"へ／2026 Module-LLM |
| 4 | なぜ"物理"なのか | 2分 | 画面の中の道具 → 顔・声・体で"相棒"に |
| 5 | 会話の仕組み | 2分 | 聞く/考える/話す＝どこで動かすか。我々の構成 |
| 6 | **実践：レイテンシーとの戦い** | **4分** | ★本番。7秒の沈黙 → 対策の積み上げ |
| 7 | まとめ・ブース誘導 | 2分 | 世界観の再掲＋実機に会いに来てね |

> 合計15分。**第6章（レイテンシー）が山場**なので、1〜5章は巻きで進めて時間を確保する。

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

スライドは **Marp**（Markdown → PDF/PPTX/HTML）で管理します。1ファイルで編集でき、当日は PDF 全画面 or PowerPoint 変換で投影できます。

```bash
# プレビュー（VS Code なら「Marp for VS Code」拡張が手軽）
npx @marp-team/marp-cli@latest -p slides/lt-stackchan-ai-agent.md

# PDF 書き出し（当日投影用・推奨）
npx @marp-team/marp-cli@latest slides/lt-stackchan-ai-agent.md -o lt.pdf

# PowerPoint / HTML が要る場合
npx @marp-team/marp-cli@latest slides/lt-stackchan-ai-agent.md --pptx -o lt.pptx
npx @marp-team/marp-cli@latest slides/lt-stackchan-ai-agent.md --html -o lt.html
```

### これから詰める作業（チェックリスト）

- [ ] **実機デモ映像/写真**を数点差し込む（会話の様子・アーキ図）。画像は `docs/public/img/` を流用可
- [ ] aieo-stack-chan の **アーキテクチャ図**（`docs/public/diagrams/architecture-overview.svg`）を1枚入れる
- [ ] レイテンシーの **体感が伝わる図**（声→間つなぎ→本答え のタイムライン）を作成
- [ ] **リハーサルで15分に収める**（特に1〜5章を巻く）。第6章に時間を残す
- [ ] 可能なら**ライブデモ**（実機で1往復）。失敗時に備え**録画バックアップ**も用意
- [ ] 話者ノート（各スライドの `<!-- -->`）を見ながら通し練習

::: warning 当日の保険
会場は混雑Wi-Fiが想定される（[懸念点](/concerns)）。**ライブ会話デモはネット不調で失敗し得る**ため、
🟡Degradedモード（オンデバイスのみ）でのデモ、または**録画**を必ず用意しておく。
:::

## 関連

- スライド本体（Marp）: [`slides/lt-stackchan-ai-agent.md`](https://github.com/aieo-product/stackchanEventBooth/blob/main/slides/lt-stackchan-ai-agent.md)
- 実開発リポジトリ: [aieo-product/aieo-stack-chan](https://github.com/aieo-product/aieo-stack-chan)
- ブースのアイディア（LLM Moduleデモ）: [/ideas](/ideas)
- 事前に潰す懸念点（ネットワーク）: [/concerns](/concerns)
