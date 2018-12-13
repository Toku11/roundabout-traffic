public class Utils {
  float y, x;
  Utils() {
  }

  public int roundAngle(float angle){
    if(inRange(abs(angle), 0, sin(QUARTER_PI)))
      return 0;
    else
      return (int)(angle/abs(angle));
  }
  public boolean isVelMin(float vel) {
    if (vel >= 20.0)  return true;
    else  return false;
  }

  public boolean isVelMax(float vel) {
    if (vel <= 10.0) return true;
    else return false;
  }

  public boolean inRange(float val, float x, float y) {
    if (val >= x && val <= y) return true;
    else return false;
  }

  public boolean isOut(PVector point) {
    if (point.x <= -500 || point.y <= -500 || point.x >= 500 || point.y >= 500) {
      return true;
    }
    return false;
  }
  
  public float euclideanDist(float x1, float y1, float x2, float y2){
    return sqrt(pow((x2 - x1),2) + pow((y2 - y1),2));
  }

  public boolean isVehicle(PVector point) {
    //PImage detectPixels;
    //detectPixels = get();
    //detectPixels.loadPixels();
   // print(detectPixels.pixels[0]);
    float col = red(get((int)point.x + 500, 500 - ((int)point.y)));// &0xFF;
    float col2 = blue(get((int)point.x + 500, 500 - ((int)point.y)));
    float col3 = green(get((int)point.x + 500, 500 - ((int)point.y)));
    if (col != col2 && col != col3) return true;
    return false;
  }

  public boolean isBlocked(ArrayList<PVector> sensors, char side) {
    for (PVector sensor : sensors) { //x : distance last point, y : angle
      if (sensor.x < 10.0 && side=='l' && inRange(sensor.y, 45, 135)) {
        return true;
      }
      if (sensor.x < 10.0 && side=='r' && inRange(sensor.y, 225, 315)) {
        return true;
      }
      if (sensor.x < 10.0 && side=='f' && (inRange(sensor.y, 0, 45)||inRange(sensor.y, 315, 360))) {
        return true;
      }
    }
    return false;
  }

  public int lane(float radius) {// calculate discrete difference along the x axis
    return (int)(radius-165)/30;
  }

  public float[] diff(float[] x) {
    int nx = x.length - 1; 
    float[] h = new float[nx];

    for (int i = 0; i < nx; ++i) {
      h[i] = x[i+1] - x[i];
    }
    return h;
  }
  
  public float[] arrayListToArray(ArrayList<Float> arrayList){
    float[] array = new float[arrayList.size()];
    int i = 0;
    for(float x : arrayList){
      array[i] = x;
      ++i;
    }
    return array;
  }
  public PVector doubleArrayListToPVector(ArrayList<ArrayList<Float>> arrayList){
    PVector output = new PVector();
    output.x = arrayList.get(0).get(0);
    output.y = arrayList.get(1).get(0);
    output.z = arrayList.get(2).get(0);
    return output;
  }
  public  float[] arange(float start, float stop, float step) {
    ArrayList<Float> output = new ArrayList<Float>();
    for (Float i = start; i < stop; i+=step) {
      output.add(i);
    }
    float[] arrayOut = arrayListToArray(output);
    return arrayOut;
  }

  public float[]  cumsum(float[] vector){
    float[] output = new float[vector.length];
    output[0] = vector[0];
    for(int i = 1; i < (vector.length); ++i){
      output[i] = output[i-1] + vector[i];
    }
    return output;
  }
  
  public float[] extend(float[] A, float[] B){

    float[] output = new float[A.length + B.length];
    ArrayList<Float> aux = new ArrayList<Float>();
    for(float x : A){
      aux.add(x);
    }
   
   for(float x : B){
      aux.add(x);
    }
   output = arrayListToArray(aux);
   return output;
  }
  
  public int bisect_bisect(float value, float[] x){
    int i;
    for(i = 0; i < x.length; ++i){
      if(value < x[i]){
        return i; 
      }
    }
    return i;
  }
  
  public float[] clip_(float[] array, float min, float max){
    for (int i = 0; i < array.length; i++){
      array[i] = (min < array[i]) ? array[i] : min;
      array[i] = (max > array[i]) ? array[i] : max;
    }
    //println(array);
    return array;
  }
  
  public float clip_(float val, float min, float max){
      val = (min < val) ? val : min;
      val = (max > val) ? val : max;
    return val;
  }
  
  public float normalizeAngle(float angle){
    while (angle > PI){
      angle -= TWO_PI;
    }
    
    while(angle < - PI){
      angle += TWO_PI ;
    }
    return angle;
  }
  
  public class Matrix {
    double[][] matrix, origMat;
    int[] piv;
    int pivsign = 1, numRows, numColumns;
    Matrix(float[][] mat) {
      this.matrix = floatToDouble(mat);
      this.origMat = floatToDouble(mat);
      numRows = matrix.length;
      numColumns = matrix[0].length;
      piv = new int[numRows];
      for (int i = 0; i < numRows; i++) {
        piv[i] = i;
      }
      pivsign = 1;
      double[] rowi;
      double[] colj = new double[numRows];

      for (int j = 0; j < numColumns; j++) {
        for (int i = 0; i < numRows; i++) {
          colj[i] = matrix[i][j];
        }

        for (int i = 0; i < numRows; i++) {
          rowi = matrix[i];
          int kmax = Math.min(i, j);
          float s = 0.0f;
          for (int k = 0; k < kmax; k++) {
            s += rowi[k] * colj[k];
          }
          rowi[j] = colj[i] -= s;
        }

        int p = j;
        for (int i = j+1; i < numRows; i++) {
          if (Math.abs(colj[i]) > Math.abs(colj[p])) {
            p = i;
          }
        }
        if (p != j) {
          for (int k = 0; k < numColumns; k++) {
            double t = matrix[p][k]; 
            matrix[p][k] = matrix[j][k]; 
            matrix[j][k] = t;
          }
          int k = piv[p]; 
          piv[p] = piv[j]; 
          piv[j] = k;
          pivsign = -pivsign;
        }

        if (j < numRows & matrix[j][j] != 0.0) {
          for (int i = j+1; i < numRows; i++) {
            matrix[i][j] /= matrix[j][j];
          }
        }
      }
    } 
    public void mPrint() {
      for (int i = 0; i < origMat.length; i++) {
        for (int j = 0; j < origMat.length; j++) {
          print(" " + origMat[i][j]+",");
        }
        println(";");
      }
    }

    public double[][] floatToDouble(float[][] _inputMatrix) {
      int numColumns = _inputMatrix[0].length; 
      int numRows = _inputMatrix.length;
      double[][] outputMatrix = new double[numRows][numColumns];
      for (int i = 0; i < numRows; i++) {
        for (int j = 0; j < numColumns; j++) {
          outputMatrix[i][j] = (double)_inputMatrix[i][j];
        }
      }    
      return outputMatrix;
    }

    public double[] floatToDouble(float[] _inputVec) {
      int numRows = _inputVec.length;
      double[] outputMatrix = new double[numRows];
      for (int i = 0; i < numRows; i++) {
        outputMatrix[i] = (double)_inputVec[i];
      }    
      return outputMatrix;
    }

    public float[][] mCopy() {
      int numRows = matrix.length; 
      int numColumns = matrix[0].length;
      float[][] newMat = new float[numRows][numColumns];
      for (int i = 0; i < numRows; i++) {
        System.arraycopy(matrix[i], 0, newMat[i], 0, numColumns);
      }    
      return newMat;
    }

    public float det () {
      if (numRows != numColumns) {
        throw new IllegalArgumentException("Matrix must be square.");
      }
      double d = (double) pivsign;
      for (int j = 0; j < numColumns; j++) {
        d *= matrix[j][j];
      }
      return (float)d;
    }

    public boolean isNonsingular () {
      for (int j = 0; j < numColumns; j++) {
        if (matrix[j][j] == 0)
          return false;
      }
      return true;
    }

    public float[] populate( float[] fullDataset, int[] indices) {
      float[] outputDat = new float[indices.length];
      for (int i = 0; i < indices.length; i++) {
        outputDat[i] = fullDataset[indices[i]];
      }
      return outputDat;
    }

    public double[] solve (float[] b, boolean returnZeroesForSingularCase) {
      if (b.length != numRows) {
        throw new IllegalArgumentException("Matrix row dimensions must agree.");
      }
      if (!this.isNonsingular()) {
        if (returnZeroesForSingularCase) return new double[numColumns];
        else throw new RuntimeException("Matrix is singular.");
      }

      // Copy right hand side with pivoting
      double[] X = floatToDouble(populate(b, piv));
      //System.out.println(X.length+","+b.length+","+LU[0].length);
      // Solve L*Y = B(piv,:)
      for (int k = 0; k < numColumns; k++) {
        for (int i = k+1; i < numColumns; i++) {
          X[i] -= X[k] * matrix[i][k];
        }
      }
      // Solve U*X = Y;
      for (int k = numColumns-1; k >= 0; k--) {
        X[k] /= matrix[k][k];
        for (int i = 0; i < k; i++) {
          X[i] -= X[k] * matrix[i][k];
        }
      }
      return X;
    }
  }
}
