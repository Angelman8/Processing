ArrayList shellExec ( String command )
{
  return shellExec ( new String[]{ "/bin/bash", "-c", command } );
}




ArrayList shellExec ( String[] command )
{
  ArrayList lines = new ArrayList();
  try {
    Process process = Runtime.getRuntime().exec ( command );
    
    BufferedReader inBufferedReader  = new BufferedReader( new InputStreamReader ( process.getInputStream() ) );
    BufferedReader errBufferedReader = new BufferedReader( new InputStreamReader ( process.getErrorStream() ) );
    
    String line, eline;
    while ( (line  = inBufferedReader.readLine() ) != null && !errBufferedReader.ready() )
    {
  lines.add(line);
    }
    if ( errBufferedReader.ready() ) {
  while ( (eline  = errBufferedReader.readLine() ) != null )
  {
    println( eline );
  }
  return null;
    }
    int exitVal = process.waitFor();
    
    inBufferedReader.close();  process.getInputStream().close();
    errBufferedReader.close(); process.getErrorStream().close();
  }
  catch (Exception e)
  {
    e.printStackTrace();
    return null;
  }
  
  return lines;
}
