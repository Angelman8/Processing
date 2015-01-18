class Defense {

  boolean hasArmourBonus = false;
  boolean hasShieldBonus = false;
  
  int racialBonus = 0;
  int featBonus = 0;
  int classBonus = 0;
  int powerBonus = 0;
  int enhancementBonus = 0;
  int itemBonus = 0;
  int miscBonus = 0;  
  
  int value(int levelModifier, int baseStatModifier, int armourBonus, int shieldBonus) {
    int val = 10 + levelModifier + baseStatModifier + racialBonus + classBonus + featBonus + powerBonus + enhancementBonus + itemBonus + miscBonus;
    val += hasArmourBonus ? armourBonus : 0;
    val += hasShieldBonus ? shieldBonus : 0;
    return val;
  }

  Defense(boolean _armourBonus, boolean _shieldBonus) {
    hasArmourBonus = _armourBonus;
    hasShieldBonus = _shieldBonus;
  }
}

class Skill {
  String base = "";
  int value;
  boolean trained = false;

  Skill(int _value, String _base, boolean _trained) {
    value = _value;
    base = _base;
    trained = _trained;
  }

  int Check(int level) {
    int val = Roll(20) + value;
    return val;
  }
}

class Language {
  String name = "";

  Language (String _name) {
    name = _name;
  }
}

