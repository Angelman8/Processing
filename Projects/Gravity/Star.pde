class Star {

  float x, y;
  float diameter;
  float vx = 0;
  float vy = 0;
  int id;
  Star[] others;

  Star(float xin, float yin, float din, int idin, Star[] oin) {
    x = xin;
    y = yin;
    diameter = din;
    id = idin;
    others = oin;
  } 

  void collide() {
    for (int i = id + 1; i < numstars; i++) {
      float dx = others[i].x - x;
      float dy = others[i].y - y;
      float distance = sqrt(dx*dx + dy*dy);
      
      //PVector min = minDistance(others[i]);
      float minDist = (others[i].diameter/2 + diameter/2) * gravityWell * diameter;
        println(isInfluenced(others[i], minDist));
      if (distance < minDist) { 
        float angle = atan2(dy, dx);
        float targetX = x + cos(angle) * minDist;
        float targetY = y + sin(angle) * minDist;
        float ax = (targetX - others[i].x) * spring;
        float ay = (targetY - others[i].y) * spring;
        vx -= ax;
        vy -= ay;
        others[i].vx += ax;
        others[i].vy += ay;
      }
    }
  }

  void move() {
    vy += gravity;
    x -= vx;
    y -= vy;
  }

  void pacman() {
    if (x > width)
      x = 0;
    else if (x < 0)
      x = width;
    if (y > height)
      y = 0;
    else if (y < 0)
      y = height;
  } 

  void display() {
    ellipse(x, y, diameter, diameter);
  }

  boolean isInfluenced(Star other, float tempDistance) {
    return true;
  }
}

