package processing.visualcube1e3.device;

/**
 * Constants and types concerning a VisualCube1e3 device.
 * 
 * @author	Andreas Rentschler
 * @date	2008-07-21
 * @version	1.0
 */
public class VisualCubeConstants {
	
	/** Version information as to be expected (and as supported), length <= RX_MESSAGE_DATA_SIZE / 2 - 1 */
	public final static String VERSION = "VisualCube1e3 v1.0\nMain Controller Firmware v1.0\nSub Controller Firmware v1.0";
	
	/** Number of LEDs on X axis */
	public final static int WIDTH = 10;
	
	/** Number of LEDs on X axis */
	public final static int HEIGHT = 10;
	
	/** Number of LEDs on X axis */
	public final static int DEPTH = 10;
	
	/** Number of available colors => range [0, 255] */
	public static final int COLORS = 256;

	/** Number of voxels per frame */
	public final static int FRAME_SIZE = (WIDTH * HEIGHT * DEPTH);

	/** Number of frames per second */
	public static final int FRAMERATE = 30;
	
//	/** Typical delay device needs to answer */
//	public static final int DELAY = 20;

	/** RPC Message IDs */
	public static enum MESSAGE {
		GETDEVICEINFO("VisualCube1e3.getDeviceInfo"), 
		GETDEVICESTATUSREPORT("VisualCube1e3.getDeviceStatusReport"), 
		SETDEVICECONTROLFLAGS("VisualCube1e3.setDeviceControlFlags"), 
		RESETDEVICE("VisualCube1e3.resetDevice"), 
		UPDATEDISPLAY("VisualCube1e3.updateDisplay"),
		SETVOXELBYLOGICPOSITION("VisualCube1e3.setVoxelByLogicPosition"), 
		SETVOXEL("VisualCube1e3.setVoxel"),
		GETVOXELSTATUSBYLOGICPOSITION("VisualCube1e3.getVoxelStatusByLogicPosition"), 
		GETVOXELSTATUS("VisualCube1e3.getVoxelStatus"),
		SETSUBCONTROLLERLED("VisualCube1e3.setSubControllerLed");

		/** ID representing RPC message */
		public String id;
		
		MESSAGE(String id) {
			this.id = id;
		}
	};
	
	/** RPC Status IDs */
	public static enum RESULT {
		SUCCESS(0), 
		ERROR(1);
		
		/** ID representing RPC status */
		public int nr;
		
		RESULT(int nr) {
			this.nr = nr;
		}
	};
	
	public static class Voxel {
		Voxel(int red, int green, int blue) {
			this.red = red;
			this.green = green;
			this.blue = blue;
		}
		public Voxel() {
			this(0, 0, 0);
		}
		
		public int red;
		public int green;
		public int blue;
	}

}
