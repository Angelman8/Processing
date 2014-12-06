int[][] Flood(int x, int y, int target, int replacement, int[][] map) {
  if (map[x][y] != target) {
    return map;
  }
  ArrayList Q = new ArrayList();
  Q.add(new PVector(x, y));
  while (Q.size () > 0) {
    PVector N = (PVector)Q.get(Q.size()-1);
    Q.remove(Q.size()-1);
    if (map[(int)N.x][(int)N.y] == target) {
      ArrayList weQ = new ArrayList();
      PVector w = N;
      PVector e = N;
      while (Valid ( (int)w.x, (int)w.y) && map[(int)w.x][(int)w.y] == target) {
        weQ.add(w);
        w = new PVector(w.x - 1, w.y);
      }
      while (Valid ( (int)e.x, (int)e.y) && map[(int)e.x][(int)e.y] == target) {
        weQ.add(e);
        e = new PVector(e.x + 1, e.y);
      }
      for (int j = weQ.size() - 1; j > 0; j--) {
        PVector n = (PVector)weQ.get(j);
        map[(int)n.x][(int)n.y] = replacement;
        if (Valid((int)n.x, (int)n.y - 1) && map[(int)n.x][(int)n.y - 1] == target) {
          Q.add(new PVector(n.x, n.y - 1));
        }
        if (Valid((int)n.x, (int)n.y + 1) && map[(int)n.x][(int)n.y + 1] == target) {
          Q.add(new PVector(n.x, n.y + 1));
        }
      }
    }
  }
  regionCount++;
  regionColours = append(regionColours, GetRandomColour());
  return map;
}


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



color GetRandomColour() {
  return color((int)random(0, 255), (int)random(0, 255), (int)random(0, 255));
}

