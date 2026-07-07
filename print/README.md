# print/ — 印刷リストと自動印刷の仕組み

スタックチャン ブース用アクセサリーを、**リスト（マニフェスト）経由で Bambu Lab X2D に
自動で印刷**するための一式です。

```
print/
├── print-list.yaml   ← 「何を・どのファイルで・何色・何個」印刷するかの唯一の定義
├── auto_print.py     ← リストを読み、X2D へ 1 ジョブずつ送って印刷（逐次・立ち会い前提）
├── download.py       ← print/files/ に不足しているモデルの入手先URLを表示
├── requirements.txt  ← 依存（PyYAML, bambulabs_api）
└── files/            ← 実モデルファイル(.gcode.3mf 等)。★Git管理外（.gitignore）
```

## なぜ実ファイルは Git に入れないのか（ライセンス）

MakerWorld のモデルは作者の権利物で、**一部ライセンスは再配布不可**です
（「MakerWorld標準/限定ライセンス」＝個人・非商用の印刷は可だがデータ再配布は不可）。
そのため**バイナリ（.3mf/.stl）は `print/files/` に置きつつ Git 管理外**にし、
リポジトリには**印刷の定義とスクリプトだけ**を保存します。ファイルはリスト経由で
各自ローカルに集める運用です（CC0/BY/BY-SA/BY-NC-SA など再配布可のものは、
`print-list.yaml` の `redistribute: true` を目印に、希望あれば同梱可）。

## セットアップ

### 1. 依存インストール（各自のPython環境で）
```bash
cd print
python3 -m venv .venv && source .venv/bin/activate   # 任意
pip install -r requirements.txt
```

### 2. プリンター接続情報を Keychain に登録（値はファイルに書かない）
X2D を **LAN モード**にし（Bambu Studio > プリンター設定 > 「LAN Only Mode / 開発者モード」）、
プリンター画面に表示される **IP / アクセスコード / シリアル**を登録します。
```bash
security add-generic-password -s BAMBU_PRINTER_IP  -a BAMBU_PRINTER_IP  -w "192.168.x.x" -U
security add-generic-password -s BAMBU_ACCESS_CODE -a BAMBU_ACCESS_CODE -w "XXXXXXXX"     -U
security add-generic-password -s BAMBU_SERIAL      -a BAMBU_SERIAL      -w "01P00A..."    -U
# もしくは: akc set BAMBU_ACCESS_CODE
```
スクリプトは**サービス名のみ**で取得します（`-a` は付けない・[CLAUDE.md 準拠](../../CLAUDE.md)）。

### 3. モデルファイルを用意
```bash
python3 download.py            # 不足ファイルと入手先URLを一覧
python3 download.py --open     # 入手先をブラウザで開く
```
MakerWorld の各モデルで **Print Profile（事前スライス済み `.gcode.3mf`）** を
ダウンロードし、`print-list.yaml` の `file` 名（例 `files/hat-generator.gcode.3mf`）で
`print/files/` に保存します。Bambu Studio の「MakerWorldで開く→印刷」でも取得できます。

## 使い方

```bash
# 何を刷るか確認（既定は dry-run。プリンターには送らない）
python3 auto_print.py

# 特定の1種だけ
python3 auto_print.py --only hat-generator

# 実際に印刷（★プリンターに立ち会うこと）
python3 auto_print.py --go
python3 auto_print.py --go --yes    # 開始確認プロンプトを省略
```

`auto_print.py --go` は `print-list.yaml` の **`enabled: true`** のジョブを上から順に、
`copies` の数だけ印刷します。1 ジョブ完了 →（`wait_between_sec` 待機）→ 次、の逐次実行です。

## 印刷リスト（print-list.yaml）の書き方

```yaml
jobs:
  - key: hat-generator            # 一意キー（--only で指定）
    name: 帽子ジェネレータ
    makerworld_id: "2772131"
    url: https://makerworld.com/ja/models/2772131
    license: BY                   # ライセンス（下記凡例）
    redistribute: true            # リポジトリ同梱可否
    file: files/hat-generator.gcode.3mf   # print/files/ 内のファイル
    color: パステルピンク          # 色メモ（人間用）
    ams_mapping: [0]              # AMS スロット割当（プロファイルの色→実スロット）
    copies: 2                     # 印刷個数
    enabled: true                 # false でスキップ
```

ライセンス凡例: `BY`=クレジットのみ / `BY-SA`=改変配布は継承 /
`BY-NC`・`BY-NC-SA`=非商用のみ（無料展示OK・物販不可）/ `CC0`=フリー /
`MW-STD`(標準)・`MW-EX`(限定)=個人非商用の印刷可・再配布不可。

## ⚠️ 安全上の注意

- **3Dプリンターの無人運転は禁止**。火災・造形失敗のリスクがあるため、
  `--go` は必ず立ち会って実行してください。本ツールは意図的に逐次実行です。
- 実行前に **AMS のフィラメント（色・残量）**と**ビルドプレートの空き**を確認。
- 透明シェル・猫耳（@mongonta555 / @murasametech）は MakerWorld 外のため、
  **作者の許諾＋データ入手後**に `files/` へ置き、`enabled: true` にしてください。

## 関連

- 造形とライセンスの調査: [`../research/model-data.md`](../research/model-data.md)
- 着せ替えアクセサリー一覧（公開サイト）: [/accessories](https://stackchan-event-booth.pages.dev/accessories)
- フィラメント必要量・購入: [/printing](https://stackchan-event-booth.pages.dev/printing)
