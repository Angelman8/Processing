int tileSize = 1;

//Noise
float noiseScale = .013;
float contrast = 1.4;
float maxThreshold = 150;
float xCompression = 0.5;
float yCompression = 1.3;
float dropoff = 20.0;

Tile[][] map;

void setup() {
  size(1200, 900);
  noStroke();

  InitializeMap();
  GenerateMap();
  DrawLand();
}

void draw() {
}

void keyPressed() {
  if (key == 'g') {
    GenerateMap();
    DrawLand();
  }
}

boolean Valid(int x, int y) {
  if ( x < 0 || x >= width/tileSize || y < 0 || y >= height/tileSize ) {
    return false;
  } else {
    return true;
  }
}

