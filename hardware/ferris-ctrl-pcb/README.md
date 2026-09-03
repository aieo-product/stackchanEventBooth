# ferris-ctrl-pcb — 観覧車 v7 制御基板（AtomS3R キャリア）

EasyEDA（Std/Pro どちらでも可）で作図し JLCPCB に発注する。設計の全体は
[docs/ferris-v7-auto.md](../../docs/ferris-v7-auto.md) を正とする。

## 方針

- **MCU は AtomS3R をそのまま挿す**（既存 LED ファームの資産・書込み環境・画面/ボタン付き）。
  基板は「電源＋モータードライバ＋コネクタ」だけのキャリア → 部品点数最小・JLC 組立の失敗リスク最小。
- 基板外形 **80 × 60 mm・M3 穴 4 か所（角から 4 mm）・Atom 中心 (20, 30)・コネクタは +Y 辺** に固定。
  この値は `cad/params.scad` の `pcb_*` と一致させる（筐体を先に印刷するため）。
- 2 層・1.6 mm・緑レジスト・HASL 可。PCBA は **Economic assembly（片面 SMT）** で、THT コネクタは手はんだ。

## ブロック図

```
12V DC jack ─ F1(2A poly) ─ D1(SS54 逆接) ─┬─ U1 DRV8871 ── J2 モーター (JGY-370)
                                          │      └ R_ILIM 51k (I_TRIP≈1.25A)
                        J6 非常停止(常閉) ─┘ ← モーター12V を物理遮断（U1 の VM 手前に直列）
                                          └─ U2 LM2596S-5.0 ─┬─ Atom 5V ピン
                                                             ├─ J7/J8 LED 5V（C3 1000uF）
                                                             └─ LED1 電源表示
AtomS3R 底面ヘッダ ─ G5 IN1 / G6 IN2 → U1
                  ─ G7 ADC ← J4 ポテンショ(3V3 ラダー)
                  ─ G8 ← J3 ホール（10k PU to 3V3）
                  ─ G38 ← J5 ボタン（10k PU）  G39 ← J6 検知（10k PU）
Atom Grove G1/G2 ─ U3/U4 74AHCT1G125（3V3→5V）─ R6/R7 1k ─ J7/J8 DATA
```

## ネットリスト（EasyEDA で結線するときのチェックリスト）

| ネット | 接続 |
|---|---|
| VIN_RAW | J1.center → F1 → D1.A |
| VIN | D1.K → C1(+) / U2.VIN / J6.1（非常停止スイッチ常閉側） |
| VM | J6.2（スイッチ戻り）→ U1.VM / C9 / C4 |
| MOTOR_OUT1/2 | U1.OUT1 → J2.1, U1.OUT2 → J2.2 |
| IN1 / IN2 | Atom G5 → U1.IN1、Atom G6 → U1.IN2 |
| ILIM | U1.ILIM → R1 51k → GND |
| 5V | U2.OUT → L1 → C2 → 5V（Atom 5V ピン・J7/J8・U3/U4 VCC・LED1） |
| U2 周辺 | U2.FB=5V、U2.ON/OFF=GND、D2 SS54 U2.OUT→GND（カソード OUT 側） |
| 3V3 | Atom 3V3 ピン（Atom 内蔵 LDO 出力）→ プルアップ R2-R5・J4.1 |
| POT | J4.2 → Atom G7、J4.3 → GND |
| HALL | J3: 1=5V, 2=GND, 3=OUT → R3 10k→3V3・Atom G8（A3144 等オープンコレクタ品を使う。5V 出力品なら分圧） |
| BTN | J5.1 → Atom G38（R4 10k→3V3）、J5.2 → GND |
| ESTOP_SENSE | J6.3 → Atom G39（R5 10k→3V3）、J6.4 → GND（非常停止の第 2 接点・押下で GND） |
| LED_F / LED_B | Atom Grove G2 → U3.A、U3.Y → R6 1k → J7.3 ／ Atom Grove G1 → U4.A、U4.Y → R7 1k → J8.3 |
| GND | 全 GND を 1 面ベタ。モーター GND と LED GND は U2 の入力側 GND で一点接続気味に |

## レイアウト指針

- DRV8871 の EP（サーマルパッド）は GND ベタに 6 個以上のビアで落とす。VM デカップ 10uF+0.1uF は 5 mm 以内。
- モーター配線（OUT1/2・VM・GND）は 1 mm 幅以上、LED 5V は 1.5 mm 幅以上（最大 3A 想定）。
- Atom ソケットは基板の左側 (20,30) 中心。**画面が上向き**になるように（筐体 lid の窓位置）。
- コネクタは全て +Y 辺に一列（筐体 tray の切欠き 60 mm 幅に収める）。
- 非常停止・ボタン・ポテンショは**筐体の蓋の操作部ベイ**（基板の +X 隣・幅 44）にパネル取付けし XH ケーブルで基板へ。
  基板の真上には何も垂れないので**基板側の部品高さ制約なし**（Atom 13mm が最高部品。蓋窓の 5mm 下）。

## 発注

1. EasyEDA → PCB 完成 → `Generate Fabrication File` で Gerber、`Export BOM`（LCSC 番号付き）、`Export Pick and Place`。
2. JLCPCB: 2 層 / 100×100 以下 / 5 枚 / 緑 / HASL(lead-free) / PCBA Economic / 片面 / 5 枚（または 2 枚）。
3. 配送は **DHL Express**（日本 3〜4 営業日）。9/8（月）までに発注すれば 9/16 前後着。
4. `bom-jlcpcb.csv` の `?` 付き C 番号は発注時に JLC Parts で検索して確定（Basic 優先＝手数料ゼロ）。

## PCB が間に合わない場合のプラン B

同じ回路をモジュールで組む: DRV8871 ブレイクアウト（Adafruit #3190 相当・Amazon 在庫）＋ 5V バックモジュール（LM2596 基板）＋ 74AHCT125 DIP または直結（3.3V 直駆動は 7/24 実績あり）。ユニバーサル基板に載せて同じ筐体に入れる。
