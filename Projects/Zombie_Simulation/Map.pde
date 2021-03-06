void generateGrid() {
  int q;
  Node n2;
  for ( int ix = 0; ix < width/gridSize; ix+=1 ) {
    for ( int iy = 0; iy < height/gridSize; iy+=1) {
      grid[iy][ix] = -1;
      nodes.add(new Node(ix*gridSize, iy*gridSize));
      grid[iy][ix] = nodes.size()-1;

      if (map[iy][ix] != 1 && map[iy][ix] != 4)
      {
        if (ix>0) {
          if (grid[iy][ix-1] != 1 && map[iy][ix-1] != 4) {
            n2 = (Node)nodes.get(nodes.size()-1);
            float cost = random(0, 0);
            n2.addNbor((Node)nodes.get(grid[iy][ix-1]), cost);
            ((Node)nodes.get(grid[iy][ix-1])).addNbor(n2, cost);
          }
        }
        if (iy>0) {
          if (grid[iy-1][ix] != 1 && map[iy-1][ix] != 4) {
            n2 = (Node)nodes.get(nodes.size()-1);
            float cost = random(0, 0);
            n2.addNbor((Node)nodes.get(grid[iy-1][ix]), cost); 
            ((Node)nodes.get(grid[iy-1][ix])).addNbor(n2, cost);
          }
        }
      }
    }
  }
}

void generateMap()
{
    map = new int[][] {
   { 0,5,4,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,4,5,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,5,0,0,0},
   { 0,0,5,0,5,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,5,0,5,0,0,0,0,0,0,0,0,0,0,0,5,4,5,0,0,0,0,0,0,0,0,0,0,0,0,0},
   { 0,0,0,5,4,5,0,0,0,5,0,0,0,0,0,5,4,5,0,0,0,5,4,5,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,5,0,0,0,0,0,0,0,0},
   { 0,0,0,0,5,0,0,0,5,4,5,0,0,0,0,0,5,0,0,3,3,3,5,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,5,4,5,0,0,0,0,0,0,0},
   { 0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,5,4,3,3,3,0,0,0,0,0,5,4,5,0,0,0,0,0,5,0,0,0,0,5,0,0,0,5,0,0,0,0},
   { 0,0,0,0,1,1,1,1,1,1,1,1,1,0,1,1,0,0,0,5,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,5,4,5,0,0,0,0,0,0,5,4,5,0,0,5},
   { 0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,5,0,0,5,4},
   { 0,0,0,0,0,0,2,2,2,2,0,1,2,2,0,1,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,5},
   { 0,0,0,0,1,0,2,2,2,2,0,1,0,0,0,1,0,0,0,0,5,4,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,4,5,0,0,0,0,0,0,0,0},
   { 0,0,0,0,1,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0},
   { 0,0,0,0,1,1,1,1,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
   { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
   { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,5,4,5,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0},
   { 0,4,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,1,0,2,2,2,2,2,0,1,0,0,0,5,0,0,0,0,0,5,4,5,0,0,0,0,0,0,0,0,0,0,0},
   { 0,0,0,0,3,3,0,0,0,5,4,5,0,0,0,0,0,0,1,0,2,2,2,2,2,0,1,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0},
   { 0,0,0,3,3,3,0,0,0,0,5,0,0,0,0,0,0,0,1,0,2,2,2,2,2,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
   { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
   { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,1,1,1,1,1,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
   { 1,1,1,1,1,1,1,1,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,4,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
   { 1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
   { 1,0,2,2,2,2,0,2,2,2,2,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,4,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0},
   { 1,0,2,2,2,2,2,2,2,2,2,0,1,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,5,4,5},
   { 1,0,0,0,0,0,2,2,2,2,2,0,1,0,0,0,0,0,0,0,5,4,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,4,5,0,0,0,0,5,0},
   { 1,1,0,1,1,0,2,2,2,0,0,0,1,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,5,4,5},
   { 0,0,0,0,1,1,1,1,1,1,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0},
   { 0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,5,0,0,0,0,0},
   { 0,0,0,0,1,0,2,2,2,2,2,0,1,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,5,4,5,0,0,0,0,0,5,4,5,0,0,0,0},
   { 0,0,0,0,1,0,2,2,2,2,2,0,1,0,0,0,0,0,0,0,0,0,0,5,4,5,0,0,0,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0,5,0,0,0,0,0},
   { 0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,5,4,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
   { 0,0,0,0,1,1,0,1,1,1,1,1,1,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
   { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,4,5,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,1,1,1,1,1,0,0,0,0,0,0},
   { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0},
   { 0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,2,2,2,2,2,2,2,2,0,0,0,0,0,0,0,0},
   { 0,0,0,5,4,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,2,2,2,1,2,2,0,1,0,0,0,0,0,0},
   { 0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,2,2,0,0,0,0,0,1,0,0,0,0,0,0},
   { 0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,2,2,0,1,1,1,1,1,0,0,0,0,0,0},
   { 0,0,0,0,0,0,5,4,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0},
   { 0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,1,0,0,0,0,0,0,0,0,0,0},
   { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
   { 0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,1,1,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
   { 0,0,0,0,5,4,5,0,0,0,0,0,0,5,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
   { 0,5,0,0,0,5,0,0,0,0,0,0,0,4,5,0,1,0,2,2,2,2,2,2,2,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
   { 0,4,0,0,0,0,0,0,0,0,0,0,0,5,0,0,1,0,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
   { 0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,1,0,2,2,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
   { 0,0,0,0,5,4,5,0,5,0,0,0,0,0,0,0,1,0,0,0,0,1,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3,0,0,0,0},
   { 0,0,0,0,0,5,0,5,4,5,0,0,0,0,0,0,1,1,1,1,0,1,5,4,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3,3,3,3,0,0},
   { 0,5,0,0,0,0,0,0,5,0,0,0,0,0,0,0,5,4,5,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3,3,3,3,0,0,0},
   { 5,4,5,0,0,0,0,0,0,0,0,5,0,0,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3,3,3,0,0,0,0,0},
   { 0,5,0,5,0,0,0,0,0,0,5,4,5,0,0,0,0,0,0,0,5,4,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0},
   { 0,0,5,4,5,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0} };
}

