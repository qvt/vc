/**
 * checkerboard
 *
 * For more informations, visit:
 * http://www.visualcube.org/1e3
 * 
 * @author	Michael Rentschler
 * @date	2009-06-27
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

float phi = 0;
float theta = 0;

void draw() {
  // clear screen
  cube.fill(0, 0, 0);

  // increment rotation angles
  phi   += sq(sin(frameCount*0.009)*0.5);
  theta += sq(cos(frameCount*0.005)*0.5);
  phi %= PI*2;
  theta %= PI*2;

  // precalc sin/cos values for rotation matrix
  double sa = sin(phi);
  double ca = cos(phi);
  double sb = sin(theta);
  double cb = cos(theta);

  // draw checkerboard
  for(int x=0; x < 10; x++)
  for(int y=0; y < 10; y++)
  for(int z=0; z < 10; z++)
  {
    // get coords relative to center
    float x0 = x - 4.5f;
    float y0 = y - 4.5f;
    float z0 = z - 4.5f;
    
    // rotation matrix about y-axis (a) and x-axis (b)
    //
    //  / +cos(a) +sin(a)*sin(b) +sin(a)*cos(b) \
    // |  +0      +cos(b)        -sin(b)         |
    //  \ -sin(a) +cos(a)*sin(b) +cos(a)*cos(b) /
    //
    boolean fx = (+ x0*ca + y0*sa*sb + z0*sa*cb) >= 0;
    boolean fy = (+ x0*0  + y0*cb    - z0*sb   ) >= 0;
    boolean fz = (- x0*sa + y0*ca*sb + z0*ca*cb) >= 0;

    // black or white field?
    if(fx^fy^fz)
    {
      float d = dist(0, 0, 0, x0, y0, z0) / sqrt(3*sq(4.5f));
      int c = int(sin(d*PI/2) * 255);
      cube.set(x, y, z, fx?c:0, fy?c:0, fz?c:0);
    }
  }
  
  cube.update();  // update remote device
}

void destroy() {
  cube.clear();   // clear the display
  cube.update();  // update remote device
  cube.close();   // say goodbye cube
}
