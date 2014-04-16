import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 
import ddf.minim.analysis.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class MusicVisualizer extends PApplet {




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
float distMod = 150;
float connectionMod = 0;
float modifier = .3f;
int border = 0;

//SPEED
float maxAcceleration = 0.15f;
float acceleration = maxAcceleration;
float maxVelocity = 1.5f;
float velocity = maxVelocity;
ArrayList<Dot> dots;

public boolean sketchFullScreen() {
  return FULLSCREEN;
}

public void setup() 
{
  numDots = (int)(displayWidth*displayHeight*.00008f);
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

public void draw() 
{
  if (!paused)
  {
    background(0);
    if (AUDIO_REACTIVE) {
      beat.detect(input.left);

      float beatKick = beat.isKick() ? 22 : 0;
      if (beat.isKick())
      {
        //DrawDot();
      }
      float inputMod = abs(input.mix.get(100)* 160);
      distMod = displayWidth*displayHeight*0.000025f + inputMod + beatKick;

      strokeWeight(map(inputMod, 0, 100, 0.2f, 1.6f));
      velocity = map(inputMod, 0, 100, 1, 15.0f);
      acceleration = map(inputMod, 0, 100, .1f, 2.4f);
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
      distMod -= 0.05f;
    }
  }
}

public void DrawDot()
{
  int i = (int)random(0, dots.size()-1);
  Dot dot = dots.get(i);
  dot.diameter = dot.maxDiameter;
}

public void keyPressed() {
  if (FULLSCREEN)
    exit();
}
public void mouseMoved() {
  if (FULLSCREEN)
    exit();
} 

class Dot {
  float x, y;
  float maxDiameter;
  float diameter;
  int id;
  //Start with random velocity
  float rx, ry;
  int dotcolor = color(255);

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

  public void checkDistance() {
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

  public void move() {
    x += rx;
    y += ry;

    rx += random(-acceleration, acceleration);
    ry += random(-acceleration, acceleration);

    if (rx >  velocity) rx =  velocity;
    if (rx <  -velocity) rx =  -velocity;
    if (ry >  velocity) ry =  velocity;
    if (ry <  -velocity) ry =  -velocity;
  }

  public void display() {
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

  public void randomBeatColor()
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

  public void drawline(float x, float y, float x2, float y2) {
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

  public void drawTriangle(float x, float y, float x2, float y2, float x3, float y3) {
    fill(255, 255);
    println("triangle drawn");
    triangle(x, y, x2, y2, x3, y3);
  }
  public void pacman() {
    if (x > width)
      x = 0;
    else if (x < 0)
      x = width;
    if (y > height)
      y = 0;
    else if (y < 0)
      y = height;
  }

  public boolean isConnectedTo(Dot otherDot)
  {
    if (connections.contains(otherDot))
      return true;
    else
      return false;
  }
}

class BeatListener implements AudioListener
{
 private BeatDetect beat;
 private AudioInput source;
 
 BeatListener(BeatDetect beat, AudioInput source)
 {
   this.source = source;
   this.source.addListener(this);
   this.beat = beat;
 }
 
 public void samples(float[] samps)
 {
   beat.detect(source.mix);
 }
 
 public void samples(float[] sampsL, float[] sampsR)
 {
   beat.detect(source.mix);
 }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--hide-stop", "MusicVisualizer" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
