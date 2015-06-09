/**
 * Star of Bethlehem. 
 * Processing example by Andreas Rentschler 2009-12-15.
 * 
 * An animated star.
 *
 * For more informations, visit:
 * http://www.visualcube.org
 * 
 * @author	Andreas Rentschler
 * @date	2009-12-11
 * @version	1.0
 */

import processing.visualcube1e3.*;
import java.util.*;

class Voxel {
  int x, y, z; 
  Voxel(int x, int y, int z) { 
    this.x = x; 
    this.y = y; 
    this.z = z;
  }
};

VisualCube cube = new VisualCube(this);
Random rnd = new Random();

final int FRAMERATE = 10;
final VisualCube.Color W = new VisualCube.Color(255, 255, 255);
final VisualCube.Color R = new VisualCube.Color(255, 000, 000);
void setup() {
  size(800, 800, P3D);    // open 3D canvas
  cube.open("10.0.0.1");  // say hello to the cube
  cube.clear();           // clear the display
  cube.simulate();        // start the simulator
  frameRate(FRAMERATE);           // slow down
}

void draw() {
  // clear layer
  cube.fill(0, 0, 0, 0.2);  // fade out

  // draw scene on layer
  int i;
  VisualCube.Color w;
  
  i = rnd.nextInt(4);
  cube.line(4,4,4, 4-i,4-i,4-i, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(5,5,5, 5+i,5+i,5+i, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(4,4,4, 4-i,4-i,4, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(5,5,5, 5+i,5+i,5, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(4,4,4, 4-i,4,4-i, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(5,5,5, 5+i,5,5+i, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(4,4,4, 4-i,4,4, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(5,5,5, 5+i,5,5, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(4,4,4, 4,4-i,4-i, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(5,5,5, 5,5+i,5+i, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(4,4,4, 4,4-i,4, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(5,5,5, 5,5+i,5, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(4,4,4, 4,4,4-i, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(5,5,5, 5,5,5+i, 255-i*20, 255-i*20, 255-i*20);

  i = rnd.nextInt(4);
  cube.line(4,4,5, 4-i,4-i,5+i, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(5,5,4, 5+i,5+i,4-i, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(4,4,5, 4-i,4-i,5, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(5,5,4, 5+i,5+i,4, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(4,4,5, 4-i,4,5+i, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(5,5,4, 5+i,5,4-i, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(4,4,5, 4-i,4,5, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(5,5,4, 5+i,5,4, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(4,4,5, 4,4-i,5+i, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(5,5,4, 5,5+i,4-i, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(4,4,5, 4,4-i,5, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(5,5,4, 5,5+i,4, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(4,4,5, 4,4,5+i, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(5,5,4, 5,5,4-i, 255-i*20, 255-i*20, 255-i*20);

  i = rnd.nextInt(4);
  cube.line(4,5,4, 4-i,5+i,4-i, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(5,4,5, 5+i,4-i,5+i, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(4,5,4, 4-i,5+i,4, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(5,4,5, 5+i,4-i,5, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(4,5,4, 4-i,5,4-i, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(5,4,5, 5+i,4,5+i, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(4,5,4, 4-i,5,4, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(5,4,5, 5+i,4,5, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(4,5,4, 4,5+i,4-i, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(5,4,5, 5,4-i,5+i, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(4,5,4, 4,5+i,4, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(5,4,5, 5,4-i,5, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(4,5,4, 4,5,4-i, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(5,4,5, 5,4,5+i, 255-i*20, 255-i*20, 255-i*20);

  i = rnd.nextInt(4);
  cube.line(4,5,5, 4-i,5+i,5+i, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(5,4,4, 5+i,4-i,4-i, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(4,5,5, 4-i,5+i,5, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(5,4,4, 5+i,4-i,4, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(4,5,5, 4-i,5,5+i, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(5,4,4, 5+i,4,4-i, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(4,5,5, 4-i,5,5, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(5,4,4, 5+i,4,4, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(4,5,5, 4,5+i,5+i, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(5,4,4, 5,4-i,4-i, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(4,5,5, 4,5+i,5, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(5,4,4, 5,4-i,4, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(4,5,5, 4,5,5+i, 255-i*20, 255-i*20, 255-i*20);
  i = rnd.nextInt(4);
  cube.line(5,4,4, 5,4,4-i, 255-i*20, 255-i*20, 255-i*20);


//  // clear layer
//  cube.fill(0, 0, 0, 0.01);  // fade out
//
//  // draw scene on layer
//  for (int i = 0; i < 10; i++) {
//    int x1 = 4 + rnd.nextInt(2);
//    int y1 = 4 + rnd.nextInt(2);
//    int z1 = 4 + rnd.nextInt(2);
//    int x2 = x1 < 5? 4 - rnd.nextInt(4) : 5 + rnd.nextInt(4);
//    int y2 = y1 < 5? 4 - rnd.nextInt(4) : 5 + rnd.nextInt(4);
//    int z2 = z1 < 5? 4 - rnd.nextInt(4) : 5 + rnd.nextInt(4);
//    cube.line(x1, y1, z1, x2, y2, z2, W);
//  }

  cube.update();  // update remote device
}

void destroy() {
  cube.close();  // say goodbye cube
}