int sensorValue = 0;
float voltage;
int count = 0;
void setup() {
  Serial.begin(115200);
}

void loop(){
  sensorValue = analogRead(A0);
  
  Serial.print(String(sensorValue) + ',' + String(sensorValue) + ',' + String(sensorValue * 0.15) + ',' + String(sensorValue * 0.15) + "," + String(count) + '\n');

  if(millis() > 5000)
    count = 1;
  delay(200);
}
