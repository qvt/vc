/**
 * Tetris3D. 
 * Processing example by Andreas Rentschler 2013-05-26. 
 * 
 * This sketch is designed for the GPN13 hacker meeting.
 * Hint for Mac users: 
 *
 * For more informations, visit:
 * http://www.visualcube.org
 * 
 * @author  Andreas Rentschler
 * @date  2013-05-26
 * @version  1.0
 */

// BUG: Rotation sometimes causes displacement (rounding error, or interrupted by dropping timeout?)

import processing.visualcube1e3.*;

VisualCube cube = new VisualCube(this);

// time till the current block drops
final int DROP_INTERVAL_NORMAL = 1500;
final int DROP_INTERVAL_SUPER = 150;
int dropTime;
boolean dropCompletely = false;

// timer for blinking of shadow
final int BLINK_INTERVAL = 500;
int blinkTime;
boolean blinkerActive = false;
final VisualCube.Color blinkColor = new VisualCube.Color(255, 255, 255);

// the tetris blocks
ArrayList<Block> allBlocks = new ArrayList<Block>();

// time till next input action in command series is played from script
final boolean SCRIPT_RECORDING_MODE = false; // activate to record a script
int scriptRecorderSimulatedTime;  // instead of using millis(), add SCRIPT_INTERVAL per executed command
final int SCRIPT_INTERVAL = 500;
int scriptTime;

CommandType[] scriptCommands = {
  CommandType.DROP, CommandType.NOP, CommandType.ROTATEX, CommandType.FORWARD, CommandType.RIGHT, CommandType.RIGHT, CommandType.DROP, CommandType.LEFT, CommandType.NOP, CommandType.ROTATEX,
  CommandType.ROTATEX, CommandType.ROTATEX, CommandType.FORWARD, CommandType.DROP, CommandType.NOP, CommandType.RIGHT, CommandType.RIGHT, CommandType.ROTATEX, CommandType.ROTATEX, CommandType.ROTATEY, CommandType.ROTATEZ, CommandType.ROTATEX,
  CommandType.ROTATEZ, CommandType.ROTATEZ, CommandType.ROTATEZ, CommandType.ROTATEY, CommandType.ROTATEY, CommandType.ROTATEY, CommandType.ROTATEY, CommandType.ROTATEZ, CommandType.ROTATEY, CommandType.ROTATEY, CommandType.DROP,
  CommandType.LEFT, CommandType.LEFT, CommandType.ROTATEY, CommandType.NOP, CommandType.ROTATEZ, CommandType.ROTATEZ
};
BlockType[] scriptBlocks = {
  BlockType.BLOCK_LINE,
  BlockType.BLOCK_SQUIGGLE,
  BlockType.BLOCK_SQUIGGLE, 
  BlockType.BLOCK_CORNER2, 
  BlockType.BLOCK_SQUARE  
};

int currentScriptCommand;
int currentScriptBlock;
boolean executeScriptedDrop;

boolean paused;
boolean gameOver;
int rowsCompleted;

void setup() {
  size(800, 800, P3D);    // open 3D canvas
  cube.open("10.0.0.1");  // say hello to the cube
  cube.clear();           // clear the display
  cube.simulate();        // start the simulator

  reset();
}

