// ferris_ctrl.ino — 観覧車 v7 自動回転コントローラ（モーター駆動 + リムLED）
// Board: M5Stack AtomS3R (FQBN m5stack:esp32:m5stack_atoms3r)
// Carrier: hardware/ferris-ctrl-pcb (EasyEDA / JLCPCB) — 設計書 docs/ferris-v7-auto.md
//
// 配線（AtomS3R 底面ヘッダ = キャリア基板ソケット / Grove PORT.A = LED）:
//   G5  -> DRV8871 IN1 (PWM)        G6  -> DRV8871 IN2 (PWM)
//   G7  -> 速度ポテンショ (ADC1)      G8  -> ホールセンサ (open-drain, 内部PU)
//   G38 -> RUN/STOP 押しボタン (GND)  G39 -> 非常停止スイッチ 検知 (GND=押下)
//   Grove G2 -> 前リム SK6812 Din     Grove G1 -> 後リム SK6812 Din
//   ※ 非常停止スイッチはこの検知線とは別に、モーター12Vを物理的に遮断する（基板上の配線）
//
// 動作:
//   起動 = STOP。ボタン短押しで RUN <-> STOP、RUN は 2 秒ソフトスタート。
//   速度はポテンショ 30..100%（ウォームモーターは低デューティで止まるため下限30%）。
//   ホールセンサ有効時、想定周期の 2.5 倍パルスが来なければ STALL 停止（表示赤）。
//   非常停止が押されている間は FAULT 表示・PWM 0（12V も物理遮断済み）。
//   画面ボタン(G41) 短押し = LED 輝度 50/25/100/OFF、長押し(1s) = RUN/STOP（現場での予備操作）。

#include <M5Unified.h>
#include <FastLED.h>

// ---- pins --------------------------------------------------------------
constexpr int PIN_IN1   = 5;
constexpr int PIN_IN2   = 6;
constexpr int PIN_POT   = 7;
constexpr int PIN_HALL  = 8;
constexpr int PIN_BTN   = 38;
constexpr int PIN_ESTOP = 39;
constexpr int PIN_LED_F = 2;    // Grove 白線側
constexpr int PIN_LED_B = 1;    // Grove 黄線側

// ---- config ------------------------------------------------------------
constexpr int   NUM_LED        = 60;
constexpr int   PWM_FREQ_HZ    = 20000;   // 可聴域外
constexpr int   PWM_RES_BITS   = 10;      // 0..1023
constexpr int   PWM_MAX        = (1 << PWM_RES_BITS) - 1;
constexpr float DUTY_MIN       = 0.30f;   // ポテンショ最小位置でのデューティ
constexpr float DUTY_MAX       = 1.00f;
constexpr uint32_t RAMP_MS     = 2000;    // ソフトスタート
constexpr bool  HALL_ENABLED   = true;    // センサ未実装なら false
constexpr int   HALL_MAGNETS   = 1;       // ハブ外周の磁石数
constexpr float MOTOR_RPM_FULL = 3.0f;    // JGY-370 12V 3rpm 版（デューティ100%時）
constexpr float STALL_FACTOR   = 2.5f;    // 想定パルス間隔 × この倍率でストール判定
constexpr uint32_t STALL_MIN_MS = 8000;   // 起動直後の猶予

enum class State { STOP, RUN, STALL, FAULT };
State state = State::STOP;
uint32_t runStartMs = 0;
volatile uint32_t lastHallMs = 0;
volatile uint32_t hallCount = 0;
float dutyCmd = 0;   // 現在出力中

const uint8_t kLevels[] = {128, 64, 255, 0};
const char*   kLabels[] = {"50%", "25%", "100%", "OFF"};
int levelIdx = 0;
CRGB ledsF[NUM_LED], ledsB[NUM_LED];

void IRAM_ATTR onHall() { lastHallMs = millis(); hallCount++; }

float readPotDuty() {
  // 8 回平均、0..4095 -> DUTY_MIN..DUTY_MAX
  uint32_t acc = 0;
  for (int i = 0; i < 8; i++) acc += analogRead(PIN_POT);
  float t = (acc / 8.0f) / 4095.0f;
  return DUTY_MIN + (DUTY_MAX - DUTY_MIN) * t;
}

void motorWrite(float duty) {
  duty = constrain(duty, 0.0f, 1.0f);
  dutyCmd = duty;
  // 正転: IN1=PWM, IN2=0（DRV8871: IN2=0/IN1=PWM で forward, 逆は入替え）
  ledcWrite(PIN_IN1, (int)(duty * PWM_MAX));
  ledcWrite(PIN_IN2, 0);
}

void motorCoast() { ledcWrite(PIN_IN1, 0); ledcWrite(PIN_IN2, 0); dutyCmd = 0; }

