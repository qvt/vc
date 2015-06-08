package processing.visualcube1e3.simulator;

import processing.core.PApplet;

/**
 * General vector math useful for calculations in 2D space.
 * A vector defines a point in 3D space.
 * 
 * @author	Andreas Rentschler
 * @date	2008-07-21
 * @version	1.0
 */
class Vector2D {
	public final float x, y; 

	/**
	 * Create a new Vector.
	 * @param x Vector's x value
	 * @param y Vector's y value
	 */
	public Vector2D(float x, float y) {
		this.x = x;
		this.y = y;
	}

	/**
	 * Show string representation.
	 * @return This Vector's string representation
	 */
	public String toString() {
		return "(" + x + ", " + y + ")";
	}

	/**
	 * Get Vector's norm.
	 * @return A number containing this Vector's norm
	 */
	public float norm() {
		return PApplet.sqrt(x*x + y*y);
	}

	/**
	 * Normalize Vector.
	 * @return A new Vector containing the result
	 */
	public Vector2D normalize() {
		float d = this.norm();
		return new Vector2D(x/d, y/d);
	}

	/**
	 * Create Vector conjugate.
	 * @return A new Vector containing the result
	 */
	public Vector2D conjugate() {
		return new Vector2D(-x, -y);
	}

	/**
	 * Add Vector to another Vector.
	 * @param b Vector to be added
	 * @return A new Vector containing the result
	 */
	public Vector2D plus(Vector2D b) {
		Vector2D a = this;
		return new Vector2D(a.x+b.x, a.y+b.y);
	}

	/**
	 * Subtract another Vector from Vector.
	 * @param b Vector to be subtracted
	 * @return A new Vector containing the result
	 */
	public Vector2D minus(Vector2D b) {
		Vector2D a = this;
		return new Vector2D(a.x-b.x, a.y-b.y);
	}
	
	/**
	 * Calculate distance to another Vector.
	 * @param b Another Vector
	 * @return Distance
	 */
	public float distance(Vector2D b) {
		Vector2D a = this;
		return a.minus(b).norm();
	}
	
	/**
	 * Multiply Vector by another Vector (cross product).
	 * @param b Right-sided multiplication Vector
	 * @return A new Vector containing the result
	 */
	public Vector2D cross(Vector2D b) {
		Vector2D a = this;
		return new Vector2D(
				+ a.y*b.x - b.x*a.x,
				- a.x*b.y + b.x*a.y);
	}

	/**
	 * Multiply Vector by another Vector (dot product).
	 * @param b Right-sided multiplication Vector
	 * @return A scalar containing the result
	 */
	public float dot(Vector2D b) {
		Vector2D a = this;
		return a.x*b.x + a.y*b.y;
	}
	
	/**
	 * Multiply Vector by another Vector (scalar product).
	 * @param b Multiplication scalar
	 * @return A new Vector containing the result
	 */
	public Vector2D times(float f) {
		return new Vector2D(x*f, y*f);
	}

	/** Invert Vector.
	 * @return A new Vector containing the result
	 */
	public Vector2D inverse() {
		float d = x*x + y*y ;
		return new Vector2D(x/d, y/d);
	}

	/**
	 * Divide Vector a by another Vector b.
	 * @param b Divisor Vector
	 * @return A new Vector containing the result
	 */
	public Vector2D divides(Vector2D b) {
		Vector2D a = this;
		return a.inverse().cross(b);
	}

	/**
	 * Divide Vector by a number.
	 * @param b Divisor number
	 * @return A new Vector containing the result
	 */	    
	public Vector2D divides(float b) {
		return new Vector2D(x/b, y/b);
	}

	/**
	 * Ensure Vector stays in range.
	 * @param a minimum value
	 * @param b maximum value
	 * @return A new Vector containing the result
	 */	    
	public Vector2D constrain(float a, float b) {
		return new Vector2D(
				PApplet.constrain(x, a, b), 
				PApplet.constrain(y, a, b));
	}
	
}