/**
 * Fan. 
 * Processing example by Andreas Rentschler 2008-07-22. 
 * 
 * Colored line rotating around center.
 *
 * For more informations, visit:
 * http://www.visualcube.org
 * 
 * @author	Andreas Rentschler
 * @date	2009-06-15
 * @version	1.0
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
  cube.fill(0, 0, 0, 0.005);
  
  int x = int((sin(frameCount*0.04)+1)/2*9);
  int y = int((sin(frameCount*0.05)+1)/2*9);
  int z = int((sin(frameCount*0.06)+1)/2*9);
  int r = int((sin(frameCount*0.01)+1)/2*255);
  int g = int((sin(frameCount*0.02)+1)/2*255);
  int b = int((sin(frameCount*0.03)+1)/2*255);
  cube.line(9 - x, 9 - y, 9 - z, x, y, z, r, g, b);

  cube.update();  // update remote device
}

void destroy() {
  cube.clear();   // clear the display
  cube.update();  // update remote device
  cube.close();   // say goodbye cube
}

