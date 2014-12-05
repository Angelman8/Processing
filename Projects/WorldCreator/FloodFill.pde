int[][] FloodFromPoint(int x, int y, int targetColour, int replacementColour, int[][] map) {
  if (map[x][y] != targetColour) {
    return map;
  }
  ArrayList Q = new ArrayList();
  Q.add(new PVector(x,y));
  while(Q.size() > 0) {
    PVector N = (PVector)Q.get(Q.size()-1);
    Q.remove(Q.size()-1);
    if (map[(int)N.x][(int)N.y] == targetColour) {
      ArrayList weQ = new ArrayList();
      PVector w = N;
      PVector e = N;
      while (Valid((int)w.x, (int)w.y) && map[(int)w.x][(int)w.y] == targetColour) {
        weQ.add(w);
        w = new PVector(w.x - 1, w.y);
      }
      while (Valid((int)e.x, (int)e.y) && map[(int)e.x][(int)e.y] == targetColour) {
        weQ.add(e);
        e = new PVector(e.x + 1, e.y);
      }
      for(int j = weQ.size() - 1; j > 0; j--) {
        PVector n = (PVector)weQ.get(j);
        map[(int)n.x][(int)n.y] = replacementColour;
        if (Valid((int)n.x, (int)n.y - 1) && map[(int)n.x][(int)n.y - 1] == targetColour) {
          Q.add(new PVector(n.x, n.y - 1));
        }
        if (Valid((int)n.x, (int)n.y + 1) && map[(int)n.x][(int)n.y + 1] == targetColour) {
          Q.add(new PVector(n.x, n.y + 1));
        }
      }
    }
  }
  regionCount++;
  regionColours = append(regionColours, GetRandomColour());
  return map;
}




boolean Valid(int x, int y) {
  if ( x < 0 || x >= width || y < 0 || y >= height ) {
    return false;
  } else {
    return true;
  }
}



color GetRandomColour() {
  return color((int)random(0,255),(int)random(0,255),(int)random(0,255));
}
