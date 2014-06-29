class Person {
  int age;
  String firstName, middleName, lastName;
  int gender, sexuality;
  float height, weight;
  boolean isAlive;
  ArrayList <Relationship> family = new ArrayList<Relationship>();

  //Attributes (Baseline, Temporary):
  float openness, curiousity;
  float conscientiousness, attention;
  float extraversion, energy;
  float agreeableness, empathy;
  float rationality, happiness;

  Person() {
    gender = (int)random(0, 2);
    firstName = (gender == 0 ? femaleNames.get((int)random(0, femaleNames.size()-1)) : maleNames.get((int)random(0, maleNames.size()-1)));
    middleName = (gender == 0 ? femaleNames.get((int)random(0, femaleNames.size()-1)) : maleNames.get((int)random(0, maleNames.size()-1)));
    lastName = lastNames.get((int)random(0, lastNames.size()-1));
    sexuality = (int)random(0, 100);
    age = (int)Math.abs((averageAge + randomGaussian()*4 + random(-10, 40)));
    height = (gender == 0 ? averageHeightW : averageHeightM) + randomGaussian()*.25;
    weight = (gender == 0 ? averageWeightW : averageWeightM) + randomGaussian()*10 + random(-10, 30);

    openness = round(random(0, 10));
    curiousity = openness;
    conscientiousness = round(random(0, 10));
    attention = conscientiousness;
    extraversion = round(random(0, 10));
    energy = extraversion;
    agreeableness = round(random(0, 10));
    empathy = agreeableness;
    rationality = round(random(0, 10));
    happiness = rationality;
    isAlive = true;
  }

  Person(String _firstName, String _middleName, String _lastName, int _gender, int _sexuality, int _age, float _height, float _weight, 
  int _openness, int _curiousity, int _conscientiousness, int _attention, int _extraversion, int _energy, 
  int _agreeableness, int _empathy, int _rationality, int _happiness, boolean _isAlive) {
    firstName = _firstName;
    middleName = _middleName;
    lastName = _lastName;
    gender = _gender;
    sexuality = _sexuality;
    age = _age;
    height = _height;
    weight = _weight;

    openness = _openness;
    curiousity = _curiousity;
    conscientiousness = _conscientiousness;
    attention = _attention;
    extraversion = _extraversion;
    energy = _energy;
    agreeableness = _agreeableness;
    empathy = _empathy;
    rationality = _rationality;
    happiness = _happiness;
    isAlive = _isAlive;
  }

  String formattedHeight() {
    String roundedHeight = String.format("%.1f", height);
    String[] splitHeight = split(roundedHeight, '.');
    return splitHeight[0] + "\'" + splitHeight[1] + "\"";
  }

  int heightFeet() {
    String roundedHeight = String.format("%.1f", height);
    String[] splitHeight = split(roundedHeight, '.');
    return Integer.parseInt(splitHeight[0]);
  }

  int heightInches() {
    String roundedHeight = String.format("%.1f", height);
    String[] splitHeight = split(roundedHeight, '.');
    return Integer.parseInt(splitHeight[1]);
  }

  String formattedWeight() {
    String roundedWeight = String.format("%.0f", weight);
    return roundedWeight + " lbs.";
  }

  void checkForFamily(ArrayList<Person> people, int thisIndex) {
    for (int i = 0; i < people.size()-1; i++) {
      Person other = people.get(i);
      if (lastName.equals(other.lastName) && !firstName.equals(other.firstName)) {
        
        if (abs(age - other.age) >= 1 && abs(age - other.age) < 10) {
         other.family.add(new Relationship(thisIndex, gender == 1 ? "Brother" : "Sister", -1));
         }
      }
    }
  }
}

