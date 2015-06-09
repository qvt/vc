/**
 * SoundTowers. 
 * Processing example by Andreas Rentschler 2008-07-22. 
 * 
 * This little sketch shows the basics in controlling a VisualCube device.
 * Use line-in signal input controlling the cube.
 * Uses the sonia library for audio playback and analysis.
 * Hint for Mac users: 
 * You should use the sonia library and SoundflowerBed if you want to
 * capture audio from 3rd party applications streaming to OSX's Core Audio.
 * For PC:  use the 'Sounds & Audio Devices' menu in the control panel to choose your input; Mic, wave, etc.
 * For Mac: the current microphone device will be used as input.
 *          use Soundflower (http://code.google.com/p/soundflower/) to send
 *          output of applications to line-in
 *
 * For more informations, visit:
 * http://www.visualcube.org
 * 
 * @author  Andreas Rentschler
 * @date    2009-06-15
 * @version 1.0
 */

import processing.visualcube1e3.*;
import pitaru.sonia_v2_9.*;

VisualCube cube = new VisualCube(this);

// used to remap lower frequency bands to cube's interior
int[] bands = {
  20, 21, 22, 23, 24,
  19,  6,  7,  8,  9,
  18,  5,  0,  1, 10,
  17,  4,  3,  2, 11,
  16, 15, 14, 13, 12,
};

void setup(){
  size(800, 800, P3D);   // open 3D canvas
  
  Sonia.start(this);           // Start Sonia engine.
  LiveInput.start(32);         // Start LiveInput and return 25 FFT frequency bands.
  
  cube.open("10.0.0.1"); // say hello to the cube
  cube.clear();          // clear the display
  cube.simulate();       // start the simulator
}

void draw(){
  cube.fill(0, 0, 0, 0.02);
  int l = (int)LiveInput.getLevel() * 128;
  if (l > 32) cube.fill(l, l, l);

  LiveInput.getSpectrum();
  for (int i = 0; i < 5; i++)
    for (int j = 0; j < 5; j++) {
      cube.cuboid(
        i*2, j*2, cube.width, i*2 + 1, 
        j*2 + 1, cube.width - (int)LiveInput.spectrum[bands[i*5 + j]]/20, 
        i*51, j*51, 255-i*j*255/16);
    }
    
  cube.update();
}

// Safely close the sound engine upon Browser shutdown.
void stop() {
  Sonia.stop();
  super.stop();
}

void destroy() {
  cube.clear();   // clear the display
  cube.update();  // update remote device
  cube.close();   // say goodbye cube
}