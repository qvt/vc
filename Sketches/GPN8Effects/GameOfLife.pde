/**
 * Game Of Life. 
 * Processing example by Andreas Rentschler 2009-06-12.
 * 
 * This little sketch shows the basics in controlling a VisualCube device.
 * Game Of Life is animated in 3D.
 * Inspiration found at http://www.ibiblio.org/e-notes/Life/Game.htm
 *
 * For more informations, visit:
 * http://www.visualcube.org
 * 
 * @author	Andreas Rentschler
 * @date	2009-06-10
 * @version	1.0
 */

import processing.visualcube1e3.*;

/**/class GameOfLife extends Effect {  //VisualCube cube = new VisualCube(this);
/**/  public int getMinTimeout() { return 50000; }
/**/  public int getMaxTimeout() { return 90000; }

Random rnd = new Random();

// Game Of Life's rule set
final int MIN_NEIGHBORS_FOR_SPAWNING = 3;
final int MAX_NEIGHBORS_FOR_SPAWNING = 4;
final int MIN_NEIGHBORS_FOR_DYING = 4;
final int MAX_NEIGHBORS_FOR_DYING = 1;
final boolean ROLL_OVER = false;
final int FRAMES_PER_STEP = cube.colors / 2;
final int COLOR_INCREMENT = cube.colors/FRAMES_PER_STEP / 2;

int[][][]sum = new int[cube.depth + 2][cube.height + 2][cube.width + 2];
boolean[][][]target = new boolean[cube.depth][cube.height][cube.width];
  
void setup() {
  cube.open("192.168.2.173");     // say hello to the cube
  cube.clear();                   // clear the display
  cube.simulate(800, 800);        // show simulator canvas
  
  // set startup configuration
  for (int z = 0; z < cube.depth; z++) {
    for (int y = 0; y < cube.height; y++) {
      for (int x = 0; x < cube.width; x++) {
        target[z][y][x] = false;
      }
    }
  }
  target[0][0][0] = true;
  target[1][0][0] = true;
  target[0][1][0] = true;
  target[0][0][1] = true;

  target[9][9][9] = true;
  target[8][9][9] = true;
  target[9][8][9] = true;
  target[9][9][8] = true;
}

void draw() {
  if (frameCount % FRAMES_PER_STEP == 0)
    step();
  for (int z = 0; z < cube.depth; z++) {
    for (int y = 0; y < cube.height; y++) {
      for (int x = 0; x < cube.width; x++) {

        VisualCube.Color c = cube.get(x, y, z);
        if (target[z][y][x]) {
          if (c.r < cube.colors - 1 - COLOR_INCREMENT) c.r += COLOR_INCREMENT;
          if (c.g < cube.colors - 1 - COLOR_INCREMENT) c.g += COLOR_INCREMENT;
//          if (c.b < cube.colors - 1 - COLOR_INCREMENT) c.b += COLOR_INCREMENT;
        }
        else {
          if (c.r >= COLOR_INCREMENT) c.r -= COLOR_INCREMENT;
          if (c.g >= COLOR_INCREMENT) c.g -= COLOR_INCREMENT;
//          if (c.b >= COLOR_INCREMENT) c.b -= COLOR_INCREMENT;
        }
        cube.set(x, y, z, c);
        
      }
    }
  }
  
  cube.update();  // update remote device
}

void destroy() {
  cube.clear();   // clear the display
  cube.update();  // update remote device
  cube.close();   // say goodbye cube
}

// calculate next step
void step() {
  // clear sum of neighbors
  for (int z = 0; z < cube.depth + 2; z++) {
    for (int y = 0; y < cube.height + 2; y++) {
      for (int x = 0; x < cube.width + 2; x++) {
        sum[z][y][x] = 0;
      }
    }
  }

  // build sum of neighbors
  for (int z = 1; z < cube.depth + 1; z++) {
    for (int y = 1; y < cube.height + 1; y++) {
      for (int x = 1; x < cube.width + 1; x++) {
        if (target[z - 1][y - 1][x - 1]) {
          for (int z0 = -1; z0 <= 1; z0++) {
            for (int y0 = -1; y0 <= 1; y0++) {
              for (int x0 = -1; x0 <= 1; x0++) {
                sum[z + z0][y + y0][x + x0]++;
              }
            }
          }
          sum[z][y][x]--;
        }
      }
    }
  }

  // additional sum if field is continuing on opposite side
  if (ROLL_OVER) {
    for (int z = 0; z < cube.depth + 2; z++) {
      for (int y = 0; y < cube.height + 2; y++) {
        sum[z][y][1] += sum[z][y][cube.width + 1];
        sum[z][y][cube.width] += sum[z][y][0];
      }
    }
    for (int z = 0; z < cube.depth + 2; z++) {
      for (int x = 0; x < cube.width + 2; x++) {
        sum[z][1][x] += sum[z][cube.height + 1][x];
        sum[z][cube.height][x] += sum[z][0][x];
      }
    }
    for (int y = 0; y < cube.height + 2; y++) {
      for (int x = 0; x < cube.width + 2; x++) {
        sum[1][y][x] += sum[cube.depth + 1][y][x];
        sum[cube.depth][y][x] += sum[0][y][x];
      }
    }
  }

  // update according to rules
  for (int z = 0; z < cube.depth; z++) {
    for (int y = 0; y < cube.height; y++) {
      for (int x = 0; x < cube.width; x++) {
        int s = sum[z + 1][y + 1][x + 1];
        if (!target[z][y][x] && 
          s >= MIN_NEIGHBORS_FOR_SPAWNING &&
          s <= MAX_NEIGHBORS_FOR_SPAWNING)
          target[z][y][x] = true;
        else if (target[z][y][x] &&
          s >= MIN_NEIGHBORS_FOR_DYING ||
          s <= MAX_NEIGHBORS_FOR_DYING)
          target[z][y][x] = false;
      }
    }
  }
}

/**/}
