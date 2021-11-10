
#define sensorPin A0
int sensorValue = 0;
float voltage;

void setup() {
  Serial.begin(9600);
  delay(100);
}

void loop() {
  sensorValue = analogRead(sensorPin);
  voltage = sensorValue * (5.0 / 1024);

  Serial.print("Tensão do potenciometro: ");
  Serial.print(voltage);

  Serial.print(" | Valor: ");
  Serial.println(sensorValue);

  delay(0);
}
