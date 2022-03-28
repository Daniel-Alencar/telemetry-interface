class Graph{
  // Number of sub divisions
  int xDiv = 5, yDiv = 5;
  // location of the top left corner of the graph
  int xPos, yPos;
  // Width and height of the graph
  int Width, Height;

  color GraphColor;
  color TextColor = 255;
  color BackgroundColor = color(32, 33, 36);  
  color StrokeColor = color(180);     
  
  // Default titles
  String Title = "Title";          
  String xLabel = "x - Label";
  String yLabel = "y - Label";

  // Default axis dimensions
  float yMax = 0, yMin = 0;
  float xMax = 10, xMin = 0;
  float yMaxRight = 1024, yMinRight = 0;
  
  Graph(int x, int y, int w, int h, color k) {
    xPos = x;
    yPos = y;
    Width = w;
    Height = h;
    GraphColor = k;
  }

  void DrawAxis(){
    /* == Main axes Lines, Graph Labels, Graph Background == */
    fill(BackgroundColor); color(TextColor); stroke(StrokeColor); strokeWeight(1);
    int t = 60;
    
    // outline
    rect(xPos - t * 1.6, yPos - t, Width + t * 2.5, Height + t * 2.5);           
    // Heading Rectangle
    textAlign(CENTER); textSize(18);                     
    
    fill(TextColor);
    // Heading Title
    text(Title, xPos + Width / 2, yPos - 37);                            
    textAlign(CENTER); textSize(10);
    // x-axis Label
    text(xLabel, xPos + Width, yPos + Height + t / 1.5);                     
    
    // rotate -90 degrees
    rotate(-PI / 2);                                               
    // y-axis Label 
    text(yLabel, -yPos - Height / 10, xPos - t * 1.4 + 20);                   
    // rotate back
    rotate(PI / 2);
    
    textSize(10); stroke(0); smooth(); strokeWeight(1);
    
    stroke(TextColor);
    //Edges
    // y-axis line
    line(xPos - 3, yPos + Height, xPos - 3, yPos);                         
    // x-axis line 
    line(xPos - 3, yPos + Height, xPos + Width + 5, yPos + Height);           
    
    if(yMin < 0){
      line(xPos - 7, yPos + Height - (abs(yMin) / (yMax - yMin)) * Height, xPos + Width, yPos + Height - (abs(yMin) / (yMax - yMin)) * Height);
    }
      
    /* == Sub-devisions for both axes, left and right == */
    for(int x = 0; x <= xDiv; x++){
      /* == x-axis == */
      //  x-axis Sub devisions
      line(float(x) / xDiv * Width + xPos - 3, yPos + Height, float(x) / xDiv * Width + xPos - 3, yPos + Height + 5);
      // x-axis Labels
      textSize(10);
      // the only way to get a specific number of decimals
      String xAxis = str(xMin + float(x) / xDiv * (xMax - xMin));         
      // x-axis Labels
      text(round(float(xAxis)), float(x) / xDiv * Width + xPos - 3, yPos + Height + 15);   
    }
    
    /* == left y-axis == */
    for(int y = 0; y <= yDiv; y++){
      // y-axis lines 
      line(xPos - 3, float(y) / yDiv * Height + yPos, xPos - 7, float(y) / yDiv * Height + yPos);
      
      textAlign(RIGHT); fill(TextColor);
      
      // Make y Label a string
      String yAxis = str(yMin + float(y) / yDiv * (yMax - yMin));     
      // Split string
      String[] yAxisMS = split(yAxis, '.');
      // y-axis Labels
      text(yAxisMS[0] + "." + yAxisMS[1].charAt(0), xPos - 15, float(yDiv - y) / yDiv * Height + yPos + 3);       
    }
  }

  
 /* == Streight line graph == */
  void LineGraph(float[] x, float[] y){
    for (int i = 0; i < (x.length - 1); i++){
       strokeWeight(2); stroke(GraphColor); noFill(); smooth();
       line(xPos + (x[i] - x[0]) / (x[x.length - 1] - x[0]) * Width, yPos + Height - (y[i] / (yMax - yMin) * Height) + (yMin) / (yMax - yMin) * Height,
            xPos + (x[i + 1] - x[0]) / (x[x.length - 1] - x[0]) * Width, yPos + Height - (y[i + 1] / (yMax - yMin) * Height) + (yMin) / (yMax - yMin) * Height);
     }                   
  }
}
