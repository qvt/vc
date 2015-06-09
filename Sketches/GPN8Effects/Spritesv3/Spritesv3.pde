 

import processing.video.*;
Capture myCapture;
int imgs = 1;
import processing.visualcube1e3.*;

VisualCube cube = new VisualCube(this);
Random rnd = new Random();
PGraphics paul;


void setup() {
  cube.open("192.168.2.173");     // say hello to the cube
  cube.clear();                   // clear the display
  cube.simulate(800, 800);        // show simulator canvas
  frameRate(30);       
    myCapture = new Capture(this, 640, 480, 30);
    paul = createGraphics(640, 640, P3D);


}

void draw() {
    paul.beginDraw();

paul.resize(20,20);
 paul.image(myCapture ,0,0);
                       
  //image(myCapture, 0, 0);
  // cube.fill(0, 0, 0, 0.1);  // fade out
image(paul,0,0);
  for(int i = 0; i < 10;i++){
    for(int j = 0; j < 10; j++){
      // color c = seed.get(i, j);
//      int r = int(red(moreImages[imgs%3].get(i, j)));
//      int g = int(green(moreImages[imgs%3].get(i, j)));
//      int b = int(blue(moreImages[imgs%3].get(i, j)));
//      
      int r = int(red(paul.get(i, j)));
      int g = int(green(paul.get(i, j)));
      int b = int(blue(paul.get(i, j)));

      cube.set(i,j,int(random(10)) ,r,g,b);


    }

  }
  cube.update();  // update remote device
paul.endDraw();
}
void captureEvent(Capture myCapture) {
  myCapture.read();
}

void destroy() {
  cube.close();  // say goodbye cube
}

void keyPressed() {
  
  imgs++;
  
}
