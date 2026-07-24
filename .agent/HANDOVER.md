# HANDOVER — stackchanEventBooth

> 最終更新: 2026-07-23 昼 (JST) / 更新セッション: フォトウォール・LED・LT会ジオラマ・v6量産・未着対応
> **イベントは明日 7/24(金)13:00-17:00。今日はオフィス残り〜10hで印刷を全消化する日**

## ゴール
- AI Dev Day 2026(大手町プレイス1F)のスタックチャンブース。🎡手回し観覧車(実機搭乗)＋🎤LT会ジオラマ撮影ブース＋📺フォトウォール＋15分LT

## 今いちばん大事な状態 🔥
- **印刷分担(7/23午後確定)**: 応援=リム4＋**支柱上下各1＋base-mini×2**(足元パッド化で1枚1h・ジャーナル廃止・/dl/wheel-kit-20260723.zip v3・明朝神田受渡)。自宅=リム残→hub×2→crank(v2鋼棒ハンドル・最後)。**ブースは床タイル全廃→スタンド自立のハリボテ壁構成に変更し、壁+スタンドをブース応援者へ委譲**(/dl/booth-walls-kit-20260723.zip)。**608ベアリング不使用で確定**(支柱Φ9穴が滑り軸受・千石リストの608は購入不要に)
- **昨夜のプレート(ゴンドラv6×4＋支柱4点＋crank＋Φ2.9かまぼこ)の完了確認がまだ会話に出ていない** — 失敗していたら最優先で再印刷
- **7/13 Amazon便は7/27着に遅延=イベントに間に合わない** → 全代替を千石で現物調達: `research/akiba-backup-20260722.md`(LED配線含む・約¥6,200・商品コード確認済み)。**買い出しは本日中必須**(千石19時まで)
- **Φ2.9セルフタップは7/23午後に実ネジで実証済み**(IMG_9508/9509: スポークパッド2枚をM3でハブ片に固定・しっかり噛合)。hub×2はこのまま本番使用可。これで観覧車の全接合部が検証完了

## 観覧車(v6・8b25bc4まで)
- 駆動: 8mm鉄シャフト→ハブΦ8.2(イモネジM3×2/Φ2.9直タップ)→支柱上端支柱Φ9穴の直軸受(608不使用で確定・Φ22.2ポケットは空きでOK)→クランク。ゴンドラ吊りΦ6印刷軸+キャップ(検証済)
- v6: pivot100(装飾ロボ頭上33mm)・支柱300mm・ゴンドラ88×74×107.4。v5でシャフト/着座/吊り/水平は実機合格済み
- **スポーク⇔ハブ**: パッドΦ3.4素通し+ハブΦ2.9タップ×8穴、M3×8。**リム継手**: ダブテール+M3×8(タップ側Φ2.9)。**白リム1号のみ旧Φ4.0→M4×8**
- リム応援印刷4個(配布URL: /dl/rim-segment-v20260722.stl・最新Φ2.9版と同一ハッシュ確認済み)

## LED(実装完了・配線材のみ未調達)
- AtomS3R + `firmware/led_rainbow/led_rainbow.ino` 書込済: SK6812 60LED×2本をGrove G2(前リム)/G1(後リム)、画面ボタンで50/25/100%/OFF、900mAキャップ
- 配線: Grove切断ケーブル→WAGO分岐→SMメスピグテール(千石CAB-14575)→テープ**Din側**(矢印始点)。7/22の不点灯はDOUT側接続+仮結線が原因
- 電源: ATOMICバッテリーベース(A151)×3差し替え・稼働1h以内なら容量OK。ベースUSB-Cにモバブ挿しで延命可

