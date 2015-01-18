float noiseVal;
int noiseDetail = 3;
float noiseFalloff = 0.5;
float noiseScale = 0.02;

void setup() {
  size(500, 500);
}

void draw() {
  noiseDetail(noiseDetail, noiseFalloff);
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      noiseVal = noise(x * noiseScale, y * noiseScale);
      stroke(noiseVal * 255);
      rect(x, y, 1, 1);
    }
  }
}

void keyPressed() {
  if (key == 'q') {
    noiseScale += 0.001;
  } 
  else if (key == 'a') {
    noiseScale -= 0.001;
  }

  if (key == 'w') {
    noiseDetail++;
  }
  else if (key == 's') {
    noiseDetail--;
  }

  if (key == 'e') {
    noiseFalloff += 0.1;
  } 
  else if (key == 'd') {
    noiseFalloff -= 0.1;
  }
  println("Noise Scale: " + noiseScale);
  println("Noise Detail: " + noiseDetail);
  println("Noise Falloff: " + noiseFalloff);
}

