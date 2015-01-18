int GetHigher(int val1, int val2) {
  int val = val1 >= val2 ? val1 : val2;
  return  val;
}

int GetModifier(int value) {
  int newValue = floor((value - 2) / 2);
  return newValue;
}

//void Load(String characterName) {
//  BufferedReader reader;
//  String line;
//  String hashPointer = "";
//  reader = createReader(characterName + ".csv");
//  boolean done = false;
//  while (!done) {
//    try {
//      line = reader.readLine();
//    } 
//    catch (IOException e) {
//      println(e);
//      line = null;
//    }
//    if (line != null && line.indexOf("== ") != -1) {
//      String[] pieces = split(line, "== ");
//      hashPointer = pieces[1];
//      println(hashPointer);
//    } 
//    else if (line == null) {
//      done = true;
//      break;
//    } 
//    else {
//      String[] pieces = split(line, ", ");
//      if (hashPointer.equals("ABILITIES")) {
//        abilities.put(pieces[0], new Ability(parseInt(pieces[1])));
//        println(pieces[0], pieces[1]);
//      }
//    }
//  }
//}

