float noiseScale = .015;
float maxThreshold = 100;
float dropoff = 5;
int continentThreshold = 1000;

boolean drawGrid = true;
int gridSize = 10;
color gridColour = color(255, 50);

int i, j;
int[][] landMap;
int[][] heightMap;
int[][] regionMap;
int[][] checkedMap;
int[][] currentMap;
color[] regionColours;
int regionCount = 2;
int fillCount = 0;

void setup() {
  size(800, 800);
  background(0);
  noStroke();
  regionColours = new color[3];
  regionColours[0] = color(0);
  regionColours[1] = color(255);
  regionColours[2] = GetRandomColour();
  
  heightMap = new int[width][height];
  
  CreateNewMap();
}

void keyPressed() {
  if (key == 'g') {
    CreateNewMap();
  }
  if (key == '1') {
    currentMap = landMap;
  }
  if (key == '2') {
    currentMap = regionMap;
  }
  DrawMap(currentMap);
}

void CreateNewMap() {
    long rand = (long)random(0, 1000000);
    landMap = GenerateMap(rand, heightMap);
    regionMap = GetRegions(GenerateMap(rand, heightMap));
    currentMap = regionMap;
    DrawMap(currentMap);
}

void draw() {
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

void DrawMap(int[][] map) {
  background(0);
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      stroke(regionColours[map[x][y]]);
      rect(x, y, 1, 1);
    }
  }
  if (drawGrid) {
    DrawGrid();
  }
}

int[][] GenerateMap(long seed, int[][] heightM) {
  noiseSeed(seed);
  int[][] map = new int[width][height];
  //Generate Landmass
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      float n = noise(x * noiseScale, y * noiseScale);
      int threshold = (int)(n * 255 - (abs(dist(x, y, width/2, height/2)) / dropoff));
      if (threshold > maxThreshold) {
        heightM[x][y] = threshold;
        map[x][y] = 1;
      } 
      else {
        heightM[x][y] = 0;
        map[x][y] = 0;
      }
    }
  }
  return map;
}

