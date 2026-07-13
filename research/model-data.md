# 造形データ配布元・ライセンス（深掘り調査）

「**データを確認 → 作者へ許諾**」を進めるための、実際の3Dモデルデータ配布元リスト。プラットフォーム上の作者・ライセンス・URLを特定し、対応するX制作者に紐付ける。

- 関連Issue: [#2](https://github.com/aieo-product/stackchanEventBooth/issues/2)
- 調査日: 2026-07-03 / 方法: Chrome自動操作（MakerWorld `tag:stack-chan` / `tag:stackchan` 等）＋Web検索
- ライセンス確認済みは MakerWorld のモデルページ表記に基づく
- **更新調査**: [makerworld-survey-20260713.md](./makerworld-survey-20260713.md)（2026-07-13・全33件）— 本書で「要確認」のライセンスが判明（ku-nelカバー=MW標準 / BOX=CC0 / Car-stom=MW限定）

## MakerWorld（データDL可・ライセンス明記）

| # | 造形（種類）| 作者(MakerWorld) | ライセンス | データURL |
|---|---|---|---|---|
| 1 | Stack-chan **サンプルパーツ**（顔パーツ・耳カラー等）| **kennel.org**（＝X:@kennel_org）| **CC BY-NC-SA** | [models/1145027](https://makerworld.com/ja/models/1145027-stack-chan_sample_piece) |
| 2 | 🎧 **スタックちゃんヘッドホン** | **sskw** | **CC BY-NC-SA** | [models/2858793](https://makerworld.com/ja/models/2858793-stack-chan-headphone) |
| 3 | 🔑 スタックちゃん **クレーンゲームアクセサリー**（タグ/キーホルダー）| sskw | **CC BY-SA** | [models/564419](https://makerworld.com/ja/models/564419-stack-chan-crane-machine-accessory) |
| 4 | 🎩 スタックチャン **custom hat generator**（帽子ジェネレータ）| beavers_hive | **CC BY** | [models/2772131](https://makerworld.com/ja/models/2772131-stackchan-custom-hat-generator) |
| 5 | 🧊 **M5StackChanカバー**（フロントパネルなし）| user_93648059 | 要確認 | [models/2817922](https://makerworld.com/ja/models/2817922-m5stackchan-cover-no-frontpanel) |
| 6 | 🚗 **OpenCar with toio**（台車・baseIdeaのQRカード）| **kenichi**（ken-ichi）| **CC BY-NC** | [models/2922441](https://makerworld.com/ja/models/2922441-stack-chan-opencar-with-toio) |
| 7 | スタックチャン **BOX** | sugamo | 要確認 | [models/2750877](https://makerworld.com/ja/models/2750877-stackable-box) |
| 8 | 台座「Car-stom」for タカオ版ボディ | Tanipochi | 要確認 | [models/2781106](https://makerworld.com/ja/models/2781106-stack-chan-base-car-stom-custom-for-takao-version) |
| 9 | toio用 Atom mate マウント | kenichi | 要確認 | [models/530912](https://makerworld.com/ja/models/530912-atom-mate-for-toio-mount-for-toio-core-cube) |

> MakerWorld一覧: [tag:stack-chan](https://makerworld.com/ja/search/models?keyword=tag%3A+stack-chan) / [tag:stackchan](https://makerworld.com/ja/search/models?keyword=tag%3A+stackchan)

## BOOTH / GitHub（その他の配布元）

| 配布元 | 内容 | 作者 | 条件 |
|---|---|---|---|
| [mongonta.booth.pm](https://mongonta.booth.pm/)（Arpeggio Factory）| タカオ版ケースセット・スタンドSTL 等 | タカヲ/Takao（X:@mongonta555）| BOOTH（有料/一部STL配布・規約準拠）|
| [booth 3771954](https://booth.pm/ja/items/3771954) | Core2分解不要の組立オプションSTL | First DIY | BOOTH |
| [github.com/m5stack/StackChan](https://github.com/m5stack/StackChan) | 本体の3Dデータ（公式・OSS）| M5Stack/community | リポジトリのライセンス |

## X制作者 → データ配布元の紐付け

| X制作者 | 配布元・データ | 状態 |
|---|---|---|
| @kennel_org | MakerWorld **kennel.org** サンプルパーツ（CC BY-NC-SA）| ✅ 特定 |
| @uk59（くうねる）| MakerWorld **MakerChip**（QRチップ）形式で配布。個別モデルはプロフィール要確認 | 🔎 要確認 |
| @UtaAoya（A-Uta）| 「ミニマル(スマホ版)ケース」配布先（MakerWorld/booth）| 🔎 要確認 |
| @mongonta555（Takao）| mongonta.booth.pm / GitHub | ✅ 特定 |
| sskw（MakerWorld）| ヘッドホン/クレーンアクセ。X handle | 🔎 要確認 |
| kenichi（MakerWorld）| OpenCar with toio。X handle（baseIdeaカードは @kenichi 表記）| 🔎 要確認 |
| @k8ark | 撮影ブース（造形データではなくジオラマ演出）| — |

## ライセンス別・ブース利用の考え方（※最終は各作者へ確認）

| ライセンス | 表示 | 非商用 | 継承(SA) | ブース（非商用展示）での目安 |
|---|:--:|:--:|:--:|---|
| CC BY | 必要 | 制限なし | — | 展示・印刷OK（クレジット必須）|
| CC BY-SA | 必要 | 制限なし | あり | OK。改変配布は同ライセンス継承 |
| CC BY-NC | 必要 | **非商用のみ** | — | 無料展示はOK。**物販/有償頒布は不可** |
| CC BY-NC-SA | 必要 | **非商用のみ** | あり | 同上＋継承 |

> 本ブースは非商用のコミュニティ展示のため多くは利用可の範囲だが、**方針どおり各作者に許諾を取る**。特に SA（改変時）・NC（物理配布/物販）・独自条件は事前確認必須。

## MakerWorld = X2Dで最速の印刷供給源（2026-07-06 全ライセンス確認）

MakerWorld は Bambu Lab 公式プラットフォーム。多くのモデルに **Print Profile（Bambu向け事前スライス済み3MF）** が付属し、Bambu Studio/Handy から **X2D へワンクリック送信で印刷可能**（＝実質そのまま生成できる）。`__NEXT_DATA__` から全ヒットのライセンスを一括取得した結果、スタックチャンの**着せ替えアクセサリー**は以下（各ページの `license` フィールドより）。

### 着せ替えアクセサリー（印刷対象）

| ID | アクセサリー | 種別 | ライセンス | 作者(uid) |
|---|---|---|---|---|
| [979116](https://makerworld.com/ja/models/979116) | スタックチャン アクセサリーセット/head accessory set | 頭部アクセ複数 | **BY-NC** | user_93648059 |
| [2858793](https://makerworld.com/ja/models/2858793) | Stack-chan headphone | ヘッドホン | **BY-NC-SA** | sskw |
| [2792626](https://makerworld.com/ja/models/2792626) | StackChan simple headphone | ヘッドホン | MakerWorld標準 | — |
| [2772131](https://makerworld.com/ja/models/2772131) | StackChan Custom Hat Generator | 帽子(自由生成) | **BY** | beavers_hive |
| [2855044](https://makerworld.com/ja/models/2855044) | StackChan Brick Hat | ブロック帽子 | **BY-NC** | — |
| [2736962](https://makerworld.com/ja/models/2736962) | Pharaoh decoration of StackChan | かぶりもの | **BY-SA** | — |
| [2834877](https://makerworld.com/ja/models/2834877) | ｽｰﾊﾟｰｻｲﾔｽﾀｯｸﾁｬﾝ | 髪 | **BY-NC-SA** | user_93648059 |
| [3013279](https://makerworld.com/ja/models/3013279) | Eridian Xenolite StackChan body cover | ボディカバー | **BY-NC** | — |
| [2904501](https://makerworld.com/ja/models/2904501) | StackChan-ServoBodycover | ボディカバー(サーボ) | **BY-NC** | — |
| [1145027](https://makerworld.com/ja/models/1145027) | Stack-chan_sample_piece | 顔/耳パーツ | **BY-NC-SA** | kennel.org(@kennel_org) |
| [564419](https://makerworld.com/ja/models/564419) | Stack-chan Crane Machine Accessory | タグ/キーホルダー | **BY-SA** | sskw |

### 非アクセサリー（MakerWorldにあるが対象外）

| ID | 名称 | 種別 | ライセンス |
|---|---|---|---|
| [2922441](https://makerworld.com/ja/models/2922441) | Stack-chan OpenCar with toio | 台車 | BY-NC |
| [2750877](https://makerworld.com/ja/models/2750877) | スタックチャンBOX | 収納 | **CC0** |
| [2781106](https://makerworld.com/ja/models/2781106) | 台座「Car-stom」| スタンド | MakerWorld限定 |
| [2817922](https://makerworld.com/ja/models/2817922) | M5StackChan-Cover-no-FrontPanel | カバー | MakerWorld標準 |
| [996135](https://makerworld.com/ja/models/996135) / [1349010](https://makerworld.com/ja/models/1349010) | M5Stack Stand-chan 各種 | スタンド | BY-NC |

### ライセンス区分の注意

- **CC0**：完全フリー（権利放棄）。**CC BY**：クレジットのみ。**CC BY-SA**：改変配布は同ライセンス継承。**CC BY-NC / BY-NC-SA**：非商用のみ（無料展示OK・物販不可）。
- **「MakerWorld標準ライセンス(Standard Digital File License)」「MakerWorld限定ライセンス(Exclusive)」**：個人・非商用の**印刷は可**だが**データ再配布・商用は不可**。当ブース（無料展示・データ再配布なし）は範囲内。
- MakerWorldはBambu連携でDL/印刷が容易＝**実質そのまま生成可能**。ただし透明シェル・猫耳（@mongonta555/@murasametech）は MakerWorld に無く、BOOTH/GitHub/直接許諾が必要。

## 次のアクション

- [ ] @uk59 / @UtaAoya の具体的な配布モデルURLを特定（プロフィール/固定ポスト）
- [ ] sskw・kenichi・user_93648059・sugamo・Tanipochi・beavers_hive の X アカウントを特定（許諾連絡先）
- [ ] 未確認ライセンス（#5,7,8,9）をモデルページで確定
- [ ] 各データを実際にDL・確認 → 作者へ許諾依頼（テンプレは research/accessories.md）
