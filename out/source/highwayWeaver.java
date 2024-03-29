import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class highwayWeaver extends PApplet {

int Y_AXIS = 1;
int X_AXIS = 2;

Grid grid;
Road road;

float terrainSize = 40; // in terms of size of squares generated on terrain grid;
float roadGrit = 60; // in terms of squares of grit on the road;
float gridHeight = 2600;
float gridWidth = 2600;
// int fps = 30;
// float dt = 1/((float) fps);
float dt = 1/30;

//Translate and Rotate Constants.
        // rotateX(PI/2);
        // translate((width-gridWidth)/2,-0.91*gridHeight,-0.65*height);
float rotX, traX, traY, traZ;

float deltaTime = 0;
float lastTime = 0;

float noiseSize = 300; //Higher means smoother.
float maxHeight = 250; //Max height of mountains/regions;
float minHeight = -100; //min height of regions;
float moveSpeed = 1;
float roadHWidth = 3; //Half width of the road in # of cells.

public void settings(){
    // size(800,600,P3D);
    fullScreen(P3D);
}

public void setup(){
    gridHeight = 4 * height; 
    gridWidth = 1 * width;

    grid = new Grid(terrainSize);
    road = new Road(roadGrit);
    //smooth(8);

    float rotX = PI/2;
    float traX = (width-gridWidth)/2;
    float traY = -0.91f*gridHeight;
    float traZ = -0.65f*height;
    // frameRate(fps);
}

public void draw(){

    dt = 1/((float) frameRate);

    // background(color(135,0,90));
    background(0);
    push();
        fill(color(255, 190, 48));
        stroke(0);
        strokeWeight(0);
        translate(width/2,height/3,-1*gridHeight);
        // ellipse(0,0,1000,1000);
        setCircleGradient(0, 0, 500, color(135,0,90) ,color(255, 190, 48), Y_AXIS);
        noStroke();
        fill(0);
        // rect(-4*gridWidth,50,gridWidth*8,gridHeight*6);
    pop();

    float currentTime = millis();
    deltaTime = (currentTime - lastTime) / 1000;
    grid.show();
    road.show();
    while(deltaTime > dt){
        grid.move(dt);
        road.move(dt);
        deltaTime -= dt;
    }
    lastTime = currentTime;
}

public void setCircleGradient(int x, int y, float r, int c1, int c2, int axis ) {

  noFill();
  strokeWeight(1);

//   println("heehehe");

  if (axis == Y_AXIS) {  // Top to bottom gradient
    for (float i = y - r; i <= y+r; i++) {
      float inter = map(i, y-r, y+r, 0, 1);
      int c = lerpColor(c1, c2, inter);
        float interR = sqrt(pow(r, 2) - pow(i, 2));
    //   println("interR: "+interR);
      stroke(c);
      line(x-interR, i, 0, x+interR, i, 0);
    }
  }  
  else if (axis == X_AXIS) {  // Left to right gradient
    for (float i = x - r; i <= x + r; i++) {
      float inter = map(i, x-r, x+r, 0, 1);
      int c = lerpColor(c1, c2, inter);
        float interR = sqrt(pow(r, 2) - pow(i, 2));
                    // println("interR: "+interR);

      stroke(c);
      line(i, y-interR, 0, i, y+interR, 0);
    }
  }
}
class Cell{
    private float x, y, z = 1, distance, myMin, myMax;

    Cell(float i,float j, float dist){
        x = i;
        y = j;
        distance = dist; //distance from road;
        updateZ(0);
        updateMinMax();
    }

    public void move(float d){
        updateZ(d);
    }

    private void updateZ(float d){
        // if(distance > 3){
            z = map(noise(x/noiseSize,(y/noiseSize) + d), 0,1,myMin,myMax);
        // }else{
        //     if(z > -1){
        //         z = map(random(1), 0, 1, myMin, myMax);
        //     }
        // }
        //z = 0;
    }

    private void updateMinMax(){
        // System 1: based on exponential growth powers...
        // float mapMax = pow((cols/2)-3,3);
        // float mapVal = pow(distance,3);
        // myMax = map(mapVal,0,mapMax,10,maxHeight);
        // myMin = map(mapVal,0,mapMax,-10,minHeight);

        // System 2: make 2 blocks distances only affect z from noise by 10%;
        if(distance <= 3){
            // myMax = 255;
            // myMin = 0;
            myMax = 40;
            myMin = 10;
        }else if(distance <= 4){
            myMax = 0.1f * maxHeight;
            myMin = 0.1f * minHeight;
        }else if(distance <= 6){
            myMax = 0.3f * maxHeight;
            myMin = 0.3f * minHeight;
        }else{
            myMax = maxHeight;
            myMin = minHeight;
        }
    }

    public float getX(){
        return x;
    }

    public float getY(){
        return y;
    }

    public float getZ(){
        return z;
    }
}
class Grid{
    private int cols, rows;
    private float disp = 0;
    private Cell[] cells;


    Grid(float size){
        rows = 1 + PApplet.parseInt(gridHeight/size);
        cols = 1 + PApplet.parseInt(gridWidth/size);

        cells = new Cell[rows*cols];
        for(int a = 0; a< rows; a++){
            for(int b = 0; b < cols; b++){
                float dist = abs(b-(cols/2)); //distance from road.
                cells[a*cols + b] = new Cell(size*b,size*a, dist);

            }
        }
    }
    
    public void move(float dt){
      disp -= dt * moveSpeed;


        for(int a = 0; a < rows-1; a++){
            for(int b = 0; b< cols-1; b++){
                if(abs(b-(cols/2)) > roadHWidth){
                    cells[a * cols + b].move(disp);  
                }
            }
        }

    //   for(int i = 0; i<cells.length; i++){
    //     if(abs(b-(cols/2)) > roadHWidth){
    //         cells[i].move(disp);  
    //     }
    //   }
    }
      

    public void show(){
        push();
        rotateX(PI/2);
        translate((width-gridWidth)/2,-0.8f*gridHeight,-0.55f*height);

        noStroke();
        fill(0);
        push();
        translate(0,0,-15);
        rect(0,0,gridWidth,gridHeight);
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
            // stroke(255);
            stroke(color(0, 175, 255));
            //noStroke();
            vertex(c.getX(),c.getY(),c.getZ());
        }else{
            noFill();
            noStroke();
            vertex(c.getX(),c.getY(),-1);
        }
    }
}
class Road{
    private int colour = 33;
    private float grit, disp = 0;
    private Cell[] tarmac;
    private int cols, rows;

    Road(float g){
        grit = g;
        cols = PApplet.parseInt((2*terrainSize*roadHWidth)/grit);
        rows = PApplet.parseInt(gridHeight/grit);

        tarmac = new Cell[cols*rows];
        for(int a = 0; a<rows; a++){
            for(int b = 0; b<cols; b++){
                tarmac[a*cols + b] = new Cell(b*grit,a*grit, 1);
            }
        }
    }

    public void move(float dt){
      disp -= dt * moveSpeed;
      for(int i = 0; i<tarmac.length; i++){
          tarmac[i].move(disp);
      }
    }

    public void show(){
        push();
        rotateX((PI/2));
        translate((width-(2*terrainSize*roadHWidth))/2,-0.8f*gridHeight,-0.55f*height);
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
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "highwayWeaver" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
