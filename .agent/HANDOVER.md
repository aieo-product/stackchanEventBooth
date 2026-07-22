# HANDOVER — stackchanEventBooth

> 最終更新: 2026-07-21 (JST) / 更新者セッション: 観覧車CAD反復修正（v3→v5）・3Dビューア・K151実寸反映・ミニ観覧車・ゲストスライドissue
> **イベントは7/24(金)13:00-17:00 — 残り3日。クリティカルパス＝回転系テスト合格→リム量産**

## ゴール
- AI Dev Day 2026(7/24・大手町プレイス1Fコミュニティショーケース)のスタックチャンブース。目玉=🎡手回し観覧車(実機搭乗)＋📸学校ジオラマ撮影ブース＋15分LT(A-Utaさんメイン)

## 今いちばん大事な状態 🔥
- **ユーザーがテストプレート印刷中/直後**: ゴンドラv5＋rig-bearing＋fittest-hubcore＋fittest-crankboss（約3h・ゴンドラは青推奨と伝達済み）。8mm鉄シャフトは着荷済み
- **合格判定**: ①鉄シャフトが hubcore/crankboss/rig-bearing にスムーズに通る ②K151を真上から載せてポケット着座 ③印刷軸を円盤外周穴→ゴンドラタワー穴→キャップと通して吊り下げ ④円盤を回してゴンドラ水平維持 → **全部OKならリム量産GO**（rim×8≈18h＋支柱・ベース・ハブ・クランク・ディフューザー）
- 渋い/ゆるいが出たら cad/params.scad の該当径を±0.2して `make -C cad all` → 対象STLだけ再印刷

## 観覧車の設計現在地（v5・52eed7a まで）
- **駆動**: 8mm鉄シャフト(L250カット不要・着荷済) をハブΦ8.2にイモネジ固定、支柱上端の**608ベアリング(7/13注文・7/20-22着予定)**Φ22.2ポケットで受け、端にクランク（イモネジ）。手回し
- **ゴンドラ吊り**: Φ6**印刷軸**(頭付き・先端4mmテーパー)＋押込キャップ。リム穴Φ6.8(r140・45°位置×4)
- **ゴンドラv6(7/22)**: 88×74×107.4・pivot100(装飾ロボ用に頭上33mm)・支柱300mm化で地上クリアランス38mm維持(分割上165/下168)。ロボ+X向き・閉じた丸穴Φ6.7・2段ポケットはv5同様。**7/22テストでv5合格→v6は量産時に反映**(リグ再テストは任意・rig_bush_z160要)
- **搭乗運用**: キャップ外し→軸を抜く→ゴンドラをリム間(90mm)から出す→真上からK151載せ替え→軸を通し直す
- **教訓（再発防止・重要）**:
  - 浮遊形状（非接地）→スパゲッティ化。check_dims.pyに接地チェック恒久化済み
  - 「着座の静的干渉」だけでなく**搭乗動線(loading path)の検証必須**（v2ブリッジは全経路を塞いでいた）
  - タワーは軸方向(±Y)にしか置けない→**ロボは+X(開放面)向き**が正（v4で90°修正）
  - J溝/フック→**閉じた丸穴が確実**（ユーザー方針: 確実性・耐久性優先。着脱は軸を抜けばよい）
  - 印刷公差: 穴は呼び径+0.7〜1.0（6.8/6.7/9.0/8.2）＋軸先端テーパー。ポケット+0.5/側
- **fit_check.scad**: 公式K151のSTL(cad/vendor/k151/・MIT・10部品)を実寸合成して搭乗検証。接地面=足込み48×56フラット（Base.stl解析済・足はBase一体）

## リポジトリ構造（CAD）
- `cad/params.scad` = 全寸法・公差の唯一の正。`make -C cad all` / `check`(寸法+接地+250mm) / `viewer-models` / `fit-test` / `swing-test`
- `cad/ferris/`: rim_segment / diffuser / hub / gondola(v5) / tower(608ポケット) / base / crank / axle(D断面寝かせ) / k151 / fit_check / mate_check / fit_test_kit(rim・floor・bridge・hubcore・crankboss) / swing_test_rig(+bearing小片) / assembly(ビューア配置)
- `cad/booth/`: floor_tile / wall_panel3種 / stand_clips — **撮影ブース側は未印刷・未テスト**
- `cad/mini/adapter_gondola.scad`: ミニ観覧車（実測不要方針: 案A=ゲルテープ直付け優先）
- 出力先 `print/files/`(git外)。3Dビューア: `docs/public/viewer/`+`models/ferris/`(15パーツ+manifest)

