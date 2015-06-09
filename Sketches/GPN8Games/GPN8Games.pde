/**
 * _Games_. 
 * Choose from 4 different VisualCube games. Useful for installations.
 * 
 * For more informations, visit:
 * http://www.visualcube.org
 * 
 * @author	Andreas Rentschler
 * @date	2009-07-13
 * @version	1.0
 */
import processing.visualcube1e3.*;
import ddf.minim.*;

VisualCube cube = new VisualCube(this);
Game games[] = {
  new Connect5Game(this),
  new DiamondBlastGame(this),
  new Pong3DGame(this),
  new SpaceInvadersGame(this),
};
Menu menu = new Menu((PApplet)this);
Game game = menu;

void setup() {
  size(800, 800, P3D);    // open 3D canvas
  cube.open("10.0.0.1");  // say hello to the cube
  cube.clear();           // clear the display
  cube.simulate();        // start the simulator
  game.setup();
}

void draw() {
  game.update();
  game.draw(cube);
  if (game.isOver()) {
    game.destroy();
    game = (game == menu? games[menu.getSelection()] : menu);
    game.setup();
  }
}

void keyPressed() {
  switch (key) {
    case CODED:
      switch (keyCode) {
/*
        case LEFT:    game.leftKey(0); break;
        case RIGHT:   game.rightKey(0); break;
        case UP:      game.upKey(0); break;
        case DOWN:    game.downKey(0); break;
        case CONTROL: game.fireKey(0); break;
*/
        case RIGHT:    game.leftKey(0); break;
        case LEFT:   game.rightKey(0); break;
        case DOWN:      game.upKey(0); break;
        case UP:    game.downKey(0); break;
        case CONTROL: game.fireKey(0); break;
      }
      break;

    case 'a': game.leftKey(1); break;
    case 'd': game.rightKey(1); break;
    case 'w': game.upKey(1); break;
    case 's': game.downKey(1); break;
    case 'q': game.fireKey(1); break;

    case 'f': game.leftKey(2); break;
    case 'h': game.rightKey(2); break;
    case 't': game.upKey(2); break;
    case 'g': game.downKey(2); break;
    case 'r': game.fireKey(2); break;

    case 'j': game.leftKey(3); break;
    case 'l': game.rightKey(3); break;
    case 'i': game.upKey(3); break;
    case 'k': game.downKey(3); break;
    case 'u': game.fireKey(3); break;
    
    case '*':
      for (int x = 0; x < VisualCube.width; x++)
        for (int y = 0; y < VisualCube.height; y++)
          for (int z = 0; z < VisualCube.depth; z++) {
            VisualCube.Color c = cube.get(x, y, z);
            if (c.r == 0 && c.g == 0 && c.b == 0) continue;
            println("new Voxel(" + x + ", " + y + ", " + z + ", " + c.r + ", " + c.g + ", " + c.b + "), ");
      }
      break;
  }
}

void destroy() {
  cube.clear();
  cube.update();
  cube.close();
  game.destroy();
}

abstract static class Game {
  abstract void setup();
  abstract void destroy();
  abstract void update();
  abstract void draw(VisualCube cube);
  
  abstract boolean isOver();
  
  void leftKey(int player) { };
  void rightKey(int player) { };
  void upKey(int player) { };
  void downKey(int player) { };
  void fireKey(int player) { };
}

class Menu extends Game {
  private PApplet sketch;
  private Minim minim;
  private AudioPlayer music;
  private AudioSnippet hello;
  private AudioSnippet hit1;
  private AudioSnippet hit2;
  private AudioSnippet shoot;
  
  private final float FPS = 30;

  private boolean fired;
  private float fading;
  private int selecting;
  private int selection = 0;
  private int oldSelection;
 
