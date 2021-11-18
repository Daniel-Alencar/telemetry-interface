
#define sensorPin A0
int sensorValue = 0;
float voltage;

void setup() {
  Serial.begin(115200);
  delay(100);
}

void loop() {
  sensorValue = analogRead(sensorPin);
  voltage = sensorValue * (5.0/1024);

  Serial.println(sensorValue);
  delay(100);
}
