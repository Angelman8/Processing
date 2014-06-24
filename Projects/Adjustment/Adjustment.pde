int personCount = 200;

int firstNamesCount = 10000;
int lastNamesCount = 200;

//Average Attributes
int averageAge = 30;
float averageHeightM = 5.9;
float averageHeightW = 5.4;
float averageWeightM = 180;
float averageWeightW = 140;



ArrayList <String>firstNames = new ArrayList<String>();
ArrayList <String>lastNames = new ArrayList<String>();

ArrayList humans = new ArrayList();

Person person;

void setup() {
  size(600, 600);
  frameRate(60);
  background(0);

  InitializeNames();
  person = new Person();
}

void draw() {
  background(0);
  text("Name: " + person.firstName + " " + person.middleName + " " + person.lastName, 10, 20);
  text("Age: " + person.age, 10, 40);
  if (person.gender == 0) {
    text("Gender: Female", 10, 60);
  } else {
    text("Gender: Male", 10, 60);
  }
  text("Height: " + person.formattedHeight(), 10, 80);
  text("Weight: " + person.formattedWeight(), 10, 100);
}

void keyPressed() {
  person = new Person();
}
