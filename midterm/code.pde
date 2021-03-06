//================================================================//
//
// MIDTERM PROJECT
// Krzysztof Warmuz ktw272
//
// The user controlls a small spaceship and is supposed to clear
// all meteorites by pushing them into the black holes and
// progress to the next stage. It can be done either by colliding
// or shooting bullets at them. If the player falls him-or-herself
// into one of the black holes - it means defeat and the stage is
// restarted.
//
// The control of the spaceship is taken by clicking it with mouse
// and pulling back a sling. Releasing the string fuels the ship
// in the direction opposite to the pull. Bullets can be shoot by
// spacebar.
//
// The ammount of meteorites and black holes is randomized, but
// its upper cap increases with each stage. The initial positions
// are also random.
//
// Every fifth stage is upgraded to the boss stage, where black
// holes are replaced with the moving enemy. The rules are the
// same, push all meteorites into the boss avoiding falling in
// yourself.
//
//================================================================//



                                                        //========//
                                                        // IMPORTS
                                                        //========//

//================================================================//
// import the sound library
//================================================================//

import processing.sound.*;


                                                //================//
                                                // OBJECT CLASSES
                                                //================//

//================================================================//
// Circle superclass,
// all in-game objects inherit from it
//   - position, velocity radius and texture of an object
//   - constructor and copy constructor (unused, only for the sake
//     of generality)
//   - functions for touching or being inside the object
//     - touch function additionally adds small 'pushback' effect
//       if one object would be to intersect another
//   - function for changing movement, including slowing down and
//     colliding with walls or other Circles
//     - collisions are based on mass-related normal velocity
//       exhcange
//   - display function, including the direction-related rotation
//   - update facade function, calls all functions that are needed
//     for per-frame update
//   - shoot function (again, unused and kept for the sake of
//     generality
//================================================================//

class Circle{
  
  float rad;
  PVector  pos;
  PVector vel;
  PVector dir;
  color col;
  PImage tex;
  float mass;
  
  Circle(float r, float pX, float pY, float vX, float vY, color c, String t){
    rad = r;
    pos = new PVector(pX, pY);
    vel = new PVector(vX, vY);
    col = c;
    tex = loadImage(t);
    tex.resize(int(2*rad), int(2*rad));
    dir = new PVector(1, 0);
    mass = 0.5;
  }
  
  Circle clone(){
    return new Circle(0, 0, 0, 0, 0, 0, "0" );
  }
  
  boolean inside(float x, float y){
    return ( (pos.x-x)*(pos.x-x)+(pos.y-y)*(pos.y-y) < rad*rad );
  }
  
  boolean inside(Circle C){
    return inside(C.pos.x, C.pos.y);
  }
  
  boolean touch(Circle C){
    if(dist(pos.x, pos.y, C.pos.x, C.pos.y) <= rad+C.rad){
      boolean ret = (pos.x-C.pos.x)*(vel.x-C.vel.x)+(pos.y-C.pos.y)*(vel.y-C.vel.y) < 0;
      pos.add(PVector.sub(pos, C.pos).mult(0.1));
      C.pos.add(PVector.sub(C.pos, pos).mult(0.1));
      return ret;
    }
    return false;
  }
  
  void move(){
    vel.limit(400*tension);
    pos = pos.add(vel);
    pos.set(constrain(pos.x, rad, height-rad), constrain(pos.y, rad, height-rad));
    if(vel.mag()!=0) dir = vel.copy().normalize();
  }
  
  void display(){
    noFill();
    stroke(col);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(dir.heading());
    circle(0, 0, rad*2);
    pushMatrix();
    rotate(PI/2);
    image(tex, -rad, -rad);
    popMatrix();
    popMatrix();
  }
  
  void collidewalls(){
    if( (pos.x<=rad && vel.x<0) || (pos.x>=width-rad && vel.x>0) ) vel.x = -vel.x;
    if( (pos.y<=rad && vel.y<0) || (pos.y>=height-rad && vel.y>0) ) vel.y = -vel.y;
  }
  
  void slow(){
    if(vel.mag()<0.1) vel=new PVector(0, 0);
    else vel = vel.add(-fric*vel.x, -fric*vel.y);
  }
  
  void update(){ 
    display();
    if(WIN==0){
      collidewalls();
      move();
      slow();
    }
  }
  
