#include <WiFi.h>
#include <PubSubClient.h>
#include <Arduino.h>
#include <IRremoteESP8266.h>
#include <IRsend.h>

#define IR_PIN 4
IRsend irsend(IR_PIN);

// TODO: add transistor to circuit to increase current thru LED
// TODO: add comments

/*
  COMMAND LIST:
  0x0 ON
  0x1 OFF
  0x2 TIME
  0x3 SPEED
  0x4 R
  0x5 G
  0x6 B
  0x7 W
  0x8 orange
  ...
  
  Commands go left to right across the row, then down columns
  
  0xC second orange
  0x10 third orange
  0x14 yellow
  0x17 asyn jump
*/

#define LED_CMD_ON 0x0
#define LED_CMD_OFF 0x1
#define LED_CMD_TIME 0x2
#define LED_CMD_SPEED 0x3

#define LED_CMD_RED 0x4
#define LED_CMD_GREEN 0x5
#define LED_CMD_BLUE 0x6
#define LED_CMD_WHITE 0x7
#define LED_CMD_ORANGE 0x8

bool led_state = false;

// WiFi
#define WIFI_SSID "24WardellWifi"   // Wi-Fi name
#define WIFI_PASSWORD "6469155996"  // Wi-Fi password

// MQTT Broker
const char *mqtt_broker = "broker.emqx.io";
const char *topic = "emqx/esp32";
const char *mqtt_username = "emqx";
const char *mqtt_password = "public";
const int mqtt_port = 1883;

WiFiClient espClient;
PubSubClient client(espClient);

void setup() {
    Serial.begin(115200);

    irsend.begin();

    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.println("Connecting to WiFi..");
    }
    Serial.println("Connected to the Wi-Fi network");
    
    client.setServer(mqtt_broker, mqtt_port);
    client.setCallback(callback);
    while (!client.connected()) {
        String client_id = "esp32-client-";
        client_id += String(WiFi.macAddress());
        
        Serial.printf("Client %s connecting to the public MQTT broker...\n", client_id.c_str());
        
        if (client.connect(client_id.c_str(), mqtt_username, mqtt_password)) {
            Serial.println("Public EMQX MQTT broker connected");
        } else {
            Serial.print("failed with state ");
            Serial.print(client.state());
            delay(2000);
        }
    }

    // client.publish(topic, "Hi, I'm ESP32 ^^");
    client.subscribe(topic);
}

void callback(char *topic, byte *payload, unsigned int length) {
    /*Serial.print("Message arrived in topic: ");
    Serial.println(topic);
    Serial.print("Message:");
    for (int i = 0; i < length; i++) {
        Serial.print((char) payload[i]);
    }
    Serial.println();
    Serial.println("-----------------------");*/

    String cmd = String((char *)payload, length);
    cmd.toLowerCase();

    Serial.println(cmd);

    if (cmd == "on") {
      set_led_state(true);
    } else if (cmd == "red") {
      set_led_color(LED_CMD_RED);
    } else if (cmd == "off") {
      set_led_state(false);
    } else {
      // TODO: default cmd
      set_led_color(LED_CMD_BLUE);
    }
}

void set_led_state(bool state) {
  // Do nothing if led_state is already the passed-in state
  // TODO: maybe add bruteforce optional parameter that is true for "ON"/"OFF" only in case this led_state variable gets out of sync
  if (led_state == state)
    return;
    
  led_state = state;
  
  if (state) {
    send_cmd(LED_CMD_ON);
  } else {
    send_cmd(LED_CMD_OFF);
  }
}

void set_led_color(uint16_t color) {
  set_led_state(true);
  send_cmd(color);
}

void send_cmd(uint16_t cmd) {
  irsend.sendNEC(irsend.encodeNEC(0xEF00, cmd));
  Serial.printf("Sent command: %d\n", cmd);
  delay(100);
}

void loop() {
    client.loop();
}
