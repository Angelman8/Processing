void mousePressed()
{
  //HumanClicks
  for (int i = humans.size()-1; i >= 0; i--)
  {
    Human human = (Human) humans.get(i);
    float mouseoverThreshold = dist(human.position.x, human.position.y, mouseX, mouseY);

    if (mouseoverThreshold < personSize)
    {
      if (mouseButton == LEFT && human.clickedOn != true)
        human.clickedOn = !human.clickedOn;
      else if (mouseButton == RIGHT)
        Zombify(human, i);
    }
    else
    {
      if (mouseButton == LEFT)
      {
        human.clickedOn = false;
      }
      else if (mouseButton == RIGHT && human.clickedOn)
      {
        human.goal = grid[int(floor(mouseY/gridSize))][int(floor(mouseX/gridSize))];
        human.findPath(human.current, human.goal);
      }
    }
  }

  //ZombieClicks
  for (int i = zombies.size()-1; i >= 0; i--)
  {
    Zombie zombie = (Zombie) zombies.get(i);
    float mouseoverThreshold = dist(zombie.position.x, zombie.position.y, mouseX, mouseY);

    if (mouseoverThreshold < personSize)
    {
      if (mouseButton == LEFT)
        zombie.clickedOn = !zombie.clickedOn;
    }
    else
      zombie.clickedOn = false;
  }
}

void Mouseover()
{
  for (int i = humans.size()-1; i >= 0; i--)
  {
    Human human = (Human) humans.get(i);
    float mouseoverThreshold = dist(human.position.x, human.position.y, mouseX, mouseY);

    if (mouseoverThreshold < personSize)
    {
      human.hoveredOver = true;
    }
    else
      human.hoveredOver = false;
  }

  for (int i = zombies.size()-1; i >= 0; i--)
  {
    Zombie zombie = (Zombie) zombies.get(i);
    float mouseoverThreshold = dist(zombie.position.x, zombie.position.y, mouseX, mouseY);

    if (mouseoverThreshold < personSize)
    {
      zombie.hoveredOver = true;
    }
    else
      zombie.hoveredOver = false;
  }
}

void keyPressed() {
  if (key == 'h' || key == 'H') {
    for (int i = humans.size()-1; i >= 0; i--)
    {
      Human human = (Human) humans.get(i);
      if (human.clickedOn)
      {
        human.goToNearestShelter();
      }
    }
  }
  if (key == 't' || key == 'T') {
    for (int i = humans.size()-1; i >= 0; i--)
    {
      Human human = (Human) humans.get(i);
      if (human.clickedOn)
      {
        human.goToNearestWater();
      }
    }
  }
  if (key == 'f' || key == 'F') {
    for (int i = humans.size()-1; i >= 0; i--)
    {
      Human human = (Human) humans.get(i);
      if (human.clickedOn)
      {
        human.goToNearestFood();
      }
    }
  }
  if (key == 'w' || key == 'W') {
    for (int i = humans.size()-1; i >= 0; i--)
    {
      Human human = (Human) humans.get(i);
      if (human.clickedOn)
      {
        human.ToggleWeapon();
      }
    }
  }
  if (key == 'p' || key == 'P') {
    pathVis = !pathVis;
  }
}

