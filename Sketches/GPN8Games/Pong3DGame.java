import processing.core.*;
import processing.visualcube1e3.*;
import java.util.Random;
import ddf.minim.*;

class Pong3DGame extends _Games_.Game {
  
  Side left;
  Side right;
  Racket top;
  Racket bottom;
  Racket front;
  Racket back;
  Ball ball;
  
  private PApplet sketch;
  private Minim minim;
  private AudioPlayer music;
  private AudioSnippet hello1;
  private AudioSnippet hello2;
  AudioSnippet hit1;
  AudioSnippet hit2;
  AudioSnippet hit3;
  AudioSnippet hit4;
  AudioSnippet miss;
  AudioSnippet end;
  AudioSnippet begin;
  
  private boolean fired;

  public Pong3DGame(PApplet sketch) {
    this.sketch = sketch;
  }
  
  public void setup() {
    left = new LeftSide();
    right = new RightSide();
    top = new Racket(this, new TopSide(), new VisualCube.Color(100, 230, 30));
    bottom = new Racket(this, new BottomSide(), new VisualCube.Color(240, 100, 20));
    front = new Racket(this, new FrontSide(), new VisualCube.Color(50, 150, 200));
    back = new Racket(this, new BackSide(), new VisualCube.Color(100, 20, 200));
    ball = new Ball(this);

    minim = new Minim(sketch);
    music = minim.loadFile("beatboxsplit3.mp3", 2048);
    hello1 = minim.loadSnippet("hello.wav");
    hello2 = minim.loadSnippet("go.wav");
    hit1 = minim.loadSnippet("pongblipd4.wav");
    hit2 = minim.loadSnippet("pongblipd5.wav");
    hit3 = minim.loadSnippet("pongblipg4.wav");
    hit4 = minim.loadSnippet("pongblipg5.wav");
    miss = minim.loadSnippet("stop.wav");
    end = minim.loadSnippet("gameover.wav");
    begin = minim.loadSnippet("repeat.wav");

    music.loop();
    (new Thread(new Runnable() {
      public void run() {
        hello1.play(0);
        try {
          Thread.sleep(hello1.length() + 500);
        } catch (InterruptedException e) {
          e.printStackTrace();
        }
        hello2.play(0);
      }
    })).start();
    
    fired = false;
  }
  
  public void update() {
    if (left.paused || right.paused || top.paused || 
      bottom.paused || front.paused || back.paused) return;
    if (ball.update(this)) ball = new Ball(this);
  }
  
  public void draw(VisualCube cube) {
    cube.fill(0, 0, 0, 0.05f);

    ball.draw(cube);

    left.draw(cube);
    right.draw(cube);
    top.draw(cube);
    bottom.draw(cube);
    front.draw(cube);
    back.draw(cube);
    
    cube.update();
  }
  
  public boolean isOver() {
    return top.won || bottom.won || front.won || back.won || fired;
  }
  
  public void leftKey(int player) {
    switch (player) {
      case 0: front.moveLeft(); break;
      case 1: back.moveLeft(); break;
      case 2: top.moveLeft(); break;
      case 3: bottom.moveLeft(); break;
    }
  }

  public void rightKey(int player) {
    switch (player) {
      case 0: front.moveRight(); break;
      case 1: back.moveRight(); break;
      case 2: top.moveRight(); break;
      case 3: bottom.moveRight(); break;
    }
  }

  public void upKey(int player) {
    switch (player) {
      case 0: front.moveUp(); break;
      case 1: back.moveUp(); break;
      case 2: top.moveUp(); break;
      case 3: bottom.moveUp(); break;
    }
  }

  public void downKey(int player) {
    switch (player) {
      case 0: front.moveDown(); break;
      case 1: back.moveDown(); break;
      case 2: top.moveDown(); break;
      case 3: bottom.moveDown(); break;
    }
  }
  
  public void fireKey(int player) {
    fired = true;
  }

  public void destroy() {
    music.close();
    hello1.close();  
    hello2.close();  
    hit1.close();  
    hit2.close();  
    hit3.close();  
    hit4.close();  
    miss.close();  
    end.close();  
    begin.close();  
    minim.stop();
  }
}

class Ball {
  private Vector position;
  private Vector movement;
  private Side lastCollision;
  private Pong3DGame game;
  private VisualCube.Color color = new VisualCube.Color(200, 0, 0);
  private long timer = System.currentTimeMillis();
  private long count = 0;

  public Ball(Pong3DGame game) {
    this.game = game;
    Random r = new Random();
    position = new Vector((VisualCube.width / 2) * 100, (VisualCube.height / 2) * 100, (VisualCube.depth / 2) * 100);
    movement = new Vector(r.nextInt(20) - 10, r.nextInt(20) - 10, r.nextInt(20) - 10);
  }

