package processing.visualcube1e3.simulator;

import java.util.Collections;
import java.util.Vector;

import processing.core.PApplet;
import processing.core.PConstants;
import processing.opengl.PGraphics3D;
import processing.visualcube1e3.VisualCube;
import processing.visualcube1e3.AbstractVisualCube.Color;
import processing.visualcube1e3.device.VisualCubeConstants;
import processing.visualcube1e3.simulator.GLTextRenderer.ALIGN;

// TODO: Can't call any OpenGL function gl.* on destroy()/close()/... => NO FONT DEALLOCATION!!!
//TODO: draw axes?

/**
 * A virtual VisualCube rendered to a sketch's canvas.
 * Sketches are special applets in Processing derived from <code>processing.core.PApplet</code>.
 * Sketches written for VisualCubes are sending output to a VisualCube. Even if there's no VisualCube
 * connected, output is still rendered to the sketch's canvas.
 * 
 * @author	Andreas Rentschler
 * @date	2008-07-21
 * @version	1.0
 */
public class VisualCubeRenderer {

	// constants
	
	/** Screen width and height */
	private int screenSize;
	/** Distance from viewer */ 
	private float depth;
	/** Number of boxes per axis */
	private int numCubes;
	/** Size of space for a box */
	private float spaceSize;
	/** Space used by box */
	private float boxSize;
	/** Length of a marker's line */
	private float lineLength;

	// static variables
	
	/** List of voxels for sorting and drawing */
	private Vector<Voxel> voxels = new Vector<Voxel>();
	
	/** OpenGL 2d font */
	private GLTextRenderer bigFont = null;
	/** OpenGL 2d font */
	private GLTextRenderer mediumFont = null;
	/** OpenGL 2d font */
	private GLTextRenderer smallFont = null;
	
	/** Rotational position */
	private Quaternion r = new Quaternion(1.0f * PApplet.PI/2, new Vector3D(+0.1f, -1.0f, +0.0f)).normalize();

	/** Rotational velocity */
	private Quaternion v = new Quaternion(0.0025f * PApplet.PI/2, new Vector3D(-20.0f, +40.0f, +0.0f)).normalize();

	/** Current blending state */
	float cubeAlpha = 1.0f;

	/** Processing application */
	private PApplet s;
	
	/** VisualCube device */
	private VisualCube cube;
	
	/** OpenGL utility functions */
	private GLHelpers glh;
	
	/**
	 * Create a renderer for a sketch 	
	 * @param sketch		The Processing sketch
	 * @param cube			The VisualCube providing state
	 * @param width			Width of canvas
	 * @param height		Height of canvas
	 */
	public VisualCubeRenderer(PApplet sketch, VisualCube cube, int width, int height) {
		this.s = sketch;
		this.cube = cube;
		
		// create canvas when in Processing Development Environment
		// TODO: no longer works in latest Processing!
		// maybe this works: http://forum.processing.org/one/topic/switching-renderers-on-the-fly.html
		try {
			s.size(width, height, PConstants.P3D);
		} catch(IllegalStateException e) {
			// error message displayed iff in Eclipse and not in PDE
			System.out.println("Caught exception " + e);
		}

		glh = new GLHelpers(s);
		s.registerMethod("dispose", this);	// TODO: releasing libGL.dylib resources fails with bad memory access!

		// setup constants according to size of canvas and size of cube
		screenSize = PApplet.min(s.width, s.height);
		depth = screenSize * 11/10;			// viewer's distance is 110% of canvas' width
		numCubes = PApplet.min(
				VisualCubeConstants.WIDTH, 
				VisualCubeConstants.HEIGHT, 
				VisualCubeConstants.DEPTH);	// cube length in voxels
		spaceSize = screenSize / numCubes;  // space available for a voxel
		boxSize = spaceSize * 7/10;			// 70% of space is used by box
		lineLength = boxSize * 1/2;         // 50% of box size contains marker
		
		// create LEDs
		for (int i = 0; i < numCubes; i++)
			for (int j = 0; j < numCubes; j++)
				for (int k = 0; k < numCubes; k++)
					voxels.add(new Voxel(k, j, i));

		// load fonts
	    bigFont = new GLTextRenderer(s, "/data/HelveticaNeueUltraLight.ttf", 65);
		mediumFont = new GLTextRenderer(s, "/data/HelveticaNeueLight.ttf", 20);
		smallFont = new GLTextRenderer(s, "/data/HelveticaNeue.ttf", 14);

		// black canvas
		s.background(0);
		
		// hand cursor
		// TODO: latest Processing says: "Cursor types not supported in OpenGL, provide your cursor image"
		//s.cursor(PConstants.HAND);
	}
		
