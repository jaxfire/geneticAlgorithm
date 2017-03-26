
Cat[] cats;
int backgroundColour;
int generationSize;

int nextGenBtnX, nextGenBtnY, nextGenBtnWidth, nextGenBtnHeight;
int changeEnvironmentBtnX, changeEnvironmentBtnY, changeEnvironmentBtnWidth, changeEnvironmentBtnHeight;

boolean overNextGenBtn, overChangeEnvironmentBtn, toggleView;

void setup(){
  
  size(210,250);
  
  nextGenBtnX = 10;
  nextGenBtnY = 210;
  nextGenBtnWidth = 90;
  nextGenBtnHeight = 30;
  
  changeEnvironmentBtnX = 110;
  changeEnvironmentBtnY = 210;
  changeEnvironmentBtnWidth = 90;
  changeEnvironmentBtnHeight = 30;
  
  backgroundColour = 255;
  generationSize = 100; // Must be even
  
  cats = new Cat[generationSize];

  generateInitialSample();
  
  nextCycle();
  
}

void nextCycle(){
  
  //Step 1
  calculateFit();
  
  //Step 2
  cull();

  display();
  
  //Step 3
  reproduce();
  
}

void generateInitialSample(){
  
  for (int i = 0; i < generationSize; i++){
   
      cats[i] = new Cat(int(random(256)));
      
  }
  
}

void calculateFit(){
  for (int i = 0; i < generationSize; i++){

    cats[i].calcVariation(backgroundColour);
    
  } 
}


void cull(){
 
  cats = shuffle(cats);
  int killCount = 0;
  int i = 0;
  
  //Calculate the maximum possible variation that any cat has
  int maxVariation = 0;
  for (Cat c : cats) {
    if(c.getVariation() > maxVariation){
      maxVariation = c.getVariation();
    }
  }
  
  //cull half of the cats
  while (killCount < generationSize / 2){
    
    if (i > generationSize - 1){
      i = 0; 
    }
    
    //As we may have to loop back through the list of cats we need to make sure we haven't already killed the curretn cat.
    if(!cats[i].killed){
      
      //Monte Carlo random - Lower score valued cats have a higher chance of being killed
      float score = map(cats[i].getVariation(), 0, maxVariation, 1.0, 0.0);
      float qualifyingRandom = random(1);
      if(qualifyingRandom > score){
        cats[i].kill();
        killCount++;
      }
    }
  
    i++;
  }

}

void reproduce(){
  
  //Put survivors in to a new array (mating pool)
  Cat[] survivors = new Cat[generationSize / 2];
  
  int i = 0;
  
  for (Cat c : cats){
    if(!c.getKilled()){
       survivors[i] = c;
       i++;
    }
  }
  
  Cat[] nextGeneration = new Cat[generationSize];
  
  int offspringCounter = 0;
  
  for (int j = 0; j < generationSize; j++){
    
    //Pick two random maters
    Cat mateA = survivors[int(random(survivors.length))];
    Cat mateB = survivors[int(random(survivors.length))];
    
    //Get the offspring's colour
    //int mutatedColour = (mateA.getColour() + mateB.getColour()) / 2; //Find the mean
    
    int brightest, darkest;
    
    if(mateA.getColour() >= mateB.getColour()){
      brightest = mateA.getColour();
      darkest = mateB.getColour();
    } else {
      brightest = mateB.getColour();
      darkest = mateA.getColour();
    }
    
    int mutatedColour = -1;
    
    int mutationAllowance = 30;
    
    while(mutatedColour < 0 || mutatedColour > 255){
      mutatedColour = int(random(darkest - mutationAllowance, brightest + mutationAllowance));
    }
    
    //Add it to the next generation of cats
    nextGeneration[offspringCounter] = new Cat(mutatedColour);
    
    offspringCounter++;
   
  }
  
  //Update the main cats array with the new generation
  cats = nextGeneration;
  
}

Cat[] shuffle(Cat[] cats){
  
  Cat[] shuffled = cats;
  int n = shuffled.length;
  
  for (int i = 0; i < shuffled.length; i++) {
    
      // Get a random index of the array past i.
      int random = i + (int) (Math.random() * (n - i));
      // Swap the random element with the present element.
      Cat randomElement = shuffled[random];
      shuffled[random] = shuffled[i];
      shuffled[i] = randomElement;
      
  }  
  
  return shuffled;
  
}


void display(){
 
  background(backgroundColour);
  
  if(cats.length > 0){
  
    int gridWidth = 10;
    int gridHeight = 10;
    int width = 10;
    int height = 10;
    float separation = 2.0;
    int initialOffset = 10;
    
    for (int i = 0; i < generationSize; i++){
      
      int x = i % gridWidth;
      int y = i / gridHeight;

      fill(cats[i].getColour());
      
      rect(x * width * separation + initialOffset, y * height * separation + initialOffset, width, height);
    
    }
    
      
  }
  
  toggleView = !toggleView;
  
}

void draw(){
  
  fill(80,180,80);
  rect(nextGenBtnX, nextGenBtnY, nextGenBtnWidth, nextGenBtnHeight);
  
  fill(80,80,180);
  rect(changeEnvironmentBtnX, changeEnvironmentBtnY, changeEnvironmentBtnWidth, changeEnvironmentBtnHeight);
  
  if (overRect(nextGenBtnX, nextGenBtnY, nextGenBtnWidth, nextGenBtnHeight) ) {
    overNextGenBtn = true;
  } else {
    overNextGenBtn = false; 
  }
  
  if (overRect(changeEnvironmentBtnX, changeEnvironmentBtnY, changeEnvironmentBtnWidth, changeEnvironmentBtnHeight) ) {
    overChangeEnvironmentBtn = true;
  } else {
    overChangeEnvironmentBtn = false; 
  }
  
}

boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

void mousePressed() {
  if (overNextGenBtn) {
    nextCycle();
  }
  
  if (overChangeEnvironmentBtn) {
    changeEnvironment();
    nextCycle();
  }
}

void changeEnvironment(){
  if(backgroundColour == 255){
    backgroundColour = 0;
  } else {
    backgroundColour = 255;
  }
}