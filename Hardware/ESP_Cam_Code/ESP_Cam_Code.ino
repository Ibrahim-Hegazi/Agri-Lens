#include <Arduino.h>
#include <WiFi.h>
#include <WiFiClient.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>
#include "soc/soc.h"
#include "soc/rtc_cntl_reg.h"
#include "esp_camera.h"
#include "img_converters.h"
#include <AccelStepper.h>

// WiFi credentials
const char* ssid = "PIXEL";
const char* wifiPassword = "PI#P@ssw0rd_AB94"; 

// Server configuration
const char* loginUrl = "http://agri-lens.runasp.net/api/Account/Login";
const char* getIdsUrl = "http://agri-lens.runasp.net/api/Sensors/get-ids"; 
const char* imageServerHost = "192.168.1.28";
const int imageServerPort = 8000;

// User credentials
String user = "arduino1";
String userPassword = "Arduino1234#"; 
String token;
int cameraId;
int farmID = 3; 

WiFiClient client;

// Stepper setup
#define dirPin  12
#define stepPin 14
AccelStepper stepper(AccelStepper::DRIVER, stepPin, dirPin);
const int stepsBetweenCells = 1700;
int currentPosition = 0;

// Camera pin config
#define PWDN_GPIO_NUM     32
#define RESET_GPIO_NUM    -1
#define XCLK_GPIO_NUM      0
#define SIOD_GPIO_NUM     26
#define SIOC_GPIO_NUM     27
#define Y9_GPIO_NUM       35
#define Y8_GPIO_NUM       34
#define Y7_GPIO_NUM       39
#define Y6_GPIO_NUM       36
#define Y5_GPIO_NUM       21
#define Y4_GPIO_NUM       19
#define Y3_GPIO_NUM       18
#define Y2_GPIO_NUM        5
#define VSYNC_GPIO_NUM    25
#define HREF_GPIO_NUM     23
#define PCLK_GPIO_NUM     22
#define FLASH_LED_PIN      4

bool flashState = false;
bool autoSequence = true;
bool firstRunDone = false;

unsigned long lastAutoSequence = 0;
unsigned long lastCaptureTime = 0;
unsigned long autoSequenceInterval = 3600000;
unsigned long captureInterval = 2000;

void configInitCamera() {
  camera_config_t config;
  config.ledc_channel = LEDC_CHANNEL_0;
  config.ledc_timer = LEDC_TIMER_0;
  config.pin_d0 = Y2_GPIO_NUM;
  config.pin_d1 = Y3_GPIO_NUM;
  config.pin_d2 = Y4_GPIO_NUM;
  config.pin_d3 = Y5_GPIO_NUM;
  config.pin_d4 = Y6_GPIO_NUM;
  config.pin_d5 = Y7_GPIO_NUM;
  config.pin_d6 = Y8_GPIO_NUM;
  config.pin_d7 = Y9_GPIO_NUM;
  config.pin_xclk = XCLK_GPIO_NUM;
  config.pin_pclk = PCLK_GPIO_NUM;
  config.pin_vsync = VSYNC_GPIO_NUM;
  config.pin_href = HREF_GPIO_NUM;
  config.pin_sccb_sda = SIOD_GPIO_NUM;
  config.pin_sccb_scl = SIOC_GPIO_NUM;
  config.pin_pwdn = PWDN_GPIO_NUM;
  config.pin_reset = RESET_GPIO_NUM;
  config.xclk_freq_hz = 20000000;
  config.pixel_format = PIXFORMAT_RGB565;
  config.frame_size = FRAMESIZE_QVGA;
  config.jpeg_quality = 10;
  config.fb_count = 1;
  config.fb_location = CAMERA_FB_IN_PSRAM;
  config.grab_mode = CAMERA_GRAB_LATEST;

  esp_err_t err = esp_camera_init(&config);
  if (err != ESP_OK) {
    Serial.printf("Camera init failed with error 0x%x\n", err);
    delay(1000);
    ESP.restart();
  }
  Serial.println("Camera initialized successfully!");
}