	/**
	 * Draw a frame, called by the applet. Not meant to be called directly.
	 * This class is converted from a sketch itself, it utilizes the Processing software renderer.
	 */
	public void draw() {
		// fade out old frames on canvas
	    s.fill(0, 100);		// use black with alpha
		s.rectMode(PConstants.CORNER);
		s.rect(0, 0, s.width, s.height);
		
		// spin cube according to mouse moves (trackball technique)
		if (s.mousePressed) {
			// create click vector m1 & track vector m2 to fictitious sphere surface
// BUGGY
//			Vector3D m1 = new Vector3D(1f * s.pmouseX/s.width - 0.5f, 1f * s.pmouseY/s.height - 0.5f, 0).constrain(-0.5f, +0.5f);
//			Vector3D m2 = new Vector3D(1f * s.mouseX/s.width - 0.5f, 1f * s.mouseY/s.height - 0.5f, 0).constrain(-0.5f, +0.5f);
//			m1 = new Vector3D(m1.x, m1.y, PApplet.sqrt(1f - (m1.x*m1.x + m1.y*m1.y))).constrain(0, 1);
//			m2 = new Vector3D(m2.x, m2.y, PApplet.sqrt(1f - (m2.x*m2.x + m2.y*m2.y))).constrain(0, 1);
// CORRECT
//			Vector3D m1 = new Vector3D(s.pmouseX - s.width/2, s.pmouseY - s.height/2, 0).divides(screenSize*3);
//			Vector3D m2 = new Vector3D(s.mouseX - s.width/2, s.mouseY - s.height/2, 0).divides(screenSize*3);
//			if ((m1.x*m1.x + m1.y*m1.y) > 1f) { m1 = m1.normalize(); m1 = new Vector3D(m1.x, m1.y, 0); } 
//			else m1 = new Vector3D(m1.x, m1.y, PApplet.sqrt(1f - (m1.x*m1.x + m1.y*m1.y)));
//			if ((m2.x*m2.x + m2.y*m2.y) > 1f) { m2 = m2.normalize(); m2 = new Vector3D(m2.x, m2.y, 0); } 
//			else m2 = new Vector3D(m2.x, m2.y, PApplet.sqrt(1f - (m2.x*m2.x + m2.y*m2.y)));	
// OPTIMIZED
			Vector3D m1 = new Vector3D(s.pmouseX - s.width/2, s.pmouseY - s.height/2, 0).divides(screenSize*3);
			Vector3D m2 = new Vector3D(s.mouseX - s.width/2, s.mouseY - s.height/2, 0).divides(screenSize*3);
			m1 = new Vector3D(m1.x, m1.y, PApplet.sqrt(1f - PApplet.min(1, (m1.x*m1.x + m1.y*m1.y))));
			m2 = new Vector3D(m2.x, m2.y, PApplet.sqrt(1f - PApplet.min(1, (m2.x*m2.x + m2.y*m2.y))));

			// create trackball: axis orthogonal to m1 and m2 through origin and angle between m1 and m2:
			//Quaternion t = new Quaternion(2 * PApplet.acos(m1.dot(m2)), m1.cross(m2)).normalize();
			Vector3D a = m1.cross(m2) /*<HACK>*//*.times(m1.dot(m2))*//*</HACK>*/;
			Quaternion t = new Quaternion(m1.dot(m2), a.x, a.y, a.z).normalize();

			// merge with existing velocity
			v = t.times(v).normalize();
		}

		// rotate by decreasing velocity
		r = v.times(r).normalize();
		v = new Quaternion(0.6f * v.getAngle(), v.getAxis().times(1.4f)).normalize();

		// center cube, rotate by axis and angle
		glh.begin();
		glh.translate(new Vector3D(s.width/2, s.height/2, -depth));
		Vector3D axis = r.getAxis();
		glh.rotate(r.getAngle() * 180/PApplet.PI, axis);

		// update alpha blending state
		cubeAlpha += (s.mousePressed && s.mouseButton != PConstants.RIGHT)? +0.01f : -0.01f;
		cubeAlpha = PApplet.constrain(cubeAlpha, 0.0f, 1.0f);

	    // draw cube box
		glh.setColor(255, 255, 255, (int)(cubeAlpha * 0.7f*255));	// white, 70% alpha
		glh.drawBox(screenSize + spaceSize/2);
		glh.setColor(128, 128, 128, (int)(cubeAlpha * 0.7f*255));	// gray, 70% alpha
		glh.setWeight(2.5f);
		glh.drawBoxWired(screenSize + spaceSize/2);
		
		// draw 3 axis
//	    s.strokeWeight(2);
//	    s.stroke(255, 0, 0);
//	    s.line(0, 0, 0, 1000, 0, 0);
//	    s.stroke(0, 255, 0);
//	    s.line(0, 0, 0, 0, 1000, 0);
//	    s.stroke(0, 0, 255);
//	    s.line(0, 0, 0, 0, 0, 1000);
			
		// draw shortest line to sketch name
		Vector2D v1 = new Vector2D(s.width/2, s.height - 70);
		Vector2D v2 = new Vector2D(0, 0);
		float[][] points = { 
				{0, 1, 1}, {0, -1, 1}, {0, 1, -1}, {0, -1, -1}, 
				{1, 1, 0}, {-1, 1, 0}, {1, -1, 0}, {-1, -1, 0}, 
				{1, 0, 1}, {-1, 0, 1}, {1, 0, -1}, {-1, 0, -1}
		};
		for (int i = 0; i < 12; i++) {
			Vector2D v = glh.getScreen(new Vector3D(
					points[i][0] * (screenSize/2 + spaceSize/4),
					points[i][1] * (screenSize/2 + spaceSize/4),
					points[i][2] * (screenSize/2 + spaceSize/4))).dropZ();
			if (i == 0 || v1.distance(v) < v1.distance(v2)) v2 = v;
		}
		glh.setColor(255, 255, 255, (int)(cubeAlpha * 0.7f*255));
		glh.setWeight(2f);
		glh.drawLine2D(v1, v2);
		
		// add coordinates
		for (int i=0; i < 8; i++) {
			float w = screenSize/2 + spaceSize*2/3;
			boolean x = (i & 1) != 0;
			boolean y = (i & 2) != 0;
			boolean z = (i & 4) != 0;

			smallFont.setColor(255, 255, 255, (int)(cubeAlpha * 128));
			smallFont.print(
					"[" + (x? numCubes - 1 : 0) + 
					"|" + (y? numCubes - 1 : 0) + 
					"|" + (z? numCubes - 1 : 0) + "]", 
					glh.getScreen(new Vector3D((x? +w : -w), (y? +w : -w), (z? +w : -w))).dropZ(),
					ALIGN.CENTER);
		}
		
		// draw LEDs
		for (Voxel v : voxels) v.updateZ();
		Collections.sort(voxels);
		for (Voxel v : voxels) v.draw();		

		// draw intro banner
	    glh.setColor(220, 220, 220, PApplet.max(155 - s.frameCount, 0));
		glh.drawRect2D(new Vector2D(0, s.height/2 - 50), new Vector2D(s.width, s.height/2 + 50));
	    
		// add intro/info text
		bigFont.setColor(255, 255, 255, PApplet.max(255 - s.frameCount, 0));
		smallFont.setColor(255, 255, 255, PApplet.max(255 - s.frameCount, 0));
		bigFont.print("visualcube1e3", new Vector2D(s.width/2, s.height/2 - 35), ALIGN.CENTER);
//		smallFont.print("©", new Vector2D(s.width/2 + 200, s.height/2 - 40), ALIGN.RIGHT);
		smallFont.setColor(255, 255, 255, PApplet.max(255 - s.frameCount/2, 0));
		smallFont.print("VisualCube, VisualCube1e3 © 2007-2009 Andreas Rentschler" + 
				", Michael Rentschler.", new Vector2D(15, s.height - 21), ALIGN.LEFT);

		smallFont.setColor(0, 0, 0, PApplet.max(255 - s.frameCount, 0));
		smallFont.print("Use mouse buttons to show markers & to spin cube.", 
				new Vector2D(s.width/2, s.height/2 + 17), ALIGN.CENTER);

		String[] path = s.sketchPath().split("[/\\\\]");  // splitting at path separators '/' or '\'
		mediumFont.setColor(255, 255, 255, (int)(cubeAlpha * 255));
		mediumFont.print(path[path.length - 1], new Vector2D(s.width/2, s.height - 70), ALIGN.CENTER);
		
		glh.end();
	}
	
