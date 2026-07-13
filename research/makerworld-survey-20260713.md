# MakerWorld スタックチャン関連モデル 全数調査（装飾パーツ量産向け）

- 調査日: 2026-07-13 / 方法: Chrome自動操作（検索4クエリ＋`tag: stackchan`タグ検索＋制作者プロフィール巡回）
- 目的: 装飾・着せ替えパーツの**量産候補**を洗い出す（AI Dev Day 2026 ブース用）
- 前回調査: [model-data.md](./model-data.md)（2026-07-03）— 本調査で「要確認」だったライセンスが複数判明
- 計 **33件**（装飾・着せ替え 18件 ＋ 本体シェル・スタンド・その他 15件）

## 検索手法メモ

| クエリ | 総ヒット | 関連件数 | 備考 |
|---|---|---|---|
| `tag: stackchan`（タグ検索）| 30 | 30 | **最も網羅的**。主データソース |
| `stackchan` | 1304 | 先頭〜17件 | 精度良好 |
| `stack-chan` | 1035 | 先頭8件 | 以降は無関係な"stackable"家具等 |
| `スタックチャン`（日本語）| 1309 | 0件 | 「スタック」の一般名詞マッチのみで**使えない** |
| `M5Stack robot` | 1277 | 0件 | Stack-chan固有パーツなし |
| プロフィール巡回 | — | +3件 | M5Stack公式のデコ3種はタグ未設定・検索非ヒット |

> タグ未設定モデルの補完: Case for AI-Robots（最多DL）、Stack-chan_sample_piece、Stepper Motor Visualizer はキーワード検索のみでヒット。

## 装飾・着せ替えパーツ（量産候補）— 18件

