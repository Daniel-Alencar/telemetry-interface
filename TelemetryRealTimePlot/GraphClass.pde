class Graph{
  int     xDiv = 5, yDiv = 5;       // Number of sub divisions
  int     xPos, yPos;               // location of the top left corner of the graph  
  int     Width, Height;            // Width and height of the graph


  color   GraphColor;
  color   BackgroundColor = color(255);  
  color   StrokeColor = color(180);     
  
  String  Title = "Title";          // Default titles
  String  xLabel = "x - Label";
  String  yLabel = "y - Label";

  float   yMax = 1024, yMin = 0;      // Default axis dimensions
  float   xMax = 10, xMin = 0;
  float   yMaxRight = 1024, yMinRight = 0;
  
  Graph(int x, int y, int w, int h,color k) {  // The main declaration function
    xPos = x;
    yPos = y;
    Width = w;
    Height = h;
    GraphColor = k;
  }

  void DrawAxis(){
    /* == Main axes Lines, Graph Labels, Graph Background == */
    
    fill(BackgroundColor); color(0); stroke(StrokeColor); strokeWeight(1);
    int t = 60;
    
    rect(xPos - t * 1.6, yPos - t, Width + t * 2.5, Height + t * 2);           // outline
    textAlign(CENTER); textSize(18);                     // Heading Rectangle  
    
    fill(0);
    text(Title, xPos + Width / 2, yPos - 37);                            // Heading Title
    textAlign(CENTER); textSize(14);
    text(xLabel, xPos + Width / 2, yPos + Height + t / 1.5);                     // x-axis Label 
    
    rotate(-PI / 2);                                               // rotate -90 degrees
    text(yLabel, -yPos - Height / 2, xPos - t * 1.6 + 20);                   // y-axis Label  
    rotate(PI / 2);                                                // rotate back
    
    textSize(10); noFill(); stroke(0); smooth(); strokeWeight(1);
    
    //Edges
    line(xPos - 3, yPos + Height, xPos - 3, yPos);                        // y-axis line 
    line(xPos - 3, yPos + Height, xPos + Width + 5, yPos + Height);           // x-axis line 
    
    stroke(200);
    
    if(yMin < 0){
      line(xPos - 7, yPos + Height - (abs(yMin) / (yMax - yMin)) * Height, xPos + Width, yPos + Height - (abs(yMin) / (yMax - yMin)) * Height);
    }
      
    /* == Sub-devisions for both axes, left and right == */
    stroke(0);
    
    for(int x = 0; x <= xDiv; x++){
    /* == x-axis == */
      line(float(x) / xDiv * Width + xPos - 3, yPos + Height, float(x) / xDiv * Width + xPos - 3, yPos + Height + 5);        //  x-axis Sub devisions
           
      textSize(10);                                   // x-axis Labels
      String xAxis = str(xMin + float(x) / xDiv * (xMax - xMin));  // the only way to get a specific number of decimals 
      String[] xAxisMS = split(xAxis, '.');                 // is to split the float into strings 
      text(xAxisMS[0] + "." + xAxisMS[1].charAt(0), float(x) / xDiv * Width + xPos - 3, yPos + Height + 15);   // x-axis Labels
    }
    
    /* == left y-axis == */
    for(int y = 0; y <= yDiv; y++){
      line(xPos - 3, float(y) / yDiv * Height + yPos, xPos - 7, float(y) / yDiv * Height + yPos);              // y-axis lines 
      
      textAlign(RIGHT); fill(20);
      
      String yAxis = str(yMin + float(y) / yDiv * (yMax - yMin));     // Make y Label a string
      String[] yAxisMS = split(yAxis, '.');                    // Split string
     
      text(yAxisMS[0] + "." + yAxisMS[1].charAt(0), xPos - 15, float(yDiv - y) / yDiv * Height + yPos + 3);       // y-axis Labels 
      stroke(0);
    }
  }

  
 /* == Streight line graph == */
  void LineGraph(float[] x ,float[] y){
    for (int i = 0; i < (x.length - 1); i++){
       strokeWeight(2); stroke(GraphColor); noFill(); smooth();
       line(xPos + (x[i] - x[0]) / (x[x.length - 1] - x[0]) * Width, yPos + Height - (y[i] / (yMax - yMin) * Height) + (yMin) / (yMax - yMin) * Height,
            xPos + (x[i + 1] - x[0]) / (x[x.length - 1] - x[0]) * Width, yPos + Height - (y[i + 1] / (yMax - yMin) * Height) + (yMin) / (yMax - yMin) * Height);
     }                   
  }
}
