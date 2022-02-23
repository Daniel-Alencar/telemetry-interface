
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

  char result[29];
  String voltageString = String(voltage, 5);

  sprintf(result, "%05d,%s,%05d,%s\n", sensorValue, voltageString.c_str(), sensorValue, voltageString.c_str());
  Serial.print(result);
  
  delay(250);
}
