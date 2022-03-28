// import libraries
import java.awt.Frame;
import java.awt.BorderLayout;
import controlP5.*;
import processing.serial.*;
import java.util.Arrays;
import processing.sound.*;

// ===================== Serial port to connect to ===================== //
String serialPortName = Serial.list()[0];
Serial serialPort;
int baudRate = 115200;

// ========================== Interface stuff ========================== //
ControlP5 cp5;

// ========== Settings for the plotter are saved in this file ========== //
JSONObject plotterConfigJSON;

// =============================== Plots =============================== //
int graphsNumber = 4;
int heightGraph = 191, widthGraph = 491;
int paddingX = 150, paddingY = 150;
int initialPositionX = 95, initialPositionY = 59;

Graph[] LineGraph = new Graph[graphsNumber];

float[][] lineGraphValues = new float[graphsNumber][100];
float[] lineGraphSampleNumbers = new float[100];
color[] graphColors = new color[graphsNumber];

Textlabel[] tl = new Textlabel[4];

// =============== Helper for saving the executing path ================ //
String topSketchPath = "";

// ========================= Global variables ========================== //

// ============= Buffer ============= //
byte[] inBuffer = new byte[100];

// ============= Counter ============ //
int i = 0;

// ========= Amount of data ========= //
int dataAmount = 5;

// ====== Arduino delay in ms ======= //
int delay = 50;

// = Indicates parachute activation = //
boolean parachuteDeactivated = true;

// ==== Indicates empty garbage ===== //
boolean clear = false;

// ==== Synchronize the graphics ==== //
float timePerGraphLength = 2.74074074074071 * 0.000001 * delay * delay + 0.0973148148148148 * delay - 0.0725925925925939;
boolean hadNotSetInterfaceDelay = true;
int interfaceDelay = 0;

// ================================ Images ================================ //
PImage icon, img, parachute;

// ================================ Sounds ================================ //
SoundFile parachuteSound;

void setup() {
  // Print serial port array
  printArray(Serial.list());
  
  // Load Images
  icon = loadImage(topSketchPath + "images/application.png");
  img = loadImage(topSketchPath + "images/logo.png");
  parachute = loadImage(topSketchPath + "images/off.png");
  
  // load sounds
  parachuteSound = new SoundFile(this, "censorbeep8.wav", false);
  
  // set window settings
  surface.setTitle("Telemetry Interface");
  surface.setIcon(icon);
  size(1280, 680);

  // set graph settings
  LineGraph[0] = new Graph(initialPositionX, initialPositionY, widthGraph, heightGraph, color (20, 20, 200));
  LineGraph[1] = new Graph(initialPositionX + widthGraph + paddingX, initialPositionY, widthGraph, heightGraph, color (20, 20, 200));
  LineGraph[2] = new Graph(initialPositionX, initialPositionY + heightGraph + paddingY, widthGraph, heightGraph, color (20, 20, 200));
  LineGraph[3] = new Graph(initialPositionX + widthGraph + paddingX, initialPositionY + heightGraph + paddingY, widthGraph, heightGraph, color (20, 20, 200));
  
  // set line graph colors
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
  // read serial and update values
  if(serialPort.available() > 0){
    try {
      Arrays.fill(inBuffer, (byte)0x30);
      serialPort.readBytesUntil('\n', inBuffer);
    } catch (Exception e) {
      println(e);
    }
    
    String myString = new String(inBuffer);
    String[] verify = split(myString, '\n');
    
    if(verify[0].equals("INICIADO!\r")){
      clear = true;
    }
    
    if(clear){
      // split the string at delimiter ','
      String[] nums = split(myString, ',');
      
      // build the arrays for line graphs
      if(nums.length == dataAmount){
        plotterConfigJSON.setString("myString", myString);
        saveJSONObject(plotterConfigJSON, topSketchPath + "/plotter_config.json");
        
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
            println(e);
          }
        }
        
        // indicates parachute activation
        String[] parachuteBit = split(nums[dataAmount - 1], '\n');
        if(parachuteDeactivated){
          if(int(parachuteBit[0]) == 1) {
            parachuteSound.play();
            parachute = loadImage("images/on.png");
            parachuteDeactivated = false;
          }
        }  
      }
    }
  }
  
  // draw the line graphs
  LineGraph[0].DrawAxis();
  LineGraph[1].DrawAxis();
  LineGraph[2].DrawAxis();
  LineGraph[3].DrawAxis();

  // draw parachute image
  image(parachute, 629, 10, 22, 23);
  
  // draw graphics background image
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
      if(clear){
        
        if(hadNotSetInterfaceDelay) {
          interfaceDelay = millis();
          hadNotSetInterfaceDelay = false;
        }
        int currentTime = (millis() - interfaceDelay) / 1000;
        
        LineGraph[i].xMax = currentTime;
        LineGraph[i].xMin = currentTime - timePerGraphLength;
      }
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
  LineGraph[0].xMax = currentTime;
  LineGraph[0].xMin = currentTime - timePerGraphLength;
  LineGraph[0].yMax = int(getPlotterConfigString("lgMaxY1")); 
  LineGraph[0].yMin = int(getPlotterConfigString("lgMinY1"));
  
  LineGraph[1].xLabel = "Time (s)";
  LineGraph[1].yLabel = "Value (m)";
  LineGraph[1].Title = "AltitudeFk";  
  LineGraph[1].xDiv = 5;  
  LineGraph[1].xMax = currentTime;
  LineGraph[1].xMin = currentTime - timePerGraphLength; 
  LineGraph[1].yMax = int(getPlotterConfigString("lgMaxY2")); 
  LineGraph[1].yMin = int(getPlotterConfigString("lgMinY2"));
  
  LineGraph[2].xLabel = "Time (s)";
  LineGraph[2].yLabel = "Value (m/s)";
  LineGraph[2].Title = "Velocidade";  
  LineGraph[2].xDiv = 5;  
  LineGraph[2].xMax = currentTime;
  LineGraph[2].xMin = currentTime - timePerGraphLength;  
  LineGraph[2].yMax = int(getPlotterConfigString("lgMaxY3")); 
  LineGraph[2].yMin = int(getPlotterConfigString("lgMinY3"));
  
  LineGraph[3].xLabel = "Time (s)";
  LineGraph[3].yLabel = "Value (m/s)";
  LineGraph[3].Title = "VelocidadeFk";  
  LineGraph[3].xDiv = 5;
  LineGraph[3].xMax = currentTime;
  LineGraph[3].xMin = currentTime - timePerGraphLength;  
  LineGraph[3].yMax = int(getPlotterConfigString("lgMaxY4")); 
  LineGraph[3].yMin = int(getPlotterConfigString("lgMinY4"));
}

// get gui settings from settings file
String getPlotterConfigString(String id) {
  String value = "";
  try{
    value = plotterConfigJSON.getString(id);
  } catch (Exception e) {
    value = "";
  }
  return value;
}
