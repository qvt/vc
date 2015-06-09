//have fun!

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
int[][] worm = new int[10][3];
int dir = 0;
int sign = 1;

void setup() {
  size(800, 800, P3D);   // open 3D canvas
  cube.open("10.0.0.1"); // say hello to the cube
  cube.clear();          // clear the display
  cube.simulate();       // start the simulator
}

void draw() {
  int i, tmp, olddir;
  
  cube.set(worm[9][0], worm[9][1], worm[9][2], new VisualCube.Color(0, 0, 0));
  for (i = 8; i >= 0; i--) {
    worm[i+1][0] = worm[i][0];
    worm[i+1][1] = worm[i][1];
    worm[i+1][2] = worm[i][2];
    cube.set(worm[i][0], worm[i][1], worm[i][2], new VisualCube.Color((int) (((float) (9 - i)) * 255.0 / 10.0), 0, 0));
  }
  
  olddir = dir;
  do {
    tmp = 0;
    if (worm[0][dir] == 9 && sign > 0) tmp = 1;
    if (worm[0][dir] == 0 && sign < 0) tmp = 1;
    if ((rnd.nextInt() % 10) == 0) tmp = 1;
    if (tmp == 1) {
      do {
        dir = abs(rnd.nextInt()) % 3;
      } while (olddir == dir);
      sign = abs(rnd.nextInt() % 2)*2-1;
    }
  } while(tmp > 0);
  worm[0][dir] += sign;
  cube.set(worm[0][0], worm[0][1], worm[0][2], new VisualCube.Color(255, 0, 0));
  cube.update();
}

void destroy() {
  cube.close(); 
}