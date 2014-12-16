int[][] Clamp(int[][] inputMap, int min, int max) {
  int[][] newMap = new int[width][height];
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      newMap[x][y] = constrain(inputMap[x][y], min, max);
    }
  }
  return newMap;
}

boolean Valid(int x, int y) {
  if ( x < 0 || x >= width || y < 0 || y >= height ) {
    return false;
  } 
  else {
    return true;
  }
}
