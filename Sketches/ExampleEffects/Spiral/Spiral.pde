/**
 * spiral
 *
 * For more informations, visit:
 * http://www.visualcube.org/1e3
 * 
 * @author  Michael Rentschler
 * @date    2009-06-27
 * @version 1.0
 */

import processing.visualcube1e3.*;
import java.util.*;

VisualCube cube = new VisualCube(this);

void setup() {
  size(800, 800, P3D);   // open 3D canvas
  cube.open("10.0.0.1"); // say hello to the cube
  cube.clear();          // clear the display
  cube.simulate();       // start the simulator
}

float phi = 0;

void draw() {
  cube.fill(0, 0, 0, 0.25f);
  
  float phi_inc = sin(frameCount * 0.01)*0.2f;
  phi += phi_inc;

  for(int x=0; x < 10; x++)
  for(int y=0; y < 10; y++)
  for(int z=0; z < 10; z++)
  {    
    float a = (frameCount+z*3) * 0.2;
    
    int b = int((sin(a*0.3))*127+127);
    int g = int((cos(a*0.3))*127+127);
    int r = 255-(b+g)/2;

    // get angle between line (x,y,z) and (0,0,z)
    float d = (y - 4.5f) / (x - 4.5f);
    float t = tan(phi + phi_inc * z);

    if(abs(d - t) < 1f)
    {
      cube.set(x, y, z, r, g, b);
    }
  }
  
  cube.update();  // update remote device
}

void destroy() {
  cube.clear();   // clear the display
  cube.update();  // update remote device
  cube.close();   // say goodbye cube
}