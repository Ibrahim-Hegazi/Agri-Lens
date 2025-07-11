#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>
#include <DHT.h>

// Wi-Fi and backend settings
#define WIFI_SSID "PIXEL"
#define WIFI_PASSWORD "PI#P@ssw0rd_AB94"
const char* loginUrl = "http://agri-lens.runasp.net/api/Account/Login";
const char* getIdsUrl = "http://agri-lens.runasp.net/api/Sensors/get-ids";

// Hardware configuration
int soilPins[3] = {34, 35, 32};
int pumpPins[3] = {27, 14, 12};
DHT dht(33, DHT11);

// Global variables
int farmID = 3;
int temp;
int soilRead[3];
int soilPinsIds[3];  // Exactly as requested
int DHTid;           // Exactly as requested
String user = "arduino1";
String password = "Arduino1234#";
String token;


void getSensorIds() {
  HTTPClient http;
  http.begin(getIdsUrl);
  http.addHeader("Content-Type", "application/json");
  http.addHeader("Authorization", "Bearer " + token);

  StaticJsonDocument<300> jsonDoc;
  jsonDoc["farmId"] = farmID;
  
  JsonArray sensorsTypes = jsonDoc.createNestedArray("sensorsTypes");
  sensorsTypes.add("soil");
  sensorsTypes.add("soil");
  sensorsTypes.add("soil");
  sensorsTypes.add("temperature");

  JsonArray portsNumbers = jsonDoc.createNestedArray("portsNumbers");
  portsNumbers.add(soilPins[0]);
  portsNumbers.add(soilPins[1]);
  portsNumbers.add(soilPins[2]);
  portsNumbers.add(33);

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
        
        int count = 0;
        for (int id : idsArray) {
          if (count < 3) {
            soilPinsIds[count++] = id;  // Using the exact requested variable name
          } else {
            DHTid = id;  // Using the exact requested variable name
          }
        }
        
        Serial.print("DHTid: ");
        Serial.println(DHTid);  // Using the exact requested variable name
        
        // Print soil sensor IDs
        for (int i = 0; i < 3; i++) {
          Serial.print("Soil sensor ");
          Serial.print(i);
          Serial.print(" ID: ");
          Serial.println(soilPinsIds[i]);  // Using the exact requested variable name
        }
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




void sendSensorData() {
  if (WiFi.status() == WL_CONNECTED && token.length() > 0) {
  HTTPClient http;
  http.begin("http://agri-lens.runasp.net/api/SensorDatas");
  http.addHeader("Content-Type", "application/json");
  http.addHeader("Authorization", "Bearer " + token);

  // Build JSON array with 4 objects
  StaticJsonDocument<512> doc; // Adjust size if needed
  JsonArray arr = doc.to<JsonArray>();

  for (int i = 0; i < 3; i++) {
    JsonObject obj = arr.createNestedObject();
    obj["value"] = soilRead[i]; // example value, replace with sensor value
    obj["sensorId"] = soilPinsIds[i]; // example sensorId, replace with real one
  }
   JsonObject obj = arr.createNestedObject();
    obj["value"] = temp; // example value, replace with sensor value
    obj["sensorId"] = DHTid; // example sensorId, replace with real one
  String payload;
  serializeJson(arr, payload);

  Serial.println("Payload to send:");
  Serial.println(payload);

  // Send POST request
  int httpResponseCode = http.POST(payload);

  if (httpResponseCode > 0) {
    String response = http.getString();
    Serial.print("Response code: ");
    Serial.println(httpResponseCode);
    Serial.print("Response body: ");
    Serial.println(response);
  } else {
    Serial.print("POST failed, code: ");
    Serial.println(httpResponseCode);
  }

  http.end();
  } else {
    Serial.println("Wi-Fi not connected or token is empty.");
  }
}


void setup() {
  dht.begin();
  Serial.begin(115200);

  // Initialize pins
  for (int i = 0; i < 3; i++) {
    pinMode(soilPins[i], INPUT);
    pinMode(pumpPins[i], OUTPUT);
    digitalWrite(pumpPins[i], LOW);
  }

  // Connect to WiFi
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  int attempt = 0;
  while (WiFi.status() != WL_CONNECTED && attempt < 10) {
    Serial.print(".");
    delay(300);
    attempt++;
  }

  if (WiFi.status() == WL_CONNECTED) {
    Serial.println();
    Serial.print("Connected with IP: ");
    Serial.println(WiFi.localIP());

    // First API call - Login
    StaticJsonDocument<200> loginDoc;
    loginDoc["username"] = user;
    loginDoc["password"] = password;

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
  } else {
    Serial.println("\nFailed to connect to Wi-Fi after 10 attempts.");
  }
}


void loop() {
  temp = dht.readTemperature();

  for (int i = 0; i < 3; i++) {
    soilRead[i] = analogRead(soilPins[i]);
    float soilMoisturePercentage = 100.0 - (soilRead[i] / 4095.0) * 100.0;
    int soilMoisture = (int)soilMoisturePercentage;

    Serial.print("Soil Moisture Sensor ");
    Serial.print(i + 1);
    Serial.print(": ");
    Serial.println(soilMoisture);

    sendSensorData();

    if (soilMoisture < 7) {
      digitalWrite(pumpPins[i], HIGH); // Turn on pump
    } else {
      digitalWrite(pumpPins[i], LOW);  // Turn off pump
    }

    // Optional: here you could send data to your .NET backend using token
    // using HTTPClient and token as Bearer:
    /*
    if (WiFi.status() == WL_CONNECTED) {
      HTTPClient http;
      http.begin("http://your-backend/api/sensors");
      http.addHeader("Content-Type", "application/json");
      http.addHeader("Authorization", "Bearer " + token);

      StaticJsonDocument<200> dataDoc;
      dataDoc["farmID"] = farmID;
      dataDoc["sensorID"] = i + 1;
      dataDoc["soilMoisture"] = soilMoisture;
      dataDoc["temperature"] = temp;

      String dataPayload;
      serializeJson(dataDoc, dataPayload);

      int res = http.POST(dataPayload);
      if (res > 0) {
        Serial.println("Data sent successfully: " + http.getString());
      } else {
        Serial.print("Failed to send data, code: ");
        Serial.println(res);
      }
      http.end();
    }
    */
  }

  delay(10000);
}