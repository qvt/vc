import processing.core.*;
import processing.visualcube1e3.*;
import java.util.Random;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.signals.*;

// Spaceinvaders
// 2009-07-13
// original version by Robert Tagscherer
// refactored & improvements by Andreas Rentschler
class SpaceInvadersGame extends _Games_.Game {
  
  private PApplet sketch;
  private Minim minim;
  private AudioPlayer music;
  private AudioSnippet explosion;
  private AudioSnippet shot;
  private AudioSnippet gameover;
  private BeatDetect beat;
  
  private Random rnd = new Random();
  
  private int x;
  private int y;
  private int z;
  private float beatmul;
  private float ampmul;
  private int planecounter = 450;
  private Bullet bullets[];
  private Invader invaders[][][];
  
  public boolean over;
  private int ending;
  private float difficulty;
  
  public SpaceInvadersGame(PApplet sketch) {
    this.sketch = sketch;
  }

  public void setup() {
    minim = new Minim(sketch);
    music = minim.loadFile("mukke.mp3", 2048);
    explosion = minim.loadSnippet("explosion.wav");
    shot = minim.loadSnippet("shoot.wav");
    gameover = minim.loadSnippet("gameover.wav");
    
    explosion.setGain(2);
    shot.setGain(-12);
    
    beat = new BeatDetect();
    beat.setSensitivity(75);
    
    music.addListener(
      new AudioListener() {
        public void samples(float[] samps) {
          beat.detect(music.mix);
        }
        public void samples(float[] sampsL, float[] sampsR) {
          beat.detect(music.mix);
        }
      });
    music.loop();
    
    beatmul = 0f;
    ampmul = 1f;
    x = 5;
    y = 5;
    z = 9;
    planecounter = 450;
    bullets = new Bullet[10];
    invaders = new Invader[10][10][9];
    for (int tx = 0; tx <= 9; tx++)
      for (int ty = 0; ty <= 9; ty++)
        for (int tz = 0; tz <= 8; tz++)
          invaders[tx][ty][tz] = new Invader(tx, ty, tz);
          
    over = false;
    ending = 0;
    difficulty = 0.8f;
  }
  
  public void destroy() {
    music.close();
    explosion.close();
    shot.close();
    gameover.close();
    minim.stop();
  }
  
  public void update() {
    if (ending > 0 || over) return;
    
    beatmul = beat.isOnset()? 1f : (beatmul * 0.95f);
    ampmul = (music.left.level() + music.right.level()) * 150;
    
    if (++planecounter > (int)(300 / difficulty)) {
      for (int tx = 0; tx <= 9; tx++) {
        for (int ty = 0; ty <= 9; ty++) {
          for (int tz = 8; tz >= 0; tz--) {
            if (tz == 8 && invaders[tx][ty][tz].health > 0) {
              ending = 1;
              gameover.play(0);
              System.out.println("Score: " + (int)(difficulty * 100 - 80));
            }
            
            invaders[tx][ty][tz].health = 
              tz > 0? invaders[tx][ty][tz - 1].health : 
              (rnd.nextInt(100) < (int)(7 * difficulty))? rnd.nextInt(100) : 
              0;
          }
        }
      }
      planecounter = 0;
    }
    
    for (int i = 0; i < bullets.length; i++) {
      Bullet b = bullets[i];
      if (b == null) continue;
      if (invaders[b.x][b.y][b.z].health > 0) {
        invaders[b.x][b.y][b.z].health -= 25;
        if (invaders[b.x][b.y][b.z].health < 0) {
          invaders[b.x][b.y][b.z].health = 0;
          invaders[b.x][b.y][b.z].exploding++;

          explosion.play(0);
          difficulty += 0.002;
          System.out.println(difficulty);
        }
        bullets[i] = null;
      } else if (b.advance() == false) bullets[i] = null;
    }
  }
  
