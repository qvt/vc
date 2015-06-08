import java.util.Random;

import processing.core.*;
import processing.visualcube1e3.*;

/**
 * Aladdin's Magic Mood Lamp. 
 * Processing example by Andreas Rentschler 2008-07-22. 
 * 
 * This little sketch shows the basics in controlling a VisualCube device.
 * A point is constantly running along a spline curve in the 3D color space.
 * The displayed color transition is based on the current position in the 
 * 3D color space. When the target color is reached a new color is chosen 
 * to aim at.
 *
 * For more informations, visit:
 * http://www.visualcube.org
 * 
 * @author	Andreas Rentschler
 * @date	2008-07-21
 * @version	1.0
 */
@SuppressWarnings("serial")
public class VisualCubeSketch2 extends PApplet {

	public static void main(String args[]) {
		PApplet.main(new String[] { "VisualCubeSketch2" }); //--present
	}
	// Processing says:
	//	When not using the PDE, size() can only be used inside settings().
	//	Remove the size() method from setup(), and add the following:
	//	public void settings() {
	//	  size(800, 800, P3D);
	//	}
    public void settings() {
		size(800, 800, PConstants.OPENGL);
    }
    
    ////////////////////////////////////////////////////////////////////////

    VisualCube cube = new VisualCube(this);
	Random rnd = new Random();
	float x = rnd.nextFloat();
	float y = rnd.nextFloat(); 
	float z = rnd.nextFloat(); 
	float x2 = x, y2 = y, z2 = z;
	float vx = 0, vy = 0, vz = 0;
	float dist = 0;
	float r = 1, g = 1, b = 1;
	int rgbSelect = 0;  // set to a value >3 to switch off "1 CHANNEL CONSTANT" MODE

	public void setup() {
		cube.open("192.168.2.173");                    // say hello to the cube
		cube.clear();                   // clear the display
		cube.simulate(800, 800);  // open canvas as local display
	}

	public void draw() {		
//		print("\ndist: " + dist(x, y, z, x2, y2, z2));
		float dist2 = dist(x, y, z, x2, y2, z2);
		if(dist2 <= 0.0001f || dist <= dist2) {
			// new target needed
//			int n = rnd.nextInt(6);  // on one side of the color space for brighter colors
//			x2 = n == 0? 0 : n == 1? 1 : rnd.nextFloat(); 
//			y2 = n == 2? 0 : n == 3? 1 : rnd.nextFloat(); 
//			z2 = n == 4? 0 : n == 5? 1 : rnd.nextFloat();
			x2 = rnd.nextFloat(); 
			y2 = rnd.nextFloat(); 
			z2 = rnd.nextFloat();
//			print("\nnew target: " + x2 + " " + y2 + " " + z2);
			dist2 = dist(x, y, z, x2, y2, z2);
		}
		dist = dist2;

		vx = vx * 0.3f + (x2 - x) * 0.7f;
		vy = vy * 0.3f + (y2 - y) * 0.7f;
		vz = vz * 0.3f + (z2 - z) * 0.7f;
		
		x += vx * 0.1f;
		y += vy * 0.1f;
		z += vz * 0.1f;
//		print("\nposition: " + x + " " + y + " " + z);
		
		float xn = max(0, min(1, x));
		float yn = max(0, min(1, y));
		float zn = max(0, min(1, z));
		
		// "1 CHANNEL CONSTANT" MODE:
		// one color range is not mixed to prevent corner (0,0,0) from being always black
		// 0 = fade all 3 channels, 1 = don't fade red, 2 = don't fade green, 3 = don't fade blue
		r = rgbSelect == 1? r * 0.9f : r * 0.9f + 0.1f;
		g = rgbSelect == 2? g * 0.9f : g * 0.9f + 0.1f;
		b = rgbSelect == 3? b * 0.9f : b * 0.9f + 0.1f;
		if ((rgbSelect == 0 && r > 0.99999f && g > 0.99999f && b > 0.99999f) || (rgbSelect == 1 && r < 0.00001f) || (rgbSelect == 2 && g < 0.00001f) || (rgbSelect == 3 && b < 0.00001f)) 
			{ rgbSelect = rnd.nextInt(4); /*print("\nselect=" + rgbSelect);*/ }
//		print("\nr=" + r + " g=" + g + " b=" + b);

		// draw color transition
		for (int i = 0; i < VisualCube.width; i++) {
			for (int j = 0; j < VisualCube.height; j++) {
				for (int k = 0; k < VisualCube.depth; k++) {
					VisualCube.Color c = new VisualCube.Color(
							(int)(xn * (1f - r * i/VisualCube.width)  * (VisualCube.colors-1)), 
							(int)(yn * (1f - g * j/VisualCube.height) * (VisualCube.colors-1)), 
							(int)(zn * (1f - b * k/VisualCube.depth)  * (VisualCube.colors-1)));
					cube.set(i, j, k, c);
				}
			}
		}
//		// position in color space
//		int m = (frameCount%50) * (VisualCube.colors-1) / 50;
//		cube.set((int)(x*9), (int)(y*9), (int)(z*9), new VisualCube.Color(m, m, m));


		// update remote device
		cube.update();
	}

	public void destroy() {
		// say goodbye to the cube
		cube.close();
	}
}
