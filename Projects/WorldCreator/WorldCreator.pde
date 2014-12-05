float noiseScale = .014;
float maxThreshold = 75;
float dropoff = 4.5;
int continentThreshold = 1000;

boolean drawGrid = false;
int gridSize = 10;
color gridColour = color(255, 30);

int i, j;
int[][] landMap;
int[][] heightMap;
int[][] regionMap;
int[][] checkedMap;
int[][] currentMap;
color[] currentColours;
color[] regionColours;
int regionCount = 2;
int fillCount = 0;

void setup() {
  size(1200, 700);
  background(0);
  noStroke();
  regionColours = new color[3];
  regionColours[0] = color(0);
  regionColours[1] = color(255);
  regionColours[2] = GetRandomColour();

  heightMap = new int[width][height];
  
  currentMap = regionMap;
  currentColours = regionColours;
  
  GenerateWorld();
}

void keyPressed() {
  if (key == 'g') {
    GenerateWorld();
  }
  if (key == '1') {
    currentMap = landMap;
    currentColours = regionColours;
  }
  if (key == '2') {
    currentMap = regionMap;
    currentColours = regionColours;
  }
  if (key == '3') {
    currentMap = heightMap;
    currentColours = new color[1000];
    for(int i = 0; i < currentColours.length - 1; i++) {
      int c = ((int)(i * 0.8) > 255) ? 255 : (int)(i * 0.8);
      c = ((int)(i * 0.8) > 80) ? c + (c - 100) : c - (100 - c);
      currentColours[i] = color(c, c ,c);
    }
  }
  DrawMap(currentMap, currentColours);
}

void GenerateWorld() {
  long rand = (long)random(0, 1000000);
  landMap = GenerateMap(rand, heightMap);
  regionMap = GetRegions(GenerateMap(rand, heightMap));
  currentMap = regionMap;
  currentColours = regionColours;
  DrawMap(currentMap, currentColours);
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

