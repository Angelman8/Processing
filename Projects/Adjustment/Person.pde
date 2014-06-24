class Person {
  int age;
  String firstName, middleName, lastName;
  int gender;
  float sexuality;
  float height;
  float weight;
  
  //Averages
  
  Person() {
    gender = (int)random(0,2);
    firstName = firstNames.get((int)random(0, firstNames.size()-1));
    middleName = firstNames.get((int)random(0, firstNames.size()-1));
    lastName = lastNames.get((int)random(0, lastNames.size()-1));
    sexuality = random(0.0,100.0);
    age = (int)Math.abs((averageAge + randomGaussian()*9 + random(-7,20)));
    height = (gender == 0 ? averageHeightW : averageHeightM) + randomGaussian()*.25;
    weight = (gender == 0 ? averageWeightW : averageWeightM) + randomGaussian()*25;
  }
  
  String formattedHeight() {
    String roundedHeight = String.format("%.1f", height);
    String[] splitHeight = split(roundedHeight, '.');
    return splitHeight[0] + "\'" + splitHeight[1] + "\"";
  }
  
  String formattedWeight() {
    String roundedWeight = String.format("%.0f", weight);
    return roundedWeight + " lbs.";
  }
}
