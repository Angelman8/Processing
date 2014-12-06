int[][] GenerateMap(long seed, int[][] heightM) {
  noiseSeed(seed);
  int[][] map = new int[width][height];
  //Generate Landmass
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      float n = noise(x * noiseScale, y * noiseScale);
      int threshold = (int)(n * 255 - (abs(dist(x * xCompression, y * yCompression, width/2 * xCompression, height/2 * yCompression)) / dropoff));
      if (threshold > maxThreshold) {
        heightM[x][y] = threshold;
        map[x][y] = 1;
      } 
      else {
        heightM[x][y] = (threshold >= 0) ? threshold : 0 ;
        map[x][y] = 0;
      }
    }
  }
  return map;
}

int[][] GetWater(int[][] map) {
  int x = 0;
  int y = 0;
  int[][] newMap = new int[width][height];
  while(y < height) {
    while(x < width) {
      newMap = Flood(x,y, 0, regionCount, map);
      x++;
    }
    x = 0;
    y++;
  }
  return newMap;
}

int[][] GetRegions(int[][] map) {
  int x = 0;
  int y = 0;
  int[][] newMap = map;
  while(y < height) {
    while(x < width) {
      newMap = Flood(x,y, 1, regionCount, map);
      x++;
    }
    x = 0;
    y++;
  }
  return newMap;
}
