import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import com.getflourish.stt.*; 
import ddf.minim.*; 
import javax.sound.sampled.*; 
import java.io.*; 

import com.google.gson.reflect.*; 
import com.google.gson.internal.*; 
import com.getflourish.stt.*; 
import javaFlacEncoder.*; 
import com.google.gson.stream.*; 
import com.google.gson.internal.bind.*; 
import com.google.gson.*; 
import com.google.gson.annotations.*; 

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
String result, displayedResult;

//Environment Variables
boolean speaking = false;
String voice = "Oliver";

String name = "John";

int maxConnectWait = 300;
int connectionCounter = 0;
boolean headsetConnected = false;

ArrayList<Command> commands = new ArrayList<Command>();

//Minim



public void setup ()
{
  size(600, 200);
  frameRate(60);

  // Initialize STT
  stt = new STT(this);
  //stt.enableDebug();
  stt.setLanguage("en"); 
  stt.setThreshold(3.0f);
  stt.enableAutoRecord();

  //Initialize Minim stuff

  // Some text to display the result
  textFont(createFont("Arial", 14));
  displayedResult = "Say something!";
  CreateCommands();

  if (isHeadsetConnected("Sony Headset")) {
    ChangeSoundOutput("Headphones");
    ChangeSoundInput("Wireless Headset");
  }
}

public void draw ()
{
  background(0);
  stt.setThreshold(3.0f);
  text(displayedResult, 20, 20);
}

// Method is called if transcription was successfull 
public void transcribe (String utterance, float confidence) 
{
  //println(utterance);
  if (!utterance.equals(""))
  {
    result = utterance;
    displayedResult = result;
    ListenForname(result);

    result = "";
  }
}

public void ListenForname(String phrase)
{
  if (phrase.equals(name))
  {
    Greet();
  }
  else if (phrase.contains("thank you") || phrase.contains("thanks"))
  {
    Say ("You\'re welcome.");
  }
  else if (phrase.contains("volume") && phrase.contains("up"))
  {
    ArrayList tempSongVolume = shellExec("osascript -e \"tell application \\\"iTunes\\\" to set currentVolume to sound volume\"");
    int volume = 10 + Integer.parseInt((String)tempSongVolume.get(0));
    shellExec("osascript -e \"tell application \\\"iTunes\\\" to set sound volume to " + volume + "\"");
    Affirm();
  }
  else if (phrase.contains("volume") && phrase.contains("down"))
  {
    ArrayList tempSongVolume = shellExec("osascript -e \"tell application \\\"iTunes\\\" to set currentVolume to sound volume\"");
    int volume = Integer.parseInt((String)tempSongVolume.get(0)) - 10;
    shellExec("osascript -e \"tell application \\\"iTunes\\\" to set sound volume to " + volume + "\"");
    Affirm();
  }
  else if (phrase.contains("what song is this"))
  {
    ArrayList tempSongName = shellExec("osascript -e \"tell application \\\"iTunes\\\" to get name of current track\"");
    ArrayList tempArtistName = shellExec("osascript -e \"tell application \\\"iTunes\\\" to get artist of current track\"");

    String songName = (String)tempSongName.get(0);
    String artistName = (String)tempArtistName.get(0);
    Say("It\'s called " + songName + ", by " + artistName);
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
  else if (phrase.contains("goodbye") || phrase.contains("good bye") || phrase.contains("goodnight"))
  {
    Say("Good bye for now, sir.");
    shellExec("osascript -e \"tell application \\\"MusicVisualizer\\\" to run\"");
    shellExec("osascript -e \"tell application \\\"MusicVisualizer\\\" to activate\"");
    //exit();
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

  public boolean Check(String input) {
    for (int i = 0; i < keywords.size()-1; i++) {
      String keyword = (String)keywords.get(i);
      if (input.contains(keyword)) {
        return true;
      }
    }
    return false;
  }

  public ArrayList Run() {
    ArrayList lines = new ArrayList();
    for (int i = 0; i < actions.size()-1; i++) {
      String action = (String)actions.get(i);
      lines.add(shellExec(action));
    }
    return lines;
  } 
}

public void CreateCommands() {
    commands.add(new Command(new ArrayList<String>(){{add("hello"); add("hi"); add("hey");}}, new ArrayList<String>(){{add("say Why Hello there.");}} ));
}
class Context {
  
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
public void Say(String phrase)
{
  phrase = phrase.replace("(", "");
  phrase = phrase.replace(")", "");
  phrase = phrase.replace("\'", "\\'");
  println(phrase);
  
  speaking = true;
  ArrayList tempSongVolume = shellExec("osascript -e \"tell application \\\"iTunes\\\" to set currentVolume to sound volume\"");
  shellExec("osascript -e \"tell application \\\"iTunes\\\" to set sound volume to 70\"");
  shellExec("say -v \"" + voice + "\" " + phrase);
  shellExec("osascript -e \"tell application \\\"iTunes\\\" to set sound volume to " + (String)tempSongVolume.get(0) + "\"");
  speaking = false;
}

public void Affirm()
{
  ArrayList affirmations = new ArrayList(){{ add("Alright."); add("Sure."); add("Of course."); add("Right away."); add("On it."); add("Okay."); add("Yes sir."); add("Kay."); add(""); }};
  
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

public void ChangeSoundOutput(String output) {

  shellExec("osascript " + Parse(dataPath("ChangeAudioOutput.scpt")) + " \"" + output + "\"");
  println("Audio output set to " + output);
}
public void ChangeSoundInput(String input) {

  shellExec("osascript " + Parse(dataPath("ChangeAudioInput.scpt")) + " \"" + input + "\"");
  println("Audio input set to " + input);
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
        //println(headsetName + " is Connected");
        return true;
      } 
      else {
        //println(headsetName + " is Disconnected");
        return false;
      }
    } 
    else {
    }
  }
  println("Could not find " + headsetName);
  return false;
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