  void collide(Circle C){
    vel.limit(400*tension);
    C.vel.limit(400*tension);
    float t = atan( (pos.y-C.pos.y)/(pos.x-C.pos.x) );
    float vr = vel.x*cos(t) + vel.y*sin(t);
    float vt = vel.x*sin(t) + vel.y*cos(t);
    float cvr = C.vel.x*cos(t) + C.vel.y*sin(t);
    float cvt = C.vel.x*sin(t) + C.vel.y*cos(t);
    vel = new PVector( cvr*cos(t)*C.mass+vt*sin(t)*mass, cvr*sin(t)*C.mass+vt*cos(t)*mass );
    vel.mult(1/mass);
    C.vel = new PVector( vr*cos(t)*mass+cvt*sin(t)*C.mass, vr*sin(t)*mass+cvt*cos(t*C.mass) );
    C.vel.mult(1/C.mass);
  }
  
  void shoot(){
    return;
  }
  
}


//================================================================//
// Player class
// Circle controlled by player via mouse and keybord
//   - overwritten usabel clone function
//   - display function adding pullback line
//   - update function adding pullback-controlle velocity addition
//   - overwritten usable shoot function, (called in action
//     listenersby spacebar)
//================================================================//

class Player extends Circle{
  
  boolean pull;
  
  Player(float r, float pX, float pY){
    super(r, pX, pY, 0, 0, color(255, 0, 0), "falcon.png");
  }
  
  Player clone(){
    return new Player(rad, pos.x, pos.y);
  }
    
  void display(){
    super.display();
    if(pull)
      line(pos.x, pos.y, mouseX, mouseY);
  }
  
  void update(){
    super.update();
    if(WIN==0 && mousePressed && inside(mouseX, mouseY) ){
      pull = true;
    }
    if( !mousePressed ){
      if(pull){
        vel=vel.add((pos.x-mouseX)*tension, (pos.y-mouseY)*tension);
      }
      pull = false;
    }
  }
  
  void shoot(){
    PVector bVel = vel.copy();
    PVector tVel = dir.copy().setMag(10);
    bVel.add(tVel);
    PVector pVel = dir.copy().setMag(rad+10);
    B.append(new Bullet(10, pos.x+pVel.x+1, pos.y+pVel.y, bVel.x, bVel.y));
  }
  
}


//================================================================//
// Bullet class
// (created by shoot function)
//================================================================//

class Bullet extends Circle{
  
  Bullet(float r, float pX, float pY, float vX, float vY){
    super(r, pX, pY, vX, vY, color(255, 0, 0), "puck.png");
    mass = 0.5;
  }

}


//================================================================//
// Puck class
// Objects indirectly controlled by Player or Bullet collissions
//   - overwritten usabel clone function
//================================================================//

class Puck extends Circle{
  
  Puck(float r, float pX, float pY){
    super(r, pX, pY, 0, 0, color(0), "puck.png");
    mass = rad/25;
  }
  
  Puck clone(){
    return new Puck(rad, pos.x, pos.y);
  }
  
}


//================================================================//
// Hole class
// Non-controlled objects 'sucking in' both Player and Pucks
//   - overwritten usabel clone function
//================================================================//

class Hole extends Circle{
  
  Hole(float r, float pX, float pY){
    super(r, pX, pY, 0, 0, color(0), "hole.png");
  }
  
  Hole clone(){
    return new Hole(rad, pos.x, pos.y);
  }
  
}


//================================================================//
// Boss class
// Self-controlled type of Hole
//   - overwritten usabel clone function
//   - overwritten display function including 'look-at-Player'
//     txture altering
//     - one texture to look right and other to look left
//     - seems like refletion matrices in Processing are
//       non-trivial
//   - slowing function overwrittento do nothing (maintain
//     movement)
//   - overwritten usable shoot function (called periodically by
//     update function of aggregating object)
//================================================================//

class Boss extends Hole{
  
  PImage tex2;
  
  Boss(float r, float pX, float pY, float v){
    super(r, pX, pY);
    tex = loadImage("cromulon.png");
    tex.resize(int(2*rad), int(2*rad));
    tex2 = loadImage("cromulon2.png");
    tex2.resize(int(2*rad), int(2*rad));
    vel.y = v;
  }
  
  Boss clone(){
    return new Boss(rad, pos.x, pos.y, vel.y);
  }
  
