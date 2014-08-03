import java.util.Map;

String SEED = "Galen";

int MAXPEOPLE = 20;
int DAYS = 120;
int timelineScale = 10;

int firstNamesCount = 10000;
int maxNameLength = 11;
int lastNamesCount = 200;

//Average Attributes
int averageAge = 30;
float averageHeightM = 5.9;
float averageHeightW = 5.4;
float averageWeightM = 180;
float averageWeightW = 130;


ArrayList <String>femaleNames = new ArrayList<String>();
ArrayList <String>maleNames = new ArrayList<String>();
ArrayList <String>firstNames = new ArrayList<String>();
ArrayList <String>lastNames = new ArrayList<String>();

ArrayList <Person> people = new ArrayList<Person>();
ArrayList <Relationship> relationships = new ArrayList <Relationship>();


//INTERFACE VARIABLES
int focusIndex = 0;

Timeline timeline;

void setup() {
  size(1300, 800);
  frameRate(30);
  background(0);
  println("SEED: " + SEED.hashCode());
  if (!SEED.equals("")) {
    randomSeed(SEED.hashCode());
  }

  timeline = new Timeline(DAYS);

  getNames();
  for (int i = 0; i < MAXPEOPLE; i++) {
    people.add(new Person());
  }

  println("---------------------------");
  for (int i = 0; i < MAXPEOPLE; i++) {
    Person person = people.get(i);
    person.checkForFamily(people, i);
  }
}

void draw() {
  background(0);
  stroke(255);
  fill(255);
  int lineCount = 1;

  text("PEOPLE:", 10, 20 * lineCount);
  lineCount++;
  text("Person: " + (focusIndex + 1) + "/" + people.size(), 200, 20 * lineCount);

  Person person = people.get(focusIndex);
  text("Name: " + person.firstName + " " + person.lastName, 10, 20 * lineCount);
  lineCount++;
  text("Age: " + person.age, 10, 20 * lineCount);
  lineCount++;
  if (person.gender == 0) {
    text("Gender: Female", 10, 20 * lineCount);
    lineCount++;
  } 
  else {
    text("Gender: Male", 10, 20 * lineCount);
    lineCount++;
  }
  text("Height: " + person.formattedHeight(), 10, 20 * lineCount);
  lineCount++;
  text("Weight: " + person.formattedWeight(), 10, 20 * lineCount);
  lineCount += 2;

  text("Location: " + person.location, 10, 20 * lineCount);
  lineCount++;

  text("Curiousity: " + person.curiousity + "/" + person.openness + " Openness", 10, 20 * lineCount);
  lineCount++;
  text("Attention: " + person.attention + "/" + person.conscientiousness + " Conscientiousness", 10, 20 * lineCount);
  lineCount++;
  text("Energy: " + person.energy + "/" + person.extraversion + " Extraversion", 10, 20 * lineCount);
  lineCount++;
  text("Empathy: " + person.empathy + "/" + person.agreeableness + " Agreeableness", 10, 20 * lineCount);
  lineCount++;
  text("Happiness: " + person.happiness + "/" + person.rationality + " Rationality", 10, 20 * lineCount);
  lineCount += 2;
  text("FAMILY MEMBERS: ", 10, 20 * lineCount);
  lineCount++;

  for (int i = 0; i < relationships.size(); i++) {
    Relationship relationship = relationships.get(i);
    if (relationship.person1 == focusIndex) {
      Person familyMember = people.get(relationship.person2);
      text(familyMember.firstName + " " + familyMember.lastName + " (" + (relationship.name.equals("Sibling") && familyMember.gender == 0 ? "Sister" : "Brother") + ", " + familyMember.age + ")", 10, 20 * lineCount);
      lineCount++;
    } 
    else if (relationship.person2 == focusIndex) {
      Person familyMember = people.get(relationship.person1);
      text(familyMember.firstName + " " + familyMember.lastName + " (" + (relationship.name.equals("Sibling") && familyMember.gender == 0 ? "Sister" : "Brother") + ", " + familyMember.age + ")", 10, 20 * lineCount);
      lineCount++;
    }
  }

  timeline.draw(10, 500);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      focusIndex--;
    } 
    else if (keyCode == RIGHT) {
      focusIndex++;
    }
  }

  if (key == 'q') {
    timeline.propagate(0, people);
  }
  if (key == 'w') {
    timeline.propagate(10, people);
  }
  if (key == 'e') {
    timeline.propagate(20, people);
  }
  if (key == 'r') {
    timeline.propagate(30, people);
  }
  if (key == 't') {
    timeline.propagate(40, people);
  }
  if (key == 'y') {
    timeline.propagate(50, people);
  }

  if (focusIndex > people.size()-1) {
    focusIndex = 0;
  } 
  else if (focusIndex < 0) {
    focusIndex = people.size()-1;
  }
}

