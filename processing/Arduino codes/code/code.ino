int sensorValue = 0;
float voltage;

void setup() {
  Serial.begin(115200);
}

void loop() {
  sensorValue = analogRead(A0);
  String voltageString = String(sensorValue * (5.0 / 1024), 3);
 
  Serial.print(String(sensorValue) + ',' + voltageString + ',' + sensorValue + ',' + String(voltageString) + '\n');
  delay(50);
}
