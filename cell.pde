class Cell{
    private float x, y, z, distance, myMin, myMax;
    
    Cell(float i,float j, float dist){
        x = i;
        y = j;
        distance = dist; //distance from road;
        updateZ(0);
        updateMinMax();
    }

    void move(float d){
        updateZ(d);
    }

    private void updateZ(float d){
        z = map(noise(x/noiseSize,(y/noiseSize) + d), 0,1,myMin,myMax);
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
            myMax = 33;
            myMin = 22;
        }else if(distance <= 4){
            myMax = 0.1 * maxHeight;
            myMin = 0.1 * minHeight;
        }else if(distance <= 6){
            myMax = 0.3 * maxHeight;
            myMin = 0.3 * minHeight;
        }else{
            myMax = maxHeight;
            myMin = minHeight;
        }
    }

    float getX(){
        return x;
    }

    float getY(){
        return y;
    }

    float getZ(){
        return z;
    }
}
