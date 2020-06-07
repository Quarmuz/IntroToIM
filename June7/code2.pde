//========================================================//
//
// The program will display a set of rotating triangles at
// the mouse position. 
//
// Use arrow keys up and down to increase or decrease the
// number of triangles (no less than 1).
//
// Use spacebar to anable or disable autoclear.
//
// Use mouse scroll to zoom in or out.
//
//========================================================//


int side = 200;                                              //global variables
int triangles;
float zoom;
boolean autoclear;


color col(float c){                                          //color function, map from blue to red dependng on the number of triangles present
  
  if(triangles==1)
    return color(255, 0, 0);
  else
    return color(255*c/(triangles-1), 0, 255*(1-c/(triangles-1)));
  
}

void triangleRotate(float v){                                //triangle object (initiall ycentered at (0, 0)) with associated matrices and given angular velocity
                                                             //translation (to mouse coords), scaling (controlled by scroll) and rotation (time dependent)
  pushMatrix();
  translate(mouseX, mouseY);
  scale(zoom);
  rotate(v*float(frameCount)/15.0);
  triangle(-side/2, side/(2*sqrt(3)), side/2, side/(2*sqrt(3)), 0, -side/(sqrt(3)));
  popMatrix();
  
}


void setup(){                                                //setup function
                                                             //set size background, initial stroke and fill, inital number of triangles, autoclear and zoom
  size(800, 800);
  background(255);
  noStroke();
  noFill();
   
  triangles = 1;
  autoclear = true;
  zoom = 1;
  
}

void draw(){                                                 //draw function
                                                             //clear background if autoclear is enabled
  if(autoclear)                                              //draw triangles of progressing color redness and velocities
    background(255);
  frameRate(25);
  
  for(int i=0; i<triangles; i++){
    fill(col(i));
    triangleRotate(1.0+float(i)/float(triangles));
  }
  
}

void keyPressed(){                                           //key action listener
                                                             //arrowkeys up and down control the number of triangles
  if(keyCode == UP){                                         //spacebar enables or disables the autoclear
    triangles=triangles+1;
  }  
  if(keyCode == DOWN){
    if(triangles>1) triangles=triangles-1;
  }  
  if(key == ' '){
    autoclear = !autoclear;
  }
  
}

void mouseWheel(MouseEvent event) {                          //mouse wheel action listener
                                                             //controls zoom
  zoom = zoom + event.getCount()/10.0;
  
}
