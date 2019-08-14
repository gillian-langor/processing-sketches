/* Implements ___ algorithm to build and optimize delauney mesh. //<>//
 //good examples from open processing:
 //https://www.openprocessing.org/sketch/404200/
 //another good reference for mesh traversal: https://observablehq.com/@2talltim/mesh-data-structures-traversal
 */

import java.util.Random;

Mesh mesh = new Mesh();

void setup() {
  size (600, 400);
  //translate(0, height);
  //scale(1.0,-1.0);
  noLoop();
  background(255);
  stroke(0);
  strokeWeight(5);

  int margin = 20;

  mesh.create_seeds(6, width, height, margin);
  initialize(mesh.point_list);
  for (int i = 3; i< mesh.point_list.size(); i++){
    addPointToTriangulation(mesh.point_list, i);
  }
  
  draw_points(mesh.point_list);
  color textColor = color(1);
  fill(textColor);
  add_point_labels(mesh.point_list, 5);
  
  color triColor = color(120, 160, 124,30);
  fill(triColor);

  drawTriangles(mesh.triangle_list);
    
  //outputMeshResults();


}
void draw() {


}

ArrayList<PVector> sort_by_x_coord(ArrayList<PVector> point_list) {
  // Implement a selection sort 
  for (int i = 0; i < point_list.size(); i++) {
    //println("i = " + i);
    float current_min = point_list.get(i).x;
    //float current_min = x_i;
    int selected_index = i;

    for (int j = i; j < point_list.size(); j++) {
      //println("j = " + j);
      float x_j = point_list.get(j).x;
      if (x_j < current_min) {
        selected_index = j;
        current_min = x_j;
      }
    }
    //swap current value with next lowest value
    PVector temp = point_list.get(i);
    point_list.set(i, point_list.get(selected_index));
    point_list.set(selected_index, temp);
  }
  //for (int k = 0; k < point_list.size(); k++){println(point_list.get(k));
  return point_list; // returns point list along x-axis
}

void outputMeshResults(){
println("************* Border List *************");
  for (int i=0; i<mesh.borderList.size(); i++){
    println(mesh.borderList.get(i));
  }
   

//point_list 
//triangle_list
}

void draw_points(ArrayList<PVector> point_list) {
  for (int i = 0; i < point_list.size(); i++) {
    println("drawing point " + i + ": (" +  point_list.get(i).x + ", " + point_list.get(i).y + ")");
    point(point_list.get(i).x, point_list.get(i).y);
  }
}

void add_point_labels(ArrayList<PVector> point_list, int label_offset) {
  textSize(10);
  for (int i = 0; i < point_list.size(); i++) {  
    text(i, point_list.get(i).x + label_offset, point_list.get(i).y + label_offset);
  }
}

void drawTriangles(ArrayList<Mesh.Tri> triangle_list) {
  strokeWeight(1);
  for (int i = 0; i < triangle_list.size(); i++) {
    println("drawing triangle " + i + " verts = " + Arrays.toString(triangle_list.get(i).vertex_names));
    println("adjacent triangles = " + triangle_list.get(i).getAdjTriList());
    
    PVector a = triangle_list.get(i).vertices.get(0);
    PVector b = triangle_list.get(i).vertices.get(1);
    PVector c = triangle_list.get(i).vertices.get(2);
    strokeWeight(1);
    triangle(a.x, a.y, b.x, b.y, c.x, c.y);
    strokeWeight(5);

    PVector tri_center = triangle_list.get(i).getCentroid();
    point(tri_center.x, tri_center.y);

    //text(i, tri_center.x, tri_center.y);
    //println("adjacent tri list: " + triangle_list.get(i).getAdjTriList());
  }
}

