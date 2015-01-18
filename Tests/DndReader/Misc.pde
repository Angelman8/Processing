String getData (String url) {                                          // sends JSON commands via PUT request
  try
  {
    HttpGet httpGet = new HttpGet( url );                               // set HTTP put address to light being accessed
    DefaultHttpClient httpClient = new DefaultHttpClient();
    httpGet.addHeader("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8");
    httpGet.addHeader("Cookie", "f5_cspm=1234; DnDNewExperience=12/4/2013 9:50:04 PM; BIGipServerWWWCOMPPool1=1024461066.20480.0000; BIGipServerWWWPool1=3843033354.20480.0000; ASP.NET_SessionId=xxdflkqhxuxpkwlu5rlitydj; iPlanetDirectoryPro=1cfdcdf1-f021-43cb-8525-a63d506e177a");
    HttpResponse response = httpClient.execute( httpGet );            // check to make sure it went well
    HttpEntity entity = response.getEntity();
    
    StringBuilder sb = new StringBuilder();
    try {
      BufferedReader reader = 
        new BufferedReader(new InputStreamReader(entity.getContent()), 65728);
      String line = null;

      while ( (line = reader.readLine ()) != null) {
        sb.append(line);
      }
    }
    catch (IOException e) { 
      e.printStackTrace();
    }
    catch (Exception e) { 
      e.printStackTrace();
    }
    
    return sb.toString();
  } 
  catch( Exception e ) { 
    e.printStackTrace();
  }
  return "";
}

