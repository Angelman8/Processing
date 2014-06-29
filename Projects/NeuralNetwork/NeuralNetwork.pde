/*Neural Network created by ScottC on 15th Aug 2011
 
Please visit my blog for a detailed explanation of my Neural Network
http://arduinobasics.blogspot.com/p/arduinoprojects.html
 
*/
   
   
 
void setup(){
  ArrayList myTrainingInputs = new ArrayList();
  ArrayList myTrainingOutputs = new ArrayList();
   
  float[] myInputsA={0,0};
  float[] myInputsB={0,1};
  float[] myInputsC={1,0};
  float[] myInputsD={1,1};
  float[] myOutputsA={1};
  float[] myOutputsB={0};
   
   
  println("TRAINING DATA");
  println("--------------------------------------------");
  myTrainingInputs.add(myInputsA);
  myTrainingOutputs.add(myOutputsA);
  println("INPUTS= " + myInputsA[0] + ", " + myInputsA[1] + "; Expected output = " + myOutputsA[0]);
  myTrainingInputs.add(myInputsB);
  myTrainingOutputs.add(myOutputsB);
  println("INPUTS= " + myInputsB[0] + ", " + myInputsB[1] + "; Expected output = " + myOutputsB[0]);
  myTrainingInputs.add(myInputsC);
  myTrainingOutputs.add(myOutputsB);
  println("INPUTS= " + myInputsC[0] + ", " + myInputsC[1] + "; Expected output = " + myOutputsB[0]);
  myTrainingInputs.add(myInputsD);
  myTrainingOutputs.add(myOutputsA);
  println("INPUTS= " + myInputsD[0] + ", " + myInputsD[1] + "; Expected output = " + myOutputsA[0]);
  println("--------------------------------------------");
  
  NeuralNetwork NN = new NeuralNetwork();
  NN.addLayer(2,2);
  NN.addLayer(2,1);
  
  println("Before Training");
  float[] myInputDataA1={0,0};
  NN.processInputsToOutputs(myInputDataA1);
  float[] myOutputDataA1={};
  myOutputDataA1=NN.getOutputs();
  println("Feed Forward:  INPUT = 0,0; OUTPUT=" + myOutputDataA1[0]);
   
  float[] myInputDataB1={0,1};
  NN.processInputsToOutputs(myInputDataB1);
  float[] myOutputDataB1={};
  myOutputDataB1=NN.getOutputs();
  println("Feed Forward:  INPUT = 0,1; OUTPUT=" + myOutputDataB1[0]);
   
  float[] myInputDataC1={1,0};
  NN.processInputsToOutputs(myInputDataC1);
  float[] myOutputDataC1={};
  myOutputDataC1=NN.getOutputs();
  println("Feed Forward:  INPUT = 1,0; OUTPUT=" + myOutputDataC1[0]);
   
  float[] myInputDataD1={1,1};
  NN.processInputsToOutputs(myInputDataD1);
  float[] myOutputDataD1={};
  myOutputDataD1=NN.getOutputs();
  println("Feed Forward:  INPUT = 1,1; OUTPUT=" + myOutputDataD1[0]);
 
  println("");
  println("--------------------------------------------");
   
  println("Begin Training");
  NN.autoTrainNetwork(myTrainingInputs,myTrainingOutputs,0.0001,500000);
  println("");
  println("End Training");
  println("");
  println("--------------------------------------------");
  println("Test the neural network");
  float[] myInputDataA2={0,0};
  NN.processInputsToOutputs(myInputDataA2);
  float[] myOutputDataA2={};
  myOutputDataA2=NN.getOutputs();
  println("Feed Forward:  INPUT = 0,0; OUTPUT=" + myOutputDataA2[0]);
   
  float[] myInputDataB2={0,1};
  NN.processInputsToOutputs(myInputDataB2);
  float[] myOutputDataB2={};
  myOutputDataB2=NN.getOutputs();
  println("Feed Forward:  INPUT = 0,1; OUTPUT=" + myOutputDataB2[0]);
   
  float[] myInputDataC2={1,0};
  NN.processInputsToOutputs(myInputDataC2);
  float[] myOutputDataC2={};
  myOutputDataC2=NN.getOutputs();
  println("Feed Forward:  INPUT = 1,0; OUTPUT=" + myOutputDataC2[0]);
   
  float[] myInputDataD2={1,1};
  NN.processInputsToOutputs(myInputDataD2);
  float[] myOutputDataD2={};
  myOutputDataD2=NN.getOutputs();
  println("Feed Forward:  INPUT = 1,1; OUTPUT=" + myOutputDataD2[0]);
  
   
}   
