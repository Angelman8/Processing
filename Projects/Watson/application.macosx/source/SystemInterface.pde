void ChangeSoundOutput(String output) {
  //Make sure the audio is properly channelled from Watson
  shellExec("osascript " + Parse(dataPath("ChangeAudioOutput.scpt")) + " \"" + output + "\"");
  println("Audio output set to " + output);
}



void ChangeSoundInput(String input) {
  //Connect/Reconnect STT Library to default input
  shellExec("osascript " + Parse(dataPath("ChangeAudioInput.scpt")) + " \"" + input + "\"");
  println("Audio input set to " + input);
  //Connect/Reconnect STT Library to default input
  ReconfigureSTT();
}


void ReconfigureSTT() {
  mixerInfo = AudioSystem.getMixerInfo();
  mixer = AudioSystem.getMixer(mixerInfo[0]);
  minim = stt.getMinimInstance();
  minim.setInputMixer(mixer);
  println("### Source set to: " + mixerInfo[0]);
  stt.enableDebug();
  stt.disableAutoRecord();
  stt.enableAutoRecord();
  stt.disableAutoThreshold();
  stt.setThreshold(3.0);
}




boolean isHeadsetConnected(String headsetName)
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




void DisplayNotification(String title, String content)
{
  shellExec("osascript -e \"display notification \\\"" + content + "\\\" with title \\\"" + title + "\\\"\"");
}




void CheckForNotifications()
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
