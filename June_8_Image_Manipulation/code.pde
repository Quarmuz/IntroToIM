//==============================================//
// The program is a simple pictionary game. It
// displays a random image from the list and the
// player guesses the word via text input (accept
// with enter). THe program responds was the guess
// right or wrong and proceeds to show next image. 
//==============================================//


PImage[] images;                                //global variables
PImage photo;
String[] answers;
int number;
String text;
int WIN;


void getPhoto(){                                //load random photo and answer, reset game state and text
  
  number = 1+int(random(images.length-1));
  photo = images[number];
  photo.resize(width, height);
  WIN = 0;
  text = "";
  
}


void button(float x, float y){                  //textfield
  
  pushMatrix();
  translate(x, y);
  fill(255);
  rect(-100, -25, 200, 50);
  fill(0);
  if(text.length()<10)
    textSize(32);
  else
    textSize(32-3.0/2.0*(text.length()-9));
  text(text, -95, 12);
  popMatrix();  
  
}
  

void setup(){                                   //setup function
                                                //set size, background, fill and stroke
  size(600, 600);                               //load image and answer arrays
                                                //get first photo
  background(255);
  stroke(0);
  noFill();

  images = new PImage[] {loadImage("start.png"), loadImage("dog.png"), loadImage("tree.png")};
  answers = new String[] {"start", "dog", "tree"};
  
  number = 0;
  photo = images[0];
  photo.resize(width, height);
  WIN = 0;
  text = "";

}

void draw(){                                    //draw function
                                                //depending on game state delegate functionality to subfunctions
  if(WIN>0){
    winScreen();
  }else if(WIN<0){
    loseScreen();
  }else{
    play();
  }
  
}

void play(){                                    //guessing stage, enable txt input
  
  tint(255, 255, 255);
  image(photo, 0, 0);
  button(width/2, height-50);
  
}

void winScreen(){                               //win screen, apply green tint and reset on mouse press
  
  tint(100, 255, 100);
  image(photo, 0, 0);
  if(mousePressed) getPhoto();
  
}

void loseScreen(){                              //lose screen, apply red tint and reset on mouse press
  
  tint(255, 100, 100);
  image(photo, 0, 0);
  if(mousePressed) getPhoto();
  
}

void keyPressed() {                             //button action listener, text input and allow reset on enter
  
  if(key==BACKSPACE) {
    if(text.length()>0) {
      text=text.substring(0, text.length()-1);
    }
  }
  else if(key==RETURN || key==ENTER) {
    if(WIN!=0){
      getPhoto();
    }
    else if(text.equals(answers[number])) {
      WIN = 1;
    }
    else{
      WIN = -1;
    }
  }
  else{
    text += key;
  }
}