void initialize(ArrayList<PVector> point_list) {
  println("****** Starting Triangle  ******");
  float orientation = orient2D_test(point_list.get(0),point_list.get(1), point_list.get(2) );
  ArrayList <PVector> triangle_0_vertices = new ArrayList<PVector>();
  PVector a; 
  PVector b; 
  PVector c;
  if (orientation >0) {
    a = point_list.get(0);
    b = point_list.get(1);
    c = point_list.get(2);
  } else {
    a = point_list.get(1);
    b = point_list.get(0);
    c = point_list.get(2);
  }
  triangle_0_vertices.add(a);
  triangle_0_vertices.add(b);
  triangle_0_vertices.add(c);
  Mesh.Tri triangle_0 = mesh.new Tri(triangle_0_vertices);

  //Create edges
  ArrayList <PVector> ab = new ArrayList<PVector>(Arrays.asList(a, b));
  ArrayList <PVector> bc = new ArrayList<PVector>(Arrays.asList(b, c));
  ArrayList <PVector> ca = new ArrayList<PVector>(Arrays.asList(c, a));

  // Add edges to convex hull in the ccw direction in their triangle
  mesh.borderList.add(ab);
  mesh.borderList.add(bc);
  mesh.borderList.add(ca);
  
  println("Initial triangle is " + Arrays.toString(mesh.triangle_list.get(0).getVNames()));
  
}



void addPointToTriangulation(ArrayList<PVector> point_list, int k) {
  // test which edges are on the left of the new point. Will need to flip orientation of this edge.
  ArrayList<ArrayList<PVector>> candidateHullEdges = new ArrayList<ArrayList<PVector>>();
  for (int i = 0; i < mesh.borderList.size(); i++) {
    float orientation = orient2D_test(mesh.borderList.get(i).get(0), mesh.borderList.get(i).get(1), point_list.get(k));
    if (orientation < 0) { //test whether new point is on the right of the line on the border edge (which is pointing in a ccw direction around the hull)
      candidateHullEdges.add(mesh.borderList.get(i));
    }
  }
  println ("candidate hull edges to be connected for point " + k + " are: ");
  for (int r = 0; r< candidateHullEdges.size(); r++){println(candidateHullEdges.get(r));}

  for (int j = 0; j < candidateHullEdges.size(); j++) {
    println("****** Adding New Point " + k +  "******");
    ArrayList <PVector> newTriangleVertices = new ArrayList<PVector>();
    PVector a; PVector b; PVector c;
    a = candidateHullEdges.get(j).get(1);
    b = candidateHullEdges.get(j).get(0);
    c = point_list.get(k); 

    //points in new triangle are added in ccw order
    newTriangleVertices.add(a);
    newTriangleVertices.add(b);
    newTriangleVertices.add(c);
    Mesh.Tri triangle_new = mesh.new Tri(newTriangleVertices);
    
    //remove twin from 
    ArrayList <PVector> ba = new ArrayList<PVector>(Arrays.asList(b,a)); // this is the base edge, remove this edge from border list
    mesh.borderList.remove(ba); //remove the record of the base edge, BC from the outer hull

    //Create edges
    ArrayList <PVector> bc = new ArrayList<PVector>(Arrays.asList(b,c));
    ArrayList <PVector> ca = new ArrayList<PVector>(Arrays.asList(c,a));

    // update convex hull -- NOTE these need to be entered in CCW order. 
 

    //add  only if its reversed edge is not already in border list
    ArrayList <PVector> ac = new ArrayList<PVector>(Arrays.asList(a,c));
    ArrayList <PVector> cb = new ArrayList<PVector>(Arrays.asList(c,b));

    if (mesh.borderList.contains(ac)==true){
      mesh.borderList.remove(ac);
    } else {
      mesh.borderList.add(ca);
    }
    
    if (mesh.borderList.contains(cb)==true){
      mesh.borderList.remove(cb);
    } else {
      mesh.borderList.add(bc);
    }
    
    for (int m = 0; m < mesh.triangle_list.size()-1; m++){
      if (mesh.triangle_list.get(m).vertices.contains(a) && mesh.triangle_list.get(m).vertices.contains(b)){
        println("found adjacent triangle that contains AB. index is " + m); 
        triangle_new.setAdjTriA(mesh.triangle_list.get(m)); // add previously created adjacent triangle //<>//
        mesh.triangle_list.get(m).setAdjTriB(triangle_new); // add reverse adjacent triangle //<>// //<>//
      }
       //<>//
      
      if (mesh.triangle_list.get(m).vertices.contains(b) && mesh.triangle_list.get(m).vertices.contains(c)){ //<>//
        println("found adjacent triangle that contains BC. index is " + m);  //<>//
        triangle_new.setAdjTriB(mesh.triangle_list.get(m)); // add previously created adjacent triangle
        mesh.triangle_list.get(m).setAdjTriC(triangle_new); // add reverse adjacent triangle //<>//
      }
    } //<>//
    
    //<>// //<>//

  }
}