  // return true iff out of field
  public boolean update(Pong3DGame game) {
    if (System.currentTimeMillis() - timer < 100) return false;
    timer = System.currentTimeMillis();
    
    if (count++ % 10 == 0) {
      movement.incrementInDirection();
      int red = (color.r + 14) % VisualCube.colors;
      int green = (color.r + 1) % VisualCube.colors;
      int blue = (color.r +8) % VisualCube.colors;
      color = new VisualCube.Color(red, green, blue);
    }
    
    position.add(movement);
    position.x = PApplet.constrain(position.x, 0, (VisualCube.width - 1) * 100);
    position.y = PApplet.constrain(position.y, 0, (VisualCube.height - 1) * 100);
    position.z = PApplet.constrain(position.z, 0, (VisualCube.depth - 1) * 100);

    Side collisionSide = null;
    if (position.x == 0) collisionSide = game.left;
    else if (position.x == (VisualCube.width - 1) * 100) collisionSide = game.right;
    else if (position.y == 0) collisionSide = game.front;
    else if (position.y == (VisualCube.height - 1) * 100) collisionSide = game.back;
    else if (position.z == 0) collisionSide = game.bottom;
    else if (position.z == (VisualCube.depth - 1) * 100) collisionSide = game.top;

    if (collisionSide != null) {
      movement = collisionSide.reflect(movement, position);
      if (movement == null) {
//        if (collisionSide instanceof Racket) (Racket)collisionSide.lost();
        if (lastCollision != null) {
          if (lastCollision instanceof Racket) ((Racket)lastCollision).won();
          lastCollision = null;
        }
        return true;
      } else if (collisionSide instanceof Racket) {
        ((Racket)collisionSide).setColor(color, 700);
        lastCollision = collisionSide;
      }
    }
    
    return false;
  }

  public void draw(VisualCube cube) {
    for (int x = position.x / 100 - 1; x < position.x / 100 + 2; x++) {
      for (int y = position.y / 100 - 1; y < position.y / 100 + 2; y++) {
        for (int z = position.z / 100 - 1; z < position.z / 100 + 2; z++) {
          if (x >= 0 && y >= 0 && z >= 0 && x < VisualCube.width && y < VisualCube.height && z < VisualCube.depth) {
            int xDiff = Math.abs(x * 100 - position.x);
            int yDiff = Math.abs(y * 100 - position.y);
            int zDiff = Math.abs(z * 100 - position.z);
            double diff = Math.sqrt(xDiff*xDiff + yDiff*yDiff + zDiff*zDiff);
            int green = (int)(100 - diff) * color.g;
            int red = (int)(100 - diff) * color.r;
            int blue = (int)(100 - diff) * color.b;
            if (green < 0) green = 0;
            if (red < 0) red = 0;
            if (blue < 0) blue = 0;
            cube.set(x, y, z, red, green, blue);
          }
        }
      }
    }
  }
}

abstract class Side {
  abstract public Vector reflect(Vector v, Vector p);
  abstract public int getVectorX(Vector v);
  abstract public int getVectorY(Vector v);
  abstract public void drawPixel(VisualCube cube, int x, int y, VisualCube.Color c);
  
  VisualCube.Color color = null;
  boolean paused = false;
  
  public synchronized void setColor(VisualCube.Color c) {
    color = c;
  }
 
  public void setColor(final VisualCube.Color c, final int time) {
    (new Thread(new Runnable() {
      public void run() {
        paused = true;
        VisualCube.Color oldColor = color;
        setColor(c);
        try {
          Thread.sleep(time);
        } catch (InterruptedException e) {
          e.printStackTrace();
        }
        setColor(oldColor);
        paused = false;
      }
    })).start();
  }

  public void draw(VisualCube cube) {
    if (color == null) return;
    for (int x = 0; x < VisualCube.width; x++)
      for (int y = 0; y < VisualCube.width; y++)
        drawPixel(cube, x, y, color);
  }
}

class Racket extends Side {
  volatile int x;
  volatile int y;
  final int length = VisualCube.width / 3;

  private Side side;
  private Pong3DGame game;

  int score = 0;
  boolean won = false;
  
  public Racket(Pong3DGame game, final Side side, VisualCube.Color color) {
    super();
    this.side = side;
    this.game = game;
    this.x = VisualCube.width / 3;
    this.y = VisualCube.height / 3;
    this.color = color;
  }
  
  public int getVectorX(Vector v) {
    return side.getVectorX(v);
  }
  public int getVectorY(Vector v) {
    return side.getVectorY(v);
  }
  public void drawPixel(VisualCube cube, int x, int y, VisualCube.Color c) {
    side.drawPixel(cube, x, y, c);
  }

  public int getScore() {
    return score;
  }
  