void draw() {
  auto& d = M5.Display;
  uint16_t bg = TFT_BLACK;
  const char* title = "STOP";
  switch (state) {
    case State::RUN:   bg = TFT_DARKGREEN; title = "RUN";   break;
    case State::STALL: bg = TFT_RED;       title = "STALL"; break;
    case State::FAULT: bg = TFT_MAROON;    title = "E-STOP"; break;
    default: break;
  }
  d.fillScreen(bg);
  d.setTextColor(TFT_WHITE, bg);
  d.setTextDatum(top_center);
  d.setTextSize(3);
  d.drawString(title, d.width() / 2, 8);
  d.setTextSize(2);
  char buf[32];
  snprintf(buf, sizeof buf, "SPD %3d%%", (int)(dutyCmd * 100));
  d.drawString(buf, d.width() / 2, 52);
  snprintf(buf, sizeof buf, "LED %s", kLabels[levelIdx]);
  d.drawString(buf, d.width() / 2, 76);
  snprintf(buf, sizeof buf, "rev %lu", (unsigned long)(hallCount / HALL_MAGNETS));
  d.drawString(buf, d.width() / 2, 100);
}

void setState(State s) {
  if (s == state) return;
  state = s;
  if (s == State::RUN) { runStartMs = millis(); lastHallMs = millis(); }
  else motorCoast();
  draw();
}

void setup() {
  auto cfg = M5.config();
  M5.begin(cfg);
  pinMode(PIN_BTN, INPUT_PULLUP);
  pinMode(PIN_ESTOP, INPUT_PULLUP);
  pinMode(PIN_HALL, INPUT_PULLUP);
  analogReadResolution(12);
  ledcAttach(PIN_IN1, PWM_FREQ_HZ, PWM_RES_BITS);
  ledcAttach(PIN_IN2, PWM_FREQ_HZ, PWM_RES_BITS);
  motorCoast();
  if (HALL_ENABLED) attachInterrupt(digitalPinToInterrupt(PIN_HALL), onHall, FALLING);

  FastLED.addLeds<SK6812, PIN_LED_F, GRB>(ledsF, NUM_LED);
  FastLED.addLeds<SK6812, PIN_LED_B, GRB>(ledsB, NUM_LED);
  FastLED.setMaxPowerInVoltsAndMilliamps(5, 900);
  FastLED.setBrightness(kLevels[levelIdx]);
  draw();
}

void loop() {
  M5.update();
  static uint32_t lastDraw = 0;
  static bool btnPrev = true;
  static uint32_t btnDownMs = 0;

  // --- 非常停止（最優先）---
  bool estop = digitalRead(PIN_ESTOP) == LOW;
  if (estop) setState(State::FAULT);
  else if (state == State::FAULT) setState(State::STOP);

  // --- 外部 RUN/STOP ボタン（立下りで反転・50ms デバウンス）---
  bool btn = digitalRead(PIN_BTN);
  if (btnPrev && !btn) btnDownMs = millis();
  if (!btnPrev && btn && millis() - btnDownMs > 50 && !estop) {
    setState(state == State::RUN ? State::STOP : State::RUN);
  }
  btnPrev = btn;

  // --- 画面ボタン: 短押し=LED 輝度、長押し=RUN/STOP ---
  if (M5.BtnA.wasReleased()) {
    levelIdx = (levelIdx + 1) % 4;
    FastLED.setBrightness(kLevels[levelIdx]);
    draw();
  }
  if (M5.BtnA.pressedFor(1000) && !estop) {
    setState(state == State::RUN ? State::STOP : State::RUN);
    while (M5.BtnA.isPressed()) { M5.update(); delay(10); }
  }

  // --- モーター出力 ---
  if (state == State::RUN) {
    float target = readPotDuty();
    uint32_t t = millis() - runStartMs;
    float ramp = t >= RAMP_MS ? 1.0f : (float)t / RAMP_MS;
    motorWrite(target * ramp);

    if (HALL_ENABLED && t > STALL_MIN_MS) {
      float rpm = MOTOR_RPM_FULL * dutyCmd;
      uint32_t expectMs = (uint32_t)(60000.0f / (rpm * HALL_MAGNETS));
      if (millis() - lastHallMs > (uint32_t)(expectMs * STALL_FACTOR)) setState(State::STALL);
    }
  }

  // --- LED レインボー（従来と同じ）---
  uint8_t base = millis() / 20;
  fill_rainbow(ledsF, NUM_LED, base, 255 / NUM_LED);
  for (int i = 0; i < NUM_LED; i++) ledsB[i] = ledsF[i];
  FastLED.show();

  if (millis() - lastDraw > 500) { lastDraw = millis(); draw(); }
  delay(16);
}
