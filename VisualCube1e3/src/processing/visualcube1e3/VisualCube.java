package processing.visualcube1e3;

import processing.core.PApplet;
import processing.visualcube1e3.device.VisualCubeCommunication;
import processing.visualcube1e3.device.VisualCubeConstants;
import processing.visualcube1e3.device.VisualCubeException;
import processing.visualcube1e3.device.VisualCubeConstants.Voxel;
import processing.visualcube1e3.simulator.VisualCubeRenderer;

/**
 * Communication interface for the VisualCube.
 * To be used from Processing or real java alike.
 * 
 * @author	Andreas Rentschler
 * @date	2008-07-21
 * @version	1.0
 */
public class VisualCube implements AbstractVisualCube {

	/** Number of voxels along X axis */
	public final static int width = VisualCubeConstants.WIDTH;
	
	/** Number of voxels along Y axis */
	public final static int height = VisualCubeConstants.HEIGHT;
	
	/** Number of voxels along Z axis */
	public final static int depth = VisualCubeConstants.DEPTH;
	
	/** Number of colors per R/G/B value */
	public final static int colors = VisualCubeConstants.COLORS;
	
	/** Number of frames per second */
	public final static int frameRate = VisualCubeConstants.FRAMERATE;

	/** Voxel matrix */
	public Voxel[] voxels;
	
	/** Voxel matrix, last updated */
	public Voxel[] frame = null;

	/** Number of frames of device */
	private float frameCount = 0;

	/**
	 * Connection to remote device
	 */
	private VisualCubeCommunication communication = null;

	/**
	 * Applet controlling cube
	 */
	private PApplet sketch;
	
	/**
	 * Initialize cube with parameter stating the calling applet possibly like this:
	 * <code>cube = new VisualCube(this);</code>
	 * @param sketch	Calling sketch with a canvas to draw onto
	 */
	public VisualCube(PApplet sketch) {
		this.sketch = sketch;
		
		voxels = new VisualCubeConstants.Voxel[VisualCubeConstants.WIDTH * VisualCubeConstants.DEPTH * VisualCubeConstants.HEIGHT];
		for (int i = 0; i < voxels.length; i++) {
			voxels[i] = new VisualCubeConstants.Voxel();
		}
	}	

	/* (non-Javadoc)
	 * @see processing.visualcube.AbstractVisualCube#open()
	 */
	public boolean open() {
		return open(null);
	}
	
	/**
	 * Open VisualCube device specified by URL
	 * @param url		URL identifying cube on network, e.g. "192.168.0.123". If it
	 * 					is null, environment variable "visualcube1e3.url" or java
	 * 					property "visualcube1e3.url" is taken. If those are null too,
	 * 					/etc/hosts is asked for a name->IP mapping of "visualcube1e3"
	 * 					(compare to "localhost").
	 */
	public boolean open(String url) {
		if (communication != null) {
//			System.out.println("Already connected.");
			return true;
		}
		
		System.out.println("Opening cube...");

		// setup communication
		String info;
		try {
			communication = new VisualCubeCommunication(url);
			info = communication.getDeviceInfo();
		} catch (VisualCubeException e) {
			System.out.println("Opening cube failed: " + e);
			communication = null;
			return false;
		}
		
		System.out.println("Opening cube succeeded:\n" + info);
		return true;
	}
	
	/* (non-Javadoc)
	 * @see processing.visualcube.AbstractVisualCube#close()
	 */
	public boolean close() {
		if (communication == null) {
//			System.out.println("No cube opened.");
			return true;
		}

		System.out.println("Closing cube...");

		communication = null;
				
		System.out.println("Closing cube succeeded.");
		return true;
	}

	/**
	 * Initialize a sketch's drawing canvas during start-up like this
	 * <code>init() { simulate(640, 480); }</code>
	 * @param width		Width of canvas
	 * @param height	Height of canvas
	 */
	public void simulate(int width, int height) {
		System.out.println("Setting the size this way no longer works, you must place 'size(" + width + ", " + height + ", P3D);' as the first line in your setup() method. An OpenGL exception will occur.");
		
		sketch.registerMethod("draw", new VisualCubeRenderer(sketch, this, width, height));
	}
	public void simulate() {
		sketch.registerMethod("draw", new VisualCubeRenderer(sketch, this, 800, 800));
	}
	
