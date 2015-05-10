import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import SimpleOpenNI.*; 
import org.apache.http.HttpEntity; 
import org.apache.http.HttpResponse; 
import org.apache.http.client.methods.HttpPut; 
import org.apache.http.impl.client.DefaultHttpClient; 
import processing.core.*; 
import edu.cmu.sphinx.frontend.util.Utterance; 
import edu.cmu.sphinx.frontend.util.Microphone; 
import edu.cmu.sphinx.recognizer.Recognizer; 
import edu.cmu.sphinx.result.Result; 
import edu.cmu.sphinx.util.props.ConfigurationManager; 
import edu.cmu.sphinx.util.props.PropertyException; 
import java.io.IOException; 
import java.net.URL; 
import java.lang.reflect.*; 

import org.apache.http.auth.params.*; 
import org.apache.http.pool.*; 
import edu.cmu.sphinx.decoder.*; 
import edu.cmu.sphinx.linguist.lextree.*; 
import org.apache.http.client.methods.*; 
import org.apache.http.impl.io.*; 
import edu.cmu.sphinx.linguist.language.ngram.*; 
import org.apache.http.cookie.*; 
import org.apache.http.conn.ssl.*; 
import org.apache.http.client.entity.*; 
import org.apache.http.client.protocol.*; 
import edu.cmu.sphinx.frontend.databranch.*; 
import edu.cmu.sphinx.decoder.search.stats.*; 
import edu.cmu.sphinx.frontend.*; 
import org.apache.commons.logging.*; 
import edu.cmu.sphinx.result.*; 
import org.apache.http.io.*; 
import edu.cmu.sphinx.linguist.acoustic.*; 
import edu.cmu.sphinx.linguist.language.grammar.*; 
import edu.cmu.sphinx.linguist.dflat.*; 
import org.apache.http.impl.entity.*; 
import edu.cmu.sphinx.decoder.search.*; 
import edu.cmu.sphinx.util.props.tools.*; 
import edu.cmu.sphinx.frontend.filter.*; 
import org.apache.http.impl.client.*; 
import org.apache.http.conn.scheme.*; 
import edu.cmu.sphinx.frontend.transform.*; 
import org.apache.http.impl.auth.*; 
import edu.cmu.sphinx.util.*; 
import org.apache.http.params.*; 
import edu.cmu.sphinx.linguist.language.ngram.large.*; 
import edu.cmu.sphinx.util.props.*; 
import org.apache.http.impl.client.cache.*; 
import edu.cmu.sphinx.linguist.language.classes.*; 
import org.apache.http.message.*; 
import edu.cmu.sphinx.linguist.acoustic.trivial.*; 
import edu.cmu.sphinx.linguist.acoustic.tiedstate.HTK.*; 
import org.apache.http.conn.util.*; 
import edu.cmu.sphinx.frontend.util.*; 
import edu.cmu.sphinx.linguist.dictionary.*; 
import edu.cmu.sphinx.frontend.feature.*; 
import edu.cmu.sphinx.jsgf.*; 
import edu.cmu.sphinx.util.machlearn.*; 
import org.apache.http.cookie.params.*; 
import org.apache.http.entity.mime.*; 
import org.apache.http.impl.client.cache.memcached.*; 
import org.apache.commons.logging.impl.*; 
import edu.cmu.sphinx.jsgf.parser.*; 
import org.apache.http.*; 
import org.apache.http.impl.conn.tsccm.*; 
import org.apache.http.impl.conn.*; 
import org.apache.http.protocol.*; 
import org.apache.http.conn.routing.*; 
import org.apache.http.conn.params.*; 
import edu.cmu.sphinx.linguist.util.*; 
import edu.cmu.sphinx.jsgf.rule.*; 
import org.apache.http.auth.*; 
import org.apache.http.client.params.*; 
import org.apache.http.client.cache.*; 
import org.apache.http.impl.cookie.*; 
import org.apache.http.entity.mime.content.*; 
import edu.cmu.sphinx.frontend.endpoint.*; 
import edu.cmu.sphinx.decoder.pruner.*; 
import edu.cmu.sphinx.decoder.scorer.*; 
import org.apache.http.impl.*; 
import edu.cmu.sphinx.linguist.flat.*; 
import org.apache.http.concurrent.*; 
import org.apache.http.impl.pool.*; 
import org.apache.http.client.*; 
import edu.cmu.sphinx.recognizer.*; 
import org.apache.http.client.fluent.*; 
import edu.cmu.sphinx.frontend.frequencywarp.*; 
import edu.cmu.sphinx.linguist.*; 
import org.apache.http.conn.*; 
import org.apache.http.client.utils.*; 
import org.apache.http.entity.*; 
import edu.cmu.sphinx.instrumentation.*; 
import org.apache.http.impl.client.cache.ehcache.*; 
import hypermedia.net.*; 
import org.apache.http.annotation.*; 
import edu.cmu.sphinx.frontend.window.*; 
import org.apache.http.util.*; 
import edu.cmu.sphinx.linguist.acoustic.tiedstate.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Watson_2 extends PApplet {

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

public void setup() {
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

public void dispose() {
  listener.dispose();
}

public void draw() {
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

public void receive( byte[] data, String ip, int port ) {
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


//import hypermedia.net.*;
 

public void drawDepth() {
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

public void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("New User - userId: " + userId);
  curContext.startTrackingSkeleton(userId);
  peopleActive++;
  println("People Active: " + peopleActive);
}

public void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("Lost User - userId: " + userId);
  peopleActive--;
  if (peopleActive < 0) {
    peopleActive = 0;
  }
  println("People Active: " + peopleActive);
}






int test = 0;

class Light {
  String l;
  int id;
  int brightness;

  Light(String bridge_ip, String user, int _id) {
    String _lighturl = "http://" + bridge_ip + "/api/" + user + "/lights/" + _id + "/state";
    id = _id;
    l = _lighturl;
    on();
  }

  public void send (String command) {                                          // sends JSON commands via PUT request
    try
    {
      HttpPut httpPut = new HttpPut( l );                               // set HTTP put address to light being accessed
      DefaultHttpClient httpClient = new DefaultHttpClient();

      httpPut.addHeader("Accept", "application/json");                  // tell everyone we are talking JSON
      httpPut.addHeader("Content-Type", "application/json");

      StringEntity entity = new StringEntity(command, "UTF-8");         // pull in the command set already in JSON
      entity.setContentType("application/json");
      httpPut.setEntity(entity); 

      HttpResponse response = httpClient.execute( httpPut );            // check to make sure it went well
      println( response.getStatusLine());
    } 
    catch( Exception e ) { 
      e.printStackTrace();
    }
  }
  
  public int brightness() {
    String response = loadStrings( l.substring(0, (l.length() - 6)) )[0];
    if ( response != null ) {
      JSONObject root = new JSONObject();
      root = root.parse(response);
      JSONObject condition = root.getJSONObject("state");
      return condition.getInt("bri");
    }
    return 255;
  }
  
  public void brightness(int value) {
    value = value > 255 ? 255 : value;
    value = value < 0 ? 0 : value; 
    this.send("{\"bri\": " + value + "}");
    this.brightness = value;
    println("Brightness for light " + id + " set to " + this.brightness);
  }
  
  public void brightness(int value, int transitionSpeed) {
    value = value > 255 ? 255 : value;
    value = value < 0 ? 0 : value; 
    this.send("{\"bri\": " + value + ", \"transitiontime\": " + transitionSpeed + "}");
    this.brightness = value;
    println("Brightness for light " + id + " set to " + this.brightness);
  }
    
  public boolean on(boolean value) {
    this.send("{\"on\": " + value + "}");
    return value;
  }
  
  public boolean on() {
    String response = loadStrings( l.substring(0, (l.length() - 6)) )[0];
    if ( response != null ) {
      JSONObject root = new JSONObject();
      root = root.parse(response);
      JSONObject condition = root.getJSONObject("state");
      boolean isOn = condition.getBoolean("on");
      println("Light " + id + " on = " + isOn);
      return isOn;
    }
    return false;
  }
  
}

public String GetBridgeIP() {
  String url = "https://www.meethue.com/api/nupnp";
  print("Searching for Hue bridge........... ");
  try
  {
    HttpGet httpGet = new HttpGet(url);                               
    DefaultHttpClient httpClient = new DefaultHttpClient();
    httpGet.addHeader("Accept", "application/json");                  
    httpGet.addHeader("Content-Type", "application/json");
    HttpResponse response = httpClient.execute(httpGet);
    
    String body = EntityUtils.toString(response.getEntity());
    body = "{\"source\":" + body + "}";
    JSONObject parsed = JSONObject.parse(body);
    JSONArray array = parsed.getJSONArray("source");
    JSONObject result = array.getJSONObject(0);
    String ip = result.getString("internalipaddress");
    
    print("SUCCESS.\n");
    println("Found Hue bridge on IP: " + ip);
    
    return ip;
  } 
  catch( Exception e ) {
    print("FAILED.\n");
    println("Unable to find Hue Bridge on local network.");
    e.printStackTrace();
    return "";
  }
}
public void Parse(String input) {
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



// sphinx stuff







// java stuff





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
public void SphinxEvent(Sphinx _l) {
  if (useVoice) {
    s = _l.readString(); // returns the recognized string
    println("Sphinx heard: " + s);
    Parse(s);
    if ((s.indexOf("quit") >= 0) || (s.indexOf("exit") >= 0) || (s.indexOf("stop") >= 0)) {
      exit();
    }
  }
}


  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Watson_2" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
