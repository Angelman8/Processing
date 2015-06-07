import processing.core.*;

// sphinx stuff
import edu.cmu.sphinx.frontend.util.Utterance;
import edu.cmu.sphinx.frontend.util.Microphone;
import edu.cmu.sphinx.recognizer.Recognizer;
import edu.cmu.sphinx.result.Result;
import edu.cmu.sphinx.util.props.ConfigurationManager;
import edu.cmu.sphinx.util.props.PropertyException;

// java stuff
import java.io.IOException;
import java.net.URL;
import java.lang.reflect.*;


public class Sphinx implements Runnable {
  Recognizer recognizer;
  Microphone microphone;
  PApplet parent;
  Method SphinxEventMethod;

  Thread t;
  String resultText;
  String config;
  String path;
  Recognizer.State READY = Recognizer.State.READY;

  public Sphinx(PApplet _p, String _c) {
    this.parent = _p;
    this.config = _c;
    resultText = "";
    init();

    parent.registerDispose(this);

    t = new Thread(this);
    t.start();
  }

  private void init() {
    path = parent.dataPath("");
    //System.out.println("Microphone off test");
    try {
      SphinxEventMethod = parent.getClass().getMethod("SphinxEvent", new Class[] { 
        Sphinx.class
      }
      );

      // Initialize the voice recognition      
      System.out.println("Initializing Sphinx-4:");      
      System.out.println("  data directory " + path);
      System.out.println("  config file " + config);
      URL url = new URL("file:///" + path + "/"+ config);

      System.out.print("loading configuration...");
      ConfigurationManager cm = new ConfigurationManager(url);
      System.out.println("loaded");

      recognizer = (Recognizer) cm.lookup("recognizer");
      System.out.print("allocating recognizer (note this may take some time)... ");
      try {
        recognizer.allocate();
      } 
      catch (Exception e) {
        e.printStackTrace();
      };
      System.out.println("allocated");

      microphone = (Microphone) cm.lookup("microphone"); 
      // start recording / recognizing
      System.out.print("microphone recording... ");
      if (!microphone.startRecording()) {
        System.out.println("Cannot start microphone.");
        recognizer.deallocate();
      }
      System.out.println("started");
    } 
    catch (IOException ioe) {
      ioe.printStackTrace();
    } 
    catch (PropertyException pe) {
      pe.printStackTrace();
    } 
    catch (Exception e) {
      e.printStackTrace();
    }
  }

  public void run() {
    // Sphinx thread, main loop
    System.out.println("main recognition loop started");
    while (true) {
      try {        
        // ask the recognizer to recognize text in the recording
        if(recognizer.getState()==Recognizer.State.READY) {
          Result result = recognizer.recognize(); 
          // got a result
          if (result != null) {
            resultText = result.getBestFinalResultNoFiller();
            println();
            if(resultText.length()>0) {
              makeEvent();
            }
          }
        }
      }
      catch (Exception e) { 
        System.out.println("exception Occured ");  
        e.printStackTrace(); 
        System.exit(1);
      }
    }
  }

  public String readString() {
    return resultText;
  }

  public void makeEvent() {
    if (SphinxEventMethod != null) {
      try {
        SphinxEventMethod.invoke(parent, new Object[] { 
          this
        }
        );
      } 
      catch (Exception e) {
        e.printStackTrace();
        SphinxEventMethod = null;
      }
    }
  }

  public void dispose() {
    microphone.stopRecording();
    while(recognizer.getState()==Recognizer.State.RECOGNIZING) {
      // wait till finished recognizing
    };
    recognizer.deallocate();
  }
}

//Voice Record Event
void SphinxEvent(Sphinx _l) {
  if (useVoice) {
    s = _l.readString(); // returns the recognized string
    println("Sphinx heard: " + s);
    Parse(s);
    if ((s.indexOf("quit") >= 0) || (s.indexOf("exit") >= 0) || (s.indexOf("stop") >= 0)) {
      exit();
    }
  }
}

//// PARSING

void Parse(String input) {
  if (input.contains("light") && input.contains("off") && input.contains("turn")) {
    lastAction = "light off turn";
    if (phoneDetected) {
      light1.on(false);
      light2.on(false);
    }
  } 
  if (input.contains("light") && input.contains("on") && input.contains("turn")) {
    lastAction = "light on turn";
    if (phoneDetected) {
      light1.on(true);
      light2.on(true);
    }
  } 
  if (input.contains("reading") && input.contains("mode")) {
    lastAction = "reading mode";
    if (!light1.on())
      light1.on(true);
    light1.brightness(00);
    light2.on(false);
  } 
  if (input.contains("brightness")) {
    if (input.contains("up") || input.contains("on")) {
      lastAction = "brightness up";
      if (light1.on())
        light1.brightness(light1.brightness() + brightnessScale);
      if (light2.on())
        light2.brightness(light2.brightness() + brightnessScale);
    } 
    else if (input.contains("down")) {
      lastAction = "brightness down";
      if (light1.on())
        light1.brightness(light1.brightness() - brightnessScale);
      if (light2.on())
        light2.brightness(light2.brightness() - brightnessScale);
    }
  } 
  if (input.contains("more")) {
    println(lastAction);
    if (lastAction.contains("brightness"))
      Parse(lastAction);
  }
  if (input.contains("faster")) {
    brightnessScale += 20; 
    Parse(lastAction);
  } 
  else if (input.contains("slower")) {
    brightnessScale -= 20; 
    Parse(lastAction);
  }
}



