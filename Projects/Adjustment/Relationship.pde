class Relationship {
  String name;
  int person1;
  int person2;
  int intensity;

  Relationship(int _person1, int _person2, String _name, int _intensity) {
    person1 = _person1;
    person2 = _person2;
    name = _name;
    intensity = _intensity;
  }
  
  boolean existsIn(ArrayList<Relationship> tempList) {
    for(int i = 0; i < tempList.size(); i++) {
      Relationship other = tempList.get(i);
      if (name.equals(other.name)&& person1 == other.person1 && person2 == other.person2 && intensity == other.intensity) {
        return true;
      }
    }
    return false;
  }
}

