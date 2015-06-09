/* --------------------------------------------------------------------------
 * VisualCube Kinect Hand Track Demo, based on SimpleOpenNI NITE Hands
 * --------------------------------------------------------------------------
 * Processing Wrapper for the OpenNI/Kinect library
 * http://code.google.com/p/simple-openni
 * --------------------------------------------------------------------------
 * prog:  Michael Rentschler
 * date:  05/30/2013 (m/d/y)
 * ----------------------------------------------------------------------------
 * This example works with multiple hands, to enable mutliple hand change
 * the ini file in /usr/etc/primesense/XnVHandGenerator/Nite.ini:
 *  [HandTrackerManager]
 *  AllowMultipleHands=1
 *  TrackAdditionalHands=1
 * on Windows you can find the file at:
 *  C:\Program Files (x86)\Prime Sense\NITE\Hands\Data\Nite.ini
 *
 * This implementation only supports 1 hand at a time!!!
 * ----------------------------------------------------------------------------
 */

import SimpleOpenNI.*;


SimpleOpenNI context;

// focus gestures  / here i do have some problems on the mac, i only recognize raiseHand ? Maybe cpu performance ?
String focusGesture = "RaiseHand";  //"RaiseHand", "Wave", "Click"

PVector handTrackPos = null;
boolean handTrackFlag = false;


void setup()
{
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
  
  // enable the hands + gesture
  context.enableGesture();
  context.enableHands();
 
  context.addGesture(focusGesture);
  
  size(context.depthWidth(), context.depthHeight()); 
  smooth();
}

void draw()
{
  background(0, 0, 0);

  // update the cam
  context.update();
  
  // draw depthImageMap
  image(context.depthImage(), 0, 0);

  PVector pos = handTrackPos;
  if( pos != null )
  {
    PVector screenPos = new PVector();
    
    pushStyle();
    noFill();
      
    strokeWeight(16);
    stroke(color(255,255,0));
    context.convertRealWorldToProjective(pos, screenPos);
    point(screenPos.x,screenPos.y);
      
    popStyle();
  }
}

void keyPressed()
{
  switch(key)
  {
  case 'x':
    println("exit");
    exit();
    break;
  }
}


/////////////////////////////////////////////////////////////////////////////////////////////////////
// hand events
/////////////////////////////////////////////////////////////////////////////////////////////////////

void onCreateHands(int handId,PVector pos,float time)
{
  println("onCreateHands: handId=" + handId + ", pos=" + pos + ", time=" + time);
 
  handTrackPos = pos;
  handTrackFlag = true;
}

void onUpdateHands(int handId,PVector pos,float time)
{
  //println("onUpdateHands: handId=" + handId + ", pos=" + pos + ", time=" + time);
  
  handTrackPos = pos;
}

void onDestroyHands(int handId,float time)
{
  println("onDestroyHands: handId=" + handId + ", time=" + time);
  
  handTrackFlag = false;
  handTrackPos = null;
  context.addGesture(focusGesture);
}


/////////////////////////////////////////////////////////////////////////////////////////////////////
// gesture events
/////////////////////////////////////////////////////////////////////////////////////////////////////

void onRecognizeGesture(String strGesture, PVector idPosition, PVector endPosition)
{
  println("onRecognizeGesture: strGesture=" + strGesture + ", idPosition=" + idPosition + ", endPosition=" + endPosition);
  
  context.removeGesture(focusGesture);
  context.startTrackingHands(handTrackPos = endPosition);
}

/*void onProgressGesture(String strGesture, PVector position,float progress)
{
  println("onProgressGesture: strGesture=" + strGesture + ", position=" + position + ", progress=" + progress);
}*/

