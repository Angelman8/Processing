void InitializeNames()
{
  reader.firstRow();
  reader.nextRow();
  for (int i = 0; i < firstNamesCount; i++)
  {
    firstNames.add(reader.getString());
    reader.nextRow();
  }
  reader.firstRow();
  reader.nextRow();
  for (int i = 0; i < lastNamesCount; i++)
  {
    reader.nextCell();
    lastNames.add(reader.getString());
    reader.nextRow();
  }
}

String GetFirstName(String tempString)
{
  int stringNum = (int)random(0, firstNames.size()-1);
  tempString = (String) firstNames.get(stringNum);
  return tempString;
};
String GetLastName(String tempString)
{
  int stringNum = (int)random(0, lastNames.size()-1);
  tempString = (String) lastNames.get(stringNum);
  return tempString;
};
