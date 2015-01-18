void DrawLand() {
  for (int x = 0; x < width/tileSize; x++) {
    for (int y = 0; y < height/tileSize; y++) {
      if (map[x][y].landHeight > maxThreshold) {
        fill(255);
      } else {
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
      map[x][y].AddNoise(1, .014, 1.4, 0.5, 1.0, 3.0);
      map[x][y].AddNoise(.6, .004, 1.4, 1.5, 1.5, 6.0);
      map[x][y].RemoveGaussian(.03);
    }
  }
}

