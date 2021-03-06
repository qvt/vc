# VisualCube1e3
This project contains sourcecode of a [PROCESSING](https://processing.org) library for programming the VisualCube1e3 device, as well as PROCESSING sketches, little programs that make use of the PROCESSING API extended by the library to generate beautiful animations on the cubical device.

The VisualCube is a large volumetric color display designed of a thousand light emitting diodes. The lights are equidistantly arranged in a cubical frame with an edge length of 275 centimeters, easily controllable via wireless LAN. On [visualcube.org](http://www.visualcube.org) you can find detailed information and supplemental material related to the visualcube1e3 device.

# Binaries
If you do not want to build the library manually from the sources, you can download the binaries at the cube's [download page](http://visualcube.org/1e3/?page_id=18). There are also instructions on how to install the library into PROCESSING.

# Compiling the Library
The library is maintained as an Eclipse Java project. We recommend to download the latest [Eclipse IDE for Java Developers](http://www.eclipse.org/downloads/). Checkout the project directly from this git repository.

To create the visualcube1e3.jar file, you can use Eclipse's exporting function, File > Export... > Jar File > Export generated class files and sources. You must ensure that target compatibility is set to the correct JVM compliance level under the project's properties page – level 1.6 for PROCESSING 1.x and 2.x, and level 1.7 or 1.8 for PROCESSING 3.x.

*Potential incompatibility risks in future releases:* There are two critical APIs used by the library, the PROCESSING API (core.jar), and the JOGL API (jogl*.jar). These two libraries were constantly changing in past releases of PROCESSING and should be expected to break again in future releases of PROCESSING. The XML-RPC API appears to be stable and is no longer maintained by the Apache Foundation.

# Developing Effects under Eclipse

Processing sketches are 95% valid Java code and can be run on a Java VM. Rather than using the PROCESSING Development Environment (PDE), you can use Eclipse for easier development and debugging of sketches and, of course, the VisualCube library.

To start, checkout the library provided as an Eclipse project into a freshly installed Eclipse IDE for Java development (File > Import... > Eclipse Project > Select archive...). The project already contains the Processing API core.jar and other libraries which come with PROCESSING (JOGL), plus the Apache XML-RPC library to access the cube as a network device.

Sketches which perfectly run in the PDE must be adjusted to real Java code before they run under the Eclipse IDE. For example, the whole code must be embedded into a class that inherits from PApplet. For details, see the example sketches that are included in the Eclipse project, and this tutorial.

# Used 3rd-Party Libraries
The sourcecode published here relies on the following third-party libraries:

* The PROCESSING API v3.0a9, which includes
* the Java OpenGL library (JOGL) v2.3.1, and additionally
* the Apache XML-RPC library v3.1.1 for communication with the device.

# License
The sourcecode published here is subject to the [GNU GPL license version three](http://www.gnu.org/licenses/gpl-3.0.en.html) and is free of charge.
