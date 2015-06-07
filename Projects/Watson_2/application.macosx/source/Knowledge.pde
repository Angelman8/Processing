import java.net.URLEncoder;

void searchGoogle(String input) {
  String search = URLEncoder.encode(input);
  try
  {
    HttpGet httpGet = new HttpGet("https://www.google.com/search?q=" + search);
    DefaultHttpClient httpClient = new DefaultHttpClient();
    HttpResponse response = httpClient.execute(httpGet);
    String body = EntityUtils.toString(response.getEntity());

    String[] save = new String[1];
    save[0] = body;
    saveStrings("test.html", save);

    println("------");
    String[] regTest = match(body, "<div id=\"search\"><div id=\"(?:.*?)\"><span class=\"(?:.*?)\">(.[^(]*)(.*?)</span><div class=\"(?:.*?)\">(.*?)</div>");
    if (regTest.length > 0) {
      String answer = regTest[1];
      String additionalInfo = "";
      for (int i = 2; i < regTest.length; i++) {
        additionalInfo += regTest[i];
      } 
      println(additionalInfo);
      voice.Speak("You asked " + input + ", and I think the answer is: " + answer);
    } else {
      println("could not find an answer to: " + input);
    }
  } 
  catch( Exception e ) {
    e.printStackTrace();
  }
}

