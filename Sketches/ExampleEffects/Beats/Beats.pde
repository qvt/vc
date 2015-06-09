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

Minim minim = new Minim(this);
AudioPlayer song;
BeatDetect beat;
float extent = 0f;

void setup() {
  size(800, 800, P3D);   // open 3D canvas
  cube.open("10.0.0.1"); // say hello to the cube
  cube.clear();          // clear the display
  cube.simulate();       // start the simulator

  song = minim.loadFile("Mihai Popoviciu - We Love.mp3", 2048);
  beat = new BeatDetect();
  beat.setSensitivity(200);  
  song.addListener(
    new AudioListener() {
      void samples(float[] samps) {
        beat.detect(song.mix);
      }
      void samples(float[] sampsL, float[] sampsR) {
        beat.detect(song.mix);
      }    
    });
  song.play();
}

void draw() {
  extent = beat.isOnset()? 1f : (extent * 0.95);
  
  // draw centered sphere
  for (int i = 0; i < VisualCube.width; i++) {
    for (int j = 0; j < VisualCube.height; j++) {
      for (int k = 0; k < VisualCube.depth; k++) {
        float d = dist(
          2f * i/(VisualCube.width - 1) - 1f, 
          2f * j/(VisualCube.height - 1) - 1f, 
          2f * k/(VisualCube.depth - 1) - 1f, 
          0f, 0f, 0f);
        int c = int((1.0 - d) * extent * (VisualCube.colors - 1));
        cube.set(i, j, k, new VisualCube.Color(c, c, c));
      }
    }
  }

  cube.update();  // update remote device
}

void stop() {
  song.close();  // free audio buffers 
  minim.stop();  // free audio processing buffers
  super.stop();  // close sketch
}

void destroy() {
  cube.close();  // say goodbye cube
}