  public synchronized Vector reflect(Vector v, Vector p) {
    if (doesReflect(p)) {
      (new Thread(new Runnable() {
        public void run() {
          AudioSnippet hit = 
            (side instanceof FrontSide)? game.hit1 : 
            (side instanceof BackSide)? game.hit2 : 
            (side instanceof TopSide)? game.hit3 : game.hit4;
          hit.play(0);
        }
      })).start();
      return side.reflect(v, p);
    } else {
      (new Thread(new Runnable() { 
        public void run() {
          paused = true;
          VisualCube.Color oldColor = side.color;
          side.color = new VisualCube.Color(VisualCube.colors - 1, 0, 0);
          game.miss.play(0);
          try {
            Thread.sleep(game.miss.length() + 500);
          } catch (InterruptedException e) {
            e.printStackTrace();
          }
          game.begin.play(0);
          side.setColor(oldColor);
          paused = false;
        }
      })).start();

      return null;
    }
  }
  
  public boolean doesReflect(Vector v) {
    return (x <= side.getVectorX(v) / 100 && 
      x + length >= side.getVectorX(v) / 100 && 
      y <= side.getVectorY(v) / 100 && 
      y + length >= side.getVectorY(v) / 100);
  }

  public synchronized void moveLeft() {
    x = PApplet.constrain(--x, 0, VisualCube.width - length);
  }
  public synchronized void moveRight() {
    x = PApplet.constrain(++x, 0, VisualCube.width - length);
  }
  public synchronized  void moveUp() {
    y = PApplet.constrain(--y, 0, VisualCube.height - length);
  }
  public synchronized void moveDown() {
    y = PApplet.constrain(++y, 0, VisualCube.height - length);
  }

  public synchronized void won() {
    this.setColor(new VisualCube.Color(200, 200, 0), 1500);
    if (++score == (VisualCube.height - 1)) {
      (new Thread(new Runnable() {
        public void run() {
          paused = true;
          final VisualCube.Color oldColor = side.color;
          side.setColor(new VisualCube.Color(0, 200, 0));
          game.end.play(0);
          try {
            Thread.sleep(game.end.length() + 2000);
          } catch (InterruptedException e) {
            e.printStackTrace();
          }
          side.setColor(oldColor);
          won = true;
        }
      })).start();
    }
  }
  
  public void draw(VisualCube cube) {
    side.draw(cube);
    
    // draw score
    for (int i = 0; i < score; i++)
      side.drawPixel(cube, 0, i, color);

    // draw racket
    for(int x = this.x; x < this.x + length; x++) {
      for (int y = this.y; y < this.y + length; y++) {
        side.drawPixel(cube, x, y, color);
      }
    }
  }
}

abstract class VerticalXSide extends Side {
  public Vector reflect(Vector v, Vector p) {
   return new Vector(v.x, -v.y, v.z);
  }

  public int getVectorX(Vector v) {
    return v.x;
  }

  public int getVectorY(Vector v) {
    return v.z;
  }
}

abstract class VerticalYSide extends Side {
  public Vector reflect(Vector v, Vector p) {
   return new Vector(-v.x, v.y, v.z);
  }

  public int getVectorX(Vector v) {
    return v.y;
  }

  public int getVectorY(Vector v) {
    return v.z;
  }
}

abstract class HorizontalSide extends Side {
  public Vector reflect(Vector v, Vector p) {
   return new Vector(v.x, v.y, -v.z);
  }

  public int getVectorX(Vector v) {
    return v.x;
  }

  public int getVectorY(Vector v) {
    return v.y;
  }
}

class FrontSide extends VerticalXSide {
  public void drawPixel(VisualCube cube, int x, int y, VisualCube.Color c) {
    cube.set(x, 0, y, c);
  }
}
class BackSide extends VerticalXSide {
  public void drawPixel(VisualCube cube, int x, int y, VisualCube.Color c) {
    cube.set(x, VisualCube.height - 1, y, c);
  }
}

class LeftSide extends VerticalYSide {
  public void drawPixel(VisualCube cube, int x, int y, VisualCube.Color c) {
    cube.set(0, x, y, c);
  }
}

class RightSide extends VerticalYSide {
  public void drawPixel(VisualCube cube, int x, int y, VisualCube.Color c) {
    cube.set(VisualCube.width - 1, x, y, c);
  }
}

class TopSide extends HorizontalSide {
  public void drawPixel(VisualCube cube, int x, int y, VisualCube.Color c) {
    cube.set(x, y, VisualCube.depth - 1, c);
  }
}

class BottomSide extends HorizontalSide {
  public void drawPixel(VisualCube cube, int x, int y, VisualCube.Color c) {
    cube.set(x, y, 0, c);
  }
}

class Vector {
  int x;
  int y;
  int z;

  public Vector(int x, int y, int z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  public void incrementInDirection() {
    Random random = new Random();
    int count = random.nextInt(2) + 2;    
    x = (x < 0? x - count : x + count);
    count = random.nextInt(2) + 2;   
    y = (y < 0? y - count : y + count);
    count = random.nextInt(2) + 2;   
    z = (z < 0? z - count : z + count);
  }

  public void add(Vector v) {
    this.x += v.x;
    this.y += v.y;
    this.z += v.z;
  }
}
