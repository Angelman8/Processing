void Say(String phrase)
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




void Affirm()
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




void Greet()
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




void Interrupt()
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




String timeOfDay()
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
