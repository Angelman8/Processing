import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.impl.client.DefaultHttpClient;
import java.util.Map;
import java.io.InputStreamReader;

XML xml;

void setup() {
  PlayerCharacter Gelmir = Load("Gelmir Amras");
  String response = getData("http://www.wizards.com/dndinsider/compendium/power.aspx?id=8226");
  //xml = parseXML(response.substring(15).replaceAll("&nbsp;", ""));
  println(response.substring(15));
  
}

PlayerCharacter Load(String filePath) {
    xml = loadXML(filePath + ".dnd4e");
    
    PlayerCharacter playerCharacter = new PlayerCharacter();
    playerCharacter.abilities.put("Charisma", xml.getChild("CharacterSheet/AbilityScores/Charisma").getInt("score"));
    return playerCharacter;  
}
