//Booleans
boolean lightsTriggered = false;
boolean phoneDetected = true;
boolean useVoice = true;
boolean useKinect = true;
boolean useServer = true;
boolean showControls = true;
boolean showDepth = true;

boolean alarm = true;

int peopleActive = 0;

//HUE LIGHTS
Light light1, light2;
boolean light1History, light2History = true;
String user = "newdeveloper";
int brightnessScale = 30;
int transitionSpeed = 2;

String lastAction = "";

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
  size(640, 480);
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
}

void dispose() {
  listener.dispose();
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
    ellipse(width/2, height/10, 20, 20);
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
    println( "UDP Broadcast: \""+message+"\" from "+ip+" on port "+port );
  }
}

