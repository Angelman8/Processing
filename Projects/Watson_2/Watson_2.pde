
//HUE LIGHTS
Light light1, light2;
String user = "newdeveloper";
String bridge_ip = "223.103.5.141";
int brightnessScale = 20;
int transitionSpeed = 2;


//SPHINX
Sphinx listener;
String s = "";



void setup() {
  size(400, 400);
  background(0);
  listener = new Sphinx(this,"upstairs.config.xml");
  
  light1 = new Light(bridge_ip, user, 1);
  light2 = new Light(bridge_ip, user, 2);
}

void dispose() {
  listener.dispose();
}

void draw() {
  background(0);
}

void SphinxEvent(Sphinx _l) {
  s = _l.readString(); // returns the recognized string
  println("Sphinx heard: " + s);
  Parse(s);
  if((s.indexOf("quit") >= 0) || (s.indexOf("exit") >= 0) || (s.indexOf("stop") >= 0)) {
    exit();
  }
}


