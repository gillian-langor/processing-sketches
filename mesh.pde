class Mesh {
  ArrayList<PVector> point_list = new ArrayList<PVector>();
  ArrayList<Tri> triangle_list = new ArrayList<Tri>();
  ArrayList<ArrayList<PVector>> borderList = new ArrayList<ArrayList<PVector>>(); 
  ArrayList<ArrayList<PVector>> legalizationList = new ArrayList<ArrayList<PVector>>(); 

  
  
  public Mesh() {}

  //Vertex newVertex(PVector coordinates) { return this.new Vertex(coordinates); }
  // add n number of random points within the canvas (excluding margin area)
  void create_seeds(int n, int w, int h, int margin) {
    for (int i = 0; i < n; i++) {  
      point_list.add(new PVector(random(margin, w - margin), random(margin, h - margin)));
    }
    point_list = sort_by_x_coord(point_list);
  }

  class Tri {
    private ArrayList<PVector> vertices;
    private int[] vertex_names;
    private Tri adjTriA;
    private Tri adjTriB;
    private Tri adjTriC;
    private PVector circumcenter;
    private PVector centroid;
    private PVector a; 
    private PVector b;
    private PVector c;

    public Tri(ArrayList<PVector> vertices) {
      if (vertices.size() != 3) {
        print("Triangles need 3 vertices");
      } else {
        triangle_list.add(this);
      }
      this.vertices = vertices;
      this.a = vertices.get(0);
      this.b = vertices.get(1);
      this.c = vertices.get(2);
      setCircumcenter();
      setCentroid();

 
    }
    
    public int [] getVNames() {
      this.vertex_names = new int []{point_list.indexOf(this.a), point_list.indexOf(this.b), point_list.indexOf(this.c)};
      return this.vertex_names;
    }
      
      
    public PVector setA(PVector a) {
      this.a = a;
      this.circumcenter = setCircumcenter();
      this.centroid = setCentroid();
      this.vertices.set(0,a);
      return this.a;
    }
    public PVector getA() {
      return this.a;
    }
    
    public PVector setB(PVector b) {
      this.b = b;
      this.circumcenter = setCircumcenter();
      this.centroid = setCentroid();
      this.vertices.set(1,b);

      return this.b;
    }
    public PVector getB() {
      return this.b;
    }
    
    public PVector setC(PVector c) {
      this.c = c;
      this.circumcenter = setCircumcenter();
      this.centroid = setCentroid();
      this.vertices.set(2,c);
      return this.c;
    }
    public PVector getC() {
      return this.c;
    }
    
    public Tri setAdjTriA(Mesh.Tri tri) {
      this.adjTriA = tri;
      return this.adjTriA;
    }
    public Tri getAdjTriA () {
      return this.adjTriA;
    }
    public Tri setAdjTriB(Mesh.Tri tri) {
      this.adjTriB = tri;
      return this.adjTriB;
    }
    public Tri getAdjTriB () {
      return this.adjTriB;
    }
    public Tri setAdjTriC (Mesh.Tri tri) {
      this.adjTriC = tri;
      return this.adjTriC;
    }
    
    public Tri getAdjTriC () {
      return this.adjTriC;
    }
    
    public ArrayList<Tri> getAdjTriList () { //<>//
      return new ArrayList<Tri>(Arrays.asList(this.adjTriA, this.adjTriB, this.adjTriC));
    }
    
        
    public PVector setCircumcenter(){    
      PVector ab_mid = new PVector((this.a.x + this.b.x)/2, (this.a.y + this.b.y)/2); //<>//
      PVector bc_mid = new PVector((this.b.x + this.c.x)/2, (this.b.y + this.c.y)/2);    //<>//
      PVector ab_delta = new PVector(ab_mid.y - this.a.y, this.a.x - ab_mid.x); //the offsets of the perp point from midpoint
      PVector ab_perp_bisector = new PVector(ab_mid.x + ab_delta.x, ab_mid.y + ab_delta.y);
      PVector bc_delta = new PVector(bc_mid.y - this.b.y, this.b.x - bc_mid.x);
      PVector bc_perp_bisector = new PVector(bc_mid.x + bc_delta.x, bc_mid.y + bc_delta.y);
      this.circumcenter = intersection(ab_mid, ab_perp_bisector, bc_mid, bc_perp_bisector);
      return circumcenter;
     }
    
    public PVector getCircumcenter () {
      return this.circumcenter;
    }
    
    public PVector setCentroid(){    
      PVector ab_mid = new PVector((this.a.x + this.b.x)/2, (this.a.y + this.b.y)/2);
      PVector bc_mid = new PVector((this.b.x + this.c.x)/2, (this.b.y + this.c.y)/2);
      this.centroid = intersection(ab_mid, this.c, bc_mid, this.a);
      return centroid;
     }
    
    public PVector getCentroid () {
      return this.centroid;
    }
    
    public void legalize () {
      //legalize new triangle with its neighbors
      if (this.getAdjTriA() != null) {
        println("triangle has adj TriA");
        PVector d;
        int index;
        if (! this.vertices.contains(this.getAdjTriA().vertices.get(0))){
          d = this.getAdjTriA().vertices.get(0);
          index = 0;
        } else if (! this.vertices.contains(this.getAdjTriA().vertices.get(1))){
          d = this.getAdjTriA().vertices.get(1);
          index = 1;
  
        } else {
          d = this.getAdjTriA().vertices.get(2);
          index = 2;
        }
        
        println(d);
        println(this.vertices);
        println(this.getAdjTriA().vertices);
        
        float det = incircle_test(a,b,c,d);
        if (det > 0){
          this.vertices.set(1,d); // reset new triangle from ABC to ADC
          int index_a = this.getAdjTriA().vertices.indexOf(a);
          this.getAdjTriA().vertices.set(index_a, c); // reset adj_triangle_A from DBA to DBC
        }
        
        
      }
    }
    
  }  
}