	/**
	 * Free resources
	 */
	public void dispose() {
// causes javax.media.opengl.GLException: No OpenGL context current on this thread
//		bigFont.dispose();
//		mediumFont.dispose();
//		smallFont.dispose();
	}
	
	/**
	 * Represents a VisualCube's voxel for z-sorted rendering in Processing.
	 */
	class Voxel implements Comparable<Voxel> {
		private int i, j, k;
		private Vector3D v;
		private float viewingTransformedZ;

		/**
		 * Create voxel representing a specific position in cube.
		 * @param i Position along x axis
		 * @param j Position along y axis
		 * @param k Position along z axis
		 */
		Voxel(int i, int j, int k) {
			this.i = i;
			this.j = j;
			this.k = k;
			
			this.v = new Vector3D(
					i*spaceSize - screenSize/2 + spaceSize/2,
					j*spaceSize - screenSize/2 + spaceSize/2,
					k*spaceSize - screenSize/2 + spaceSize/2);
		}

		/**
		 * Draw voxel to canvas in P3D/OpenGL mode.
		 */
		public void draw() {
			glh.pushMatrix();

			// position LED
			glh.translate(v);

			// draw grid marker
			if (s.mousePressed && s.mouseButton != PConstants.RIGHT) {
				glh.setColor(255, 255, 255, 50);  // gray, 50% alpha
				glh.setWeight(2f);
				glh.drawLine(new Vector3D(-lineLength/2, 0, 0), new Vector3D(+lineLength/2, 0, 0));
				glh.drawLine(new Vector3D(0, -lineLength/2, 0), new Vector3D(0, +lineLength/2, 0));
				glh.drawLine(new Vector3D(0, 0, -lineLength/2), new Vector3D(0, 0, +lineLength/2));
			}

			// draw LED
			Color c = cube.getFromFrame(i, j, k);
			if (c == null) c = new Color(0, 0, 0);
			glh.setColor(c.r, c.g, c.b , 50);
			if (s.mousePressed && s.mouseButton != PConstants.LEFT)
				glh.drawSphere(boxSize/2, 7);
			else 
				glh.drawBox(boxSize);

			glh.popMatrix();
		}

		/**
		 * Update viewing-transformed Z position once for sorting.
		 * Speeds-up sorting since sorting requires this value several times.
		 */
		public void updateZ() {
			viewingTransformedZ = glh.getScreen(v).z;
		}

		/**
		 * Comparing 2 voxel position for Z sorting.
		 * <code>updateZ()</code> has to be called before for both voxels.
		 * @return 1/0/-1 iff voxel is behind/equal/before another voxel
		 */
		public int compareTo(Voxel o) {
			double z1 = this.viewingTransformedZ;
			double z2 = o.viewingTransformedZ;
			return z1 < z2 ? 1 : z1 == z2 ? 0 : -1;
		}

	}
	
}
