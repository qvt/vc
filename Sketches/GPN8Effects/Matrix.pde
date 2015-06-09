//have fun!
//this code is public domaijn
import processing.visualcube1e3.*;

/**/class Matrix extends Effect {  //VisualCube cube = new VisualCube(this);

final int PARTICLESPERSTEP = 1;
final int TICKSPERSTEP = 5;
ArrayList particlelist = new ArrayList();

void setup() {
  cube.open("192.168.2.173"); 
  cube.clear();               
  cube.simulate(800, 800);
}

void addparticle() {
  particlelist.add(new int[] {int(random(10)), int(random(10)), 9}); // x, y, height
}

void draw() {
  int i, j, k;
  
  for (i = 0; i < 10; i++) {
    for (j = 0; j < 10; j++) {
      for (k = 0; k < 10; k++) {
        cube.set(i, j, k,
            ((int) (((float) cube.getRed(i, j, k))  - ((float) cube.getRed(i, j, k))  * 0.2)),
            ((int) (((float) cube.getGreen(i, j, k))  - ((float) cube.getGreen(i, j, k)) * 0.2)),
            ((int) (((float) cube.getBlue(i, j, k))  - ((float) cube.getBlue(i, j, k)) * 0.2))
    );
      }
    }
  }
  
  for (i = 0; i < PARTICLESPERSTEP; i++) addparticle();
  
  int deletionindex = particlelist.size();

  for (i = 0; i < particlelist.size(); i++) {
    int[] p = (int[]) particlelist.get(i);
    if (p[2] >= 0) cube.set(p[0], 9-p[2], p[1], 255, 255 ,255);
    if (p[2] < 9) cube.set(p[0], 9-(p[2]+1), p[1], 0, 255 ,0);
    if (p[2] > -1) deletionindex = i;
    p[2]--;
  }
  deletionindex++;
  while (deletionindex < particlelist.size()) particlelist.remove(deletionindex);
  
  cube.update();
}

void destroy() {
  cube.close(); 
}

/**/}