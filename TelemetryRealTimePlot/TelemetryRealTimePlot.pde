// import libraries
import java.awt.Frame;
import java.awt.BorderLayout;
import controlP5.*; // http://www.sojamo.de/libraries/controlP5/
import processing.serial.*;

// Serial port to connect to
String serialPortName = Serial.list()[0];

Serial serialPort; // Serial port object

// interface stuff
ControlP5 cp5;

// Settings for the plotter are saved in this file
JSONObject plotterConfigJSON;

// plots
int heightGraph = 125, widthGraph = 300;
int paddingX = 200;
int initialPositionX = 170;
int initialPositionY = 70;
Graph LineGraph = new Graph(initialPositionX, initialPositionY, widthGraph, heightGraph, color (20, 20, 200));
Graph LineGraph1 = new Graph(initialPositionX + widthGraph + paddingX, initialPositionY, widthGraph, heightGraph, color (20, 20, 200));
Graph LineGraph2 = new Graph(initialPositionX, initialPositionY + heightGraph + paddingX, widthGraph, heightGraph, color (20, 20, 200));
Graph LineGraph3 = new Graph(initialPositionX + widthGraph + paddingX, initialPositionY + heightGraph + paddingX, widthGraph, heightGraph, color (20, 20, 200));

float[][] lineGraphValues = new float[6][100];
float[] lineGraphSampleNumbers = new float[100];
color[] graphColors = new color[6];

// helper for saving the executing path
String topSketchPath = "";

byte[] inBuffer = new byte[100]; // holds serial message
int i = 0;

void setup() {
  surface.setTitle("Telemetry Interface");
  size(1100, 600);

  // set line graph colors
  graphColors[0] = color(131, 255, 20);
  graphColors[1] = color(232, 158, 12);
  graphColors[2] = color(255, 0, 0);
  graphColors[3] = color(62, 12, 232);
  graphColors[4] = color(13, 255, 243);
  graphColors[5] = color(200, 46, 232);

  // settings save file
  topSketchPath = sketchPath();
  plotterConfigJSON = loadJSONObject(topSketchPath+"/plotter_config.json");

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
  
  //String serialPortName = Serial.list()[3];
  serialPort = new Serial(this, serialPortName, 115200);
  
  // build the gui
  int x = 15, y = 10, spacing = 40;

  cp5.addTextlabel("label").setText("on/off").setPosition(x, y).setColor(0);
  cp5.addToggle("lgVisible1").setPosition(x -= 5, y += 15).setValue(int(getPlotterConfigString("lgVisible1"))).setMode(ControlP5.SWITCH).setColorActive(graphColors[0]);
  cp5.addToggle("lgVisible2").setPosition(x, y += spacing).setValue(int(getPlotterConfigString("lgVisible2"))).setMode(ControlP5.SWITCH).setColorActive(graphColors[1]);
  cp5.addToggle("lgVisible3").setPosition(x, y += spacing).setValue(int(getPlotterConfigString("lgVisible3"))).setMode(ControlP5.SWITCH).setColorActive(graphColors[2]);
  cp5.addToggle("lgVisible4").setPosition(x, y += spacing).setValue(int(getPlotterConfigString("lgVisible4"))).setMode(ControlP5.SWITCH).setColorActive(graphColors[3]);
  cp5.addToggle("lgVisible5").setPosition(x, y += spacing).setValue(int(getPlotterConfigString("lgVisible5"))).setMode(ControlP5.SWITCH).setColorActive(graphColors[4]);
  cp5.addToggle("lgVisible6").setPosition(x, y += spacing).setValue(int(getPlotterConfigString("lgVisible6"))).setMode(ControlP5.SWITCH).setColorActive(graphColors[5]);
  
  cp5.addTextfield("lgMinY").setPosition(x, y +=spacing).setText(getPlotterConfigString("lgMinY")).setColorCaptionLabel(0).setWidth(40).setAutoClear(false);
  cp5.addTextfield("lgMaxY").setPosition(x, y +=spacing).setText(getPlotterConfigString("lgMaxY")).setColorCaptionLabel(0).setWidth(40).setAutoClear(false);
}

// loop variable
void draw(){
  /* Read serial and update values */
  if(serialPort.available() > 0){
    String myString = "";
    try {
      serialPort.readBytesUntil('\r', inBuffer);
    } catch (Exception e) {
    }
    myString = new String(inBuffer);
    
    // split the string at delimiter (space)
    String[] nums = split(myString, ',');
    
    // build the arrays for line graphs
    for(i = 0; i < nums.length; i++) {
      // update line graph
      try {
        if (i < lineGraphValues.length) {
          for(int k = 0; k < lineGraphValues[i].length - 1; k++) {
            lineGraphValues[i][k] = lineGraphValues[i][k + 1];
          }

          lineGraphValues[i][lineGraphValues[i].length - 1] = float(nums[i]);
        }
      } catch (Exception e) {
      }
    }
  }

  // draw the line graphs
  LineGraph.DrawAxis();
  LineGraph1.DrawAxis();
  LineGraph2.DrawAxis();
  for(int i = 0; i < lineGraphValues.length; i++) {
    LineGraph.GraphColor = graphColors[i];
    if(int(getPlotterConfigString("lgVisible" + (i + 1))) == 1)
      LineGraph.LineGraph(lineGraphSampleNumbers, lineGraphValues[i]);
  }
}

// called each time the chart settings are changed by the user 
void setChartSettings() {
  LineGraph.xLabel = "Samples";
  LineGraph.yLabel = "Value";
  LineGraph.Title = "Samples x Value";  
  LineGraph.xDiv = 5;  
  LineGraph.xMax = 0; 
  LineGraph.xMin = -100;  
  LineGraph.yMax = int(getPlotterConfigString("lgMaxY")); 
  LineGraph.yMin = int(getPlotterConfigString("lgMinY"));
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
    saveJSONObject(plotterConfigJSON, topSketchPath+"/plotter_config.json");
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
