import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.impl.client.DefaultHttpClient;

//HUE LIGHTS
Light light1, light2;
String user = "newdeveloper";
int brightnessScale = 20;
int transitionSpeed = 2;

String lastAction = "";

//SPHINX
Sphinx listener;
String s = "";



void setup() {
  size(400, 400);
  background(0);
  listener = new Sphinx(this, "upstairs.config.xml");
  String bridge_ip = ConfigureIP();
  
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


