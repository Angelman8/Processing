void getNames() {
  Table firstNamesTable;
  firstNamesTable = loadTable("randomGenderizedNames.csv", "header");
  
  for (TableRow row : firstNamesTable.rows()) {
    if(Integer.parseInt(row.getString("female")) == 1) {
      femaleNames.add(row.getString("name"));
    }
    if(Integer.parseInt(row.getString("male")) == 1) {
      maleNames.add(row.getString("name"));
    }
  }
  Table lastNamesTable;
  lastNamesTable = loadTable("randomNames.csv", "header");
  for (TableRow row : lastNamesTable.rows()) {
      lastNames.add(row.getString("lastName"));
  }
}

