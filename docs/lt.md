# LT（ライトニングトーク）企画

当日行う **15分LT** の企画・構成・進め方をまとめます。テーマは
**「スタックチャンの歴史 → Module-LLMの苦労話 → ローカルLLM実装の最前線（A-Utaさん）」**。

::: tip 🎤 2人リレー形式（メインは A-Uta さん）
[@UtaAoya](https://x.com/UtaAoya)（A-Utaさん）の **ローカルLLMスタックチャン展示**（[出典ポスト](https://x.com/UtaAoya/status/1997262915846705625)）を**メインパート**に据え、
大谷が「歴史 → Module-LLMの苦労」で前フリして**最後にバトンタッチ**する構成です。
:::

::: tip 🖥️ スライド本体（リッチHTML・そのまま投影可）
**<a href="/slides/lt.html" target="_blank">/slides/lt.html を開く</a>**（別タブ）
CDN非依存の**自己完結HTML**なので、会場のWi-Fi不調でも**オフラインで動作**します。`←/→`・スペースでめくり、`F`で全画面、`P`でPDF出力。
:::

## 狙い・ターゲット

- 来場者の**大多数はスタックチャンを知らない**前提で、「**スタックチャンとは何か**」から入る。
- 「クラウドAI頼み → **オンデバイス/ローカルAI**」という時代の流れを、**2人の実践**で立体的に見せる。
- 大谷パートは A-Uta さんパートの**前フリ**：オンデバイスAI（Module-LLM）の苦労と限界を正直に語り、「では**全部ローカル**でどこまでできる？」という問いでバトンを渡す。
- メインは A-Uta さんの **CPU/NPU/GPU分散処理によるフルローカル実装**（Whisper + gpt-oss-20b(FLM) + LLM2、EVO X2 + RTX 5070Ti ×2 OCuLink）。

::: tip キーメッセージ
**AIに顔と声と体を与える挑戦は、クラウド頼みから "全部ローカル" の時代へ。**
:::

## 15分の時間配分（2人リレー）

| # | パート | 話者 | 目安 | 要点 |
|---|---|---|--:|---|
| 1 | オープニング・地図 | 大谷 | 1分 | 2人リレーの構成と「クラウド→ローカル」の流れを提示 |
| 2 | スタックチャンの歴史 | 大谷 | 3分 | OSSのカワイイロボット・5歳・2021→2026年表・なぜ"物理"か |
| 3 | Module-LLMの苦労話 | 大谷 | 3分 | 動かすまでが地獄（UART/マイク/沈黙）・7秒の沈黙・二刀流の現在地 |
| 4 | **バトンタッチ** | 大谷 | 0.5分 | 「全部ローカルでどこまで会話できる？」→ A-Utaさん紹介 |
| 5 | **ローカルLLM実装 ★メイン** | **A-Utaさん** | **6.5分** | AIｽﾀｯｸﾁｬﾝミニマル・CPU/NPU/GPU分散・EVO X2+RTX5070Ti×2・デモ |
| 6 | まとめ・ブース誘導 | 両名 | 1分 | 「AIの体は選べる時代へ」＋実機に会いに来てね |

> 合計15分。**A-Utaさんパート（第5章）が山場**。大谷パートは前フリに徹し、時間が押したら歴史（第2章）を削る。スライドは全20枚。

## 大谷パートの素材：Module-LLM苦労話（実話・出典付き）

実開発リポジトリ [aieo-product/aieo-stack-chan](https://github.com/aieo-product/aieo-stack-chan) の実issueをそのまま使う。

| 苦労 | 内容 | 出典(issue) |
|---|---|---|
| 動かすまで① | CoreS3 ↔ Module-LLM の UART 疎通から一苦労 | #29 |
| 動かすまで② | マイクのゲイン設定が**再起動で消える**（boot永続化が必要） | #76 |
| 動かすまで③ | 音声入力が「入力待ち」のまま**黙り込む**取り込み障害 | #127 |
| 動かすまで④ | 日本語オンデバイスTTS（MeloTTS/NPU）への道が険しい | #55 / #67 / #69 |
| レイテンシー | クラウド往復7秒 → Haikuで5秒 → 間つなぎで体感1秒 | #54 / #70 / #71 / #87 |

> オチ：「オンデバイスAIは、動けば速い。動かすまでが地獄」。それでも二刀流（速い脳×賢い脳）で沈黙は消せた。**ただし賢さの本体はまだクラウド頼み**——この"正直な現在地"が A-Uta さんへの前フリになる。

## メインパートの素材：A-Utaさんのローカル LLM 実装

[出典ポスト（2025-12-06・#ローカルAIに向き合う展示会）](https://x.com/UtaAoya/status/1997262915846705625)より：

- **AI ｽﾀｯｸﾁｬﾝ ミニマル** — ネット接続なしで音声会話
- 分散処理：**CPU = Whisper（音声認識）／ NPU = LLM1: gpt-oss-20b（FLM）／ GPU = LLM2**
- ハードウェア：**EVO X2 + RTX 5070Ti ×2（OCuLink経由）**
- **スマホ版は全部CPU** で動かす割り切り構成

::: warning A-Utaさんとの調整事項
- スライドのメインパート（15〜18枚目）は**ポスト内容ベースのドラフト**。A-Utaさん本人に内容確認・差し替えを依頼する。
- 18枚目「実装の流れ・デモ」は**丸ごと差し替え前提**のプレースホルダ。
- 持ち時間（5〜6.5分）・デモの有無・録画バックアップの要否を事前にすり合わせる。
:::

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

> 旧Marp版 [`slides/lt-stackchan-ai-agent.md`](https://github.com/aieo-product/stackchanEventBooth/blob/main/slides/lt-stackchan-ai-agent.md) は<b>旧構成（電子工作素人の苦労話＋レイテンシー主役）</b>のまま残置。内容の正はHTML版。

### これから詰める作業（チェックリスト）

- [ ] **A-Utaさんにメインパート（15〜18枚目）の内容確認・差し替え**を依頼（持ち時間・デモ有無も）
- [ ] A-Utaさんの**展示写真・アーキ図**を提供してもらいメインパートに差し込む
- [ ] **リハーサルで15分に収める**（バトンタッチの段取り含む。押したら歴史パートを削る）
- [ ] 可能なら**ライブデモ**（実機で1往復）。失敗に備え**録画バックアップ**を用意
- [ ] 会場PCで**事前に表示確認**（フォント・全画面・めくり）

::: warning 当日の保険
会場は混雑Wi-Fiが想定される（[懸念点](/concerns)）。大谷側のクラウド連携デモはネット不調で失敗し得るため、🟡Degradedモードまたは**録画**を用意。
A-Utaさん側は**フルローカルなのでネット不要**——むしろ本構成の強みとして紹介できる。
:::

## 関連

- 🖥️ **スライド本体（リッチHTML）**: [/slides/lt.html](/slides/lt.html)
- A-Utaさんの出典ポスト: [x.com/UtaAoya/status/1997262915846705625](https://x.com/UtaAoya/status/1997262915846705625)
- スライド旧版（Marp・旧構成）: [`slides/lt-stackchan-ai-agent.md`](https://github.com/aieo-product/stackchanEventBooth/blob/main/slides/lt-stackchan-ai-agent.md)
- 実開発リポジトリ: [aieo-product/aieo-stack-chan](https://github.com/aieo-product/aieo-stack-chan)
- ブースのアイディア（LLM Moduleデモ）: [/ideas](/ideas)
- 事前に潰す懸念点（ネットワーク）: [/concerns](/concerns)
