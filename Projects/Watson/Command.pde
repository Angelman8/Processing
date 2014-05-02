class Command {
  ArrayList<String> keywords;
  ArrayList<String> actions;

  Command(ArrayList tempKeywords, ArrayList tempActions) {
    keywords = tempKeywords;
    actions = tempActions;
  }




  int validity(String phrase) {
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

  ArrayList Handle() {
    ArrayList lines = new ArrayList();
    for (int i = 0; i < actions.size(); i++) {
      String action = (String)actions.get(i);
      lines.add(shellExec(action));
    }
    return lines;
  }
}




void CreateCommands() {
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




void CheckCommandValidity(String phrase)
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

