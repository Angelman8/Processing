int personCount = 200;

int firstNamesCount = 10000;
int lastNamesCount = 200;

ArrayList <String>firstNames = new ArrayList<String>();
ArrayList <String>lastNames = new ArrayList<String>();

ArrayList humans = new ArrayList();

Person person;

void setup() {
  size(600, 600);
  frameRate(60);
  background(0);

  InitializeNames();
  CreatePerson();
}

void draw() {
  background(0);
  text("Name: " + person.firstName + " " + person.middleName.charAt(0) + ". " + person.lastName, 10, 20);
  text("Age: " + person.age, 10, 40);
  text("Height: " + person.height, 10, 60);
  text("Weight: " + person.weight, 10, 80);
}

void keyPressed() {
  CreatePerson();
}

void CreatePerson() {
  person = new Person(
  firstNames.get((int)random(0, firstNames.size()-1)), 
  firstNames.get((int)random(0, firstNames.size()-1)), 
  lastNames.get((int)random(0, lastNames.size()-1)), 
  (int)Math.abs((30 + randomGaussian()*10 + random(-5,20))), 
  5.7 + randomGaussian()*.28, 
  190 + randomGaussian()*30
    );
}
