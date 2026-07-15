# 観覧車 追加発注パーツ 実売調査（2026-07-15・Amazon＋秋葉原実店舗）

- 調査方法: Chrome自動操作でAmazon.co.jpを閲覧のみ（カート投入なし）。価格は税込・お届け予定は調査時点の表示
- **全候補が翌日7/16(木)着**（Prime）を確認。在庫切れ・納期遅延なし
- 反映先: [docs/ferris-wheel.md](../docs/ferris-wheel.md) BOM表（採用候補=各項目a）／ [Issue #12](https://github.com/aieo-product/stackchanEventBooth/issues/12)

## 候補一覧（a=採用候補・b=代替）

| # | 商品名 | 価格 | URL | 評価 | 備考 |
|---|---|--:|---|---|---|
| 1a | BRINGSMART JGY-370 12V 3rpm ウォームギアモーター | ¥2,429 | [dp/B01HGCSBDM](https://www.amazon.co.jp/dp/B01HGCSBDM) | 4.2★(81) | セルフロック。低速要件に適合 |
| 1b | JGY-370 12V 6rpm 版 | ¥2,429 | [dp/B08MSYS1SD](https://www.amazon.co.jp/dp/B08MSYS1SD) | 4.1★(15) | トルク大きめ |
| 2a | Broadwatch ACアダプター 12V 2A 5.5×2.1mm | ¥1,380 | [dp/B00AJDAPM6](https://www.amazon.co.jp/dp/B00AJDAPM6) | 3.9★(229) | ケーブル約110cm |
| 2b | Kaito Denshi 12V 2A 24W | ¥1,890 | [dp/B0CMXLM5WL](https://www.amazon.co.jp/dp/B0CMXLM5WL) | 4.3★(10) | PSE適合 |
| 3a | beyourchoi PWMコントローラ DC1.8-15V 2A 6個 | ¥749 | [dp/B0CX55SRYM](https://www.amazon.co.jp/dp/B0CX55SRYM) | 4.2★(76) | 電圧範囲がジャスト |
| 3b | ZuoMei PWM 10A 400W | ¥750〜999 | [dp/B00IK6P8KI](https://www.amazon.co.jp/dp/B00IK6P8KI) | 3.9★(632) | 入力DC12-40V（12Vは下限） |
| 4a | LIANHATA ロッカースイッチ 2ピン 5個 | ¥575 | [dp/B0DG8R497X](https://www.amazon.co.jp/dp/B0DG8R497X) | 3.8★(69) | ラウンド型 |
| 4b | Youmile DC-099 DCジャック 5.5×2.1 10個 | ¥999 | [dp/B08SM3BY7L](https://www.amazon.co.jp/dp/B08SM3BY7L) | 3.9★(175) | 金属製・5A定格 |
| 5a | uxcell リニアシャフト 8×250mm 2本 | ¥1,180 | [dp/B08XYM78XJ](https://www.amazon.co.jp/dp/B08XYM78XJ) | 4.2★(50) | **Dカット無し**・焼入れで加工困難 |
| 5b | uxcell 304ステンレス丸棒 8×250mm 4本 | ¥2,107 | [dp/B0CF569NCG](https://www.amazon.co.jp/dp/B0CF569NCG) | 3.9★(29) | Dカット無し・切削しやすい |
| 6a | Saipor 6-8mm ビームカップリング 5個 | ¥999 | [dp/B07ZMYSYLH](https://www.amazon.co.jp/dp/B07ZMYSYLH) | 4.3★(21) | 高トルクで強度不足報告（本用途は低トルク） |
| 6b | Ohamtes 6-8mm カップリング 2個 | ¥1,272 | [dp/B09MC5C9KG](https://www.amazon.co.jp/dp/B09MC5C9KG) | 3.9★(14) | 外径19mm・L25mm |
| 7a | ALITOVE WS2812B 5m 60LED/m IP20 | ¥3,369 | [dp/B01N7BX973](https://www.amazon.co.jp/dp/B01N7BX973) | 4.6★(10) | 指定仕様に最も近い |
| 7b | BTF-LIGHTING WS2812B 5m 60LED/m IP65 | ¥4,099 | [dp/B08THGBTZN](https://www.amazon.co.jp/dp/B08THGBTZN) | 4.3★(182) | IP30はl m/144LEDのみ在庫 |
| 8a | 304ステンレス丸棒 Φ3×300mm 10本 | ¥1,050 | [dp/B0FCZP736S](https://www.amazon.co.jp/dp/B0FCZP736S) | 4.4★(19) | ベストセラー1位 |
| 8b-1 | uxcell Eクリップ 3mm 50枚 | ¥660 | [dp/B0G2SFKXW1](https://www.amazon.co.jp/dp/B0G2SFKXW1) | 0件 | 3mm専用 |
| 8b-2 | E型スナップリング120個 M1.5-M10 | ¥589 | [dp/B08HN2CCDZ](https://www.amazon.co.jp/dp/B08HN2CCDZ) | 3.9★(294) | 10サイズ入りで汎用 |

## 集計・所見

- **モーター系5点（1a+2a+3a+4a+4b+6a）= ¥7,131** → 切替閾値¥6,000を超過（最安構成でも¥6,700台）→ **手回し版に決定（2026-07-15）**
- 電動版合計 約¥13,300 ／ 手回し版合計 約¥6,200（5a+7a+8a+8b-2）
- Φ8mm**Dカット付きは在庫なし** → ハブ固定はM3イモネジ×2に設計変更（docs反映済み）
- LEDはIP30×2mの完全一致なし → ALITOVE IP20×5mで代替
- フレキシブルカプラは高トルクで強度不足の報告 → 本用途（低速・低トルク）は許容、必要ならリジッド型へ

## 秋葉原実店舗の在庫調査（秋月電子通商・千石電商、2026-07-15）

オフィス（神田）から店頭購入できる前提で、手回し版に必要な3点＋予備1点を両店の通販サイトで調査（閲覧のみ）。

| パーツ | 秋月電子通商 | 千石電商 |
|---|---|---|
| アドレサブルLEDテープ（60LED/m・2m） | ✅ **SK6812テープLED 1m/60LED ¥1,940**（[112982](https://akizukidenshi.com/catalog/g/g112982/)・WS2812B互換・通販在庫410本・2本で¥3,880）。30LED/m版（¥1,200・[130333](https://akizukidenshi.com/catalog/g/g130333/)）は密度不足 | ❌ アドレサブル品の取扱なし（JTT製の単色/一括制御USBテープライトのみ） |
| Φ8mmシャフト（金属） | ❌ 取扱なし（「シャフト」はモーターハブ等のみ） | ❌ 金属8mmなし。[アクリル透明丸棒 8φ×30cm ¥330](https://www.sengoku.co.jp/mod/sgk_cart/detail.php?code=6B4T-TDEN)（本店2階・在庫拠点秋葉原）のみ — 樹脂のため軸用途は強度要検証 |
| Φ3mm丸棒（金属）＋Eリング | ❌ 丸棒なし | 丸棒❌／✅ **EリングEW3 ¥25/個・100個¥580**（[EEHD-6GJZ](https://www.sengoku.co.jp/mod/sgk_cart/detail.php?code=EEHD-6GJZ)・本店2階） |
| 608ベアリング（予備） | ❌ | ✅ **ミネベア608ZZ ¥221/個**（[EEHD-4JWX](https://www.sengoku.co.jp/mod/sgk_cart/detail.php?code=EEHD-4JWX)・本店3階）— 7/13注文分の遅延時バックアップ |

### 所見
- **金属丸棒2種（8mm/3mm）は秋葉原の両店で入手不可** → Amazonで発注が確実。未確認の候補: 西川電子部品・東急ハンズ秋葉原・模型店（一般知識・現地確認要）
- LEDは秋月SK6812（店頭・当日）とAmazon ALITOVE 5m（明日着・¥3,369）の二択。必要量ちょうどで買うなら秋月、単価で選ぶならAmazon
- 千石・秋月は徒歩圏内で1回の外出で回れる。店頭在庫数はサイト非公開のため来店前の電話確認推奨
- 千石の店舗情報: Eリング=本店2階／608ZZ=本店3階／アクリル丸棒=本店2階（いずれも在庫拠点: 秋葉原）
