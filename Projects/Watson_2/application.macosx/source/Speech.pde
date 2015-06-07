import ddf.minim.*;
import javax.sound.sampled.*;

Minim minim;
AudioPlayer player;
AudioInput input;

class Voice {
  String voice = "";
  int detailSize = 100;
  int irisRadius = 150;
  int gravityWell = 500;
  float speed = 0.008;
  float lineStrength = 25;
  PVector[] points;

  Voice(String _voice) {
    voice = _voice;
    points = new PVector[detailSize];
    for (int i = 0; i < points.length-1; i++) {
      float x = 0;
      float y = 0;
      while (dist (x, y, width/2, height/2) > irisRadius) {
        x = random(width/2 - irisRadius, width/2 + irisRadius);
        y = random(height/2 - irisRadius, height/2 + irisRadius);
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
          
          if (distance < lineStrength + strength / 1.2 * mod) {
            stroke(225, 245, 255, 33);
            line(points[i].x, points[i].y, points[j].x, points[j].y);
          }
          float angle = atan2(dy, dx);
          float targetX = points[i].x + cos(angle) * (irisRadius);
          float targetY = points[i].y + sin(angle) * (irisRadius);
          PVector a = new PVector((targetX - points[j].x) * speed, (targetY - points[j].y) * speed);
          points[i].sub(a);
          points[j].add(a);
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

