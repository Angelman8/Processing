import java.util.Arrays;

int INPUT_NEURONS = 12;
int HIDDEN_NEURONS = 8;
int OUTPUT_NEURONS = 2;
double LEARN_RATE = 0.2;
double NOISE_FACTOR = 0.45;
int TRAINING_REPS = 100000;
int MAX_SAMPLES = 1000;

//The weights between the Input and Hidden layers
double[][] weightsInput = new double[INPUT_NEURONS + 1][HIDDEN_NEURONS];
//The weights between the Hidden and Output layers
double[][] weightsHidden = new double[INPUT_NEURONS + 1][HIDDEN_NEURONS];

//Activations
double inputs[] = new double[INPUT_NEURONS];
double hidden[] = new double[HIDDEN_NEURONS];
double target[] = new double[OUTPUT_NEURONS];
double actual[] = new double[OUTPUT_NEURONS];

double erro[] = new double[OUTPUT_NEURONS];
double errh[] = new double[HIDDEN_NEURONS];

Table table;
NeuralNetwork network;

void setup() 
{
  size(600, 300);
  network = new NeuralNetwork();
  network.GetTrainingData();
  network.AssignRandomWeights();
  network.Train();
}