## 進行中/未着手 📋
- **リム量産**（テスト合格待ち）→ 支柱・ベース・ハブ・クランク・ディフューザー(PETGクリア・要乾燥)
- **撮影ブース印刷が全く未着手**（床8・壁8・スタンド＝PLAウッド/白/黒、MakerWorld小物9点）— 7/22-23で押し込み要
- **LED**: 秋月SK6812×2・Atom Liteスケッチ未作成（FastLEDレインボー約30行）
- **ミニ観覧車(#19)**: 案A(ゲルテープ直付け)を試す→必要ならサドル式
- **ゲストスライド(#22)**: @livinoffwater さんの画像/PDF待ち（7/23期限）。届いたら lt.html の `<h1>Module-LLMの苦労話 🛠️</h1>` 章扉の**直前**に1枚挿入→デプロイ
- 100均買い出し（research/hyakkin-props-20260716.md・約¥3,300）／A-Utaさんスライド確認・許諾依頼送信（ユーザー領域）
- **📺フォトウォール実装済・当日運用のみ残**: /photowall/ にXの `#ｽﾀｯｸﾁｬﾝ写真館 #AIDevDay` 写真を1枚10秒スライドショー（デプロイ済・サンプル=/photowall/?data=posts.sample.json）。当日は表示PCで開いて`F`全画面＋Claudeが `scripts/photowall/README.md` の手順で更新（Claude in Chromeスクレイピング→merge_posts.py→デプロイ）。**7/21に実Xポストでリハーサル成功済**（Chrome拡張接続OK・抽出はDLP回避のためmedia ID形式）。不適切投稿は ban.json で除外

## Issues/PR
- #12/#13=クローズ / #16=PR#17済 / **#18=オープン（v5まで反映済・テスト結果で更新）** / **#19=実測不要方針へ変更済** / #22=素材待ち
- GitHubユーザー livinoffwater は存在せずassign不可→URLを本人へ直接共有してもらう約束

## 定型作業
- ビルド: `export PATH="$HOME/.nvm/versions/node/v24.14.1/bin:$PATH"` 必須（npmがデフォルトPATHにない）
- デプロイ: `cd docs && npm run build` → `export CLOUDFLARE_API_TOKEN=$(security find-generic-password -s CLOUDFLARE_API_TOKEN -w); export CLOUDFLARE_ACCOUNT_ID=$(security find-generic-password -s CLOUDFLARE_ACCOUNT_ID -w); npx wrangler@latest pages deploy .vitepress/dist --project-name=stackchan-event-booth --commit-dirty=true`（要 dangerouslyDisableSandbox。ユーザー指示の継続作業では自動デプロイの運用実績あり）
- スライサー展開: `open -a BambuStudio <stl...>`。テスト記録は `baseIdea/観覧車/testresult/`（動画はffmpegでフレーム抽出→解析が有効だった）
- git: main直コミット運用（大きめの変更は issue→branch→PR。dev-workflowスキル準拠・実装はサブエージェント委譲/親がレビュー）

## 参照
| 項目 | 値 |
|---|---|
| 本番 | https://stackchan-event-booth.pages.dev/ ／ 3Dビューア: /viewer/ ／ スライド: /slides/lt.html |
| 設計ページ | /ferris-wheel（BOM・組立手順・スケジュール表）・/photobooth・/space |
| 経費 | 約¥21,200+PLAウッド¥3,042計上済（expenses.md）。フィラメント在庫は十分（総需要≈3.5kg vs 手持ち6kg+7本） |
| 調査 | research/: makerworld-survey-20260713 / makerworld-props-20260715 / amazon-parts-20260715 / hyakkin-props-20260716 |
| K151実寸 | 全体54×70.5×61.5・187.2g / ベース(足込み接地面)48×56×11.1 / 構造STL=cad/vendor/k151(MIT) |

## 申し送り・注意点
- **markdown-it罠**: docsで `**…（…）**`+CJK隣接は生テキスト化→`<b>`使用。見出しアンカーの中黒「・」はslugifyで保持される（リンク側も「・」のまま書く）
- 未コミット: `baseIdea/観覧車/testresult/` の新規写真動画 — コミット可だが**個人情報入りスクショは除外**（.gitignoreに1件登録済み・過去に誤コミット1回の教訓。履歴に1件残存・ユーザー判断待ちのまま）
- 秘密情報はKeychainサービス名のみで取得（-a付けない）
- 印刷は立ち会い運用・無人禁止。PLAウッド=0.2mmノズル不可(0.4はOK)・PETG=要乾燥。テクスチャPEIプレート推奨
