/**
 * Beats. 
 * Processing example by Andreas Rentschler 2008-07-22. 
 * 
 * This little sketch shows the basics in controlling a VisualCube device.
 * Act to the beat of a playing mp3 track.
 * Uses the minim library for audio playback and analysis.
 * Hint for Mac users: 
 * You should use the sonia library and SoundflowerBed if you want to
 * capture audio from 3rd party applications streaming to OSX's Core Audio.
 *
 * For more informations, visit:
 * http://www.visualcube.org
 * 
 * @author  Andreas Rentschler
 * @date    2009-06-15
 * @version 1.0
 */

import processing.visualcube1e3.*;
import ddf.minim.*;
import ddf.minim.analysis.*;

VisualCube cube = new VisualCube(this);

void setup() {
  size(800, 800, P3D);   // open 3D canvas
  cube.open("10.0.0.1"); // say hello to the cube
  cube.clear();          // clear the display
  cube.simulate();       // start the simulator
}

void draw() {
  cube.line(0,0,0, 9,0,0, 255,0,0);
  cube.line(0,0,0, 0,9,0, 0,255,0);
  cube.line(0,0,0, 0,0,9, 0,0,255);
  cube.update();  // update remote device
}

void destroy() {
  cube.clear();   // clear the display
  cube.update();  // update remote device
  cube.close();   // say goodbye cube
}