  private class Voxel {
    int x, y, z, r, g, b;
    Voxel(int x, int y, int z, int r, int g, int b) {
      this.x = x; this.y = y; this.z = z; this.r = r; this.g = g; this.b = b;
    }
  }
  private final Voxel[][] sprites = { 
    { new Voxel(0, 0, 0, 128, 0, 64), 
      new Voxel(0, 0, 1, 128, 0, 64), 
      new Voxel(0, 0, 2, 128, 0, 64), 
      new Voxel(0, 0, 3, 128, 0, 64), 
      new Voxel(0, 0, 4, 128, 0, 64), 
      new Voxel(0, 0, 5, 128, 0, 64), 
      new Voxel(0, 0, 6, 128, 0, 64), 
      new Voxel(0, 0, 7, 128, 0, 64), 
      new Voxel(0, 0, 8, 128, 0, 64), 
      new Voxel(0, 0, 9, 128, 0, 64), 
      new Voxel(1, 0, 0, 128, 0, 64), 
      new Voxel(1, 0, 1, 0, 0, 64), 
      new Voxel(1, 0, 2, 0, 0, 64), 
      new Voxel(1, 0, 3, 0, 0, 64), 
      new Voxel(1, 0, 4, 0, 0, 64), 
      new Voxel(1, 0, 5, 0, 0, 64), 
      new Voxel(1, 0, 6, 0, 0, 64), 
      new Voxel(1, 0, 7, 0, 0, 64), 
      new Voxel(1, 0, 8, 0, 0, 64), 
      new Voxel(1, 0, 9, 128, 0, 64), 
      new Voxel(2, 0, 0, 128, 0, 64), 
      new Voxel(2, 0, 1, 0, 0, 64), 
      new Voxel(2, 0, 2, 0, 0, 64), 
      new Voxel(2, 0, 3, 0, 0, 64), 
      new Voxel(2, 0, 4, 0, 0, 64), 
      new Voxel(2, 0, 5, 0, 0, 64), 
      new Voxel(2, 0, 6, 0, 0, 64), 
      new Voxel(2, 0, 7, 0, 0, 64), 
      new Voxel(2, 0, 8, 0, 0, 64), 
      new Voxel(2, 0, 9, 128, 0, 64), 
      new Voxel(2, 9, 2, 0, 128, 0), 
      new Voxel(3, 0, 0, 128, 0, 64), 
      new Voxel(3, 0, 1, 0, 0, 64), 
      new Voxel(3, 0, 2, 0, 0, 64), 
      new Voxel(3, 0, 3, 0, 0, 64), 
      new Voxel(3, 0, 4, 0, 0, 64), 
      new Voxel(3, 0, 5, 0, 0, 64), 
      new Voxel(3, 0, 6, 0, 0, 64), 
      new Voxel(3, 0, 7, 0, 0, 64), 
      new Voxel(3, 0, 8, 0, 0, 64), 
      new Voxel(3, 0, 9, 128, 0, 64), 
      new Voxel(3, 9, 3, 255, 255, 0), 
      new Voxel(4, 0, 0, 128, 0, 64), 
      new Voxel(4, 0, 1, 0, 0, 64), 
      new Voxel(4, 0, 2, 0, 0, 64), 
      new Voxel(4, 0, 3, 0, 0, 64), 
      new Voxel(4, 0, 4, 0, 0, 64), 
      new Voxel(4, 0, 5, 0, 0, 64), 
      new Voxel(4, 0, 6, 0, 0, 64), 
      new Voxel(4, 0, 7, 0, 0, 64), 
      new Voxel(4, 0, 8, 0, 0, 64), 
      new Voxel(4, 0, 9, 128, 0, 64), 
      new Voxel(4, 8, 4, 255, 255, 0), 
      new Voxel(4, 9, 4, 0, 128, 0), 
      new Voxel(5, 0, 0, 128, 0, 64), 
      new Voxel(5, 0, 1, 0, 0, 64), 
      new Voxel(5, 0, 2, 0, 0, 64), 
      new Voxel(5, 0, 3, 0, 0, 64), 
      new Voxel(5, 0, 4, 0, 0, 64), 
      new Voxel(5, 0, 5, 0, 0, 64), 
      new Voxel(5, 0, 6, 0, 0, 64), 
      new Voxel(5, 0, 7, 0, 0, 64), 
      new Voxel(5, 0, 8, 0, 0, 64), 
      new Voxel(5, 0, 9, 128, 0, 64), 
      new Voxel(5, 7, 5, 255, 255, 0), 
      new Voxel(5, 8, 5, 128, 0, 0), 
      new Voxel(5, 9, 5, 0, 128, 0), 
      new Voxel(6, 0, 0, 128, 0, 64), 
      new Voxel(6, 0, 1, 0, 0, 64), 
      new Voxel(6, 0, 2, 0, 0, 64), 
      new Voxel(6, 0, 3, 0, 0, 64), 
      new Voxel(6, 0, 4, 0, 0, 64), 
      new Voxel(6, 0, 5, 0, 0, 64), 
      new Voxel(6, 0, 6, 0, 0, 64), 
      new Voxel(6, 0, 7, 0, 0, 64), 
      new Voxel(6, 0, 8, 0, 0, 64), 
      new Voxel(6, 0, 9, 128, 0, 64), 
      new Voxel(6, 6, 6, 255, 255, 0), 
      new Voxel(6, 7, 6, 128, 0, 0), 
      new Voxel(6, 8, 6, 0, 128, 0), 
      new Voxel(6, 9, 6, 0, 128, 0), 
      new Voxel(7, 0, 0, 128, 0, 64), 
      new Voxel(7, 0, 1, 0, 0, 64), 
      new Voxel(7, 0, 2, 0, 0, 64), 
      new Voxel(7, 0, 3, 0, 0, 64), 
      new Voxel(7, 0, 4, 0, 0, 64), 
      new Voxel(7, 0, 5, 0, 0, 64), 
      new Voxel(7, 0, 6, 0, 0, 64), 
      new Voxel(7, 0, 7, 0, 0, 64), 
      new Voxel(7, 0, 8, 0, 0, 64), 
      new Voxel(7, 0, 9, 128, 0, 64), 
      new Voxel(7, 5, 7, 255, 255, 0), 
      new Voxel(7, 6, 7, 0, 128, 0), 
      new Voxel(7, 7, 7, 128, 0, 0), 
      new Voxel(7, 8, 7, 0, 128, 0), 
      new Voxel(7, 9, 7, 0, 128, 0), 
      new Voxel(8, 0, 0, 128, 0, 64), 
      new Voxel(8, 0, 1, 0, 0, 64), 
      new Voxel(8, 0, 2, 0, 0, 64), 
      new Voxel(8, 0, 3, 0, 0, 64), 
      new Voxel(8, 0, 4, 0, 0, 64), 
      new Voxel(8, 0, 5, 0, 0, 64), 
      new Voxel(8, 0, 6, 0, 0, 64), 
      new Voxel(8, 0, 7, 0, 0, 64), 
      new Voxel(8, 0, 8, 0, 0, 64), 
      new Voxel(8, 0, 9, 128, 0, 64), 
      new Voxel(9, 0, 0, 128, 0, 64), 
      new Voxel(9, 0, 1, 128, 0, 64), 
      new Voxel(9, 0, 2, 128, 0, 64), 
      new Voxel(9, 0, 3, 128, 0, 64), 
      new Voxel(9, 0, 4, 128, 0, 64), 
      new Voxel(9, 0, 5, 128, 0, 64), 
      new Voxel(9, 0, 6, 128, 0, 64), 
      new Voxel(9, 0, 7, 128, 0, 64), 
      new Voxel(9, 0, 8, 128, 0, 64), 
      new Voxel(9, 0, 9, 128, 0, 64), 
    },
    {
      new Voxel(1, 9, 6, 0, 0, 255), 
      new Voxel(2, 8, 6, 0, 255, 255), 
      new Voxel(2, 9, 5, 0, 255, 255), 
      new Voxel(2, 9, 6, 0, 0, 255), 
      new Voxel(3, 7, 6, 0, 0, 255), 
      new Voxel(3, 8, 5, 0, 0, 255), 
      new Voxel(3, 8, 6, 255, 0, 0), 
      new Voxel(3, 8, 7, 0, 255, 255), 
      new Voxel(3, 9, 3, 255, 0, 0), 
      new Voxel(3, 9, 4, 255, 0, 0), 
      new Voxel(3, 9, 5, 255, 0, 0), 
      new Voxel(3, 9, 6, 0, 0, 255), 
      new Voxel(3, 9, 7, 0, 0, 255), 
      new Voxel(4, 8, 7, 0, 255, 255), 
      new Voxel(4, 9, 6, 0, 0, 255), 
      new Voxel(4, 9, 7, 0, 0, 255), 
      new Voxel(5, 0, 3, 0, 255, 255), 
      new Voxel(5, 0, 4, 0, 255, 255), 
      new Voxel(5, 0, 5, 255, 0, 255), 
      new Voxel(5, 0, 6, 255, 0, 255), 
      new Voxel(5, 4, 5, 255, 0, 0), 
      new Voxel(5, 5, 4, 255, 0, 0), 
      new Voxel(5, 5, 5, 255, 0, 0), 
      new Voxel(5, 6, 4, 255, 0, 0), 
      new Voxel(5, 6, 5, 255, 255, 0), 
      new Voxel(5, 6, 7, 255, 255, 0), 
      new Voxel(5, 7, 3, 255, 0, 0), 
      new Voxel(5, 7, 4, 0, 255, 0), 
      new Voxel(5, 7, 5, 255, 0, 0), 
      new Voxel(5, 7, 6, 255, 0, 0), 
      new Voxel(5, 7, 7, 0, 0, 255), 
      new Voxel(5, 8, 3, 255, 255, 0), 
      new Voxel(5, 8, 4, 255, 255, 0), 
      new Voxel(5, 8, 5, 0, 0, 255), 
      new Voxel(5, 8, 6, 255, 0, 0), 
      new Voxel(5, 8, 7, 255, 255, 0), 
      new Voxel(5, 9, 2, 0, 255, 0), 
      new Voxel(5, 9, 3, 0, 255, 0), 
      new Voxel(5, 9, 4, 255, 0, 0), 
      new Voxel(5, 9, 5, 255, 0, 0), 
      new Voxel(5, 9, 6, 0, 0, 255), 
      new Voxel(5, 9, 7, 255, 0, 0), 
      new Voxel(6, 6, 7, 255, 255, 0), 
      new Voxel(6, 7, 5, 255, 0, 0), 
      new Voxel(6, 7, 7, 0, 0, 255), 
      new Voxel(6, 8, 4, 255, 0, 0), 
      new Voxel(6, 8, 5, 255, 255, 0), 
      new Voxel(6, 8, 7, 255, 255, 0), 
      new Voxel(6, 9, 4, 0, 255, 0), 
      new Voxel(6, 9, 5, 0, 255, 0), 
      new Voxel(6, 9, 6, 0, 255, 0), 
      new Voxel(6, 9, 7, 255, 0, 0), 
      new Voxel(7, 9, 4, 255, 255, 0), 
      new Voxel(7, 9, 5, 255, 255, 0), 
      new Voxel(8, 9, 4, 0, 0, 255), 
      new Voxel(8, 9, 5, 0, 0, 255), 
    },
    { 
      new Voxel(3, 3, 0, 240, 100, 20), 
      new Voxel(3, 3, 9, 100, 230, 30), 
      new Voxel(3, 4, 0, 240, 100, 20), 
      new Voxel(3, 4, 9, 100, 230, 30), 
      new Voxel(3, 5, 0, 240, 100, 20), 
      new Voxel(3, 5, 9, 100, 230, 30), 
      new Voxel(3, 9, 3, 100, 20, 200), 
      new Voxel(3, 9, 4, 100, 20, 200), 
      new Voxel(3, 9, 5, 100, 20, 200), 
      new Voxel(4, 0, 4, 50, 150, 200), 
      new Voxel(4, 0, 5, 50, 150, 200), 
      new Voxel(4, 0, 6, 50, 150, 200), 
      new Voxel(4, 3, 0, 240, 100, 20), 
      new Voxel(4, 3, 9, 100, 230, 30), 
      new Voxel(4, 4, 0, 240, 100, 20), 
      new Voxel(4, 4, 9, 100, 230, 30), 
      new Voxel(4, 5, 0, 240, 100, 20), 
      new Voxel(4, 5, 9, 100, 230, 30), 
      new Voxel(4, 9, 3, 100, 20, 200), 
      new Voxel(4, 9, 4, 100, 20, 200), 
      new Voxel(4, 9, 5, 100, 20, 200), 
      new Voxel(5, 0, 4, 50, 150, 200), 
      new Voxel(5, 0, 5, 50, 150, 200), 
      new Voxel(5, 0, 6, 50, 150, 200), 
      new Voxel(5, 3, 0, 240, 100, 20), 
      new Voxel(5, 3, 9, 100, 230, 30), 
      new Voxel(5, 4, 0, 240, 100, 20), 
      new Voxel(5, 4, 9, 100, 230, 30), 
      new Voxel(5, 5, 0, 240, 100, 20), 
      new Voxel(5, 5, 9, 100, 230, 30), 
      new Voxel(5, 6, 6, 255, 255, 255), 
      new Voxel(5, 6, 7, 255, 255, 255), 
      new Voxel(5, 9, 3, 100, 20, 200), 
      new Voxel(5, 9, 4, 100, 20, 200), 
      new Voxel(5, 9, 5, 100, 20, 200), 
      new Voxel(6, 0, 4, 50, 150, 200), 
      new Voxel(6, 0, 5, 50, 150, 200), 
      new Voxel(6, 0, 6, 50, 150, 200), 
      new Voxel(6, 6, 6, 255, 255, 255), 
      new Voxel(6, 6, 7, 255, 255, 255), 
      new Voxel(7, 8, 3, 1, 1, 1), 
    },
    { 
      new Voxel(0, 0, 0, 90, 165, 50), 
      new Voxel(0, 3, 1, 148, 107, 50), 
      new Voxel(0, 4, 4, 225, 30, 50), 
      new Voxel(0, 8, 3, 95, 160, 50), 
      new Voxel(1, 1, 3, 187, 68, 50), 
      new Voxel(1, 7, 2, 67, 188, 50), 
      new Voxel(1, 8, 1, 90, 165, 50), 
      new Voxel(1, 9, 1, 204, 51, 50), 
      new Voxel(2, 0, 1, 123, 132, 50), 
      new Voxel(2, 0, 3, 29, 226, 50), 
      new Voxel(2, 6, 2, 133, 122, 50), 
      new Voxel(3, 1, 3, 143, 112, 50), 
      new Voxel(3, 2, 2, 240, 15, 50), 
      new Voxel(3, 8, 0, 13, 242, 50), 
      new Voxel(4, 8, 4, 90, 165, 50), 
      new Voxel(4, 9, 0, 118, 137, 50), 
      new Voxel(4, 9, 1, 166, 89, 50), 
      new Voxel(4, 9, 3, 146, 109, 50), 
      new Voxel(5, 8, 5, 143, 112, 50), 
      new Voxel(5, 9, 1, 72, 183, 50), 
      new Voxel(5, 9, 2, 80, 175, 50), 
      new Voxel(6, 6, 3, 138, 117, 50), 
      new Voxel(6, 9, 0, 92, 163, 50), 
      new Voxel(7, 3, 9, 11, 11, 11), 
      new Voxel(7, 4, 5, 0, 0, 234), 
      new Voxel(7, 4, 9, 31, 31, 31), 
      new Voxel(7, 5, 9, 11, 11, 11), 
      new Voxel(7, 6, 5, 125, 130, 50), 
      new Voxel(7, 8, 5, 54, 201, 50), 
      new Voxel(8, 1, 1, 176, 79, 50), 
      new Voxel(8, 1, 4, 118, 137, 50), 
      new Voxel(8, 3, 5, 0, 0, 234), 
      new Voxel(8, 3, 9, 31, 31, 31), 
      new Voxel(8, 4, 4, 0, 0, 234), 
      new Voxel(8, 4, 5, 0, 0, 234), 
      new Voxel(8, 4, 9, 255, 255, 255), 
      new Voxel(8, 5, 9, 31, 31, 31), 
      new Voxel(8, 6, 0, 44, 211, 50), 
      new Voxel(9, 0, 3, 46, 209, 50), 
      new Voxel(9, 3, 9, 11, 11, 11), 
      new Voxel(9, 4, 9, 31, 31, 31), 
      new Voxel(9, 5, 3, 240, 15, 50), 
      new Voxel(9, 5, 9, 11, 11, 11), 
      new Voxel(9, 9, 4, 215, 40, 50),      
    },
    {
      new Voxel(0, 4, 4, 255, 255, 255), 
      new Voxel(1, 4, 4, 255, 255, 255), 
      new Voxel(1, 4, 5, 255, 255, 255), 
      new Voxel(1, 5, 4, 255, 255, 255), 
      new Voxel(1, 5, 5, 255, 255, 255), 
      new Voxel(1, 3, 3, 255, 255, 255), 
      new Voxel(1, 3, 4, 255, 255, 255), 
      new Voxel(1, 3, 5, 255, 255, 255), 
      new Voxel(1, 4, 3, 255, 255, 255), 
      new Voxel(1, 4, 5, 255, 255, 255), 
      new Voxel(1, 5, 3, 255, 255, 255), 
      new Voxel(1, 5, 4, 255, 255, 255), 
      new Voxel(1, 5, 5, 255, 255, 255), 
      new Voxel(8, 4, 4, 255, 255, 255), 
      new Voxel(8, 4, 5, 255, 255, 255), 
      new Voxel(8, 5, 4, 255, 255, 255), 
      new Voxel(8, 5, 5, 255, 255, 255), 
      new Voxel(8, 3, 3, 255, 255, 255), 
      new Voxel(8, 3, 4, 255, 255, 255), 
      new Voxel(8, 3, 5, 255, 255, 255), 
      new Voxel(8, 4, 3, 255, 255, 255), 
      new Voxel(8, 4, 5, 255, 255, 255), 
      new Voxel(8, 5, 3, 255, 255, 255), 
      new Voxel(8, 5, 4, 255, 255, 255), 
      new Voxel(8, 5, 5, 255, 255, 255), 
      new Voxel(9, 4, 4, 255, 255, 255), 
    },
  };

