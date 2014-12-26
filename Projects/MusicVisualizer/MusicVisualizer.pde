import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioInput input;
BeatListener listener;
BeatDetect beat;


boolean AUDIO_REACTIVE = true;
boolean RANDOM_COLORS = true;
boolean FULLSCREEN = true;


//ENVIRONMENT
int numDots;
float numDotsModifier = 0.00009;
int minDist = 0;
int maxDist = 100;
float distMod = 20;
float connectionMod = 2;
float modifier = .3;
int border = 0;
float colorEasing = 0.5;

//SPEED
float maxAcceleration = 20.00;
float acceleration = maxAcceleration;
float maxVelocity = 50.5;
float velocity = maxVelocity;
ArrayList<Dot> dots;

boolean sketchFullScreen() {
  return FULLSCREEN;
}

float beatKick = 0;

void setup() 
{
  numDots = (int)(displayWidth*displayHeight * numDotsModifier);
  boolean paused = false;
  if (FULLSCREEN) {
    size(displayWidth, displayHeight);
  } 
  else {
    size(1000, 800);
  }
  if (frame != null) {
    frame.setResizable(true);
  }
  frameRate(30);
  background(0);
  noStroke();
  smooth();
  ellipseMode(CENTER);
  rectMode(CENTER);
  noCursor();

  if (AUDIO_REACTIVE) {
    minim = new Minim(this);
    input = minim.getLineIn();
    beat = new BeatDetect(1024, 44100);
    listener = new BeatListener(beat, input);
  }

  dots = new ArrayList<Dot>();

  for (int i = 0; i < numDots; i++) {
    dots.add(new Dot(random(border, width-border), random(border, height-border), random(1, 5), i, dots));
  }
}

void draw() 
{
  if (!paused)
  {
    background(0);
    if (AUDIO_REACTIVE) {
      beat.detect(input.left);

      if (beat.isKick()) {
        beatKick = beatKick > 60 ? 60 : beatKick + 40;
      } else {
       beatKick = distMod < 0 ? distMod : beatKick - 2.2;
      }
      float inputMod = abs(input.mix.get(100)* 190);
      distMod = displayWidth*displayHeight*0.00003 + inputMod + beatKick;

      strokeWeight(map(inputMod, 0, 100, 0.7, 3));
      velocity = map(inputMod, 0, 100, 1, 120.0);
      acceleration = map(inputMod, 0, 100, .1, 50);
    }

    for (int i = 0; i < dots.size()-1; i++) {
      Dot dot = dots.get(i);
      dot.move();
      dot.checkDistance();
      dot.pacman();
    }

    if (distMod < 0) { 
      distMod = 0;
    } 
    else { 
      distMod -= 0.05;
    }
  }
}

void DrawDot()
{
  int i = (int)random(0, dots.size()-1);
  Dot dot = dots.get(i);
  dot.diameter = dot.maxDiameter;
}

void keyPressed() {
  if (FULLSCREEN)
    exit();
}
void mouseMoved() {
  if (FULLSCREEN)
    exit();
} 

