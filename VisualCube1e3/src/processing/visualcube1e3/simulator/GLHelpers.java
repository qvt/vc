package processing.visualcube1e3.simulator;

import com.jogamp.opengl.GL2;
import com.jogamp.opengl.glu.GLU;

import processing.core.PApplet;
import processing.opengl.PGraphicsOpenGL;
import processing.opengl.PJOGL;

import com.jogamp.opengl.util.gl2.GLUT;

/**
 * Collection of helpers for users of JOGL/OpenGL within Processing.
 * Update 2015-06-04 from Processing 1.0.5 and JOGL1 to Processing 3.0a9 and JOGL 2.3.1.
 * @see https://github.com/processing/processing/wiki/Advanced-OpenGL
 */
class GLHelpers {
	private PApplet s;
	private PGraphicsOpenGL pgl = null;
	private GLUT glut = null;
	private GLU glu = null;
	private GL2 gl = null;
	private double[] modelView2D;
	
	/**
	 * Initialize helper API.
	 * @param s Processing sketch
	 */
	GLHelpers(PApplet s) {
		this.s = s;
	}
	
	/**
	 * Start drawing
	 */
	public void begin() {
		pgl = (PGraphicsOpenGL) s.g;				// g may change
		glut = new GLUT();							// OpenGL utility toolkit (objects)
		glu = ((PJOGL)pgl.beginPGL()).glu;			// OpenGL utility functions (helpers)
		gl = ((PJOGL)pgl.beginPGL()).gl.getGL2();	// always use the GL object returned by beginGL
		modelView2D = getModelView();

		// configure OpenGL
		gl.glPushAttrib(GL2.GL_ALL_ATTRIB_BITS);
		gl.glDisable(GL2.GL_DEPTH_TEST);					// this fixes the overlap issue
	    gl.glEnable(GL2.GL_BLEND);						// turn on alpha blending
	    gl.glBlendFunc(GL2.GL_SRC_ALPHA,GL2.GL_ONE_MINUS_SRC_ALPHA);	// define the blend mode

//	    glu.gluPerspective(fovy, 1f*s.width/s.height, near, far);
//	    gl.glViewport(0, 0, s.width, s.height);
//		gl.glMatrixMode(GL.GL_PROJECTION);
//		gl.glLoadIdentity();
//		gl.glMatrixMode(GL.GL_MODELVIEW);
//	    gl.glPushMatrix();
	}
	
	/**
	 * End drawing
	 */
	public void end() {
	    // restore old OpenGL settings/matrices
	    gl.glPopAttrib();
		pgl.endPGL();
		pgl = null;
		glu = null;
		gl = null;
	}
	
	/**
	 * Show current matrices. 
	 */
	public void printView() {
		double[] modelView = new double[16], projection = new double[16];
		int[] viewPort = new int[4];

		gl.glGetDoublev(GL2.GL_MODELVIEW_MATRIX, modelView, 0);
		gl.glGetDoublev(GL2.GL_PROJECTION_MATRIX, projection, 0);
		gl.glGetIntegerv(GL2.GL_VIEWPORT, viewPort, 0);
		
		PApplet.println("modelView  =" + modelView[0] + " " + modelView[1] + " " + modelView[2] + " " + modelView[3]);
		PApplet.println("            " + modelView[4] + " " + modelView[5] + " " + modelView[6] + " " + modelView[7]);
		PApplet.println("            " + modelView[8] + " " + modelView[9] + " " + modelView[10] + " " + modelView[11]);
		PApplet.println("            " + modelView[12] + " " + modelView[13] + " " + modelView[14] + " " + modelView[15]);
		PApplet.println("projection =" + projection[0] + " " + projection[1] + " " + projection[2] + " " + projection[3]);
		PApplet.println("            " + projection[4] + " " + projection[5] + " " + projection[6] + " " + projection[7]);
		PApplet.println("            " + projection[8] + " " + projection[9] + " " + projection[10] + " " + projection[11]);
		PApplet.println("            " + projection[12] + " " + projection[13] + " " + projection[14] + " " + projection[15]);
		PApplet.println("viewPort   =" + viewPort[0] + " " + viewPort[1] + " " + viewPort[2] + " " + viewPort[3]);
	}	
	
	/**
	 * Calculate position of a 3D point projected by current matrices. 
	 * @param glu OpenGLU handle
	 * @param gl OpenGL handle
	 * @param v Vector point
	 * @return 3D coordinates as seen on screen
	 */
	public Vector3D getScreen(Vector3D v) {
		double[] modelView = new double[16], projection = new double[16], coordinate = { 0, 0, 0 };
		int[] viewPort = new int[4];

		gl.glGetDoublev(GL2.GL_MODELVIEW_MATRIX, modelView, 0);
		gl.glGetDoublev(GL2.GL_PROJECTION_MATRIX, projection, 0);
		gl.glGetIntegerv(GL2.GL_VIEWPORT, viewPort, 0);
		glu.gluProject(v.x, v.y, v.z, modelView, 0, projection, 0, viewPort, 0, coordinate, 0);
		return new Vector3D((float) coordinate[0], (float) viewPort[3] - (float) coordinate[1], (float) coordinate[2]);
	}
	
