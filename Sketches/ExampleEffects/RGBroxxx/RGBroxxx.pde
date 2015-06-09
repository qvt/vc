/**
 * @author Daniel "Nils" Koester <daniel.koester@student.kit.edu>
 */
import processing.visualcube1e3.*;
import java.util.*;

VisualCube cube = new VisualCube(this);
Manager man = new Manager(cube);

void setup() {
  size(800, 800, P3D);   // open 3D canvas
  cube.open("10.0.0.1"); // say hello to the cube
  cube.clear();          // clear the display
  cube.simulate();       // start the simulator
    
  man.addPoint(255, 50, 50, 3.0, 0.005);
  man.addPoint(50, 255, 50, 2.5, 0.006);
  man.addPoint(50, 50, 255, 2.0, 0.007);
  man.addPlane(50, 0, 0, 1, 0.004);
  man.addPlane(0, 50, 0, 2, 0.005);
  man.addPlane(0, 0, 50, 3, 0.006);
  man.addSprite(300, 4, 100);
  man.addSprite(200, 3, 75);
  man.addSprite(100, 2, 50);
}

void draw() {
  man.updatePositions();
}

void destroy() {
  man.destroy();
}

/**
 * @author Daniel "Nils" Koester <daniel.koester@student.kit.edu>
 */
class Manager {
  VisualCube cube;
  private Vector points;
  private Vector planes;
  private Vector sprites;
  
  public Manager(VisualCube c) {
    cube = c;
    points = new Vector();
    planes = new Vector();
    sprites = new Vector();
    
  }
  
  void addPoint(int r, int g, int b, float size, float speed) {
	points.addElement(new Point(r, g, b, size, speed));
  }
  
  void addPlane(int r, int g, int b, int dir, float speed) {
	planes.addElement(new Plane(r, g, b, dir, speed, points));
  }

  void addSprite(int max, int size, int fade) {
	sprites.addElement(new Sprite(max, size, fade));
  }
  
  void updatePositions() {
    cube.clear();

    for(int i=0; i<points.size(); i++) {
      Point p = (Point)points.get(i);
      p.updatePos();
    }
    
    for(int i=0; i<planes.size(); i++) {
      Plane p = (Plane)planes.get(i);
      p.updatePos();
    }
    
    for(int i=0; i<sprites.size(); i++) {
      Sprite s = (Sprite)sprites.get(i);
      s.trigger();
    }
    cube.update();
  }
  
  void destroy() {
    cube.close();
  }
}

/**
 * @author Daniel "Nils" Koester <daniel.koester@student.kit.edu>
 */
class Plane {
  public int r, g, b;
  private int xDir, yDir, zDir;
  private float px, py, pz;
  private float pos, prev, next;
  private float travel, stepsize;
  private Vector points;
  private Random rnd;
  
  // dir is the planes normal direction (1=>x, 2=>y, 3=>z)
  Plane(int rV, int gV, int bV, int dir, float speed, Vector p) {
    r = rV;
    g = gV;
    b = bV;
    xDir = 1==dir?1:0;
    yDir = 2==dir?1:0;
    zDir = 3==dir?1:0;
    stepsize = speed;
    travel = 0;
    rnd = new Random();
    prev = rnd.nextFloat()*10;
    next = rnd.nextFloat()*10;
    px = py = pz = prev;
    points = p;
  }
  
  void updatePos() {
    if (xDir == 1) pos = px;
    if (yDir == 1) pos = py;
    if (zDir == 1) pos = pz;
    float d = abs(pos - next);
    if ( d < 0.1 ) {
      prev = next;
      while(abs(prev-next)<2) next = rnd.nextFloat()*10;
      travel = 0;
    } else {
      travel = travel + stepsize;
      if (travel>1) travel = 1;
      pos = (1-travel)*prev+ travel*next;
      px = py = pz = pos;
      drawPos();
    }
  }
  
  void drawPos() {
    drawSlice(1.0);
  }
  
  void drawSlice(float fac) {
    float d = 0;
    Point p;
    int numPoints = points.size();
    VisualCube.Color c;
    for (int i = 0; i < 10; i++) {
      for (int j = 0; j < 10; j++) {
        for (int k = 0; k < numPoints; k++) {
          p = (Point)points.elementAt(k);
          if (xDir == 1) {
            py = i;
            pz = j;
            d = sqrt(pow(p.pos[1]-i, 2) + pow(p.pos[2]-j, 2));
          }
          if (yDir == 1) {
            px = i;
            pz = j;
            d = sqrt(pow(p.pos[0]-i, 2) + pow(p.pos[2]-j, 2));
          }
          if (zDir == 1) {
            px = i;
            py = j;
            d = sqrt(pow(p.pos[0]-i, 2) + pow(p.pos[1]-j, 2));
          }
          d = d<1?1:d;
          c = cube.get((int)px, (int)py, (int)pz);
          if ( c == null ) continue;
          cube.set((int)px, (int)py, (int)pz,
                   int(((r/numPoints+c.r+p.r/d))*fac),
                   int(((g/numPoints+c.g+p.g/d))*fac),
                   int(((b/numPoints+c.b+p.b/d))*fac));
         }
      }
    }
  }
}

