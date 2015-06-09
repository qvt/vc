/**
 * Snoozing. 
 * Processing example by Andreas Rentschler 2008-07-22. 
 * 
 * This little sketch shows the basics in controlling a VisualCube device.
 * Inspired by a computer manufacturer :]
 *
 * For more informations, visit:
 * http://www.visualcube.org
 * 
 * @author  Andreas Rentschler
 * @date    2008-07-21
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
  cube.clear();
  
  // draw centered sphere
  for (int i = 0; i < VisualCube.width; i++) {
    for (int j = 0; j < VisualCube.height; j++) {
      for (int k = 0; k < VisualCube.depth; k++) {
        float d = dist(
          2f * i/(VisualCube.width - 1) - 1f, 
          2f * j/(VisualCube.height - 1) - 1f, 
          2f * k/(VisualCube.depth - 1) - 1f, 
          0f, 0f, 0f);
        int c = int((1.0 - d) * abs(sin(frameCount * 0.02)) * (VisualCube.colors - 1));
        cube.set(i, j, k, new VisualCube.Color(c, c, c));
      }
    }
  }

  cube.update();  // update remote device
}

void destroy() {
  cube.close();  // say goodbye cube
}