////////////////////////////////////////////////////////////////////////////
void draw() {
  cube.clear();
  
  if(!paused && !gameOver) {
    // if scene is full, then game is over
    for (int i = 0; i < allBlocks.size() - 1; i++) {
      for (Cube cube : allBlocks.get(i).cubes) {
        if (cube.y <= 0) {
          print("Game over.");
          gameOver = true;
        }
      }
    }

    // if old one is dropped, check if a row is completed, create new block
    allBlocks.get(allBlocks.size() - 1).update();
    if (allBlocks.get(allBlocks.size() - 1).dropped) {
      for (int i = 0; i < VisualCube.height; i++) {
        boolean complete = isRowComplete(i);
        if (complete) {
          print("Row completed.");
          clearRow(i);
          rowsCompleted++;
          i--;
        }
      }
      allBlocks.add(currentScriptBlock < scriptBlocks.length? 
        new Block(scriptBlocks[currentScriptBlock++]) : new Block());
      // if complete drop was asked for, reset
      dropCompletely = false;
      int time = (SCRIPT_RECORDING_MODE && !dropCompletely)? scriptRecorderSimulatedTime : millis();
      dropTime = time + DROP_INTERVAL_NORMAL;
    }
    
    // execute script
    if (millis() > scriptTime) {
      if (currentScriptCommand < scriptCommands.length) {
        print("play scripted ");
        doCommand(scriptCommands[currentScriptCommand++]);
      }
      scriptTime = millis() + SCRIPT_INTERVAL;
    }

    // drop blocks in scene
    int time = (SCRIPT_RECORDING_MODE && !dropCompletely)? scriptRecorderSimulatedTime : millis();
    if (time > dropTime) {
      allBlocks.get(allBlocks.size() - 1).drop();
      dropTime = time + (dropCompletely? DROP_INTERVAL_SUPER : DROP_INTERVAL_NORMAL);
      executeScriptedDrop = false;
      currentScriptCommand++;
    }
  }

  // update shadow timer
  if (millis() > blinkTime) {
    blinkerActive = (blinkerActive? false : true);
    blinkTime = millis() + BLINK_INTERVAL;
  }

  // draw scene
  for (Block block : allBlocks) {
    block.display();
  }

  cube.update();  // update remote device
}

////////////////////////////////////////////////////////////////////////////
void stop() {
  super.stop();  // close sketch
}

////////////////////////////////////////////////////////////////////////////
void destroy() {
  cube.close();  // say goodbye cube
}

////////////////////////////////////////////////////////////////////////////
// For testing purposes without a script
void keyPressed() {
  switch(keyCode) {
    case UP: doCommand(CommandType.BACKWARD); break;
    case DOWN: doCommand(CommandType.FORWARD); break;
    case LEFT: doCommand(CommandType.LEFT); break;
    case RIGHT: doCommand(CommandType.RIGHT); break;
    case 'Q': case 'q': doCommand(CommandType.ROTATEX); break;
    case 'W': case 'w': doCommand(CommandType.ROTATEY); break;
    case 'E': case 'e': doCommand(CommandType.ROTATEZ); break;
    case ' ': doCommand(CommandType.DROP); break;
    case 'R': case 'r': doCommand(CommandType.RESET); break;
    case 'P': case 'p': doCommand(CommandType.PAUSE); break;
    case 'N': case 'n': doCommand(CommandType.NOP); /* wait for drop, useful for script recording */ break;
    case '1': case '2': case '3': case '4': case '5': case '6': case '7': /* for script recording */
      print("BlockType." + BlockType.values()[keyCode - '1'] + ", "); 
      allBlocks.remove(allBlocks.size() - 1); 
      allBlocks.add(new Block(BlockType.values()[keyCode - '1'])); 
      break;
  }
}

////////////////////////////////////////////////////////////////////////////
void doCommand(CommandType type) {
  Block currentScriptBlock = allBlocks.get(allBlocks.size() - 1);
  print("CommandType." + type + ", ");
  switch(type) {
    case NOP: currentScriptCommand--; executeScriptedDrop = true; /* simulate wait till next drop timeout */ break;
    case RESET: reset(); break;
    case PAUSE: paused = (paused? false : true); break;
    case LEFT: currentScriptBlock.move(-1, 0); break;
    case RIGHT: currentScriptBlock.move(+1, 0); break;
    case FORWARD: currentScriptBlock.move(0, +1); break;
    case BACKWARD: currentScriptBlock.move(0, -1); break;
    case ROTATEX: currentScriptBlock.rotate(90, 0, 0); break;
    case ROTATEY: currentScriptBlock.rotate(0, 90, 0); break;
    case ROTATEZ: currentScriptBlock.rotate(0, 0, 90); break;
    case DROP: currentScriptBlock.dropCompletely(); break;
  }
  if (SCRIPT_RECORDING_MODE && type != CommandType.RESET && type != CommandType.PAUSE && type != CommandType.DROP) 
    scriptRecorderSimulatedTime += SCRIPT_INTERVAL;
}