  void display(){
    noFill();
    stroke(col);
    pushMatrix();
    translate(pos.x, pos.y);
    circle(0, 0, rad*2);
    if(P.length()>0 && P.get(0).pos.x>pos.x) image(tex, -rad, -rad);
    else image(tex2, -rad, -rad);
    popMatrix();
  }
  
  void slow(){
    return;
  }
  
  void shoot(){
    float ang;
    for(int i=0; i<12; i++){
      ang = i*PI/6;
      B2.append(new BossBullet(20, pos.x+rad*cos(ang), pos.y+rad*sin(ang), 10*cos(ang), 15*sin(ang)));
    }
  }
  
}


//================================================================//
// BossBullet class
// alternative type of bullets
// (created by Boss class shoot function)
//   - again, overwritten display function including
//     'look-at-Player' txture altering
//================================================================//

class BossBullet extends Bullet{
  
  PImage tex2;
  
  BossBullet(float r, float pX, float pY, float vX, float vY){
    super(r, pX, pY, vX, vY);
    col = color(0);
    tex = loadImage("cromulon.png");
    tex.resize(int(2*rad), int(2*rad));
    tex2 = loadImage("cromulon2.png");
    tex2.resize(int(2*rad), int(2*rad));
    mass = 1;
  }

  void display(){
    noFill();
    stroke(col);
    pushMatrix();
    translate(pos.x, pos.y);
    circle(0, 0, rad*2);
    if(P.length()>0 && P.get(0).pos.x>pos.x) image(tex, -rad, -rad);
    else image(tex2, -rad, -rad);
    popMatrix();
  }

}



                                            //====================//
                                            // AGGREGATION CLASSES
                                            //====================//

//================================================================//
// CircleList class
// General class for aggregating Circle class objects
//   - indirect getters and setters for ArrayList of Circles
//   - update function for all aggregated objects
//   - collide functions checking for all possible collisions
//     with other aggregating object or self
//================================================================//

class CircleList{
  
  ArrayList<Circle> C;
  
  CircleList(){
    C = new ArrayList<Circle>(0);
  }
  
  CircleList(CircleList CL){
    C = new ArrayList<Circle>(0);
    for(int i=0; i<CL.length(); i++)
      C.add(CL.C.get(i).clone());
  }
  
  Circle get(int n){
    return C.get(n);
  }
  
  boolean empty(){
    return C.size()==0;
  }
  
  int length(){
    return C.size();
  }
  
  void append(Circle c){
    C.add(c);
  }
  
  void update(){
    for(int i=0; i<C.size(); i++){
      C.get(i).update();
    }
  }
  
  void collide(CircleList CL){
    Circle Ci;
    Circle Cj;
    for(int i=0; i<C.size(); i++){
      Ci = C.get(i);
      for(int j=0; j<CL.C.size(); j++){
        Cj = CL.C.get(j);
        if(Ci.touch(Cj)) Ci.collide(Cj);
      }
    }
  }
  
  void collide(){
    Circle Ci;
    Circle Cj;
    for(int i=0; i<C.size(); i++){
      Ci = C.get(i);
      for(int j=0; j<C.size(); j++){
        Cj = C.get(j);
        if(i!=j && Ci.touch(Cj)) Ci.collide(Cj);
      }
    }
  }
  
}


//================================================================//
// PlayerList class
// stores Player class object
//   - added shoot functions calling shoot for all aggregated
//     Players
//================================================================//

class PlayerList extends CircleList{
  
  PlayerList(){
    super();
  }
  
  PlayerList(CircleList CL){
    super(CL);
  }
  
  void shoot(){
    for(int i=0; i<length(); i++){
      C.get(i).shoot();
    }
  }
  
}


//================================================================//
// BulletList class
// stores Bullet class objects
//   - overwritten update function removing bullets after they
//     slow down beneath certain treshold
//   - updated collide function to remove bullets upon collisions
//================================================================//

class BulletList extends CircleList{
  
  BulletList(){
    super();
  }
  
  void update(){
    for(int i=0; i<C.size(); i++){
      C.get(i).update();
      if(C.get(i).vel.mag()<0.1) C.remove(i);
    }
  }
  
