// metabawlz for teh cube
// 2013 GPN13 by hadez@shackspace.de
// github.com/hdznrrd

import processing.visualcube1e3.*;

class Ball
{
  private Trajectory _t = null;
  private float _x;
  private float _y;
  private float _z;
  private float _r;
  private float _g;
  private float _b;
  public Ball(float r, float g, float b, Trajectory t)
  {
    _r = r;
    _g = g;
    _b = b;
    _t = t;
    _t.setBall(this);
    
    moveTo(0,0,0);
  }
  
  public void moveTo(float x, float y, float z)
  {
    _x = x;
    _y = y;
    _z = z;
  }
  
  public float distanceTo(float x, float y, float z)
  {
    float dx = _x-x;
    float dy = _y-y;
    float dz = _z-z;
    float d = sqrt(dx*dx+dy*dy+dz*dz);
    //println("d="+d);
    return d;
  }

  public float getRed() { return _r; }
  public float getBlue() { return _g; }
  public float getGreen() { return _b; }
  
  public void step()
  {
    if(_t != null)
    {
      _t.step();
    }
  }
  
};

class Trajectory
{
  float _fx;
  float _fy;
  float _fz;
  float _fRad;
  float _minRad;
  float _scale;
  long _t = 0;
  Ball _ball = null;
  
  public Trajectory(float fx, float fy, float fz, float fRad, float minRad, float scale_)
  {
    _fx = fx;
    _fy = fy;
    _fz = fz;
    _fRad = fRad;
    _minRad = minRad;
    _scale = scale_;
  }
  
  public void setBall(Ball b)
  {
    _ball = b;
  }
  
  void step()
  {
    float rad = ( (1.0+_minRad+sin(((float)_t)/PI/_fRad))/(2.0+_minRad) ) * _scale;
    float nx = sin(((float)_t)/PI/_fx)*rad;
    float ny = cos(((float)_t)/PI/_fy)*rad;
    float nz = sin(((float)_t)/PI/_fz)*rad;
    
    if(_ball != null)
    {
      _ball.moveTo(nx,ny,nz);
    }
    
    ++_t;
  }
}

class Pixel
{
  private float _r;
  private float _g;
  private float _b;
  private float _a;
  public Pixel(float r, float g, float b, float a)
  {
    _r = r;
    _g = g;
    _b = b;
    _a = a;
  }
  
  public float getRed() { return _r; }
  public float getBlue() { return _g; }
  public float getGreen() { return _b; }
  public float getAlpha() { return _a; }
};

class World
{
  int MAX_SIZE = 10;
  float ballRadius = 0.8;
  
  ArrayList _bawlz;
  VisualCube _cube;
  
  public World(VisualCube cube)
  {
    _cube = cube;
    _bawlz = new ArrayList();
    _bawlz.add(new Ball(1,0,0, new Trajectory(3,5,7,31,0.2,0.6) ));
    _bawlz.add(new Ball(0,1,0, new Trajectory(7,7,3,37,0.2,0.5) ));
    _bawlz.add(new Ball(0,0,1, new Trajectory(3,7,5,41,0.2,0.5) ));
  }
  
  public void step()
  {
    _cube.clear();

    for(int i=0; i<_bawlz.size(); ++i)
    {
      ((Ball)_bawlz.get(i)).step();
    }
       
    for(int xx=0; xx<MAX_SIZE; ++xx) {
    for(int yy=0; yy<MAX_SIZE; ++yy) {
    for(int zz=0; zz<MAX_SIZE; ++zz)
    {
      Pixel p = getPotential(xx,yy,zz);
      if(p.getAlpha() > 0.6 /*&& p.getAlpha() < 1.0*/)
      {
        _cube.set(xx, yy, zz, (int)(p.getRed()*255), (int)(p.getGreen()*255), (int)(p.getBlue()*255), 1 );
      }
    }}}
    
    _cube.update();
  }

  private Pixel getPotential(int x, int y, int z)
  {
    float r=0;
    float g=0;
    float b=0;
    float a=0;
    
    for(int i=0; i<_bawlz.size(); ++i)
    {
      Ball ball = (Ball)_bawlz.get(i);
      
      // shift coordinate of ball so that 0,0,0 is at the center of the cube
      float d = ball.distanceTo(
              (((float)x+0.5)/MAX_SIZE)-(0.5),
              (((float)y+0.5)/MAX_SIZE)-(0.5),
              (((float)z+0.5)/MAX_SIZE)-(0.5)
              );
      
      // limit potential field to ballRadius
      //float p = ( (ballRadius-min(d,ballRadius))*(1/ballRadius) )*7;// / _bawlz.size();
      float p = pow(1-d,_bawlz.size());
      
      // weighted cummulative color for pixel
      r += ball.getRed() * p;
      g += ball.getGreen() * p;
      b += ball.getBlue() * p;
      a += p;
    }
    //println(r+","+g+","+b+","+a);
    return new Pixel(r,g,b,a);
  } 
};

VisualCube cube = new VisualCube(this);
World world = new World(cube);

void setup() {
  size(800, 800, P3D);    // open 3D canvas
  frameRate(30);
  cube.open("10.0.0.1");  // say hello to the cube
  cube.clear();           // clear the display
  cube.simulate();        // start the simulator
}
void draw() {
  world.step();
}
void destroy() {
  cube.clear(); // clear the display
  cube.update(); // update remote device
  cube.close(); // say goodbye cube
}