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
