/**
 * Shadebob, controlled by kinect
 *
 * For more informations, visit:
 * http://www.visualcube.org
 * 
 * @author	Michael Rentschler
 * @date	2009-06-15
 * @version	1.0
 */

import processing.visualcube1e3.*;
import SimpleOpenNI.*;

SimpleOpenNI context;
VisualCube cube;

void setup() {
  size(800, 800, P3D);    // open 3D canvas

  // VisualCube setup
  cube = new VisualCube(this);
  cube.open("10.0.0.1");  // say hello to the cube
  cube.clear();           // clear the display
  cube.simulate();        // start the simulator

  context = new SimpleOpenNI(this);
  
  // mirror is by default enabled
  context.setMirror(false);
   
  // enable depthMap generation 
  if(context.enableDepth() == false)
  {
     println("Can't open the depthMap, maybe the camera is not connected!"); 
     exit();
     return;
  }
  
  // enable skeleton generation for all joints
  context.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
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
    cube.set(xx, yy, zz,
      min(cube.getRed(xx, yy, zz) + rr, 255),
      min(cube.getGreen(xx, yy, zz) + gg, 255),
      min(cube.getBlue(xx, yy, zz) + bb, 255));
  }
}

void draw() {
  context.update();
  
  cube.fill(0, 0, 0, 0.01);

  float a = 0.25f * (frameCount - 0.005f);      
  
  int[] userList = context.getUsers();
  if( 0 < userList.length )
  {
    for(int i=0; i<userList.length; i++)
    {
      int userId = userList[i];
      
      PVector posO = new PVector();
      context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_TORSO, posO);
      PVector posR = new PVector();
      context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, posR);
      PVector posL = new PVector();
      context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, posL);
  
      float distFact = 0.007f;
  
      int x = int((posL.x - posR.x)*distFact+4.5f);
      int y = int((posL.y - posR.y)*distFact+4.5f);
      int z = int((posL.z - posR.z)*distFact+4.5f);
  
      int b = int((sin(a*0.03))*64+64+64);
      int g = int((cos(a*0.03))*64+64+64);
      int r = 128+64-(b+g)/2;
  
      blob(x, y, z, 1, r, g, b);
      
      a += 100.0f;  //changes color of next user
    }
  }
  else
  {
      int x = int((sin(a*0.9)+cos(a*1.2))*2.5f+4.5f);
      int y = int((cos(a*0.6)+cos(a*1.1))*2.5f+4.5f);
      int z = int((sin(a*0.7f)+cos(a*0.3f))*2.5f+4.5f);
  
      int b = int((sin(a*0.03))*64+64);
      int g = int((cos(a*0.03))*64+64);
      int r = 128-(b+g)/2;      
  
      blob(x, y, z, 1, r, g, b);
  }
    
  
  cube.update();  // update remote device
}

void destroy() {
  cube.clear();   // clear the display
  cube.update();  // update remote device
  cube.close();   // say goodbye cube
}



// -----------------------------------------------------------------
// SimpleOpenNI events

void onNewUser(int userId)
{
  println("onNewUser: userId=" + userId);
  context.requestCalibrationSkeleton(userId,true);
  //no autodetect: context.startPoseDetection("Psi",userId);
}

void onLostUser(int userId)
{
  println("onLostUser: userId=" + userId);
}

void onExitUser(int userId)
{
  println("onExitUser: userId=" + userId);
}

void onReEnterUser(int userId)
{
  println("onReEnterUser: userId=" + userId);
}

void onStartCalibration(int userId)
{
  println("onStartCalibration: userId=" + userId);
}

void onEndCalibration(int userId, boolean successfull)
{
  println("onEndCalibration: userId=" + userId + ", successfull=" + successfull);
  
  if(successfull) 
  { 
    println("  User calibrated!");
    context.startTrackingSkeleton(userId); 
  } 
  else 
  { 
    println("  Failed to calibrate user, enter start pose (Psi) instead!");
    context.startPoseDetection("Psi",userId);
  }
}

void onStartPose(String pose,int userId)
{
  println("onStartPose: userId=" + userId + ", pose=" + pose);
  
  context.stopPoseDetection(userId); 
  context.requestCalibrationSkeleton(userId, true);
 
}

void onEndPose(String pose,int userId)
{
  println("onEndPose: userId=" + userId + ", pose=" + pose);
}