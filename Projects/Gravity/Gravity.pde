int numstars = 200;
float spring = 0.0000005;
float border = 300;
float gravity = 0.0;
float gravityWell = 100;
float friction = -0.0009;
Star[] stars = new Star[numstars];
boolean paused = false;

void setup() {
  size(800, 800);
  for (int i = 0; i < numstars-1; i++) {
    stars[i] = new Star(random(width), random(height), random(1, 2), i, stars);
  }
  stars[numstars-1] = new Star(random(width/2 - border, width/2 + border), random(height/2 - border, height/2 + border), 80, numstars-1, stars);
  noStroke();
  fill(255, 204);
}

void draw() {
  if (!paused) {
    background(0);
    for (int i = 0; i < numstars-1; i++) {
      stars[i].collide();
      stars[i].move();
      stars[i].display();
      stars[i].pacman();
    }
    stars[numstars-1].collide();
    stars[numstars-1].display();
    stars[numstars-1].pacman();
  }
}

void keyPressed() {
  paused = !paused;
}

