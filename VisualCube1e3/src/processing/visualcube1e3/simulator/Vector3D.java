package processing.visualcube1e3.simulator;

import processing.core.PApplet;

/**
 * General vector math useful for calculations in 3D space.
 * A vector defines a point in 3D space.
 * 
 * @author	Andreas Rentschler
 * @date	2008-07-21
 * @version	1.0
 */
class Vector3D {
	public final float x, y, z; 

	/**
	 * Create a new Vector.
	 * @param x0 Vector's x value
	 * @param x1 Vector's y value
	 * @param x2 Vector's z value
	 */
	public Vector3D(float x0, float x1, float x2) {
		this.x = x0;
		this.y = x1;
		this.z = x2;
	}

	/**
	 * Show string representation.
	 * @return This Vector's string representation
	 */
	public String toString() {
		return "(" + x + ", " + y + ", " + z + ")";
	}

	/**
	 * Get Vector's norm.
	 * @return A number containing this Vector's norm
	 */
	public float norm() {
		return PApplet.sqrt(x*x + y*y +z*z);
	}

	/**
	 * Normalize Vector.
	 * @return A new Vector containing the result
	 */
	public Vector3D normalize() {
		float d = this.norm();
		return new Vector3D(x/d, y/d, z/d);
	}

	/**
	 * Create Vector conjugate.
	 * @return A new Vector containing the result
	 */
	public Vector3D conjugate() {
		return new Vector3D(-x, -y, -z);
	}

	/**
	 * Add Vector to another Vector.
	 * @param b Vector to be added
	 * @return A new Vector containing the result
	 */
	public Vector3D plus(Vector3D b) {
		Vector3D a = this;
		return new Vector3D(a.x+b.x, a.y+b.y, a.z+b.z);
	}

	/**
	 * Subtract another Vector from Vector.
	 * @param b Vector to be subtracted
	 * @return A new Vector containing the result
	 */
	public Vector3D minus(Vector3D b) {
		Vector3D a = this;
		return new Vector3D(a.x-b.x, a.y-b.y, a.z-b.z);
	}
	
	/**
	 * Calculate distance to another Vector.
	 * @param b Another Vector
	 * @return Distance
	 */
	public float distance(Vector3D b) {
		Vector3D a = this;
		return a.minus(b).norm();
	}
	
	/**
	 * Multiply Vector by another Vector (cross product).
	 * @param b Right-sided multiplication Vector
	 * @return A new Vector containing the result
	 */
	public Vector3D cross(Vector3D b) {
		Vector3D a = this;
		return new Vector3D(
				+ a.y*b.z - b.y*a.z,
				- a.x*b.z + b.x*a.z,
				+ a.x*b.y - b.x*a.y);
	}

	/**
	 * Multiply Vector by another Vector (dot product).
	 * @param b Right-sided multiplication Vector
	 * @return A scalar containing the result
	 */
	public float dot(Vector3D b) {
		Vector3D a = this;
		return a.x*b.x + a.y*b.y + a.z*b.z;
	}
	
	/**
	 * Multiply Vector by another Vector (scalar product).
	 * @param b Multiplication scalar
	 * @return A new Vector containing the result
	 */
	public Vector3D times(float f) {
		return new Vector3D(x*f, y*f, z*f);
	}

	/** Invert Vector.
	 * @return A new Vector containing the result
	 */
	public Vector3D inverse() {
		float d = x*x + y*y + z*z;
		return new Vector3D(x/d, y/d, z/d);
	}

	/**
	 * Divide Vector a by another Vector b.
	 * @param b Divisor Vector
	 * @return A new Vector containing the result
	 */
	public Vector3D divides(Vector3D b) {
		Vector3D a = this;
		return a.inverse().cross(b);
	}

	/**
	 * Divide Vector by a number.
	 * @param b Divisor number
	 * @return A new Vector containing the result
	 */	    
	public Vector3D divides(float b) {
		return new Vector3D(x/b, y/b, z/b);
	}

	/**
	 * Ensure Vector stays in range.
	 * @param a minimum value
	 * @param b maximum value
	 * @return A new Vector containing the result
	 */	    
	public Vector3D constrain(float a, float b) {
		return new Vector3D(
				PApplet.constrain(x, a, b), 
				PApplet.constrain(y, a, b), 
				PApplet.constrain(z, a, b));
	}
	
	/**
	 * Convert to 2D Vector.
	 * @return new Vector without 3rd coordinate
	 */
	public Vector2D dropZ() {
		return new Vector2D(x, y);
	}
	
}