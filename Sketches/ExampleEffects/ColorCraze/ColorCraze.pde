/**
 * Color Craze. 
 * Processing example by Andreas Rentschler 2008-07-22. 
 * 
 * This little sketch shows the basics in controlling a VisualCube device.
 * A point is constantly running along a spline curve in the 3D color space.
 * The displayed color transition is based on the current position in the 
 * 3D color space. When the target color is reached a new color is chosen 
 * to aim at.
 * This example is the Magic Mood Lamp with only one modification:
 * The ragged look is created by converting 0..255 colors from type int to 
 * type byte (-127..128) and therefore cutting off upper bits; 
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
float x = rnd.nextFloat();
float y = rnd.nextFloat(); 
float z = rnd.nextFloat(); 
float x2 = x, y2 = y, z2 = z;
float vx = 0, vy = 0, vz = 0;
float dist = 0;
float r = 1, g = 1, b = 1;
int rgbSelect = 0;

void setup() {
  size(800, 800, P3D);   // open 3D canvas
  cube.open("10.0.0.1"); // say hello to the cube
  cube.clear();          // clear the display
  cube.simulate();       // start the simulator
}

void draw() {
  float dist2 = dist(x, y, z, x2, y2, z2);
  if(dist2 <= 0.0001f || dist <= dist2) {
    x2 = rnd.nextFloat(); 
    y2 = rnd.nextFloat(); 
    z2 = rnd.nextFloat();
    dist2 = dist(x, y, z, x2, y2, z2);
  }
  dist = dist2;

  vx = vx * 0.3f + (x2 - x) * 0.7f;
  vy = vy * 0.3f + (y2 - y) * 0.7f;
  vz = vz * 0.3f + (z2 - z) * 0.7f;

  x += vx * 0.1f;
  y += vy * 0.1f;
  z += vz * 0.1f;

  float xn = max(0, min(1, x));
  float yn = max(0, min(1, y));
  float zn = max(0, min(1, z));
  
  // throttle black corner: in most cases show only transitions of 2 color ranges
  r = rgbSelect == 1? r * 0.9f : r * 0.9f + 0.1f;
  g = rgbSelect == 2? g * 0.9f : g * 0.9f + 0.1f;
  b = rgbSelect == 3? b * 0.9f : b * 0.9f + 0.1f;
  if ((rgbSelect == 0 && r > 0.99999f && g > 0.99999f && b > 0.99999f) 
    || (rgbSelect == 1 && r < 0.00001f) 
    || (rgbSelect == 2 && g < 0.00001f) 
    || (rgbSelect == 3 && b < 0.00001f)) 
    rgbSelect = rnd.nextInt(4);

  // draw color transition
  for (int i = 0; i < VisualCube.width; i++) {
    for (int j = 0; j < VisualCube.height; j++) {
      for (int k = 0; k < VisualCube.depth; k++) {
        int rn = /*!*/byte/*!*/(xn * (1f - r * i/VisualCube.width)  * (VisualCube.colors-1));
        int gn = /*!*/byte/*!*/(yn * (1f - g * j/VisualCube.height) * (VisualCube.colors-1));
        int bn = /*!*/byte/*!*/(zn * (1f - b * k/VisualCube.depth)  * (VisualCube.colors-1));
        cube.set(i, j, k, new VisualCube.Color(rn, gn, bn));
      }
    }
  }

  cube.update();  // update remote device
}

void destroy() {
  cube.close();  // say goodbye cube
}