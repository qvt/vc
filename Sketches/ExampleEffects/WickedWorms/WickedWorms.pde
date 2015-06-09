/**
 * Wicked Worms. 
 * Processing example by Andreas Rentschler 2008-11-30.
 * 
 * This little sketch shows the basics in controlling a VisualCube device.
 * A swarm of worms are randomly moving around.
 * In iTunes, the worms seem to be reflecting the music's mood.
 * TODO: The louder the music, the bigger the worm's range. If quiet they stay in the center.
 *
 * For more informations, visit:
 * http://www.visualcube.org
 * 
 * @author	Andreas Rentschler
 * @date	2008-11-30
 * @version	1.0
 */

import processing.visualcube1e3.*;
import java.util.*;

VisualCube cube = new VisualCube(this);

Random rnd = new Random();
Worm[] worms = new Worm[10];
int frame = 0;

void setup() {
  size(800, 800, P3D);   // open 3D canvas
  cube.open("10.0.0.1"); // say hello to the cube
  cube.clear();          // clear the display
  cube.simulate();       // start the simulator

  for (int i = 0; i < worms.length; i++) {
    int r = rnd.nextInt(3);
    VisualCube.Color c = new VisualCube.Color(
      r == 0? VisualCube.colors - 1 : 0,
      r == 1? VisualCube.colors - 1 : 0,
      r == 2? VisualCube.colors - 1 : 0);
    r = rnd.nextInt(8);
    Point p = new Point(
      (r & 1) != 0? VisualCube.width - 1 : 0,
      (r & 2) != 0? VisualCube.height - 1 : 0,
      (r & 4) != 0? VisualCube.depth - 1 : 0);
    worms[i] = new Worm(rnd.nextInt(20) + 20, p, c, new VisualCube.Color(c.r / 2, c.g / 2, c.b / 2));
  }
}

void draw() {
  cube.clear();  // clear the display
  
  for (int i = 0; i < worms.length; i++) {
    if ((frame % 5) == 0) {
      Point dir = worms[i].getLastDirection();
    
      // change direction?
      if (rnd.nextInt(2) == 0) {
        boolean first = rnd.nextBoolean();
        int next = rnd.nextInt(3) - 1;
      
        if (dir.x != 0) dir = new Point(0, first? next : 0, first? 0 : next);
        else if (dir.y != 0) dir = new Point(first? next : 0, 0, first? 0 : next);
        else if (dir.z != 0) dir = new Point(first? next : 0, first? 0 : next, 0);
      }
    
      worms[i].move(dir); 
    }
    
    worms[i].draw();
  }
  
  frame++;
  cube.update();  // update remote device
}

void destroy() {
  cube.close();  // say goodbye cube
}

// Worm type
public class Worm {

  private Point[] segments = null;
  private Point lastDirection;
  private VisualCube.Color head;
  private VisualCube.Color tail;
  
  Worm(int size, Point start, VisualCube.Color head, VisualCube.Color tail) {
    segments = new Point[size];
    
    for (int i = 0; i < segments.length; i++) {
      segments[i] = new Point(start.x, start.y, start.z);
    }
    
    int r = rnd.nextInt(3);
    int d = rnd.nextBoolean()? +1 : -1;
    lastDirection = new Point(r == 0? d : 0, r == 1? d : 0, r == 2? d : 0);

    this.head = head;
    this.tail = tail;
  }
  
  public void move(Point direction) {
    if (direction.x == 0 && direction.y == 0 && direction.z == 0) return;
    for (int i = segments.length - 1; i > 0 ; i--) segments[i] = segments[i - 1];
    segments[0] = new Point(segments[1].x + direction.x, segments[1].y + direction.y, segments[1].z + direction.z);
    segments[0].x = segments[0].x < 0? 0 : segments[0].x >= VisualCube.width? VisualCube.width - 1 : segments[0].x;
    segments[0].y = segments[0].y < 0? 0 : segments[0].y >= VisualCube.height? VisualCube.height - 1 : segments[0].y;
    segments[0].z = segments[0].z < 0? 0 : segments[0].z >= VisualCube.depth? VisualCube.depth - 1 : segments[0].z;
    lastDirection = direction;
  }
  
  public Point getLastDirection() {
    return lastDirection;
  }
  
  public void draw() {
    for (int i = 0; i < segments.length; i++) {
      // use additive blending for lights
      VisualCube.Color old = cube.get(segments[i].x, segments[i].y, segments[i].z);
      VisualCube.Color now = (i == 0? head : tail);
      VisualCube.Color mix = new VisualCube.Color(old.r + now.r, old.g + now.g, old.b + now.b);
      if (mix.r >= VisualCube.colors) mix.r = VisualCube.colors - 1;
      if (mix.g >= VisualCube.colors) mix.g = VisualCube.colors - 1;
      if (mix.b >= VisualCube.colors) mix.b = VisualCube.colors - 1;
      cube.set(segments[i].x, segments[i].y, segments[i].z, mix);
//      println("(" + segments[i].x + "," + segments[i].y + "," + segments[i].z + ")");
    }
//    println();
  }
  
}

// Point in 3D space
class Point {

  public Point(int x, int y, int z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  public Point() {
    this(0, 0, 0);
  }

  public int x;
  public int y;
  public int z;

}