import java.util.Random;

import processing.core.*;
import processing.visualcube1e3.*;

/**
 * Processing example program showing how to control the VisualCube.
 * 
 * @author	Andreas Rentschler
 * @date	2008-07-21, updated 2015-06-04
 * @version	1.0
 */
@SuppressWarnings("serial")
public class VisualCubeSketch1 extends PApplet {

	public static void main(String args[]) {
		PApplet.main(new String[] { "VisualCubeSketch1" }); //--present
	}
	// Processing says:
	//	When not using the PDE, size() can only be used inside settings().
	//	Remove the size() method from setup(), and add the following:
	//	public void settings() {
	//	  size(800, 800, P3D);
	//	}
    public void settings() {
		//size(800, 800, PConstants.P3D);
    }
    
    ////////////////////////////////////////////////////////////////////////

    VisualCube cube = new VisualCube(this);
    Random rnd = new Random();
    int number = 0;
    int target = 0;
    
    public void setup() {
        // open canvas to be used as local display
        cube.simulate(800, 800);
    	
    	// connect to remote device
    	cube.open("10.0.0.1"); //("192.168.2.173");
        
        // fill with green color of random intensity
        cube.fill(0, rnd.nextInt(VisualCube.colors), 0);
    }

    public void draw() {
    	// XRAY MIRROR BALL
    	// set random pixels to random colors
    	// let number of drawn pixels per call run to a random target value
    	// when target value is reached fill with random color and set new target value
  
//    	int c = ((frameCount/frameRate)%2)==0? VisualCube.colors : 0;
		/*if ((frameCount % (int)frameRate) == 0)*/ {
			cube.fill(frameCount%VisualCube.colors,frameCount%VisualCube.colors,frameCount%VisualCube.colors);
					//rnd.nextInt(VisualCube.colors), 
					//rnd.nextInt(VisualCube.colors), 
					//rnd.nextInt(VisualCube.colors));
		}

		for (int i = 0; i < VisualCube.width; i++) {
			cube.set(i, 0, 3, new VisualCube.Color(VisualCube.colors - 1, 0, 0));
		}
		
    	/*if (number == target) {
			target = rnd.nextInt(14);
			cube.fill(new VisualCube.Color(
					rnd.nextInt(VisualCube.colors), 
					rnd.nextInt(VisualCube.colors), 
					rnd.nextInt(VisualCube.colors)));
    	}
		else {
			number += (number < target ? 1 : -1);
		}
    	
    	for (int i = 0; i < number; i++) {
        	cube.set(
        			rnd.nextInt(VisualCube.width), 
        			rnd.nextInt(VisualCube.height), 
        			rnd.nextInt(VisualCube.depth), 
    				new VisualCube.Color(
    						rnd.nextInt(VisualCube.colors), 
    						rnd.nextInt(VisualCube.colors), 
    						rnd.nextInt(VisualCube.colors)));
    	}*/
    	
    	// update remote device
    	cube.update();
    }
    
    public void destroy() {
    	// say goodbye to the cube
    	cube.close();
    }
}
