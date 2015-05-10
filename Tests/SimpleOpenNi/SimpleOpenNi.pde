import SimpleOpenNI.*; 
import ddf.minim.*;
import ddf.minim.ugens.*;

SimpleOpenNI  context; 
PImage img;

Minim minim;
AudioOutput out;
Oscil wave;
int maxFrequency = 60;
int frequency = maxFrequency;
float maxAmplitude = 0.4f;
float amplitude = maxAmplitude;

float rotX = radians(180);

void setup(){
  size(640, 480); 

  context = new SimpleOpenNI(this);
 
  context.enableDepth();  
  context.enableUser();
  context.setMirror(true);
  img = createImage(640,480,RGB);
  img.loadPixels();
  
  minim = new Minim(this);
  out = minim.getLineOut();
  wave = new Oscil( frequency, amplitude, Waves.SINE );
}

void draw(){
  background(0);
  
  context.update();
  PImage depthImage = context.depthImage();
  depthImage.loadPixels();
 
  int[] upix = context.userMap();
 
  for(int i = 0; i < upix.length; i++){
    if(upix[i] > 0){
      img.pixels[i] = color(0,0,255);
    } else {
      img.pixels[i] = depthImage.pixels[i];
    }
  }
  img.updatePixels();
  image(img, 0, 0);
 
  int[] users = context.getUsers();
  ellipseMode(CENTER);
 
  for(int i = 0; i < users.length; i++){
    int uid = users[i];
    
    PVector realCoM = new PVector();
    context.getCoM(uid,realCoM);
    PVector projCoM = new PVector();
    
    context.convertRealWorldToProjective(realCoM, projCoM);
    fill(255, 0, 0);
    ellipse(projCoM.x, projCoM.y, 10, 10);
    
    if(context.isTrackingSkeleton(uid)){
      //HEAD
      PVector realHead=new PVector();
      context.getJointPositionSkeleton(uid,SimpleOpenNI.SKEL_HEAD,realHead);
      PVector projHead=new PVector();
      context.convertRealWorldToProjective(realHead, projHead);
      fill(0,255,0);
      ellipse(projHead.x, projHead.y, 10, 10);
 
      //LEFT HAND
      PVector realLHand=new PVector();
      context.getJointPositionSkeleton(uid, SimpleOpenNI.SKEL_LEFT_HAND, realLHand);
      PVector projLHand=new PVector();
      context.convertRealWorldToProjective(realLHand, projLHand);
      fill(255,255,0);
      ellipse(projLHand.x,projLHand.y,10,10);
      
      //LEFT FOOT
      PVector realLFoot=new PVector();
      context.getJointPositionSkeleton(uid, SimpleOpenNI.SKEL_LEFT_FOOT, realLFoot);
      PVector projLFoot=new PVector();
      context.convertRealWorldToProjective(realLFoot, projLFoot);
      fill(255,255,255);
      ellipse(projLFoot.x,projLFoot.y,10,10);
      
      //RIGHT HAND
      PVector realRHand=new PVector();
      context.getJointPositionSkeleton(uid, SimpleOpenNI.SKEL_RIGHT_HAND, realRHand);
      PVector projRHand=new PVector();
      context.convertRealWorldToProjective(realRHand, projRHand);
      fill(255,0,255);
      ellipse(projRHand.x,projRHand.y,10,10);
      
      wave.setFrequency( frequency + projLHand.y * .2);
      wave.setAmplitude( amplitude + projLHand.y * .002);
    }
  }
 
}
 
void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  curContext.startTrackingSkeleton(userId);
  //wave.patch( out );
}
 
void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
  //wave.unpatch( out );
 
}
