class Continent {
  int index;
  String name = "";
  HashMap<String,PVector> data = new HashMap<String,PVector>();
  
  Continent() {
  }
  
  void AddData(int x, int y) {
    data.put("" + x + y, new PVector(x,y));
  }
}