| モデル名 | URL | 制作者 | ライセンス | 👍/DL/印刷 | プロファイル | 備考 |
|---|---|---|---|---|---|---|
| M5StackChan-Cover-no-FrontPanel | [models/2817922](https://makerworld.com/en/models/2817922-m5stackchan-cover-no-frontpanel) | [ku-nel](https://makerworld.com/en/@user_93648059) | MW-STD | 33/47/32 | 有 | フロントパネルなしケース |
| M5StackChan-Cover-add-FrontPanel | [models/2817921](https://makerworld.com/en/models/2817921-m5stackchan-cover-add-frontpanel) | [ku-nel](https://makerworld.com/en/@user_93648059) | MW-STD | 17/18/9 | 有 | フロントパネル付きケース |
| stackchancover | [models/2839068](https://makerworld.com/en/models/2839068-stackchancover) | [user_2302219760](https://makerworld.com/en/@user_2302219760) | **CC0** | 3/4/2 | 有 | シンプルカバー。制約なしで自由度最大 |
| Stack-chan headphone | [models/2858793](https://makerworld.com/en/models/2858793-stack-chan-headphone) | [sskw](https://makerworld.com/en/@sskw) | BY-NC-SA | 20/21/13 | 有 | ヘッドホン型装飾 |
| StackChan simple headphone | [models/2792626](https://makerworld.com/en/models/2792626-stackchan-simple-headphone) | [user_3807793624](https://makerworld.com/en/@user_3807793624) | MW-STD | 6/10/8 | 有 | シンプル版ヘッドホン |
| StackChan Custom Hat Generator | [models/2772131](https://makerworld.com/en/models/2772131-stackchan-custom-hat-generator) | [beavers_hive](https://makerworld.com/en/@beavers_hive) | **BY** | 10/12/5 | 有 | 帽子カスタムジェネレーター。クレジットのみで利用しやすい |
| StackChan Brick Hat | [models/2855044](https://makerworld.com/en/models/2855044-stackchan-brick-hat) | [user_4023807793](https://makerworld.com/en/@user_4023807793) | BY-NC | 17/15/9 | 有 | レンガ風帽子 |
| Pharaoh decoration of StackChan | [models/2736962](https://makerworld.com/en/models/2736962-pharaoh-decoration-of-stackchan) | [M5Stack公式](https://makerworld.com/en/@M5Stack) | BY-SA | 6/18/1 | 有 | 公式。ファラオ風装飾 |
| American football decoration for StackChan | [models/2736961](https://makerworld.com/en/models/2736961-american-football-decoration-for-stackchan) | [M5Stack公式](https://makerworld.com/en/@M5Stack) | BY-SA | 3/21/1 | 無 | 公式。アメフトヘルメット。プロフィール巡回で発見 |
| Christmas hat decoration for StackChan | [models/2736960](https://makerworld.com/en/models/2736960-christmas-hat-decoration-for-stackchan) | [M5Stack公式](https://makerworld.com/en/@M5Stack) | BY-SA | 4/18/1 | 無 | 公式。サンタ帽。プロフィール巡回で発見 |
| Saint Seiya decoration for StackChan | [models/2736950](https://makerworld.com/en/models/2736950-saint-seiya-decoration-for-stackchan) | [M5Stack公式](https://makerworld.com/en/@M5Stack) | BY-SA | 3/25/5 | 有 | 公式だが**版権パロディ（聖闘士星矢）→展示非推奨** |
| スーパーサイヤスタックチャン | [models/2834877](https://makerworld.com/en/models/2834877-super-saiyan-stack-chan-m5stackchan-exclusive-acce) | [ku-nel](https://makerworld.com/en/@user_93648059) | BY-NC-SA | 4/14/1 | 無 | **版権パロディ（ドラゴンボール）→展示非推奨** |
| Eridian Xenolite StackChan body cover | [models/3013279](https://makerworld.com/en/models/3013279-eridian-xenolite-stackchan-body-cover) | [kenichi](https://makerworld.com/en/@kenichi) | BY-NC | 1/0/0 | 有 | ボディコスチューム系カバー |
| StackChan-ServoBodycover | [models/2904501](https://makerworld.com/en/models/2904501-stackchan-servobodycover) | [user_2302219760](https://makerworld.com/en/@user_2302219760) | BY-NC | 1/0/0 | 有 | サーボ部ボディカバー |
| StackChan(M5 ver.) neck hanging parts | [models/2870969](https://makerworld.com/en/models/2870969-stackchan-m5-ver-neck-hanging-parts) | [kenichi](https://makerworld.com/en/@kenichi) | **BY** | 2/0/1 | 有 | 首掛けパーツ。クレジットのみで利用しやすい |
| Stackchan Pendant Top | [models/3022476](https://makerworld.com/en/models/3022476-stackchan-pendant-top) | [user_2722792563](https://makerworld.com/en/@user_2722792563) | BY-NC-SA | 1/0/0 | 無 | ペンダントトップ |
| スタックチャンアクセサリーセット（頭部） | [models/979116](https://makerworld.com/en/models/979116-stackchan-accessory-set-stackchan-head-accessory-s) | [ku-nel](https://makerworld.com/en/@user_93648059) | BY-NC | 4/11/3 | 有 | 頭部アクセサリーセット |
| ミックチャンなりきりセット | [models/2777168](https://makerworld.com/en/models/2777168-miku-chan-role-play-set) | [sugamo](https://makerworld.com/en/@sugamo) | BY-NC | 4/12/0 | 無 | **版権パロディ（初音ミク）→展示非推奨** |

## 本体シェル・スタンド・その他 — 15件

| モデル名 | URL | 制作者 | ライセンス | 👍/DL/印刷 | プロファイル | 備考 |
|---|---|---|---|---|---|---|
| Case for AI-Robots (AI Stack-chan minimal) | [models/881711](https://makerworld.com/en/models/881711-case-for-ai-robots-ai-stack-chan-minimal) | [hako85](https://makerworld.com/en/@hako85) | BY-NC | **115/205/63** | 有 | **全調査中で最人気**の本体エンクロージャ。タグ未設定 |
| M5Stack Stand-chan | [models/996135](https://makerworld.com/en/models/996135-m5stack-stand-chan) | [Takao](https://makerworld.com/en/@mongonta) | BY-NC | 7/12/10 | 有 | スタンド基本形 |
| M5Stack Stand-chan big | [models/996444](https://makerworld.com/en/models/996444-m5stack-stand-chan-big) | [Takao](https://makerworld.com/en/@mongonta) | BY-NC | 21/25/11 | 有 | スタンド大型版 |
| M5Stack Stand Chan Stack size up to 35mm | [models/1349010](https://makerworld.com/en/models/1349010-m5stack-stand-chan-stack-size-up-to-35mm) | [Takao](https://makerworld.com/en/@mongonta) | BY-NC | 7/27/15 | 有 | 積み上げ35mm対応 |
| M5Stack-Stand for ModuleLLM | [models/1029159](https://makerworld.com/en/models/1029159-m5stack-stand-for-modulellm) | [Takao](https://makerworld.com/en/@mongonta) | BY-NC | 5/2/2 | 有 | ModuleLLM用スタンド |
| Cuteboy custom | [models/548757](https://makerworld.com/en/models/548757-cuteboy-custom) | [Takao](https://makerworld.com/en/@mongonta) | BY-NC-SA | 4/5/0 | 無 | 本体シェルのカスタム |
| 台座「Car-stom」for タカオ版ボディ | [models/2781106](https://makerworld.com/en/models/2781106-stack-chan-base-car-stom-custom-for-takao-version) | [Tanipochi](https://makerworld.com/en/@Tanipochi) | **MW-EX** | 10/11/0 | 有 | **最も制限的（MakerWorld限定）**。量産不向き |
| スタックチャンBOX | [models/2750877](https://makerworld.com/en/models/2750877-stackable-box) | [sugamo](https://makerworld.com/en/@sugamo) | **CC0** | 4/8/0 | 無 | 収納・展示ボックス |
| スタックチャン収納バケツ | [models/2834404](https://makerworld.com/en/models/2834404-stack-chan-storage-bucket) | [sugamo](https://makerworld.com/en/@sugamo) | **CC0** | 6/6/0 | 無 | 収納バケツ |
| M5 LLM Module Bottom Case | [models/1039760](https://makerworld.com/en/models/1039760-m5-llm-module-bottom-case) | [kennel.org](https://makerworld.com/en/@kennel.org) | BY-NC-SA | 7/15/5 | 有 | LLMモジュール用ケース |
| Stack-chan OpenCar with toio | [models/2922441](https://makerworld.com/en/models/2922441-stack-chan-opencar-with-toio) | [kenichi](https://makerworld.com/en/@kenichi) | BY-NC | 0/0/0 | 有 | toio連携の機構パーツ |
| Stack-chan Stepper Motor Visualizer | [models/685287](https://makerworld.com/en/models/685287-stack-chan-stepper-motor-visualizer) | [Hiroloquy](https://makerworld.com/en/@Hiroloquy) | BY-NC-SA | 1/0/0 | 無 | 可視化ギミック。タグ未設定 |
| Stack-chan_sample_piece | [models/1145027](https://makerworld.com/en/models/1145027-stack-chan_sample_piece) | [kennel.org](https://makerworld.com/en/@kennel.org) | BY-NC-SA | 6/4/2 | 有 | サンプル/テストピース。タグ未設定 |
| スタックさん 1/12スケールフィギュア | [models/2570902](https://makerworld.com/en/models/2570902-stack-san-1-12-scale-figure) | [kenichi](https://makerworld.com/en/@kenichi) | BY-NC | 2/2/1 | 有 | 派生フィギュア |
| キューボーイゼンマイ玩具用ダミーボディ | [models/76734](https://makerworld.com/en/models/76734-dummy-body-parts-for-cubeboy-wind-up-toy) | [kennel.org](https://makerworld.com/en/@kennel.org) | BY-NC-SA | 16/22/1 | 有 | 派生玩具のダミーボディ |

> ライセンス略号は [print-list.yaml](../print/print-list.yaml) と同一: BY / BY-SA / BY-NC / BY-NC-SA / CC0 / MW-STD(標準) / MW-EX(限定)

## 量産優先度（ライセンス×プロファイル有無）

| 優先度 | 条件 | 該当（装飾パーツ） |
|---|---|---|
| 🟢 即量産可 | CC0 | stackchancover |
| 🟢 クレジットのみ | BY | Custom Hat Generator ⭐ / neck hanging parts |
| 🟡 クレジット＋SA継承 | BY-SA（M5Stack公式） | ファラオ ⭐ / アメフト / クリスマス帽 |
| 🟠 非商用展示＋クレジット（許諾推奨） | BY-NC / BY-NC-SA | headphone ⭐ / Brick Hat ⭐ / 頭部アクセセット / ボディカバー2種 / ペンダント |
| 🟠 個人印刷可・展示は要確認 | MW-STD | ku-nelカバー2種 / simple headphone |
| 🔴 展示非推奨 | 版権パロディ | 聖闘士星矢 / スーパーサイヤ / ミクちゃん |

⭐ = プリントプロファイル有＋実績（DL/印刷数）ありの推し。

## print-list.yaml との突き合わせ

既存8ジョブ（hat-generator / headphone / accessory-set / brick-hat / pharaoh / super-saiyan / body-cover / sample-piece）は**すべて本調査でも確認済み**。本調査での新規追加候補:

- **stackchancover**（CC0・プロファイル有）— ライセンス面で最優先
- **neck hanging parts**（BY・プロファイル有）— 首掛け＝来場者が持ち歩ける
- **M5Stack公式デコ3種**（BY-SA）— アメフト/クリスマス帽はプロファイル無のため要スライス
- **StackChan simple headphone**（MW-STD・プロファイル有）— 展示可否の確認後
- ~~super-saiyan~~ は版権リスクの再評価を推奨（print-list に既存 → enabled:false 検討）

## 前回調査（model-data.md）からの更新

| モデル | 前回 | 今回判明 |
|---|---|---|
| M5StackChanカバー（ku-nel, 2817922）| 要確認 | **MW-STD**（個人印刷可・再配布不可）|
| スタックチャンBOX（sugamo, 2750877）| 要確認 | **CC0** |
| Car-stom（Tanipochi, 2781106）| 要確認 | **MW-EX**（MakerWorld限定・最も制限的）|
