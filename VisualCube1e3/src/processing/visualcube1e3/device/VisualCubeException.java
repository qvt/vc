package processing.visualcube1e3.device;
import java.io.IOException;

/**
 * Exceptions throwable by a VisualCube1e3 device.
 * 
 * @author	Andreas Rentschler
 * @date	2008-07-21
 * @version	1.0
 */
public class VisualCubeException extends IOException
{
    /**
	 * Generated serial version ID
	 */
	private static final long serialVersionUID = 5103024387214396133L;

//	/**
//	 * Error values
//	 */
//	public static enum ERROR {
//	  SUCCESS,
//
//	  INVALID_HANDLE,
//	  DEVICE_NOT_FOUND,
//	  DEVICE_NOT_OPENED,
//	  COM_IO,
//	  INSUFFICIENT_RESOURCES,
//	  INVALID_PARAMETER,
//	  INVALID_BAUD_RATE,
//
//	  DEVICE_NOT_OPENED_FOR_ERASE,
//	  DEVICE_NOT_OPENED_FOR_WRITE,
//	  FAILED_TO_WRITE_DEVICE,
//	  EEPROM_READ_FAILED,
//	  EEPROM_WRITE_FAILED,
//	  EEPROM_ERASE_FAILED,
//	  EEPROM_NOT_PRESENT,
//	  EEPROM_NOT_PROGRAMMED,
//
//	  INVALID_ARGS,
//	  NOT_SUPPORTED,
//	  UNDEFINED,
//
//	  COM_LOST,
//	  COM_TIMEOUT,
//	  TX_CMD_FAILED,
//	  EXEC_CMD_FAILED,
//
//	  FW_NOT_OPENED,
//	  FW_READ_FAILED,
//	  FW_INVALID_FILE,
//	  FW_FILE_CORRUPTED,
//	  FW_NOT_SUPPORTED
//	};
	
	public VisualCubeException()
    {
    }

    public VisualCubeException(String msg)
    {
        super(msg);
    }

}
