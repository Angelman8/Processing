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
float numDotsModifier = 0.0001;
int minDist = 0;
int maxDist = 150;
float distMod = 230;
float connectionMod = 2;
float modifier = .5;
int border = 0;

//SPEED
float maxAcceleration = 0.30;
float acceleration = maxAcceleration;
float maxVelocity = 2.5;
float velocity = maxVelocity;
ArrayList<Dot> dots;

boolean sketchFullScreen() {
  return FULLSCREEN;
}

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

      float beatKick = beat.isKick() ? 40 : 0;
      if (beat.isKick())
      {
        //DrawDot();
      }
      float inputMod = abs(input.mix.get(100)* 160);
      distMod = displayWidth*displayHeight*0.00005 + inputMod + beatKick;

      strokeWeight(map(inputMod, 0, 100, 0.4, 2));
      velocity = map(inputMod, 0, 100, 1, 18.0);
      acceleration = map(inputMod, 0, 100, .1, 3);
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