////////////////////////////////////////////////////////////////////////////
void reset() {
  gameOver = false; 
  paused = false; 
  rowsCompleted = 0;
  dropTime = (SCRIPT_RECORDING_MODE? scriptRecorderSimulatedTime : millis()) + DROP_INTERVAL_NORMAL;
  blinkTime = millis() + BLINK_INTERVAL;
  //scriptTime = millis() + SCRIPT_INTERVAL;
  if (SCRIPT_RECORDING_MODE) scriptRecorderSimulatedTime = 0;
  currentScriptCommand = 0;
  currentScriptBlock = 0;
  executeScriptedDrop = false;
  
  allBlocks.clear();
  allBlocks.add(currentScriptBlock < scriptBlocks.length? 
    new Block(scriptBlocks[currentScriptBlock++]) : new Block());
}

////////////////////////////////////////////////////////////////////////////
boolean isRowComplete(int row) {
  for (int x = 0; x < VisualCube.width; x++) {
    for (int y = 0; y < VisualCube.depth; y++) {
      boolean spotOccupied = false;
      for (Block block : allBlocks) {
        for (Cube cube : block.cubes) {
          if (abs(row - cube.z) < 0.5 && abs(x - cube.x) < 0.5 && abs(y - cube.y) < 0.5) {
            spotOccupied = true;
          }
        }
      }
      if (!spotOccupied) return false;
    }
  }
  return true;
}

////////////////////////////////////////////////////////////////////////////
void clearRow(int row) {
  for (Block block : allBlocks) {
    for (Cube cube : block.cubes) {
      if (abs(row - cube.y) < 0.5) {
        block.cubes.remove(cube);
      }
      else if (cube.y < row) {
        cube.y++;
      }
    }
  }
}

////////////////////////////////////////////////////////////////////////////
// each tetris block is constructed from cubes
class Block {
  ArrayList<Cube> cubes = new ArrayList<Cube>();
  boolean dropped = false;
  Point3D shapeCenter;
  VisualCube.Color shapeColor;
  float rotationSpeedX;
  float rotationSpeedY;
  float rotationSpeedZ;

  Block(BlockType type) {
    switch(type) {
      case BLOCK_SQUARE:
        cubes.add(new Cube(0, 0, 0));
        cubes.add(new Cube(1, 0, 0));
        cubes.add(new Cube(0, 0, 1));
        cubes.add(new Cube(1, 0, 1));
        shapeCenter = new Point3D(0, 0, 0);
        shapeColor = new VisualCube.Color(255, 0, 0);
        break;
      case BLOCK_T:
        cubes.add(new Cube(1, 0, 1));
        cubes.add(new Cube(0, 0, 1));
        cubes.add(new Cube(0, 0, 2));
        cubes.add(new Cube(0, 0, 0));
        shapeCenter = new Point3D(0, 0, 1);
        shapeColor = new VisualCube.Color(255, 165, 0);
        break;
      case BLOCK_LINE:
        cubes.add(new Cube(0, 0, 0));
        cubes.add(new Cube(1, 0, 0));
        cubes.add(new Cube(2, 0, 0));
        cubes.add(new Cube(3, 0, 0));
        shapeCenter = new Point3D(1, 0, 0);
        shapeColor = new VisualCube.Color(0, 0, 255);
        break;
      case BLOCK_SQUIGGLE:
        cubes.add(new Cube(0, 0, 0));
        cubes.add(new Cube(1, 0, 0));
        cubes.add(new Cube(1, 0, 1));
        cubes.add(new Cube(2, 0, 1));
        shapeCenter = new Point3D(1, 0, 0);
        shapeColor = new VisualCube.Color(160, 32, 240);
        break;
      case BLOCK_L:
        cubes.add(new Cube(0, 0, 1));
        cubes.add(new Cube(0, 0, 0));
        cubes.add(new Cube(1, 0, 0));
        cubes.add(new Cube(2, 0, 0));
        shapeCenter = new Point3D(1, 0, 0); 
        shapeColor = new VisualCube.Color(0, 255, 0);
        break;
      case BLOCK_CORNER1:
        cubes.add(new Cube(0, 1, 0));
        cubes.add(new Cube(1, 1, 0));
        cubes.add(new Cube(1, 0, 0));
        cubes.add(new Cube(1, 1, 1));
        shapeCenter = new Point3D(1, 1, 0);
        shapeColor = new VisualCube.Color(255, 255, 0);
        break;
      case BLOCK_CORNER2:
        cubes.add(new Cube(0, 1, 0));
        cubes.add(new Cube(1, 1, 0));
        cubes.add(new Cube(1, 0, 0));
        cubes.add(new Cube(0, 1, 1));
        shapeCenter = new Point3D(0, 1, 0);
        shapeColor = new VisualCube.Color(255, 20, 147);
        break;
    }
    // translate to center of field
    for (Cube cube : cubes) {
      cube.x += VisualCube.width/2 - shapeCenter.x - 1;
      cube.z += VisualCube.depth/2 - shapeCenter.z - 1;
    }
    shapeCenter.x += VisualCube.width/2 - shapeCenter.x - 1;
    shapeCenter.z += VisualCube.depth/2 - shapeCenter.z - 1;
  }

