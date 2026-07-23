# 🎡 スタックチャン観覧車（手回し回転・虹色LED）

スタックチャン（実機）が乗った観覧車を**来場者がクランクで回し**、リムが**虹色に光る**卓上観覧車を3Dプリントで製作します。撮影ブース（学校ジオラマ）と並べて、「スタックチャンが現実世界で生活してる」世界観の目玉展示にします。

::: info 2026-07-15 決定: 手回し版を採用
Amazon実売調査でモーター系5点が¥7,131（閾値¥6,000超）だったため、**電動をやめ手回しクランク版に決定**。追加発注は3点・約¥6,200に半減し、「来場者が回す」参加型の体験になります。電動版の検討記録は[比較表](#⚖️-電動-vs-手回し-モーター価格で選択)に残しています。
:::

::: tip このページの目的
1. **観覧車の寸法・分割プリント・組立方式**を確定する（設計）
2. **電装パーツ（モーター・LED・電源）のBOM**と**フィラメント必要量**を出して発注できる状態にする
3. X2D 1台・立ち会い運用で **7/23までに印刷が終わるスケジュール** を確定する
:::

## 🕹️ 組立シミュレーター（3Dビューア）

<a href="/viewer/" target="_blank" style="display:inline-block;background:#4da3ff;color:#08101d;font-weight:700;padding:10px 18px;border-radius:10px;text-decoration:none;">▶ ブラウザで3D組立シミュレーターを開く</a>

実際の印刷用CADと同一データを組立位置に配置したインタラクティブビューアです。**パーツごとの表示ON/OFF・透明度・分解ビュー・透視モード（内部構造）**で、どのパーツがどこに付くかを確認できます（パーツ名クリックで単独表示）。

## 完成予想図

<div style="display:flex;justify-content:center;margin:16px 0;">
  <img src="/img/ferris/concept-render.jpg" alt="スタックチャン観覧車の完成予想CG（虹色LEDリム・パステルゴンドラにスタックチャンが搭乗）" style="max-width:680px;width:100%;border-radius:12px;" />
</div>

> AI生成の完成イメージ（2026-07-15・**手回しクランク版**）。実設計はゴンドラ**4基**・リムØ300・接地350×250（下記仕様）。雰囲気・配色（白リム＋半透明ディフューザー＋パステルゴンドラ＋グレー支柱＋クランクハンドル）の共有用。

## 着想元

居酒屋で実際に見かけた**木製ドリンク観覧車**（回転する吊りトレイにグラスを載せる什器）。M5Stackデバイスを載せると「スタックチャンが観覧車に乗っている」画になることを確認済みで、これを電動・LED付きの3Dプリント版として再構成します。

<div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(280px,1fr));gap:12px;margin:16px 0;">
  <img src="/img/ferris/reference-stackchan.jpg" alt="ドリンク観覧車に乗ったM5Stackデバイス（着想元）" style="width:100%;border-radius:10px;" />
  <img src="/img/ferris/reference-wheel.jpg" alt="木製ドリンク観覧車の構造（ボルト接合・吊りトレイ）" style="width:100%;border-radius:10px;" />
</div>

> 撮影: 本企画メンバー。構造面でも「多角形プレート2枚＋ボルト接合＋自由回転の吊りトレイ」という本設計と同型で、**ゴンドラは深いバケットではなく吊りトレイ＋前面ガード**でも成立することの実物証明になっている。

## 全体仕様

| 項目 | 仕様 | 備考 |
|---|---|---|
| リム直径 | **Ø300mm** | 卓上でテーブル中央ゾーン（W450）に収まる |
| 全高 | 約450mm | 軸高さ約280mm＋リム上端 |
| 接地サイズ | 約350×250mm | ベースプレート（2分割） |
| ゴンドラ | **4基**（内寸 75×75×85mm） | スタックチャン実機（約54×54×65mm・約150g）が1体ずつ搭乗。自由回転（スイング）式 |
| 回転 | **手回しクランク**（来場者が回す参加型） | ゆっくり回す運用（スタッフ誘導）。1周目安5〜10秒 |
| 駆動 | クランクハンドル直結（3Dプリント製・M3イモネジでシャフト固定） | フリクションダンパー（印刷パーツ・任意）で回しすぎ/惰性回転を抑制 |
| LED | WS2812B（アドレサブル） | リムに沿って虹色レインボーアニメーション |
| 本体重量 | 印刷部品 約1.1kg ＋ 搭乗実機 最大600g | |

### 搭乗対象と安全設計

- ゴンドラはスタックチャン実機（M5Stack Core系）1体分。**底面すべり止め＋前面ガード**付きで、走行サーボが動いても落下しない深さ（85mm）を確保。
- クランク直結で動力源がなく、**手を離せば止まる**。フリクションダンパー（印刷パーツ）で惰性回転・急回転を抑制し、回す速さはスタッフが声かけで誘導。
- ゴンドラと支柱のクリアランスは**15mm以上**を確保し、体験時はスタッフが常駐。

## 構造・分割プリント設計

X2Dのビルドプレートに収まるよう、**全パーツを最大250mm以下**に分割します。接合はダブテール＋M3ネジ（<b>Φ2.9下穴への直接セルフタップ</b>・7/22にインサート未着対応で全穴変更済み #18）で、**分解・再組立可能**（搬入出は分解状態、現地組立5〜10分）。

```
        ┌─ リム（Ø300・前後2枚）… 1/4円弧×4 ×2枚 = 8ピース
        │   └ スポーク一体成形。外周に半透明LEDディフューザー溝
        ├─ ハブ×2 … 8mmシャフトにM3イモネジ×2で固定
        ├─ ゴンドラ×4 … Φ6 3Dプリント軸で前後リム間に吊り下げ
        ├─ 支柱（A型）×2 … 上下2分割（H170×2）。上端に608ZZベアリング
        ├─ ベース … 2分割（175×250×2）。クランク軸受付き
        └─ 駆動 … クランクハンドル → 8mmシャフト →ハブ→ リム回転
```

