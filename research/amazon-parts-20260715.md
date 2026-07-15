# 観覧車 追加発注パーツ Amazon実売調査（2026-07-15）

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

- **モーター系5点（1a+2a+3a+4a+4b+6a）= ¥7,131** → 切替閾値¥6,000を超過（最安構成でも¥6,700台）
- 電動版合計 約¥13,300 ／ 手回し版合計 約¥6,200（5a+7a+8a+8b-2）
- Φ8mm**Dカット付きは在庫なし** → ハブ固定はM3イモネジ×2に設計変更（docs反映済み）
- LEDはIP30×2mの完全一致なし → ALITOVE IP20×5mで代替
- フレキシブルカプラは高トルクで強度不足の報告 → 本用途（低速・低トルク）は許容、必要ならリジッド型へ
