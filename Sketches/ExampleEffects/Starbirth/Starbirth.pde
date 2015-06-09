//have fun!
//this code is public d
import processing.visualcube1e3.*;
import java.util.*;

VisualCube cube = new VisualCube(this);
Random rnd = new Random();
float radius = 6.0;
float diffinnerradius = 2.0;
final int PARTICLES = 30;
float particle_ang[][] = new float[PARTICLES][2];
float particle_vel[][] = new float[PARTICLES][2];
float particle_col[][] = new float[PARTICLES][3];
  int tick = 0;

void setupcolors() {
  int i;
  for (i = 0; i < PARTICLES; i++) {
    particle_col[i][0] = abs(rnd.nextInt() % 255);
    particle_col[i][1] = abs(rnd.nextInt() % 255);
    particle_col[i][2] = 255 - (particle_col[i][0]+particle_col[i][1])/2;
  }

}
void setup() {
  int i;
  
  size(800, 800, P3D);   // open 3D canvas
  cube.open("10.0.0.1"); // say hello to the cube
  cube.clear();          // clear the display
  cube.simulate();       // start the simulator

  for (i = 0; i < PARTICLES; i++) {
    particle_vel[i][0] = ((float) abs(rnd.nextInt() % 255)) / 9000.0;
    particle_vel[i][1] = ((float) abs(rnd.nextInt() % 255)) / 9000.0;
  }
  
  setupcolors();
}

void addparticle(int x, int y, int z, float weight, int i) { 
    /*cube.set(xf, yf, zf,
        ((int) (((float) cube.getRed(xf, yf, zf)) * (xtf * 0.5 + 0.5) + particle_col[i][0] * (xtc * 0.5))),
        ((int) (((float) cube.getGreen(xf, yf, zf)) * (ytf * 0.5 + 0.5) + particle_col[i][1] * (ytc * 0.5))),
        ((int) (((float) cube.getBlue(xf, yf, zf)) * (ztf * 0.5 + 0.5) + particle_col[i][2] * (ztc * 0.5)))
    );*/
    if (weight < 0.0) weight = 0.0;
    if (weight > 1.0) weight = 1.0;
    cube.set(x, y, z,
        ((int) (((float) cube.getRed(x, y, z)) + particle_col[i][0] * (weight * 0.7))),
        ((int) (((float) cube.getGreen(x, y, z)) + particle_col[i][1] * (weight * 0.7))),
        ((int) (((float) cube.getBlue(x, y, z)) + particle_col[i][2] * (weight * 0.7)))
    );
}

void boom() {
  int i, j, k;
  
  for (i = 0; i < 10; i++) {
    for (j = 0; j < 10; j++) {
      for (k = 0; k < 10; k++) {
        if (tick <= 255) cube.set(i, j, k, 255, 255 - (tick / 3), 255 - (tick));
        else cube.set(i, j, k, 0,0, 0);
      }}}
   cube.update();
   tick++;
   if (tick >= 350) { tick = 0; radius = 7.0; }

}

void draw() {
  int i, j, k;
  float distance;
  float grey;
  
  //radius -= pow(7.0 - radius + .1, 2.0) / 49.0;
  diffinnerradius = radius < 3.0 ? radius / 3.0 * 2.0 : 2.0;
  if (radius < 0.0) { /*boom();*/ radius = 7.0; return;}
  if (diffinnerradius < .01) diffinnerradius = .01;
  for (i = 0; i < 10; i++) {
    for (j = 0; j < 10; j++) {
      for (k = 0; k < 10; k++) {
        distance = sqrt(pow(((float) i) - 4.5, 2.0) + pow(((float) j) - 4.5, 2.0) + pow(((float) k) - 4.5, 2.0));
        if (distance > radius) grey = 0.0;
        else if (distance <= radius && distance > radius - diffinnerradius) grey = ((2.0 - (distance - radius + diffinnerradius)) / diffinnerradius * 255.0);
        else grey = 255.0;
        //dim grey according to volume [linear];
        grey *= ((7.0 - radius) / 7.0 * 2.0 / 3.0 + 0.33); //0.33 .. 1
        grey = 0.0;
        if (grey > 255.0) grey = 255.0;
        //if (i == 5 && j == 5 && k == 5) println(grey);
         { cube.set(i, j, k, (int) grey, (int) grey, (int) grey);  }
      }
    }
  }
  
  for (i = 0; i < PARTICLES; i++) {
    for (j = 0; j < 2; j++) {
      particle_ang[i][j] += particle_vel[i][j];
      if (particle_ang[i][j] > 2*3.1415927) particle_ang[i][j] -= 2*3.1415927;
      if (particle_ang[i][j] < 2*3.1415927) particle_ang[i][j] += 2*3.1415927;
      //particle_vel[i][j] += ((float) (abs(rnd.nextInt() % 256)-128)) / 128.0 * 0.01;
    }
    float x, y, z;
    float xtf, ytf, ztf;
    float xtc, ytc, ztc;
    int xf, yf, zf;
    
    x = sin(particle_ang[i][0]) * sin(particle_ang[i][1]) * (radius - diffinnerradius) + 4.5;
    y = cos(particle_ang[i][0]) * sin(particle_ang[i][1]) * (radius - diffinnerradius) + 4.5;
    z = cos(particle_ang[i][1]) * (radius - diffinnerradius) + 4.5;
    /*x = ((float) tick % 100) / 10.0;
    y=0;
    z = 0;*/
    tick++;

    xf = round(floor(x));
    yf = round(floor(y));
    zf = round(floor(z));
    xtf = 1.0-(((float) x) - xf);
    ytf = 1.0-(((float) y) - yf);
    ztf = 1.0-(((float) z) - zf);
    xtc = 1.0 - xtf;
    ytc = 1.0 - ytf;
    ztc = 1.0 - ztf;
    
    addparticle(xf, yf, zf, 1.0- sqrt(pow(xtc,2.0) + pow(ytc, 2.0) + pow(ztc, 2.0)), i);
    addparticle(xf+1, yf, zf,  1.0- sqrt(pow(xtf, 2.0) + pow(ytc, 2.0) + pow(ztc, 2.0)), i);
    addparticle(xf, yf+1, zf, 1.0-  sqrt(pow(xtc, 2.0) + pow(ytf, 2.0) + pow(ztc, 2.0)), i);
    addparticle(xf, yf, zf+1,  1.0- sqrt(pow(xtc, 2.0) + pow(ytc, 2.0) + pow(ztf, 2.0)), i);
    addparticle(xf+1, yf+1, zf,  1.0-  sqrt(pow(xtf, 2.0) + pow(ytf, 2.0) + pow(ztc, 2.0)), i);
    addparticle(xf, yf+1, zf+1,  1.0- sqrt(pow(xtc, 2.0) + pow(ytf, 2.0) + pow(ztf, 2.0)), i);
    addparticle(xf+1, yf, zf+1,  1.0- sqrt(pow(xtf, 2.0) + pow(ytc, 2.0) + pow(ztf, 2.0)), i);
    addparticle(xf+1, yf+1, zf+1,  1.0-  sqrt(pow(xtf, 2.0) + pow(ytf, 2.0) + pow(ztf, 2.0)), i);
  }
  cube.update();
}

void destroy() {
  cube.close(); 
}