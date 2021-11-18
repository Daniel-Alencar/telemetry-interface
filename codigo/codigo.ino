int PinAnalogLM35 = 0;
float valAnalog = 0;
float temp = 0;
 
void setup(){
    Serial.begin(9600);
}
 
void loop(){

            valAnalog = analogRead(PinAnalogLM35);

            Serial.println(valAnalog);
            delay(100);
}
