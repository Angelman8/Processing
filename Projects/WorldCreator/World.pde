class World {
  boolean foundLandmass = false;

  Map land;
  Map water;
  Map elevation;
  Map continents;

  color[] colours;

  World(float noiseScale, float maxThreshold, float contrast, float xCompression, float yCompression, float dropoff) {
    elevation = new Map();
    elevation = GetElevation(noiseScale, maxThreshold, contrast, xCompression, yCompression, dropoff);
    land = GetLand(elevation);
    continents = GetContinents(land);
    //water = GetWater(land);
  }

  Map GetNoise(float noiseScale, float maxThreshold, float contrast, float xCompression, float yCompression, float dropoff) {
    println("Creating Noise Map...");
    noiseSeed((long)random(0, 1000000));
    Map newMap = new Map();
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        float n = noise(x * noiseScale, y * noiseScale) * contrast;
        newMap.data[x][y] = (int)(n * 255 - (abs(dist(x * xCompression, y * yCompression, width/2 * xCompression, height/2 * yCompression)) / dropoff));
        newMap.SetMinMax(newMap.data[x][y]);
      }
    }
    println("Noise Map Complete.");
    return newMap;
  }

  Map GetElevation(float noiseScale, float maxThreshold, float contrast, float xCompression, float yCompression, float dropoff) {
    Map newMap = new Map();
    newMap = GetNoise(noiseScale, maxThreshold, contrast, xCompression, yCompression, dropoff);
    return newMap;
  }

  Map GetLand(Map inputMap) {
    Map newMap = new Map();
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        newMap.data[x][y] = (inputMap.data[x][y] > maxThreshold) ? 1 : 0;
        newMap.SetMinMax((int)newMap.data[x][y]);
      }
    }
    return newMap;
  }

  Map GetContinents(Map inputMap) {
    Map newMap = new Map();
    int x = 0;
    int y = 0;
    int regionCount = 2;
    while (y < height) {
      while (x < width) {
        newMap.data = Flood(x, y, 1, regionCount, inputMap.data);
        newMap.SetMinMax((int)newMap.data[x][y]);
        if (foundLandmass) {
          regionCount++;
          foundLandmass = false;
        }
        x++;
      }
      x = 0;
      y++;
    }
    return newMap;
  }
  
  Map GetWater(Map inputMap) {
    Map newMap = new Map();
    int x = 0;
    int y = 0;
    int regionCount = 2;
    while (y < height) {
      while (x < width) {
        newMap.data = Flood(x, y, 1, regionCount, inputMap.data);
        if (x == 500)
          println(newMap.data[x][y], newMap.min, newMap.max, regionCount);
        if (foundLandmass) {
          regionCount++;
          foundLandmass = false;
        }
        newMap.SetMinMax((int)newMap.data[x][y]);
        x++;
      }
      x = 0;
      y++;
    }
    return newMap;
  }

  int[][] Flood(int x, int y, int target, int replacement, int[][] map) {
    int[][] newMap = map;
    if (newMap[x][y] != target) {
      foundLandmass = false;
      return newMap;
    }
    ArrayList Q = new ArrayList();
    Q.add(new PVector(x, y));
    while (Q.size () > 0) {
      PVector N = (PVector)Q.get(Q.size()-1);
      Q.remove(Q.size()-1);
      if (newMap[(int)N.x][(int)N.y] == target) {
        ArrayList weQ = new ArrayList();
        PVector w = N;
        PVector e = N;
        while (Valid ( (int)w.x, (int)w.y) && newMap[(int)w.x][(int)w.y] == target) {
          weQ.add(w);
          w = new PVector(w.x - 1, w.y);
        }
        while (Valid ( (int)e.x, (int)e.y) && newMap[(int)e.x][(int)e.y] == target) {
          weQ.add(e);
          e = new PVector(e.x + 1, e.y);
        }
        for (int j = weQ.size () - 1; j > 0; j--) {
          PVector n = (PVector)weQ.get(j);
          newMap[(int)n.x][(int)n.y] = replacement;
          if (Valid((int)n.x, (int)n.y - 1) && newMap[(int)n.x][(int)n.y - 1] == target) {
            Q.add(new PVector(n.x, n.y - 1));
          }
          if (Valid((int)n.x, (int)n.y + 1) && newMap[(int)n.x][(int)n.y + 1] == target) {
            Q.add(new PVector(n.x, n.y + 1));
          }
        }
      }
    }
    foundLandmass = true;
    return newMap;
  }
}

