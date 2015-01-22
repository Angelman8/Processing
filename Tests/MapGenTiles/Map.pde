void DrawLand() {
  for (int x = 0; x < width/tileSize; x++) {
    for (int y = 0; y < height/tileSize; y++) {
      if (map[x][y].isLand()) {
        fill(255);
      } 
      else {
        fill(0);
      }

      rect(x * tileSize, y * tileSize, tileSize, tileSize);
    }
  }
}

void DrawElevation() {
  for (int x = 0; x < width/tileSize; x++) {
    for (int y = 0; y < height/tileSize; y++) {
      if (map[x][y].isLand()) {
        fill(map[x][y].elevation);
      } 
      else {
        fill(0);
      }

      rect(x * tileSize, y * tileSize, tileSize, tileSize);
    }
  }
}

void InitializeMap() {
  map = new Tile[width/tileSize][height/tileSize];

  for (int x = 0; x < width/tileSize; x++) {
    for (int y = 0; y < height/tileSize; y++) {
      map[x][y] = new Tile(x, y);
    }
  }
}

void GenerateMap() {
  noiseSeed((long)random(0, 1000000));
  for (int x = 0; x < width/tileSize; x++) {
    for (int y = 0; y < height/tileSize; y++) {
      map[x][y].Clear();
      map[x][y].landHeight += map[x][y].AddNoise(1, .015, 1.4, 0.8, 1.2, 3.0);
      map[x][y].landHeight += map[x][y].AddNoise(.4, .003, 1.4, 1.4, 1.4, 4.0);
      map[x][y].landHeight += map[x][y].AddNoise(.3, .004, 1.2, 1.5, 1.5, 10.0);
      map[x][y].landHeight -= map[x][y].AddGaussian(.01);
    }
  }

  noiseSeed((long)random(0, 1000000));
  for (int x = 0; x < width/tileSize; x++) {
    for (int y = 0; y < height/tileSize; y++) {
      map[x][y].elevation = map[x][y].landHeight;
      map[x][y].elevation += map[x][y].AddNoise(.3, .09, 20.4, 1.2, 1.2, 15.0);
      map[x][y].elevation += map[x][y].AddNoise(.5, .05, 20.9, 1.0, 1.0, 15.0);
      map[x][y].elevation += map[x][y].AddNoise(2.9, .02, 50.5, 1.5, 1.5, 10.0);
      map[x][y].elevation += map[x][y].AddNoise(3.2, .008, 1000.8, 1.2, 1.2, 8.0);

      min = map[x][y].elevation < min ? map[x][y].elevation : min;
      max = map[x][y].elevation > max ? map[x][y].elevation : max;
    }
  }
  NormalizeElevation(0, 255);
//  int count = 0;
//  while (count < rainCount) {
//    Rain((int)(width/2 + randomGaussian() * rainSpread), (int)(height/2 + randomGaussian() * rainSpread));
//    count++;
//  }
}

void NormalizeElevation(int minimum, int maximum) {
  for (int x = 0; x < width/tileSize; x++) {
    for (int y = 0; y < height/tileSize; y++) {
      map[x][y].elevation = (int)map(map[x][y].elevation, min, max, minimum, maximum);
    }
  }
}

void Rain(int startX, int startY) {
  if (!Valid(startX, startY)) {
    return;
  }
  int stepsTaken = 0;
  while (stepsTaken < rainDistance) {
    if (map[startX][startY].isWater) {
      return;
    }
    float lowest = map[startX][startY].elevation;
    int lowestX = startX;
    int lowestY = startY;
    for (int x = startX - 1; x <= startX + 1; x++) {
      for (int y = startY - 1; y <= startY + 1; y++) {
        if (Valid(x, y)) {
          if (map[x][y].elevation < lowest && map[x][y].isLand()) {
            lowest = map[x][y].elevation;
            lowestX = x;
            lowestY = y;
          }
        }
      }
    }
    if (abs(lowest - map[startX][startY].elevation) < .05) {
      return;
    }
    map[startX][startY].elevation -= erosionFactor;
    startX = lowestX;
    startY = lowestY;
    stepsTaken++;
  }
}

