Grid grid;
Road road;

float terrainSize = 40; // in terms of size of squares generated on terrain grid;
float roadGrit = 20; // in terms of squares of grit on the road;
float gridHeight = 4000;
float gridWidth = 2000;

//Translate and Rotate Constants.
        // rotateX(PI/2);
        // translate((width-gridWidth)/2,-0.91*gridHeight,-0.65*height);
float rotX, traX, traY, traZ;

int deltaTime = 0;
int lastTime = 0;

float noiseSize = 300; //Higher means smoother.
float maxHeight = 400; //Max height of mountains/regions;
float minHeight = -200; //min height of regions;
float moveSpeed = 1;
float roadHWidth = 3; //Half width of the road in # of cells.

void settings(){
    //size(800,600,P3D);
    fullScreen(P3D);
}

void setup(){
    gridHeight = 4 * height; 
    gridWidth = 1 * width;

    grid = new Grid(terrainSize);
    road = new Road(roadGrit);
    //smooth(8);

    float rotX = PI/2;
    float traX = (width-gridWidth)/2;
    float traY = -0.91*gridHeight;
    float traZ = -0.65*height;
}

void draw(){
    background(color(135,0,90));
    push();
        fill(color(255, 190, 48));
        stroke(0);
        strokeWeight(0);
        translate(width/2,height/2,-1*gridHeight);
        ellipse(0,0,1000,1000);
        noStroke();
        fill(0);
        rect(-4*gridWidth,50,gridWidth*8,gridHeight*6);
    pop();
    deltaTime = millis() - lastTime;
    grid.show();
    road.show();
    grid.move(deltaTime);
    road.move(deltaTime);
    lastTime = millis();
}
