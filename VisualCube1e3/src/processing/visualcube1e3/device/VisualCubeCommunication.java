package processing.visualcube1e3.device;

import java.net.MalformedURLException;
import java.net.URL;
import java.nio.ByteBuffer;
import java.util.Vector;

import processing.visualcube1e3.device.VisualCubeConstants.MESSAGE;
import processing.visualcube1e3.device.VisualCubeConstants.RESULT;
import processing.visualcube1e3.device.VisualCubeConstants.Voxel;

import org.apache.xmlrpc.XmlRpcException;
import org.apache.xmlrpc.XmlRpcRequest;
import org.apache.xmlrpc.client.AsyncCallback;
import org.apache.xmlrpc.client.XmlRpcClient;
import org.apache.xmlrpc.client.XmlRpcClientConfigImpl;
import org.apache.xmlrpc.client.XmlRpcCommonsTransportFactory;

/**
 * Communicate with a VisualCube1e3 device via XML-RPC.
 * Interface is exact mapping of hardware functions. 
 * 
 * @author	Andreas Rentschler
 * @date	2008-07-21
 * @version	1.0
 */
public class VisualCubeCommunication {
	
	/**
	 * Connection handle
	 */
	private XmlRpcClient client;
	
	/**
	 * asynchronous remote procedure call still active
	 */
	private boolean asyncExecution = false;
	
	/**
	 * Initialize communication
	 * @param url The device to connect to identified by network id
	 * @throws VisualCubeException 
	 */
	public VisualCubeCommunication(String url) throws VisualCubeException {
		// check environment variable, java properties
		String environment = System.getenv("visualcube1e3.url");
		String property = System.getProperty("visualcube1e3.url");
		
		// if neither URL nor variable is given rely onto /etc/hosts name mapping
		url = url != null? url : environment != null? environment : property != null? property : "visualcube1e3";
		if (!url.contains(":/")) url = "http://" + url + ":8080/RPC2";
		
		// setup XML-RPC communication
		XmlRpcClientConfigImpl config = new XmlRpcClientConfigImpl();
		try {
			config.setServerURL(new URL(url));
		} catch (MalformedURLException e) {
			throw new VisualCubeException("No device found at URL " + url + ".");
		}
		config.setEnabledForExtensions(true);	// enable vendor extensions to allow compression, data types support ...
		config.setConnectionTimeout(1000);		// wait 1s for connection, NB: unsupported by XmlRpcLiteHttpTransportFactory
		config.setReplyTimeout(1000);			// wait 1s for reply, NB: unsupported by XmlRpcLiteHttpTransportFactory
		//config.setContentLengthOptional(true);	// enables faster and memory saving streaming mode
		//config.setGzipCompressing(true);			// requests gzip compression
		//config.setGzipRequesting(true);			// requests server to gzip response
		
		client = new XmlRpcClient();
		client.setTransportFactory(new XmlRpcCommonsTransportFactory(client));
		client.setConfig(config);
	}
	
	/**
	 * Get displayable API/device version banner.
	 * @return String containing version string
	 * @throws VisualCubeException 
	 */
	public String getDeviceInfo() throws VisualCubeException {
		String info;
		
		try {
			Vector<Object> params = new Vector<Object>();
			info = (String) client.execute(MESSAGE.GETDEVICEINFO.id, params);
		} catch (XmlRpcException e) {
			throw new VisualCubeException(e.toString());
		}
		
		return info;
	}
	
	/**
	 * Analyze device components depending on flags.
	 * @param attributes	flags
	 * @return result corresponding to given flag
	 * @throws VisualCubeException 
	 */
	public String getDeviceStatusReport(int attributes) throws VisualCubeException {
		String result;
		
		try {
			Vector<Object> params = new Vector<Object>();
			params.add(attributes);
			result = (String) client.execute(MESSAGE.GETDEVICESTATUSREPORT.id, params);
		} catch (XmlRpcException e) {
			throw new VisualCubeException(e.toString());
		}
		
		return result;
	}
	
	/**
	 * Set control flags or execute function (eg. put-down-display, 
	 * ignore-fps-delimiter, reset-voxels, reset-sub-ctrl, highspeed-mode etc.).
	 * @param flags control flags
	 * @return true iff successful
	 * @throws VisualCubeException 
	 */
	public boolean setDeviceControlFlags(int flags) throws VisualCubeException {
		int status;
		
		try {
			Vector<Object> params = new Vector<Object>();
			params.add(flags);
			status = (Integer) client.execute(MESSAGE.SETDEVICECONTROLFLAGS.id, params);
		} catch (XmlRpcException e) {
			throw new VisualCubeException(e.toString());
		}
		
		return (status == RESULT.SUCCESS.nr);
	}
	
	/**
	 * Reset device according to flags.
	 * @param flags	flags describing what to reset
	 * @return true iff successful
	 * @throws VisualCubeException 
	 */
	public boolean resetDevice(int flags) throws VisualCubeException {
		int status;
		
		try {
			Vector<Object> params = new Vector<Object>();
			params.add(flags);
			status = (Integer) client.execute(MESSAGE.RESETDEVICE.id, params);
		} catch (XmlRpcException e) {
			throw new VisualCubeException(e.toString());
		}
		
		return (status == RESULT.SUCCESS.nr);
	}
	
