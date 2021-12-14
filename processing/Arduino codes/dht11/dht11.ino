#include <dht.h>

dht dht11;

int sensorValue = 0;
float voltage;

void setup(){
  Serial.begin(115200);
}

void loop() {
  dht11.read11(A1);
  sensorValue = analogRead(A0);
  String voltageString = String(sensorValue * (5.0 / 1024), 3);
 
  Serial.print(String(sensorValue) + ',' +  dht11.temperature + ',' + dht11.humidity + ',' + String(voltageString) + '\n');
  delay(50);
  // 0,0.00,0.00,0.000\n  18
  // 1024,100.00,100.00,4.999\n 25
}
