void Parse(String input) {
  if (input.contains("light") && input.contains("off") && input.contains("turn")) {
    lastAction = "light off turn";
    light1.on(false);
    light2.on(false);
  } 
  if (input.contains("light") && input.contains("on") && input.contains("turn")) {
    lastAction = "light on turn";
    light1.on(true);
    light2.on(true);
  } 
  if (input.contains("reading") && input.contains("mode")) {
    lastAction = "reading mode";
    if (!light1.on())
      light1.on(true);
    light1.brightness(00);
    light2.on(false);
  } 
  if (input.contains("brightness")) {
    if (input.contains("up") || input.contains("on")) {
      lastAction = "brightness up";
      if (light1.on())
        light1.brightness(light1.brightness() + brightnessScale);
      if (light2.on())
        light2.brightness(light2.brightness() + brightnessScale);
    } 
    else if (input.contains("down")) {
      lastAction = "brightness down";
      if (light1.on())
        light1.brightness(light1.brightness() - brightnessScale);
      if (light2.on())
        light2.brightness(light2.brightness() - brightnessScale);
    }
  } 
  if (input.contains("more")) {
    println(lastAction);
    if (lastAction.contains("brightness"))
      Parse(lastAction);
  }
  if (input.contains("faster")) {
    brightnessScale += 20; 
    Parse(lastAction);
  } 
  else if (input.contains("slower")) {
    brightnessScale -= 20; 
    Parse(lastAction);
  }
}

