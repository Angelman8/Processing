class Map {
  float noiseScale;
  float maxThreshold;
  float xCompression;
  float yCompression;
  float dropoff;

  int[][] land;
  int[][] water;
  int[][] elevation;
  int[][] continents;
  
  color[] colours;

  Map() {
    elevation = Clamp(GetNoise(0.0007, 95, 0.9, 1.5, 3), 0, 255);
  }

  int[][] GetNoise(float noiseScale, float maxThreshold, float xCompression, float yCompression, float dropoff) {
    println("Creating Noise Map...");
    int[][] newMap = new int[width][height];
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        float n = noise(x * noiseScale, y * noiseScale);
        if (x == 200)
          print(n + ", ");
        newMap[x][y] = (int)(n * 255 - (abs(dist(x * xCompression, y * yCompression, width/2 * xCompression, height/2 * yCompression)) / dropoff));
      }
    }
    println("Noise Map Complete.");
    return newMap;
  }

  int[][] GetLand(int[][] inputMap) {
    int[][] newMap = new int[width][height];
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        newMap[x][y] = (inputMap[x][y] > maxThreshold) ? 1 : 0;
      }
    }
    return newMap;
  }

  void Draw(int[][] inputMap) {
    println("Drawing Map...");
    background(0);
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        stroke(inputMap[x][y]);
        rect(x, y, 1, 1);
      }
    }
    if (drawGrid) {
      DrawGrid();
    }
    println("Drawing Complete.");
  }
}

