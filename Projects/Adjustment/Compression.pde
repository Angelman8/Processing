byte[] compressPerson(Person person) {
  byte[] result;
  int lengthDiff;
  byte[] compressedName;
  
  //NAME
  //First Name
  lengthDiff = maxNameLength - person.firstName.length();
  result = person.firstName.getBytes();
  for(int i = 0; i < lengthDiff; i++)
    result = append(result, byte(32));
  //Middle Name
  lengthDiff = maxNameLength - person.middleName.length();
  for(int i = 0; i < person.middleName.length(); i++)
    result = append(result, byte(person.middleName.charAt(i)));
  for(int i = 0; i < lengthDiff; i++)
    result = append(result, byte(32));
  //Last Name
  lengthDiff = maxNameLength - person.lastName.length();
  for(int i = 0; i < person.lastName.length(); i++)
    result = append(result, byte(person.lastName.charAt(i)));
  for(int i = 0; i < lengthDiff; i++)
    result = append(result, byte(32));
    
  //Age
  result = append(result, byte(person.age));
  //Gender
  result = append(result, byte(person.gender));
  //Sexuality
  result = append(result, byte(person.sexuality));
  //Height
  result = append(result, byte(person.heightFeet()));
  result = append(result, byte(person.heightInches()));
  //Weight
  result = append(result, byte(person.weight/100));
  result = append(result, byte(round(person.weight) % 100));
  
  //STATS
  //Openness
  result = append(result, byte(person.openness));
  //Conscientiousness
  result = append(result, byte(person.conscientiousness));
  //Extraversion
  result = append(result, byte(person.extraversion));
  //Agreeableness
  result = append(result, byte(person.agreeableness));
  //Rationality
  result = append(result, byte(person.rationality));
  //Curiousity
  result = append(result, byte(person.curiousity));
  //Attention
  result = append(result, byte(person.attention));
  //Energy
  result = append(result, byte(person.energy));
  //Empathy
  result = append(result, byte(person.empathy));
  //Happiness
  result = append(result, byte(person.happiness));
  
  //Is Alive
  result = append(result, byte(person.isAlive));
  //Location
  result = append(result, byte(person.location));
  
  
  return result;
}


Person decompressPerson(byte[] byteArray) {
  String firstName = "";
  for(int i = 0; i < 11; i++) { firstName = firstName + (char)byteArray[i]; }
  firstName = trim(firstName);
  
  String middleName = "";
  for(int i = 11; i < 22; i++) { middleName = middleName + (char)byteArray[i]; }
  middleName = trim(middleName);
  
  String lastName = "";
  for(int i = 22; i < 33; i++) { lastName = lastName + (char)byteArray[i]; }
  lastName = trim(lastName);
  
  int age = byteArray[33];
  int gender = byteArray[34];
  int sexuality = byteArray[35];
  float height = Float.parseFloat(byteArray[36] + "." + byteArray[37]);
  float weight = (byteArray[38]*100) + byteArray[39];
  
  int openness = byteArray[40];
  int conscientiousness = byteArray[41];
  int extraversion = byteArray[42];
  int agreeableness = byteArray[43];
  int rationality = byteArray[44];
  int curiousity = byteArray[45];
  int attention = byteArray[46];
  int energy = byteArray[47];
  int empathy = byteArray[48];
  int happiness = byteArray[49];
  
  boolean isAlive = byteArray[50] == 1 ? true : false;
  
  int location = byteArray[51];
  
  Person result = new Person(firstName, middleName, lastName, gender, sexuality, 
  age, height, weight, openness, curiousity, conscientiousness, attention, 
  extraversion, energy, agreeableness, empathy, rationality, happiness, isAlive, location);
  return result;
}  
