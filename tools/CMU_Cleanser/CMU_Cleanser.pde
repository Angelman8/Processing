String lines[] = loadStrings("common-words.csv");
String finalWords = "";
println("there are " + lines.length + " lines");
for (int i = 0 ; i < lines.length; i++) {
  if (i > 0) {
    finalWords += "| ";
  }
  finalWords += lines[i] + " ";
}
String grammarLines[] = loadStrings("grammar_template.txt");
grammarLines[8] = " public <WORDS> = ( " + finalWords.toUpperCase() + " ) *;";
saveStrings("upstairs.gram", grammarLines);
