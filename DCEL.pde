import java.util.*;
import java.math.*;

/** 
 * doubly-connected edge list data structure
 */ 
 


class DCEL {
  //creates three lists of objects to describe the triangulation
  ArrayList<Vertex> vertices = new ArrayList<Vertex>();
  ArrayList<HalfEdge> halfEdges = new ArrayList<HalfEdge>();
  ArrayList<Face> faces = new ArrayList<Face>();
  
  //Face outerFace = null;
  
  public DCEL() {
    //outerFace = this.new Face();
  }
  
  Vertex newVertex(PVector coordinates) { return this.new Vertex(coordinates); }
  HalfEdge newHalfEdge(Vertex origin, Face face) { return this.new HalfEdge(origin, face); }
  Face newFace() { return this.new Face(); }
  
  ArrayList<HalfEdge> getCycleFrom(HalfEdge e) {
    // TODO Fill in
    return null; 
  }
  
  class HalfEdge {
    HalfEdge twin = null, next = null, prev = null; 
    Vertex origin = null; 
    Face face = null;
    
    private HalfEdge(Vertex origin, Face face) {
      this.origin = origin;
      this.face = face;
      halfEdges.add(this); //adding to the arraylist of half edges
      origin.outgoingEdge = this;
    }
    
    Vertex getDestination() {
      return twin.origin;
    }
  }
  
  class Vertex {
    PVector coord;
    HalfEdge outgoingEdge; 
    private  Vertex(PVector coordinates) {
      vertices.add(this);
      this.coord = coordinates; 
    }
  }
  
  class Face {
    HalfEdge incidentEdge; 
    private Face() {
      faces.add(this);
    }
  }
  
}
