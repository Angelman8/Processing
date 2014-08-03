class Event {
  int[] participants;
  String message;

  Event(int[] _participants, String _message) {
    participants = _participants;
    message = _message;
  }
}

ArrayList<Person> Interact(ArrayList<Person> tempPeople) {
  for (Person person : tempPeople) {
    person.energy--;
  }
  return tempPeople;
}

void Normalize(ArrayList<Person> people) {
  for (Person person : people) {
    if (person.energy > person.extraversion) {
      person.energy--;
    } 
    else if (person.energy < person.extraversion) {
      person.energy++;
    }
  }
}