  Block() {
    this(BlockType.values()[(int)random(0, BlockType.values().length)]);
  }

  void display() {
    for (Cube cube : cubes) {
      cube.display(shapeColor);
      if (!dropped && !gameOver && blinkerActive) {
        cube.displayShadow();
      }
    }
  }

  void rotate(float angleX, float angleY, float angleZ) {
    update();
    if (!dropped) {
      // create temporary copy
      ArrayList<Cube> newCubes = new ArrayList<Cube>();
      for (Cube cube : cubes) {
        newCubes.add(new Cube(cube.x, cube.y, cube.z));
      }

      // translate to center
      for (Cube cube : newCubes) {
        cube.x -= shapeCenter.x; 
        cube.y -= shapeCenter.y; 
        cube.z -= shapeCenter.z;
      }

      // do the rotation
      for (Cube cube : newCubes) {
        float newX, newY, newZ;
        
        newZ = cube.y * sin(radians(angleX)) + cube.z * cos(radians(angleX));
        newY = cube.y * cos(radians(angleX)) - cube.z * sin(radians(angleX));
        cube.y = round(newY);
        cube.z = round(newZ);
        
        newX = cube.z * sin(radians(angleY)) + cube.x * cos(radians(angleY));
        newZ = cube.z * cos(radians(angleY)) - cube.x * sin(radians(angleY));
        cube.x = round(newX);
        cube.z = round(newZ);
        
        newX = cube.x * cos(radians(angleZ)) - cube.y * sin(radians(angleZ));
        newY = cube.x * sin(radians(angleZ)) + cube.y * cos(radians(angleZ));
        cube.x = round(newX);
        cube.y = round(newY);
      }

      // translate back
      for (Cube cube : newCubes) {
        cube.x += shapeCenter.x;
        cube.y += shapeCenter.y;
        cube.z += shapeCenter.z;
      }

      // if in bounds, this is the new state
      boolean notInBounds = false;
      for (Cube cube : newCubes) {
        if (!cube.isInBounds()) notInBounds = true;
      }
      if (!notInBounds && !droppedBlocksCollideWith(newCubes)) {
        cubes = newCubes;
      }
    }
  }

  void drop() {
    boolean goOn = true;
    for (Cube cube : cubes) {
      if (cube.y == VisualCube.height - 1) {
        goOn = false;
      }
    }
    for (int i = 0; i < allBlocks.size() - 1; i++) {
      for (Cube otherCube : allBlocks.get(i).cubes) {
        for (Cube cube : cubes) {
          if (otherCube.collidesWith(new Cube(cube.x, cube.y + 1, cube.z))) {
            dropped = true;
            goOn = false;
          }
        }
      }
    }
    if (goOn) {
      for (Cube cube : cubes) cube.y++;
      shapeCenter = new Point3D(shapeCenter.x, shapeCenter.y + 1, shapeCenter.z);
    }
  }
  
