int PinAnalogLM35 = 0;
float valAnalog = 0;
float temp = 0;
 
void setup(){
    Serial.begin(9600);
}
 
void loop(){
    if (Serial.available() > 0){
        if (Serial.read() == 116) {
            valAnalog = analogRead(PinAnalogLM35);
            temp = (valAnalog * 500) / 1023;
            Serial.print("o valor é: ");
            Serial.println(temp);
        }
    }
}
