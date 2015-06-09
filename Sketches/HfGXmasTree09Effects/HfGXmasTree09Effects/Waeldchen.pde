/**
 * Waeldchen. 
 * Processing example by Andreas Rentschler 2009-06-10.
 * 
 * A set of treelike icons are randomly printed.
 *
 * For more informations, visit:
 * http://www.visualcube.org
 * 
 * @author	Andreas Rentschler
 * @date	2009-12-11
 * @version	1.0
 */

import processing.visualcube1e3.*;

class Waeldchen extends Effect {
public int getTimeout()
{
  return ((int)random(MAX_TIMEOUT/2) + MIN_TIMEOUT/2 + 1) * 1000;
}

//VisualCube cube = new VisualCube(this);
Random rnd = new Random();
int c0 = -1;

final VisualCube.Color W = new VisualCube.Color(0, 0, 0);
final VisualCube.Color G = new VisualCube.Color(0, 255, 0);
final VisualCube.Color P = new VisualCube.Color(255-0, 255-255, 255-0);
final VisualCube.Color X = new VisualCube.Color(255-200, 255-69, 255-18);
final VisualCube.Color B = new VisualCube.Color(200, 69, 18);

VisualCube.Color[][][] hugeTree = { {
    {W,W,G,G,W,W},
    {W,G,G,G,G,W},
    {G,G,G,G,G,G},
    {G,G,G,G,G,G},
    {W,W,B,B,W,W}
  }, {
    {W,W,W,W,W,W},
    {W,W,G,G,W,W},
    {W,G,G,G,G,W},
    {G,G,G,G,G,G},
    {W,W,W,W,W,W}
  }, {
    {W,W,W,W,W,W},
    {W,W,W,W,W,W},
    {W,W,G,G,W,W},
    {W,G,G,G,G,W},
    {W,W,W,W,W,W}
  }
};

VisualCube.Color[][][] bigTree = { {
    {W,W,G,W,W},
    {W,G,G,G,W},
    {G,G,G,G,G},
    {G,G,B,G,G},
    {W,B,B,B,W}
  }, {
    {W,W,W,W,W},
    {W,G,G,G,W},
    {G,G,G,G,G},
    {G,G,G,G,G},
    {W,B,B,B,W}
  }, {
    {W,W,W,W,W},
    {W,W,W,W,W},
    {W,G,G,G,W},
    {G,G,G,G,G},
    {W,W,W,W,W}
  }
};

VisualCube.Color[][][] mediumTree = { {
    {W,G,G,W},
    {G,G,G,G},
    {G,G,G,G},
    {W,B,B,W}
  }, {
    {W,W,W,W},
    {W,G,G,W},
    {G,G,G,G},
    {W,W,W,W}
  }
};

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
  frameRate(30);                  // slow down
}

void draw() {
  // determine layer

  if (frameCount < c0) return;
  c0 = frameCount + rnd.nextInt((int)frameRate * 3) + (int)frameRate;

  // clear layer
  cube.fill(0, 0, 0, 1.0);  // fade out

  // draw scene on layer
  switch (rnd.nextInt(10)) {
  case 0:
    drawMediumTree(0, 0, 0);
    drawMediumTree(6, 0, 0);
    drawMediumTree(0, 6, 0);
    drawMediumTree(6, 6, 0);
    drawMediumTree(0, 0, 6);
    drawMediumTree(5, 0, 6);
    drawMediumTree(0, 6, 6);
    drawMediumTree(6, 6, 6);
    break;
  case 1:
    drawHugeTree(2, 3, 2);
    drawSmallTree(0, 0, 0);
    drawSmallTree(7, 0, 0);
    drawSmallTree(0, 6, 0);
    drawSmallTree(7, 6, 0);
    drawSmallTree(0, 0, 7);
    drawSmallTree(7, 0, 7);
    drawSmallTree(0, 6, 7);
    drawSmallTree(7, 6, 7);
    break;
  default:
    int x0 = rnd.nextInt(3) - 3;
    int y0 = rnd.nextInt(3) - 3;
    int z0 = rnd.nextInt(3) - 3;

    int rx = rnd.nextInt(3);
    int ry = rnd.nextInt(3);
    int rz = rnd.nextInt(3);

    for (int x = 0; x < 3; x++) {
      for (int y = 0; y < 3; y++) {
        for (int z = 0; z < 3; z++) {
          if (x == rx && y == ry && z == rz)
            drawSmallTree2(x0 + x * 4, y0 + y * 5, z0 + z * 4);
          else if (rnd.nextInt(10) > 4) 
            drawSmallTree(x0 + x * 4, y0 + y * 5, z0 + z * 4);
        }
      }
    }
    break;
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

// draw medium tree
void drawMediumTree(int x0, int y0, int z0) {
  drawSprite(x0, y0, z0 + 0, mediumTree[1]);
  drawSprite(x0, y0, z0 + 1, mediumTree[0]);
  drawSprite(x0, y0, z0 + 2, mediumTree[0]);
  drawSprite(x0, y0, z0 + 3, mediumTree[1]);
}

// draw big tree
void drawBigTree(int x0, int y0, int z0) {
  drawSprite(x0, y0, z0 + 0, bigTree[2]);
  drawSprite(x0, y0, z0 + 1, bigTree[1]);
  drawSprite(x0, y0, z0 + 2, bigTree[0]);
  drawSprite(x0, y0, z0 + 3, bigTree[1]);
  drawSprite(x0, y0, z0 + 4, bigTree[2]);
}

// draw huge tree
void drawHugeTree(int x0, int y0, int z0) {
  drawSprite(x0, y0, z0 + 0, hugeTree[2]);
  drawSprite(x0, y0, z0 + 1, hugeTree[1]);
  drawSprite(x0, y0, z0 + 2, hugeTree[0]);
  drawSprite(x0, y0, z0 + 3, hugeTree[0]);
  drawSprite(x0, y0, z0 + 4, hugeTree[1]);
  drawSprite(x0, y0, z0 + 5, hugeTree[2]);
}

// draw sprite to position x0,y0,z0 
void drawSprite(int x0, int y0, int z0, VisualCube.Color[][] sprite) {
  for (int x = 0; x < sprite[0].length; x++) {
    for (int y = 0; y < sprite.length; y++) {
      cube.set(x0 + x, y0 + y, z0, sprite[y][x]);  
    }
  } 
}

}