	/* (non-Javadoc)
	 * @see processing.visualcube.AbstractVisualCube#update()
	 */
	public boolean update() {
		// only update display according to its frame rate
		int oldFrameCount = (int) frameCount;
		frameCount += (float) frameRate / sketch.frameRate;
		if (oldFrameCount == (int) frameCount) {
			return true;
		}
		else {
			frame = voxels.clone();
		}

		// update remote device
		if (communication == null)
			return false;
		
		try {
			communication.updateDisplay(/*frameRate*/0, frame);
		} catch (VisualCubeException e) {
			//System.out.println("Device update failed: " + e);
			return false;
		}

		return true;
	}
	
	/* (non-Javadoc)
	 * @see processing.visualcube.AbstractVisualCube#clear()
	 */
	public void clear() {
		for(VisualCubeConstants.Voxel p : voxels) p.blue = p.green = p.red = 0;
	}
	
	/* (non-Javadoc)
	 * @see processing.visualcube.AbstractVisualCube#fill(processing.visualcube.VisualCube.Color)
	 */
	public void fill(Color c) {
		for (VisualCubeConstants.Voxel p : voxels) {
			p.red = (int) (((1.0 - c.a) * p.red) + (c.a * c.r));
			p.green = (int) (((1.0 - c.a) * p.green) + (c.a * c.g));
			p.blue = (int) (((1.0 - c.a) * p.blue) + (c.a * c.b));
		}
	}
	
	/* (non-Javadoc)
	 * @see processing.visualcube.AbstractVisualCube#fill(int, int, int)
	 */
	public void fill(int r, int g, int b) {
		fill(new Color(r, g, b));
	}

	/* (non-Javadoc)
	 * @see processing.visualcube.AbstractVisualCube#fill(int, int, int, float)
	 */
	public void fill(int r, int g, int b, float a) {
		fill(new Color(r, g, b, a));
	}
	
	/* (non-Javadoc)
	 * @see processing.visualcube.AbstractVisualCube#set(int, int, int, processing.visualcube.VisualCube.Color)
	 */
	public boolean set(int x, int y, int z, Color c) {
		if (x < 0 || x >= VisualCubeConstants.WIDTH || y < 0 || y >= VisualCubeConstants.HEIGHT || z < 0 || z >= VisualCubeConstants.DEPTH) return false;
		if (c.a <= 0f) return false; else if (c.a > 1.0) c.a = 1f;
		if (c.r < 0) c.r = 0; else if (c.r >= VisualCubeConstants.COLORS) c.r = VisualCubeConstants.COLORS - 1;
		if (c.g < 0) c.g = 0; else if (c.g >= VisualCubeConstants.COLORS) c.g = VisualCubeConstants.COLORS - 1;
		if (c.b < 0) c.b = 0; else if (c.b >= VisualCubeConstants.COLORS) c.b = VisualCubeConstants.COLORS - 1;
		
		VisualCubeConstants.Voxel voxel = voxels[z * VisualCubeConstants.WIDTH * VisualCubeConstants.HEIGHT + y * VisualCubeConstants.WIDTH + x];
		
		if (c.a == 1.0f) {
			voxel.red = c.r;
			voxel.green = c.g;
			voxel.blue = c.b;
			return true;
		}
		
		Color c0 = get(x, y, z);
		voxel.red = (int) (((1f - c.a) * c0.r) + (c.a * c.r));
		voxel.green = (int) (((1f - c.a) * c0.g) + (c.a * c.g));
		voxel.blue = (int) (((1f - c.a) * c0.b) + (c.a * c.b));
		
		return true;
	}
	
	/* (non-Javadoc)
	 * @see processing.visualcube.AbstractVisualCube#set(int, int, int, int, int, int)
	 */
	public boolean set(int x, int y, int z, int r, int g, int b) {
		return set(x, y, z, new Color(r, g, b));
	}
	
