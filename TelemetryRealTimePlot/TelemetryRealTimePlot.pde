// import libraries
import java.awt.Frame;
import java.awt.BorderLayout;
import controlP5.*;
import processing.serial.*;
import java.util.Arrays;
import processing.sound.*;

// serial port to connect to
String serialPortName = Serial.list()[0];
Serial serialPort;
int baudRate = 115200;

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

// Images
PImage icon, img, parachute;

// Sounds
SoundFile parachuteSound;

void setup() {
  printArray(Serial.list());
  
  // Load Images
  icon = loadImage(topSketchPath + "images/application.png");
  img = loadImage(topSketchPath + "images/logo.png");
  parachute = loadImage(topSketchPath + "images/off.png");
  
  // Load sounds
  parachuteSound = new SoundFile(this, "ding.mp3");
  
  surface.setTitle("Telemetry Interface");
  surface.setIcon(icon);
  size(1280, 680);

  // must conform to the number defined by 'graphsNumber'
  LineGraph[0] = new Graph(initialPositionX, initialPositionY, widthGraph, heightGraph, color (20, 20, 200));
  LineGraph[1] = new Graph(initialPositionX + widthGraph + paddingX, initialPositionY, widthGraph, heightGraph, color (20, 20, 200));
  LineGraph[2] = new Graph(initialPositionX, initialPositionY + heightGraph + paddingY, widthGraph, heightGraph, color (20, 20, 200));
  LineGraph[3] = new Graph(initialPositionX + widthGraph + paddingX, initialPositionY + heightGraph + paddingY, widthGraph, heightGraph, color (20, 20, 200));
  
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
  
  serialPort = new Serial(this, serialPortName, baudRate);
  
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
     
  setChartSettings();

}

void draw(){
  
  
  /* Read serial and update values */
  if(serialPort.available() > 0){
    String myString = "";
    try {
      Arrays.fill(inBuffer, (byte)0x00); // Rever a forma de zerar o buffer
      serialPort.readBytesUntil('\n', inBuffer);
    } catch (Exception e) {
      println(e);
    }
    myString = new String(inBuffer);
    println(myString);
    
    // split the string at delimiter ','
    String[] nums = split(myString, ',');
    
    if(nums.length < 5){
      plotterConfigJSON.setString("myString", myString);
      saveJSONObject(plotterConfigJSON, topSketchPath + "/plotter_config.json");
    }
    
    // build the arrays for line graphs
    for(i = 0; i < nums.length; i++) {
      // update line graph
      if(i < 4) {
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
          println(e);
        }
       } else {
         if(int(nums[4]) >= 1) {    
           //parachuteSound.play();
           parachute = loadImage("images/on.png");
         } else {
           parachute = loadImage("images/off.png");
           //parachuteSound.stop();
         }
       }
    }    
  }
  
  // draw the line graphs
  // must conform to the number defined by 'graphsNumber'
  LineGraph[0].DrawAxis();
  LineGraph[1].DrawAxis();
  LineGraph[2].DrawAxis();
  LineGraph[3].DrawAxis();
  
  // Draw parachute image
  image(parachute, 629, 10, 22, 23);
  
  // Draw graphics background image
  tint(70);
  image(img, initialPositionX + widthGraph / 2 - 44, initialPositionY + heightGraph / 2 - 50, 88, 100);
  image(img, initialPositionX + widthGraph / 2 + widthGraph + 60 * 2.5 - 44, initialPositionY + heightGraph / 2 - 50, 88, 100);
  image(img, initialPositionX + widthGraph / 2 - 44, heightGraph / 2 + heightGraph + 60 * 2.5, 88, 100);
  image(img, initialPositionX + widthGraph / 2 + widthGraph + 60 * 2.5 - 44, heightGraph / 2 + heightGraph + 60 * 2.5, 88, 100);
  tint(255);
  
  for(int i = 0; i < lineGraphValues.length; i++) {
    LineGraph[i].GraphColor = graphColors[i];
    
    if(int(getPlotterConfigString("lgVisible" + (i + 1))) == 1) {
      LineGraph[i].LineGraph(lineGraphSampleNumbers, lineGraphValues[i]);
      
      // sets the current value for the X axis according to time
      LineGraph[i].xMax = millis() / 1000 + timePerGraphLength;
      LineGraph[i].xMin = LineGraph[i].xMax - timePerGraphLength;
    }
  }
}

// called each time the chart settings are changed by the user 
void setChartSettings() {
  int currentTime = millis() / 1000;
  
  LineGraph[0].xLabel = "Time (s)";
  LineGraph[0].yLabel = "Value (m)";
  LineGraph[0].Title = "Altitude";  
  LineGraph[0].xDiv = 5;  
  LineGraph[0].xMax = currentTime + timePerGraphLength;
  LineGraph[0].xMin = currentTime; 
  LineGraph[0].yMax = int(getPlotterConfigString("lgMaxY1")); 
  LineGraph[0].yMin = int(getPlotterConfigString("lgMinY1"));
  
  LineGraph[1].xLabel = "Time (s)";
  LineGraph[1].yLabel = "Value (m)";
  LineGraph[1].Title = "AltitudeFk";  
  LineGraph[1].xDiv = 5;  
  LineGraph[1].xMax = currentTime + timePerGraphLength;
  LineGraph[1].xMin = currentTime; 
  LineGraph[1].yMax = int(getPlotterConfigString("lgMaxY2")); 
  LineGraph[1].yMin = int(getPlotterConfigString("lgMinY2"));
  
  LineGraph[2].xLabel = "Time (s)";
  LineGraph[2].yLabel = "Value (m/s)";
  LineGraph[2].Title = "Velocidade";  
  LineGraph[2].xDiv = 5;  
  LineGraph[2].xMax = currentTime + timePerGraphLength;
  LineGraph[2].xMin = currentTime;  
  LineGraph[2].yMax = int(getPlotterConfigString("lgMaxY3")); 
  LineGraph[2].yMin = int(getPlotterConfigString("lgMinY3"));
  
  LineGraph[3].xLabel = "Time (s)";
  LineGraph[3].yLabel = "Value (m/s)";
  LineGraph[3].Title = "VelocidadeFk";  
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
