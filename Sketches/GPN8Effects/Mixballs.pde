/**
 * metaballs
 *
 * For more informations, visit:
 * http://www.visualcube.org
 * 
 * @author	Michael Rentschler
 * @date	2009-06-15
 * @version	1.0
 */

import processing.visualcube1e3.*;

/**/class Mixballs extends Effect {  //VisualCube cube = new VisualCube(this);

class Metaball
{
  int x, y, z, d;
  int r, g, b;
  
  Metaball(int x0, int y0, int z0, int d0, int r0, int g0, int b0)
  {
    x = x0;
    y = y0;
    z = z0;
    d = d0;
    r = r0;
    g = g0;
    b = b0;
  }
  
  void setPos(int x0, int y0, int z0)
  {
    x = x0;
    y = y0;
    z = z0;
  }
  
  void setDiameter(int d0)
  {
    d = d0;
  }
  
  float f(int x0, int y0, int z0)
  {
    return 1f / (sq(x0-x) + sq(y0-y) + sq(z0-z));
  }

  float d(int x0, int y0, int z0)
  {
    return sqrt(sq(x0-x) + sq(y0-y) + sq(z0-z)) / sqrt(3f/4f*d*d);
  }
};

Metaball[] balls =
{
  new Metaball(3, 3, 3,  4,  255, 0, 0),
  new Metaball(7, 7, 7,  4,  0, 255, 0),
  new Metaball(5, 5, 5,  4,  0, 0, 255),
  //new Metaball(7, 3, 7,  5,  255, 0, 175),
  null
};

void setup() {
  cube.open("192.168.2.173");  // say hello to the cube
  cube.clear();                // clear the display
  cube.simulate(600, 600);     // show simulator canvas
}

void draw() {
  cube.fill(0, 0, 0);
  
  float a = frameCount * 0.25f;
  
  balls[0].setPos(
    int(sin(a*0.7f)*3+3),
    int(cos(a*0.1f)*3+3),
    int(sin(a*0.2f)*cos(a*0.6)*3+3) );
  balls[1].setPos(
    int(cos(a*0.4f)*3+7),
    int(cos(a*0.2f)*3+7),
    int(sin(a*0.9f)*cos(a*0.1)*3+7) );
  balls[2].setPos(
    int(sin(a*0.1f)*4+5),
    int(sin(a*0.3f)*4+5),
    int(cos(a*0.7f)*sin(a*0.1)*4+5) );
  
  for(int x=0; x < 10; x++)
  for(int y=0; y < 10; y++)
  for(int z=0; z < 10; z++)
  {
    int r = 0;
    int g = 0;
    int b = 0;
    
    float s = 1f;
    for(int n=0; balls[n] != null; n++)
    {
      float d = balls[n].d(x, y, z);
      if(d < 1f)
      {
        r += int(cos(d * PI / 2f) * balls[n].r)*2;
        g += int(cos(d * PI / 2f) * balls[n].g)*2;
        b += int(cos(d * PI / 2f) * balls[n].b)*2;
      }
      s *= d; //s += balls[n].f(x, y, z);
    }
    
    if(s < 1f)
    {
      cube.set(x, y, z, r, g, b);
    }
  }
  
  cube.update();  // update remote device
}

void destroy() {
  cube.clear();   // clear the display
  cube.update();  // update remote device
  cube.close();   // say goodbye cube
}

/**/}
