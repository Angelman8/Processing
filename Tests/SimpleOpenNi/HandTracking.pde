boolean      handsTrackFlag = false;  //if kinect is tracking hand or not
PVector      handVec = new PVector();  //the latest/most up to date hand point
ArrayList    handVecList = new ArrayList();  //the previous points in a list
int          handVecListSize = 30;  //the number of previous points to be remembered 
String       lastGesture = "";  //used to keep track of gestures

PVector      handMin = new PVector();
PVector      handMax = new PVector();
float        handThresh = 95;
float        openThresh = 200;
