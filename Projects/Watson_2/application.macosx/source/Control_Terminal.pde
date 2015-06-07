import java.io.*;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

StreamWrapper getStreamWrapper(InputStream is, String type) {
  return new StreamWrapper(is, type);
}
class StreamWrapper extends Thread {
  InputStream is = null;
  String type = null;          
  String message = null;

  public String getMessage() {
    return message;
  }

  StreamWrapper(InputStream is, String type) {
    this.is = is;
    this.type = type;
  }

  public void run() {
    try {
      BufferedReader br = new BufferedReader(new InputStreamReader(is));
      StringBuffer buffer = new StringBuffer();
      String line = null;
      while ( (line = br.readLine ()) != null) {
        buffer.append(line);//.append("\n");
      }
      message = buffer.toString();
    } 
    catch (IOException ioe) {
      ioe.printStackTrace();
    }
  }
}

void execute(String command) {
  Runtime rt = Runtime.getRuntime();
  try {
    Process proc = rt.exec(command);
  } 
  catch (IOException e) {
    e.printStackTrace();
  }
}
