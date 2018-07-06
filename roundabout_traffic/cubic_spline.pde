class Spline {
  ArrayList <Float> x = new ArrayList<Float>();
  ArrayList <Float> y = new ArrayList<Float>();
  utils utils = new utils();
  
  Spline(ArrayList<Float> x, ArrayList<Float> y ){
     this.x = x;
     this.y = y;
     ArrayList<Float> h = utils.diff(x);
     float[][] A = calc_A(h); 
     float[] B = calc_B(h);
     
     for(int i = 0; i<A.length;i++){
       for(int j = 0; j<A.length;j++){
         print(" "+ A[i][j]);
       }
       println();
     }
     for(int i = 0; i<B.length;i++){
     print(" "+B[i]);
     }
  }
  
     private float[][] calc_A(ArrayList<Float> h){
        int nx = h.size() + 1;
        float[][] A = new float[nx][nx];
        A[0][0] = 1;
        
        for(int i = 0; i < nx - 1; i++){
          if(i != (nx - 2))
            A[i + 1][i + 1] = 2.0 * (h.get(i) + h.get(i + 1));
          A[i + 1][i] = h.get(i);
          A[i][i + 1] = h.get(i);
        }
        
        A[0][1] = 0.0;
        A[nx - 1][nx - 2] = 0.0;
        A[nx - 1][nx - 2] = 1.0;
        return A;
     }
        
    private float[] calc_B(ArrayList<Float> h){
        int nx = h.size() + 1;
        float[] B = new float[nx];
        for(int i = 0; i < nx - 2; i++){
            B[i + 1] = 3.0 * (y.get(i + 2) - y.get(i + 1)) /
                h.get(i + 1) - 3.0 * (y.get(i + 1) - y.get(i)) / h.get(i);
        }
        return B;
    }  
  
}