  void collide(CircleList CL){
    Circle Ci;
    Circle Cj;
    for(int i=0; i<C.size(); i++){
      Ci = C.get(i);
      for(int j=0; j<CL.C.size(); j++){
        Cj = CL.C.get(j);
        if(Ci.touch(Cj)){
          Ci.collide(Cj);
          C.remove(i);
        }
      }
    }
  }
  
}


//================================================================//
// HoleList class
// aggregates Hole class objects
//   - updated collide function to remove objects that fall into
//     the Hole
//     - checks for inside rather than touch function
//================================================================//

class HoleList extends CircleList{
  
  HoleList(){
    super();
  }
  
  HoleList(CircleList CL){
    super(CL);
  }
  
  void collide(CircleList CL){
    Circle Ci;
    Circle Cj;
    for(int i=0; i<C.size(); i++){
      Ci = C.get(i);
      for(int j=0; j<CL.C.size(); j++){
        Cj = CL.C.get(j);
        if(Ci.inside(Cj)) CL.C.remove(j);
      }
    }
  }
  
}


//================================================================//
// BossList class
// type of HoleList that aggregates Boss class objects
//   - overwritte update function to periodically call shoot
//     function
//     - active only when WIN state variable is set to active game
//       (0)
//   - added shoot function that calls shoot for all aggregated
//     Bosses
//================================================================//

class BossList extends HoleList{
  
  BossList(){
    super();
  }
  
  BossList(CircleList CL){
    super(CL);
  }
  
  void update(){
    super.update();
    if(WIN==0 && frameCount%50==0) shoot();
  }
  
  void shoot(){
    for(int i=0; i<length(); i++){
      C.get(i).shoot();
    }
  }
  
}


//================================================================//
// BossBulletList class
// type of BulletList that aggregate BossBullet class objects
//   - overwritten update function so that BossBullets disappear
//     upon reaching the walls
//================================================================//

class BossBulletList extends BulletList{
  
  BossBulletList(){
    super();
  }
  
  void update(){
    Circle temp;
    for(int i=0; i<C.size(); i++){
      temp = C.get(i);
      if(temp.pos.x<=temp.rad || temp.pos.x>=width-temp.rad || temp.pos.y<=temp.rad || temp.pos.y>=height-temp.rad){
        C.remove(i);
        continue;
      }
      C.get(i).update();
      if(C.get(i).vel.mag()<0.1) C.remove(i);
    }
  }
  
}



                                          //======================//
                                          // NON-OBJECT INSTANCES
                                          //======================//

//================================================================//
// textButton function
// draws a textfield inof specified position, size and text
// called in between levels (WIN state variable 2)
//================================================================//

void textButton(float x, float y, float w, float h, String text){
  
  pushMatrix();
  translate(x, y);
  stroke(0);
  fill(0, 128);
  rect(-w/2, -h/2, w, h);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(h);
  text(text, 0, 0);
  popMatrix();  
  
}


                                              //==================//
                                              // GLOBAL VARIABLES
                                              //==================//

//================================================================//
// global variables
//   - variables for aggregating objects
//     - since Players, Pucks, and Holes are refreshed upon lose
//       additional initial-state lists are added
//   - state variables for game state (WIN) and current stage
//     (stage)
//   - image variables for textures and soundfile variables for
//     sound effects and music
//================================================================//

float fric, tension;
CircleList C, initC;
PlayerList P, initP;
BulletList B;
BossBulletList B2;
HoleList H, initH;

int WIN;
int stage;

PImage falcon;
PImage hole;
PImage puck;
PImage background;
SoundFile music;
SoundFile mydemons;
SoundFile laser;
SoundFile showme;
SoundFile goodjob;
SoundFile disqualified;


                                              //==================//
                                              // RUNNING FUNCTIONS
                                              //==================//

//================================================================//
// setup function
//   - randomSeed disabled by default
//   - framerate controlled by int variable associated with all
//     speed coefficients
//     - failed to achieve smooth framerate-independent scaling of
//       velocities (framerate seems not to be fully linear)
//   - loading images and sounds
//     - adjusting some volumes
//   - setting current level to 0 and creating new stage 
//================================================================//