| パーツ | 個数 | 1個のサイズ | 単重(g) | 印刷時間/個 | 推奨色 |
|---|--:|---|--:|--:|---|
| リム1/4円弧（スポーク一体） | 8 | 約230×95×20 | 50 | 2.2h | アイボリーホワイト |
| LEDディフューザー（円弧カバー） | 8 | 約230×20×12 | 12 | 0.6h | **PETG半透明クリア**（無色・LED発色優先／7/17購入） |
| ハブ（シャフトフランジ） | 2 | Ø80×25 | 30 | 1.5h | アッシュグレー |
| ゴンドラ | 4 | 85×85×110 | 40 | 1.8h | パステル各色（ピンク/黄/青/白・手持ち。※グラディエント綿菓子の雲は売切のため変更） |
| 支柱（上下分割） | 4 | 約170×120×30 | 55 | 2.2h | アッシュグレー |
| ベースプレート | 2 | 250×175×15 | 90 | 3.0h | アッシュグレー |
| モーターマウント・小物類 | 一式 | — | 60 | 2.5h | アッシュグレー |
| **合計** | | | **約1,176g** | **約50h** | |

> 失敗・試作マージン+25%で **実質 約1.47kg**。印刷時間はPLA 0.2mm・インフィル15%の概算（スライス後に更新）。

### 接合方式（現地組立対応）

| 接合部 | 方式 | 現地作業 |
|---|---|---|
| リム円弧同士 | ダブテール＋M3×8（Φ2.9下穴セルフタップ。<b>印刷済みリム1号の旧Φ4.0穴のみM4×8で代替</b>） | **事前組立**（円盤2枚は組んだまま運搬可・Ø300） |
| 前後リム間（ゴンドラ軸） | **Φ6 3Dプリント軸**を貫通・フランジ頭＋押込キャップで抜け止め（金属棒・カット不要） | 事前組立 |
| 支柱 上下 | 角ダボ＋M3×12 ×2本 | 現地（2分）|
| 支柱⇔ベース | 差し込み＋M3蝶ネジ | 現地（2分）|
| ベース2分割 | ダブテール＋M3蝶ネジ | 現地（1分）|
| ホイール⇔支柱 | シャフトをベアリングに通し、両側のハブ・クランクのM3イモネジで軸方向固定（Eリング不要） | 現地（2分）|
| ゴンドラ | 閉じた丸穴＋Φ6印刷軸を貫通（J溝フック廃止・確実性優先） | 事前組立（搭乗時は軸を抜いて出し入れ）|

**現地組立の合計は約8分**（1時間シフト交代の設営5〜10分要件内）。工具はプラスドライバー1本と蝶ネジ（手回し）のみ。

## 電装設計

### 駆動系（手回しクランク）

```
クランクハンドル（3Dプリント・グリップ付き） → 8mmシャフトにM3イモネジ固定 → ハブ → ホイール回転
※ フリクションダンパー（印刷パーツ・任意）をシャフトに添えて回転を減衰
```

> ベースのモーターマウント部は**クランク軸受に差し替え**（印刷量は同等）。電源・配線が不要になり、現地組立がさらに簡単になります。

### LED系（虹色イルミネーション）

回転するリムへの給電は**スリップリングを使わず**、ハブ中央に小型モバイルバッテリー＋M5 Atom Liteを<b>同乗（一緒に回転）</b>させて解決します。配線のねじれが発生せず、手持ちのM5デバイスを活用できます。

```
[回転部] モバイルバッテリー(5V) → M5 AtomS3R → SK6812テープ×2（前後リム外周）
[固定部]（フォールバック/追加）USB電源 → AtomS3R → ベース・支柱のLED
```

