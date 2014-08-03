class Moment {
  int cardinality = (int)random(-2, 2);
  ArrayList<Relationship> relationships;
  ArrayList<Event> events;
  ArrayList<byte[]> data;

  Moment(ArrayList<Person> currentPeople) {

    data = new ArrayList<byte[]>();
    for (Person person : currentPeople) {
      data.add(compressPerson(person));
    }
  }

  ArrayList<Person> unpackMoment() {
    ArrayList<Person> newPeople = new ArrayList<Person>();
    for (byte[] person : data) {
      newPeople.add(decompressPerson(person));
    }

    return newPeople;
  }
}

class Timeline {
  ArrayList<Moment> moments;
  int days;

  Timeline(int _days) {
    days = _days;
    moments = new ArrayList<Moment>();
  }

  void draw(int x, int y) {
    int initialX = x;
    int initialY = y;
    for (int i = 0; i < moments.size()-1; i++) {
      Moment moment = moments.get(i);
      //Year Ticks
      //line(x + (int)((i / 365) * 365 * timelineScale), initialY - 50, x + (int)((i / 365) * 365 * timelineScale), initialY + 30);
      //Day Ticks
      y = y + (moment.cardinality * 10);
      stroke(50);
      line(x + ((i) * timelineScale), initialY - 120, x + ((i) * timelineScale), initialY + 120);
      stroke(255);
      drawTick(i, x, y);
    }
    ellipseMode(CENTER);
    fill(0);
    ellipse(x + moments.size() * timelineScale, y, 20, 20);
  }

  void drawTick(int i, int x, int y) {
    line(x + ((i) * timelineScale), y, x + ((i) * timelineScale), y - (moments.get(i).cardinality * 10));  //Vertical
    line(x + ((i) * timelineScale), y, x + ((i) * timelineScale) + timelineScale, y);  //Horizontal
  }


  void propagate(int currentDay, ArrayList<Person> currentPeople) {
    if (currentDay > moments.size()) {
      println("Current Day is not an existing Moment");
    } else {
      for (int i = moments.size()-1; i > currentDay; i--) {
        Moment moment = moments.get(i);
        moments.remove(moment);
      }

      for (int i = currentDay; i < days; i++) {
        Moment lastMoment;
        Moment moment;

        if (i > 0) {
          lastMoment = moments.get(i-1);
          ArrayList<Person> lastPeople = lastMoment.unpackMoment();
          //Normalize(lastPeople);
          ArrayList<Person> newPeople = Interact(lastPeople);
          moment = new Moment(newPeople);
        } 
        else {
          moment = new Moment(currentPeople);
        }

        moments.add(moment);

        println("======================================");
        println("Propogating Year " + (i / 365 + 1) + ", Day " + (i % 365 + 1));
        println("======================================");

        for (byte[] pdata : moment.data) {
          Person person = decompressPerson(pdata);
          println(person.firstName + " Energy: " + person.energy);
        }
      }
    }
  }
}

