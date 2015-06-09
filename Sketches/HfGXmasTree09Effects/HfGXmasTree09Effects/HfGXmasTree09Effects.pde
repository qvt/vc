/**
 * Effects. 
 * View random VisualCube sketches. Useful for installations.
 *
 * What to do to add a sketch:
 * 1) Copy sketch into MetaViewer's folder.
 * 2) Remove this line:
 *    //VisualCube cube = new VisualCube(this);
 * 3) Wrap sketch into a class named after sketch:
 *    class NAMEOFSKETCH extends Effect {
 *      ...
 *    }
 * 4) Optionally, you may redefine method in wrapper class
 *    to overwrite default timeout:
 *      ...
 *      public int getTimeout() {
 *        return TIME_IN_MILLISECONDS;
 *      }
 *      ...
 * 5) Add sketch to array of effects, defined below:
 *    Effect effects[] = {
 *      ...
 *      new NAMEOFSKETCH(),
 *    };
 * 
 * For more informations, visit:
 * http://www.visualcube.org
 * 
 * @author	Andreas Rentschler
 * @date	2009-07-13
 * @version	1.0
 */
import processing.visualcube1e3.*;
import java.util.*;

VisualCube cube = new VisualCube(this);
Random rnd = new Random();

Effect effects[] = {
  new XmasTree(), 
  new Waeldchen(),
  new TreeHunt(),
  new StarOfBethlehem(),
};

// default timeout in range of 60..180s
final int MIN_TIMEOUT = 60;
final int MAX_TIMEOUT = 120;

// time when device should be off (hours from 0..23)
// sleep from 2am till 5pm
final int SLEEP_START = 2;
final int SLEEP_STOP = 17;

Effect oldEffect = null;
Effect newEffect = null;

float timer = 0;
float fader = 0;
int timeout = 0;

int oldMouseX, oldMouseY;
void mousePressed() { oldMouseX = mouseX; oldMouseY = mouseY; }
void mouseReleased() { if (abs(oldMouseX - mouseX) < 10 && abs(oldMouseY - mouseY) < 10) timer = 0; }

void setup() {
  size(800, 800, P3D);    // open 3D canvas
  cube.open("10.0.0.1");  // say hello to the cube
  cube.clear();           // clear the display
  cube.simulate();        // start the simulator
  frameRate(10);
  println("Ready to shuffle " + effects.length + " effects.");
}

void draw() {
  if (millis() - timer >= timeout) {
    timer = millis();
    fader = 1f;
      
    if (oldEffect != null) oldEffect.destroy();
    oldEffect = newEffect;

    if (hour() >= SLEEP_START && hour() < SLEEP_STOP) {
      newEffect = null;
      timeout = (((SLEEP_STOP - hour()) * 60 - minute()) * 60 - second()) * 1000;
      println("Sleeping for " + timeout/1000/60/60 + "h " + (timeout/1000/60) % 60 + "m " + (timeout/1000) % 60 + "s.");
    } else {
      newEffect = effects[int(random(effects.length - (oldEffect != null? 1 : 0)))];
      if (newEffect == oldEffect) newEffect = effects[effects.length - 1];  // if randomly picked previous effect
      timeout = newEffect.getTimeout();
      println("Running " + newEffect.toString().split("[\\$@\\[\\]]")[1] + " for " + timeout/1000 + "seconds.");
      newEffect.setup();
    }  
  }
  
  if (newEffect != null) {
    newEffect.draw(); 
    newEffect.frameCount++;
  }
  if (fader > 0.001f) {
    fader *= 0.95f;
    if (oldEffect != null) {
      oldEffect.draw();
      oldEffect.frameCount++;
      if (fader < 0.001f) oldEffect = null;
    }
  }
  
  for (int x = 0; x < VisualCube.width; x++) {
    for (int y = 0; y < VisualCube.height; y++) {
      for (int z = 0; z < VisualCube.depth; z++) {
        VisualCube.Color c1 = (newEffect != null? newEffect.cube.get(x, y, z) : new VisualCube.Color(0, 0, 0));
        VisualCube.Color c2 = (oldEffect != null? oldEffect.cube.get(x, y, z) : new VisualCube.Color(0, 0, 0));
        cube.set(x, y, z,
          (int)((c1.r * (1f - fader)) + (c2.r * fader)),
          (int)((c1.g * (1f - fader)) + (c2.g * fader)),
          (int)((c1.b * (1f - fader)) + (c2.b * fader)));
      }
    }
  }
  
  cube.update();
}

void destroy() {
  if (oldEffect != null) oldEffect.destroy();
  if (newEffect != null) newEffect.destroy();
  cube.close(); 
}

// Modified sketch class PApplet replacing a cube device with a fake cube,
// and providing access to it.
abstract class Effect extends PApplet {
  VisualCubeProxy cube = new VisualCubeProxy(this);

  public int getTimeout()
  {
    return ((int)random(MAX_TIMEOUT) + MIN_TIMEOUT + 1) * 1000;
  }
    
  public abstract void setup();
  public abstract void destroy();
  public abstract void draw();
}

// Proxy class faking a VisualCube device.
// Instead of implementing the whole interface AbstractVisualCube,
// override functions containing device functionality with dummy code.
class VisualCubeProxy extends VisualCube {
  Effect effect;
  
  VisualCubeProxy(Effect effect) {
    super(null);
    this.effect = effect;
  }
  
  public boolean open(String url) { 
    return true; 
  }
  public boolean close() { 
    return true; 
  }
  public void simulate(int width, int height) { 
  }
  public boolean update() {
    frame = voxels.clone();
    return true;
  }
}