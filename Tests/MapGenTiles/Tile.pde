class Tile {
  int x;
  int y;
  int landHeight;
  float elevation;
  
  boolean isWater = false;

  boolean isLand() {
    if (landHeight > waterLevel) {
      return true;
    } 
    else {
      isWater = true;
      return false;
    }
  }

  Tile(int _x, int _y) {
    x = _x;
    y = _y;
  }

  int AddNoise(float strength, float noiseScale, float contrast, float xCompression, float yCompression, float dropoff) {
    float n = noise(x * noiseScale, y * noiseScale) * contrast;
    int value = (int)((n * (abs(dist(x * xCompression, y * yCompression, width/2 * xCompression, height/2 * yCompression)) / dropoff)) * strength);
    return value;
  }

  int AddGaussian(float strength) {
    int value = (int)(abs(dist(x, y, width/2, height/2)) * strength);
    return value;
  }

  void Clear() {
    landHeight = 0;
    elevation = 0;
  }
}