void setup(){

  //randomSeed(0);
  
  int f = 25;
  size(750, 750);
  frameRate(f);
  
  fric = 0.25/f;
  tension = 2.0/f;
  
  falcon = loadImage("falcon.png");
  hole = loadImage("hole.png");
  puck = loadImage("puck.png");
  background = loadImage("background.png");
  background.resize(width, height);
  
  music = new SoundFile(this, "FlyFalcon.wav");
  mydemons = new SoundFile(this, "mydemons.wav");
  mydemons.amp(0.4);
  laser = new SoundFile(this, "pew.wav");
  laser.amp(0.6);
  showme = new SoundFile(this, "showme.wav");
  showme.amp(0.4);
  goodjob = new SoundFile(this, "goodjob.wav");
  goodjob.amp(0.4);
  disqualified = new SoundFile(this, "disqualified.wav");
  disqualified.amp(0.4);
  music.play();

  stage = 0;
  setNew();

}


//================================================================//
// setNew sunction
// sets new stage
//   - advancces the current stage by 1
//   - calls setBoss instead if boss stage is required
//   - initiates aggregating objects of semi-random length and
//     copies their initial conditions
//     - several fall loops ensure no object is created initially
//       inside a Hole
//   - sets WIN state variable to 'prepare for new stage' (2)
//================================================================//

void setNew(){

  stage++;
  if(isBoss()){
    setBoss();
    return;
  }
  
  P = new PlayerList();
  C = new CircleList();
  H = new HoleList();
  B = new BulletList();
  B2 = new BossBulletList();
  
  int p = int(random(1))+1;
  int c = int(random(stage))+1;
  int h = int(random(stage))+1;
  PVector tempV;
  float tempR;
  boolean ok;
  for(int i=0; i<h; i++){
    tempR = random(100)+25;
    tempV = new PVector(random(width-2*tempR)+tempR, random(height-2*tempR)+tempR);
    H.append(new Hole(tempR, tempV.x, tempV.y));
  }
  for(int i=0; i<p; i++){
    tempV = new PVector(random(width-50)+25, random(height-50)+25);
    ok = true;
    for(int j=0; j<H.length(); j++){
      if(H.get(j).inside(tempV.x, tempV.y)){
        ok = false;
        break;
      }
    }
    if(ok){
      P.append(new Player(25, tempV.x, tempV.y));
    }
    else{
      i--;
    }
  }
  for(int i=0; i<c; i++){
    tempR = 25*(random(1.5)+0.5);
    tempV = new PVector(random(width-2*tempR)+tempR, random(height-2*tempR)+tempR);
    ok = true;
    for(int j=0; j<H.length(); j++){
      if(H.get(j).inside(tempV.x, tempV.y)){
        ok = false;
        break;
      }
    }
    if(ok){
      C.append(new Puck(tempR, tempV.x, tempV.y));
    }
    else{
      i--;
    }
  }
    
  initP = new PlayerList(P);
  initC = new CircleList(C);
  initH = new HoleList(H);
  
  WIN = 2;
  
}


//================================================================//
// setBoss function
// sets the boss stage, analogous to setNew
//   - ensures no objects are created initially in Boss's path
//================================================================//

void setBoss(){
  
  P = new PlayerList();
  C = new CircleList();
  H = new BossList();
  B = new BulletList();
  B2 = new BossBulletList();
  
  int p = int(random(1))+1;
  int c = int(random(stage))+stage;
  int h = int(random(1))+1;
  PVector tempV;
  float tempR;
  boolean ok;
  for(int i=0; i<h; i++){
    tempR = 125;
    tempV = new PVector(random(width-2*tempR)+tempR, random(height-2*tempR)+tempR);
    H.append(new Boss(tempR, tempV.x, tempV.y, 10));
  }
  for(int i=0; i<p; i++){
    tempV = new PVector(random(width-50)+25, random(height-50)+25);
    ok = true;
    for(int j=0; j<H.length(); j++){
      if(abs(H.get(j).pos.x-tempV.x)<=125){
        ok = false;
        break;
      }
    }
    if(ok){
      P.append(new Player(25, tempV.x, tempV.y));
    }
    else{
      i--;
    }
  }
  for(int i=0; i<c; i++){
    tempR = 25*(random(1.5)+0.5);
    tempV = new PVector(random(width-2*tempR)+tempR, random(height-2*tempR)+tempR);
    ok = true;
    for(int j=0; j<H.length(); j++){
      if(abs(H.get(j).pos.x-tempV.x)<=125){
        ok = false;
        break;
      }
    }
    if(ok){
      C.append(new Puck(tempR, tempV.x, tempV.y));
    }
    else{
      i--;
    }
  }
  
  initP = new PlayerList(P);
  initC = new CircleList(C);
  initH = new BossList(H);
  
  music.stop();
  mydemons.play();
  
  WIN = 2;
  
}