size_t convertRGB565ToJpeg(camera_fb_t* fb, uint8_t** jpeg_buf) {
  if (!fb) return 0;
  *jpeg_buf = (uint8_t*)malloc(fb->len);  
  if (*jpeg_buf == NULL) return 0;
  size_t jpeg_len = 0;
  bool success = fmt2jpg(fb->buf, fb->len, fb->width, fb->height, PIXFORMAT_RGB565, 80, jpeg_buf, &jpeg_len);
  if (!success) {
    free(*jpeg_buf);
    return 0;
  }
  return jpeg_len;
}


String uploadImageToServer(int cellNumber) {
  Serial.println("📸 Taking a photo for cell " + String(cellNumber) + "...");

  camera_fb_t * fb = esp_camera_fb_get();
  if (!fb) return "❌ Camera capture failed";

  uint8_t* jpeg_buf = NULL;
  size_t jpeg_len = convertRGB565ToJpeg(fb, &jpeg_buf);
  esp_camera_fb_return(fb);
  if (jpeg_len == 0) return "❌ JPEG conversion failed";

  if (!client.connect(imageServerHost, imageServerPort)) {
    free(jpeg_buf);
    return "❌ Connection to image server failed.";
  }

  String boundary = "----WebKitFormBoundary7MA4YWxkTrZu0gW";
  String header = "POST /upload/" + String(cellNumber) + " HTTP/1.1\r\n";
  header += "Host: " + String(imageServerHost) + "\r\n";
  header += "Content-Type: multipart/form-data; boundary=" + boundary + "\r\n";
  header += "Authorization: Bearer " + token + "\r\n"; // Added authorization header

  String body = "--" + boundary + "\r\n";
  body += "Content-Disposition: form-data; name=\"file\"; filename=\"cell" + String(cellNumber) + "_" + String(millis()) + ".jpg\"\r\n";
  body += "Content-Type: image/jpeg\r\n\r\n";
  String footer = "\r\n--" + boundary + "--\r\n";

  size_t contentLength = body.length() + jpeg_len + footer.length();
  header += "Content-Length: " + String(contentLength) + "\r\n\r\n";

  client.print(header + body);
  client.write(jpeg_buf, jpeg_len);
  client.print(footer);

  String response = "";
  while (client.connected()) {
    if (client.available()) {
      response += client.readStringUntil('\r');
    }
  }

  client.stop();
  free(jpeg_buf);
  Serial.println("📨 Server response: " + response);
  return response.indexOf("200 OK") > 0 ? "✅ Uploaded!" : "❌ Upload failed!";
}

void rotateStepper(int steps) {
  stepper.move(steps);
  while (stepper.distanceToGo() != 0) {
    stepper.run();
  }
  currentPosition += steps;
}

