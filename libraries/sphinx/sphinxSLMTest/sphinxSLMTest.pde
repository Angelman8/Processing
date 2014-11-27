//
// sphinxSLMTest
//
//   simple example program of sphinx4 automatic speech recognizer using 
//   a statistical language model (SLM) rather than a grammar.  
//
//   The two SLM's in the data directory, 3990.lm/.dict, and 7707.lm/.dict
//   were generated with the CMU Sphinx Knowledge Base Tool:
//     http://www.speech.cs.cmu.edu/tools/lmtool-new.html
//
//   prepared for a workshop at UNTREF:
//   http://wiki.roberttwomey.com/UNTREF_Speech_Workshop
//
//   robert twomey, 2013, roberttwomey.com
//
//

Sphinx listener;
String s = ""; // variable for sphinx results

int lastevent = 0;

void setup() {
  size(400, 400);
  background(0);

  // setup speech recognition
  listener = new Sphinx(this,"/sphinx_config.xml");
  lastevent = 0; // for intra-utterance timing
}

void dispose() {
  // clean up listener threads
  listener.dispose();
}

void draw() { 
  stroke(255);

  // check how long it has been silent
  // doquit();
}

void SphinxEvent(Sphinx _l) {
  int now = millis();

  s = _l.readString(); // returns the recognized string

    // echo to screen 
//  System.out.print("["+now+"] sphinx heard: "+s);
  System.out.print("["+now+"] "+s);

  // intra-utterance timing
  System.out.println("  ("+(now-lastevent)+" since last utterance)");
  lastevent=now;

  // check for stop command
  if((s.indexOf("quit") >= 0) || (s.indexOf("exit") >= 0) || ((s.indexOf("stop") >= 0) && (s.indexOf("dystopian") < 0))) {
    exit();
  }
}