//================================================================//
// restart function
// restarts current stage
//   - restores initial condition for agggregating objects
//     - bullets are cleared instead
//   - sets the WIN state variable to 'prepare for stage' (2)
//================================================================//

void restart(){
  
  P = new PlayerList(initP);
  C = new CircleList(initC);
  H = new BossList(initH);
  B = new BulletList();
  B2 = new BossBulletList();
  
  WIN = 2;
  
}


//================================================================//
// draw function
// delegates the running game depending on WIN state variable
//================================================================//

void draw(){
  
  if(WIN==1){
    winScreen();
  }else if(WIN==2){
    nextScreen();
  }else if(WIN==-1){
    loseScreen();
  }else{
    play();
  }
  
}


//================================================================//
// winScreen function
// marks successfull completion of stage (WIN = 1)
//   - white-shade the screen
//   - display victory message via textbutton function
//   - create new stage upon mouse or spacebar pressed
//================================================================//

void winScreen(){

  play();
  noStroke();
  fill(255, 128);
  rect(0, 0, width, height);
  textButton(width/2, height/2, width, 100, "victory");

  if(mousePressed || (keyPressed && key == ' ')) setNew();
  
}


//================================================================//
// nextScreen function
// marks preparation for the current stage (WIN = 2)
//   - display the stage number
//   - upon mouse pressed set WIN state variable to game running
//     (0)
//     - play boss-related sounds if boss stage is initiated
//================================================================//

void nextScreen(){

  play();
  noStroke();
  fill(255, 128);
  if(isBoss()) textButton(width/2, height/2, width, 100, "BOSS STAGE");
  else textButton(width/2, height/2, width, 100, "stage "+stage);

  if(mousePressed || (keyPressed && key == ' ')){
    if(isBoss()) showme.play();
    frameCount = 0;
    WIN = 0;
  }
}


//================================================================//
// loseScreen function
// marks failure to complete the stage (WIN = -1)
//   - black-shade the screen
//   - display defeat message via textbutton function
//   - restart the stage upon mouse or spacebar pressed
//================================================================//

void loseScreen(){

  play();
  noStroke();
  fill(0, 128);
  rect(0, 0, width, height);
  textButton(width/2, height/2, width, 100, "defeat");
  
  if(mousePressed || (keyPressed && key == ' ')) restart();
  
}


//================================================================//
// play function
// marks successfull completion of stage (WIN = 1)
//   - run collissions and updates
//     - Pucks collide with everything
//     - Players don't collide with self (only one PLayer
//       considered)
//     - Bullets and Holes collide with Players and Pucks, but
//       not with self or each other
//   - resolve the stage if the number of Players or Pucks
//     reaches 0
//     - Players - defeat, Pucks - victory
//   - play boss-related sounds if boss stage gets resolved
//     - restore original music if the completion of boss stage
//     - was successful
//================================================================//

void play(){
  background(background);
  
  P.collide(C);
  C.collide();
  H.collide(C);
  H.collide(P);
  B.collide(P);
  B.collide(C);
  B.collide(B2);
  B2.collide(P);
  B2.collide(C);  
  
  P.update();
  C.update();
  H.update();
  B.update();
  B2.update();
  
  if (P.empty()){
    if(WIN==0 && isBoss()) disqualified.play();
    WIN = -1;
  }
  else if(C.empty()){
    if(WIN==0 && isBoss()){
      mydemons.stop();
      music.play();
      goodjob.play();
    }
    WIN = 1;
  }
  
}



                          //======================================//
                          // HELPER FUNCTIONS AND ACTION LISTENERS
                          //======================================//

//================================================================//
// isBoss helper function
// states whether the current stage is a boss stage
//   -set boss stage to be every fifth
//================================================================//

boolean isBoss(){
  return stage%5==0;
}


//================================================================//
// keyPressed action listener
// used by Player to shoot when spacebar is pressed
//   - disbled wif state variable WIN does not indicate running
//     game (0)
//   - also plays the laser sound effect
//================================================================//

void keyPressed(){
  
  if(WIN == 0 && key == ' '){
    P.shoot();
    laser.play();
  }
  
}
