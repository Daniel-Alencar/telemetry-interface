int sensorValue = 0;
float voltage;
int count = 0;

int value = 0;

void setup() {
  Serial.begin(115200);
}

void loop(){
  sensorValue = analogRead(A0);

  if(millis() % 50 == 0){
    value = !value;
  }
  
  Serial.print(String(600 * value) + ',' + String(sensorValue) + ',' + String(sensorValue * 0.15) + ',' + String(sensorValue * 0.15) + "," + String(count) + '\n');
  
  if(millis() > 5000)
    count = 1;
  delay(50);
}
