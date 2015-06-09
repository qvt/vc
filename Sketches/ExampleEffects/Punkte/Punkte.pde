//have fun!
//this code is public domain
//random points

import processing.visualcube1e3.*;
import java.util.*;

VisualCube cube = new VisualCube(this);

Random rnd = new Random();
final static int POINTS = 6;
int tick;

void setup() {
  size(800, 800, P3D);   // open 3D canvas
  cube.open("10.0.0.1"); // say hello to the cube
  cube.clear();          // clear the display
  cube.simulate();       // start the simulator
}

void draw() {
  tick++;
  cube.clear();
  for (int i = 0; i < POINTS; i++) {
  cube.set(abs(rnd.nextInt()%10), abs(rnd.nextInt()%10), abs(rnd.nextInt()%10), new VisualCube.Color(abs(rnd.nextInt()%255), abs(rnd.nextInt()%255), abs(rnd.nextInt()%255)));
  }
  cube.update();
}

void destroy() {
  cube.close(); 
}