	/**
	 * Update frame asynchronously that means function creates a worker thread and returns instantly.
	 * @param maxFps maximum frames per seconds to allow updates
	 * @param frame array of color information for voxels to update
	 * @throws VisualCubeException 
	 */
	public void updateDisplay(int maxFps, Voxel[] frame) throws VisualCubeException {
		ByteBuffer data = ByteBuffer.allocate(VisualCubeConstants.WIDTH * VisualCubeConstants.HEIGHT * VisualCubeConstants.DEPTH * 3);
		for (int z = 0; z < VisualCubeConstants.DEPTH; z++) {
			for (int y = 0; y < VisualCubeConstants.HEIGHT; y++) {
				for (int x = 0; x < VisualCubeConstants.WIDTH; x++) {
					Voxel v = frame[z * VisualCubeConstants.WIDTH * VisualCubeConstants.HEIGHT + y * VisualCubeConstants.WIDTH + x];
					data.put((byte) v.red).put((byte) v.green).put((byte) v.blue);
				}
			}
		}	
		
		try {
			Vector<Object> params = new Vector<Object>();
			params.add(maxFps);
			params.add(data.array());
			
			if (asyncExecution)
				throw new VisualCubeException("Still waiting for last asynchronous remote procedure invocation.");
			asyncExecution = true;		
			
			client.executeAsync(MESSAGE.UPDATEDISPLAY.id, params, new AsyncCallback() {
				public void handleError(XmlRpcRequest request, Throwable throwable) {
					System.out.println("Device update interrupted: " + throwable);
					asyncExecution = false;
				}
				public void handleResult(XmlRpcRequest request, Object result) {
					if ((Integer) result != RESULT.SUCCESS.nr)
						System.out.println("Device update failed.");
					asyncExecution = false;
				}
				
			});
		} catch (XmlRpcException e) {
			throw new VisualCubeException(e.toString());
		}
	}

//	/**
//	 * Set color of a voxel defined by its logic position.
//	 * @param x x coordinate
//	 * @param y y coordinate
//	 * @param y y coordinate
//	 * @param v color information for voxel to update
//	 * @return true iff successful
//	 * @throws VisualCubeException 
//	 */
//	public boolean setVoxelByLogicPosition(int x, int y, int z, Voxel v) throws VisualCubeException {
//		ByteBuffer data = ByteBuffer.allocate(1 * 3);
//		data.put((byte) v.red).put((byte) v.green).put((byte) v.blue);
//		
//		int result;
//		
//		try {
//			Vector<Object> params = new Vector<Object>();
//			params.add(x);
//			params.add(y);
//			params.add(z);
//			params.add(data.array());
//			result = (Integer) client.execute(MESSAGE.SETVOXELBYLOGICPOSITION.id, params);
//		} catch (XmlRpcException e) {
//			throw new VisualCubeException(e.toString());
//		}
//		
//		return (result == RESULT.SUCCESS.nr);
//	}
//	
//	/**
//	 * Set color of a voxel defined by its ID.
//	 * @param mcbIndex
//	 * @param subControllerId
//	 * @param scbIndex
//	 * @param voxelId
//	 * @param v color information for voxel to update
//	 * @return true iff successful
//	 * @throws VisualCubeException 
//	 */
//	public boolean setVoxel(int mcbIndex, int subControllerId, int scbIndex, int voxelId, Voxel v) throws VisualCubeException {
//		ByteBuffer data = ByteBuffer.allocate(1 * 3);
//		data.put((byte) v.red).put((byte) v.green).put((byte) v.blue);
//		
//		int result;
//		
//		try {
//			Vector<Object> params = new Vector<Object>();
//			params.add(mcbIndex);
//			params.add(subControllerId);
//			params.add(scbIndex);
//			params.add(voxelId);
//			params.add(data.array());
//			result = (Integer) client.execute(MESSAGE.SETVOXEL.id, params);
//		} catch (XmlRpcException e) {
//			throw new VisualCubeException(e.toString());
//		}
//		
//		return (result == RESULT.SUCCESS.nr);
//	}
//	
//	/*
//	 * Missing functions left:
//	 * VisualCube1e3.getVoxelStatusByLogicPosition(int x, int y, int z, struct &stat) -> int
//	 * VisualCube1e3.getVoxelStatus(int mcb_index, int subctrl_id, int scb_index, int voxel_id, struct &stat) -> int
//	 */	
//	
//	/**
//	 * Set a subcontroller's LED.
//	 * @param mcbIndex
//	 * @param subControllerId
//	 * @param frequency
//	 * @return true iff successful
//	 * @throws VisualCubeException 
//	 */
//	public boolean setSubControllerLed(int mcbIndex, int subControllerId, int frequency) throws VisualCubeException {
//		int result;
//		
//		try {
//			Vector<Object> params = new Vector<Object>();
//			params.add(mcbIndex);
//			params.add(subControllerId);
//			params.add(frequency);
//			result = (Integer) client.execute(MESSAGE.SETVOXEL.id, params);
//		} catch (XmlRpcException e) {
//			throw new VisualCubeException(e.toString());
//		}
//		
//		return (result == RESULT.SUCCESS.nr);
//	}
}