- レインボーアニメーションは AtomS3R の FastLED/M5Unified スケッチで実装済み（[`firmware/led_rainbow/led_rainbow.ino`](https://github.com/aieo-product/stackchanEventBooth/blob/main/firmware/led_rainbow/led_rainbow.ino)・画面ボタンで輝度4段切替・900mA電力キャップ）。
- バッテリーはハブ中心に置くため回転トルクへの影響は最小。10000mAh級で4時間運用は余裕（LED 2m・輝度50%で約1A）。
- **フォールバック**: 回転部LEDが間に合わない場合は、支柱・ベースなど固定部のみのLED装飾に切り替え（バッテリー・配線不要でUSB給電）。

#### 配線（AtomS3R Grove → SMコネクタ・2026-07-23確定）

AtomS3Rには<b>何も加工しない</b>のがポイント。Groveケーブル1本を切断してバラ線化し、WAGOコネクタ4個でSMコネクタ付ケーブルのメス側と橋渡しする（はんだ不要）。部品はページ末尾の「🛒 最終購入リスト」参照。

<style>
.wiring-panel { background: var(--vp-c-bg-soft); border: 1px solid var(--vp-c-divider); border-radius: 10px; padding: 12px; overflow-x: auto; }
.wiring-panel svg { display: block; min-width: 700px; width: 100%; height: auto; }
.wiring-panel .wt { font-size: 12px; fill: var(--vp-c-text-1); }
.wiring-panel .ws { font-size: 10.5px; fill: var(--vp-c-text-2); }
</style>

<div class="wiring-panel">
<svg viewBox="0 0 860 560" role="img" aria-label="AtomS3RからLEDテープまでの配線図">
  <defs>
    <marker id="wire-arr" viewBox="0 0 8 8" refX="7" refY="4" markerWidth="7" markerHeight="7" orient="auto">
      <path d="M0 0 L8 4 L0 8 z" fill="var(--vp-c-text-2)"/>
    </marker>
  </defs>
  <rect x="18" y="200" width="104" height="104" rx="14" fill="#3a3f45" stroke="rgba(128,128,128,.6)"/>
  <rect x="32" y="214" width="76" height="58" rx="6" fill="#111318"/>
  <text x="70" y="247" text-anchor="middle" font-size="11" fill="#8be9a8">50%</text>
  <text x="70" y="292" text-anchor="middle" font-size="11" fill="#c8cdd3" font-weight="600">AtomS3R</text>
  <text x="70" y="190" text-anchor="middle" class="wt" font-weight="600">① 本体</text>
  <rect x="118" y="234" width="16" height="36" rx="3" fill="#e6e6e6" stroke="rgba(128,128,128,.6)"/>
  <text x="126" y="228" text-anchor="middle" class="ws">PORT.A</text>
  <text x="126" y="322" text-anchor="middle" class="ws">底面ヘッダはバッテリー</text>
  <text x="126" y="336" text-anchor="middle" class="ws">ベース用に空ける</text>
  <g fill="none" stroke-linecap="round">
    <path d="M134 240 H208" stroke="rgba(128,128,128,.6)" stroke-width="7"/><path d="M134 240 H208" stroke="#e03131" stroke-width="4.5"/>
    <path d="M134 248 H208" stroke="rgba(128,128,128,.6)" stroke-width="7"/><path d="M134 248 H208" stroke="#26292e" stroke-width="4.5"/>
    <path d="M134 256 H208" stroke="rgba(128,128,128,.6)" stroke-width="7"/><path d="M134 256 H208" stroke="#fafafa" stroke-width="4.5"/>
    <path d="M134 264 H208" stroke="rgba(128,128,128,.6)" stroke-width="7"/><path d="M134 264 H208" stroke="#f5c518" stroke-width="4.5"/>
  </g>
  <line x1="222" y1="218" x2="222" y2="288" stroke="#e8590c" stroke-width="2" stroke-dasharray="5 4"/>
  <text x="222" y="208" text-anchor="middle" font-size="11" fill="#e8590c" font-weight="700">✂ ② ここで切断</text>
  <text x="222" y="302" text-anchor="middle" class="ws">反対側の余りは予備に</text>
  <g fill="none" stroke-linecap="round">
    <path d="M236 240 C300 240 280 96 344 96" stroke="rgba(128,128,128,.6)" stroke-width="7"/><path d="M236 240 C300 240 280 96 344 96" stroke="#e03131" stroke-width="4.5"/>
    <path d="M236 248 C300 248 280 216 344 216" stroke="rgba(128,128,128,.6)" stroke-width="7"/><path d="M236 248 C300 248 280 216 344 216" stroke="#26292e" stroke-width="4.5"/>
    <path d="M236 256 C300 256 280 336 344 336" stroke="rgba(128,128,128,.6)" stroke-width="7"/><path d="M236 256 C300 256 280 336 344 336" stroke="#fafafa" stroke-width="4.5"/>
    <path d="M236 264 C300 264 280 456 344 456" stroke="rgba(128,128,128,.6)" stroke-width="7"/><path d="M236 264 C300 264 280 456 344 456" stroke="#f5c518" stroke-width="4.5"/>
  </g>
  <text x="290" y="130" class="ws" text-anchor="middle">赤 5V</text>
  <text x="290" y="238" class="ws" text-anchor="middle">黒 GND</text>
  <text x="290" y="320" class="ws" text-anchor="middle">白 G2</text>
  <text x="290" y="440" class="ws" text-anchor="middle">黄 G1</text>
  <text x="392" y="46" text-anchor="middle" class="wt" font-weight="600">③ WAGOで結線（4個）</text>
  <g>
    <rect x="344" y="72" width="96" height="48" rx="7" fill="var(--vp-c-bg)" stroke="rgba(128,128,128,.6)"/>
    <rect x="352" y="64" width="80" height="12" rx="3" fill="#e8590c"/>
    <text x="392" y="102" text-anchor="middle" font-size="11.5" class="wt" font-weight="600">WFR-3（3P）</text>
    <text x="452" y="70" class="ws">5V: 赤1本→赤2本</text>
  </g>
  <g>
    <rect x="344" y="192" width="96" height="48" rx="7" fill="var(--vp-c-bg)" stroke="rgba(128,128,128,.6)"/>
    <rect x="352" y="184" width="80" height="12" rx="3" fill="#e8590c"/>
    <text x="392" y="222" text-anchor="middle" font-size="11.5" class="wt" font-weight="600">WFR-3（3P）</text>
    <text x="452" y="190" class="ws">GND: 黒1本→黒2本</text>
  </g>
  <g>
    <rect x="344" y="312" width="96" height="48" rx="7" fill="var(--vp-c-bg)" stroke="rgba(128,128,128,.6)"/>
    <rect x="352" y="304" width="80" height="12" rx="3" fill="#e8590c"/>
    <text x="392" y="342" text-anchor="middle" font-size="11.5" class="wt" font-weight="600">WFR-2（2P）</text>
    <text x="452" y="310" class="ws">白G2 ↔ ①の緑</text>
  </g>
  <g>
    <rect x="344" y="432" width="96" height="48" rx="7" fill="var(--vp-c-bg)" stroke="rgba(128,128,128,.6)"/>
    <rect x="352" y="424" width="80" height="12" rx="3" fill="#e8590c"/>
    <text x="392" y="462" text-anchor="middle" font-size="11.5" class="wt" font-weight="600">WFR-2（2P）</text>
    <text x="452" y="430" class="ws">黄G1 ↔ ②の緑</text>
  </g>
  <g fill="none" stroke-linecap="round">
    <path d="M440 88 C500 88 480 108 540 108" stroke="rgba(128,128,128,.6)" stroke-width="7"/><path d="M440 88 C500 88 480 108 540 108" stroke="#e03131" stroke-width="4.5"/>
    <path d="M440 104 C520 104 460 388 540 388" stroke="rgba(128,128,128,.6)" stroke-width="7"/><path d="M440 104 C520 104 460 388 540 388" stroke="#e03131" stroke-width="4.5"/>
    <path d="M440 208 C500 208 480 140 540 140" stroke="rgba(128,128,128,.6)" stroke-width="7"/><path d="M440 208 C500 208 480 140 540 140" stroke="#26292e" stroke-width="4.5"/>
    <path d="M440 224 C520 224 460 420 540 420" stroke="rgba(128,128,128,.6)" stroke-width="7"/><path d="M440 224 C520 224 460 420 540 420" stroke="#26292e" stroke-width="4.5"/>
    <path d="M440 336 C510 336 470 124 540 124" stroke="rgba(128,128,128,.6)" stroke-width="7"/><path d="M440 336 C510 336 470 124 540 124" stroke="#2f9e44" stroke-width="4.5"/>
    <path d="M440 456 C500 456 480 404 540 404" stroke="rgba(128,128,128,.6)" stroke-width="7"/><path d="M440 456 C500 456 480 404 540 404" stroke="#2f9e44" stroke-width="4.5"/>
  </g>
  <text x="588" y="72" text-anchor="middle" class="wt" font-weight="600">④ SMメス側</text>
  <rect x="540" y="96" width="56" height="56" rx="7" fill="#f0efe9" stroke="rgba(128,128,128,.6)"/>
  <text x="568" y="128" text-anchor="middle" font-size="10.5" fill="#3d4148" font-weight="600">SMメス</text>
  <rect x="540" y="376" width="56" height="56" rx="7" fill="#f0efe9" stroke="rgba(128,128,128,.6)"/>
  <text x="568" y="408" text-anchor="middle" font-size="10.5" fill="#3d4148" font-weight="600">SMメス</text>
  <line x1="600" y1="124" x2="640" y2="124" stroke="var(--vp-c-text-2)" stroke-width="2" marker-end="url(#wire-arr)"/>
  <text x="620" y="112" text-anchor="middle" class="ws">挿す</text>
  <line x1="600" y1="404" x2="640" y2="404" stroke="var(--vp-c-text-2)" stroke-width="2" marker-end="url(#wire-arr)"/>
  <text x="620" y="392" text-anchor="middle" class="ws">挿す</text>
  <g>
    <rect x="644" y="94" width="196" height="60" rx="8" fill="var(--vp-c-bg)" stroke="rgba(128,128,128,.6)"/>
    <rect x="644" y="112" width="14" height="24" rx="3" fill="#f0efe9" stroke="rgba(128,128,128,.6)"/>
    <text x="700" y="118" font-size="11.5" class="wt" font-weight="700">Din ▶▶</text>
    <text x="668" y="140" font-size="11" class="wt">SK6812テープ① 前リム</text>
    <text x="828" y="118" text-anchor="end" font-size="11" fill="#e03131" font-weight="700">DO側 ✕</text>
    <text x="744" y="172" text-anchor="middle" class="ws">「Din」印字＋矢印の始点側に接続（⑤）</text>
  </g>
  <g>
    <rect x="644" y="374" width="196" height="60" rx="8" fill="var(--vp-c-bg)" stroke="rgba(128,128,128,.6)"/>
    <rect x="644" y="392" width="14" height="24" rx="3" fill="#f0efe9" stroke="rgba(128,128,128,.6)"/>
    <text x="700" y="398" font-size="11.5" class="wt" font-weight="700">Din ▶▶</text>
    <text x="668" y="420" font-size="11" class="wt">SK6812テープ② 後リム</text>
    <text x="828" y="398" text-anchor="end" font-size="11" fill="#e03131" font-weight="700">DO側 ✕</text>
    <text x="744" y="452" text-anchor="middle" class="ws">「Din」印字＋矢印の始点側に接続（⑤）</text>
  </g>
</svg>
</div>

| Grove側（切断した4線） | 結線コネクタ | SMピグテール側 | 行き先 |
|---|---|---|---|
| 赤（5V） | WAGO WFR-3 | ①の赤＋②の赤 | 両テープの5V |
| 黒（GND） | WAGO WFR-3 | ①の黒＋②の黒 | 両テープのGND |
| 白（G2） | WAGO WFR-2 | ①の緑 | 前リムテープのDin |
| 黄（G1） | WAGO WFR-2 | ②の緑 | 後リムテープのDin |

::: warning 7/22に光らなかった原因と対策
- <b>DO側（終点側）に挿していた</b> — 信号は矢印の向きにしか流れない。必ず「Din」印字＋矢印の始点側へ
- コネクタ無しの仮結線で接触不良 — WAGOはレバーを上げ→被覆を約11mm剥いた線を差し→レバーを倒す。結線後に軽く引いて抜けを確認
- ピグテールの線色が違うロットあり — 色より<b>SMコネクタのピン位置</b>（テープ側の5V/Din/GND印字と対応）を最終確認
:::

### パーツリスト（BOM・2026-07-15 実売調査済み：Amazonリンク付き）

7/13のAmazon注文（工具・締結・配線材）は<b>7/27着に遅延</b>（7/22判明・イベント7/24に間に合わない）。締結系は<b>CADをΦ2.9セルフタップ化してインサート不要に</b>し（8b25bc4）、ベアリング・ネジ類は<b>7/23に千石電商 秋葉原本店で現物調達</b>する（下の「🛒 7/23 千石買い出しリスト」参照）。

| # | 品目 | 採用候補（実売） | 状態 | 実売(税込) | 購入リンク |
|--:|---|---|---|--:|---|
| 1 | ~~ウォームギヤードモーター~~ | JGY-370 12V 3rpm（[dp/B01HGCSBDM](https://www.amazon.co.jp/dp/B01HGCSBDM)） | ✖ 不採用（電動版用・参考） | (¥2,429) | — |
| 2 | ~~ACアダプタ 12V 2A~~ | Broadwatch（[dp/B00AJDAPM6](https://www.amazon.co.jp/dp/B00AJDAPM6)） | ✖ 不採用（電動版用・参考） | (¥1,380) | — |
| 3 | ~~PWM速度コントローラ~~ | beyourchoi 6個（[dp/B0CX55SRYM](https://www.amazon.co.jp/dp/B0CX55SRYM)） | ✖ 不採用（電動版用・参考） | (¥749) | — |
| 4 | ~~スイッチ＋DCジャック~~ | LIANHATA＋Youmile | ✖ 不採用（電動版用・参考） | (¥1,574) | — |
| 5 | ベアリング 608（内径8mm） | ミネベア 608ZZ ×3（支柱2＋予備1） | 🏪 <b>7/23 千石3階で購入</b>（Amazon便は7/27着遅延） | ¥663 | [EEHD-4JWX](https://www.sengoku.co.jp/mod/sgk_cart/detail.php?code=EEHD-4JWX) |
| 6 | シャフト Φ8mm | uxcell リニアシャフト 8×250mm **2本**（★4.2/50件） | 🛒 共通 | ¥1,180 | [dp/B08XYM78XJ](https://www.amazon.co.jp/dp/B08XYM78XJ) |
| 7 | ~~シャフトカプラ 6→8mm~~ | Saipor 5個（[dp/B07ZMYSYLH](https://www.amazon.co.jp/dp/B07ZMYSYLH)） | ✖ 不採用（電動版用・参考） | (¥999) | — |
| 8 | LEDテープ（アドレサブル） | **秋月 SK6812 1m/60LED ×2本**（WS2812B互換・両端SMコネクタ付き＝切断/はんだ不要・着脱式） | 🏪 **秋月店頭で購入（7/16予定）** | ¥3,880 | [秋月 112982](https://akizukidenshi.com/catalog/g/g112982/) |
| 9 | LEDコントローラ | M5 Atom Lite | ✅ 手持ち | — | — |
| 10 | モバイルバッテリー | 小型 5V/2A（ハブ同乗用） | ✅ 手持ち | — | — |
| 11 | ネジ類 | ~~M3ヒートインサート~~（Φ2.9セルフタップ化で<b>不要</b>）／M3なべ×8・×12／M3イモネジ／M3蝶ボルト／M4×8 | 🏪 <b>7/23 千石2階で購入</b>（Amazon便は7/27着遅延） | 約¥2,500 | 下の買い出しリスト参照 |
| 12 | ゴンドラ軸 | ~~Φ3丸棒＋Eリング~~ → **Φ6 3Dプリント軸×4＋キャップ**（2026-07-16 設計変更: カット機材不要のため。曲げ応力≈2.8MPa・安全率18倍） | 🖨️ 印刷（購入不要） | — | — |
| 13 | 配線・工具 | 3ピンコネクタ・ジャンパー・熱収縮・はんだ・ニッパー・サーボテスター | 🚚 7/27着（遅延）— <b>観覧車は手回し駆動のため当日必須ではない</b>。熱収縮のみ必要なら秋月で代替 | — | — |
| 14 | クランクハンドル・軸受・ダンパー | 3Dプリント（本設計） | 🖨️ 印刷（購入不要） | — | — |
| | | | **追加調達合計（手回し版）** | **約¥6,700**（Amazon ¥2,819＋秋月 ¥3,880） | |

### 🛒 7/23 千石買い出しリスト（機構部品）

> LED配線材を含む<b>全品の確定版はページ末尾の「🛒 最終購入リスト」</b>を参照。

7/13 Amazon注文の未着（7/27着に遅延）を受けた現物調達リスト。<b>必須分は千石電商 秋葉原本店1軒で完結</b>します（外神田1-8-6 丸和ビル・11:00〜19:00・03-3253-4411）。商品リンク・在庫拠点は2026-07-23の通販サイト表示（在庫拠点=秋葉原を確認済み。店頭数は非公開のため電話確認が確実）。

| 売場 | 品目 | 数量 | 用途 | 価格 | 商品リンク |
|---|---|---|---|--:|---|
| 3階 メカトロ | ミネベア 608ZZ ベアリング | 3個（支柱2＋予備1） | 支柱上端の軸受（Φ22.2ポケット） | ¥663 | [EEHD-4JWX](https://www.sengoku.co.jp/mod/sgk_cart/detail.php?code=EEHD-4JWX) |
| 2階 ネジ | 鉄ナベ小ネジ M3×8（50本入） | 1袋 | リム継手8箇所×2本＋スポーク⇔ハブ8穴×2枚＝32本＋予備。Φ2.9下穴に直接セルフタップ | ¥650 | [EEHD-6MP4](https://www.sengoku.co.jp/mod/sgk_cart/detail.php?code=EEHD-6MP4) |
| 2階 ネジ | 鉄ナベ小ネジ M3×12（50本入） | 1袋 | 支柱上下連結2本×2＋イモネジ穴の事前タップ立て用＋予備 | ¥650 | [EEHD-6MP6](https://www.sengoku.co.jp/mod/sgk_cart/detail.php?code=EEHD-6MP6) |
| 2階 ネジ | 鉄イモネジ（ホーロー）M3×8 | 10個（使用6＋予備） | ハブ×2枚の各2本＋クランク2本のシャフト固定。<b>締結に六角レンチ1.5mmが必要</b> | ¥550 | [EEHD-6GTT](https://www.sengoku.co.jp/mod/sgk_cart/detail.php?code=EEHD-6GTT) |
| 2階 ネジ | 鉄蝶ボルト M3×12 | 6個 | 支柱⇔ベース×2・ベース2分割連結（手回し・工具レス） | ¥450 | [EEHD-6GGM](https://www.sengoku.co.jp/mod/sgk_cart/detail.php?code=EEHD-6GGM) |
| 2階 ネジ | 鉄蝶ボルト M3×8 | 4個 | 上記の長さ現物合わせ用サブ | ¥300 | [EEHD-6GGK](https://www.sengoku.co.jp/mod/sgk_cart/detail.php?code=EEHD-6GGK) |
| 2階 ネジ | M4×8 ネジ（セムス/トラス等どれでも可） | 4本 | <b>印刷済みリム1号の旧Φ4.0継手穴の代替のみ</b>（8b25bc4のコメント参照） | 〜¥200 | [EEHD-6FGL](https://www.sengoku.co.jp/mod/sgk_cart/detail.php?code=EEHD-6FGL) |
| 工具売場 | 六角レンチ 1.5mm（手持ちなければ） | 1本 | イモネジ用。<b>これが無いとシャフト固定不可</b> | 〜¥300 | 店頭選定 |
| （任意）2階 | 平ワッシャーM3 少量 | — | 蝶ボルト座面のPLA保護 | 〜¥100 | 店頭バラ |

- <b>合計目安: 約¥3,700</b>（任意含む）
- 買わなくてよくなったもの: ~~M3ヒートインサート~~（Φ2.9セルフタップ化）・~~EW3 Eリング~~（ゴンドラ軸の印刷軸化＋ハブ/クランクのイモネジ軸方向固定で不要）
- 任意・別店: 熱収縮チューブは並びの[秋月電子](https://akizukidenshi.com/catalog/c/cheatshri/)（平日11:30〜18:30）。サーボテスターは駅反対側のスーパーラジコン（11:00〜21:00・03-5688-1414）だが観覧車には不要
- 調査ログ: [research/akiba-backup-20260722.md](https://github.com/aieo-product/stackchanEventBooth/blob/main/research/akiba-backup-20260722.md)

::: tip 調達状況（2026-07-15 確定・履歴）
- **Amazon発注（¥1,180）**: 8mmシャフト2本（**7/18着**・ホイール主軸・L250でカット不要）のみ。~~Eリング・Φ3丸棒~~ は印刷軸化（2026-07-16）により購入不要に
- **秋月店頭（7/16買い出し予定）**: SK6812テープLED 1m×2本（¥3,880・[販売コード112982](https://akizukidenshi.com/catalog/g/g112982/)・通販在庫410本）
  - 1mずつ前後リムに1本ずつ貼るだけ（切断・はんだ不要）。両端SMコネクタで着脱式＝現地分解の設計方針と好相性
  - 千石電商（徒歩圏）に寄るなら: EW3 Eリング（本店2階）・608ZZ（本店3階）が7/13注文分の遅延時保険
- シャフトは7/18着だが、軸組みは7/22の本組立のため**スケジュール影響なし**
:::

::: warning 実売調査での判明事項（2026-07-15）
- **モーター系5点（#1〜4・7）の実売合計は¥7,131**で切替閾値（¥6,000）を超過 → **手回し版に決定（2026-07-15）**。#1〜4・7は発注しない。
- 実売が概算より高いのは**多くがセット販売**のため（PWM6個・ジャック10個・カプラ5個・シャフト2本・丸棒10本・LED5m）。余剰は予備・他プロジェクトに回せます。
- **Φ8mm Dカット付きシャフトは在庫なし** → 丸棒で代替し、**ハブ固定はDカット依存をやめてM3イモネジ×2（手持ちインサート活用）に設計変更**。
- LEDテープはIP30・2m品の完全一致がなく、ALITOVE 5m IP20（非防水・ほぼ同等）を採用。カプラはフレキ型の高トルク強度に注意（本用途は低トルクのため許容、必要ならリジッド型へ）。
- **納期は全品「明日7/16着」**を確認済み。7/17着目標より前倒しで揃います。
:::

### 🏪 調達先の比較（Amazon通販 × 秋葉原店頭・2026-07-15調査）

オフィス（神田）から秋葉原の実店舗に行ける前提で、**秋月電子通商・千石電商の通販サイト在庫**も調査済み（[調査詳細](https://github.com/aieo-product/stackchanEventBooth/blob/main/research/amazon-parts-20260715.md)）。両店は徒歩圏内なので1回の外出で回れます。

| パーツ | 🚚 Amazon（明日7/16着） | 🏪 秋葉原店頭（当日入手） |
|---|---|---|
| ① 8mmシャフト | ✅ uxcell 2本 ¥1,180（[dp/B08XYM78XJ](https://www.amazon.co.jp/dp/B08XYM78XJ)） | ❌ 金属シャフトは秋月・千石とも**取扱なし**。千石に[アクリル8φ×30cm ¥330](https://www.sengoku.co.jp/mod/sgk_cart/detail.php?code=6B4T-TDEN)（本店2階）があるが樹脂のため軸荷重・耐久は要検証 |
| ② アドレサブルLEDテープ 2m | ALITOVE WS2812B 5m ¥3,369（[dp/B01N7BX973](https://www.amazon.co.jp/dp/B01N7BX973)・切断/はんだ処理が必要） | ✅ **【採用】秋月 SK6812テープLED 1m/60LED ¥1,940×2本=¥3,880**（[112982](https://akizukidenshi.com/catalog/g/g112982/)・WS2812B互換・両端SMコネクタ付き・在庫410本）。千石はアドレサブル品の取扱なし |
| ③ Φ3mm丸棒＋Eリング | ✅ 丸棒10本 ¥1,050＋Eリング120個 ¥589（[dp/B0FCZP736S](https://www.amazon.co.jp/dp/B0FCZP736S) / [dp/B08HN2CCDZ](https://www.amazon.co.jp/dp/B08HN2CCDZ)） | 丸棒❌（金属3mmは両店なし）／ Eリングのみ✅ [千石 EW3 100個¥580](https://www.sengoku.co.jp/mod/sgk_cart/detail.php?code=EEHD-6GJZ)（本店2階） |
| （予備）608ベアリング | 7/13注文済（7/20〜22着） | ✅ [千石 ミネベア608ZZ ¥221/個](https://www.sengoku.co.jp/mod/sgk_cart/detail.php?code=EEHD-4JWX)（本店3階）— 着荷遅延時のバックアップに |

**確定プラン（2026-07-15）**: **金属丸棒2種（①③）＋EリングはAmazonで発注**（計¥2,819・シャフトのみ7/18着、他は7/16着）。**LEDは秋月店頭でSK6812×2本を購入（7/16買い出し）** — 1mずつ前後リムに貼るだけで切断・はんだ不要、SMコネクタで着脱式のため。千石のEリング・608ZZは7/13注文分の着荷遅延時の保険。※店頭在庫数はサイト非公開のため、来店前の電話確認が確実。

### ⚖️ 電動 vs 手回し（モーター価格で選択）

モーター・電源系の実売価格が想定より高い場合は、**モーターをドロップして手回しクランク版**に切り替えられる設計にします（ホイール・支柱・ベース・LEDは共通、モーターマウント部だけクランク軸受に差し替え）。

| 比較項目 | 🔌 電動版（本命） | 🖐️ 手回し版（コストダウン） |
|---|---|---|
| 回転 | ウォームギヤモーターで**自動**（1〜2rpm連続） | 印刷製クランクハンドルを**来場者が回す** |
| 追加発注費（**実売**・2026-07-15調査） | **約¥13,300** | **約¥6,200**（モーター系5点 ¥7,131 をドロップ） |
| 追加発注の内訳 | モーター系5点（¥7,131）＋シャフト・LED | シャフト¥1,180＋秋月LED¥3,880 のみ（ゴンドラ軸は印刷化で¥0） |
| LED（虹色） | ハブ同乗バッテリー＋Atom Lite | **同じ構成でそのまま使用可**（回転と独立） |
| 体験の質 | 常時回転で展示映え・無人でも絵になる | 来場者参加型（「回してみて」の体験化）。無人時は静止 |
| 安全 | セルフロックで電源OFF即停止 | クランク直結・低速。回しすぎ防止のフリクションダンパー（印刷パーツ）を任意追加 |
| 印刷の変更 | — | モーターマウント → クランク軸受＋ハンドル（同等の印刷量） |

**決定（2026-07-15）**: モーター系5点の実売合計が**¥7,131で閾値¥6,000を超過**したため、**手回し版を採用**。「来場者がクランクを回す」参加型体験として運用し、電源・配線レスで現地組立もさらに簡単になる。本表は検討記録として残置。

## フィラメント必要量（追加分）

| 区分 | 量 |
|---|--:|
| 観覧車 印刷部品合計 | 約1,176g |
| 失敗・試作マージン +25% | +294g |
| **観覧車 追加消費** | **約1.47kg** |

既存計画（アクセサリー等 約1.2〜1.3kg、[プリント環境](/printing)）＋観覧車約1.47kg＋撮影ブース約0.7kg（[撮影ブース](/photobooth)）＝ **合計約3.4〜3.5kg**。購入済みの**6色×1kg＝6kg以内に収まります**（追加購入不要）。

## 印刷スケジュール（X2D 1台・立ち会い運用・観覧車＋撮影ブース＋アクセサリー統合）

::: warning 前提
無人運転は禁止（[print/README](https://github.com/aieo-product/stackchanEventBooth/blob/main/print/README.md)）のため、1日の印刷枠を<b>最大12h（立ち会い可能時間）</b>として計画。総印刷時間 約50h（観覧車）＋約25h（撮影ブース）＋約20h（アクセサリー優先分）≒ **95h** を **9日間・計108h枠**（≦12h/日）に配分します。7/15のテスト印刷分（リム1・ゴンドラ1・床タイル1）は本番部品として使用します。
:::

| 日付 | 印刷内容 | 目安時間 | 並行作業 |
|---|---|--:|---|
| 7/15(火) | **テスト印刷**（リム円弧1・ゴンドラ1※手持ちパステルで公差確認・床タイル1） | 5.0h | CAD完了（PR #17マージ済） |
| 7/16(水) | 観覧車 リム円弧×4＋ハブ×2 | 11.8h | 秋葉原買い出し（秋月SK6812×2）／Amazon着荷（Eリング・丸棒） |
| 7/17(木) | 観覧車 リム円弧×3＋支柱×2 | 11.0h | フィラメント7本 発注済み（7/16・PLAウッド/PETGクリア等）の着荷待ち |
| 7/18(金) | 観覧車 支柱×2＋ベース×2 | 10.4h | シャフト着荷／**プランB切替判断**（CADは完了済のため原則プランA続行） |
| 7/19(土) | クランク一式＋**ゴンドラ×3（手持ちパステル）**＋ディフューザー×4（PETGクリア・要乾燥） → **LED点灯テスト＋仮合わせ** | 10.3h | フィラメント着荷確認・LEDテスト |
| 7/20(日) | ディフューザー×4＋撮影ブース 床タイル×7＋壁パネル×4 | 11.8h | ジオラマ装飾素材の画像作成・印刷／7/13注文分の着荷確認 |
| 7/21(月) | 撮影ブース 壁パネル×4＋スタンド類＋MakerWorld小物4点 | 11.9h | 100均で装飾調達／インサート圧入開始（着荷次第） |
| 7/22(火) | アクセサリー優先分（帽子・ヘッドホン・猫耳・キーホルダー） | 12.0h | **観覧車 本組立・回転/LEDテスト**（ベアリング組込み） |
| 7/23(水) | 予備日（失敗リテイク・配布品追加） → **全体組立リハーサル・梱包** | 6.0h | 最終確認 |

> フィラメント7本は7/16発注（グラディエント綿菓子の雲は売切→ゴンドラは手持ちパステル4色に変更）。PETGクリアは7/18〜19着見込みのためディフューザーを7/19以降に配置。PETGは印刷前に乾燥させること。

**時間が足りない場合の縮退順**: ① 配布用キーホルダーの個数削減 → ② 撮影ブース壁パネルを8→4枚（背面中央のみ） → ③ 観覧車ゴンドラ4→2基。観覧車本体の中止は最終手段。

## 現地組立手順（当日・約8分）

1. ベース2分割を連結し、テーブル中央ゾーンに設置（1分）
2. 支柱を上下連結し、ベースに差し込んで蝶ネジ固定（2分×2本＝並行可）
3. ホイール（事前組立済みの円盤＋シャフト・ゴンドラ4基は吊り済み）を支柱のベアリングに載せる（2分）
4. クランクハンドルをシャフト端にイモネジ固定 — ハブとクランクで軸方向も固定される（2分）
5. ハブのバッテリーをONにしてLED点灯・手回しでの回転を確認（1分）

## MakerWorld既存モデルの流用可否（2026-07-15 調査済み）

MakerWorldの既存観覧車を調査した結果（8件・詳細は [Issue #12](https://github.com/aieo-product/stackchanEventBooth/issues/12)）、**実機（6cm角・150g）が搭乗できる強度・サイズの既製品は無く、新規設計（本ページのプランA）を本命**とします。ただし有力な既製品が2つあり、フォールバックとして活用します。

| 候補 | ライセンス | 印刷時間 | 評価 |
|---|---|--:|---|
| [espRyk 電動観覧車（N20モーター+USB5V）](https://makerworld.com/ja/models/911733) | MW標準 | 16.6h | 完成度最高・コミュニティ活発。ただし推定Ø205でゴンドラ寸法非公開 → **実機は乗れない前提**。ミニスタックチャン（キーホルダー配布品）なら搭乗可の見込み |
| [jj0815 シルバニアファミリー版](https://makerworld.com/ja/models/2503805) | MW限定 | 11.5h | シルバニア人形（高さ6〜7cm）向け＝**スケール適合は最良**。ただし手動回転・軽量人形前提で150gの実機はヒンジ強度が不足の見込み |
| [GUYI DESIGN 電動発光観覧車](https://makerworld.com/ja/models/1625080) | MW標準 | 52h | 電動+LEDで理想像に近いが、印刷52h・半田付け必須・モーター情報不足 → **期間内製作は不可** |

**プランB（フォールバック）**: 新規設計のCAD/印刷が7/19の仮組立に間に合わない場合、espRyk電動版（16.6h・Print Profile付きでそのまま印刷可）に**ミニスタックチャン（配布用キーホルダー）を搭乗**させる構成へ切替。虹色LEDは固定部（支柱・ベース）装飾として本設計の電装をそのまま使う。切替判断は**7/18時点のCAD進捗**で行う。

> 経費は [経費まとめ](/expenses) に反映済み。印刷ジョブは [`print/print-list.yaml`](https://github.com/aieo-product/stackchanEventBooth/blob/main/print/print-list.yaml) の `ferris-*` を参照（STL確定後に有効化）。

## 🛒 最終購入リスト（2026-07-23 最小構成に確定）

<b>7/23 昼の強度見直しで最小構成に絞り込み</b>: フィットテストで嵌合がきつめ＝摩擦固定が効くこと、手回し低速で軸受精度が不要なことから、<b>締結は「リムを繋ぐM3ネジ」だけ</b>に削減。買い出しは千石電商 秋葉原本店1軒（外神田1-8-6・11:00〜19:00・03-3253-4411）。

### 買うもの（最小構成・約¥2,200）

| ✔ | 売場 | 品目 | 数量 | 価格 | 商品リンク | 用途 |
|---|---|---|---|--:|---|---|
| ☐ | 2階 ネジ | 鉄ナベ小ネジ M3×8（50本入） | 1袋 | ¥650 | [EEHD-6MP4](https://www.sengoku.co.jp/mod/sgk_cart/detail.php?code=EEHD-6MP4) | <b>唯一の必須締結</b>。リム継手16本＋スポーク⇔ハブ16本＋予備（Φ2.9下穴セルフタップ） |
| ☐ | 2階 ネジ | M4×8 ネジ（セムス/トラス等可） | 4本 | 〜¥200 | [EEHD-6FGL](https://www.sengoku.co.jp/mod/sgk_cart/detail.php?code=EEHD-6FGL) | 印刷済みリム1号の旧Φ4.0穴のみ（リム1号を使わないなら不要） |
| ☐ | 1階 14番07列 | JST SM状コネクタ付ケーブル 3P オスメスセット（CAB-14575） | 2セット | ¥700 | [EEHD-57YB](https://www.sengoku.co.jp/mod/sgk_cart/detail.php?code=EEHD-57YB) | LED用。<b>メス側</b>をテープDin端（オス）に挿す×2（余裕あれば予備+1） |
| ☐ | 地下1階 | WAGO WFR-3 ワンタッチコネクター 3P | 2個 | ¥378 | [EEHD-4YR3](https://www.sengoku.co.jp/mod/sgk_cart/detail.php?code=EEHD-4YR3) | LED用。5V分岐・GND分岐（¥189/個） |
| ☐ | 地下1階 | WAGO WFR-2 ワンタッチコネクター 2P | 2個 | ¥274 | [EEHD-4YMP](https://www.sengoku.co.jp/mod/sgk_cart/detail.php?code=EEHD-4YMP) | LED用。信号線 白G2↔①Din・黄G1↔②Din（¥137/個） |

### 買わない（省略の根拠・2026-07-23 強度見直し）

| 品目 | 店頭で買うなら | 省略できる理由 | 滑った/緩んだ時のリカバリ |
|---|---|---|---|
| ~~608ZZベアリング~~ | [EEHD-4JWX](https://www.sengoku.co.jp/mod/sgk_cart/detail.php?code=EEHD-4JWX)（3階・¥221/個） | 支柱のシャフト貫通穴は<b>Φ9.0</b>（CAD実測）— Φ8シャフトが直接乗る。ガタ約0.5mm・手回し低速では体感差なし | 現物合わせで気になればポケットに608を後日装着（7/27 Amazon便に同梱） |
| ~~M3イモネジ＋六角レンチ~~ | [EEHD-6GTT](https://www.sengoku.co.jp/mod/sgk_cart/detail.php?code=EEHD-6GTT)（2階・¥55/個） | クランク・ハブとも圧入がきつく摩擦固定で足りる（フィットテスト実測） | ハブ/クランクの<b>Φ2.9横穴にM3ネジを直接ねじ込む</b>（同じ50本袋で対応・頭は出るが機能する） |
| ~~M3蝶ボルト~~ | [M3×12: EEHD-6GGM](https://www.sengoku.co.jp/mod/sgk_cart/detail.php?code=EEHD-6GGM)／[M3×8: EEHD-6GGK](https://www.sengoku.co.jp/mod/sgk_cart/detail.php?code=EEHD-6GGK)（2階・¥75/個） | 支柱・ベースは差し込みだけで自立安定 | 運搬時にガタつくならテープ養生で十分 |
| ~~M3×12~~ | [EEHD-6MP6](https://www.sengoku.co.jp/mod/sgk_cart/detail.php?code=EEHD-6MP6)（2階・50本¥650） | 支柱上下は角ダボ＋自重（圧縮方向）で保持 | 抜け方向が心配ならM3×8を短掛け |
| ~~六角レンチ1.5mm・平ワッシャー~~ | 工具売場・2階バラ | イモネジ・蝶ボルト省略に伴い不要 | — |

### 任意・別店

| 品目 | 店 | 備考 |
|---|---|---|
| 熱収縮チューブ | [秋月電子](https://akizukidenshi.com/catalog/c/cheatshri/)（千石の並び・平日11:30〜18:30） | LED配線の被覆保護。WAGO結線なら無くても可 |
| ビニールテープ | 100均/コンビニ | 絶縁・結線補強 |

### LED結線メモ（購入後の作業）

- Grove側は手持ちのGrove一体型ケーブル1本を切断して片側バラ線化（購入不要）。接続図は `firmware/led_rainbow/led_rainbow.ino` 冒頭コメント参照
- 結線: 赤↔赤（5V）／黒↔黒（GND）／白G2↔テープ①緑Din／黄G1↔テープ②緑Din。<b>テープは`Din`印字＋矢印始点側</b>に接続（`DO`側は光らない — 7/22の不点灯原因）
- ファーム書込み済み（AtomS3R・画面ボタンで輝度4段切替・900mA上限）。バッテリーはATOMICバッテリーベース×3を差し替え運用

> 調達の経緯・帰宅後の組立順は [research/akiba-backup-20260722.md](https://github.com/aieo-product/stackchanEventBooth/blob/main/research/akiba-backup-20260722.md) を参照。