  // draw sprite with color r,g,b at position x0,y0,z0 
  private void drawSprite(int x0, int y0, int z0, Voxel[] voxels, float a) {
    for (int i = 0; i < voxels.length; i++) {
      Voxel v = voxels[i];
      cube.set(x0 + v.x, y0 + v.y, z0 + v.z, v.r, v.g, v.b, a);
    } 
  }

  public Menu(PApplet sketch) {
    this.sketch = sketch;
  }

  void setup() {
    fired = false;
    fading = 0f;
    selecting = 0;

    minim = new Minim(sketch);
    music = minim.loadFile("beatboxsplit1.mp3", 2048);
    hello = minim.loadSnippet("hello.wav");
    hit1 = minim.loadSnippet("pongblipd4.wav");
    hit2 = minim.loadSnippet("pongblipd5.wav");
    shoot = minim.loadSnippet("shoot.wav");
    music.loop();
    hello.play(0);
    
    frameRate(FPS);
  }
  
  void destroy() {
    music.close();
    hello.close();    
    hit1.close();  
    hit2.close();  
    shoot.close();  
    minim.stop();
  }
  
  void update() {
    if (fired && fading > 0.0001f) fading *= 0.95f;
    if (!fired && fading < 0.9999f) fading = 1 - ((1 - fading) * 0.95f);
    
    if (selecting < 0) selecting++;
    if (selecting > 0) selecting--;
  }
  
