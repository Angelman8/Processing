float noiseScale = .020;
float maxThreshold = 80;
float dropoff = 2.9;
int maxColours = 100;
int continentThreshold = 1000;

boolean drawGrid = true;
int gridSize = 100;
color gridColour = color(255, 150);

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
  size(600, 600);
  background(0);
  noStroke();
  regionColours = new color[maxColours];
  regionColours[0] = color(0);
  regionColours[1] = color(255);
  for (int i = 2; i < regionColours.length; i++) {
    regionColours[i] = color(random(0, 255), random(0, 255), random(0, 255));
  }

  long rand = (long)random(0, 1000000);
  heightMap = new int[width][height];
  landMap = GenerateMap(rand, heightMap);
  regionMap = Fill(GenerateMap(rand, heightMap));
  GetContinents(regionMap);
  currentMap = landMap;
  DrawMap(currentMap);
}

void keyPressed() {
  if (key == 'g') {
    long rand = (long)random(0, 1000000);
    landMap = GenerateMap(rand, heightMap);
    regionMap = Fill(GenerateMap(rand, heightMap));
    currentMap = landMap;
    GetContinents(regionMap);
    DrawMap(currentMap);
  }
  if (key == '1') {
    currentMap = landMap;
  }
  if (key == '2') {
    currentMap = regionMap;
  }
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

void GetContinents(int[][] map) {
  ArrayList numContinents = new ArrayList();
  int[] continentSize = new int[100];
  int islands = 0;
  int continents = 0;
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      if (map[x][y] != 1) {
        if (!numContinents.contains(map[x][y]) && map[x][y] != 0) {
          numContinents.add(map[x][y]);
          continentSize[map[x][y]] = 1;
        } 
        else {
          continentSize[map[x][y]] += 1;
        }
      }
    }
  }
  for (int i = 0; i < continentSize.length; i++) {
    if (continentSize[i] > 0 && continentSize[i] < continentThreshold) {
      islands++;
    } 
    else if (continentSize[i] > continentThreshold) {
      continents++;
    }
  }
  println("================================");
  println("There are " + numContinents.size() + " land masses in this map.");
  println("There are " + (continents - 1) + " continents in this map.");
  println("There are " + islands + " islands in this map.");
  println("================================");
}

int[][] Fill(int[][] map) {
  checkedMap = new int[width][height];
  regionCount = 2;
  int x = 0;
  int y = 0;
  while (!isFilled (checkedMap)) {
    fillCount = 0;
    for (int i = 0; i < 10; i++) {
      Flood(x, y, 1, regionCount, map);
      if (x > width) {
        x = 0;
        y++;
      } 
      else {
        x++;
      }
      if (regionCount > 1)
        regionCount = 2;
      else 
        regionCount++;
    }
  }
  return map;
}

void Flood(int x, int y, int oldThreshold, int newThreshold, int[][] map) {
  if (x >= 0 && x < width && y >= 0  && y < height && checkedMap[x][y] != 1) {
    checkedMap[x][y] = 1;
    fillCount++;
    if (map[x][y] != oldThreshold || fillCount > 100) {
      return;
    }
    map[x][y] = newThreshold;
    Flood(x + 1, y, oldThreshold, newThreshold, map);
    Flood(x - 1, y, oldThreshold, newThreshold, map);
    Flood(x, y + 1, oldThreshold, newThreshold, map);
    Flood(x, y - 1, oldThreshold, newThreshold, map);
  } 
  else {
    return;
  }
}

boolean isFilled(int[][] map) {
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      if (map[x][y] == 0) {
        return false;
      }
    }
  }
  return true;
}

