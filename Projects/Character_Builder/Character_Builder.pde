import java.util.Map;

int combatAdvantage = 2;
int flanking = 2;

ArrayList<PlayerCharacter> characters = new ArrayList<PlayerCharacter>();

void setup() {
  PlayerCharacter pc = new PlayerCharacter(1, "Ardent", 21, 13, 11, 9, 19, 12);
  Table table = loadTable("Classes.csv", "header");
  TableRow row = table.findRow("Ardent", "Class");
  println(row.getInt("FortitudeBonus"));
}

void draw() {
}

void mousePressed() {
  println(Roll(20));
}

