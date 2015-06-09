//have fun!
//this code is public domain
//random points

import processing.visualcube1e3.*;

/**/class Punkte extends Effect {  //VisualCube cube = new VisualCube(this);

Random rnd = new Random();
final static int POINTS = 6;
int tick;

void setup() {
  cube.open("192.168.2.173");
  cube.clear();
  cube.simulate(800, 800); 
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

/**/}
