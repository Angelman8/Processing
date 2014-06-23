import de.bezier.data.*;

//Initializing Variables
int gridSize = 12;

boolean pathVis = false;

int firstNamesCount = 10000;
int lastNamesCount = 200;

int zombieCount = 0;
int humanCount = 70;

float healthLossRate = 1;
float safetyChangeRate = 0.01;

int personSize = 10;
int spawnBuffer = 15;
int attributeThreshold = 20;

int treeDiameter = 15;

float mouseMovementCounter;
float mouseDelayTime = 2000;
float lastMouseX;
float lastMouseY;

//colors
color humanColor = color(255, 180, 150);
color zombieColor = color(80, 110, 160);
color highlightColor = color(255);

XlsReader reader; 

String seed = "";
long seedvar;

ArrayList firstNames = new ArrayList();
ArrayList lastNames = new ArrayList();

//Pathfinding
int[][] grid;
int[][] map;
ArrayList unitsOnPath = new ArrayList();
ArrayList nodes = new ArrayList();

float mouseoverX, mouseoverY;

//Fish array initialization
ArrayList humans = new ArrayList();
ArrayList zombies = new ArrayList();


void setup() {
  size(600, 600);
  frameRate(60);
  ellipseMode(CENTER);
  stroke(0, 0, 0, 20);

  //Initialize Maps
  map = new int[height/gridSize][width/gridSize];
  grid = new int[height/gridSize][width/gridSize];
  generateMap();
  generateGrid();

  if ( seed != "")
    randomSeed(seedvar);

  reader = new XlsReader( this, "randomNames.xls" );

  InitializeNames();
  NewSimulation();
}


