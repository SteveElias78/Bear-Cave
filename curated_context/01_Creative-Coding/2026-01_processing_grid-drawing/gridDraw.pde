

void drawGrid()
{
  
  for(float i = 0; i < width; i += gridSize) 
  {
    line(i, 0, i, height);
  }
  
  for(float i = 0; i < height; i += gridSize) 
  {
    line(0, i, width, i);
  }
  
}

void drawHWGrid( float gridheight, float gridwidth)
{
  for(float i = 0; i < gridwidth; i += gridSize) 
  {
    line(i, 0, i, gridheight);
  }
  
  for(float i = 0; i < gridheight; i += gridSize) 
  {
    line(0, i, gridwidth, i);
  }
}

void drawVariableGrid( float gridheight, float gridwidth, float xPosition, float yPosition, float gridSize)
{
  for(float i = 0; i <= gridwidth; i += gridSize) 
  {
    line(i+xPosition, yPosition, i + xPosition, yPosition + gridheight);
  }
  
  for(float i = 0; i <= gridheight; i += gridSize) 
  {
    line(xPosition, i + yPosition, xPosition + gridwidth, i + yPosition);
  }
}

void verticalLines()
{
  
  for(float i = 0; i < width; i += gridSize) 
  {
    line(i, 0, i, height);
  }
  
}