	/* (non-Javadoc)
	 * @see processing.visualcube.AbstractVisualCube#set(int, int, int, int, int, int, float)
	 */
	public boolean set(int x, int y, int z, int r, int g, int b, float a) {
		return set(x, y, z, new Color(r, g, b, a));
	}
	
	/* (non-Javadoc)
	 * @see processing.visualcube.AbstractVisualCube#get(int, int, int)
	 */
	public Color get(int x, int y, int z) {
		if (x < 0 || x >= VisualCubeConstants.WIDTH || y < 0 || y >= VisualCubeConstants.HEIGHT || z < 0 || z >= VisualCubeConstants.DEPTH) return null;
		VisualCubeConstants.Voxel voxel = voxels[z * VisualCubeConstants.WIDTH * VisualCubeConstants.HEIGHT + y * VisualCubeConstants.WIDTH + x];
		return new Color(voxel.red, voxel.green, voxel.blue);		
	}
	
	/**
	 * Get voxel color from last updated frame made visible
	 * @param x		Position on x axis
	 * @param y		Position on y axis
	 * @param z		Position on z axis
	 * @return		Color of specified voxel
	 */
	public Color getFromFrame(int x, int y, int z) {
		if (frame == null) return null;
		if (x < 0 || x >= VisualCubeConstants.WIDTH || y < 0 || y >= VisualCubeConstants.HEIGHT || z < 0 || z >= VisualCubeConstants.DEPTH) return null;
		VisualCubeConstants.Voxel voxel = frame[z * VisualCubeConstants.WIDTH * VisualCubeConstants.HEIGHT + y * VisualCubeConstants.WIDTH + x];
		return new Color(voxel.red, voxel.green, voxel.blue);		
	}

	/* (non-Javadoc)
	 * @see processing.visualcube.AbstractVisualCube#getRed(int, int, int)
	 */
	public int getRed(int x, int y, int z) {
		Color c = get(x, y, z);
		return c != null? c.r : 0;
	}
	
	/* (non-Javadoc)
	 * @see processing.visualcube.AbstractVisualCube#getGreen(int, int, int)
	 */
	public int getGreen(int x, int y, int z) {
		Color c = get(x, y, z);
		return c != null? c.g : 0;
	}
	
	/* (non-Javadoc)
	 * @see processing.visualcube.AbstractVisualCube#getBlue(int, int, int)
	 */
	public int getBlue(int x, int y, int z) {
		Color c = get(x, y, z);
		return c != null? c.b : 0;
	}

	/* (non-Javadoc)
	 * @see processing.visualcube.AbstractVisualCube#error()
	 */
	public String error() {
		// TODO Auto-generated method stub
		return null;
	}
	
	/**
	 * Draw a line between 2 points with a specific color.
	 * @param x0	x-coordinate of starting point
	 * @param y0	y-coordinate of starting point
	 * @param z0	z-coordinate of starting point
	 * @param x1	x-coordinate of target point
	 * @param y1	y-coordinate of target point
	 * @param z1	z-coordinate of target point
	 * @param c		Line's color
	 */
	public void line(int x0, int y0, int z0, int x1, int y1, int z1, Color c) {
		int dy = y1 - y0;
		int dx = x1 - x0;
		int dz = z1 - z0;
		int stepx, stepy, stepz;

		if (dy < 0) {
			dy = -dy;
			stepy = -1;
		} else {
			stepy = 1;
		}
		if (dx < 0) {
			dx = -dx;
			stepx = -1;
		} else {
			stepx = 1;
		}
		if (dz < 0) {
			dz = -dz;
			stepz = -1;
		} else {
			stepz = 1;
		}
		dy <<= 1;
		dx <<= 1;
		dz <<= 1;

		set(x0, y0, z0, c);
		if (dx > dy && dx > dz) {
			int fractiony = dy - (dx >> 1);
			int fractionz = dz - (dx >> 1);
			while (x0 != x1) {
				if (fractiony >= 0) {
					y0 += stepy;
					fractiony -= dx;
				}
				if (fractionz >= 0) {
					z0 += stepz;
					fractionz -= dz;
				}
				x0 += stepx;
				fractiony += dy;
				fractionz += dz;
				set(x0, y0, z0, c);
			}
		} else if (dx < dy && dy > dz) {
			int fractionx = dx - (dy >> 1);
			int fractionz = dz - (dy >> 1);
			while (y0 != y1) {
				if (fractionx >= 0) {
					x0 += stepx;
					fractionx -= dy;
				}
				if (fractionz >= 0) {
					z0 += stepz;
					fractionz -= dz;
				}
				fractionx += dx;
				y0 += stepy;
				fractionz += dz;
				set(x0, y0, z0, c);
			}
		} else {
			int fractionx = dx - (dz >> 1);
			int fractiony = dy - (dz >> 1);
			while (z0 != z1) {
				if (fractionx >= 0) {
					x0 += stepx;
					fractionx -= dy;
				}
				if (fractiony >= 0) {
					y0 += stepy;
					fractiony -= dy;
				}
				fractionx += dx;
				fractiony += dy;
				z0 += stepz;
				set(x0, y0, z0, c);
			}
		}
	}
	
