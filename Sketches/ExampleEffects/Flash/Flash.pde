/**
 * Flash. 
 * Processing example by Michael Rentschler 2008-07-22. 
 * 
 * For more informations, visit:
 * http://www.visualcube.org
 * 
 * @author  Michael Rentschler
 * @date    2009-06-15
 * @version 1.0
 */

import processing.visualcube1e3.*;

VisualCube cube = new VisualCube(this);

void setup() {
  size(800, 800, P3D);   // open 3D canvas
  cube.open("10.0.0.1"); // say hello to the cube
  cube.clear();          // clear the display
  cube.simulate();       // start the simulator
}

void draw() {
  int n = int(frameCount) % int(frameRate*3);
  int x = 10;
  boolean b = (n == 0*x) || (n == 2*x) || (n == 4*x);
  cube.fill(b?255:0, b?255:0, b?255:0);
  cube.update();  // update remote device
}

void destroy() {
  cube.clear();  // clear the display
  cube.close();  // say goodbye cube
}