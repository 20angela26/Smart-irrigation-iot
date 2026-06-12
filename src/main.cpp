#include <Arduino.h>
#include <DHT.h>
#include <ArduinoJson.h>
#include <PubSubClient.h>
#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <time.h>


const char* ssid= "iPhone";
const char* password ="angela123";
const char* mqtt_server = "00bb4b8f25504bcb8380dce5fdd8cf37.s1.eu.hivemq.cloud";
const int mqtt_port=8883;
const char* mqtt_user="Parcial2_Datos";
const char* mqtt_pass="Parcial2_Datos";
const char* topic = "Parcial2_Datos";
const char* topic_bomba = "Parcial2_Bomba";

#define DHTPIN 4
#define DHTTYPE DHT11
#define SOIL_PIN 34
#define BOMBA_PIN 26

DHT dht(DHTPIN, DHTTYPE);

WiFiClientSecure espClient;
PubSubClient client(espClient);
const long gmtOffset_sec = -5 * 3600;
const int daylightOffset_sec = 0;


void setup_wifi() {
  delay(10);

  Serial.println();
  Serial.print("Conectando a ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.println("WiFi conectado");
  Serial.println("Dirección IP: ");
  Serial.println(WiFi.localIP());
}

void reconnect_mqtt() {
  while (!client.connected()) {
    Serial.print("Conectando a MQTT... ");

    bool conectado;

    if (strlen(mqtt_user) == 0) {
      conectado = client.connect("ESP32_Riego_01");
    } else {
      conectado = client.connect("ESP32_Riego_01", mqtt_user, mqtt_pass);
    }

    if (conectado) {
      Serial.println("conectado");

      bool suboOk = client.subscribe(topic_bomba);
      Serial.println(suboOk ? "Suscripcion OK" : "Suscripcion FALLO");

    } else {
      Serial.print("fallo, rc=");
      Serial.println(client.state());
      delay(3000);
    }
  }
}

void callback(char* topic, byte* payload, unsigned int length) {
  Serial.println("Callback OK");
  
  String mensaje = "";
  for (unsigned int i = 0; i < length; i++) {
    mensaje += (char)payload[i];
  }

  Serial.print("Topic: ");
  Serial.println(topic);
  Serial.print("Msg: ");
  Serial.println(mensaje);

  if (String(topic) == topic_bomba) {
    if (mensaje == "ON") {
      digitalWrite(BOMBA_PIN, LOW);
      Serial.println("Bomba encendida");
    } else if (mensaje == "OFF") {
      digitalWrite(BOMBA_PIN, HIGH);
      Serial.println("Bomba apagada");
    }
  }
}
void setup() {
  Serial.begin(115200);
  delay(1000);

  pinMode(BOMBA_PIN, OUTPUT);
  digitalWrite(BOMBA_PIN, HIGH);

  dht.begin();
  setup_wifi();

  configTime(gmtOffset_sec, daylightOffset_sec, "pool.ntp.org", "time.nist.gov");
  
  espClient.setInsecure();
  
  client.setServer(mqtt_server, mqtt_port);
  client.setCallback(callback);
  client.setKeepAlive(60);
  client.setSocketTimeout(60);
}

void loop() {
  if (WiFi.status() != WL_CONNECTED) {
    setup_wifi();
  }

  if (!client.connected()) {
    reconnect_mqtt();
  }

  client.loop();

  float humedadAire = dht.readHumidity();
  float temperatura = dht.readTemperature();
  int valorSuelo = analogRead(SOIL_PIN);

  JsonDocument doc;

  
  doc["node_id"] = "ESP32_1";

  if (isnan(humedadAire) || isnan(temperatura)) {
    doc["error"] = "Error leyendo el DHT11";
  } else {
    doc["temperatura"] = temperatura;
    doc["humedad_aire"] = humedadAire;
  }

  doc["humedad_suelo"] = valorSuelo;

  struct tm timeinfo;
  if (getLocalTime(&timeinfo)) {
    char fechaHora[30];
    strftime(fechaHora, sizeof(fechaHora), "%Y-%m-%d %H:%M:%S", &timeinfo);
    doc["timestamp"] = fechaHora;
  } else {
    doc["timestamp"] = "sin_hora";
  }

  char buffer[256];
  serializeJson(doc, buffer);

  bool enviado = client.publish(topic, buffer);

  Serial.println(buffer);
  Serial.println(enviado ? "Datos enviados" : "Error al enviar datos");

  client.loop();
  delay(2000);
}