import ddf.minim.*;
import javax.sound.sampled.*;

Minim minim;
AudioPlayer player;
AudioInput input;

class Voice {
  String voice = "";
  int detailSize = 150;
  int irisRadius = 200;
  int gravityWell = 500;
  float speed = 0.008;
  PVector[] points;

  Voice(String _voice) {
    voice = _voice;
    points = new PVector[detailSize];
    for (int i = 0; i < points.length-1; i++) {
      float x = 0;
      float y = 0;
      while (dist (x, y, width/2, height/2) > gravityWell) {
        x = random(width/2 - gravityWell/2, width/2 + gravityWell/2);
        y = random(height/2 - gravityWell/2, height/2 + gravityWell/2);
      }
      points[i] = new PVector(x, y);
    }
  }

  void Speak(String phrase) {
    String voiceCmd = "";
    if ( ! voice.equals("")) {
      voiceCmd = "-v " + voice + " ";
    }
    println("Watson says: " + phrase);
    execute("say -a 58 " + voiceCmd + phrase);
  }

  void Render() {
    fill(225, 255, 245);
    int strength = abs((int)(input.mix.get(0) * 200));
    int mod = (strength <= 0) ? -1 : 1;
    for (int i = 0; i < points.length-1; i++) {
      ellipse(points[i].x, points[i].y, 1, 1);
      for (int j = 0; j < points.length-1; j++) {
        if (i == j)
          continue;
        float dx = points[j].x - points[i].x;
        float dy = points[j].y - points[i].y;
        float distance = sqrt(dx*dx + dy*dy);
        if (distance < gravityWell) { 
          if (distance < 20 + strength / 1.5 * mod) {
            stroke(225, 245, 255, 30);
            line(points[i].x, points[i].y, points[j].x, points[j].y);
          }
          float angle = atan2(dy, dx);
          float targetX = points[i].x + cos(angle) * (irisRadius);
          float targetY = points[i].y + sin(angle) * (irisRadius);
          float ax = (targetX - points[j].x) * speed;
          float ay = (targetY - points[j].y) * speed;
          points[i].x -= ax;
          points[i].y -= ay;
          points[j].x += ax;
          points[j].y += ay;
        }
      }
    }
  }
}

void SetAudioSource(int source) {
  Mixer.Info[] mixerInfo;
  mixerInfo = AudioSystem.getMixerInfo();
  println("======Checking Audio Devices======");
  for (int i = 0; i < mixerInfo.length-1; i++) {
    println("Audio Source " + i + ": " + mixerInfo[i].getName());
  }
  println("==================================");
  println("Setting Audio Source to: " + mixerInfo[source].getName());
  Mixer mixer = AudioSystem.getMixer(mixerInfo[source]);
  if (input != null) {
    input.close();
  }
  minim.setInputMixer(mixer);
  input = minim.getLineIn(Minim.STEREO);
  println("SUCCESS!");
}

void stop()
{
  // always close Minim audio classes when you are done with them
  input.close();
  minim.stop();

  super.stop();
}

