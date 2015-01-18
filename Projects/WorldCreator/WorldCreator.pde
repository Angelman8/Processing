import java.util.Map;

//Default Values
float noiseScale = .013;
float contrast = 1.4;
float maxThreshold = 110;
float xCompression = 0.5;
float yCompression = 1.25;
float dropoff = 5.0;

World world;

int civNum = 100;
int pixelSize = 4;
int gridSize = 280;
boolean drawGrid = true;
color gridColour = color(255, 30);

void setup() {
  println("Beginning Setup...");
  size(1400, 900);
  background(0);
  noStroke();

  GenerateWorld();
  println("Setup Complete.");
}

void keyPressed() {
  if (key == 'c') {
    world.result.Draw();
  }
  if (key == 'C') {
    DrawCivilizations();
  }
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
  DrawCivilizations();
}

void draw() {
  if (mousePressed == true) {
    DrawZoom(world.result, mouseX, mouseY, pixelSize);
  }
}

void mouseReleased() {
    world.result.Draw();
  DrawCivilizations();
}

void DrawCivilizations() {
  for( int i = 0; i < world.civilizations.size(); i++) {
    Civilization civilization = world.civilizations.get(i);
    ellipseMode(CENTER);
    fill(255, 0, 0);
    ellipse(civilization.x, civilization.y, civilization.size, civilization.size);
  }
}

void DrawZoom(Map map, int inputX, int inputY, int magnification) {
  int counterX = 0;
  int counterY = 0;
  for (int x = inputX - (int)(gridSize / pixelSize / pixelSize); x < inputX + (int)(gridSize / pixelSize / pixelSize); x++) {
    for (int y = inputY - (int)(gridSize / pixelSize / pixelSize); y < inputY + (int)(gridSize / pixelSize / pixelSize); y++) {
      if (Valid(x, y)) {
        fill(map(map.data[x][y], map.min, map.max, 0, 255));
      } else {
        fill(0);
      }
      rect(counterX * pixelSize * magnification, counterY * pixelSize * magnification, pixelSize * magnification, pixelSize * magnification);
      counterY++;
    }
    counterY = 0;
    counterX++;
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