	/**
	 * Draw a line between 2 points with a specific color.
	 * @param x0	x-coordinate of starting point
	 * @param y0	y-coordinate of starting point
	 * @param z0	z-coordinate of starting point
	 * @param x1	x-coordinate of target point
	 * @param y1	y-coordinate of target point
	 * @param z1	z-coordinate of target point
	 * @param r		red color portion within interval [0, color - 1]
	 * @param g		green color portion within interval [0, color - 1]
	 * @param b		blue color portion within interval [0, color - 1]
	 */
	public void line(int x0, int y0, int z0, int x1, int y1, int z1, int r, int g, int b) {
		line(x0, y0, z0, x1, y1, z1, new Color(r, g, b));
	}	

	/**
	 * Draw a line between 2 points with a specific color.
	 * @param x0	x-coordinate of starting point
	 * @param y0	y-coordinate of starting point
	 * @param z0	z-coordinate of starting point
	 * @param x1	x-coordinate of target point
	 * @param y1	y-coordinate of target point
	 * @param z1	z-coordinate of target point
	 * @param r		red color portion within interval [0, color - 1]
	 * @param g		green color portion within interval [0, color - 1]
	 * @param b		blue color portion within interval [0, color - 1]
	 * @param a		covering degree, 0 being none, 1 being full
	 */
	public void line(int x0, int y0, int z0, int x1, int y1, int z1, int r, int g, int b, float a) {
		line(x0, y0, z0, x1, y1, z1, new Color(r, g, b, a));
	}	
	
	/**
	 * Draw a cuboid filled with a specific color, frame colored differently.
	 * @param x0	x-coordinate of starting point
	 * @param y0	y-coordinate of starting point
	 * @param z0	z-coordinate of starting point
	 * @param x1	x-coordinate of target point
	 * @param y1	y-coordinate of target point
	 * @param z1	z-coordinate of target point
	 * @param c0	inner color
	 * @param c1	color to draw frame with
	 */
	public void cuboid(int x0, int y0, int z0, int x1, int y1, int z1, Color c0, Color c1) {
		if (x0 > x1) { int s = x0; x0 = x1; x1 = s; }
		if (y0 > y1) { int s = y0; y0 = y1; y1 = s; }
		if (z0 > z1) { int s = z0; z0 = z1; z1 = s; }
		
		for (int x = x0; x <= x1; x++) {
			for (int y = y0; y <= y1; y++) {
				for (int z = z0; z <= z1; z++) {
					set(x, y, z, (x == x0 || x == x1 || y == y0 || y == y1 || z == z0 || z == z1)? c1 : c0);
				}
			}
		}
	}

