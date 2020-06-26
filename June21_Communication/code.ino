//================================================================//
//
// The code translates the motion of a servo motor to string and
// sends it as a string to be read by Processing. Since negative
// voltage is not noted, the left and right motion have sepparate
// inputs, where left-turn sign is being flipped.
//
//================================================================//


void setup() {
  pinMode(A0, INPUT);
  pinMode(A1, INPUT);
  Serial.begin(9600);
  Serial.println("HELLO!");
}

void loop() {
  int right = analogRead(A1);
  int left = analogRead(A0);
  int dir = 0;
  if(right>0 && left==0) dir = right;
  if(left>0 && right==0) dir = -left;
  Serial.println(dir);
  delay(2);
}
