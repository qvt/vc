/**
 * Tree Hunt. 
 * Processing example by Andreas Rentschler 2009-06-10.
 * 
 * Hunting for an xmas tree.
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
ArrayList trees = null;
Voxel foundTree = null;
int foundCount = 0;

final VisualCube.Color W = new VisualCube.Color(0, 0, 0);
final VisualCube.Color G = new VisualCube.Color(0, 255, 0);
final VisualCube.Color P = new VisualCube.Color(255-0, 255-255, 255-0);
final VisualCube.Color X = new VisualCube.Color(255-200, 255-69, 255-18);
final VisualCube.Color B = new VisualCube.Color(200, 69, 18);

VisualCube.Color[][][] smallTree = { {
    {W,G,W},
    {G,G,G},
    {G,G,G},
    {W,B,W}
  }, {
    {W,W,W},
    {W,G,W},
    {G,G,G},
    {W,W,W}
  }
};

VisualCube.Color[][][] smallTree2 = { {
    {W,P,W},
    {P,P,P},
    {P,P,P},
    {W,X,W}
  }, {
    {W,W,W},
    {W,P,W},
    {P,P,P},
    {W,W,W}
  }
};

void setup() {
  size(800, 800, P3D);    // open 3D canvas
  cube.open("10.0.0.1");  // say hello to the cube
  cube.clear();           // clear the display
  cube.simulate();        // start the simulator
  frameRate(FRAMERATE);           // slow down
}

void draw() {
  // initialize new grove

  if (foundCount == 0) {
    foundTree = null;
    foundCount = -1;
    trees = new ArrayList();
  }
  
  // clear layer
  cube.fill(0, 0, 0, 0.5);  // fade out

  // draw scene on layer
  if ((frameCount % 3 == 0) && rnd.nextInt(2) == 0 && foundTree == null) {
    int y = rnd.nextInt(10) == 0? 3 : (rnd.nextInt(cube.height + 2) - 2);
    int z = rnd.nextInt(10) == 0? 3 : (rnd.nextInt(cube.height + 2) - 2);
    trees.add(new Voxel(-2, y, z));
  }
  
  for (int i = 0; i < trees.size(); i++) {
    Voxel tree = (Voxel)trees.get(i);
    
    if (foundTree == null && tree.x == 3 && tree.y == 3 && tree.z == 3) {
      foundTree = tree;
      foundCount = FRAMERATE * 6;
    }

    if (tree == foundTree) {
      foundCount--;
      if ((foundCount % (FRAMERATE * 2)) > FRAMERATE) {
        drawSmallTree2(tree.x, tree.y, tree.z);
      } else {
        drawSmallTree(tree.x, tree.y, tree.z);
      }
    } else {
      drawSmallTree(tree.x, tree.y, tree.z);
    
      if (foundTree == null) {
        tree.x++;
        if (tree.x > cube.width) {
          trees.remove(i); i--;
        }
      }
    }
    
  }

  cube.update();  // update remote device
}

void destroy() {
  cube.close();  // say goodbye cube
}

// draw small tree
void drawSmallTree(int x0, int y0, int z0) {
  drawSprite(x0, y0, z0 + 0, smallTree[1]);
  drawSprite(x0, y0, z0 + 1, smallTree[0]);
  drawSprite(x0, y0, z0 + 2, smallTree[1]);
}

// draw small tree with inverted colors
void drawSmallTree2(int x0, int y0, int z0) {
  drawSprite(x0, y0, z0 + 0, smallTree2[1]);
  drawSprite(x0, y0, z0 + 1, smallTree2[0]);
  drawSprite(x0, y0, z0 + 2, smallTree2[1]);
}

// draw sprite to position x0,y0,z0 
void drawSprite(int x0, int y0, int z0, VisualCube.Color[][] sprite) {
  for (int x = 0; x < sprite[0].length; x++) {
    for (int y = 0; y < sprite.length; y++) {
      if (sprite[y][x] == W) continue;
      cube.set(x0 + x, y0 + y, z0, sprite[y][x]);  
    }
  } 
}