/**
 * @author Daniel "Nils" Koester <daniel.koester@student.kit.edu>
 */
class Point {
  public int r, g, b;
  public float rad;
  public float[] pos, prev, next;
  private float travel, stepsize;
  private Random rnd;
  
  public Point(int rV, int gV, int bV, float radius, float speed) {
    r = rV;
    g = gV;
    b = bV;
    rad = radius;
    stepsize = speed;
    travel = 0;
    prev = new float[3];
    next = new float[3];
    pos = new float[3];
    rnd = new Random();
    prev[0] = rnd.nextFloat()*10;
    next[0] = rnd.nextFloat()*10;
    prev[1] = rnd.nextFloat()*10;
    next[1] = rnd.nextFloat()*10;
    prev[2] = rnd.nextFloat()*10;
    next[2] = rnd.nextFloat()*10;
  }
  
  void updatePos() {
    float d = dist(pos[0], pos[1], pos[2], next[0], next[1], next[2]);
    if ( d < 0.05 ) {
      prev[0] = next[0];
      prev[1] = next[1];
      prev[2] = next[2];
      next[0] = rnd.nextFloat()*10;
      next[1] = rnd.nextFloat()*10;
      next[2] = rnd.nextFloat()*10;
      travel = 0;
    } else {
      travel = travel + stepsize;
      if (travel>1) travel = 1;
      pos[0] = (1-travel)*prev[0]+travel*next[0];
      pos[1] = (1-travel)*prev[1]+travel*next[1];
      pos[2] = (1-travel)*prev[2]+travel*next[2];
      drawPos();
    }
  }
  
  void drawPos() {
    float d;
    VisualCube.Color c;
    for (float i = round(pos[0]-rad); i < round(pos[0]+rad); i++) {
      for (float j = round(pos[1]-rad); j < round(pos[1]+rad); j++) {
        for (float k = round(pos[2]-rad); k < round(pos[2]+rad); k++) {
          c = cube.get((int)i, (int)j, (int)k);
          if ( c == null ) continue;
          d = dist(i, j, k, pos[0], pos[1], pos[2]);
          d = 0.75*d*d;
          d = d<1?1:d;
          cube.set((int)i, (int)j, (int)k, int(c.r+r/d), int(c.g+g/d), int(c.b+b/d));
        }
      }
    }
  }
}

/**
 * @author Daniel "Nils" Koester <daniel.koester@student.kit.edu>
 */
class Sprite {
  private float r, g, b;
  private int rad;
  private int[] pos;
  int next, max;
  float fade, f;
  private Random rnd;
  
  public Sprite(int randomMaxFrameInterval, int size, int fade) {
    pos = new int[3];
    max = randomMaxFrameInterval;
    rad = size;
    next = frameCount;
    f = fade;
    rnd = new Random();
  }
  
  void trigger() {
    if (next <= frameCount) {
      next = int(frameCount+fade+rnd.nextFloat()*max);
      pos[0] = rnd.nextInt(10);
      pos[1] = rnd.nextInt(10);
      pos[2] = rnd.nextInt(10);
      while((r+g+b) < 255) {
        r = rnd.nextFloat()*255;
        g = rnd.nextFloat()*255;
        b = rnd.nextFloat()*255;
      }
      fade = f;
    }
    fade = fade - 1;
    if (fade > 0) drawPos(1);
  }
  
  void drawPos(float fac) {
    VisualCube.Color c;
    float d;
    float dmax = rad - f/fade;
    for (float i = round(pos[0]-dmax-1); i < round(pos[0]+dmax+1); i++) {
      for (float j = round(pos[1]-dmax-1); j < round(pos[1]+dmax+1); j++) {
        for (float k = round(pos[2]-dmax-1); k < round(pos[2]+dmax+1); k++) {
          c = cube.get((int)i, (int)j, (int)k);
          if ( c == null ) continue;
          d = dist(i, j, k, pos[0], pos[1], pos[2]);
          fac = 1.0 - (d - dmax);
          cube.set((int)i, (int)j, (int)k, c.r+int(r*fac), c.g+int(g*fac), c.b+int(b*fac));
        }
      }
    }
  }
}