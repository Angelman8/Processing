class Counter {
  int counter = 0;
  int max;
  
  boolean countReached() {
    if (counter >= max) {
      counter = 0;
      return true;
    } else {
      counter++;
      return false;
    }
  }
  
  Counter(int tempMax) {
    max = tempMax;
  }
  
  void SetMaxCount(int val) {
    max = val;
  } 
}
