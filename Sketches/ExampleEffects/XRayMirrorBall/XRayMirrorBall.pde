/**
 * XRay Mirrorball. 
 * Processing example by Andreas Rentschler 2008-07-22. 
 * 
 * This little sketch shows the basics in controlling a VisualCube device.
 *
 * For more informations, visit:
 * http://www.visualcube.org
 * 
 * @author  Andreas Rentschler
 * @date    2008-07-21
 * @version 1.0
 */

import processing.visualcube1e3.*;
import java.util.*;

VisualCube cube = new VisualCube(this);

Random rnd = new Random();
int number = 0;
int target = 0;
    
void setup() {
  size(800, 800, P3D);   // open 3D canvas
  cube.open("10.0.0.1"); // say hello to the cube
  cube.clear();          // clear the display
  cube.simulate();       // start the simulator
}

void draw() {
  // set random pixels to random colors
  // let number of drawn pixels per call run to a random target value
  // when target value is reached fill with random color and set new target value
  if (number == target) {
    target = rnd.nextInt(14);
    cube.fill(new VisualCube.Color(
      rnd.nextInt(VisualCube.colors), 
      rnd.nextInt(VisualCube.colors), 
      rnd.nextInt(VisualCube.colors)));
  }
  else {
    number += (number < target ? 1 : -1);
  }

  for (int i = 0; i < number; i++) {
    cube.set(
      rnd.nextInt(VisualCube.width), 
      rnd.nextInt(VisualCube.height), 
      rnd.nextInt(VisualCube.depth), 
      new VisualCube.Color(
      rnd.nextInt(VisualCube.colors), 
      rnd.nextInt(VisualCube.colors), 
      rnd.nextInt(VisualCube.colors)));
  }

  cube.update();  // update remote device
}

void destroy() {
  cube.close();  // say goodbye cube
}