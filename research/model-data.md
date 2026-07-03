# 造形データ配布元・ライセンス（深掘り調査）

「**データを確認 → 作者へ許諾**」を進めるための、実際の3Dモデルデータ配布元リスト。プラットフォーム上の作者・ライセンス・URLを特定し、対応するX制作者に紐付ける。

- 関連Issue: [#2](https://github.com/aieo-product/stackchanEventBooth/issues/2)
- 調査日: 2026-07-03 / 方法: Chrome自動操作（MakerWorld `tag:stack-chan` / `tag:stackchan` 等）＋Web検索
- ライセンス確認済みは MakerWorld のモデルページ表記に基づく

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

## 次のアクション

- [ ] @uk59 / @UtaAoya の具体的な配布モデルURLを特定（プロフィール/固定ポスト）
- [ ] sskw・kenichi・user_93648059・sugamo・Tanipochi・beavers_hive の X アカウントを特定（許諾連絡先）
- [ ] 未確認ライセンス（#5,7,8,9）をモデルページで確定
- [ ] 各データを実際にDL・確認 → 作者へ許諾依頼（テンプレは research/accessories.md）