void draw() {
  background(100, 100, 100);
  fill(200);

  if (humans.size() <= 0)
  {
    NewSimulation();
  }

  if (abs(lastMouseX - mouseX) < 1 && abs(lastMouseX - mouseX) < 1)
  {
    mouseMovementCounter++;
  }
  else
    mouseMovementCounter = 0;

  for ( int ix = 0; ix < width/gridSize; ix+=1 ) {
    for ( int iy = 0; iy < height/gridSize; iy+=1) {
      if (map[iy][ix] == 0)
      {
        fill(100, 150, 90);
        rect(ix*gridSize, iy*gridSize, gridSize, gridSize);
      }
      if (map[iy][ix] == 1)
      {
        fill(0);
        rect(ix*gridSize, iy*gridSize, gridSize, gridSize);
      }
      if (map[iy][ix] == 2)
      {
        fill(150);
        rect(ix*gridSize, iy*gridSize, gridSize, gridSize);
      }
      if (map[iy][ix] == 3)
      {
        fill(10, 50, 100);
        rect(ix*gridSize, iy*gridSize, gridSize, gridSize);
      }
      if (map[iy][ix] == 5)
      {
        fill(100, 150, 90);
        rect(ix*gridSize, iy*gridSize, gridSize, gridSize);
      }
    }
  }

  noStroke();
  
  for (int i = humans.size()-1; i >= 0; i--)
  {
    Human human = (Human) humans.get(i);

    if (human.health <= 0)
    {
      Zombify(human, i);
    }
    if (human.hunger <= 0 || human.thirst <= 0 || human.sleep <= 0 && !human.bitten)
    {
      humans.remove(i);
    }

    human.Update();
  }
  
  for (int i = humans.size()-1; i >= 0; i--)
  {
    Human human = (Human) humans.get(i);
    human.Draw();
  }
  
  if (zombies.size() > 0)
  {
    for (int i = zombies.size()-1; i >= 0; i--)
    {
      Zombie zombie = (Zombie) zombies.get(i);
      zombie.Update();
    }
  }
// Draw the trees over top of the Humans and Zombies
  for ( int ix = 0; ix < width/gridSize; ix+=1 ) {
    for ( int iy = 0; iy < height/gridSize; iy+=1) {
      if (map[iy][ix] == 4)
      {
        fill(60, 120, 70);
        triangle(
        cos(radians(30 + 0)) * (treeDiameter) + (ix*gridSize + gridSize/2), sin(radians(30)) * (treeDiameter) + (iy*gridSize + gridSize/2), 
        cos(radians(30 + 120)) * (treeDiameter) + (ix*gridSize + gridSize/2), sin(radians(30 + 120)) * (treeDiameter) + (iy*gridSize + gridSize/2), 
        cos(radians(30 + 240)) * (treeDiameter) + (ix*gridSize + gridSize/2), sin(radians(30 + 240)) * (treeDiameter) + (iy*gridSize + gridSize/2)
          );

        fill(60, 110, 70);
        triangle(
        cos(radians(60 + 0)) * (treeDiameter) + (ix*gridSize + gridSize/2), sin(radians(60)) * (treeDiameter) + (iy*gridSize + gridSize/2), 
        cos(radians(60 + 120)) * (treeDiameter) + (ix*gridSize + gridSize/2), sin(radians(60 + 120)) * (treeDiameter) + (iy*gridSize + gridSize/2), 
        cos(radians(60 + 240)) * (treeDiameter) + (ix*gridSize + gridSize/2), sin(radians(60 + 240)) * (treeDiameter) + (iy*gridSize + gridSize/2)
          );

        fill(60, 120, 70);
        triangle(
        cos(radians(90 + 0)) * (treeDiameter) + (ix*gridSize + gridSize/2), sin(radians(90)) * (treeDiameter) + (iy*gridSize + gridSize/2), 
        cos(radians(90 + 120)) * (treeDiameter) + (ix*gridSize + gridSize/2), sin(radians(90 + 120)) * (treeDiameter) + (iy*gridSize + gridSize/2), 
        cos(radians(90 + 240)) * (treeDiameter) + (ix*gridSize + gridSize/2), sin(radians(90 + 240)) * (treeDiameter) + (iy*gridSize + gridSize/2)
          );

        fill(60, 120, 70);
        triangle(
        cos(radians(120 + 0)) * (treeDiameter/5) + (ix*gridSize + gridSize/2), sin(radians(120)) * (treeDiameter/5) + (iy*gridSize + gridSize/2), 
        cos(radians(120 + 120)) * (treeDiameter/5) + (ix*gridSize + gridSize/2), sin(radians(120 + 120)) * (treeDiameter/5) + (iy*gridSize + gridSize/2), 
        cos(radians(120 + 240)) * (treeDiameter/5) + (ix*gridSize + gridSize/2), sin(radians(120 + 240)) * (treeDiameter/5) + (iy*gridSize + gridSize/2)
          );
          fill(220,20,20);
          ellipse(ix*gridSize + 3, iy*gridSize + 15, 2,2);
          ellipse(ix*gridSize + 14, iy*gridSize + 10, 2,2);
          ellipse(ix*gridSize + 6, iy*gridSize + 1, 2,2);
          ellipse(ix*gridSize - 5, iy*gridSize + 5, 2,2);
          ellipse(ix*gridSize + 7, iy*gridSize + 8, 2,2);
        //        fill(100, 80, 50);
        //        ellipse(ix*gridSize + gridSize/2, iy*gridSize + gridSize/2, gridSize/2, gridSize/2);
      }
    }
  }


  // separate forloop to draw data on top of objects
  for (int i = humans.size()-1; i >= 0; i--)
  {
    Human human = (Human) humans.get(i);
    human.DrawData();
  }
  //And for Zombies
  for (int i = zombies.size()-1; i >= 0; i--)
  {
    Zombie zombie = (Zombie) zombies.get(i);
    zombie.DrawData();
  }

  lastMouseX = mouseX;
  lastMouseY = mouseY;


  Mouseover();
  CorrectPositions();

  if (mouseMovementCounter > mouseDelayTime)
  {
    //DisplayHelp();
  }
}


