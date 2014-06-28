Table table;
Table genderized;

void setup() {
  size(300, 300);
  background(0);
  textSize(20);

  ArrayList <String>names = new ArrayList<String>();
  ArrayList <String>genderizedNames = new ArrayList<String>();

  table = loadTable("randomNames.csv", "header");

  for (TableRow row : table.rows()) {
    if (!names.contains(row.getString("firstName"))) {
      names.add(row.getString("firstName"));
      println(row.getString("firstName"));
    }
  }
  println(names.size());
}

void draw() {
  background(0);
  TableRow row = table.getRow(0);
  text(row.getString("firstName"), width/2 - 10, height/2);
}

void keyPressed() {
  TableRow row = table.getRow(0);
  String name = row.getString("firstName");
  if (key == CODED) {
    if (keyCode == LEFT) {
      //Male
      SaveGender(name, 1, 0);
    } 
    else if (keyCode == RIGHT) {
      //Female
      SaveGender(name, 0, 1);
    }
    else if (keyCode == UP) {
      //Unisex
      SaveGender(name, 1, 1);
    }
  }
}

void SaveGender(String name, int isMale, int isFemale) {
  String newNameRow = name + "," + isMale + "," + isFemale;
  Table genderized = loadTable("randomGenderizedNames.csv", "header");

  TableRow newRow = genderized.addRow();
  newRow.setString("name", name);
  newRow.setInt("male", isMale);
  newRow.setInt("female", isFemale);

  table.removeRow(0);

  saveTable(genderized, "data/randomGenderizedNames.csv");
  saveTable(table, "data/randomNames.csv");
  table = loadTable("randomNames.csv", "header");
}

