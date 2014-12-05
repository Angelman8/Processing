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

int[][] GetRegions(int[][] map) {
  int x = 0;
  int y = 0;
  int[][] newMap = map;
  while(y < height) {
    while(x < width) {
      newMap = FloodFromPoint(x,y, 1, regionCount, map);
      x++;
    }
    x = 0;
    y++;
  }
  return newMap;
}
