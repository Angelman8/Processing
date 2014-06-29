import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import com.getflourish.stt.*; 
import ddf.minim.*; 
import javax.sound.sampled.*; 
import java.io.*; 

import edu.cmu.sphinx.frontend.frequencywarp.*; 
import edu.cmu.sphinx.jsgf.parser.*; 
import edu.cmu.sphinx.result.*; 
import edu.cmu.sphinx.decoder.*; 
import com.google.gson.annotations.*; 
import edu.cmu.sphinx.util.props.*; 
import edu.cmu.sphinx.linguist.language.ngram.large.*; 
import edu.cmu.sphinx.linguist.flat.*; 
import javaFlacEncoder.*; 
import edu.cmu.sphinx.linguist.language.grammar.*; 
import edu.cmu.sphinx.linguist.acoustic.tiedstate.*; 
import edu.cmu.sphinx.linguist.acoustic.trivial.*; 
import com.google.gson.internal.*; 
import edu.cmu.sphinx.decoder.scorer.*; 
import edu.cmu.sphinx.util.*; 
import edu.cmu.sphinx.linguist.language.ngram.*; 
import edu.cmu.sphinx.util.props.tools.*; 
import edu.cmu.sphinx.frontend.databranch.*; 
import com.google.gson.stream.*; 
import edu.cmu.sphinx.frontend.util.*; 
import edu.cmu.sphinx.linguist.dictionary.*; 
import edu.cmu.sphinx.linguist.acoustic.*; 
import com.google.gson.internal.bind.*; 
import edu.cmu.sphinx.linguist.*; 
import edu.cmu.sphinx.frontend.*; 
import edu.cmu.sphinx.instrumentation.*; 
import edu.cmu.sphinx.frontend.endpoint.*; 
import edu.cmu.sphinx.frontend.transform.*; 
import edu.cmu.sphinx.linguist.language.classes.*; 
import edu.cmu.sphinx.frontend.filter.*; 
import edu.cmu.sphinx.decoder.pruner.*; 
import edu.cmu.sphinx.jsgf.*; 
import com.google.gson.*; 
import edu.cmu.sphinx.research.parallel.*; 
import edu.cmu.sphinx.frontend.window.*; 
import edu.cmu.sphinx.jsgf.rule.*; 
import com.getflourish.stt.*; 
import edu.cmu.sphinx.recognizer.*; 
import com.google.gson.reflect.*; 
import edu.cmu.sphinx.linguist.dflat.*; 
import edu.cmu.sphinx.decoder.search.*; 
import edu.cmu.sphinx.linguist.util.*; 
import edu.cmu.sphinx.frontend.feature.*; 
import edu.cmu.sphinx.decoder.search.stats.*; 
import edu.cmu.sphinx.util.machlearn.*; 
import edu.cmu.sphinx.linguist.acoustic.tiedstate.HTK.*; 
import edu.cmu.sphinx.linguist.lextree.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Watson extends PApplet {






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



public void setup ()
{
  size(600, 200);
  frameRate(20);

  // Initialize STT
  stt = new STT(this);
  //stt.enableDebug();
  stt.setLanguage("en"); 
  stt.enableAutoRecord();
  stt.disableAutoThreshold();
  stt.setThreshold(3.0f);


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




public void draw ()
{
  background(0);
  text(displayedResult, 20, 20);
  text(inputResult, 20, 60);

  ////CHECK COUNTERS
  //Check for notifications
  if (notificationCounter.countReached()) {
    CheckForNotifications();
  }
//  //Make sure STT doesn't crap out
//  if (autoRecordCounter.countReached()) {
//    stt.disableAutoRecord();
//    stt.enableAutoRecord();
//  }
}




// Method is called if transcription was successfull 
public void transcribe (String utterance, float confidence) 
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




public void ListenForKeywords(String phrase)
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
    Say("Good bye for now, sir.");
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




public String Parse(String string) {
  string = string.replace(" ", "\\ ");
  string = string.replace("(", "(");
  string = string.replace(")", ")");
  string = string.replace("\'", "\\'");
  return string;
}

class Command {
  ArrayList<String> keywords;
  ArrayList<String> actions;

  Command(ArrayList tempKeywords, ArrayList tempActions) {
    keywords = tempKeywords;
    actions = tempActions;
  }




  public int validity(String phrase) {
    String input = phrase;
    int count = 0;
    for (int i = 0; i < keywords.size(); i++) {
      String keyword = (String)keywords.get(i);
      if (input.contains((String)keyword)) {
        count++;
        println(keyword + " found. " + count);
      }
    }
    return count;
  }

  public ArrayList Handle() {
    ArrayList lines = new ArrayList();
    for (int i = 0; i < actions.size(); i++) {
      String action = (String)actions.get(i);
      lines.add(shellExec(action));
    }
    return lines;
  }
}




public void CreateCommands() {
  commands.add(new Command(new ArrayList<String>() {
    {
      add("hello"); 
      add("hi"); 
      add("hey");
    }
  }
  , new ArrayList<String>() {
    {
      add("say Why Hello there.");
    }
  } 
  ));
}




public void CheckCommandValidity(String phrase)
{
  int highestValidity = 0;
  Command mostValid = null; 
  for (int i = 0; i < commands.size(); i++) {
    Command command = commands.get(i);
    if (command.validity(phrase) > highestValidity) {
      mostValid = command;
    }
  }
  if (mostValid != null)
  {
    mostValid.Handle();
  }
}

class Context {
  
}
class Counter {
  int counter = 0;
  int max;
  
  public boolean countReached() {
    if (counter >= max) {
      counter = 0;
      return true;
    } else {
      counter++;
      return false;
    }
  }
  
  Counter(int tempMax) {
    max = tempMax;
  }
  
  public void SetMaxCount(int val) {
    max = val;
  } 
}
public ArrayList shellExec ( String command )
{
  return shellExec ( new String[]{ "/bin/bash", "-c", command } );
}




public ArrayList shellExec ( String[] command )
{
  ArrayList lines = new ArrayList();
  try {
    Process process = Runtime.getRuntime().exec ( command );
    
    BufferedReader inBufferedReader  = new BufferedReader( new InputStreamReader ( process.getInputStream() ) );
    BufferedReader errBufferedReader = new BufferedReader( new InputStreamReader ( process.getErrorStream() ) );
    
    String line, eline;
    while ( (line  = inBufferedReader.readLine() ) != null && !errBufferedReader.ready() )
    {
  lines.add(line);
    }
    if ( errBufferedReader.ready() ) {
  while ( (eline  = errBufferedReader.readLine() ) != null )
  {
    println( eline );
  }
  return null;
    }
    int exitVal = process.waitFor();
    
    inBufferedReader.close();  process.getInputStream().close();
    errBufferedReader.close(); process.getErrorStream().close();
  }
  catch (Exception e)
  {
    e.printStackTrace();
    return null;
  }
  
  return lines;
}
class Person {
  String firstName, lastName;
  int age;
  
}
public void Say(String phrase)
{
  displayedResult = phrase;

  speaking = true;
  ArrayList tempSongVolume = shellExec("osascript -e \"tell application \\\"iTunes\\\" to set currentVolume to sound volume\"");
  if (Integer.parseInt((String)tempSongVolume.get(0)) > 60)
    shellExec("osascript -e \"tell application \\\"iTunes\\\" to set sound volume to 60\"");
  ArrayList systemVolume = shellExec("osascript -e \"output volume of (get volume settings)\"");
  if (Integer.parseInt((String)systemVolume.get(0)) > relativeVolume)
    shellExec("osascript -e \"set volume output volume " + relativeVolume + "\"");
    String customVoice = "";
    if(!voice.equals("")) { customVoice = "-v"; } else { customVoice = ""; }
  shellExec("say " + customVoice + " \"" + voice + "\" " + Parse(phrase));
  shellExec("osascript -e \"tell application \\\"iTunes\\\" to set sound volume to " + (String)tempSongVolume.get(0) + "\"");
  shellExec("osascript -e \"set volume output volume " + (String)systemVolume.get(0) + "\"");
  speaking = false;
}




public void Affirm()
{
  ArrayList affirmations = new ArrayList() {
    { 
      add("Alright,");
      add("Right away."); 
      add("On it."); 
      add("Okay."); 
      add("Yes sir."); 
      add("Okay sir."); 
      add(" ");
    }
  };

  int index = (int)random(0, affirmations.size()-1);
  String affirm = (String)affirmations.get(index);
  Say(affirm);
}




public void Greet()
{
  ArrayList greetings = new ArrayList();
  greetings.add("Yes sir?");
  greetings.add("Yes?");
  greetings.add("How can I help?");
  greetings.add("What can I do for you?");

  int index = (int)random(0, greetings.size()-1);
  String greet = (String)greetings.get(index);
  Say(greet);
}




public void Interrupt()
{
  ArrayList interruptions = new ArrayList();
  interruptions.add("Excuse me, ");
  interruptions.add("Pardon the interruption, ");
  interruptions.add("Sorry to interrupt, ");
  interruptions.add("Pardon me, ");

  int index = (int)random(0, interruptions.size()-1);
  String interruption = (String)interruptions.get(index);
  Say(interruption);
}




public String timeOfDay()
{
  String daytime = "";
  if (hour() <= 11) {
  daytime = "morning";
  } else if (hour() > 11 && hour() <= 17) {
    daytime = "afternoon";
  } else {
    daytime = "evening";
  }
  return daytime;
}
public void ChangeSoundOutput(String output) {
  //Make sure the audio is properly channelled from Watson
  shellExec("osascript " + Parse(dataPath("ChangeAudioOutput.scpt")) + " \"" + output + "\"");
  println("Audio output set to " + output);
}



public void ChangeSoundInput(String input) {
  //Connect/Reconnect STT Library to default input
  shellExec("osascript " + Parse(dataPath("ChangeAudioInput.scpt")) + " \"" + input + "\"");
  println("Audio input set to " + input);
  //Connect/Reconnect STT Library to default input
  ReconfigureSTT();
}


public void ReconfigureSTT() {
  mixerInfo = AudioSystem.getMixerInfo();
  mixer = AudioSystem.getMixer(mixerInfo[0]);
  minim = stt.getMinimInstance();
  minim.setInputMixer(mixer);
  println("### Source set to: " + mixerInfo[0]);
  stt.enableDebug();
  stt.disableAutoRecord();
  stt.enableAutoRecord();
  stt.disableAutoThreshold();
  stt.setThreshold(3.0f);
}




public boolean isHeadsetConnected(String headsetName)
{
  connectionCounter = 0;
  ArrayList lines = shellExec("system_profiler SPBluetoothDataType");
  for (int i = 0; i < lines.size()-1; i++) {
    String line = (String)lines.get(i);
    if (line.contains(headsetName)) {
      String connected = (String)lines.get(i+7);
      if (connected.contains("Yes")) {
        println(headsetName + " is Connected");
        return true;
      } 
      else {
        println(headsetName + " is Disconnected");
        return false;
      }
    } 
    else {
    }
  }
  println("Could not find " + headsetName);
  return false;
}




public void DisplayNotification(String title, String content)
{
  shellExec("osascript -e \"display notification \\\"" + content + "\\\" with title \\\"" + title + "\\\"\"");
}




public void CheckForNotifications()
{
  ArrayList notifications = shellExec("osascript " + Parse(dataPath("GetNotifications.scpt")));
  for (int i = 0; i < notifications.size(); i++) {
    String[] notification = split((String)notifications.get(i), ",");
    if (!notification[0].equals("")) {
      Interrupt();
      Say("there's a notification from " + notification[0] + ", saying, \"" + notification[1] + "\"");
    }
  }
  notifications.clear();
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Watson" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
