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

void settings(){
    // size(800,600,P3D);
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
    // frameRate(fps);
}

void draw(){

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

void setCircleGradient(int x, int y, float r, color c1, color c2, int axis ) {

  noFill();
  strokeWeight(1);

//   println("heehehe");

  if (axis == Y_AXIS) {  // Top to bottom gradient
    for (float i = y - r; i <= y+r; i++) {
      float inter = map(i, y-r, y+r, 0, 1);
      color c = lerpColor(c1, c2, inter);
        float interR = sqrt(pow(r, 2) - pow(i, 2));
    //   println("interR: "+interR);
      stroke(c);
      line(x-interR, i, 0, x+interR, i, 0);
    }
  }  
  else if (axis == X_AXIS) {  // Left to right gradient
    for (float i = x - r; i <= x + r; i++) {
      float inter = map(i, x-r, x+r, 0, 1);
      color c = lerpColor(c1, c2, inter);
        float interR = sqrt(pow(r, 2) - pow(i, 2));
                    // println("interR: "+interR);

      stroke(c);
      line(i, y-interR, 0, i, y+interR, 0);
    }
  }
}