
float gridSize = 10;


void setup()
{
  size(1000, 1300);
  background(255);
  
  strokeWeight(3);
 
  //drawGrid();
  
  //verticalLines();
  
  //drawHWGrid(300, 500);
  
}

void draw()
{
  
  background(255);
  
  drawVariableGrid(300, 500, 200, 400, gridSize);
  
  drawVariableGrid( 100, 200, 100, 800, gridSize);
}

void mouseClicked()
{
  
  gridSize  = random(5,100);
  println(gridSize);
  
}
