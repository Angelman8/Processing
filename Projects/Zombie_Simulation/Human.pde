class Human {

  //identifiers
  String firstName;
  String lastName;

  //position
  PVector position = new PVector(0, 0);
  float goalX, goalY;
  float distanceFromGoal;
  float direction;
  float zombieAngleBuffer;
  float angleVis;
  float smallestDistance = 999;
  int currentTarget;


  //mental attributes
  float courage, intelligence, empathy = 0; 
  float perceivedSafety = 50;
  boolean freakingOut, lookingForFood, lookingForWater, lookingForShelter = false;
  float gunshotFrequency;

  //KnownMapData
  PVector lookingAt, closestWater, closestFood, closestShelter;


  //physical attributes
  int maxHealth, health;
  boolean hasWeapon;
  int weaponID;
  color currentColor = humanColor;
  color originalColor = currentColor;
  color shirtColor;
  boolean bitten;
  boolean shooting;
  float communicationDistance = 200;
  float speed;

  float hunger, thirst, sleep, desperation;

  //data
  float healthCounter = 0;
  boolean clickedOn, hoveredOver = false;
  int lines = 5;
  int lineSpacing = 20;

  //pathfinding
  ArrayList path = new ArrayList();
  ArrayList openSet = new ArrayList();
  ArrayList closedSet = new ArrayList();
  boolean isOnPath = false;
  int current = -1;
  int goal = -1;

  //Function to see if a tile is of a certain type
  boolean tileIs(float x, float y, int val)
  {
    if (map[(int)y/gridSize][(int)x/gridSize] == val)
      return true;
    else
      return false;
  }


  Human(float tempX, float tempY, float tempCourage, float tempIntelligence, float tempEmpathy) {
    maxHealth = (int)random (80, 150);
    health = maxHealth;
    firstName = GetFirstName(firstName);
    lastName = GetLastName(lastName);

    position = new PVector(tempX, tempY);
    lookingAt = new PVector(random(1, width), random(1, height));
    direction = random(0, PI);
    current = grid[int(floor(position.y/gridSize))][int(floor(position.x/gridSize))];

    closestShelter = new PVector(0, 0);
    closestWater = new PVector(0, 0);
    closestFood = new PVector(0, 0);

    courage = tempCourage;
    intelligence = tempIntelligence;
    empathy = tempEmpathy;

    hunger = (int)random(20, 40);
    thirst = (int)random(20, 40);
    sleep = (int)random(10, 40);
    speed = random(0.9, 1.2);

    zombieAngleBuffer = 0.7;

    shirtColor = color(random(20, 150), random(20, 150), random(20, 150));
    if (courage > 90)
    {
      hasWeapon = true;
    }
  }

  void setColor(color tempColor)
  {
    currentColor = tempColor;
  }

  void Update()
  {
    UpdateNodes();
    GroupTogether();
    CheckForZombies();
    if (bitten)
      Sick();
    if (isOnPath)
      FollowPath();
    else if (current != -1 && goal != -1)
    {
      isOnPath = true;
    }
    ModifyAttributes();
    Look();
    HuntForSupplies();
    if (hasWeapon)
    {
      ShootNearestZombie();
    }
  }


  void Draw()
  {
    stroke(0, 0, 0, 15);
    pushMatrix();
    translate(position.x, position.y);
    float goalDirection = atan2(lookingAt.y - position.y, lookingAt.x - position.x);

    if (goalDirection > direction)
      direction+= 0.1;
    else if (goalDirection < direction)
      direction-= 0.1;
    rotate(direction);
    ellipseMode(CENTER);
    if (hasWeapon)
    {
      //gunshot
      if (shooting)
      {
        fill(255, 230, 220);
        ellipse(11, 4, 8, 5);
      }
      else if (!shooting)
      {
      }
      //weapon
      fill(0, 0, 0);
      rect(2, 3, 7, 2);
    }
    fill(shirtColor);
    ellipse(0, 0, personSize*.9, personSize*1.3);
    fill(currentColor);
    ellipse(1, 0, personSize*.8, personSize*.7);
    popMatrix();
  }





  void HuntForSupplies()
  {
    if (hunger < attributeThreshold + courage/6 && !lookingForFood)
    {
      goToNearestFood();
      lookingForFood = true;
    }
    else if (hunger > attributeThreshold + courage/6)
    {
      lookingForFood = false;
    }
    if (thirst < attributeThreshold + courage/6 && !lookingForWater)
    {
      goToNearestWater();
      lookingForWater = true;
    }
    else if (thirst > attributeThreshold + courage/6)
    {
      lookingForWater = false;
    }
    if (sleep < attributeThreshold - courage/10 &&!lookingForShelter)
    {
      goToNearestShelter();
      lookingForShelter = true;
    }
    else if (sleep > attributeThreshold - courage/10)
    {
      lookingForShelter = false;
    }
  }


  void ModifyAttributes()
  {
    hunger -= 0.01;
    thirst -= 0.005;
    sleep -= 0.03;
    if (tileIs(position.x+gridSize, position.y, 3) 
      || tileIs(position.x-gridSize, position.y, 3) 
      || tileIs(position.x, position.y +gridSize, 3) 
      || tileIs(position.x, position.y-gridSize, 3))
    {
      if (thirst < 100)
        thirst++;
    }
    if (tileIs(position.x+gridSize, position.y, 5) 
      || tileIs(position.x-gridSize, position.y, 5) 
      || tileIs(position.x, position.y +gridSize, 5) 
      || tileIs(position.x, position.y-gridSize, 5))
    {
      if (hunger < 100)
        hunger++;
    }
    if (tileIs(position.x+gridSize, position.y, 2) 
      || tileIs(position.x-gridSize, position.y, 2) 
      || tileIs(position.x, position.y +gridSize, 2) 
      || tileIs(position.x, position.y-gridSize, 2))
    {
      if (sleep < 100)
        sleep++;
    }
  }




  void Look()
  {
    for ( int ix = 0; ix < width/gridSize; ix++ ) {
      for ( int iy = 0; iy < height/gridSize; iy++) {
        float distance = dist(position.x, position.y, ix*gridSize, iy*gridSize);
        //check for shelter
        if (map[iy][ix] == 2 && distance < communicationDistance*2)
        {
          if (closestShelter != null)
          {
            float otherDistance = dist(position.x, position.y, closestShelter.x, closestShelter.y);
            if (distance < otherDistance)
            {
              closestShelter = new PVector(ix*gridSize, iy*gridSize);
            }
          }
          else 
          {
            closestShelter = new PVector(ix*gridSize, iy*gridSize);
          }
        }

        // check for water
        if (map[iy][ix] == 3 && distance < communicationDistance*2)
        {
          if (closestWater != null)
          {
            float otherDistance = dist(position.x, position.y, closestWater.x, closestWater.y);
            if (distance < otherDistance)
            {
              closestWater = new PVector(ix*gridSize, iy*gridSize);
            }
          }
          else
          {
            closestWater = new PVector(ix*gridSize, iy*gridSize);
          }
        }
        // closest Food
        if (map[iy][ix] == 5 && distance < communicationDistance*2)
        {
          if (closestFood != null)
          {
            float otherDistance = dist(position.x, position.y, closestFood.x, closestFood.y);
            if (distance < otherDistance)
            {
              closestFood = new PVector(ix*gridSize, iy*gridSize);
            }
          }
          else 
          {
            closestFood = new PVector(ix*gridSize, iy*gridSize);
          }
        }
      }
    }
    
  }




  void Communicate(Human otherHuman)
  {
    float distance = dist(position.x, position.y, otherHuman.position.x, otherHuman.position.y);
    float chanceOfCommunication = random(0, 100);
    if (distance < communicationDistance && chanceOfCommunication > 95)
    {
      //check to see if this human knows about a closer resource than the OtherHuman
      ////Shelter
      if ( closestShelter != null && otherHuman.closestShelter != null)
      {
        float thisShelterDistance = dist(otherHuman.position.x, otherHuman.position.y, closestShelter.x, closestShelter.y);
        float otherShelterDistance = dist(otherHuman.position.x, otherHuman.position.y, otherHuman.closestShelter.x, otherHuman.closestShelter.y);
        if (thisShelterDistance < otherShelterDistance)
        {
          otherHuman.closestShelter = closestShelter;
        }
        else
        {
        }
      }
      if ( closestWater != null && otherHuman.closestWater != null)
      {
        float thisWaterDistance = dist(otherHuman.position.x, otherHuman.position.y, closestWater.x, closestWater.y);
        float otherWaterDistance = dist(otherHuman.position.x, otherHuman.position.y, otherHuman.closestWater.x, otherHuman.closestWater.y);
        if (thisWaterDistance < otherWaterDistance)
        {
          otherHuman.closestWater = closestWater;
        }
        else
        {
        }
      }
      if ( closestFood != null && otherHuman.closestFood != null)
      {
        float thisFoodDistance = dist(otherHuman.position.x, otherHuman.position.y, closestFood.x, closestFood.y);
        float otherFoodDistance = dist(otherHuman.position.x, otherHuman.position.y, otherHuman.closestFood.x, otherHuman.closestFood.y);
        if (thisFoodDistance < otherFoodDistance)
        {
          otherHuman.closestFood = closestFood;
        }
        else
        {
        }
      }
    }
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
    rect(position.x + personSize/2 - 5, position.y - (lines * lineSpacing + personSize), 120, lines * lineSpacing);
    fill(255);
    text(firstName + " " + lastName, position.x + personSize/2, (position.y - (lines * lineSpacing + singleLine) + 5 + singleLine * lineSpacing));
    singleLine++;
    text(health + "/" + maxHealth, position.x + personSize/2 + 10, (position.y - (lines * lineSpacing) + 5 + singleLine * lineSpacing));
    singleLine++;
    fill(150);
    text("hunger: " + (int)hunger, position.x + personSize/2 + 10, (position.y - (lines * lineSpacing) + 5 + singleLine * lineSpacing));
    singleLine++;
    text("thirst: " + (int)thirst, position.x + personSize/2 + 10, (position.y - (lines * lineSpacing) + 5 + singleLine * lineSpacing));
    singleLine++;
    text("sleep: " + (int)sleep, position.x + personSize/2 + 10, (position.y - (lines * lineSpacing) + 5 + singleLine * lineSpacing));
    singleLine++;
  }

  void noShowData()
  {
    setColor(originalColor);
  }



  //Movement
  void GroupTogether()
  {
    for (int c = 0; c < humans.size(); c++)
    {
      Human human2 = (Human) humans.get(c);
      float distance = dist(position.x, position.y, human2.position.x, human2.position.y);

      Communicate(human2);

      if (distance <= personSize + (intelligence + courage) / 50)
      {
        if (position.x > 0 + spawnBuffer && position.x < width - spawnBuffer)
          position.x += 0.03*(position.x - human2.position.x);
        if (position.y > 0 + spawnBuffer && position.y < height - spawnBuffer)
          position.y += 0.03*(position.y - human2.position.y);
      }
    }
  }



  void CheckForZombies()
  {
    for (int c = 0; c < zombies.size(); c++)
    {
      Zombie zombie = (Zombie) zombies.get(c);
      float distance = dist(position.x, position.y, zombie.position.x, zombie.position.y);

      if (distance <= 150 - (courage) && !tileIs(position.x, position.y, 2))
      {
        PVector newGoal;
        float a = PVector.angleBetween(position, zombie.position);

        if (!isOnPath)
        {
          float difference = a - angleVis;
          while (abs (difference % 2*PI) <= zombieAngleBuffer || (2*PI-abs(difference % 2*PI))<= zombieAngleBuffer)
          {
            angleVis = random(0, 2*PI);
            difference = a - angleVis;
          }
          newGoal = new PVector(cos(angleVis) * (random(gridSize, 100 - courage/5)) + position.x, sin(angleVis) * (random(gridSize, 200 - courage/5)) + position.y);
          if (newGoal.x > 0 && newGoal.x < width && newGoal.y > 0 && newGoal.y < height && !tileIs(newGoal.x, newGoal.y, 1))
          {
            goal = grid[int(floor(newGoal.y/gridSize))][int(floor(newGoal.x/gridSize))];
            findPath(current, goal);
          }
        }
      }
      else if (distance <= 30 && tileIs(position.x, position.y, 2))
      {
        PVector newGoal;
        float a = PVector.angleBetween(position, zombie.position);

        if (!isOnPath)
        {
          float difference = a - angleVis;
          while (abs (difference % 2*PI) <= zombieAngleBuffer || (2*PI-abs(difference % 2*PI))<= zombieAngleBuffer)
          {
            angleVis = random(0, 2*PI);
            difference = a - angleVis;
          }
          newGoal = new PVector(cos(angleVis) * (random(gridSize, 100 - courage/5)) + position.x, sin(angleVis) * (random(gridSize, 200 - courage/5)) + position.y);
          if (newGoal.x > 0 && newGoal.x < width && newGoal.y > 0 && newGoal.y < height)
          {
            goal = grid[int(floor(newGoal.y/gridSize))][int(floor(newGoal.x/gridSize))];
            findPath(current, goal);
          }
        }
      }
    }
  }

  void Sick()
  {
    if (healthCounter >= healthLossRate + ( intelligence / 100))
    {
      health--;
      healthCounter = 0;
    }
    else
      healthCounter++;
  }

  void goToNearestShelter()
  {
    if (closestShelter != null)
    {
      goal = grid[int(floor(closestShelter.y/gridSize))][int(floor(closestShelter.x/gridSize))];
      findPath(current, goal);
    }
  }

  void goToNearestWater()
  {
    if (closestWater != null)
    {
      goal = grid[int(floor(closestWater.y/gridSize))][int(floor(closestWater.x/gridSize))];
      findPath(current, goal);
    }
  }
  void goToNearestFood()
  {
        if (clickedOn)
      println(closestFood.x/gridSize + " : " + closestFood.y/gridSize);
    if (closestFood != null)
    {
      goal = grid[int(floor(closestFood.y/gridSize))][int(floor(closestFood.x/gridSize))];
      findPath(current, goal);
    }
  }

  void ToggleWeapon()
  {
    hasWeapon = !hasWeapon;
  }




  void ShootNearestZombie()
  {
    smallestDistance = 999;
    if (zombies.size() > 0)
    {
      for (int i = 0; i < zombies.size(); i++)
      {
        Zombie zombie = (Zombie) zombies.get(i);
        float distance = dist(position.x, position.y, zombie.position.x, zombie.position.y);
        if (distance < smallestDistance)
        {
          smallestDistance = distance;
          currentTarget = i;
        }
      }
      Zombie zombie = (Zombie) zombies.get(currentTarget);
      float distance = dist(position.x, position.y, zombie.position.x, zombie.position.y);
      shooting = false;
      if (distance < 50 + intelligence/2)
      {
        lookingAt = new PVector(zombie.position.x, zombie.position.y);

        if (gunshotFrequency < 0)
        {
          float shootingChance = random(1, 100);
          if (shootingChance <= intelligence/3 - distance/5)
          {
            shooting = true;
            zombies.remove(currentTarget);
            gunshotFrequency = random(50, 100);
          }
        }
        else
        {
          gunshotFrequency--;
        }
      }
    }
  }









  boolean findPath(int iStart, int iEnd) {
    //A* Pathfinding Algorithm
    //Finds short path from node[iStart] to node[iEnd]
    //Works strictly off nodes, so not grid depended at all
    float endX, endY;
    endX = ((Node)nodes.get(iEnd)).x;
    endY = ((Node)nodes.get(iEnd)).y;

    openSet.clear();
    closedSet.clear();
    path.clear();

    //add initial node to openSet
    openSet.add( ((Node)nodes.get(iStart)) );
    ((Node)openSet.get(0)).p = -1;
    ((Node)openSet.get(0)).g = 0;
    ((Node)openSet.get(0)).h = dist( ((Node)openSet.get(0)).x, ((Node)openSet.get(0)).y, endX, endY );

    Node current;
    float tentativeGScore;
    boolean tentativeIsBetter;
    float lowest = 999999999;
    int lowId = -1;

    while ( openSet.size ()>0 ) {
      //find the node in openSet with the lowest f (g+h scores) and put its index in lowId
      lowest = 999999999;
      for ( int a = 0; a < openSet.size(); a++ ) {
        if ( ( ((Node)openSet.get(a)).g+((Node)openSet.get(a)).h ) <= lowest ) {
          lowest = ( ((Node)openSet.get(a)).g+((Node)openSet.get(a)).h );
          lowId = a;
        }
      }
      current = (Node)openSet.get(lowId);
      if ( (current.x == endX) && (current.y == endY) ) { //path found
        //follow parents backward from goal
        Node d = (Node)openSet.get(lowId);

        while ( d.p != -1) {
          path.add( d );
          d = (Node)nodes.get(d.p);
        }

        return true;
      }
      closedSet.add( (Node)openSet.get(lowId) );
      openSet.remove( lowId );
      for ( int n = 0; n < current.nbors.size(); n++ ) {
        if ( closedSet.contains( (Node)current.nbors.get(n) ) ) {
          continue;
        }
        tentativeGScore = current.g + dist( current.x, current.y, ((Node)current.nbors.get(n)).x, ((Node)current.nbors.get(n)).y )*((Float)current.nCost.get(n));
        if ( !openSet.contains( (Node)current.nbors.get(n) ) ) {
          openSet.add( (Node)current.nbors.get(n) );
          tentativeIsBetter = true;
        }
        else if ( tentativeGScore < ((Node)current.nbors.get(n)).g ) {
          tentativeIsBetter = true;
        }
        else {
          tentativeIsBetter = false;
        }

        if ( tentativeIsBetter ) {
          ((Node)current.nbors.get(n)).p = nodes.indexOf( (Node)closedSet.get(closedSet.size()-1) ); //!!!!
          ((Node)current.nbors.get(n)).g = tentativeGScore;
          ((Node)current.nbors.get(n)).h = dist( ((Node)current.nbors.get(n)).x, ((Node)current.nbors.get(n)).y, endX, endY );
        }
      }
    }
    //no path found
    return false;
  }




  void LookAt(float x, float y)
  {
    lookingAt.x = x;
    lookingAt.y = y;
  }




  void FollowPath()
  {
    if (path.size() > 0)
    {
      isOnPath = true;
      if (current != -1 && goal != -1)
      {
        Node currentNode = (Node)path.get(path.size()-1);

        if (map[(int)currentNode.y/gridSize][(int)currentNode.x/gridSize] == 1)
        {
          path.remove(path.size()-1);
        }

        if (dist(position.x, position.y, currentNode.x + gridSize/2, currentNode.y + gridSize/2) < gridSize/1.3 && path.size() > 0)
        {
          path.remove(path.size()-1);
        }
        else
        {
          LookAt(floor(currentNode.x/gridSize)*gridSize + gridSize/2, floor(currentNode.y/gridSize)*gridSize + gridSize/2);
          int directionx = (int)((position.x) - (currentNode.x + gridSize/2));
          int directiony = (int)((position.y) - (currentNode.y + gridSize/2));
          if (directionx < 0 && position.x < width - spawnBuffer && map[(int)position.y/gridSize][(int)position.x/gridSize + 1] != 1)
            position.x += speed;
          if (directionx > 0 && position.x > 0 + spawnBuffer && map[(int)position.y/gridSize][(int)position.x/gridSize - 1] != 1)
            position.x -= speed;
          if (directiony < 0 && position.y < height - spawnBuffer && map[(int)position.y/gridSize + 1][(int)position.x/gridSize] != 1)
            position.y += speed;
          if (directiony > 0 && position.y > 0 + spawnBuffer && map[(int)position.y/gridSize - 1][(int)position.x/gridSize] != 1)
            position.y -= speed;
        }
      }
      else
      {
        goal = -1;
      }
    }
    else
    {
      isOnPath = false;
    }
  }


  void UpdateNodes()
  {
    current = grid[int(floor(position.y/gridSize))][int(floor(position.x/gridSize))];
    Node currentNode, goalNode;
    for ( int i = 0; i < nodes.size(); i++ ) {
      currentNode = (Node)nodes.get(i);
      if (clickedOn || pathVis)
      {
        if (i == current)
        {
          //            fill(0, 255, 0);
          //            rect(currentNode.x, currentNode.y, gridSize, gridSize);
        }
        else if (i == goal)
        {
          fill(255, 0, 0, 50);
          rect(currentNode.x, currentNode.y, gridSize, gridSize);
          if (goal != -1)
          {
            goalX = currentNode.x;
            goalY = currentNode.y;
          }
          else
          {
            goalX = -1;
            goalY = -1;
          }
        }
        else
        {
          if (path.contains(currentNode)) {
            fill(255, 30);
            rect(currentNode.x, currentNode.y, gridSize, gridSize);
          }
        }
      }
    }
    if (clickedOn)
    {
      for ( int ix = 0; ix < width/gridSize; ix+=1 ) {
        for ( int iy = 0; iy < height/gridSize; iy+=1) {
          if (closestShelter != null)
          {
            if (ix == closestShelter.x/gridSize && iy == closestShelter.y/gridSize)
            {
              fill(150, 50, 150);
              rect(ix*gridSize, iy*gridSize, gridSize, gridSize);
            }
          }
          if (closestWater != null)
          {
            if (ix == closestWater.x/gridSize && iy == closestWater.y/gridSize && closestWater != null)
            {
              fill(50, 150, 150);
              rect(ix*gridSize, iy*gridSize, gridSize, gridSize);
            }
          }
          if (closestFood != null)
          {
            if (ix == closestFood.x/gridSize && iy == closestFood.y/gridSize && closestFood != null)
            {
              fill(140, 80, 20);
              rect(ix*gridSize, iy*gridSize, gridSize, gridSize);
            }
          }
        }
      }
    }
  }
}

