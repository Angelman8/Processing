import com.getflourish.stt.*;
import ddf.minim.*;
import javax.sound.sampled.*;
import java.io.*;

//Create STT object
STT stt;
String result, inputResult, displayedResult;

//Create Minim objects
Minim minim;
Mixer mixer;
Mixer.Info[] mixerInfo;

//Environment Variables
boolean speaking = false;
String voice = "";

String name = "John";

int maxConnectWait = 300;
int relativeVolume = 35;
int connectionCounter = 0;
boolean headsetConnected = false;
int count = 0;

ArrayList<Command> commands = new ArrayList<Command>();

//Threads

Counter notificationCounter = new Counter(240);
Counter headestConnectionCounter = new Counter(600);
Counter autoRecordCounter = new Counter(1800);



void setup ()
{
  size(600, 200);
  frameRate(60);

  // Initialize STT
  stt = new STT(this);
  stt.enableDebug();
  stt.setLanguage("en"); 
  stt.enableAutoRecord();
  stt.disableAutoThreshold();
  stt.setThreshold(3.0);


  // Some text to display the result
  textFont(createFont("Arial", 14));
  displayedResult = "";
  inputResult = "";
  CreateCommands();

  DisplayNotification(name, "I've Launched");

  if (isHeadsetConnected("Sony Headset")) {
    ChangeSoundOutput("Headphones");
    ChangeSoundInput("Wireless Headset");
  } 
  else {
    ChangeSoundInput("Internal Microphone");
  }
}




void draw ()
{
  background(0);
  text(displayedResult, 20, 20);
  text(inputResult, 20, 60);

  ////CHECK COUNTERS
  //Check for notifications
  if (notificationCounter.countReached()) {
    CheckForNotifications();
  }
  //Make sure STT doesn't crap out
  if (autoRecordCounter.countReached()) {
    stt.disableAutoRecord();
    stt.enableAutoRecord();
  }
}




// Method is called if transcription was successfull 
void transcribe (String utterance, float confidence) 
{
  //println(utterance);
  if (!utterance.equals(""))
  {
    result = utterance;
    ListenForKeywords(result);
    println(result);
    inputResult = result;
    result = "";
    
    //CheckCommandValidity(result);
    
  }
}




void ListenForKeywords(String phrase)
{
  if (phrase.equals(name))
  {
    Greet();
  }
  else if (phrase.contains("thank you") || phrase.contains("thanks"))
  {
    Say("You\'re welcome.");
  }
  else if (phrase.contains("hello") || phrase.contains(" hi ") || phrase.contains("hey"))
  {
    Say("Good " + timeOfDay());
  }
  else if (phrase.contains("volume") && phrase.contains("up") || phrase.contains("volume") && phrase.contains("increase"))
  {
    Affirm();
    ArrayList tempSongVolume = shellExec("osascript -e \"output volume of (get volume settings)\"");
    int volume = 10 + Integer.parseInt((String)tempSongVolume.get(0));
    println((String)tempSongVolume.get(0) + " : " + volume);
    shellExec("osascript -e \"set volume output volume " + volume + "\"");
  }
  else if (phrase.contains("volume") && phrase.contains("down") || phrase.contains("volume") && phrase.contains("decrease"))
  {
    Affirm();
    ArrayList tempSongVolume = shellExec("osascript -e \"output volume of (get volume settings)\"");
    int volume = Integer.parseInt((String)tempSongVolume.get(0)) - 10;
    println((String)tempSongVolume.get(0) + " : " + volume);
    shellExec("osascript -e \"set volume output volume " + volume + "\"");
  }
  else if (phrase.contains("what song is this"))
  {
    ArrayList tempSongName = shellExec("osascript -e \"tell application \\\"iTunes\\\" to get name of current track\"");
    ArrayList tempArtistName = shellExec("osascript -e \"tell application \\\"iTunes\\\" to get artist of current track\"");

    String songName = (String)tempSongName.get(0);
    String artistName = (String)tempArtistName.get(0);
    Say("It\'s called \"" + songName + ",\" by " + artistName);
  }
  else if (phrase.contains("stop"))
  {
    Affirm();
    shellExec("osascript -e \"tell application \\\"iTunes\\\" to pause\"");
  }
  else if (phrase.contains("music visualizer"))
  {
    Affirm();
    shellExec("osascript -e \"tell application \\\"Music Visualizer\\\" to activate\"");
  }
  else if (phrase.contains("play"))
  {
    Affirm();
    shellExec("osascript -e \"tell application \\\"iTunes\\\" to play\"");
  }
  else if (phrase.contains("bluetooth"))
  {
    ArrayList lines = shellExec("system_profiler SPBluetoothDataType");
    for (int i = 0; i < lines.size()-1; i++) {
      String line = (String)lines.get(i);
      println(line);
    }
    Say("Here's what's connected.");
  }
  else if (phrase.contains("next"))
  {
    Affirm();
    shellExec("osascript -e \"tell application \\\"iTunes\\\" to next track\"");
  }
  else if (phrase.contains("back"))
  {
    Affirm();
    shellExec("osascript -e \"tell application \\\"iTunes\\\" to previous track\"");
  }
  else if (phrase.contains("goodbye") || phrase.contains("good bye") || phrase.contains("goodnight") || phrase.contains("visualizer"))
  {
    shellExec("osascript -e \"tell application \\\"MusicVisualizer\\\" to run\"");
    shellExec("osascript -e \"tell application \\\"MusicVisualizer\\\" to activate\"");
    //exit();
  }
  else if (phrase.contains("open") && phrase.contains("plex"))
  {
    Affirm();
    shellExec("osascript -e \"tell application \\\"Plex Home Theater\\\" to run\"");
    shellExec("osascript -e \"tell application \\\"Plex Home Theater\\\" to activate\"");
  }
  else if (phrase.contains("close") && phrase.contains("plex"))
  {
    Affirm();
    shellExec("osascript -e \"tell application \\\"Plex Home Theater\\\" to quit\"");
  }
}




String Parse(String string) {
  string = string.replace(" ", "\\ ");
  string = string.replace("(", "(");
  string = string.replace(")", ")");
  string = string.replace("\'", "\\'");
  return string;
}

