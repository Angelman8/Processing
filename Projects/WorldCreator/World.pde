class World {
  boolean foundLandmass = false;
  Map result;
  Map land;
  Map water;
  Map elevation;
  Map gradient;
  Map continents;
  
  ArrayList<Continent> continentsList = new ArrayList<Continent>();

  color[] colours;

  World(float noiseScale, float maxThreshold, float contrast, float xCompression, float yCompression, float dropoff) {
    elevation = GetNoise(noiseScale, maxThreshold, contrast, xCompression, yCompression, dropoff);
    elevation.Apply(GetGradient(7), 0.9);
    land = GetLand(elevation.Copy(), (int)maxThreshold);
    continents = GetContinents(land.Copy());
    water = GetWater(land.Copy());
    result = new Map();
    result.Apply(land.Copy(), .5)
          .Apply(GetNoise(0.025, 80, 1.4, 1.0, 1.0, 5), 0.05)
          .Apply(GetNoise(0.05, 100, 1.4, 1.0, 1.0, 8), 0)
          .Apply(GetNoise(0.005, 80, 1.4, 1.0, 1.0, 8), 0)
          .Apply(elevation.Copy(), 0.08)
          .Randomize(0, 2)
          .Mask(land.Copy(), 0);
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
  
  Map GetGradient(float falloff) {
    println("Creating Gradient Map...");
    Map newMap = new Map();
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        float n = dist(x, y, width/2, height/2) / falloff;
        newMap.data[x][y] = (int) -n;
        newMap.SetMinMax(newMap.data[x][y]);
      }
    }
    println("Gradient Map Complete.");
    return newMap;
  }

  Map GetLand(Map inputMap, int threshold) {
    Map newMap = new Map();
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        newMap.data[x][y] = (inputMap.data[x][y] > threshold) ? 1 : 0;
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
          continentsList.add(new Continent());
          Continent continent = continentsList.get(continentsList.size()-1);
          continent.name = "Continent " + (continentsList.size()-1);
          for (int i = 0; i < width; i++) {
            for (int j = 0; j < height; j++) {
              if (newMap.data[i][j] == regionCount) {
                continent.AddData(i, j);
              }
            }
          }
          continent.AddData(x, y);
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
        newMap.data = Flood(x, y, 0, regionCount, inputMap.data);
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
    int[][] newMap;
    newMap = map;
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
  
  void PrintContinents() {
    for(int i = 0; i < continentsList.size()-1; i++) {
      Continent continent = continentsList.get(i);
      println(continent.name, continent.data.size());
    }
  }
}

