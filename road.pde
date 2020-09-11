class Road{
    private int colour = 33;
    private float grit, disp = 0;
    private Cell[] tarmac;
    private int cols, rows;

    Road(float g){
        grit = g;
        cols = int((2*terrainSize*roadHWidth)/grit);
        rows = int(gridHeight/grit);

        tarmac = new Cell[cols*rows];
        for(int a = 0; a<rows; a++){
            for(int b = 0; b<cols; b++){
                tarmac[a*cols + b] = new Cell(b*grit,a*grit, 1);
            }
        }
    }

    void move(float dt){
      disp -= dt * moveSpeed;
      for(int i = 0; i<tarmac.length; i++){
          tarmac[i].move(disp);
      }
    }

    void show(){
        push();
        rotateX((PI/2));
        translate((width-(2*terrainSize*roadHWidth))/2,-0.8*gridHeight,-0.55*height);
        shininess(6);
        for(int i = 0; i < tarmac.length; i++){
            Cell c = tarmac[i];
            noStroke();
            fill(c.getZ());
            blendMode(REPLACE);
            rect(c.getX(),c.getY(),grit,grit);
        }
        pop();
    }
}