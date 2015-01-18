
void setup() {
  for (int i = 0; i < 3; i++) {
    LineGroup((int)random(0, width), (int)random(0, height), (int)random(2,4), 3 );
  }
}

void draw() {
}

void LineGroup(int x, int y, int numLines, int slope, int lineLength) {
    int b = -((slope * x) + y);
  for (int i = 0; i < numLines; i++) {
    line(x, y);
  }
}
