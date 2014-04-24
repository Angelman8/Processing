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
int minDist = 0;
int maxDist = 130;
float distMod = 180;
float connectionMod = .03;
float modifier = 0;
int border = 0;

//SPEED
float maxAcceleration = 0.15;
float acceleration = maxAcceleration;
float maxVelocity = 1.5;
float velocity = maxVelocity;
ArrayList<Dot> dots;

boolean sketchFullScreen() {
  return FULLSCREEN;
}

void setup() 
{
  numDots = (int)(displayWidth*displayHeight*.000096);
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
  frameRate(24);
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

      float beatKick = beat.isKick() ? 30 : 0;
      if (beat.isKick())
      {
        //DrawDot();
      }
      float inputMod = abs(input.mix.get(100)* 200);
      distMod = displayWidth*displayHeight*0.00007 + inputMod + beatKick;

      strokeWeight(map(inputMod, 0, 100, 0.2, 2));
      velocity = map(inputMod, 0, 100, 1.3, 30.0);
      acceleration = map(inputMod, 0, 100, .1, 5);
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
      distMod -= 0.01;
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
//void mouseMoved() {
//  if (FULLSCREEN)
//    exit();
//} 

