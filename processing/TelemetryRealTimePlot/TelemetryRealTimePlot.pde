// import libraries
import java.awt.Frame;
import java.awt.BorderLayout;
import controlP5.*;
import processing.serial.*;
import java.util.Arrays;

// serial port to connect to
String serialPortName = Serial.list()[0];
Serial serialPort;

// interface stuff
ControlP5 cp5;

// Settings for the plotter are saved in this file
JSONObject plotterConfigJSON;

int graphsNumber = 4;

// plots
int heightGraph = 191, widthGraph = 491;
int paddingX = 150;
int paddingY = 150;
int initialPositionX = 95;
int initialPositionY = 59;
Graph[] LineGraph = new Graph[graphsNumber];

float[][] lineGraphValues = new float[graphsNumber][100];
float[] lineGraphSampleNumbers = new float[100];
color[] graphColors = new color[graphsNumber];

// helper for saving the executing path
String topSketchPath = "";

// global variables
byte[] inBuffer = new byte[100];
int i = 0;

float timePerGraphLength = 4.8;
Textlabel[] tl = new Textlabel[4];

PImage img;

void setup() {
  img = loadImage(topSketchPath + "/images/Logos-09.png");
  // must conform to the number defined by 'graphsNumber'
  LineGraph[0] = new Graph(initialPositionX, initialPositionY, widthGraph, heightGraph, color (20, 20, 200));
  LineGraph[1] = new Graph(initialPositionX + widthGraph + paddingX, initialPositionY, widthGraph, heightGraph, color (20, 20, 200));
  LineGraph[2] = new Graph(initialPositionX, initialPositionY + heightGraph + paddingY, widthGraph, heightGraph, color (20, 20, 200));
  LineGraph[3] = new Graph(initialPositionX + widthGraph + paddingX, initialPositionY + heightGraph + paddingY, widthGraph, heightGraph, color (20, 20, 200));
  
  surface.setTitle("Telemetry Interface");
  size(1280, 680);
  
  // set line graph colors
  // must conform to the number defined by 'graphsNumber'
  graphColors[0] = color(131, 255, 20);
  graphColors[1] = color(232, 158, 12);
  graphColors[2] = color(255, 0, 0);
  graphColors[3] = color(62, 12, 232);

  // settings save file
  topSketchPath = sketchPath();
  plotterConfigJSON = loadJSONObject(topSketchPath + "/plotter_config.json");

  // gui
  cp5 = new ControlP5(this);
  
  // build x axis values for the line graph
  for(int i = 0; i < lineGraphValues.length; i++){ 
    for(int k = 0; k < lineGraphValues[0].length; k++){
      lineGraphValues[i][k] = 0;
      if(i == 0){
        lineGraphSampleNumbers[k] = k;
      }
    }
  }
  
  serialPort = new Serial(this, serialPortName, 115200);
  
  // build the gui
  int x = 1055, y = 348, spacing = 50;
  
  // must conform to the number defined by 'graphsNumber'
  cp5.addToggle("X")
     .setPosition(x, y)
     .setValue(int(getPlotterConfigString("lgVisible1")))
     .setMode(ControlP5.SWITCH)
     .setColorActive(graphColors[0]);
  cp5.addToggle("Y")
     .setPosition(x += spacing, y)
     .setValue(int(getPlotterConfigString("lgVisible2")))
     .setMode(ControlP5.SWITCH)
     .setColorActive(graphColors[1]);
  cp5.addToggle("Z")
     .setPosition(x += spacing, y)
     .setValue(int(getPlotterConfigString("lgVisible3")))
     .setMode(ControlP5.SWITCH)
     .setColorActive(graphColors[2]);
  cp5.addToggle("Kalman Filter")
     .setPosition(x += spacing, y)
     .setValue(int(getPlotterConfigString("lgVisible4")))
     .setMode(ControlP5.SWITCH)
     .setColorActive(graphColors[3]);
  
  tl[0] = cp5.addTextlabel("Value1")
             .setText(getPlotterConfigString("Value1"))
             .setPosition(initialPositionX + widthGraph + 20, initialPositionY + heightGraph + 70)
             .setColor(255);
  tl[1] = cp5.addTextlabel("Value2")
             .setText(getPlotterConfigString("Value2"))
             .setPosition(initialPositionX + widthGraph * 2 + 160, initialPositionY + heightGraph + 70)
             .setColor(255);
  tl[2] = cp5.addTextlabel("Value3")
             .setText(getPlotterConfigString("Value3"))
             .setPosition(initialPositionX + widthGraph + 20, initialPositionY + heightGraph * 2 + 220)
             .setColor(255);
  tl[3] = cp5.addTextlabel("Value4")
             .setText(getPlotterConfigString("Value4"))
             .setPosition(initialPositionX + widthGraph * 2 + 160, initialPositionY + heightGraph * 2 + 220)
             .setColor(255);
}

