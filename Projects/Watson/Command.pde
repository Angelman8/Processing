class Command {
  ArrayList<String> keywords;
  ArrayList<String> actions;

  Command(ArrayList tempKeywords, ArrayList tempActions) {
    keywords = tempKeywords;
    actions = tempActions;
  }

  boolean isValid(String input) {
    for (int i = 0; i < keywords.size()-1; i++) {
      String keyword = (String)keywords.get(i);
      if (input.contains(keyword)) {
        return true;
      }
    }
    return false;
  }

  ArrayList Handle() {
    ArrayList lines = new ArrayList();
    for (int i = 0; i < actions.size()-1; i++) {
      String action = (String)actions.get(i);
      lines.add(shellExec(action));
    }
    return lines;
  } 
}

void CreateCommands() {
    commands.add(new Command(new ArrayList<String>(){{add("hello"); add("hi"); add("hey");}}, new ArrayList<String>(){{add("say Why Hello there.");}} ));
}
