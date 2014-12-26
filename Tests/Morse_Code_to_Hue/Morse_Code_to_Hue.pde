import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.impl.client.DefaultHttpClient;

Light light1, light2;      // first philips HUE light to be controlled by JSON PUT commands
// Light secondLight;     // first philips HUE light to be controlled by JSON PUT commands

String user = "newdeveloper";
String bridge_ip = "223.103.5.141";

int brightnessScale = 20;
int transitionSpeed = 2;

// Light test strings
String morseOn = "{\"on\": true, \"ct\": 154, \"bri\": 254, \"transitiontime\": 2}";  // Light ON & white command for Morse Code
String morseOff = "{\"on\": false, \"transitiontime\": 1}";                           // Light OFF command for Morse Code

String redAlertOn = "{\"on\": true, \"bri\": 254, \"hue\": 546, \"sat\": 254, \"transitiontime\": 2}";  // Light ON command for new message alert
String redAlertOff = "{\"on\": false, \"transitiontime\": 3}";                                          // Light OFF command for new message alert

String turnOn = "{\"on\": true}";     // Turn light on to whatever color it was left at
String turnOff = "{\"on\": false}";   // Turn light off

String textMessage = ""; // message on screen created from Morse Code

PFont fontM;             // text message font
PFont fontN;             // navigation font

PImage sendIconW, sendIconB, clearIconW, clearIconB, flashlightIconW, flashlightIconB;

void setup () {
  size(640, 480);
  smooth();
  colorMode(HSB, 255);
  rectMode(CENTER);

  println("initializing lights...");

  light1 = new Light(bridge_ip, user, 1);
  light2 = new Light(bridge_ip, user, 2);
  // secondLight = new Light("http://bridge_ip/api/apikey/lights/2/state");

  println("lights initialized.");
}

void draw () {
}
void keyPressed() {
  if (key == '1') {
    light1.on(!light1.on());
  }
  if (key == '2') {
    light2.on(!light2.on());
  }

  if (key == '3') {
    light2.brightness(20, 1);
  }
  if (key == '4') {
    light2.brightness(255, 1);
  }
  if (key == CODED) {
    if (keyCode == UP) {
      light1.brightness(light1.brightness() + brightnessScale);
      light2.brightness(light2.brightness() + brightnessScale);
    } else if (keyCode == DOWN) {
      light1.brightness(light1.brightness() - brightnessScale);
      light2.brightness(light2.brightness() - brightnessScale);
    }
  }
}

