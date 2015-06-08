package processing.visualcube1e3.simulator;

import processing.core.PApplet;

/**
 * General vector math useful for calculations in 3D space.
 * A quaternion defines in 3D space an axis through the origin and a relative rotation angle around it.
 * Quaternions are easier to handle and a lot faster than matrices concerning multiplication issues:
 * -> no gimbal lock i.e. one axis is rotated onto the other and therefore disappears, 
 * -> an arbitrary rotation is defined in one element compared to 3 rotation matrices.
 * -> combining rotations is done through multiplying 2 quats.
 * -> easier inversion of rotation than matrices: 
 *    rotx(a); roty(b); rotz(c); rotz(-c); roty(-b); rotx(-a);
 * 
 * @author	Andreas Rentschler
 * @date	2008-07-21
 * @version	1.0
 */
class Quaternion {
    public final float w, x, y, z; 
    
    public static final Quaternion UNIT = new Quaternion(1f, 0f, 0f, 0f);

    /**
     * Create a new Quaternion.
     * @param w This Quaternion's scalar (normalized angle)
     * @param x Vector's 1st value (x axis)
     * @param y Vector's 2nd value (y axis)
     * @param z Vector's 3rd value (z axis)
     */
    public Quaternion(float w, float x, float y, float z) {
        this.w = w;
        this.x = x;
        this.y = y;
        this.z = z;
    }

    /**
     * Create a new Quaternion.
     * @param a Scalar part (radiant angle)
     * @param v Vector part
     */
    public Quaternion(float a, Vector3D v) {
        Vector3D v2 = v.times(PApplet.sin(a/2f));
    	this.w = PApplet.cos(a/2f);
        this.x = v2.x;
        this.y = v2.y;
        this.z = v2.z;
    }
    
    /**
     * Convert first element to radiant angle
     * @return Radiant angle
     */
    public float getAngle() {
    	return 2f * PApplet.acos(w);
	}

    /**
     * Get vector part of Quaternion
     * @return Vector part
     */
    public Vector3D getAxis() {
    	float a = PApplet.sqrt(1.0f - w*w);
    	if (PApplet.abs(a) < 0.0005f) a = 1;
    	return new Vector3D(x/a, y/a, z/a);
    }

    /**
     * Show string representation.
     * @return This Quaternion's string representation
     */
    public String toString() {
        return w + " + " + x + "x + " + y + "y + " + z + "z";
    }

    /**
     * Get Quaternion's norm.
     * @return A number containing this Quaternions's norm
     */
    public float norm() {
        return PApplet.sqrt(w*w + x*x +y*y + z*z);
    }

    /**
     * Normalize Quaternion.
     * @return A new Quaternion containing the result
     */
    public Quaternion normalize() {
    	float d = this.norm();
        return new Quaternion(w/d, x/d, y/d, z/d);
    }

    /**
     * Create Quaternion conjugate.
     * @return A new Quaternion containing the result
     */
    public Quaternion conjugate() {
        return new Quaternion(w, -x, -y, -z);
    }

    /**
     * Add Quaternion to another Quaternion.
     * @param b Quaternion to be added
     * @return A new Quaternion containing the result
     */
    public Quaternion plus(Quaternion b) {
        Quaternion a = this;
        return new Quaternion(a.w+b.w, a.x+b.x, a.y+b.y, a.z+b.z);
    }

    /**
     * Multiply Quaternion by another Quaternion.
     * @param b Right-sided multiplication Quaternion
     * @return A new Quaternion containing the result
     */
    public Quaternion times(Quaternion b) {
        Quaternion a = this;
        float w = a.w*b.w - a.x*b.x - a.y*b.y - a.z*b.z;
        float x = a.w*b.x + a.x*b.w + a.y*b.z - a.z*b.y;
        float y = a.w*b.y - a.x*b.z + a.y*b.w + a.z*b.x;
        float z = a.w*b.z + a.x*b.y - a.y*b.x + a.z*b.w;
        return new Quaternion(w, x, y, z);
    }

    /**
     * Invert Quaternion.
     * @return A new Quaternion containing the result
     */
    public Quaternion inverse() {
    	float d = w*w + x*x + y*y + z*z;
        return new Quaternion(w/d, -x/d, -y/d, -z/d);
    }

    /**
     * Divide Quaternion a by another Quaternion b.
     * @param b Divisor Quaternion
     * @return A new Quaternion containing the result
     */
    public Quaternion divides(Quaternion b) {
        Quaternion a = this;
        return a.inverse().times(b);
    }

    /**
     * Divide Quaternion by a number.
     * @param b Divisor number
     * @return A new Quaternion containing the result
     */	    
    public Quaternion divides(float b) {
        return new Quaternion(w/b, x/b, y/b, z/b);
    }

}