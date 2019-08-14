float [][] vecToMatrix(PVector v){
  float[][] m = new float [3][1];
  m[0][0] = v.x;
  m[1][0] = v.y;
  m[2][0] = v.z;
  return m;
}

PVector matrixToVec(float[][] m){
  PVector v = new PVector();
  v.x = m[0][0];
  v.y = m[1][0];
  if (m.length >2){
    v.z = m[2][0];
  }
  return v;
}

float[][] matmul(float [][]a, float [][]b){
   int colsA = a[0].length;
   int rowsA = a.length;
   int colsB = b[0].length;
   int rowsB = b.length;
   
   if (colsA != rowsB){
     println("columns of A must match rows of B");
     return null;
   }
   
   float result[][]= new float[rowsA][colsB];
   for (int i = 0; i < rowsA; i++){
     for (int j = 0; j < colsB; j++){
       float sum = 0;
       for (int k = 0; k< colsA; k++){
         sum += a[i][k] * b[k][j];
       }
       result[i][j] = sum;
     }
   }
   return result; 
}

void output_matrix(float [][]m){
  int cols = m[0].length;
  int rows = m.length;
  println(rows + " x " + cols);
  println("-------------------");
  for (int i = 0; i < rows; i++){
    for (int j = 0; j < cols; j++){
      print(m[i][j] + " ");
   }
    println();
  }
}

float determinant(float[][] matrix){ // takes a matrix (two dimensional array), returns determinant.
    int sum=0; 
    int s;
    if(matrix.length==1){  //bottom case of recursion. size 1 matrix determinant is itself.
      return(matrix[0][0]);
    }
    for(int i=0;i<matrix.length;i++){ //finds determinant using row-by-row expansion
      float[][]smaller = new float[matrix.length-1][matrix.length-1]; //creates smaller matrix- values not in same row, column
      for(int a=1;a<matrix.length;a++){
        for(int b=0;b<matrix.length;b++){
          if(b<i){
            smaller[a-1][b]=matrix[a][b];
          }
          else if(b>i){
            smaller[a-1][b-1]=matrix[a][b];
          }
        }
      }
      if(i%2==0){s=1;}else{s=-1;} //sign changes based on i
      sum+=s*matrix[0][i]*(determinant(smaller)); //recursive step: determinant of larger determined by smaller.
    }
    return(sum); //returns determinant value. 
  }
  

//Orientation Test: First Geometric predicate to support mesh generation
float orient2D_test (PVector a, PVector b, PVector c){
  float[][] m = {
    {1, a.x, a.y},
    {1, b.x, b.y},
    {1, c.x, c.y}
  };
  
  float det = (b.x - a.x) * (c.y - a.y) - (c.x - a.x) * (b.y - a.y);
  //float det = determinant(m);
  //if (det > 0){println("ccw orientation");};
  //if (det < 0){println("cw orientation. change the direction");};
  //if (det == 0){println("points are coincident. handle this error");};
  //println ("determinant is " + det);
  return det;
}

//In-Circle Test: Second Geometric predicate to support mesh generation
float incircle_test (PVector a, PVector b, PVector c, PVector d){
  float[][] m = {
    {a.x, a.y, pow(a.x,2) + pow(a.y, 2), 1.0},
    {b.x, b.y, pow(b.x,2) + pow(b.y, 2), 1.0},
    {c.x, c.y, pow(c.x,2) + pow(c.y, 2), 1.0},
    {d.x, d.y, pow(d.x,2) + pow(d.y, 2), 1.0}
  };
  
  float det = determinant(m);
  if (det > 0){println("fourth point is in circle. need to flip,");};
  if (det < 0){println("fourth point is outside circle, Delauney.");};
  if (det == 0){println("fourth point is on circle.");};
  return det;
}



PVector intersection(PVector a, PVector b, PVector c, PVector d){  
  // Line AB represented as coeff1*x + coeff2*y = c1 
  float coeffA1 = b.y - a.y; 
  float coeffB1 = a.x - b.x; 
  float coeffC1 = coeffA1*(a.x) + coeffB1*(a.y); 
 
  // Line CD represented as a2x + b2y = c2 
  float coeffA2 = d.y - c.y; 
  float coeffB2 = c.x - d.x; 
  float coeffC2 = coeffA2*(c.x)+ coeffB2*(c.y);
  
  float determinant = coeffA1*coeffB2 - coeffA2*coeffB1; 
       
  if (determinant == 0) 
  { 
      // The lines are parallel. This is simplified 
      // by returning a pair of FLT_MAX 
      println("lines are parallel -- need to better handle this case") ;
      return new PVector(0,0); 
  } 
  else
  { 
      float x = (coeffB2*coeffC1 - coeffB1*coeffC2)/determinant; 
      float y = (coeffA1*coeffC2 - coeffA2*coeffC1)/determinant; 
      return new PVector(x, y); 
  }   
}