  void dropCompletely() {
    //for (int i = 0; i < VisualCube.height; i++) {
    //  drop();
    //  update();
    //}
    // enable light speed dropping till it lands
    dropCompletely = true;
    dropTime = millis() + DROP_INTERVAL_SUPER;
  }

  void move(float diffX, float diffZ) {
    update();
    boolean goOn = true;
    for (Cube cube : cubes) {
      if (cube.x + diffX < 0 || cube.x + diffX > VisualCube.width - 1 || 
          cube.z + diffZ < 0 || cube.z + diffZ > VisualCube.depth - 1 || 
          dropped) {
        goOn = false;
      }
    }
    for (int i = 0; i < allBlocks.size() - 1; i++) {
      for (Cube otherCube : allBlocks.get(i).cubes) {
        for (Cube cube : cubes) {
          if (otherCube.collidesWith(new Cube(cube.x + diffX, cube.y, cube.z + diffZ))) {
            //dropped = true;
            goOn = false;
          }
        }
      }
    }
    if (goOn) {
      for (Cube cube : cubes) {
        cube.x += diffX;
        cube.z += diffZ;
      }
      shapeCenter.x += diffX;
      shapeCenter.z += diffZ;
    }
  }

  // Has the active block reached the bottom, or does it collide with dropped blocks?
  boolean hasCollided() {
    for (Cube cube : cubes) {
      if (cube.y >= VisualCube.height - 1) {
        return true;
      }
    }
    for (int i = 0; i < allBlocks.size() - 1; i++) {
      for (Cube otherCube : allBlocks.get(i).cubes) {
        for (Cube cube : cubes) {
          if (otherCube.collidesWith(cube)) {
            return true;
          }
        }
      }
    }
    return false;
  }
  
  // Update the active block's state
  void update() {
    if (hasCollided()) dropped = true;
  }

  // Check if one of the new cubes collides with the existing dropped cubes
  boolean droppedBlocksCollideWith(ArrayList<Cube> newCubes) {
    for (int i = 0; i < allBlocks.size() - 1; i++) {
      for (Cube otherCube : allBlocks.get(i).cubes) {
        for (Cube newCube : newCubes) {
          if (otherCube.collidesWith(newCube)) {
            return true;
          }
        }
      }
    }
    return false;
  }
}

////////////////////////////////////////////////////////////////////////////
// Blocks are constructed from cubes
class Cube {
  float x, y, z;

  Cube(float x1, float y1, float z1) {
    x = x1; y = y1; z = z1;
  }

  // Collision detection
  boolean collidesWith(Cube c) {
    return (abs(x - c.x) < 0.5 && abs(y - c.y) < 0.5 && abs(z - c.z) < 0.5);
  }

  boolean isInBounds() {
    return (x >= 0 && x < VisualCube.width && y >= 0 && y < VisualCube.width && z >= 0 && z < VisualCube.depth);
  }

  void displayShadow() {
    float maxY = VisualCube.height;
    for (int i = 0; i < allBlocks.size() - 1; i++) {
      for (Cube cube : allBlocks.get(i).cubes) {
        if (cube.y < maxY && abs(x - cube.x) < 0.5 && abs(z - cube.z) < 0.5) {
          maxY = cube.y;
        }
      }
    }
    cube.set((int)x, (int)maxY - 1, (int)z, blinkColor);
  }

  void display(VisualCube.Color c) {
    cube.set((int)x, (int)y, (int)z, ((paused || gameOver) && blinkerActive)? blinkColor : c);
  }

  String toString() {
    return "(" + x + ", " + y + ", " + z + ")";
  }
}

class Point3D {
  float x = 0, y = 0, z = 0;

  Point3D(float x, float y, float z) {
    this.x = x; this.y = y; this.z = z;
  }

  String toString() {
    return "(" + x + ", " + y + ", " + z + ")";
  }
}
