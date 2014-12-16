class Map {

  int[][] data;
  color[] colours;
  float max = -9999;
  float min = 99999;

  Map() {
    data = new int[width][height];
  }

  void Draw() {
    background(0);
    println("Drawing Map...");
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        
        if (x == width/2)
          println(data[x][y], min, max, map(data[x][y], min, max, 0, 255));
        stroke(map(data[x][y], min, max, 0, 255));
        rect(x, y, 1, 1);
      }
    }
    if (drawGrid) {
      DrawGrid();
    }
    println("Drawing Complete.");
  }

  Map GetNoise(float noiseScale, float contrast, float xCompression, float yCompression, float dropoff) {
    println("Creating Noise Map...");
    noiseSeed((long)random(0, 1000000));
    Map newMap = new Map();
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        float n = noise(x * noiseScale, y * noiseScale) * contrast;
        newMap.data[x][y] = (int)(n * 255 - (abs(dist(x * xCompression, y * yCompression, width/2 * xCompression, height/2 * yCompression)) / dropoff));
      }
    }
    println("Noise Map Complete.");
    return newMap;
  }

  void SetMinMax(int n) {
    this.max = (n > this.max) ? n : this.max;
    this.min = (n < this.min) ? n : this.min;
  }
}

