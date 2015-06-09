/**
 * Shadebob
 *
 * For more informations, visit:
 * http://www.visualcube.org/1e3
 * 
 * @author  Michael Rentschler
 * @date    2009-06-26
 * @version 1.0
 */

import processing.visualcube1e3.*;

VisualCube cube = new VisualCube(this);

void setup() {
  size(800, 800, P3D);   // open 3D canvas
  cube.open("10.0.0.1"); // say hello to the cube
  cube.clear();          // clear the display
  cube.simulate();       // start the simulator
}

void blob(int x, int y, int z, int rad, int r, int g, int b)
{
  for(int i=-rad; i<=rad; i++)
  for(int j=-rad; j<=rad; j++)
  for(int k=-rad; k<=rad; k++)
  {
    int xx = x + i;
    int yy = y + j;
    int zz = z + k;
    
    float d = sqrt((i*i)+(j*j)+(k*k)) / sqrt(3*rad*rad);
    float f = cos(PI/2f*d*d);

    int rr = constrain(cube.getRed(xx, yy, zz) + int(f*r), 0, 255);
    int gg = constrain(cube.getGreen(xx, yy, zz) + int(f*g), 0, 255);
    int bb = constrain(cube.getBlue(xx, yy, zz) + int(f*b), 0, 255);
    cube.set(xx, yy, zz, rr, gg, bb);
  }
}

void draw() {
  cube.fill(0, 0, 0, 0.333);
  
  float speed = 0.25f;// - abs(cos(frameCount*0.027f)*0.1f) + 0.05f; //0.25f
  
  for(int n=0; n < 100; n++)
  {
    float a = speed * (frameCount - 0.005f*n*n);
    
    int x = int((sin(a*0.9))*4f+4.5f);
    int y = int((cos(a*0.6))*4f+4.5f);
    int z = int((sin(a*0.7f)+cos(a*0.3f))*2f+4.5f);
    int b = int((sin(a*0.3))*16+16);
    int g = int((cos(a*0.3))*16+16);
    int r = 16-(b+g)/2;
    
    blob(x, y, z, 1,
      r - int(sqrt(n)),
      g - int(sqrt(n)),
      b - int(sqrt(n)));
  }
  
  cube.update();  // update remote device
}

void destroy() {
  cube.clear();   // clear the display
  cube.update();  // update remote device
  cube.close();   // say goodbye cube
}