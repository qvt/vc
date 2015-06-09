/**
 * Pulsating. 
 * Processing example by Andreas Rentschler 2008-07-22. 
 * 
 * For more informations, visit:
 * http://www.visualcube.org
 * 
 * @author  Andreas Rentschler
 * @date    2009-06-15
 * @version 1.0
 */

import processing.visualcube1e3.*;

VisualCube cube = new VisualCube(this);

final int FPS = 30;

void setup() {
  size(800, 800, P3D);   // open 3D canvas
  cube.open("10.0.0.1"); // say hello to the cube
  cube.clear();          // clear the display
  cube.simulate();       // start the simulator
  frameRate(FPS);
}

void draw() {
  int c = int(abs(sin(PI*frameCount/FPS/2))*255);
  switch(int(frameCount/FPS/2)%3)
  {
  case 0: cube.fill(c, 0, 0); break;
  case 1: cube.fill(0, c, 0); break;
  case 2: cube.fill(0, 0, c);
  }
  cube.update();  // update remote device
}

void destroy() {
  cube.clear();  // clear the display
  cube.close();  // say goodbye cube
}