
//Booleans
boolean lightsTriggered = false;
boolean phoneDetected = true;
boolean useVoice = true;
boolean useKinect = true;
boolean useServer = true;
boolean showControls = true;
boolean showDepth = false;

boolean alarm = true;

int peopleActive = 0;

//HUE LIGHTS
Light light1, light2;
boolean light1History, light2History = true;
String user = "newdeveloper";
int brightnessScale = 30;
int transitionSpeed = 2;

String lastAction = "";

//SPEECH
Voice voice;

//SPHINX
Sphinx listener;
String s = "";

//KINECT
SimpleOpenNI  context;
PImage img;

//BLUETOOTH PROXIMITY
UDP udp;
String udpBroadcast = "";
int PORT = 5005;

void setup() {
  size(displayWidth, displayHeight);
  background(0);

  //Sphinx
  if (useVoice) {
    listener = new Sphinx(this, "upstairs.config.xml");
  }

  //Hue
  String bridge_ip = GetBridgeIP();
  light1 = new Light(bridge_ip, user, 1);
  light2 = new Light(bridge_ip, user, 2);

  //Kinect
  context = new SimpleOpenNI(this);
  context.enableDepth();  
  context.enableUser();
  context.setMirror(true);
  img = createImage(640, 480, RGB);
  img.loadPixels();

  //Server
  udp = new UDP( this, PORT );
  udp.listen( true );

  //Test Vocal chords
  minim = new Minim(this);
  SetAudioSource(5);
  voice = new Voice("Serena");
  println("Testing vocal chords...");
  print("SUCCESS!");
  
  searchGoogle("How far away is the moon from the earth?");
}

void draw() {
  background(0);

  if (useKinect) {
    drawDepth();
  }

  if (useServer) {
    if (phoneDetected) {
      fill(0, 255, 0);
    } else {
      fill(255, 0, 0);
    }
    rect(width - 15, 3, 10, 10);

    if (peopleActive > 0) {
      fill(0, 0, 255);
    } else {
      fill(255, 0, 0);
    }
    rect(width - 30, 3, 10, 10);
  }

  if (!lightsTriggered && !phoneDetected && peopleActive <= 0) {
    light1History = light1.on();
    light2History = light2.on();
    light1.on(false);
    light2.on(false);
    lightsTriggered = true;
  } else if (lightsTriggered && (phoneDetected || peopleActive > 0)) {
    lightsTriggered = false;
    light1.on(light1History);
    light2.on(light2History);
  }
  
  voice.Render();
}

void receive( byte[] data, String ip, int port ) {
  if (useServer) {
    data = subset(data, 0, data.length-2);
    String message = new String( data );
    if (message.equals("Galen.1")) {
      phoneDetected = true;
    } else {
      phoneDetected = false;
    }
    //println( "UDP Broadcast: \""+message+"\" from "+ip+" on port "+port );
  }
}

void keyPressed() {
  int random = (int)random(1, 11);
  switch (random) {
    case 1:
      voice.Speak("Hello, sir.");
      break;
    case 2:
      voice.Speak("Hello there.");
      break;
    case 3:
      voice.Speak("Hi.");
      break;
    case 4:
      voice.Speak("Greetings sir.");
      break;
    case 5:
      voice.Speak("Well hi, sir.");
      break;
    case 6:
      voice.Speak("Good to see you.");
      break;
    case 7:
      voice.Speak("Sir?");
      break;
    case 8:
      voice.Speak("Good day.");
      break;
    case 9:
      voice.Speak("Charmed.");
      break;
    case 10:
      voice.Speak("Hey there, sir.");
      break;
    default:
      break;
  }
}

