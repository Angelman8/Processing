class Tile {
  int x;
  int y;
  float landHeight;

  Tile(int _x, int _y) {
    x = _x;
    y = _y;
  }

  void AddNoise(float strength, float noiseScale, float contrast, float xCompression, float yCompression, float dropoff) {
    float n = noise(x * noiseScale, y * noiseScale) * contrast;
    this.landHeight += (int)(n * 255 - (abs(dist(x * xCompression, y * yCompression, width/2 * xCompression, height/2 * yCompression)) / dropoff)) * strength;
  }
  
  void AddGaussian(float strength) {
    this.landHeight += abs(dist(x, y, width/2, height/2)) * strength;
  }
  
  void RemoveGaussian(float strength) {
    this.landHeight -= abs(dist(x, y, width/2, height/2)) * strength;
  }
  
  void Clear() {
    landHeight = 0;
  }
}

