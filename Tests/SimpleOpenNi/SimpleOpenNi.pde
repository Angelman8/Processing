import SimpleOpenNI.*;

SimpleOpenNI context;

int steps = 3;


void setup() {
  size(640, 480);

  context = new SimpleOpenNI(this);
  context.setMirror(true);
  context.enableDepth();
  context.alternativeViewPointDepthToImage();
}

void draw() {
  background(0);
  context.update();
  int highestPoint, lowestPoint = 0;
  int[]   depthMap = context.depthMap();
  PVector[] realWorldMap = context.depthMapRealWorld();
  for (int y=0; y < context.depthHeight (); y+=steps) {
    for (int x=0; x < context.depthWidth (); x+=steps) {
      int index = x + y * context.depthWidth();
      
      if (depthMap[index] > 0) {
        stroke(depthMap[index]/10);
        rect(x, y, 1, 1);
      }
    }
  }
}

void keyPressed() {
}

