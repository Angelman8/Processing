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

      //      float minDist = gravityWell * diameter;
      //      PVector d = isInfluenced(others[i], minDist);
      //      if (d != null) { 
      float dx = others[i].x - x;
      float dy = others[i].y - y;
      float distance = sqrt(dx*dx + dy*dy);
      float minDist = (others[i].diameter/2 + diameter/2) * gravityWell * diameter;
      if (distance < minDist) { 
        float angle = atan2(dy, dx);
        float targetX = x + cos(angle) * minDist;
        float targetY = y + sin(angle) * minDist;
        float ax = (targetX - others[i].x) * spring * gravityWell * .01;
        float ay = (targetY - others[i].y) * spring * gravityWell * .01;
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

  void display(color hue) {
    fill(hue);
    ellipse(x, y, diameter, diameter);
  }

  PVector isInfluenced(Star other, float minDist) {
    PVector pos = null;
    float distance;
    //Check regular distance
    pos = new PVector(other.x - x, other.y - y);
    distance = sqrt(pos.x * pos.x + pos.y * pos.y);
    if (distance < minDist)
      return pos;

    //    //Check -width
    //    pos = new PVector(other.x - width - x, other.y - y);
    //    distance = sqrt(pos.x * pos.x + pos.y * pos.y);
    //    if (distance < minDist)
    //      return pos;
    //
    //    //Check +width
    //    pos = new PVector(other.x + width - x, other.y - y);
    //    distance = sqrt(pos.x * pos.x + pos.y * pos.y);
    //    if (distance < minDist)
    //      return pos;
    //
    //    //Check -height
    //    pos = new PVector(other.x - x, other.y - height - y);
    //    distance = sqrt(pos.x * pos.x + pos.y * pos.y);
    //    if (distance < minDist)
    //      return pos;
    //
    //    //Check +height
    //    pos = new PVector(other.x - x, other.y + height - y);
    //    distance = sqrt(pos.x * pos.x + pos.y * pos.y);
    //    if (distance < minDist)
    //      return pos;

    return pos;
  }
}

