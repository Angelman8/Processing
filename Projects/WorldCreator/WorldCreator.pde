import java.util.Map;

//Default Values
float noiseScale = .013;
float contrast = 1.4;
float maxThreshold = 110;
float xCompression = 0.5;
float yCompression = 1.25;
float dropoff = 5.0;

World world;

float pixelSize = 1;
int gridSize = 140;
boolean drawGrid = true;
color gridColour = color(255, 30);

void setup() {
  println("Beginning Setup...");
  size(1400, 700);
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
    world.result.Draw();
  }
  if (key == '2') {
    world.land.Draw();
  }
  if (key == '3') {
    world.continents.Draw();
    world.PrintContinents();
  }
  if (key == '4') {
    world.water.Draw();
  }
  if (key == '5') {
    world.elevation.Draw();
  }
}

void GenerateWorld() {
  world = new World(noiseScale, maxThreshold, contrast, xCompression, yCompression, dropoff);
  world.result.Draw();
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

