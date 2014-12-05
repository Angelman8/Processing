Sphinx listener;

String s = "";

void setup() {
  size(400, 400);
  background(0);

  // setup speech recognition
  // NOTE: you need to set the appropriate audio input in microphone section of the config file
  // do this with a <property="selectMixer" value="XXX"> statement with appropriate value.
  // read more here: http://cmusphinx.sourceforge.net/sphinx4/doc/Sphinx4-faq.html#microphone_selection
  
  listener = new Sphinx(this,"upstairs.config.xml");
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
  if((s.indexOf("quit") >= 0) || (s.indexOf("exit") >= 0) || (s.indexOf("stop") >= 0)) {
    exit();
  }
}