void runchar() {
  int charNum = seed.length();
  seed = seed.toUpperCase();  
  for (int i = 0; i < charNum; i++) {
    float charadd = seed.charAt(i);
    seedvar += charadd;
  }
}

void Zombify(Human tempHuman, int humansIndex)
{
  zombies.add(new Zombie(tempHuman.position.x, tempHuman.position.y, tempHuman.courage + random(-10, 50), tempHuman.firstName, tempHuman.lastName));
  humans.remove(humansIndex);
}


void CorrectPositions()
{
  //Correct position for Humans that are out of bounds (SpawnBuffer)
  for (int i = humans.size()-1; i >= 0; i--)
  {
    Human human = (Human) humans.get(i);
    if (human.position.x > width - spawnBuffer)
      human.position.x--;
    else if (human.position.x < spawnBuffer)
      human.position.x++;
    if (human.position.y > height - spawnBuffer)
      human.position.y--;
    else if (human.position.y < spawnBuffer)
      human.position.y++;
  }
  //Correct position if Zombie is out of bounds
  for (int i = zombies.size()-1; i >= 0; i--)
  {
    Zombie zombie = (Zombie) zombies.get(i);
    if (zombie.position.x > width - spawnBuffer)
      zombie.position.x--;
    else if (zombie.position.x < spawnBuffer)
      zombie.position.x++;
    if (zombie.position.y > height - spawnBuffer)
      zombie.position.y--;
    else if (zombie.position.y < spawnBuffer)
      zombie.position.y++;
  }
}

void NewSimulation()
{
  if (zombies.size() > 0)
  {
    for (int i = zombies.size()-1; i >= 0; i--)
    {
      zombies.remove(i);
    }
  }

  for (int i = 0; i < humanCount; i++) {
    float tempX = floor(random(0 + spawnBuffer, width - spawnBuffer)/gridSize)*gridSize + gridSize/2;
    float tempY = floor(random(0 + spawnBuffer, height - spawnBuffer)/gridSize)*gridSize + gridSize/2;
    while (map[ (int)tempY/gridSize][(int)tempX/gridSize] == 1 || map[ (int)tempY/gridSize][(int)tempX/gridSize] == 4)
    {
      tempX = floor(random(0 + spawnBuffer, width - spawnBuffer)/gridSize)*gridSize + gridSize/2;
      tempY = floor(random(0 + spawnBuffer, height - spawnBuffer)/gridSize)*gridSize + gridSize/2;
    }
    humans.add(new Human(tempX, tempY, random(0, 100), random(0, 100), random(0, 100)));
  }
  for (int i = 0; i < zombieCount; i++) {
    String firstName = "";
    String lastName = "";
    float tempX = random(0 + spawnBuffer, width - spawnBuffer);
    float tempY = random(0 + spawnBuffer, height - spawnBuffer);
    while (map[ (int)tempY/gridSize][(int)tempX/gridSize] == 1 || map[ (int)tempY/gridSize][(int)tempX/gridSize] == 4)
    {
      tempX = random(0 + spawnBuffer, width - spawnBuffer);
      tempY = random(0 + spawnBuffer, height - spawnBuffer);
    }
    zombies.add(new Zombie(tempX, tempY, random(0, 100), GetFirstName(firstName), GetFirstName(lastName)));
  }
}

void DisplayHelp()
{
  fill(0, 0, 0, 180);
  rectMode(CENTER);
  rect(width/2, height/2, 500, 200);
  rectMode(CORNER);
  fill(255);
  text("RIGHT CLICK on a human to zombify them.", width/2 - 230, height/2 - 50);
  text("LEFT CLICK on a human and guide them with RIGHT CLICK.", width/2 - 230, height/2 -30);
  text("CONTROLS:", width/2 - 220, height/2 + 10);
  text("P -- Show Human Paths", width/2 - 200, height/2 + 30);
  text("W -- Give Selected Human a Weapon", width/2 - 200, height/2 + 50);
}

