
Cat[] cats;
int backgroundColour;
int generationSize;

int buttonX, buttonY, buttonWidth, buttonHeight;

boolean rectOver, toggleView;

void setup(){
  
  size(210,250);
  
  buttonX = 10;
  buttonY = 210;
  buttonWidth = 190;
  buttonHeight = 30;
  
  backgroundColour = 200;
  generationSize = 100;
  
  cats = new Cat[generationSize];
  
  //Next button
  //display();
  
  generateInitialSample();
 
  //Next button
  display(false);
  
  calculateFit();
  
  //Next button
  display(false);
  
  
  cull();

  //Next button
  display(false);
  
  for (int i = 0; i < generationSize; i++){
    
    String killString = "";
    
    if(cats[i].killed){
      killString = "Kitty be gone";
    }
   
      println(cats[i].getVariation() + " " + killString);
      
  }
  
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
 
  Cat[] shuffled = shuffle(cats);
  int killCount = 0;
  int i = 0;
  
  //Calculate the maximum possible variation that any cat has
  int maxVariation = 0;
  for (Cat c : shuffled) {
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
    if(!shuffled[i].killed){
      
      //Monte Carlo random - Lower score valued cats have a higher chance of being killed
      float score = map(cats[i].getVariation(), 0, maxVariation, 0.0, 1.0);
      float qualifyingRandom = random(1);
      if(qualifyingRandom > score){
        shuffled[i].kill();
        killCount++;
      }
    }
  
    i++;
  }

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


void display(boolean toggleKilled){
 
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
     
      if(toggleKilled && !toggleView && cats[i].getKilled()){
          fill(230,20,20);
      } else {
        fill(cats[i].getColour());      
      }

      rect(x * width * separation + initialOffset, y * height * separation + initialOffset, width, height);
    
    }
    
      
  }
  
  toggleView = !toggleView;
  
}

void draw(){
  
  fill(80,180,80);
  rect(buttonX, buttonY, buttonWidth, buttonHeight);
  
  if (overRect(buttonX, buttonY, buttonWidth, buttonHeight) ) {
    rectOver = true;
  } else {
    rectOver = false; 
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
  if (rectOver) {
    display(true);
  }
}