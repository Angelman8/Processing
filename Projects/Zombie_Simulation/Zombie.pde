class Zombie {

  //identifiers
  String firstName;
  String lastName;

  //position
  PVector position = new PVector(0, 0);
  float goalX, goalY;
  float distanceFromGoal;
  float facingDirection;

  //mental attributes
  float ferocity;
  boolean chasingHuman = false;
  float wanderTimeCount = 0;
  PVector wander = new PVector(0, 0);
  float wanderDistance;

  //physical attributes
  color currentColor = zombieColor;
  color originalColor = currentColor;
  float speed;

  //data
  boolean clickedOn, hoveredOver = false;
  int lines = 2;
  int lineSpacing = 20;
  int currentTarget = 0;
  float smallestDistance = 999;
  float attentionSpan = 150;

  boolean tileIs(float x, float y, int val)
  {
    if (x > 0 && x < width && y > 0 && y < height)
    {
      if (map[(int)y/gridSize][(int)x/gridSize] == val)
        return true;
      else
        return false;
    }
    else
      return false;
  }


  Zombie(float tempX, float tempY, float tempFerocity, String tempFirstName, String tempLastName) {
    firstName = tempFirstName;
    lastName = tempLastName;
    position = new PVector(tempX, tempY);
    ferocity = tempFerocity;
    if (ferocity > 100)
      ferocity = 100;
    speed = 0.4;
    wanderDistance = random(100, 300);
  }

  void setColor(color tempColor)
  {
    currentColor = tempColor;
  }

  void Update()
  {
    Draw();
    ZombieCollision();
    AttackNearestHuman();
    if (!chasingHuman)
    {
      Wander();
    }
  }

  void Draw()
  {
    noStroke();
    fill(currentColor);
    ellipse(position.x, position.y, personSize, personSize);
  }

  void DrawData()
  {
    if (clickedOn || hoveredOver)
      ShowData();
    else
      noShowData();
  }

  void ShowData()
  {
    int singleLine = 0;
    setColor(highlightColor);
    fill(0, 0, 0, 150);
    rect(position.x + personSize/2 - 5, position.y - (lines * lineSpacing + personSize), 180, lines * lineSpacing);
    fill(zombieColor);
    text("was " + firstName + " " + lastName, position.x + personSize/2, (position.y - (lines * lineSpacing + singleLine) + 5 + singleLine * lineSpacing));
    singleLine++;
    fill(150);
    text("ferocity: " + ferocity, position.x + personSize/2 + 10, (position.y - (lines * lineSpacing) + 5 + singleLine * lineSpacing));
    singleLine++;
  }

  void noShowData()
  {
    setColor(originalColor);
  }

  //Movement

  //zombieCollision
  void ZombieCollision()
  {
    for (int i = 0; i < zombies.size(); i++)
    {
      Zombie zombie = (Zombie) zombies.get(i);
      float distance = dist(position.x, position.y, zombie.position.x, zombie.position.y);
      if (distance <= personSize + (ferocity / 100) && !tileIs(position.x, position.y, 1) && !tileIs(position.x, position.y, 5))
      {
        position.x += .03*(position.x - zombie.position.x);
        position.y += .03*(position.y - zombie.position.y);
      }
    }
  }

  void Wander()
  {
    if (wanderTimeCount > 0)
    {
      if (wander.x > 0 && !tileIs(position.x + gridSize, position.y, 1) && !tileIs(position.x + gridSize, position.y, 4))
      {
        position.x += speed/2;
        wander.x--;
      }
      else if (wander.x < 0 && !tileIs(position.x - gridSize, position.y, 1) && !tileIs(position.x - gridSize, position.y, 4))
      {
        position.x -= speed/2;
        wander.x++;
      }
      if (wander.y > 0 && !tileIs(position.x, position.y + gridSize, 1) && !tileIs(position.x, position.y + gridSize, 4))
      {
        position.y += speed/2;
        wander.y--;
      }
      else if (wander.y < 0 && !tileIs(position.x, position.y - gridSize, 1) && !tileIs(position.x, position.y - gridSize, 4))
      {
        position.y -= speed/2;
        wander.y++;
      }
      wanderTimeCount--;
    }
    else
    {
      wanderTimeCount = random(0, wanderDistance*2);
      wander = new PVector(random(-wanderDistance, wanderDistance), random(-wanderDistance, wanderDistance));
    }
  }




  void AttackNearestHuman()
  {
    smallestDistance = 999;
    if (humans.size() > 0)
    {
      for (int i = 0; i < humans.size(); i++)
      {
        Human human = (Human) humans.get(i);
        float distance = dist(position.x, position.y, human.position.x, human.position.y);
        if (distance < smallestDistance)
        {
          smallestDistance = distance;
          currentTarget = i;
        }
      }
      Human human = (Human) humans.get(currentTarget);
      float distance = dist(position.x, position.y, human.position.x, human.position.y);

      if (distance <= personSize/1.1)
      {
        float biteChance = random(0, 10);
        if (biteChance < 6)
        {
          human.bitten = true;
        }
      }
      else if (distance < attentionSpan)
      {
        chasingHuman = true;
        human.perceivedSafety -= safetyChangeRate;
        float directionx = position.x - human.position.x;
        float directiony = position.y - human.position.y;
        if (position.x > 0 + spawnBuffer && position.x < width - spawnBuffer)
        {
          if (directionx <= 0 && map[(int)position.y/gridSize][(int)position.x/gridSize + 1] != 1 && !tileIs(position.x + gridSize, position.y, 4))
            position.x += speed;
          else if (directionx > 0  && map[(int)position.y/gridSize][(int)position.x/gridSize - 1] != 1 && !tileIs(position.x - gridSize, position.y, 4))
            position.x -= speed;
        }
        if (position.y > 0 + spawnBuffer && position.y < height - spawnBuffer)
        {
          if (directiony <= 0 && map[(int)position.y/gridSize + 1][(int)position.x/gridSize] != 1 && !tileIs(position.x, position.y + gridSize, 4))
            position.y += speed;
          else if (directiony > 0 && map[(int)position.y/gridSize -1][(int)position.x/gridSize] != 1 && !tileIs(position.x, position.y - gridSize, 4))
            position.y -= speed;
        }
      }
      else
      {
        chasingHuman = false;
      }
    }
  }
}