	/**
	 * Draw a cuboid filled with a specific color, frame colored differently.
	 * @param x0	x-coordinate of starting point
	 * @param y0	y-coordinate of starting point
	 * @param z0	z-coordinate of starting point
	 * @param x1	x-coordinate of target point
	 * @param y1	y-coordinate of target point
	 * @param z1	z-coordinate of target point
	 * @param r0	interior red color portion within interval [0, color - 1]
	 * @param g0	interior green color portion within interval [0, color - 1]
	 * @param b0	interior blue color portion within interval [0, color - 1]
	 * @param r1	frame's red color portion within interval [0, color - 1]
	 * @param g1	frame's green color portion within interval [0, color - 1]
	 * @param b1	frame's blue color portion within interval [0, color - 1]
	 */
	public void cuboid(int x0, int y0, int z0, int x1, int y1, int z1, int r0, int g0, int b0, int r1, int g1, int b1) {
		cuboid(x0, y0, z0, x1, y1, z1, new Color(r0, g0, b0), new Color(r1, g1, b1));
	}
	
	/**
	 * Draw a cuboid filled with a specific color, frame colored differently.
	 * @param x0	x-coordinate of starting point
	 * @param y0	y-coordinate of starting point
	 * @param z0	z-coordinate of starting point
	 * @param x1	x-coordinate of target point
	 * @param y1	y-coordinate of target point
	 * @param z1	z-coordinate of target point
	 * @param r0	interior red color portion within interval [0, color - 1]
	 * @param g0	interior green color portion within interval [0, color - 1]
	 * @param b0	interior blue color portion within interval [0, color - 1]
	 * @param a0	interior color's covering degree, 0 being none, 1 being full
	 * @param r1	frame's red color portion within interval [0, color - 1]
	 * @param g1	frame's green color portion within interval [0, color - 1]
	 * @param b1	frame's blue color portion within interval [0, color - 1]
	 * @param a		frame's color's covering degree, 0 being none, 1 being full
	 */
	public void cuboid(int x0, int y0, int z0, int x1, int y1, int z1, int r0, int g0, int b0, float a0, int r1, int g1, int b1, float a1) {
		cuboid(x0, y0, z0, x1, y1, z1, new Color(r0, g0, b0, a0), new Color(r1, g1, b1, a1));
	}
	
	/**
	 * Draw a cuboid filled with a color.
	 * @param x0	x-coordinate of starting point
	 * @param y0	y-coordinate of starting point
	 * @param z0	z-coordinate of starting point
	 * @param x1	x-coordinate of target point
	 * @param y1	y-coordinate of target point
	 * @param z1	z-coordinate of target point
	 * @param c		frame's color
	 */
	public void cuboid(int x0, int y0, int z0, int x1, int y1, int z1, Color c) {
		cuboid(x0, y0, z0, x1, y1, z1, c, c);
	}
	
	/**
	 * Draw a cuboid filled with a color.
	 * @param x0	X-coordinate of starting point
	 * @param y0	Y-coordinate of starting point
	 * @param z0	Z-coordinate of starting point
	 * @param x1	X-coordinate of target point
	 * @param y1	Y-coordinate of target point
	 * @param z1	Z-coordinate of target point
	 * @param r		red color portion within interval [0, color - 1]
	 * @param g		green color portion within interval [0, color - 1]
	 * @param b		blue color portion within interval [0, color - 1]
	 */
	public void cuboid(int x0, int y0, int z0, int x1, int y1, int z1, int r, int g, int b) {
		cuboid(x0, y0, z0, x1, y1, z1, new Color(r, g, b));
	}

	/**
	 * Draw a cuboid filled with a color.
	 * @param x0	X-coordinate of starting point
	 * @param y0	Y-coordinate of starting point
	 * @param z0	Z-coordinate of starting point
	 * @param x1	X-coordinate of target point
	 * @param y1	Y-coordinate of target point
	 * @param z1	Z-coordinate of target point
	 * @param r		red color portion within interval [0, color - 1]
	 * @param g		green color portion within interval [0, color - 1]
	 * @param b		blue color portion within interval [0, color - 1]
	 * @param a		covering degree, 0 being none, 1 being full
	 */
	public void cuboid(int x0, int y0, int z0, int x1, int y1, int z1, int r, int g, int b, float a) {
		cuboid(x0, y0, z0, x1, y1, z1, new Color(r, g, b, a));
	}

}
