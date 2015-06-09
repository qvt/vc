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

/**/class Metaballs extends Effect {  //VisualCube cube = new VisualCube(this);

class Metaball
{
  float x, y, z, s;
  float r, g, b;
  
  Metaball(float x0, float y0, float z0, float s0, float r0, float g0, float b0)
  {
    x = x0;
    y = y0;
    z = z0;
    s = s0;
    r = r0;
    g = g0;
    b = b0;
  }
  
  void setPos(float x0, float y0, float z0)
  {
    x = x0;
    y = y0;
    z = z0;
  }
  
  void setStrength(float s0)
  {
    s = s0;
  }
  
  float r2(float x0, float y0, float z0)
  {
    return (sq(x0-x) + sq(y0-y) + sq(z0-z))
      / sq(s);    //optional: apply strength if blobs are of different sizes
  }
};

Metaball[] balls =
{
  new Metaball(3, 3, 3,  1,  1, 0, 0),
  new Metaball(7, 7, 7,  1,  0, 1, 0),
  new Metaball(5, 5, 5,  1,  0, 0, 1),
  null
};

void setup() {
  cube.open("192.168.2.173");  // say hello to the cube
  cube.clear();                // clear the display
  cube.simulate(600, 600);     // show simulator canvas
}

void draw() {
  cube.fill(0, 0, 0);
  
  // move metaballs
  float a = frameCount * 0.25f;
  
  balls[0].setPos(
    sin(a*0.7f)*3+3,
    cos(a*0.3f)*3+3,
    sin(a*0.2f)*cos(a*0.6)*2.5f+2.5f );
  balls[1].setPos(
    cos(a*0.4f)*3+7,
    cos(a*0.2f)*3+7,
    sin(a*0.9f)*cos(a*0.1)*2.5f+7.5f );
  balls[2].setPos(
    sin(a*0.1f)*4+5,
    sin(a*0.3f)*4+5,
    cos(a*0.7f)*sin(a*0.1)*4.5f+4.5f );

  // render frame  
  for(int x=0; x < 10; x++)
  for(int y=0; y < 10; y++)
  for(int z=0; z < 10; z++)
  {
    float r = 1;//0.3f;
    float g = 1;//0.3f;
    float b = 1;//0.3f;
    
    float q = 0f;
    for(int n=0; balls[n] != null; n++)
    {
      float r2 = balls[n].r2(x, y, z);
      
      q += 1 / r2;
      
      //r += cos(constrain(r2/2/PI, 0f, PI/2)) * balls[n].r;
      //g += cos(constrain(r2/2/PI, 0f, PI/2)) * balls[n].g;
      //b += cos(constrain(r2/2/PI, 0f, PI/2)) * balls[n].b;
    }
    
    if (q > 0.175f)
    {
      float h = //1.0f;                            //solid balls
        (constrain((q-0.175f)*30, 0, 1));          //smooth balls
        //cos(constrain((q-0.25f)*10, 0, PI/2));   //shape only
        
      cube.set(x, y, z, int(255*r*h), int(255*g*h), int(255*b*h));
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

