int maximum(final double[] vector)
{
  int sel = 0;
  double max = vector[sel];

  for (int index = 0; index < OUTPUT_NEURONS; index++)
  {
    if (vector[index] > max) {
      max = vector[index];
      sel = index;
    }
  }
  return sel;
}

double sigmoid(final double val)
{
  return (1.0 / (1.0 + Math.exp(-val)));
}

private static double sigmoidDerivative(final double val)
{
  return (val * (1.0 - val));
}

