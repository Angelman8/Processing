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

  void send (String command) {                                          // sends JSON commands via PUT request
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
  
  void toggle() {
    
  }
  
  int brightness() {
    String response = loadStrings( l.substring(0, (l.length() - 6)) )[0];
    if ( response != null ) {
      JSONObject root = new JSONObject();
      root = root.parse(response);
      JSONObject condition = root.getJSONObject("state");
      return condition.getInt("bri");
    }
    return 255;
  }
  
  void brightness(int value) {
    value = value > 255 ? 255 : value;
    value = value < 0 ? 0 : value; 
    this.send("{\"bri\": " + value + "}");
    this.brightness = value;
    println("Brightness for light " + id + " set to " + this.brightness);
  }
  
  void brightness(int value, int transitionSpeed) {
    value = value > 255 ? 255 : value;
    value = value < 0 ? 0 : value; 
    this.send("{\"bri\": " + value + ", \"transitiontime\": " + transitionSpeed + "}");
    this.brightness = value;
    println("Brightness for light " + id + " set to " + this.brightness);
  }
    
  boolean on(boolean value) {
    this.send("{\"on\": " + value + "}");
    return value;
  }
  
  boolean on() {
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

