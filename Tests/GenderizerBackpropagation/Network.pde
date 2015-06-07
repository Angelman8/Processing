class NeuralNetwork 
{  
  int sample = 0;

  int[][] trainingInputs;
  int[][] trainingOutputs;

  NeuralNetwork() {
  }

  void GetTrainingData() {
    table = loadTable("randomGenderizedNames.csv", "header");
    trainingInputs = new int[table.getRowCount()][INPUT_NEURONS];
    trainingOutputs = new int[table.getRowCount()][OUTPUT_NEURONS];
    sample = 0;
    for (TableRow row : table.rows ()) {
      String name = row.getString("name");

      char[] splitName = name.toCharArray();
      for (int i = 0; i < INPUT_NEURONS; i++) {
        if ( i < splitName.length) {
          trainingInputs[sample][i] = (int)name.charAt(i);
        } else {
          trainingInputs[sample][i] = 0;
        }
      }

      int female = row.getInt("female");
      int male = row.getInt("male");
      trainingOutputs[sample] = new int[] { 
        female, male
      };

      sample++;
    }
  }

  void Train() 
  {
    int sample = 0;
    for (int epoch = 0; epoch < TRAINING_REPS; epoch++) {
      if (sample == trainingInputs.length - 1) {
        sample = 0;
      }
      for (int i = 0; i < INPUT_NEURONS; i++) {
        inputs[i] = trainingInputs[sample][i];
      }

      for (int o = 0; o < OUTPUT_NEURONS; o++) {
        target[o] = trainingOutputs[sample][o];
      }

      FeedForward();

      BackPropagate();
    }

    GetTrainingStats();
    sample++;
  }

  void FeedForward()
  {
    double sum = 0.0;

    // Calculate input to hidden layer.
    for (int hid = 0; hid < HIDDEN_NEURONS; hid++)
    {
      sum = 0.0;
      for (int inp = 0; inp < INPUT_NEURONS; inp++)
      {
        sum += inputs[inp] * weightsInput[inp][hid];
      } // inp

      sum += weightsInput[INPUT_NEURONS][hid]; // Add in bias.
      hidden[hid] = sigmoid(sum);
    } // hid

    // Calculate the hidden to output layer.
    for (int out = 0; out < OUTPUT_NEURONS; out++)
    {
      sum = 0.0;
      for (int hid = 0; hid < HIDDEN_NEURONS; hid++)
      {
        sum += hidden[hid] * weightsHidden[hid][out];
      } // hid

      sum += weightsHidden[HIDDEN_NEURONS][out]; // Add in bias.
      actual[out] = sigmoid(sum);
    } // out
    return;
  }

  void BackPropagate()
  {
    // Calculate the output layer error (step 3 for output cell).
    for (int out = 0; out < OUTPUT_NEURONS; out++)
    {
      erro[out] = (target[out] - actual[out]) * sigmoidDerivative(actual[out]);
    }

    // Calculate the hidden layer error (step 3 for hidden cell).
    for (int hid = 0; hid < HIDDEN_NEURONS; hid++)
    {
      errh[hid] = 0.0;
      for (int out = 0; out < OUTPUT_NEURONS; out++)
      {
        errh[hid] += erro[out] * weightsHidden[hid][out];
      }
      errh[hid] *= sigmoidDerivative(hidden[hid]);
    }

    // Update the weights for the output layer (step 4).
    for (int out = 0; out < OUTPUT_NEURONS; out++)
    {
      for (int hid = 0; hid < HIDDEN_NEURONS; hid++)
      {
        weightsHidden[hid][out] += (LEARN_RATE * erro[out] * hidden[hid]);
      } // hid
      weightsHidden[HIDDEN_NEURONS][out] += (LEARN_RATE * erro[out]); // Update the bias.
    } // out

    // Update the weights for the hidden layer (step 4).
    for (int hid = 0; hid < HIDDEN_NEURONS; hid++)
    {
      for (int inp = 0; inp < INPUT_NEURONS; inp++)
      {
        weightsInput[inp][hid] += (LEARN_RATE * errh[hid] * inputs[inp]);
      } // inp
      weightsInput[INPUT_NEURONS][hid] += (LEARN_RATE * errh[hid]); // Update the bias.
    } // hid
    return;
  }

  void GetTrainingStats()
  {
    double sum = 0.0;
    for (int i = 0; i < trainingInputs.length - 1; i++)
    {
      for (int j = 0; j < INPUT_NEURONS; j++)
      {
        inputs[j] = trainingInputs[i][j];
      }

      for (int j = 0; j < OUTPUT_NEURONS; j++)
      {
        target[j] = trainingOutputs[i][j];
      }

      FeedForward();

      if (maximum(actual) == maximum(target)) {
        sum += 1;
      } else {
        println(inputs[0] + "\t" + inputs[1] + "\t" + inputs[2] + "\t" + inputs[3]);
        println(maximum(actual) + "\t" + maximum(target));
      }
    }

    text("Network is " + ((float)sum / (float)trainingInputs.length * 100.0) + "% correct.", width/2, height/2);
  }

  void AssignRandomWeights()
  {
    for (int inp = 0; inp <= INPUT_NEURONS; inp++) // Do not subtract 1 here.
    {
      for (int hid = 0; hid < HIDDEN_NEURONS; hid++)
      {
        // Assign a random weight value between -0.5 and 0.5
        weightsInput[inp][hid] = random(-0.5, 0.5) - 0.5;
      } // hid
    } // inp

    for (int hid = 0; hid <= HIDDEN_NEURONS; hid++) // Do not subtract 1 here.
    {
      for (int out = 0; out < OUTPUT_NEURONS; out++)
      {
        // Assign a random weight value between -0.5 and 0.5
        weightsHidden[hid][out] = random(-0.5, 0.5) - 0.5;
      } // out
    } // hid
    return;
  }
}

