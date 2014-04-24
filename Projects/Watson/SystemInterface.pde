void ChangeSoundOutput(String output) {

  shellExec("osascript " + Parse(dataPath("ChangeAudioOutput.scpt")) + " \"" + output + "\"");
  println("Audio output set to " + output);
}
void ChangeSoundInput(String input) {

  shellExec("osascript " + Parse(dataPath("ChangeAudioInput.scpt")) + " \"" + input + "\"");
  println("Audio input set to " + input);
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
