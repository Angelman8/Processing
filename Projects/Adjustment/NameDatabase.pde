void InitializeNames() {
  Table table;
  table = loadTable("randomNames.csv", "header");
  println(table.getRowCount() + " total rows in table");
  for (TableRow row : table.rows()) {
    if(!firstNames.contains(row.getString("firstName"))){
      firstNames.add(row.getString("firstName"));
    }
    if(!lastNames.contains(row.getString("lastName"))){
      lastNames.add(row.getString("lastName"));
    }
  }
}
