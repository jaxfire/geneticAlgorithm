
Cat[] cats;
int backgroundColour;
int generationSize;


void setup(){
  size(210,250);
  backgroundColour = 125;
  
  cats = new Cat[generationSize];
  
  generateInitialSample();
 
  display();
  
  
  
}

void generateInitialSample(){
  
  
}


void display(){
 
  background(backgroundColour);
  
}