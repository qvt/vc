/**
 * Sprites. 
 * Processing example by Andreas Rentschler 2009-06-10.
 * 
 * This little sketch shows the basics in controlling a VisualCube device.
 * A set of sprites are randomly printed while fading out.
 *
 * For more informations, visit:
 * http://www.visualcube.org
 * 
 * @author  Andreas Rentschler
 * @date    2009-06-10
 * @version 1.0
 */

import processing.visualcube1e3.*;
import java.util.*;

VisualCube cube = new VisualCube(this);

Random rnd = new Random();

int[][][] sprites = { {
    {0,1,1,1,0},
    {1,1,1,1,1},
    {1,0,1,0,1},
    {1,1,1,1,1},
    {1,0,1,0,1}
  }, {
    {0,1,1,1,0},
    {1,1,1,0,1},
    {1,1,0,0,0},
    {1,1,1,0,1},
    {0,1,1,1,0}
  }, {
    {0,0,1,0,0},
    {1,1,0,1,1},
    {0,0,1,0,0},
    {0,1,0,1,0},
    {1,0,0,0,1}
  }, {
    {1,0,0,0,1},
    {1,1,0,1,1},
    {0,0,1,0,0},
    {1,1,0,1,1},
    {1,0,0,0,1}
  }, {
    {1,1,1,1,1},
    {1,0,0,0,1},
    {0,0,1,0,0},
    {1,0,0,0,1},
    {1,1,1,1,1}
  }, {
    {0,1,1,1,0},
    {1,1,0,1,1},
    {1,0,0,0,0},
    {1,1,0,1,1},
    {0,1,1,1,0}
  }, {
    {0,0,0,0,0},
    {0,1,0,1,0},
    {0,0,1,0,0},
    {0,1,0,1,0},
    {0,0,0,0,0}
  }, {
    {0,0,0,0,0},
    {0,1,1,1,0},
    {0,1,0,1,0},
    {0,1,1,1,0},
    {0,0,0,0,0}
  }, {
    {1,0,1,0,1},
    {0,1,1,1,0},
    {1,1,1,1,1},
    {0,1,1,1,0},
    {1,0,1,0,1}
  }
};

final int SPRITES_NUM = sprites.length;
final int SPRITES_HEIGHT = sprites[0].length;
final int SPRITES_WIDTH = sprites[0][0].length;

void setup() {
  size(800, 800, P3D);   // open 3D canvas
  cube.open("10.0.0.1"); // say hello to the cube
  cube.clear();          // clear the display
  cube.simulate();       // start the simulator
  //frameRate(30);                  // slow down
}

void draw() {
  // determine layer

  //int z = frameCount % cube.depth;
  int z = frameCount % (cube.depth * 2);
  if (z >= cube.depth) z = cube.depth - 1 - (z - cube.depth);

  // clear layer

  //cube.cuboid(
  //  0, 0, z,
  //  cube.width - 1, cube.height - 1, z,
  //  0, 0, 0,
  //  0, 0, 0);
  cube.fill(0, 0, 0, 0.1);  // fade out

  // draw icon on layer

  drawSprite(
    rnd.nextInt(cube.width - SPRITES_WIDTH), 
    rnd.nextInt(cube.height - SPRITES_HEIGHT), 
    z, 
    rnd.nextInt(SPRITES_NUM), 
    rnd.nextInt(cube.colors),
    rnd.nextInt(cube.colors),
    rnd.nextInt(cube.colors));  
    
  cube.update();  // update remote device
}

void destroy() {
  cube.close();  // say goodbye cube
}

// draw sprite Nr. n with color r,g,b to position x0,y0,z0 
void drawSprite(int x0, int y0, int z0, int n, int r, int g, int b) {
  for (int x = 0; x < SPRITES_WIDTH; x++) {
    for (int y = 0; y < SPRITES_HEIGHT; y++) {
      cube.set(x0 + x, y0 + y, z0, r, g, b, (float) sprites[n][y][x]);  
    }
  } 
}