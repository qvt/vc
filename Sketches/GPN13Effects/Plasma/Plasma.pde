import processing.visualcube1e3.*;

VisualCube cube = new VisualCube(this);

void setup() {
  size(800, 800, P3D);    // open 3D canvas
  frameRate(30);
  cube.open("10.0.0.1");  // say hello to the cube
  cube.clear();           // clear the display
  cube.simulate();        // start the simulator
}

float frame = 0;

float sin1(float x)
{
  return (sin(x * TWO_PI) + 1) / 2;
}

float cos1(float x)
{
  return (cos(x * TWO_PI) + 1) / 2;
}

float distFrom(float x, float y, float z, float cx, float cy, float cz)
{
  float dx = x - cx;
  float dy = y - cy;
  float dz = z - cz;
  
  return sqrt(dx*dx + dy*dy + dz*dz);
}

void draw() {
  int xx, yy, zz;
  for (xx = 0; xx < 10; xx++)
    for (yy = 0; yy < 10; yy++)
      for (zz = 0; zz < 10; zz++)
      {
        float x = float(xx) / 10;
        float y = float(yy) / 10;
        float z = float(zz) / 10;

        float value = 0;
        value += pow(sin1((x * 1) + (frame / 100) + (sin1(frame / 59) * 0.25) + (sin1(frame / 53) * 0.14)), 1.5);
        value += pow(sin1(y * 1.3 + frame / 73 + sin1(frame / 211)), 0.8);
        value += pow(sin1(2.5/((x+y+z)*sqrt(3) + 1) + frame / 101), 1);
        value += pow(sin1(2/((x+y+(1-z))*sqrt(3) + 1) + frame / 89), 1.3);
        value += pow(sin1(distFrom(x, y, z, 0.3, 0.5, 0.2) - frame / 113), 1.5);
        value += pow(sin1(distFrom(x, y, z, 0.7, 0.2, 0.4) - frame / 151), 0.7);
        value /= 6;

        int r = int(constrain(1 * pow((value-0.7) * 5, 0.3), 0, 1) * 255);
        int b = int(constrain(1 * pow(((1-value)-0.7) * 5, 0.3), 0, 1) * 255);

        cube.set(xx, yy, zz, r, 0, b);
      }
  cube.update(); // update remote device
  frame = frame + 1;
}

void destroy() {
  cube.clear(); // clear the display
  cube.update(); // update remote device
  cube.close(); // say goodbye cube
}