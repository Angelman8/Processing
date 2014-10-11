import org.openkinect.*;
import org.openkinect.processing.tests.*;
import org.openkinect.processing.*;

Kinect kinect;
boolean depth = false;
boolean rgb = false;
boolean ir = true;

float deg = 0; // Start at 15 degrees

void setup() {
  size(1280,520);
  kinect = new Kinect(this);
  kinect.start();
  kinect.enableDepth(depth);
  kinect.enableRGB(rgb);
  kinect.enableIR(ir);
  kinect.tilt(deg);
}


void draw() {
  background(0);

  image(kinect.getVideoImage(),0,0);
  image(kinect.getDepthImage(),640,0);
  fill(255);
}

void keyPressed() {
  if (key == 'd') {
    depth = !depth;
    kinect.enableDepth(depth);
  } 
  else if (key == 'r') {
    rgb = !rgb;
    if (rgb) ir = false;
    kinect.enableRGB(rgb);
  }
  else if (key == 'i') {
    ir = !ir;
    if (ir) rgb = false;
    kinect.enableIR(ir);
  } 
  else if (key == CODED) {
    if (keyCode == UP) {
      deg++;
    } 
    else if (keyCode == DOWN) {
      deg--;
    }
    deg = constrain(deg,-30,30);
    kinect.tilt(deg);
  }
}
void stop() {
  kinect.quit();
  super.stop();
}
