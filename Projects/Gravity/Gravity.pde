int numstars = 700;
float spring = 0.0000014;
float border = 100;
float gravity = 0.0;
float maxVelocity = 200;
float gravityWell = 200;
float friction = -0.00005;
Star[] stars = new Star[numstars];
ArrayList blackholes = new ArrayList<Star>();
boolean paused = false;

boolean FULLSCREEN = true;

boolean sketchFullScreen() {
  return FULLSCREEN;
}

void setup() {
  frameRate(60);
  if (FULLSCREEN) {
    size(displayWidth, displayHeight);
  } 
  else {
    size(1000, 800);
  }
  for (int i = 0; i < numstars; i++) {
    stars[i] = new Star(random(width), random(height), random(1, 1), i, stars);
  }
  for (int i = 0; i < 10; i++) {
    blackholes.add(new Star(random(0 + border, width - border), random(0 + border, height - border), 20, i, stars));
  }
  noStroke();
  fill(255, 204);
}

void draw() {
  if (!paused) {
    background(0);
    for (int i = 0; i < numstars-1; i++) {
      stars[i].collide();
      stars[i].move();
      stars[i].display(color(255));
      //stars[i].pacman();
    }
    
    for (int i = 0; i < blackholes.size(); i++) {
      Star blackhole = (Star)blackholes.get(i);
      //blackhole.collide();
      //blackhole.display(color(50));
    }
    
  }
}

void keyPressed() {
  paused = !paused;
}

