/* -----------------------------------------------------------------
   A neuron does all the processing and calculation to convert an input into an output
--------------------------------------------------------------------- */
 
class Neuron{
  Connection[] connections={};
  float bias;
  float neuronInputValue;
  float neuronOutputValue;
  float deltaError;
   
  //The default constructor for a Neuron
  Neuron(){
  }
   
  /*The typical constructor of a Neuron - with random Bias and Connection weights */
  Neuron(int numOfConnections){
    randomiseBias();
    for(int i=0; i<numOfConnections; i++){
      Connection conn = new Connection();
      addConnection(conn);
    }
  }
   
  //Function to add a Connection to this neuron
  void addConnection(Connection conn){
      connections = (Connection[]) append(connections, conn);
  }
   
  /* Function to return the number of connections associated with this neuron.*/
  int getConnectionCount(){
      return connections.length;
  }
   
  //Function to set the bias of this Neron
  void setBias(float tempBias){
    bias = tempBias;
  }
   
  //Function to randomise the bias of this Neuron
  void randomiseBias(){
    setBias(random(1));
  }
   
  /*Function to convert the inputValue to an outputValue
  Make sure that the number of connEntryValues matches the number of connections */
   
  float getNeuronOutput(float[] connEntryValues){
    if(connEntryValues.length!=getConnectionCount()){
      println("Neuron Error: getNeuronOutput() : Wrong number of connEntryValues");
      exit();
    }
     
    neuronInputValue=0;
     
    /* First SUM all of the weighted connection values (connExit) attached to this neuron. This becomes the neuronInputValue. */
    for(int i=0; i<getConnectionCount(); i++){
      neuronInputValue+=connections[i].calcConnExit(connEntryValues[i]);
    }
     
    //Add the bias to the Neuron's inputValue
    neuronInputValue+=bias;
     
    /* Send the inputValue through the activation function to produce the Neuron's outputValue */
    neuronOutputValue=Activation(neuronInputValue);
     
    //Return the outputValue
    return neuronOutputValue;
  }
   
  //Activation function
  float Activation(float x){
    float activatedValue = 1 / (1 + exp(-1 * x));
    return activatedValue;
  }
   
}
