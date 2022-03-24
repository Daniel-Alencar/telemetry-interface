int sensorValue = 0;
float voltage;
int count = 0;
void setup() {
  Serial.begin(115200);
}

void loop() {
  sensorValue = analogRead(A0);
  String voltageString = String(sensorValue * (5.0 / 1024), 3);
 
  Serial.print(String(sensorValue) + ',' + String(voltageString) + ',' + String(sensorValue) + ',' + String(voltageString) + "," + String(count) + ",0" + '\n');

  if(millis() > 10000)
    count = 1;
  delay(50);
}
