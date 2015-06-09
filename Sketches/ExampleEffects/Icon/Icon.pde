/**
 * Icon. 
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
  if(int(frameCount) % (frameRate*1) != 0) return;
  
  cube.fill(0, 0, 0);
  
  int r = int(random(1)*255);
  int g = int(random(1)*255);
  int b = 255-(r+g)/2;
  
  for(int x=0; x<5; x++)
  {
    for(int y=0; y<10; y++)
    {
      if(random(1) >= 0.5f)
      {
        cube.set(5+x, y, 4, r, g, b);
        cube.set(5+x, y, 5, r, g, b);
        cube.set(4-x, y, 4, r, g, b);
        cube.set(4-x, y, 5, r, g, b);

        cube.set(4, y, 5+x, r, g, b);
        cube.set(5, y, 5+x, r, g, b);
        cube.set(4, y, 4-x, r, g, b);
        cube.set(5, y, 4-x, r, g, b);
      }
    }
  }
  
  cube.update();  // update remote device
}

void destroy() {
  cube.clear();  // clear the display
  cube.close();  // say goodbye cube
}