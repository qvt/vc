import processing.core.*;
import processing.visualcube1e3.*;
import ddf.minim.*;
import java.util.HashSet;
import java.util.Random;

class DiamondBlastGame extends _Games_.Game {
  
  Minim minim;
  AudioPlayer music;
  AudioSnippet begin;
  AudioSnippet end;
  AudioSnippet settle;
  AudioSnippet blast;
  
  PApplet sketch;
  
  Field field;
  Piece piece;  
  
  int score = 0;
  int timer = 0;
  int speed = 800;
  
  boolean over = false;
  
  DiamondBlastGame(PApplet sketch) {
    this.sketch = sketch;
  }
  
  public void setup() {
    field = new Field(this);
    piece = new Piece();

    minim = new Minim(sketch);

    music = minim.loadFile("Binarpilot - Defrag - 01 - Goof.mp3", 2048);
    begin = minim.loadSnippet("go.wav");
    end = minim.loadSnippet("gameover.wav");
    settle = minim.loadSnippet("pongblipe5.wav");
    blast = minim.loadSnippet("orangenoise.wav");

    music.loop();
    begin.play(0);
  }

  public boolean isOver() {
    return over;
  }

  public void leftKey(int player) {
    if (piece != null) piece.moveLeft(field);
  }  
  public void rightKey(int player) {
    if (piece != null) piece.moveRight(field);
  }  
  public void upKey(int player) {
    if (piece != null) piece.moveFront(field);
  }  
  public void downKey(int player) {
    if (piece != null) piece.moveRear(field);
  }  
  public void fireKey(int player) {
    if (piece != null) while(piece.moveDown(field));
  }
  
  public void update() {
    if (sketch.millis() - timer >= speed) {
      timer = sketch.millis();

      if (field.update()) return;
      if (over) return;

      if (piece == null) {
        piece = new Piece();
        if (piece.collides(field)) end.play(0);
      } else {
        if (piece.collides(field)) over = true;
        else if (!piece.moveDown(field)) {
          settle.play(0);
          field.addPiece(piece);
          piece = null;
        }
      }
    }
  }
  
  public void draw(VisualCube cube) {
    cube.fill(0, 0, 0, 0.05f);
    if (field != null) field.draw(cube);
    if (piece != null) piece.draw(cube);
    cube.update();
  }

  public void destroy() {
    music.close();
    begin.close();
    end.close();
    settle.close();
    blast.close();
    minim.stop();
  }
}

class Field {
  HashSet<Particle> particles = new HashSet<Particle>();
  DiamondBlastGame game;
  
  Field(DiamondBlastGame game) {
    this.game = game;
  }
  
  // add piece to field
  void addPiece(Piece piece) {
    for (Particle p : piece.particles) particles.add(p);
  }
  
  // render physics of field
  // return true iff changes applied
  boolean update() {
    boolean changed = false;
    
    // kill dead particles
    HashSet<Particle> particles2 = new HashSet(particles);
    for (Particle p : particles) {
      if (p.isDead()) {
        particles2.remove(p);
        changed = true;
      }
    }
    particles = particles2;
    if (changed) return true;
    
    // drop particle if hovering
    for (Particle p1 : particles) {
      boolean free = true;
      for (Particle p2 : particles) {
        if (p1.x == p2.x && p1.z == p2.z && p1.y + 1 == p2.y) {
          free = false;
          break;
        }
      }
      if (free && p1.y < VisualCube.height - 1) {
        p1.y++;
        changed = true;
      }
    }
    if (changed) return true;
    
    // blast particles if at least 8 of them of same color are in contact
    for (Particle p : particles) {
      HashSet<Particle> neighbors = p.getNeighbors(particles);
      if (neighbors.size() >= 8) {
        game.blast.play(0);
        for (Particle n : neighbors) n.kill();
        changed = true;
        // update score and difficulty
        for (int s = 1; s <= neighbors.size(); s++) game.score += s * (1000 - game.speed);
        if (game.speed > 100) game.speed -= 5;
        PApplet.println("Score = " + game.score);
      }
    }
    if (changed) return true;

    return false;
  }
  
  // draw particles
  void draw(VisualCube cube) {
    for (Particle p : particles) {
      p.draw(cube);
    }
  }
}

class Piece {
  HashSet<Particle> particles = new HashSet();
  
  VisualCube.Color[] colors = {
    new VisualCube.Color(VisualCube.colors - 1, 0, 0),
    new VisualCube.Color(0, VisualCube.colors - 1, 0),
    new VisualCube.Color(0, 0, VisualCube.colors - 1),
    new VisualCube.Color(VisualCube.colors - 1, VisualCube.colors - 1, 0),
    new VisualCube.Color(VisualCube.colors - 1, 0, VisualCube.colors - 1),
    new VisualCube.Color(0, VisualCube.colors - 1, VisualCube.colors - 1),
  };

