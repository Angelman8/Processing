class PlayerCharacter {

  int level;
  int XP;
  String race = "";
  String classType = "";

  int HP;
  int initiative;
  int speed;
  int passiveInsight;
  int passivePerception;

  int armourBonus = 0;
  int shieldBonus = 0;

  HashMap<String, Integer> abilities = new HashMap<String, Integer>();
  HashMap<String, Defense> defenses = new HashMap<String, Defense>();
  HashMap<String, Skill> skills = new HashMap<String, Skill>();

  HashMap<String, Language> languages = new HashMap<String, Language>();

  PlayerCharacter(int _level, String _classType, int _strength, int _constitution, int _dexterity, int _intelligence, int _wisdom, int _charisma) {
    level = _level;
    classType = _classType;
    abilities.put("Strength", _strength);
    abilities.put("Constitution", _constitution);
    abilities.put("Dexterity", _dexterity);
    abilities.put("Intelligence", _intelligence);
    abilities.put("Wisdom", _wisdom);
    abilities.put("Charisma", _charisma);
    defenses.put("AC", new Defense(true, true));
    defenses.put("Fortitude", new Defense(false, false));
    defenses.put("Reflex", new Defense(false, true));
    defenses.put("Will", new Defense(false, false));
  }

  int LevelModifier() {
    int value = floor(level/2);
    return value;
  }
  
  int MaxHP() {
    int value = HP;
    return value;
  }
  
  boolean Bloodied() {
    if (HP < floor(MaxHP/2)) {
      return true;
    } else {
      return false;
    }
  }

  int AC() {
    int value = defenses.get("AC").value(LevelModifier(), GetHigher(abilities.get("Dexterity"), abilities.get("Intelligence")), armourBonus, shieldBonus);
    return value;
  }

  int Fortitude() {
    int value = defenses.get("Fortitude").value(LevelModifier(), GetHigher(abilities.get("Strength"), abilities.get("Constitution")), armourBonus, shieldBonus);
    return value;
  }

  int Reflex() {
    int value = defenses.get("Reflex").value(LevelModifier(), GetHigher(abilities.get("Dexterity"), abilities.get("Intelligence")), armourBonus, shieldBonus);
    return value;
  }

  int Will() {
    int value = defenses.get("Will").value(LevelModifier(), GetHigher(abilities.get("Wisdom"), abilities.get("Charisma")), armourBonus, shieldBonus);
    return value;
  }
}

