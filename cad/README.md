# CAD (OpenSCAD) — 卓上観覧車 & 撮影ブース

Issue #16 の3Dプリントパーツをパラメトリックに定義したOpenSCADソースです。
寸法・公差は [`params.scad`](params.scad) に一元化しています。設計根拠は
[`docs/ferris-wheel.md`](../docs/ferris-wheel.md) / [`docs/photobooth.md`](../docs/photobooth.md)。

## 生成方法

```bash
cd cad
make all      # 全STLを ../print/files/{ferris,booth}/ に生成
make check    # 生成 + バウンディングボックス寸法チェック (python3, 標準ライブラリのみ)
make clean    # 生成STLを削除
```

STL は `print/files/` 配下（`.gitignore` 管理外）に出力されます。**ソースが正**で、
STL はコミットしません。`openscad` CLI が必要です（`/opt/homebrew/bin/openscad`, v2026 で検証）。

## パラメータ変更 → 再生成

1. [`params.scad`](params.scad) の該当変数を編集（例: 印刷公差 `tol`、ダブテール
   クリアランス `tol_dovetail`、LED溝幅 `led_groove_w` など）。
2. `make clean && make all` で全パーツを再生成（`make check` で寸法再確認）。
3. テスト印刷（7/15〜）のはめ合いフィードバックは、まず `tol` / `tol_dovetail` /
   `tol_snap` の3変数で調整します（初版は安全側=緩めに設定済み）。

`tower.scad`（`part="upper"|"lower"`）と `wall_panel.scad`
（`variant="blackboard"|"window"|"board"`）は `-D` で切り替え、Makefile が各STLに展開します。

## パーツ一覧

| STL | ソース | 実測BBox (X×Y×Z mm) | 主要寸法 / 備考 |
|---|---|---|---|
| ferris/rim-segment | `ferris/rim_segment.scad` | 158×150×20 | 1/4円弧・Ø300・スポーク2本一体・外周LED溝10.5×2.0・端部ダブテール＋接線M3ボス（X の +8 はテノン） |
| ferris/diffuser | `ferris/diffuser.scad` | 152×152×23.2 | リム外周に被せるコの字スナップカバー・1/4円弧（半透明フィラメント推奨） |
| ferris/hub | `ferris/hub.scad` | 80×80×25 | Ø80×25・シャフト穴Ø8.2貫通・スポークボルト穴8・M3イモネジ用インサート横穴2 |
| ferris/gondola | `ferris/gondola.scad` | 79×79×101 | 内寸75×75×85・前面ガード40mm＋上部開口・底リブ5本・上開きU溝フック（Ø3.4/サポート不要） |
| ferris/tower-upper | `ferris/tower.scad -D part="upper"` | 86.6×30×145 | A型上半・608ポケットØ22.2×7.2＋抜け止めリップ・スプライスソケット |
| ferris/tower-lower | `ferris/tower.scad -D part="lower"` | 122×30×168 | A型下半・ベース差込タブ＋M3蝶ネジ穴・角ダボ(male)＋M3×2 |
| ferris/base | `ferris/base.scad` | 250×183×45 | 250×175×15・長辺に自己相補ダブテール（同一部品を180°回転で連結）・支柱スロット2・M3蝶ネジ・クランク軸受Ø8.5 |
| ferris/crank | `ferris/crank.scad` | 152.5×25.5×44 | クランク本体(Ø8.2＋M3イモネジ)＋自由回転グリップØ20×40(Eリング溝)＋フリクションダンパーC形クリップ（1プレート） |
| booth/floor-tile | `booth/floor_tile.scad` | 158×158×3 | 150×150×t3・木目板目0.6mm浮彫・裏ダブテール(+X/+Yオス, -X/-Yメス)（XY の +8 はテノン） |
| booth/wall-blackboard | `wall_panel.scad -D variant="blackboard"` | 150×137×5 | 150×125×t5・中央浅凹(緑紙貼付)・下端スタンドタブ（Y の +12 はタブ） |
| booth/wall-window | `wall_panel.scad -D variant="window"` | 150×137×5 | 2×2窓開口＋裏面レベット（空画像紙用） |
| booth/wall-board | `wall_panel.scad -D variant="board"` | 150×137×6.5 | コルク風枠＋ピン穴グリッド5×5 |
| booth/stand-clips | `booth/stand_clips.scad` | 100×81.6×80 | 壁差込チャンネルスタンド(100×80×t8)＋連結クリップ＋定位置マーカーØ24（1プレート） |

BBox はすべて 250mm 以内（X2Dビルドプレート内）。全パーツ manifold（`make check` および
独立エッジ検査で確認済み）。

## 設計上の判断（設計書からの補足）

- **リム/床タイルの BBox が設計値+8mm**: 連結用ダブテールのテノンが張り出すため。本体寸法は
  リム外周半径150（Y軸）、タイル本体150×150。`check_dims.py` はテノンのない軸/厚みで検証。
- **吊りフックは水平穴でなく上開きU溝**: サポートレスで印刷でき、Ø3軸を落とし込む「フック式」
  （現地1分・工具不要）に合致（受入条件4）。
- **支柱スプライス**: 「重なり代」は角ダボ(8mm角)＋M3×2の勘合で確保し、分割位置 z=135 で
  両半とも 170mm 以下（下168 / 上145）に収めた。
- **ベース連結**: 2枚を別部品にせず、連結辺に自己相補ダブテール（テノン@+50 / モルタイス@-50）を
  配置。同一STLを2枚印刷し、片方を連結辺中点まわりに180°回転すると勘合する。
- **クランク軸受(ベース)**: 主軸クランクは支柱上端の608ベアリング（軸高280mm）に直結する運用が
  基本。ベースの軸受ブラケット(Ø8.5)は軸端のガイド/低位ジャックシャフト用オプション。
- **ディフューザー**: `rotate_extrude` 由来で OpenSCAD 上は PolySet 表示だが、閉じた多面体
  （エッジ検査で watertight 確認済み）。
