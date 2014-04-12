class Dot {
  float x, y;
  float maxDiameter;
  float diameter;
  int id;
  //Start with random velocity
  float rx, ry;
  color dotcolor = color(255);

  ArrayList<Dot> others;
  ArrayList<Dot> connections;


  Dot(float xin, float yin, float din, int idin, ArrayList<Dot> oin) {
    x = xin;
    y = yin;
    maxDiameter = din;
    others = oin;
    id = idin;
    connections = new ArrayList<Dot>();
    rx = random(-maxVelocity, maxVelocity);
    ry = random(-maxVelocity, maxVelocity);
  } 

  void checkDistance() {
    for (int i = id + 1; i < numDots; i++) {
      Dot other = others.get(i);
      float dx = other.x - x;
      float dy = other.y - y;
      float distance = sqrt(dx*dx + dy*dy);

      if (distance < distMod && distance > minDist) {
        drawline(x, y, other.x, other.y);
        connections.add(other);
        //println("connection added between dot " + id + " and dot " + other.id);
      } 
      else {
        if (connections.contains(other)) {
          connections.remove(other);
          //println("connection removed between dot " + id + " and dot " + other.id);
        }
      }
    }
  }

  void move() {
    x += rx;
    y += ry;

    rx += random(-acceleration, acceleration);
    ry += random(-acceleration, acceleration);

    if (rx >  velocity) rx =  velocity;
    if (rx <  -velocity) rx =  -velocity;
    if (ry >  velocity) ry =  velocity;
    if (ry <  -velocity) ry =  -velocity;
  }

  void display() {
    noStroke();
    fill(255, 100);
    ellipse(x, y, diameter, diameter);

    if (diameter < 0) { 
      diameter = 0;
    } 
    else { 
      diameter -= 1;
    }
  }

  void randomBeatColor()
  {
    float red = red(dotcolor);
    float green = green(dotcolor);
    float blue = blue(dotcolor);
    if (AUDIO_REACTIVE) {
      if (beat.isKick())
      {
        if (RANDOM_COLORS) {
          dotcolor = color(random(255), random(255), random(255));
        } 
        else {
          dotcolor = color(255, 255, 255);
        }
      } 
      else {
        dotcolor = color(red-1, green-1, blue-1);
        if (red < 0) {
          dotcolor = color(0, green, blue);
        }
        if (green < 0) {
          dotcolor = color(red, 0, blue);
        }
        if (blue < 0) {
          dotcolor = color(red, green, 0);
        }
        dotcolor = color(red + connections.size()*connectionMod,green + connections.size()*connectionMod,blue + connections.size()*connectionMod);
      }
    } 
    else {

      if (RANDOM_COLORS) {
        dotcolor = color(random(255), random(255), random(255));
      } 
      else {
        dotcolor = color(255, 255, 255);
      }
    }
  }

  void drawline(float x, float y, float x2, float y2) {
    randomBeatColor();
    // float lineStrength = 100 - (sqrt(x * width/2 + y * height/2)/(width) * 100);
    float midx = (x + x2)/2;
    float midy = (y + y2)/2;
    float dx = midx - width/2;
    float dy = midy - height/2;
    float lineStrength = 255 - sqrt(dx*dx + dy*dy) * modifier;
    stroke(dotcolor, lineStrength);
    line(x, y, x2, y2);
  }

  void drawTriangle(float x, float y, float x2, float y2, float x3, float y3) {
    fill(255, 255);
    println("triangle drawn");
    triangle(x, y, x2, y2, x3, y3);
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

  boolean isConnectedTo(Dot otherDot)
  {
    if (connections.contains(otherDot))
      return true;
    else
      return false;
  }
}

