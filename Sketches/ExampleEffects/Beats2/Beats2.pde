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

VisualCube.Color[] colors = {
  new VisualCube.Color(cube.colors - 1, 0, 0),
  new VisualCube.Color(0, cube.colors - 1, 0),
  new VisualCube.Color(0, 0, cube.colors - 1),
  new VisualCube.Color(cube.colors - 1, cube.colors - 1, 0),
  new VisualCube.Color(cube.colors - 1, 0, cube.colors - 1),
  new VisualCube.Color(0, cube.colors - 1, cube.colors - 1),
};

void setup() {
  size(800, 800, P3D);   // open 3D canvas
  cube.open("10.0.0.1"); // say hello to the cube
  cube.clear();          // clear the display
  cube.simulate();       // start the simulator

  song = minim.loadFile("Lumatico - Europa Model 1908.mp3", 2048);
  //song = minim.loadFile("Mihai Popoviciu - We Love.mp3", 2048);
  beat = new BeatDetect(/*song.bufferSize(), song.sampleRate()*/);
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
  cube.fill(0, 0, 0, 0.05); //0.01);  // fade out

  if (beat.isOnset()) /*isKick() isSnare() isHat()*/
    blob(random(1f), random(1f), random(1f), random(.25f, .75f),
      colors[int(random(colors.length))]);

  cube.update();  // update remote device
}

void stop() {
  song.close();  // free audio buffers 
  minim.stop();  // free audio processing buffers
  super.stop();  // close sketch
}

void destroy() {
  cube.clear();   // clear the display
  cube.update();  // update remote device
  cube.close();   // say goodbye cube
}

// draw blurry blob with additive blending:
// x,y,z defines position in cube [0, 1.0]
// d defines diameter [0, 1.0], .25 would be a sphere 25% of the cube's size
// c defines color to add
void blob(float x, float y, float z, float d, VisualCube.Color c) {
  if (d <= 0f) return;
  for (int i = 0; i < VisualCube.width; i++) {
    for (int j = 0; j < VisualCube.height; j++) {
      for (int k = 0; k < VisualCube.depth; k++) {
        float d0 = dist(
          i*1f/(VisualCube.width - 1),
          j*1f/(VisualCube.height - 1), 
          k*1f/(VisualCube.depth - 1), 
          x, y, z) / sqrt(3f);
        float f0 = constrain(1f - (1f / (d/2) * d0), 0f, 1f);
        VisualCube.Color c0 = cube.get(i, j, k);
        c0.r += int(f0 * c.r);
        c0.g += int(f0 * c.g);
        c0.b += int(f0 * c.b);
        cube.set(i, j, k, c0);
      }
    }
  }
}