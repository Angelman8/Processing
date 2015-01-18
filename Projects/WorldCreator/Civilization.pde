class Civilization {
  int x; 
  int y;
  int size;
  
  Civilization(int _x, int _y) {
    x = _x;
    y = _y;
    size = (int)(3 + 2 * randomGaussian());
  }
}
