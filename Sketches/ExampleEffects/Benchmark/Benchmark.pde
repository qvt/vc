/**
 * Benchmark. 
 * Processing example by Andreas Rentschler 2009-06-23.
 * 
 * This little sketch measures maximum possible FPS of a VisualCube device.
 *
 * For more informations, visit:
 * http://www.visualcube.org
 * 
 * @author  Andreas Rentschler
 * @date    2009-06-23
 * @version 1.0
 */

import processing.visualcube1e3.*;

int framesDone = 0;
int framesSkipped = 0;
long time = millis();

VisualCube cube = new VisualCube(this);
cube.open("10.0.0.1"); // say hello to the cube
cube.clear();          // clear the display

for (int i = 0; i < 100000; i++) {
  if (cube.update()) framesDone++; else framesSkipped++;
  print("");
}

long current = millis() - time;
println(framesDone + " frames in " + current/1000 + " seconds (skipped " + framesSkipped + ") -> " + framesDone * 1000f / current + " FPS");

cube.close();  // say goodbye cube
exit();