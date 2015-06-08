package processing.visualcube1e3;

/**
 * Interface to an abstract VisualCube device.
 * Abstract in the means that this interface is overly simplified from hardware interface.
 * 
 * @author Andreas Rentschler
 * @date 2008-07-21
 * @version 1.0
 */
public interface AbstractVisualCube {

	/**
	 * Type represents color value of a voxel.
	 */
	public static class Color {
		
		/**
		 * Initialize a specific color
		 * @param r		red color portion within interval [0, color - 1]
		 * @param g		green color portion within interval [0, color - 1]
		 * @param b		blue color portion within interval [0, color - 1]
		 */
		public Color(int r, int g, int b) {
			this.r = r;
			this.g = g;
			this.b = b;
			this.a = 1.0f;
		}

		/**
		 * Initialize a specific color
		 * @param r		red color portion within interval [0, color - 1]
		 * @param g		green color portion within interval [0, color - 1]
		 * @param b		blue color portion within interval [0, color - 1]
		 * @param a		degree of coverage within interval [0, 1]
		 */
		public Color(int r, int g, int b, float a) {
			this.r = r;
			this.g = g;
			this.b = b;
			this.a = a;
		}

		public int r;
		public int g;
		public int b;
		public float a;
	}
	
	/**
	 * Maximum number of voxels along x axis
	 */
	public final static int width = 0;
	/**
	 * Maximum number of voxels along y axis
	 */
	public final static int height = 0;
	/**
	 * Maximum number of voxels along z axis
	 */
	public final static int depth = 0;
	/**
	 * Maximum number of color tones per r/g/b portion
	 */
	public final static int colors = 0;

	/**
	 * Start connection to device.
	 * @return true iff successful
	 */
	public abstract boolean open();

	/**
	 * End connection to device.
	 * @return true iff successful
	 */
	public abstract boolean close();

	/**
	 * Show current state of voxels on device.
	 * @return true iff successful
	 */
	public abstract boolean update();

	/**
	 * Set all voxels to be set at next update to black (0, 0, 0).
	 */
	public abstract void clear();

	/**
	 * Set all voxels to be set at next update to specified color value.
	 * @param c		color type defining color portions
	 */
	public abstract void fill(Color c);

	/**
	 * Set all voxels to be set at next update to specified color portions.
	 * @param r		red color portion within interval [0, color - 1]
	 * @param g		green color portion within interval [0, color - 1]
	 * @param b		blue color portion within interval [0, color - 1]
	 */
	public abstract void fill(int r, int g, int b);
	
	/**
	 * Set all voxels to be set at next update to specified color portions.
	 * @param r		red color portion within interval [0, color - 1]
	 * @param g		green color portion within interval [0, color - 1]
	 * @param b		blue color portion within interval [0, color - 1]
	 * @param a		covering degree, 0 being none, 1 being full
	 */
	public abstract void fill(int r, int g, int b, float a);

	/**
	 * Set color value of specified voxel to be set at next update.
	 * @param x		voxel position along the x axis within interval [0, width - 1]
	 * @param y		voxel position along the y axis within interval [0, height - 1]
	 * @param z		voxel position along the z axis within interval [0, depth - 1]
	 * @param c		color type defining color portions
	 * @return		true iff successful
	 */
	public abstract boolean set(int x, int y, int z, Color c);

	/**
	 * Set color portions of specified voxel to be set at next update.
	 * @param x		voxel position along the x axis within interval [0, width - 1]
	 * @param y		voxel position along the y axis within interval [0, height - 1]
	 * @param z		voxel position along the z axis within interval [0, depth - 1]
	 * @param r		red color portion within interval [0, color - 1]
	 * @param g		green color portion within interval [0, color - 1]
	 * @param b		blue color portion within interval [0, color - 1]
	 * @return		true iff successful
	 */
	public abstract boolean set(int x, int y, int z, int r, int g, int b);

	/**
	 * Set color portions of specified voxel to be set at next update.
	 * @param x		voxel position along the x axis within interval [0, width - 1]
	 * @param y		voxel position along the y axis within interval [0, height - 1]
	 * @param z		voxel position along the z axis within interval [0, depth - 1]
	 * @param r		red color portion within interval [0, color - 1]
	 * @param g		green color portion within interval [0, color - 1]
	 * @param b		blue color portion within interval [0, color - 1]
	 * @param a		covering degree, 0 being none, 1 being full
	 * @return		true iff successful
	 */
	public abstract boolean set(int x, int y, int z, int r, int g, int b, float a);
	
	/**
	 * Get color of specified voxel to be set at next update.
	 * 
	 * @param x		voxel position along the x axis within interval [0, width - 1]
	 * @param y		voxel position along the y axis within interval [0, height - 1]
	 * @param z		voxel position along the z axis within interval [0, depth - 1]
	 * @return		a color type
	 */
	public abstract Color get(int x, int y, int z);

	/**
	 * Get red color portion of specified voxel to be set at next update.
	 * 
	 * @param x		voxel position along the x axis within interval [0, width - 1]
	 * @param y		voxel position along the y axis within interval [0, height - 1]
	 * @param z		voxel position along the z axis within interval [0, depth - 1]
	 * @return		a color value ranging from 0 to (colors - 1)
	 */
	public abstract int getRed(int x, int y, int z);

	/**
	 * Get green color portion of specified voxel to be set at next update.
	 * 
	 * @param x		voxel position along the x axis within interval [0, width - 1]
	 * @param y		voxel position along the y axis within interval [0, height - 1]
	 * @param z		voxel position along the z axis within interval [0, depth - 1]
	 * @return		a color value ranging from 0 to (colors - 1)
	 */
	public abstract int getGreen(int x, int y, int z);

	/**
	 * Get blue color portion of specified voxel to be set at next update.
	 * 
	 * @param x		position along the x axis within interval [0, width - 1]
	 * @param y		position along the y axis within interval [0, height - 1]
	 * @param z		position along the z axis within interval [0, depth - 1]
	 * @return		a color value ranging from 0 to (colors - 1)
	 */
	public abstract int getBlue(int x, int y, int z);

	/**
	 * Get error state.
	 * @return descriptive text describing error
	 */
	public abstract String error();

}