  void draw(VisualCube cube) {
    cube.fill(0, 0, 0);//, 0.09f);
    float pulsating = (sin(PI*frameCount/FPS*2f) + 2f) / 3f;  // wave between [0.33 .. 1]
    drawSprite(selecting, 0, 0, sprites[selection], pulsating * fading);
    if (selecting != 0)
      drawSprite(selecting + (selecting > 0? -VisualCube.width : +VisualCube.width), 0, 0, 
        sprites[oldSelection], pulsating * fading);
    drawSprite(0, 0, 0, sprites[sprites.length - 1], fading * 0.5f);
    cube.update();
  }
  
  boolean isOver() {
    return (fired && fading <= 0.0001f);
  }
  
  int getSelection() {
    return selection;
  }
  
  void leftKey(int player) {
    hit1.play(0);
    oldSelection = selection;
    selection = (selection - 1 + games.length) % games.length;
    selecting = -VisualCube.width;
  }  
  void rightKey(int player) {
    hit2.play(0);
    oldSelection = selection;
    selection = (selection + 1) % games.length;
    selecting = +VisualCube.width;
  }  
  void upKey(int player) {
    
  }  
  void downKey(int player) {
  }  
  void fireKey(int player) {
    shoot.play(0);
    fired  = true;
  }  
}