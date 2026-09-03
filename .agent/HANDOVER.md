# HANDOVER — stackchanEventBooth

> 最終更新: 2026-09-03 (JST) / 更新セッション: 観覧車 v7（モーター自動回転・安全版）設計
> **次の展示は 9/23(水) 生成AIなんでも展示会。JLCPCB 発注期限は 9/8(月)**

## ゴール
- 7/24 の手回し観覧車(v6)で「実機が重く速く回すとゴンドラが振れてスタックチャンが飛ぶ／子どもが回せて危険」→ **ウォームギアモーター直結で回転を固定した自動回転版 v7** に再構築。設計の正 = `docs/ferris-v7-auto.md`

## 今いちばん大事な状態 🔥
- **設計凍結済み・印刷先行**: 新規 STL 5 種（tower-upper-motor / motor-bracket / motor-coupler / ctrl-box-tray / ctrl-box-lid、計約5h）を `make -C cad ferris` で生成、`check_dims.py` ALL OK。print-list.yaml に v7 ジョブ追加（enabled:true）
- **Amazon 発注待ち**（ユーザー作業）: JGY-370 12V 3rpm、フレキシブルカップリング 6×8 D20L25、12V2A アダプタ、非常停止 22mm、10kポット、押しボタン、A3144+磁石、M3×12
- **EasyEDA 基板（未着手）**: 仕様・ネットリスト・BOM = `hardware/ferris-ctrl-pcb/`。外形 80×60・M3 角4mm・Atom 中心(20,30)・コネクタ +Y 辺は `cad/params.scad pcb_*` と同期必須（筐体を先に印刷するため）。DRV8871 は JLC C75864 確認済み、他の C 番号は `?` 付き＝発注時に確定
- **ファーム**: `firmware/ferris_ctrl/ferris_ctrl.ino` AtomS3R でコンパイル OK（未実機）。G5/G6=PWM, G7=ポット, G8=ホール, G38=ボタン, G39=非常停止検知, Grove G1/G2=LED（従来）
- **要実測**: Φ8 シャフト実長（設計 236・両端突出 20 想定 → `shaft_protrude`）、AtomS3R 底面ヘッダのピッチ、7/24 破損パーツ有無、会場 AC 電源

## 観覧車 v7 機構の要点
- モーターは前支柱（旧クランク側）外面に同軸。`motor_standoff`=47 は params で自動算出。ブラケットは下面開放の箱型（カップリングを覆う）。支柱固定は `tower-upper-motor` の Φ2.9 パイロット×4 に M3×12。フランジ→ギアボックスは M3×8（手持ち）
- ゴンドラは自由振子のまま（3rpm なら振れない）。水平保持ギアは付録に記録（9/23 後の拡張候補）
- 3D ビューア: `assembly.scad PART="all-v7"`、viewer-models に motor-bracket/coupling/motor 追加・crank 削除済み

## 定型作業
- ビルド: `export PATH="$HOME/.nvm/versions/node/v24.14.1/bin:$PATH"` → `cd docs && npm run build`
- デプロイ: CLOUDFLARE_API_TOKEN / CLOUDFLARE_ACCOUNT_ID を Keychain から（`-a` 付けない）→ `npx wrangler@latest pages deploy .vitepress/dist --project-name=stackchan-event-booth --commit-dirty=true`
- CAD: `cad/params.scad` が唯一の正 → `make -C cad ferris` / `check` / `viewer-models`
- **markdown-it 罠**: docs では `**…（…）**`+CJK 隣接が崩れる → `<b>` を使う（v7 ページは全て `<b>` 化済み）

## 申し送り（v6 から継続）
- 印刷は立ち会い運用。観覧車系は実績設定（0.4/0.2mm/15%）厳守
- 秘密情報は Keychain 参照のみ。テスト記録 = baseIdea/観覧車/testresult/（コミット除外）
