
class Grid{
    private int cols, rows;
    private float disp = 0;
    private Cell[] cells;


    Grid(float size){
        rows = 1 + int(gridHeight/size);
        cols = 1 + int(gridWidth/size);

        cells = new Cell[rows*cols];
        for(int a = 0; a< rows; a++){
            for(int b = 0; b < cols; b++){
                float dist = abs(b-(cols/2)); //distance from road.
                cells[a*cols + b] = new Cell(size*b,size*a, dist);

            }
        }
    }
    
    void move(float dt){
      disp -= (dt/1000) * moveSpeed;
      for(int i = 0; i<cells.length; i++){
          cells[i].move(disp);
      }
    }
      

    void show(){
        push();
        rotateX(PI/2);
        translate((width-gridWidth)/2,-0.8*gridHeight,-0.55*height);

        noStroke();
        fill(0);
        push();
        translate(0,0,-15);
        //rect(0,0,gridWidth,gridHeight);
        pop();

        beginShape(TRIANGLE_STRIP);
        addVertex(0,0);
        for(int a = 0; a < rows-1; a++){
            if(a%2 == 0){
                for(int b = 0; b< cols-1; b++){
                    addVertex(a+1,b);
                    addVertex(a,b+1);
                }
                addVertex(a+1,cols-1);
            }else{
                for(int b = cols-1; b>0; b--){
                    addVertex(a+1,b-1);
                    addVertex(a,b-1);
                }

            }
        }
        endShape();
        pop();
    }

    private void addVertex(int a,int b){
        Cell c = cells[a*cols + b];
        if(abs(b-(cols/2)) > roadHWidth){
            fill(0);
            stroke(255);
            //noStroke();
            vertex(c.getX(),c.getY(),c.getZ());
        }else{
            noFill();
            noStroke();
            vertex(c.getX(),c.getY(),-1);
        }
    }
}