void runFullSequenceAndUploadBatch() {
  Serial.println("📸 Capturing images and sending batch request...");

  const int numCells = 3;
  int potsNum[numCells] = {1, 2, 3};
  int sensorIds[numCells] = {cameraId, cameraId, cameraId};

  camera_fb_t* images[numCells] = {nullptr, nullptr, nullptr};
  size_t jpegLens[numCells] = {0, 0, 0};
  uint8_t* jpegBuffers[numCells] = {nullptr, nullptr, nullptr};

  String boundary = "----ESP32Boundary";
  String crlf = "\r\n";

  // 1️⃣ Capture images
  for (int i = 0; i < numCells; i++) {
    rotateStepper((i * stepsBetweenCells) - currentPosition);
    delay(captureInterval);

    images[i] = esp_camera_fb_get();
    if (!images[i]) {
      Serial.println("❌ Failed to capture image for cell " + String(i+1));
      return;
    }

    jpegLens[i] = convertRGB565ToJpeg(images[i], &jpegBuffers[i]);
    esp_camera_fb_return(images[i]);
    if (jpegLens[i] == 0) {
      Serial.println("❌ JPEG conversion failed for cell " + String(i+1));
      return;
    }

    currentPosition = i * stepsBetweenCells;
  }

  // 2️⃣ Build multipart parts
  String partHeaders[numCells];
  for (int i = 0; i < numCells; i++) {
    unsigned long timestamp = millis() / 1000;

    partHeaders[i]  = "--" + boundary + crlf;
    partHeaders[i] += "Content-Disposition: form-data; name=\"files\"; filename=\"cell" 
                   + String(i+1) + "_" + String(timestamp) + ".jpg\"" + crlf;
    partHeaders[i] += "Content-Type: image/jpeg" + crlf + crlf;
  }


  String textParts = "";

  // potsNum[]
  for (int i = 0; i < numCells; i++) {
    textParts += "--" + boundary + crlf;
    textParts += "Content-Disposition: form-data; name=\"potsNum\"" + crlf + crlf;
    textParts += String(potsNum[i]) + crlf;
  }

  // sensorId[]
  for (int i = 0; i < numCells; i++) {
    textParts += "--" + boundary + crlf;
    textParts += "Content-Disposition: form-data; name=\"sensorsId\"" + crlf + crlf;
    textParts += String(sensorIds[i]) + crlf;
  }

  // Final boundary
  String finalBoundary = "--" + boundary + "--" + crlf;

  // 3️⃣ Calculate total payload size
  size_t totalSize = 0;
  for (int i = 0; i < numCells; i++) {
    totalSize += partHeaders[i].length();  // text header
    totalSize += jpegLens[i];              // binary data
    totalSize += crlf.length();            // after each file, add CRLF
  }
  totalSize += textParts.length();
  totalSize += finalBoundary.length();

  // 4️⃣ Allocate buffer
  uint8_t* payload = (uint8_t*)malloc(totalSize);
  if (!payload) {
    Serial.println("❌ Failed to allocate memory for payload.");
    return;
  }

  // 5️⃣ Fill payload buffer
  size_t pos = 0;

  for (int i = 0; i < numCells; i++) {
    memcpy(payload + pos, partHeaders[i].c_str(), partHeaders[i].length());
    pos += partHeaders[i].length();

    memcpy(payload + pos, jpegBuffers[i], jpegLens[i]);
    pos += jpegLens[i];

    memcpy(payload + pos, crlf.c_str(), crlf.length());
    pos += crlf.length();
  }

  memcpy(payload + pos, textParts.c_str(), textParts.length());
  pos += textParts.length();

  memcpy(payload + pos, finalBoundary.c_str(), finalBoundary.length());
  pos += finalBoundary.length();

  // Sanity check
  if (pos != totalSize) {
    Serial.println("❌ Size mismatch in payload build!");
    free(payload);
    return;
  }

  // 6️⃣ Send HTTP POST
  HTTPClient http;
  String url = "http://agri-lens.runasp.net/api/sensorDatas/upload-image/" + String(farmID);

  http.begin(url);
  http.addHeader("Content-Type", "multipart/form-data; boundary=" + boundary);
  http.addHeader("Authorization", "Bearer " + token);

  int httpCode = http.POST(payload, totalSize);

  Serial.print("📨 Upload response code: ");
  Serial.println(httpCode);

  if (httpCode > 0) {
    String response = http.getString();
    Serial.println("✅ Response: " + response);
  } else {
    Serial.print("❌ HTTP POST failed: ");
    Serial.println(http.errorToString(httpCode));
  }

  http.end();

  // 7️⃣ Free memory
  free(payload);
  for (int i = 0; i < numCells; i++) {
    if (jpegBuffers[i]) free(jpegBuffers[i]);
  }

  rotateStepper(-currentPosition);
  currentPosition = 0;
}





