//================================================================//
//
// FINAL PROJECT
// Krzysztof Warmuz ktw272
//
// The Arduino controller takes input from rotor and two buttons
// and sends the state of these three in form of a string.
//
//================================================================//


//================================================================//
// setup function
// - takes A0-1 as the rotor input
// - takes A4-5 as the button inputs
//================================================================//

void setup() {
  pinMode(A0, INPUT);
  pinMode(A1, INPUT);
  pinMode(A4, INPUT);
  pinMode(A5, INPUT);
  Serial.begin(9600);
  Serial.println("HELLO!");
}



//================================================================//
// setup function
// - initialize the rotor inputs and flip the left-rotation signals
// - send serial message on rotation
// - read state of each button
// - send serial message on each button
// - delay not to overmessage the Processing 
//================================================================//

void loop() {
  
  int right = analogRead(A1);
  int left = analogRead(A0);
  int dir = 0;
  if(right>0 && left==0) dir = right;
  if(left>0 && right==0) dir = -left;
  Serial.println(dir);
  
  int red = digitalRead(A4);
  int blue = digitalRead(A5);
  String buttonRed = "redLow";
  String buttonBlue = "blueLow";  
  if(red==HIGH) buttonRed = "redHigh";
  if(blue==HIGH) buttonBlue = "blueHigh";
  Serial.println(buttonRed);
  Serial.println(buttonBlue);
    
  delay(20);
}
