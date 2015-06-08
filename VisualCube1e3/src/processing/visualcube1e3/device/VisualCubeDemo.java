package processing.visualcube1e3.device;

import java.io.IOException;

/**
 * This class provides a stand-alone test for VisualCube.
 * 
 * @author	Andreas Rentschler
 * @date	2008-07-21
 * @version	1.0
 */
public class VisualCubeDemo {
	
	public static void main(String[] args) {

		System.out.println("===============================");
		System.out.println(" Testing the VisualCube1e3 API ");
		System.out.println("===============================");
		System.out.println();

//		System.out.println();
//		System.out.println("VISUALCUBE DEVICES:");
//		Vector<StreamingDevice> devices = new VisualCubeDiscovery().getDevices();
//		if (devices == null || devices.size() == 0) return;
//
//		System.out.println();
//		System.out.println("CONNECTING TO NEXT BEST VISUALCUBE:");
//		StreamingDevice device = devices.firstElement();
//		device.connect();
//		test(new VisualCubeCommunication(device));
//		device.disconnect();
		
		System.out.println();
		System.out.print("Press return to continue... ");
		try { 
			System.in.read();
		} catch (IOException e) {
		}
		
	}
	
//	private static void test(StreamCommunication connection) {
//		// fill with random colors; set point of origin [0, 0, 0] to black
//		VisualCubeConstants.Voxel[] voxels = new VisualCubeConstants.Voxel[VisualCubeConstants.WIDTH * VisualCubeConstants.DEPTH * VisualCubeConstants.HEIGHT];
//		for (int i = 0; i < voxels.length; i++) {
//			voxels[i] = new VisualCubeConstants.Voxel(
//					(byte) new Random().nextInt(VisualCubeConstants.COLORS), 
//					(byte) new Random().nextInt(VisualCubeConstants.COLORS), 
//					(byte) new Random().nextInt(VisualCubeConstants.COLORS));
//		}
//		voxels[0].blue = voxels[0].red = voxels[0].green = 0;
//		System.out.println("StreamFrame() = " + VisualCubeConstants.StreamFrame(VisualCubeConstants.WIDTH, VisualCubeConstants.HEIGHT, VisualCubeConstants.DEPTH, voxels));
//	}
	
}