void draw(){
  /* Read serial and update values */
  if(serialPort.available() > 0){
    String myString = "";
    try {
      Arrays.fill(inBuffer, (byte)0x00);
      serialPort.readBytesUntil('\n', inBuffer);
    } catch (Exception e) {
    }
    myString = new String(inBuffer);
    
    // split the string at delimiter ','
    String[] nums = split(myString, ',');
    
    // build the arrays for line graphs
    for(i = 0; i < nums.length; i++) {
      // update line graph
      try {
        if (i < lineGraphValues.length) {
          // serves to make the graphics "walk"
          for(int k = 0; k < lineGraphValues[i].length - 1; k++) {
            lineGraphValues[i][k] = lineGraphValues[i][k + 1];
          }
          // updates the last value of the graph with the value of the serial
          lineGraphValues[i][lineGraphValues[i].length - 1] = float(nums[i]);
          tl[i].setText(nums[i]);
        }
      } catch(Exception e) {
      }
    }
  }

  // draw the line graphs
  // must conform to the number defined by 'graphsNumber'
  LineGraph[0].DrawAxis();
  LineGraph[1].DrawAxis();
  LineGraph[2].DrawAxis();
  LineGraph[3].DrawAxis();
  
  for(int i = 0; i < lineGraphValues.length; i++) {
    LineGraph[i].GraphColor = graphColors[i];
    
    if(int(getPlotterConfigString("lgVisible" + (i + 1))) == 1) {
      LineGraph[i].LineGraph(lineGraphSampleNumbers, lineGraphValues[i]);
      
      // sets the current value for the X axis according to time
      LineGraph[i].xMax = millis() / 1000 + timePerGraphLength;
      LineGraph[i].xMin = LineGraph[i].xMax - timePerGraphLength;
    }
  }
  tint(225);
  image(img, 597, 290, 88, 100);
}

// called each time the chart settings are changed by the user 
void setChartSettings() {
  int currentTime = millis() / 1000;
  
  LineGraph[0].xLabel = "Time (s)";
  LineGraph[0].yLabel = "Value (m)";
  LineGraph[0].Title = "Altitude";  
  LineGraph[0].xDiv = 10;  
  LineGraph[0].xMax = currentTime + timePerGraphLength;
  LineGraph[0].xMin = currentTime; 
  LineGraph[0].yMax = int(getPlotterConfigString("lgMaxY1")); 
  LineGraph[0].yMin = int(getPlotterConfigString("lgMinY1"));
  
  LineGraph[1].xLabel = "Time (s)";
  LineGraph[1].yLabel = "Value (K)";
  LineGraph[1].Title = "Temperature";  
  LineGraph[1].xDiv = 5;  
  LineGraph[1].xMax = currentTime + timePerGraphLength;
  LineGraph[1].xMin = currentTime; 
  LineGraph[1].yMax = int(getPlotterConfigString("lgMaxY2")); 
  LineGraph[1].yMin = int(getPlotterConfigString("lgMinY2"));
  
  LineGraph[2].xLabel = "Time (s)";
  LineGraph[2].yLabel = "Value (atm)";
  LineGraph[2].Title = "Pressure";  
  LineGraph[2].xDiv = 5;  
  LineGraph[2].xMax = currentTime + timePerGraphLength;
  LineGraph[2].xMin = currentTime;  
  LineGraph[2].yMax = int(getPlotterConfigString("lgMaxY3")); 
  LineGraph[2].yMin = int(getPlotterConfigString("lgMinY3"));
  
  LineGraph[3].xLabel = "Time (s)";
  LineGraph[3].yLabel = "Value (m/s²)";
  LineGraph[3].Title = "Acceleration";  
  LineGraph[3].xDiv = 5;
  LineGraph[3].xMax = currentTime + timePerGraphLength;
  LineGraph[3].xMin = currentTime;  
  LineGraph[3].yMax = int(getPlotterConfigString("lgMaxY4")); 
  LineGraph[3].yMin = int(getPlotterConfigString("lgMinY4"));
}

// handle gui actions
void controlEvent(ControlEvent theEvent) {
  if (theEvent.isAssignableFrom(Textfield.class) || theEvent.isAssignableFrom(Toggle.class) || theEvent.isAssignableFrom(Button.class)) {
    String parameter = theEvent.getName();
    String value = "";
    if(theEvent.isAssignableFrom(Textfield.class)){
      value = theEvent.getStringValue();
    } else if(theEvent.isAssignableFrom(Toggle.class) || theEvent.isAssignableFrom(Button.class)) {
      value = theEvent.getValue() + "";
    }
    plotterConfigJSON.setString(parameter, value);
    saveJSONObject(plotterConfigJSON, topSketchPath + "/plotter_config.json");
  }
  setChartSettings();
}

// get gui settings from settings file
String getPlotterConfigString(String id) {
  String r = "";
  try{
    r = plotterConfigJSON.getString(id);
  } catch (Exception e) {
    r = "";
  }
  return r;
}
