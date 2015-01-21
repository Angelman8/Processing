import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.impl.client.DefaultHttpClient;
import processing.net.*;

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


//Bluetooth Proximity
Server server;
boolean phoneDetected = true;

boolean useVoice = false;
boolean useServer = true;


void setup() {
  size(400, 400);
  background(0);
  if (useVoice) {
    listener = new Sphinx(this, "upstairs.config.xml");
  }
  String bridge_ip = ConfigureIP();

  light1 = new Light(bridge_ip, user, 1);
  light2 = new Light(bridge_ip, user, 2);

  server = new Server(this, 5005);
}

void dispose() {
  listener.dispose();
}

void draw() {
  background(0);
  if (useServer) {
    Client thisClient = server.available();
    if (thisClient !=null) {
      String whatClientSaid = thisClient.readString();
      if (whatClientSaid != null) {
        if (whatClientSaid.equals("Galen: in") && !phoneDetected) {
          phoneDetected = true;
          light1.on(light1History);
          light2.on(light2History);
        } 
        else if (whatClientSaid.equals("Galen: out") && phoneDetected) {
          phoneDetected = false;
          light1History = light1.on();
          light2History = light2.on();
          light1.on(false);
          light2.on(false);
        }
        int val = 1;
        server.write(val);
      }
    }
    if (phoneDetected) {
      fill(0, 255, 0);
    } 
    else {
      fill(255, 0, 0);
    }
    ellipse(width/2, height/2, 50, 50);
  }
}

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

String ConfigureIP() {
  String url = "https://www.meethue.com/api/nupnp";
  try
  {
    HttpGet httpGet = new HttpGet( url );                               
    DefaultHttpClient httpClient = new DefaultHttpClient();

    httpGet.addHeader("Accept", "application/json");                  
    httpGet.addHeader("Content-Type", "application/json");

    HttpResponse response = httpClient.execute( httpGet );
    String body = EntityUtils.toString(response.getEntity());
    body = "{\"source\":" + body + "}";
    JSONObject parsed = JSONObject.parse(body);
    JSONArray array = parsed.getJSONArray("source");
    JSONObject result = array.getJSONObject(0);
    //      JSONObject result = new JSONObject();
    //      result = result.parse(body);
    String ip = result.getString("internalipaddress");
    return ip;
  } 
  catch( Exception e ) { 
    e.printStackTrace();
    return "";
  }
}

