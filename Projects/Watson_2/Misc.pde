void Parse(String input) {
  if (input.contains("light") && input.contains("off") && input.contains("turn")) {
    light1.on(false);
    light2.on(false);
  } else if (input.contains("light") && input.contains("on") && input.contains("turn")) {
    light1.on(true);
    light2.on(true);
  } else if (input.contains("reading") && input.contains("mode")) {
    if (!light1.on()) {
      light1.on(true);
    }
    light1.brightness(50);
    light2.on(false);
  }
}