  // create a random piece at top of field
  Piece() {
    int m = VisualCube.width / 2;
    Random r = new Random();
    switch(r.nextInt(4)) {
      case 0: {
        int c1 = r.nextInt(colors.length);
        int c2 = r.nextInt(colors.length);
        particles.add(new Particle(m + 0, 0, m + 0, colors[c1]));
        particles.add(new Particle(m + 0, 0, m + 1, colors[c1]));
        particles.add(new Particle(m + 1, 0, m + 0, colors[c2]));
        particles.add(new Particle(m + 1, 0, m + 1, colors[c2]));
        break;
      }
      case 1: {
        int c1 = r.nextInt(colors.length);
        int c2 = r.nextInt(colors.length);
        particles.add(new Particle(m + 0, 0, m, colors[c1]));
        particles.add(new Particle(m + 1, 0, m, colors[c1]));
        particles.add(new Particle(m + 0, 1, m, colors[c2]));
        particles.add(new Particle(m + 1, 1, m, colors[c2]));
        break;
      }
      case 2: {
        int c1 = r.nextInt(colors.length);
        int c2 = r.nextInt(colors.length);
        particles.add(new Particle(m - 2, 0, m + 0, colors[c1]));
        particles.add(new Particle(m - 1, 0, m + 0, colors[c1]));
        particles.add(new Particle(m - 0, 0, m + 0, colors[c2]));
        particles.add(new Particle(m + 1, 0, m + 0, colors[c2]));
        break;
      }
      case 3: {
        int c1 = r.nextInt(colors.length);
        int c2 = r.nextInt(colors.length);
        particles.add(new Particle(m + 0, 0, m - 2, colors[c1]));
        particles.add(new Particle(m + 0, 0, m - 1, colors[c1]));
        particles.add(new Particle(m + 0, 0, m - 0, colors[c2]));
        particles.add(new Particle(m + 0, 0, m + 1, colors[c2]));
        break;
      }
    }
  }
  
  // return true iff piece collides with field
  boolean collides(Field field) {
    for (Particle p1 : particles) {
      for (Particle p2 : field.particles) {
        if (p1.x == p2.x && p1.y == p2.y && p1.z == p2.z) return true;
      }
    }
    return false;
  }
  // move to the left, return true iff successful
  boolean moveLeft(Field field) {
    for (Particle p1 : particles) {
      if (p1.x <= 0) return false;
      for (Particle p2 : field.particles) {
        if (p1.x - 1 == p2.x && p1.y == p2.y && p1.z == p2.z) return false;
      }
    }

    for (Particle p : particles) {
      p.x--;
    }
    return true;
  }
  // move to the right, return true iff successful
  boolean moveRight(Field field) {
    for (Particle p1 : particles) {
      if (p1.x + 1 >= VisualCube.width) return false;
      for (Particle p2 : field.particles) {
        if (p1.x + 1 == p2.x && p1.y == p2.y && p1.z == p2.z) return false;
      }
    }

    for (Particle p : particles) {
      p.x++;
    }
    return true;
  }
  // move to the front, return true iff successful
  boolean moveFront(Field field) {
    for (Particle p1 : particles) {
      if (p1.z <= 0) return false;
      for (Particle p2 : field.particles) {
        if (p1.x == p2.x && p1.y == p2.y && p1.z - 1 == p2.z) return false;
      }
    }

    for (Particle p : particles) {
      p.z--;
    }
    return true;
  }
  // move to the rear, return true iff successful
  boolean moveRear(Field field) {
    for (Particle p1 : particles) {
      if (p1.z + 1 >= VisualCube.depth) return false;
      for (Particle p2 : field.particles) {
        if (p1.x == p2.x && p1.y == p2.y && p1.z + 1 == p2.z) return false;
      }
    }

    for (Particle p : particles) {
      p.z++;
    }
    return true;
  }
  // move to the bottom, return true iff successful
  boolean moveDown(Field field) {
    for (Particle p1 : particles) {
      if (p1.y + 1 >= VisualCube.height) return false;
      for (Particle p2 : field.particles) {
        if (p1.x == p2.x && p1.y + 1 == p2.y && p1.z == p2.z) return false;
      }
    }

    for (Particle p : particles) {
      p.y++;
    }
    return true;
  }
  
  // draw particles
  void draw(VisualCube cube) {
    for (Particle p : particles) {
      p.draw(cube);
    }
  }
}

class Particle {
  int x;
  int y;
  int z;
  VisualCube.Color c;
  boolean kill;
  boolean dead;
  
  Particle(int x, int y, int z, VisualCube.Color c) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.c = c;
    kill = false;
    dead = false;
  }
  
  // render a list of equally colored neighbors of particle in field
  HashSet<Particle> getNeighbors(HashSet<Particle> particles) {
     HashSet<Particle> neighbors = new HashSet();
     this.getNeighbors2(neighbors, particles);
     return neighbors;
  }

  HashSet<Particle> getNeighbors2(HashSet<Particle> neighbors, HashSet<Particle> particles) {
    for (Particle p : particles) {
      if (p.c.r != c.r || p.c.g != c.g || p.c.b != c.b) continue;
      if (((p.x + 1 == x || p.x - 1 == x) && p.y == y && p.z == z) ||
        (p.x == x && (p.y + 1 == y || p.y - 1 == y) && p.z == z) ||
        (p.x == x && p.y == y && (p.z + 1 == z || p.z - 1 == z))) {
        if (!neighbors.contains(p)) {
          neighbors.add(p);
          HashSet<Particle> neighbors2 = p.getNeighbors2(neighbors, particles);
          for (Particle n : neighbors2) neighbors.add(n);
        }
      }
    }
    return neighbors;
  }
  
  // flash white and destroy on next update
  void kill() {
    kill = true;
  }
  
  // particle is dead?
  boolean isDead() {
    return dead;
  }
  
  // draw particles
  void draw(VisualCube cube) {
    if (kill) {
      cube.set(x, y, z, 
        VisualCube.colors - 1, 
        VisualCube.colors - 1, 
        VisualCube.colors - 1);
      kill = false;
      dead = true;
    } else {
      cube.set(x, y, z, c);
    }
  }
}

