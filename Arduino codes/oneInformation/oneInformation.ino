
#define sensorPin A0
int sensorValue = 0;
float voltage;

void setup() {
  Serial.begin(115200);
  delay(100);
}

void loop() {
  char str[10];
  sensorValue = analogRead(sensorPin);
  voltage = sensorValue * (5.0/1024);
  
  sprintf(str, "%05d\n", sensorValue);
  Serial.print(str);
  delay(10);
}
