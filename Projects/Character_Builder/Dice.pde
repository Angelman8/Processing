int Roll(int sides) {
  int value = sides;
  if (mousePressed && (mouseButton == LEFT)) {
    value = (int)floor(random(1, sides + 1));
  } else if (mousePressed && (mouseButton == RIGHT)) {
    value = (int)floor((randomGaussian() * ceil(sides * .2)) + ceil(sides * .9));
    value = value < 1 ? 1 : value;
    value = value > sides ? sides : value;
  }
    return value;
}
