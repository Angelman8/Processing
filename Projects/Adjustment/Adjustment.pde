import java.util.Map;

int personCount = 200;

String seed = "";

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

HashMap<String, Moment> timeline = new HashMap<String, Moment>();

ArrayList <Person>people = new ArrayList<Person>();

Person person;

//INTERFACE VARIABLES
int focusIndex = 0;

void setup() {
  size(600, 600);
  frameRate(30);
  background(0);
  println("Seed: " + seed.hashCode());
  if (!seed.equals("")) {
    randomSeed(seed.hashCode());
  }
  
  
  InitializeNames();
  person = new Person();
  for (int i = 0; i < personCount; i++) {
    people.add(new Person());
  }
  
  println("---------------------------");
  
  byte[] personByte = compressPerson(people.get(0));
  println(personByte);
  Person newPerson = decompressPerson(personByte);
}

void draw() {
  background(0);
  
  Person person = people.get(focusIndex);
  text("Name: " + person.firstName + " " + person.lastName, 10, 20);
  text("Age: " + person.age, 10, 40);
  if (person.gender == 0) {
    text("Gender: Female", 10, 60);
  } 
  else {
    text("Gender: Male", 10, 60);
  }
  text("Height: " + person.formattedHeight(), 10, 80);
  text("Weight: " + person.formattedWeight(), 10, 100);

  text("Curiousity: " + person.curiousity + "/" + person.openness + " Openness", 10, 140);
  text("Attention: " + person.attention + "/" + person.conscientiousness + " Conscientiousness", 10, 160);
  text("Energy: " + person.energy + "/" + person.extraversion + " Extraversion", 10, 180);
  text("Empathy: " + person.empathy + "/" + person.agreeableness + " Agreeableness", 10, 200);
  text("Happiness: " + person.happiness + "/" + person.rationality + " Rationality", 10, 220);
  
  //drawGraph();
}

void keyPressed() {
  focusIndex++;
  if (focusIndex > people.size()-1) {
    focusIndex = 0;
  }
}

