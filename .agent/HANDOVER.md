# HANDOVER — stackchanEventBooth（セッション名: stackchanKanransya → 次は stackchanKanransyaV2）

> 最終更新: 2026-09-10 夕方 (JST)
> **展示は 9/23(水) 生成AIなんでも展示会。JLCPCB 注文は 9/10 にカート投入まで完了（支払いはユーザー操作）**

## ゴール
- 観覧車 v7: JGY-370 ウォームギアモーター直結（非逆駆動）＋ AtomS3R キャリア基板で自動回転。設計の正 = `docs/ferris-v7-auto.md`。

## 今いちばん大事な状態 🔥
1. **PCB は確定・発注中**（EasyEDA プロジェクト stackchan-ferris-ctrl-v7、Nets 25/25・DRC 0）。JLCPCB カート: PCB 5枚 $4.00 ＋ PCBA Economic 2枚 $35.75（THT 部品は実装対象外＝手はんだ、LED1 は C2286 赤に置換）、クーポン -$10。**支払い・配送（DHL 推奨）はユーザーが trade.jlcpcb.com で実施**。注文番号が分かったら本ファイルと `docs/ferris-v7-auto.md` に記録。
   - 配線が階段状なのは自作ルーターの仕様。電気的・製造的に問題なし（最小異ネット間隔 0.245mm）。
   - 製造ファイル: `hardware/ferris-ctrl-pcb/fab/`（Gerber/BOM/CPL 9/9 版。J9A/J9B は 9/10 に縦向き・列間 15.24mm に変更済みで JLC には EasyEDA からの one-click で最新版が転送されている）。
2. **LCSC カート**（take.otani、Cart_20260909020357、12 品目 $15.01）: 手はんだ用 XH ヘッダ/ハウジング/コンタクト/DC ジャック/メスヘッダ/A3144(TO-92S)/電解。checkout で "Ship with JLCPCB order" を選ぶ（ユーザー操作）。
3. **Amazon 発注（ユーザー）**: JGY-370 12V 3rpm、フレキシブルカップリング 6×8 D20L25、12V2A アダプタ(PSE)、非常停止 22mm、10kポット、押しボタン、M3×12、磁石。
4. **筐体は 2 案が並存**:
   - v7（外付け）: `tower-upper-motor` / `motor-bracket` / `motor-coupler` / `ctrl-box-tray`(131×67×42・操作部ベイ付) / `ctrl-box-lid` — STL 生成・寸法チェック済み、print-list.yaml に登録済み。**確実に動く案として先に印刷推奨**。
   - v7.1（埋め込み・9/10 着手、ユーザー指示で一旦停止）: `motor-pod`（支柱外面にボルト止めの密閉ポッド、モーター内蔵、下から蓋 `motor-pod-cover`）、`base-box`（モーター側土台ボックス 140×110×45: 上面に足スロット・Atom 窓・非常停止/ツマミ/ボタン、後壁ケーブル穴、底蓋 `base-box-lid` に基板スタンドオフ）、`base-box-plain`（反対側の同高リ​ザー）。STL 生成・寸法 OK。**未完了**: 組立モデルの確認は 1 回のみ（`assembly.scad PART="all-v71"` / `-D V71=true`）、Atom の画面が窓から 15mm 沈む（スタンドオフを上げるか箱を低く）、print-list 未登録、ビューア manifest は v7.1 の ID（base-lid, base-rear, motor-pod, pod-cover）に未対応、docs 未記載。v7 の PCB はどちらの案でもそのまま使える。

## 設計・作図の要点
- CAD: `cad/params.scad` が唯一の正（v7 セクション `motor_*/mb_*/pc_*/pcb_*/box_*`、v7.1 セクション `mpod_*/pod_*/bb_*`）。`make -C cad ferris` → `python3 cad/check_dims.py print/files/ferris`。
- AtomS3R ソケット: 公式 STL＋回路図から確定。列間 15.24mm、J9A(5ピン)=3V3/G5/G6/G7/G8、J9B(4ピン)=G39/G38/5V/GND。
- EasyEDA 作図はブラウザ JS API（`easyeda.extension.exec(api=>…)`, getSource/applySource type 5.x）で全自動。手順と落とし穴はメモリ `easyeda-scripting-via-browser` と `hardware/ferris-ctrl-pcb/README.md`。
- ファーム `firmware/ferris_ctrl/ferris_ctrl.ino`（AtomS3R コンパイル済・未実機）。
- 3D ビューア: `make -C cad viewer-models`（現在は V71=true で生成する設定に変えたが manifest は v7 のまま → 次セッションで manifest を v7.1 に合わせるか、Makefile の `-D 'V71=true'` を外して v7 に戻す）。

## 未確定・要実測
- Φ8 シャフト実長（設計 236mm・両端突出 20 前提 → `shaft_protrude`）。
- 7/24 で破損したパーツの有無。会場の AC100V。

## 定型作業
- docs ビルド/デプロイ: `export PATH="$HOME/.nvm/versions/node/v24.14.1/bin:$PATH"; cd docs && npm run build` → `akc run -- npx wrangler@latest pages deploy .vitepress/dist --project-name=stackchan-event-booth --commit-dirty=true`（CLOUDFLARE_* は keychain:// 参照）。
- markdown-it 罠: docs では `**…**`+CJK が崩れる → `<b>`。
