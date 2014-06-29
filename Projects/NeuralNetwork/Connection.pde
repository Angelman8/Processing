/* ---------------------------------------------------------------------
A connection determines how much of a signal is passed through to the neuron.
--------------------------------------------------------------------  */
 
class Connection{
  float connEntry;
  float weight;
  float connExit;
   
  //This is the default constructor for an Connection
  Connection(){
    randomiseWeight();
  }
   
  //A custom weight for this Connection constructor
  Connection(float tempWeight){
    setWeight(tempWeight);
  }
   
  //Function to set the weight of this connection
  void setWeight(float tempWeight){
    weight=tempWeight;
  }
   
  //Function to randomise the weight of this connection
  void randomiseWeight(){
    setWeight(random(2)-1);
  }
   
  //Function to calculate and store the output of this Connection
  float calcConnExit(float tempInput){
    connEntry = tempInput;
    connExit = connEntry * weight;
    return connExit;
  }
}
