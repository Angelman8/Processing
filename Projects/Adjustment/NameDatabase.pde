void InitializeNames() {
  Table table;
  table = loadTable("randomNames.csv", "header");
  for (TableRow row : table.rows()) {
    firstNames.add(row.getString("firstName"));
    lastNames.add(row.getString("lastName"));
  }
}

