class Relationship {
  String name;
  int personIndex;
  int intensity;
  
  Relationship(int _personIndex, String _name, int _intensity) {
    personIndex = _personIndex;
    name = _name;
    intensity = _intensity;
  }
  
  boolean compare(Relationship other) {
    if (name.equals(other.name) && personIndex == other.personIndex && intensity == other.intensity)
    return true;
    else
    return false;
  }
}