	/**
	 * Get current model view matrix
	 * @return Model view matrix
	 */
	public double[] getModelView() {
		double[] model = new double[16];
		
		gl.glGetDoublev(GL2.GL_MODELVIEW_MATRIX, model, 0);
		
		return model;
	}
	
	/**
	 * Get current model view matrix
	 * @param model Model view matrix (array of 16 doubles)
	 */
	public void setModelView(double[] model) {
		gl.glMatrixMode(GL2.GL_MODELVIEW);
		gl.glLoadMatrixd(model, 0);
	}

	/**
	 * Set RGB color used as text color on <code>write()</code>.
	 * @param r Red color from 0..255
	 * @param g Green color from 0..255
	 * @param b Blue color from 0..255
	 * @param a Alpha value ranging from 0..255
	 */
	public void setColor(int r, int g, int b, int a) {
		gl.glColor4f(r/255f, g/255f, b/255f, a/255f);
	}
	
	/**
	 * Draw a box with current color to current position
	 * @param s Side length
	 */
	public void drawBox(float s) {
		glut.glutSolidCube(s);
//		s /= 2;
//		float[] vertices = { 
//				+s,+s,-s, -s,+s,-s, -s,+s,+s, +s,+s,+s, 
//				+s,-s,+s, -s,-s,+s, -s,-s,-s, +s,-s,-s, 
//				+s,+s,+s, -s,+s,+s, -s,-s,+s, +s,-s,+s, 
//				+s,-s,-s, -s,-s,-s, -s,+s,-s, +s,+s,-s,
//				-s,+s,+s, -s,+s,-s, -s,-s,-s, -s,-s,+s,
//				+s,+s,-s, +s,+s,+s, +s,-s,+s, +s,-s,-s };
//		FloatBuffer buffer = (FloatBuffer) BufferUtil.newFloatBuffer(vertices.length).put(vertices).rewind();
//		gl.glEnableClientState(GL.GL_VERTEX_ARRAY);
//		gl.glVertexPointer(3, GL.GL_FLOAT, 0, buffer);
//		gl.glDrawArrays(GL.GL_QUADS, 0, vertices.length / 3);
	}
	
	/**
	 * Draw rectangle.
	 * @param v1 Upper left point
	 * @param v2 Lower right point
	 */
	public void drawRect2D(Vector2D v1, Vector2D v2) {
		pushMatrix();
		setModelView(modelView2D);
		
		gl.glBegin(GL2.GL_QUADS);
	    gl.glVertex2f(v1.x, v2.y);
	    gl.glVertex2f(v2.x, v2.y);
	    gl.glVertex2f(v2.x, v1.y);
	    gl.glVertex2f(v1.x, v1.y);
	    gl.glEnd();
	    
	    popMatrix();
	}

	/**
	 * Draw line.
	 * @param v1 Start point
	 * @param v2 End point
	 */
	public void drawLine2D(Vector2D v1, Vector2D v2) {
		pushMatrix();
		setModelView(modelView2D);
		
		gl.glBegin(GL2.GL_LINES);
	    gl.glVertex2f(v1.x, v1.y);
	    gl.glVertex2f(v2.x, v2.y);
	    gl.glEnd();
	    
	    popMatrix();
	}

	/**
	 * Draw line.
	 * @param v1 Start point
	 * @param v2 End point
	 */
	public void drawLine(Vector3D v1, Vector3D v2) {
		gl.glBegin(GL2.GL_LINES);
	    gl.glVertex3f(v1.x, v1.y, v1.z);
	    gl.glVertex3f(v2.x, v2.y, v2.z);
	    gl.glEnd();			
	}

	/**
	 * Set weight of a line in pixels.
	 * @param w Weight in pixels, default is 1.0f
	 */
	public void setWeight(float w) {
		gl.glLineWidth(w);
	}

	/**
	 * Draw box as a wire frame model.
	 * @param f Side length
	 */
	public void drawBoxWired(float f) {
		glut.glutWireCube(f);
	}
	
	/**
	 * Draw sphere.
	 * @param r Radius of sphere
	 * @param d Level of detail (number of vertices along x/y axis)
	 */
	public void drawSphere(float r, int d) {
		glut.glutSolidSphere(r, d, d);
//		GLUquadric sphere = glu.gluNewQuadric();
//	    glu.gluQuadricTexture(sphere, false);
//	    glu.gluQuadricDrawStyle(sphere, GLU.GLU_FILL);
//	    glu.gluQuadricNormals(sphere, GLU.GLU_SMOOTH);
//	    glu.gluSphere(sphere, r, d, d);
	}

	/**
	 * Save current view
	 */
	public void pushMatrix() {
		gl.glPushMatrix();
	}
	
	/**
	 * Restore old view
	 */
	public void popMatrix() {
		gl.glPopMatrix();
	}

	/**
	 * Move move.
	 * @param v Direction
	 */
	public void translate(Vector3D v) {
		gl.glTranslatef(v.x, v.y, v.z);
	}

	/**
	 * Rotate view.
	 * @param a Angle in degrees
	 * @param axis Axis through origin
	 */
	public void rotate(float a, Vector3D axis) {
		gl.glRotatef(a, axis.x, axis.y, axis.z);
	}
}