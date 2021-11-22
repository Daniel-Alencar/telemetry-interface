
#define sensorPin A0
int sensorValue = 0;
float voltage;

void setup() {
  Serial.begin(9600);
  delay(100);
}

void loop() {
  sensorValue = analogRead(sensorPin);
  voltage = sensorValue * (5.0/1024);

  String result;
  result = String(sensorValue) + "," + String(voltage) + "," + String(sensorValue) + "," + String(voltage);
  Serial.println(result);
  
  delay(1000);
}
