import com.getflourish.stt.*;
import ddf.minim.*;
import java.io.*;

STT stt;
String result, displayedResult;
boolean speaking = false;
String keyword = "John";

ArrayList<Command> commands = new ArrayList<Command>();

void setup ()
{
  size(600, 200);
  // Init STT automatically starts listening
  stt = new STT(this);
  stt.enableDebug();
  stt.setLanguage("en"); 
  stt.setThreshold(3.0);
  stt.enableAutoRecord();
  stt.setThreshold(3.0);

  // Some text to display the result
  textFont(createFont("Arial", 14));
  displayedResult = "Say something!";
  CreateCommands();
}

void draw ()
{
  background(0);
  stt.setThreshold(3.0);
  text(displayedResult, 20, 20);
  
}

// Method is called if transcription was successfull 
void transcribe (String utterance, float confidence) 
{
  //println(utterance);
  if (!utterance.equals(""))
  {
    result = utterance;
    displayedResult = result;
    ListenForKeyword(result);

    result = "";
  }
}

void ListenForKeyword(String phrase)
{
  if (phrase.equals("John"))
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
  else if (phrase.contains("next") && phrase.contains("song"))
  {
    Affirm();
    shellExec("osascript -e \"tell application \\\"iTunes\\\" to next track\"");
  }
  else if (phrase.contains("back") && phrase.contains("song"))
  {
    Affirm();
    shellExec("osascript -e \"tell application \\\"iTunes\\\" to previous track\"");
  }
  else if (phrase.contains("goodbye") || phrase.contains("good bye") || phrase.contains("goodnight"))
  {
    Say("Good bye for now, sir.");
    shellExec("osascript -e \"tell application \\\"MusicVisualizer\\\" to activate\"");
    exit();
  }
}


void LowerVolume() {
}

