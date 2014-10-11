JSONObject json;

json = loadJSONObject("http://songza.com/api/1/user/11672548/song-votes?vote=UP&limit=10&offset=0");
for(int i = 0; i < json.size()-1; i++) {
  JSONObject song = getJSONObject("song");
  JSONObject artist = json.getJSONObject("artist");
  String artistName = artist.getString("name");
  String title = song.getString("title");
  println(artistName + " - " + title);
}
