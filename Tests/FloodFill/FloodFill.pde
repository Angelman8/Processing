int pixelSize = 1;
int mapSize = 800;
int colorSaturation = 10;
int replacementColourMaster = 2;
int[][] land;

color[] colours;

void setup() {
  size(pixelSize * mapSize, pixelSize * mapSize);
  noStroke();
  land = new int[mapSize * pixelSize][mapSize * pixelSize];
  for(int y = 0; y < mapSize; y++) {
    for(int x = 0; x < mapSize; x++) {
      land[x][y] = (int)random(0,2);
    }
  }
  colours = new color[3];
  colours[0] = color(0,0,0);
  colours[1] = color(50,50,50);
  colours[2] = GetRandomColour();
  
  Draw(land);
}

void draw() {
}

void keyPressed()
{
  background(0);
  
  land = new int[mapSize * pixelSize][mapSize * pixelSize];
  for(int y = 0; y < mapSize; y++) {
    for(int x = 0; x < mapSize; x++) {
      land[x][y] = (int)random(0,2);
    }
  }
  
  replacementColourMaster = 2;
  colours = new color[3];
  colours[0] = color(0,0,0);
  colours[1] = color(50,50,50);
  colours[2] = GetRandomColour();
  
  int x = 0;
  int y = 0;
  while (y < mapSize) {
    while (x < mapSize) {
      land = FloodFromPoint(x, y, 1, replacementColourMaster, land);
      x++;
    }
    x = 0;
    y++;
  }
  Draw(land);
}

void Draw(int[][] map) {
  int count = 0;
  for(int y = 0; y < mapSize; y++) {
    for(int x = 0; x < mapSize; x++) {
      fill(colours[map[x][y]]);
      rect(x * pixelSize, y * pixelSize, pixelSize, pixelSize);
      fill(255, 150);
      //text(map[x][y],  x * pixelSize + pixelSize/2, y * pixelSize + pixelSize/2.8);
      count++;
    }
  }
}

int[][] FloodFromPoint(int x, int y, int targetColour, int replacementColour, int[][] map) {
  //println("Setting Start Node: (" + x + ", " + y + ")");
  if (map[x][y] != targetColour) {
    return map;
  }
  ArrayList Q = new ArrayList();
  //println("Target Colour Found. Filling with Replacement Colour " + replacementColour + "...");
  Q.add(new PVector(x,y));
  while(Q.size() > 0) {
    PVector N = (PVector)Q.get(Q.size()-1);
    //println("Checking Node: (" + N.x + ", " + N.y + ")");
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
  replacementColourMaster++;
  colours = append(colours, GetRandomColour());
  //println("Flood Fill Ended.");
  return map;
}

boolean Valid(int x, int y) {
  if ( x < 0 || x >= mapSize || y < 0 || y >= mapSize ) {
    return false;
  } else {
    return true;
  }
}

color GetRandomColour() {
  return color((int)random(0,255),(int)random(0,255),(int)random(0,255));
}
