// led_rainbow.ino — 観覧車リムLED（SK6812 1m/60LED x2本）レインボー制御
// Board: M5Stack AtomS3R (FQBN m5stack:esp32:m5stack_atoms3r)
//
// 配線（Grove PORT.A を使用 — 底面ヘッダはバッテリーベース用に空けておく）:
//   Grove 5V  -> 両テープの 5V
//   Grove GND -> 両テープの GND
//   Grove G2  -> 前リムテープ Din（矢印の始点側から入れる）
//   Grove G1  -> 後リムテープ Din
//
// 操作: 画面ボタン(G41)で輝度切替 50% -> 25% -> 100% -> OFF -> 50% ...
// 電流はFastLEDの電力キャップで最大900mAに制限（モバイルバッテリー安全圏）

#include <M5Unified.h>
#include <FastLED.h>

constexpr int PIN_FRONT = 2;   // Grove 白線側
constexpr int PIN_BACK  = 1;   // Grove 黄線側
constexpr int NUM_LED   = 60;  // 1m 60LED/m

CRGB ledsF[NUM_LED];
CRGB ledsB[NUM_LED];

const uint8_t kLevels[] = {128, 64, 255, 0};   // 50%, 25%, 100%, OFF
const char*   kLabels[] = {"50%", "25%", "100%", "OFF"};
int levelIdx = 0;

void drawStatus() {
  M5.Display.clear(TFT_BLACK);
  M5.Display.setTextDatum(middle_center);
  M5.Display.setTextSize(3);
  M5.Display.drawString(kLabels[levelIdx], M5.Display.width() / 2,
                        M5.Display.height() / 2);
}

void setup() {
  auto cfg = M5.config();
  M5.begin(cfg);
  FastLED.addLeds<SK6812, PIN_FRONT, GRB>(ledsF, NUM_LED);
  FastLED.addLeds<SK6812, PIN_BACK,  GRB>(ledsB, NUM_LED);
  FastLED.setMaxPowerInVoltsAndMilliamps(5, 900);  // 電流上限
  FastLED.setBrightness(kLevels[levelIdx]);
  drawStatus();
}

void loop() {
  M5.update();
  if (M5.BtnA.wasPressed()) {
    levelIdx = (levelIdx + 1) % 4;
    FastLED.setBrightness(kLevels[levelIdx]);
    drawStatus();
  }
  // リム一周ぶんの虹をゆっくり流す（前後リムは同位相）
  uint8_t base = millis() / 20;   // 約13秒で一周
  fill_rainbow(ledsF, NUM_LED, base, 255 / NUM_LED);
  for (int i = 0; i < NUM_LED; i++) ledsB[i] = ledsF[i];
  FastLED.show();
  delay(16);
}
