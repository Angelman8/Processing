//import hypermedia.net.*;
import SimpleOpenNI.*; 

void drawDepth() {
  context.update();
  if (showDepth) {
    PImage depthImage = context.depthImage();
    depthImage.loadPixels();

    int[] upix = context.userMap();
    for (int i = 0; i < upix.length; i++) {
      if (upix[i] > 0) {
        img.pixels[i] = color(0, 0, 255);
      } else {
        img.pixels[i] = depthImage.pixels[i];
      }
    }
    img.updatePixels();
    image(img, 0, 0);
  }
  int[] users = context.getUsers();
  ellipseMode(CENTER);

  for (int i = 0; i < users.length; i++) {
    int uid = users[i];

    PVector realCoM = new PVector();
    context.getCoM(uid, realCoM);
    PVector projCoM = new PVector();

    context.convertRealWorldToProjective(realCoM, projCoM);
    if (showDepth) {
      fill(255, 0, 0);
      ellipse(projCoM.x, projCoM.y, 10, 10);
    }

    if (context.isTrackingSkeleton(uid)) {
      //HEAD
      PVector realHead=new PVector();
      context.getJointPositionSkeleton(uid, SimpleOpenNI.SKEL_HEAD, realHead);
      PVector projHead=new PVector();
      context.convertRealWorldToProjective(realHead, projHead);
      if (showDepth) {
        fill(0, 255, 0);
        ellipse(projHead.x, projHead.y, 10, 10);
      }
      //LEFT HAND
      PVector realLHand=new PVector();
      context.getJointPositionSkeleton(uid, SimpleOpenNI.SKEL_LEFT_HAND, realLHand);
      PVector projLHand=new PVector();
      context.convertRealWorldToProjective(realLHand, projLHand);
      if (showDepth) {
        fill(255, 255, 0);
        ellipse(projLHand.x, projLHand.y, 10, 10);
      }

      //LEFT FOOT
      PVector realLFoot=new PVector();
      context.getJointPositionSkeleton(uid, SimpleOpenNI.SKEL_LEFT_FOOT, realLFoot);
      PVector projLFoot=new PVector();
      context.convertRealWorldToProjective(realLFoot, projLFoot);
      if (showDepth) {
        fill(255, 255, 255);
        ellipse(projLFoot.x, projLFoot.y, 10, 10);
      }

      //RIGHT HAND
      PVector realRHand=new PVector();
      context.getJointPositionSkeleton(uid, SimpleOpenNI.SKEL_RIGHT_HAND, realRHand);
      PVector projRHand=new PVector();
      context.convertRealWorldToProjective(realRHand, projRHand);
      if (showDepth) {
        fill(255, 0, 255);
        ellipse(projRHand.x, projRHand.y, 10, 10);
      }
    }
  }
}

void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("New User - userId: " + userId);
  curContext.startTrackingSkeleton(userId);
  peopleActive++;
  println("People Active: " + peopleActive);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("Lost User - userId: " + userId);
  peopleActive--;
  if (peopleActive < 0) {
    peopleActive = 0;
  }
  println("People Active: " + peopleActive);
}

