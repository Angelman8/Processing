class Map {

  int[][] data;
  color[] colours;
  float max = -9999;
  float min = 99999;

  Map() {
    data = new int[width][height];
    colours = new color[0];
  }
  
  Map Copy() {
    Map newMap = new Map();
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        newMap.data[x][y] = data[x][y];
      }
    }
    for(int i = 0; i < colours.length; i++) {
        newMap.colours[i] = colours[i];
    }
    newMap.max = max;
    newMap.min = min;
    return newMap;
  }
  
  Map Apply(Map map, float strength) {
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        data[x][y] += map.data[x][y] * strength;
        SetMinMax(data[x][y]);
      }
    }
    return this;
  }
  
  Map Mask(Map map, int keyValue) {
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        if (map.data[x][y] == keyValue) {
          data[x][y] = (int)min;
          SetMinMax(data[x][y]);
        }
      }
    }
    return this;
  }
  
  Map Fade(int value) {
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        data[x][y] -= value;
        SetMinMax(data[x][y]);
      }
    }
    return this;
  }
  
  Map Randomize(int min, int max) {
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        data[x][y] += (int)random(min, max);
        SetMinMax(data[x][y]);
      }
    }
    return this;
  }
  
  Map Flip() {
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        data[x][y] = -data[x][y];
        SetMinMax(data[x][y]);
      }
    }
    return this;
  }
  
  Map Amplify(float value) {
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        data[x][y] *= value;
        SetMinMax(data[x][y]);
      }
    }
    return this;
  }
  
  Map ContrastMountains(float threshold, float multiply) {
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        if (data[x][y] > threshold) {
          data[x][y] = (int)(data[x][y] + (data[x][y] - threshold) * multiply);
          SetMinMax(data[x][y]);
        }
      }
    }
    return this;
  }
  
  void Draw() {
    background(0);
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        
        stroke(map(data[x][y], min, max, 0, 255));
        rect(x, y, 1, 1);
      }
    }
    if (drawGrid) {
      DrawGrid();
    }
  }

  void SetMinMax(int n) {
    this.max = (n > this.max) ? n : this.max;
    this.min = (n < this.min) ? n : this.min;
  }
}