## LT会ジオラマ(7/23設計完了・印刷待ち)
- **7/23夕変更: 床なし・stand_clipsスタンド自立式(ハリボテ)**。旧床ソケット案は記録。スクリーンはL/R分割→半厚ダブテール連結で300mm幅、**紙288×117(A4横)が2枚跨ぎで上から差さる**。窓壁(左)・通常壁(右)・演台(ロゴ紙43×25)・ステージ台
- 印刷紙: **https://stackchan-event-booth.pages.dev/dl/lt-paper-a4.pdf**(GPT-image-2生成・公式ルックのスタックチャン+AIDevDayロゴ+スタックチャンLT会！バナー・トンボ付き)。等倍印刷→カット
- 3Dビューア: /viewer-booth/(組立確認用・分解ビュー可)

## 📺フォトウォール(運用のみ残)
- /photowall/ 1枚10秒スライドショー・60秒毎posts.json再取得・Fで全画面。7/21実Xポストでリハ成功済(Chrome拡張+Xログイン要)
- 更新手順=`scripts/photowall/README.md`(スクレイピングはmedia ID形式でDLP回避)。除外=ban.json

## スライド(7/23昼 再構成デプロイ済み・25枚)
- 実体: `docs/public/slides/lt.html`(生HTML・ビルドで dist へコピー)。本番 /slides/lt.html
- 7/23再構成: ①歴史に「5歳お誕生日会」「OpenAI公式CM登場(@OpenAIDevs Build Week動画)」追加 / ②を新フロー化: 2.5mmケーブル入手難(6月出荷分から同梱)→MeloTTS挫折→Kokoroチューニング→フィラー0ms→最新音声ルート全体図SVG→Gemma4司令官(9〜27秒→1〜2秒)→AIEO構想(aieo-robot.pages.dev)→Utaさんへバトン。素材元=baseIdea/stackChan/(未コミット・slides/assetsに変換済コピーをコミット)
- **#22ゲストスライド**: 7/24朝に素材(PlaiPin/Natalie Yeoさん PDF)到着→ユーザー指示で誕生日会スライド直後(6P)にフルスライド挿入・デプロイ済み(assets/plaipin-guest.jpg)
- **markdown-it罠**(docsのみ): `**…（…）**`+CJK隣接→`<b>`使用。lt.htmlは生HTMLなので無関係

## 定型作業
- ビルド: `export PATH="$HOME/.nvm/versions/node/v24.14.1/bin:$PATH"` → `cd docs && npm run build`
- デプロイ: `export CLOUDFLARE_API_TOKEN=$(security find-generic-password -s CLOUDFLARE_API_TOKEN -w); export CLOUDFLARE_ACCOUNT_ID=$(security find-generic-password -s CLOUDFLARE_ACCOUNT_ID -w); npx wrangler@latest pages deploy .vitepress/dist --project-name=stackchan-event-booth --commit-dirty=true`(要sandbox解除・自動デプロイ運用実績あり)
- CAD: `cad/params.scad`が唯一の正→`make -C cad all`/`check`/`viewer-models`/`viewer-models-booth`/`joint-check`。スライサー: `open -a BambuStudio <stl>`
- git: main直コミット。動画解析はffmpegフレーム抽出

## 参照
| 項目 | 値 |
|---|---|
| 本番 | https://stackchan-event-booth.pages.dev/ ｜ /viewer/ ｜ /viewer-booth/ ｜ /photowall/ ｜ /slides/lt.html |
| 買い物 | research/akiba-backup-20260722.md(千石・今日必須) / 100均=research/hyakkin-props-20260716.md |
| K151実寸 | 54×70.5×61.5・187.2g / ベース48×56×11.1 / cad/vendor/k151 |

## 申し送り
- 印刷は立ち会い運用。0.6ノズル化は却下済み(公差が0.4基準)。高速化はブース系のみ0.28/8%可・観覧車系は実績設定厳守
- ディフューザー(PETG)は正式断念。テスト記録=baseIdea/観覧車/testresult/(個人情報スクショはコミット除外)
- 秘密情報はKeychain参照のみ(-a付けない)
