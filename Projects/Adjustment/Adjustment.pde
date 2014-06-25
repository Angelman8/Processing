import java.util.Map;

int personCount = 200;

int firstNamesCount = 10000;
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

HashMap<String,Moment> timeline = new HashMap<String,Moment>();

ArrayList <Person>people = new ArrayList<Person>();

Person person;

void setup() {
  size(600, 600);
  frameRate(30);
  background(0);

  InitializeNames();
  person = new Person();
//  for (int i = 0; i < personCount; i++) {
//    people.add(new Person());
//  }
}

void draw() {
  background(0);
  //for (int i = 0; i < people.size()-1; i++) {
    //Person person = people.get(i);
    text("Name: " + person.firstName + " " + person.middleName.charAt(0) + ". " + person.lastName, 10, 20);
    text("Age: " + person.age, 10, 40);
    if (person.gender == 0) {
      text("Gender: Female", 10, 60);
    } 
    else {
      text("Gender: Male", 10, 60);
    }
    text("Height: " + person.formattedHeight(), 10, 80);
    text("Weight: " + person.formattedWeight(), 10, 100);
    text("Openness: " + person.openness, 10, 140);
    text("Conscientiousness: " + person.conscientiousness, 10, 160);
    text("Extraversion: " + person.extraversion, 10, 180);
    text("Agreeableness: " + person.agreeableness, 10, 200);
    text("Neuroticism: " + person.neuroticism, 10, 220);
    
  //}
}

void keyPressed() {
  person = new Person();
}


