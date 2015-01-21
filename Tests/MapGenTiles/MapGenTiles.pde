int tileSize = 1;

int waterLevel = 150;
float erosionFactor = 0.2;
int rainDistance = 3;
int rainSpread = 300;
int rainCount = 5000000;

float min = 9999999;
float max = -9999999;

Tile[][] map;

void setup() {
  size(1200, 900);
  noStroke();

  InitializeMap();
  GenerateMap();
  DrawElevation();
}

void draw() {
}

void keyPressed() {
  if (key == 'g') {
    GenerateMap();
    DrawElevation();
  }
}

void mousePressed() {
  println("Land Elevation: " + map[mouseX][mouseY].elevation);
}

boolean Valid(int x, int y) {
  if ( x < 0 || x >= width/tileSize || y < 0 || y >= height/tileSize ) {
    return false;
  } 
  else {
    return true;
  }
}

