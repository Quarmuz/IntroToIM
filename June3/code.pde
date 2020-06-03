class Vec{
  
  float X;
  float Y;
  
  Vec(float nX, float nY){
    X = nX;
    Y = nY;
  }
  
  Vec add(Vec v){
    return new Vec(X+v.X, Y+v.Y);
  }
  
  Vec add(float nX, float nY){
    return new Vec(X+nX, Y+nY);
  }
  
  float len(){
    return sqrt(X*X+Y*Y);
  }
  
}

class Circle{
  
  float rad;
  Vec  pos;
  Vec vel;
  color col;
  
  Circle(float r, float pX, float pY, float vX, float vY, color c){
    rad = r;
    pos = new Vec(pX, pY);
    vel = new Vec(vX, vY);
    col = c;
  }
  
  boolean inside(float X, float Y){
    return ( (pos.X-X)*(pos.X-X)+(pos.Y-Y)*(pos.Y-Y) < rad*rad );
  }
  
  boolean inside(Circle C){
    return inside(C.pos.X, C.pos.Y);
  }
  
  boolean touch(Circle C){
    return ( (pos.X-C.pos.X)*(pos.X-C.pos.X)+(pos.Y-C.pos.Y)*(pos.Y-C.pos.Y) < (rad+C.rad)*(rad+C.rad) && (pos.X-C.pos.X)*(vel.X-C.vel.X)+(pos.Y-C.pos.Y)*(vel.Y-C.vel.Y) < 0 );
  }
  
  void move(){
    pos = pos.add(vel);
  }
  
  void display(){
    fill(col);
    circle(pos.X, pos.Y, rad*2);
  }
  
  void collidewalls(){
    if( (pos.X<rad && vel.X<0) || (pos.X>600-rad && vel.X>0) ) vel.X = -vel.X;
    if( (pos.Y<rad && vel.Y<0) || (pos.Y>600-rad && vel.Y>0) ) vel.Y = -vel.Y;
  }
  
  void slow(){
    if(vel.len()<0.1) vel=new Vec(0, 0);
    else vel = vel.add(-fric*vel.X, -fric*vel.Y);
  }
  
  void update(){
    display();
    collidewalls();
    move();
    slow();
  }
  
  void collide(Circle C){
    float t = atan( (pos.Y-C.pos.Y)/(pos.X-C.pos.X) );
    float vr = vel.X*cos(t) + vel.Y*sin(t);
    float vt = vel.X*sin(t) + vel.Y*cos(t);
    float cvr = C.vel.X*cos(t) + C.vel.Y*sin(t);
    float cvt = C.vel.X*sin(t) + C.vel.Y*cos(t);
    vel = new Vec( cvr*cos(t)+vt*sin(t), cvr*sin(t)+vt*cos(t) );
    C.vel = new Vec( vr*cos(t)+cvt*sin(t), vr*sin(t)+cvt*cos(t) );
  }
  
}

class Player extends Circle{
  
  boolean pull;
  
  Player(float r, float pX, float pY){
    super(r, pX, pY, 0, 0, color(255, 0, 0));
  }
    
  void display(){
    super.display();
    if(pull)
      line(pos.X, pos.Y, mouseX, mouseY);
  }
  
  void update(){
    super.update();
    if( mousePressed && inside(mouseX, mouseY) ){
      pull = true;
    }
    if( !mousePressed ){
      if(pull){
        vel=vel.add((pos.X-mouseX)/12, (pos.Y-mouseY)/12);
      }
      pull = false;
    }
  }
  
}


class Puck extends Circle{
  
  Puck(float r, float pX, float pY){
    super(r, pX, pY, 0, 0, color(255, 255, 255));
  }
  
}


class Hole extends Circle{
  
  Hole(float r, float pX, float pY){
    super(r, pX, pY, 0, 0, color(0, 0, 0));
  }
  
}


float fric = 0.01;
ArrayList<Player> P;
ArrayList<Puck> C;
ArrayList<Hole> H;
Player Pi, Pj;
Puck Ci, Cj;
Hole Hi;
int WIN;


void setup(){

  size(600, 600);
  frameRate(25);
  stroke(color(0));

  setNew();

}

void setNew(){

  P = new ArrayList<Player>(0);
  C = new ArrayList<Puck>(0);
  H = new ArrayList<Hole>(0);
  
  int p = int(random(3))+1;
  int c = int(random(10))+1;
  int h = int(random(4))+1;
  for(int i=0; i<p; i++) P.add(new Player(25, random(600-50)+25, random(600-50)+25));
  for(int i=0; i<c; i++) C.add(new Puck(25, random(600-50)+25, random(600-50)+25));
  for(int i=0; i<h; i++) H.add(new Hole(random(100)+25, random(600-50)+25, random(600-50)+25));
  
  WIN = 0;
  
}


void draw(){
  
  if(WIN>0){
    winScreen();
  }else if(WIN<0){
    loseScreen();
  }else{
    play();
  }
  
}


void winScreen(){

  background(0, 255, 0);

  if(mousePressed) setNew();
  
}


void loseScreen(){

  background(0, 0, 0);
  
  if(mousePressed) setNew();
  
}


void play(){

  background(255);
  
  for(int i=0; i<H.size(); i++){
    Hi = H.get(i);
    Hi.update();
    for(int j=0; j<P.size(); j++){
      Pj = P.get(j);
      if(Hi.inside(Pj)) P.remove(j);
    }
    for(int j=0; j<C.size(); j++){
      Cj = C.get(j); 
      if(Hi.inside(Cj)) C.remove(j);
    }
  }
  
  for(int i=0; i<P.size(); i++){
    Player Pi = P.get(i);
    Pi.update();
    for(int j=0; j<P.size(); j++){
      Pj = P.get(j);
      if(i!=j && Pi.touch(Pj)) Pi.collide(Pj);
    }
    for(int j=0; j<C.size(); j++){
      Cj = C.get(j);
      if(Pi.touch(Cj)) Pi.collide(Cj);
    }
  }
  
  for(int i=0; i<C.size(); i++){
    Ci = C.get(i);
    Ci.update();
    for(int j=0; j<C.size(); j++){
      Cj = C.get(j);
      if(i!=j && Ci.touch(Cj)) Ci.collide(Cj);
    }
  }
  
  if (P.size()==0) WIN = -1;
  else if(C.size()==0) WIN = 1;

}