  public void draw(VisualCube cube) {
    cube.fill(0, 0, 0, 0.05f);

    if (ending > 0) {
      for (int tx = 0; tx <= 9; tx++)
        for (int ty = 0; ty <= 9; ty++)
          for (int tz = 0; tz <= 9; tz++)
             cube.set(tx, ty, tz, 
               (int)(rnd.nextInt(255) * (beatmul / 2 + 0.5)),
               (int)(rnd.nextInt(255) * (beatmul / 2 + 0.5)),
               (int)(rnd.nextInt(255) * (beatmul / 2 + 0.5)));
      if (++ending > 255) over = true;
    } else {
      cube.set(x, y, z, 255, 255, 255);
      
      cube.set(x, y + 1, z, (int)(155 * beatmul), (int)(155 * beatmul), (int)(155 * beatmul));
      cube.set(x, y - 1, z, (int)(155 * beatmul), (int)(155 * beatmul), (int)(155 * beatmul));
      cube.set(x + 1, y, z, (int)(155 * beatmul), (int)(155 * beatmul), (int)(155 * beatmul));
      cube.set(x - 1, y, z, (int)(155 * beatmul), (int)(155 * beatmul), (int)(155 * beatmul));
      
      cube.set(x + 1, y - 1, z, (int)(55 * beatmul), (int)(55 * beatmul), (int)(55 * beatmul));
      cube.set(x - 1, y + 1, z, (int)(55 * beatmul), (int)(55 * beatmul), (int)(55 * beatmul));
      cube.set(x + 1, y + 1, z, (int)(55 * beatmul), (int)(55 * beatmul), (int)(55 * beatmul));
      cube.set(x - 1, y - 1, z, (int)(55 * beatmul), (int)(55 * beatmul), (int)(55 * beatmul));
  
      for (int tx = 0; tx <= 9; tx++)
        for (int ty = 0; ty <= 9; ty++)
          for (int tz = 0; tz <= 8; tz++)
            invaders[tx][ty][tz].draw(cube);
          
      for (Bullet b : bullets) if (b != null) b.draw(cube);
    }
    
    cube.update();    
  }
  
  public boolean isOver() {
    return over;
  }

  public void leftKey(int player) {
    x = PApplet.max(0, x - 1);
  }
  public void rightKey(int player) {
    x = PApplet.min(9, x + 1);
  }
  public void upKey(int player) {
    y = PApplet.max(0, y - 1);
  }
  public void downKey(int player) {
    y = PApplet.min(9, y + 1);
  }
  public void fireKey(int player) {
    for (int i = 0; i < 10; i++) {
      if (bullets[i] == null) {
        bullets[i] = new Bullet(x,y);
        shot.play(0);
        break;
      }
    }
  }
  
  class Bullet {
    int x, y, z;
    
    public Bullet(int x, int y) {
      this.x = x;
      this.y = y;
      this.z = VisualCube.depth - 2;
    }
    
    public boolean advance() {
      return (--z >= 0);
    }
    
    public void draw(VisualCube cube) {
      cube.set(x, y, z, 100, 100, 255);
      cube.set(x, y, z + 1, 50, 50, 180);
    }
  }
  
  class Invader {
    public int health = 0;
    public int exploding = 0;
    public int x, y, z;
    
    public Invader(int x, int y, int z) {
      this.x = x;
      this.y = y;
      this.z = z;
    }
    
    public void draw(VisualCube cube) {
      VisualCube.Color c =
        exploding > 0? new VisualCube.Color(255 - exploding, 255 - exploding, 255 - exploding) :
        health > 0? new VisualCube.Color(
          (int)((255 - (255 * health / 100)) * 1), 
          (int)((255 * health / 100) * 1), 
          (int)ampmul) : 
        new VisualCube.Color(0, 0, 0);
      cube.set(x, y, z, c);
      
      if (exploding > 0) {
        cube.set(x, y, z, 0, 0, 255 - exploding);
        
        cube.set(x + 1, y, z, 0, 0, 255 - exploding);
        cube.set(x, y + 1, z, 0, 0, 255 - exploding);
        cube.set(x, y, z + 1, 0, 0, 255 - exploding);
        cube.set(x - 1, y, z, 0, 0, 255 - exploding);
        cube.set(x, y - 1, z, 0, 0, 255 - exploding);
        cube.set(x, y, z - 1, 0, 0, 255 - exploding);
        
        exploding += 5;
      }
    }
  }    
}
  

