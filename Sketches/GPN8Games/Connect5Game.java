import processing.core.*;
import processing.visualcube1e3.*;
import ddf.minim.*;

// Connect5 on VisualCube1e3
// 2009-07-13
// original version by Sven Zühlsdorf
// refactored by Andreas Rentschler
class Connect5Game extends _Games_.Game {
  
  private PApplet sketch;
  private Minim minim;
  private AudioPlayer music;
  private AudioSnippet hello;
  AudioSnippet hit1;
  AudioSnippet hit2;
  AudioSnippet end;
  
  private int[][][] state = 
    new int[VisualCube.width][VisualCube.height - 1][VisualCube.depth];  
    // playground is cube minus top plane
  
  private int cursorX;
  private int cursorZ;
  
  private int player;
  private boolean over;
  private boolean fired;
  private final int neededBalls = 5;  // balls in a row you need to win  
  
  // used colors
  private final int[][] colors = {
    {0, 0, 0},        // 0: empty spot
    {255, 255, 255},  // 1: cursor
    {0, 255, 0},      // 2: player 1 balls
    {255, 0, 0},      // 3: player 2 balls
    {0, 128, 0},      // 4: player 1 balls after end
    {128, 0, 0},      // 5: player 2 balls after end
    {0, 128, 64},     // 6: player 1 top
    {128, 0, 64},     // 7: player 2 top
    {0, 0, 64},       // 8: top after end
    {255, 255, 0},    // 9: highlight
  };
  
  // directions in which you can get a row
  private final int[][] directions = {
    {1, 0, 0},    // x
    {0, 1, 0},    // y
    {0, 0, 1},    // z
    {1, 1, 0},    // xy
    {0, 1, 1},    // yz
    {1, 0, 1},    // xz
    {1, -1, 0},   // x-y
    {0, 1, -1},   // y-z
    {1, 0, -1},   // x-z
    {1, 1, 1},    // xyz
    {1, 1, -1},   // xy-z
    {-1, -1, 1},  // -x-yz
    {1, -1, 1},   // x-yz
  };
  
  public Connect5Game(PApplet sketch) {
    this.sketch = sketch;
  }

  // reset & start the next game
  public void setup() {
    minim = new Minim(sketch);
    music = minim.loadFile("Gothika and Hydraulic - Creep.mp3"/*"tornrugged.mp3"*/, 2048);
    hello = minim.loadSnippet("hello.wav");
    hit1 = minim.loadSnippet("pongblipd4.wav");
    hit2 = minim.loadSnippet("pongblipd5.wav");
    end = minim.loadSnippet("gameover.wav");
    music.loop();
    hello.play(0);

    for (int x = 0; x < VisualCube.width; x++)
      for (int y = 0; y < VisualCube.height - 1; y++)
        for (int z = 0; z < VisualCube.depth; z++)
          state[x][y][z] = 0;
    cursorX = 5;
    cursorZ = 5;
    player = 0;
    over = false;
  }
  
  public void destroy() {
    music.close();
    hello.close();    
    hit1.close();  
    hit2.close();  
    end.close();  
    minim.stop();
  }
  
  public void update() {
  }
  
  public void draw(VisualCube cube) {
    cube.fill(0, 0, 0, 0.02f);
    for (int x = 0; x < VisualCube.width; x++) {
      for (int z = 0; z < VisualCube.depth; z++) {
        // top plane
        int c1 = 
          (!over? (cursorX == x && cursorZ == z? 1 : 6 + player) : 
          (x == 0 || x == 9 || z == 0 || z == 9? 6 + player : 8));
        cube.set(x, 0, z, colors[c1][0], colors[c1][1], colors[c1][2]);
        
        // playground
        for (int y = 0; y < VisualCube.height - 1; y++) {
          int c2 = state[x][y][z];
          if (c2 == 10) { state[x][y][z] = 0; c2 = 9; }
          else if (c2 > 10) { state[x][y][z]--; c2 = 9; }
          else if ((c2 == 2 || c2 == 3) && over) c2 += 2;
          cube.set(x, y + 1, z, colors[c2][0], colors[c2][1], colors[c2][2]);
        }
      }
    }
    cube.update();
  }
  
  public boolean isOver() {
    return over && fired;
  }
  
  public void leftKey(int player) {
//    if (this.player != player) return;
    cursorX = PApplet.max(0, cursorX - 1);
  }
  public void rightKey(int player) {
//    if (this.player != player) return;
    cursorX = PApplet.min(9, cursorX + 1);
  }
  public void upKey(int player) {
//    if (this.player != player) return;
    cursorZ = PApplet.max(0, cursorZ - 1);
  }
  public void downKey(int player) {
//    if (this.player != player) return;
    cursorZ = PApplet.min(9, cursorZ + 1);
  }
  public void fireKey(int player) {
//    if (this.player != player) return;
    if (over) { fired = true; return; }
    if (player == 0) hit1.play(0); else hit2.play(0);
    switch (setBall()) {
      case 3: end.play(0); over = true; fired = false; break;
      case 1: this.player = 1 - this.player; break;
    }
  }

  // returns true iff the player who placed the ball at (x, y, z) has won
  private boolean hasBallWon(int x, int y, int z) {
    int current = state[x][y][z];
    
    for (int i = 0; i < directions.length; i++) {
      int got = 0;
      int tx = x;
      int ty = y;
      int tz = z;
      
      while (0 <= (tx - directions[i][0]) && (tx - directions[i][0]) < 10
          && 0 <= (ty - directions[i][1]) && (ty - directions[i][1]) < 9
          && 0 <= (tz - directions[i][2]) && (tz - directions[i][2]) < 10
          && state[tx - directions[i][0]][ty - directions[i][1]][tz - directions[i][2]] == current) {
        tx -= directions[i][0];
        ty -= directions[i][1];
        tz -= directions[i][2];
      }
      while (0 <= tx && tx < 10 && 0 <= ty && ty < 9 && 0 <= tz && tz < 10 && state[tx][ty][tz] == current) {
        tx += directions[i][0];
        ty += directions[i][1];
        tz += directions[i][2];
        if (++got >= neededBalls) {
          over = true;
          tx -= directions[i][0];
          ty -= directions[i][1];
          tz -= directions[i][2];
          // highlight the winning balls
          while (0 <= tx && tx < 10 && 0 <= ty && ty < 9 && 0 <= tz && tz < 10 && state[tx][ty][tz] == current) {
            state[tx][ty][tz] = 9;
            tx -= directions[i][0];
            ty -= directions[i][1];
            tz -= directions[i][2];
          }
          return true;
        }
      }
    }
    return false;
  }
  
  /*
   * puts a ball on the grid
   * returns:
   * 1 - sucessfully placed
   * 2 - place failed
   * 3 - player won
   */
  private int setBall() {
    int i = 0;
    //highlight the colum in which the ball will be placed
    while (i < 9 && (state[cursorX][i][cursorZ] == 0 || state[cursorX][i][cursorZ] >= 9)) {
      state[cursorX][i][cursorZ] = 29;  // highlight for 2 sec
      i++;
    }
    if (--i != -1) {
      // we have room for the ball, place it and check if the player has won
      state[cursorX][i][cursorZ] = 2 + player;
      return (hasBallWon(cursorX, i, cursorZ)? 3 : 1);
    }
    else return 2;  // we reached the top
  }

}

