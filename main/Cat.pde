class Cat {
  
  int colour;
  int variation;
  boolean killed;
  
  Cat(int colour){
    this.colour = colour;    
  }
  
  int getColour(){
    return this.colour;
  }
  
  void calcVariation(int backgroundColour){
    this.variation = Math.abs(backgroundColour - this.colour);
  }
  
  int getVariation(){
    return this.variation;
  }
  
  void kill(){
    this.killed = true; 
  }
  
  boolean getKilled(){
   return killed; 
  }

}