void getSensorIds() {
  HTTPClient http;
  http.begin(getIdsUrl);
  http.addHeader("Content-Type", "application/json");
  http.addHeader("Authorization", "Bearer " + token);

  StaticJsonDocument<300> jsonDoc;
  jsonDoc["farmId"] = farmID;
  
  JsonArray sensorsTypes = jsonDoc.createNestedArray("sensorsTypes");
  sensorsTypes.add("camera");

  JsonArray portsNumbers = jsonDoc.createNestedArray("portsNumbers");
  portsNumbers.add(32);

  String payload;
  serializeJson(jsonDoc, payload);

  int httpResponseCode = http.POST(payload);

  if (httpResponseCode > 0) {
    String response = http.getString();
    Serial.print("Sensor IDs response code: ");
    Serial.println(httpResponseCode);
    Serial.print("Response body: ");
    Serial.println(response);

    StaticJsonDocument<200> responseDoc;
    DeserializationError error = deserializeJson(responseDoc, response);

    if (!error) {
      if (responseDoc.is<JsonArray>()) {
        JsonArray idsArray = responseDoc.as<JsonArray>();
        Serial.println("Received sensor IDs:");
        
        for (int id : idsArray) {
          cameraId = id;
        }
        
        Serial.print("cameraId: ");
        Serial.println(cameraId);
      } else {
        Serial.println("Response is not an array");
      }
    } else {
      Serial.println("Failed to parse sensor IDs JSON response");
    }
  } else {
    Serial.print("Sensor IDs POST failed, error code: ");
    Serial.println(httpResponseCode);
  }
  http.end();
}

void runSingleCellSequence(int cellNumber) {
  if (cellNumber < 1 || cellNumber > 3) return;
  int targetPosition = (cellNumber - 1) * stepsBetweenCells;
  int stepsToMove = targetPosition - currentPosition;
  rotateStepper(stepsToMove);
  delay(captureInterval);
  Serial.println(uploadImageToServer(cellNumber));
  rotateStepper(-currentPosition);
}

void runFullSequence() {
  for (int i = 1; i <= 3; i++) {
    int targetPosition = (i - 1) * stepsBetweenCells;
    int stepsToMove = targetPosition - currentPosition;
    rotateStepper(stepsToMove);
    if (millis() - lastCaptureTime >= captureInterval) {
      Serial.println(uploadImageToServer(i));
      lastCaptureTime = millis();
    }
    delay(1000);
  }
  rotateStepper(-currentPosition);
}

void setup() {
  WRITE_PERI_REG(RTC_CNTL_BROWN_OUT_REG, 0);
  Serial.begin(115200);
  pinMode(FLASH_LED_PIN, OUTPUT);
  digitalWrite(FLASH_LED_PIN, LOW);

  stepper.setMaxSpeed(1000);
  stepper.setAcceleration(500);
  configInitCamera();

  WiFi.begin(ssid, wifiPassword);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500); 
    Serial.print(".");
  }
  Serial.println("\nWiFi connected!");

  if (WiFi.status() == WL_CONNECTED) {
    Serial.println();
    Serial.print("Connected with IP: ");
    Serial.println(WiFi.localIP());

    // First API call - Login
    StaticJsonDocument<200> loginDoc;
    loginDoc["username"] = user;
    loginDoc["password"] = userPassword;

    String loginPayload;
    serializeJson(loginDoc, loginPayload);

    HTTPClient http;
    http.begin(loginUrl);
    http.addHeader("Content-Type", "application/json");

    int httpResponseCode = http.POST(loginPayload);

    if (httpResponseCode > 0) {
      String response = http.getString();
      Serial.print("Login response code: ");
      Serial.println(httpResponseCode);
      Serial.print("Response body: ");
      Serial.println(response);

      StaticJsonDocument<200> responseDoc;
      DeserializationError error = deserializeJson(responseDoc, response);
      if (!error) {
        token = responseDoc["token"].as<String>();
        Serial.print("Received token: ");
        Serial.println(token);
        
        // Second API call - Get Sensor IDs (only if we got a token)
        if (token.length() > 0) {
          getSensorIds();
        }
      } else {
        Serial.println("Failed to parse login JSON response");
      }
    } else {
      Serial.print("Login POST failed, error code: ");
      Serial.println(httpResponseCode);
    }
    http.end();
  }

  Serial.println("System ready!");
}

void loop() {
  if (!firstRunDone) {
    // Run immediately the first time
    runFullSequenceAndUploadBatch();
    lastAutoSequence = millis();
    firstRunDone = true;
  } 
  else if (autoSequence && (millis() - lastAutoSequence > autoSequenceInterval)) {
    runFullSequenceAndUploadBatch();
    lastAutoSequence = millis();
  }

  delay(100);
}