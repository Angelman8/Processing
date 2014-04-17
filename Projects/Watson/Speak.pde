void Say(String phrase)
{
  phrase = phrase.replace("(", "");
  phrase = phrase.replace(")", "");
  phrase = phrase.replace("\'", "\\'");
  print(phrase);
  
  speaking = true;
  ArrayList tempSongVolume = shellExec("osascript -e \"tell application \\\"iTunes\\\" to set currentVolume to sound volume\"");
  shellExec("osascript -e \"tell application \\\"iTunes\\\" to set sound volume to 70\"");
  shellExec("say " + phrase);
  shellExec("osascript -e \"tell application \\\"iTunes\\\" to set sound volume to " + (String)tempSongVolume.get(0) + "\"");
  speaking = false;
}

void Affirm()
{
  ArrayList affirmations = new ArrayList(){{ add("Alright."); add("Sure."); add("Of course."); add("Right away."); add("On it."); add("Okay."); add("Yes sir."); add("Kay."); add(""); }};
  
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

