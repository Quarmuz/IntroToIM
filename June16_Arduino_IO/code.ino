void setup() {
  pinMode(12, OUTPUT);
  pinMode(13, OUTPUT);
  Serial.begin(9600);
  Serial.println("HELLO!");
}

void loop() {
  int temperatureSensor = analogRead(A0)-162;
  int potentiometer = digitalRead(A1);
  Serial.println("temperature:");
  Serial.println(temperatureSensor);
  Serial.println("ptoentiometer:");
  Serial.println(potentiometer);
  if(temperatureSensor > 0) analogWrite(13, temperatureSensor*100);
  else digitalWrite(13, LOW);
  if(potentiometer == HIGH) {
    if(temperatureSensor < 0) analogWrite(12, -temperatureSensor*100);
    else digitalWrite(12, LOW);
  }
  else digitalWrite(12, LOW);
}
