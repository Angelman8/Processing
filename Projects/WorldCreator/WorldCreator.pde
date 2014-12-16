//Default Values
float noiseScale = .0125;
float contrast = 1.4;
float maxThreshold = 110;
float xCompression = 1.0;
float yCompression = 2.1;
float dropoff = 5.0;

World world;

boolean drawGrid = true;
int gridSize = 80;
color gridColour = color(255, 30);

void setup() {
  println("Beginning Setup...");
  size(1200, 700);
  background(0);
  noStroke();
  
  GenerateWorld();
  println("Setup Complete.");
}

void keyPressed() {
  if (key == 'g') {
    GenerateWorld();
  }
  if (key == '1') {
    world.elevation.Draw();
  }
  if (key == '2') {
    world.land.Draw();
  }
//  if (key == '3') {
//    world.continents.Draw();
//  }
  if (key == '4') {
    world.water.Draw();
  }
}

void GenerateWorld() {
  world = new World(noiseScale, maxThreshold, contrast, xCompression, yCompression, dropoff);
  world.land.Draw();
}

void draw() {
}

void DrawMap(int[][] map, color[] colours) {
  background(0);
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      stroke(colours[map[x][y]]);
      rect(x, y, 1, 1);
    }
  }
  if (drawGrid) {
    DrawGrid();
  }
}

void DrawGrid() {
  stroke(gridColour);
  for (int x = 0; x < width/gridSize; x++) {
    line (x * gridSize, 0, x * gridSize, height);
  }
  for (int y = 0; y < height/gridSize; y++) {
    line (0, y * gridSize, width, y * gridSize);
  }
}

