## ASSIGNMENT TWO (PART 1)
### Data representation of natural language

### RATIONALE

It would be to bold to call it intro to natural language processing, but it is somewhere in that direction. The program analyses given text and outputs words by length statistics. The upward bars show the total instances of the words of given length, while the downward bars include only different word instances.

The graph is scaled in both X and Y direction to appear most conveniently.

Instead of .csv file a .txt file was used, as it processes the text in natural language. I think it can still be considered a data analysis.


### RESUTLS

- short text, Pan Tadeusz, Inwokacja. The invocation to Polish national poem (in Polish)\
![](1.png)

- longet text, Macbeth act 1 (in English)\
![](2.png)


### CODE

//========================================================//
//
// The program analyses given text and outputs words by length
// statistics. The upward bars show the total instances of the
// words of given length, while the downward bars include only
// different word instances.
//
//========================================================//


String data[];                                            //global variavbles
StringList X;
int Y1[];
int Y2[];
int xmax;
int ymax;


color col(float c){                                       //iterate color from blue to red
  print();
  return color(127*(1+c/ymax), 0, 127*(1-c/ymax));
  
}

String reduce(String s){                                  //lowercase string and truncate interpunction
  
  s = s.toLowerCase();
  s = s.replaceAll("[^a-zA-Z ]", "");
  
  return s;
  
}


void setup(){                                             //setup
                                                          //set size, load data from file, merge the lines, separate by spaces, compute the data
  size(600, 600);                                         //scale X and Y 'dynamically'
  String stuff[] = loadStrings("data.txt");
  String stuff2 = "";
  for(int i=0; i<stuff.length; i++)
    stuff2 = stuff2.concat(stuff[i]);
  data = split(stuff2, ' ');
  getData();

}


void draw(){                                              //draw the graph
  
  background(255);
  
  stroke(0);
  line(0, height/2, width, height/2);                     //middle line
  
  noStroke();
  float w = width/xmax;
  for(int i=0; i<xmax; i++){
    fill(col(Y1[i]));
    rect(i*w+0.1*w, height/2-0.9*(Y1[i]*height/2/ymax), 0.9*w, 0.9*(Y1[i]*height/2/ymax));  //bars up
    fill(col(Y2[i]));
    rect(i*w+0.1*w, height/2+0.9*(Y2[i]*height/2/ymax), 0.9*w, -0.9*(Y2[i]*height/2/ymax)); //bars down
  }
  
}


void getData(){                                           //compute the data
  
  X = new StringList();                                   //set the initial arrays
  Y1 = new int[100];
  Y2 = new int[100];
  for(int i=0; i<10; i++){
    Y1[i]=0;
    Y2[i]=0;
  }
  
  int len;
  xmax = 0;
  ymax = 0;
  
  for(int i=0; i<data.length; i++){                       //iterate through non-empty words
    len = reduce(data[i]).length();                       //insert them by their length to Y1 and if not repeating to Y2
    if(len!=0){                                           //keep the largest non-empty X and largest Y
      Y1[len-1]++;
      if(!X.hasValue(reduce(data[i]))){
        X.append(reduce(data[i]));
        Y2[len-1]++;
      }
      if(len>xmax){
        xmax = len;
      }
    }
  }
  
  for(int i=0; i<xmax; i++){
    if(Y1[i]>ymax){
      ymax = Y1[i];
    }
  }
  
}


### FURTHER DEVELOPMENT
- prefrably not in Java
- add axes and text descriptions
  - at current stage it caused too much adjustments with text size, requires more practice on my side
- recognize the actual words, not only their lengths and probabilities of appearing after given sequence few words back
  - that would be first step into narural language processing
- compute the curves approximating upwards and downwards graphs
  - for longer inputs, specific language is expected to create a distinct curve. After proper sampling this can be used for language recognition without knowing the meaning of words.


<br/><br/>


## ASSIGNMENT TWO (PART 2)
### Rotating triangles with no big idea behind them

### RATIONALE

A rather simple idea of a program displaying rotating set of triangles with different angular velocities, resulting in a periodic shape imposition. Each triangle has associated transformation (to mouse positions), rotation (time dependent) and scaling (controlled by mouse scroll) matrices.

The number of triangles can be controlled with up and down arrow keys. Space bar can be used to toggle on and of the automatic background clearing.


### RESUTLS

- simple periodic rotation (10 triangles)\
![](3.png)

- autoclear disabled (5 triangles)\
![](4.png)


### CODE

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


### FURTHER DEVELOPMENT

- rather arbitrary, the program serves no purpose except looking nice
- adding a stroke function
  - allow stroke down and stroke up
  - save the set of shaped as an object (containing list of triangles) and display it untill cleared
