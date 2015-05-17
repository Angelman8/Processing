import ddf.minim.*;
import javax.sound.sampled.*;

Minim minim;
AudioPlayer player;
AudioInput input;

class Voice {
  String voice = "";
  int detailSize;
  float[] points;

  Voice(String _voice) {
    voice = _voice;
    detailSize = input.bufferSize();
    points = new float[detailSize];
    for(int i = 0; i < points.length-1; i++) {
      points[i] = 0;
    }
  }

  Voice(String _voice, int _detailSize) {
    voice = _voice;
    detailSize = _detailSize;
    points = new float[detailSize];
    for(int i = 0; i < points.length-1; i++) {
      points[i] = 0;
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
    stroke(255);
    for (int i = 0; i < (detailSize); i++) {
      line(i, points[i] + height/2, i, points[i] + height/2 + input.left.get(i) * 200);
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
