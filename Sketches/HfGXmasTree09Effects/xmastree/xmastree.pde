/**
 * XmasTree
 *
 * For more informations, visit:
 * http://www.visualcube.org/1e3
 *
 * @author Michael Rentschler
 * @date 2009-12-04
 * @version 1.0
 */

/*
  0123456789
-     XX
-    XXXX
-   XXXXXX
-  XXXXXXXX
-    XXXX
-   XXXXXX
-  XXXXXXXX
- XXXXXXXXXX
-     BB
-     BB

-     XX
-    XXXX
-   XXXXXX
-  XXXXXXXX
- XXXXXXXXXX
- XXXXXXXXXX
-  XXXXXXXX
-   XXXXXX
-    XXXX
-     XX

-     XX
-    X  X
-  XX    XX
- X        X
-  XX    XX 
-   X    X  
-  X      X
- X   XX   X
- X  X   X X
-  X      X
*/

import processing.visualcube1e3.*;

VisualCube cube = new VisualCube(this);

void setup() {
  size(800, 800, P3D);    // open 3D canvas
  cube.open("10.0.0.1");  // say hello to the cube
  cube.clear();           // clear the display
  cube.simulate();        // start the simulator
  frameRate(10);
}

void circle(int y, float rad, int r, int g, int b)
{
  for(float x=-4.5; x<=4.5f; x+=1.0f)
  for(float z=-4.5; z<=4.5f; z+=1.0f)
  {
    float d = sqrt((x*x)+(z*z)) ;
    float rndrad = rad + random(0.3f)-0.15f;
    float f = (d <= rndrad)? cos(PI/2f*sq(d)/sq(rndrad)) : 0.0f;

    int rr = constrain(int(f*r), 0, 255);
    int gg = constrain(int(f*g), 0, 255);
    int bb = constrain(int(f*b), 0, 255);
    cube.set((int)(x+4.5f), y, (int)(z+4.5f), rr, gg, bb);
  }
}

void scanline(int y)
{
  int a = 255;
  if(y < 10) {
    for(int x=0; x<10; x++)
    for(int z=0; z<10; z++)
    {
      for(int yy=y+1; yy<10; yy++)
        cube.set(x, yy, z, 0, 0, 0);  //clear anything below current scanline

      if(cube.getRed(x,y,z) != 0 || cube.getGreen(x,y,z) != 0 || cube.getBlue(x,y,z) != 0) {
        //cube.set(x, y, z, constrain(cube.getRed(x,y,z)^a, 0, 255), constrain(cube.getGreen(x,y,z)^a, 0, 255), constrain(cube.getBlue(x,y,z)^a, 0, 255));
        //if(cube.getRed(x-1,y,z) == 0 && cube.getGreen(x-1,y,z) == 0 && cube.getBlue(x-1,y,z) == 0)
        //  cube.set(x, y, z, 255, 255, 255);
        //if(cube.getRed(x+1,y,z) == 0 && cube.getGreen(x+1,y,z) == 0 && cube.getBlue(x+1,y,z) == 0)
          cube.set(x, y, z, 255, 255, 255);
      }      
    }
  }
}


float[] tree_rad = {1, 2, 3, 4, 2, 3, 4, 5, 1.75f, 1.75f};
int[] tree_r = {0, 0, 0, 0, 0, 0, 0, 0, 0xcc, 0xcc};
int[] tree_g = {255, 255, 255, 255, 255, 255, 255, 255, 0x77, 0x77};
int[] tree_b = {0, 0, 0, 0, 0, 0, 0, 0, 0x22, 0x22};
int scanline_y = 10;


void draw() {
  cube.fill(0, 0, 0, 1.0);

  for(int y=0; y < 10; y++)
  {
    circle(y, tree_rad[y] /*+random(0.5f)-0.25f*/, tree_r[y], tree_g[y], tree_b[y]);
  }

  //scanline( (frameCount / 1) % 77 );
  //if((frameCount % 3) == 0) cube.fill(0, 0, 0, random(1.0f));
  
  if(scanline_y < -8 || scanline_y > -5) scanline(scanline_y);
    else if(random(1) > 0.8f) scanline_y = -10;
  if(scanline_y < 10) scanline_y++;
    else if((frameCount % 30) == 0 && random(1) > 0.75f) scanline_y = -9;
  
  cube.update();  // update remote device
}

void destroy() {
  cube.clear();   // clear the display
  cube.update();  // update remote device
  cube.close();   // say goodbye cube
}