int sensorValue = 0, count = 0, value = 0;
bool notSent = false;

void setup() {
  Serial.begin(115200);
}

void loop(){
  sensorValue = analogRead(A0);
  
  
  Serial.print(String(count * 600) + ',' + String(sensorValue) + ',' + String(sensorValue * 0.15) + ',' + String(sensorValue * 0.15) + "," + String(count) + '\n');
  if(!notSent){
    Serial.println("INICIADO!");
    notSent = true;
  }
  
  if(millis() > 5000)
    count = 1;
  delay(50);
}
