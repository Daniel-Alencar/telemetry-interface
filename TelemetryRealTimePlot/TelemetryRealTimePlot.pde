// import libraries
import java.awt.Frame;
import java.awt.BorderLayout;
import controlP5.*;
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
int paddingY = 150;
int initialPositionX = 170;
int initialPositionY = 70;
Graph[] LineGraph = new Graph[4];

float[][] lineGraphValues = new float[6][100];
float[] lineGraphSampleNumbers = new float[100];
color[] graphColors = new color[6];

// helper for saving the executing path
String topSketchPath = "";

byte[] inBuffer = new byte[100]; // holds serial message
int i = 0;

float timePerGraphLength = 4.80;

void setup() {
  LineGraph[0] = new Graph(initialPositionX, initialPositionY, widthGraph, heightGraph, color (20, 20, 200));
  LineGraph[1] = new Graph(initialPositionX + widthGraph + paddingX, initialPositionY, widthGraph, heightGraph, color (20, 20, 200));
  LineGraph[2] = new Graph(initialPositionX, initialPositionY + heightGraph + paddingY, widthGraph, heightGraph, color (20, 20, 200));
  LineGraph[3] = new Graph(initialPositionX + widthGraph + paddingX, initialPositionY + heightGraph + paddingY, widthGraph, heightGraph, color (20, 20, 200));
  
  surface.setTitle("Telemetry Interface");
  size(1100, 625);

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
  println(lineGraphValues.length);
  println(lineGraphValues[0].length);
  // k => 0 - 99
  // i => 0 - 5
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
  y = y + spacing;
  
  cp5.addTextfield("lgMinY1").setPosition(x, y +=spacing).setText(getPlotterConfigString("lgMinY1")).setColorCaptionLabel(0).setWidth(40).setAutoClear(false);
  cp5.addTextfield("lgMaxY1").setPosition(x, y +=spacing).setText(getPlotterConfigString("lgMaxY1")).setColorCaptionLabel(0).setWidth(40).setAutoClear(false);
  cp5.addTextfield("lgMinY2").setPosition(x, y +=spacing).setText(getPlotterConfigString("lgMinY2")).setColorCaptionLabel(0).setWidth(40).setAutoClear(false);
  cp5.addTextfield("lgMaxY2").setPosition(x, y +=spacing).setText(getPlotterConfigString("lgMaxY2")).setColorCaptionLabel(0).setWidth(40).setAutoClear(false);
  cp5.addTextfield("lgMinY3").setPosition(x, y +=spacing).setText(getPlotterConfigString("lgMinY3")).setColorCaptionLabel(0).setWidth(40).setAutoClear(false);
  cp5.addTextfield("lgMaxY3").setPosition(x, y +=spacing).setText(getPlotterConfigString("lgMaxY3")).setColorCaptionLabel(0).setWidth(40).setAutoClear(false);
  cp5.addTextfield("lgMinY4").setPosition(x, y +=spacing).setText(getPlotterConfigString("lgMinY4")).setColorCaptionLabel(0).setWidth(40).setAutoClear(false);
  cp5.addTextfield("lgMaxY4").setPosition(x, y +=spacing).setText(getPlotterConfigString("lgMaxY4")).setColorCaptionLabel(0).setWidth(40).setAutoClear(false);
}

// loop variable
void draw(){
  /* Read serial and update values */
  if(serialPort.available() > 0){
    String myString = "";
    try {
      serialPort.readBytesUntil('\r', inBuffer);
    } catch (Exception e) {
      println(e);
    }
    myString = new String(inBuffer);
    
    // split the string at delimiter ','
    String[] nums = split(myString, ',');
    
    // build the arrays for line graphs
    // nums.length == 4
    for(i = 0; i < nums.length; i++) {
      // update line graph
      try {
        // lineGraphValues.length == 6
        if (i < lineGraphValues.length) {
          // lineGraphValues[i].length == 99
          // Serve para fazer os gráficos "andarem"
          for(int k = 0; k < lineGraphValues[i].length - 1; k++) {
            lineGraphValues[i][k] = lineGraphValues[i][k + 1];
          }
          // Atualiza o último valor do gráfico com o valor da serial
          lineGraphValues[i][lineGraphValues[i].length - 1] = float(nums[i]);
        }
      } catch (Exception e) {
        println(e);
      }
    }
  }

  // draw the line graphs
  LineGraph[0].DrawAxis();
  LineGraph[1].DrawAxis();
  LineGraph[2].DrawAxis();
  LineGraph[3].DrawAxis();
  
  // lineGraphValues.length == 6
  // Devemos mudar esta parte para usar vários gráficos
  for(int i = 0; i < lineGraphValues.length; i++) {
    if(i < 4) {
      LineGraph[i].GraphColor = graphColors[i];
      
      if(int(getPlotterConfigString("lgVisible" + (i + 1))) == 1) {
        LineGraph[i].LineGraph(lineGraphSampleNumbers, lineGraphValues[i]);
        LineGraph[i].xMax = millis() / 1000;
        LineGraph[i].xMin = LineGraph[i].xMax - timePerGraphLength;
      }
    }
  }
}

// called each time the chart settings are changed by the user 
void setChartSettings() {
  int currentTime = millis() / 1000;
  LineGraph[0].xLabel = "Time(s)";
  LineGraph[0].yLabel = "Value(m)";
  LineGraph[0].Title = "Altitude";  
  LineGraph[0].xDiv = 5;  
  LineGraph[3].xMax = currentTime;
  LineGraph[3].xMin = LineGraph[3].xMax - timePerGraphLength; 
  LineGraph[0].yMax = int(getPlotterConfigString("lgMaxY1")); 
  LineGraph[0].yMin = int(getPlotterConfigString("lgMinY1"));
  
  LineGraph[1].xLabel = "Time(s)";
  LineGraph[1].yLabel = "Value(K)";
  LineGraph[1].Title = "Temperature";  
  LineGraph[1].xDiv = 5;  
  LineGraph[3].xMax = currentTime;
  LineGraph[3].xMin = LineGraph[3].xMax - timePerGraphLength; 
  LineGraph[1].yMax = int(getPlotterConfigString("lgMaxY2")); 
  LineGraph[1].yMin = int(getPlotterConfigString("lgMinY2"));
  
  LineGraph[2].xLabel = "Time(s)";
  LineGraph[2].yLabel = "Value(atm)";
  LineGraph[2].Title = "Pressure";  
  LineGraph[2].xDiv = 5;  
  LineGraph[3].xMax = currentTime;
  LineGraph[3].xMin = LineGraph[3].xMax - timePerGraphLength;  
  LineGraph[2].yMax = int(getPlotterConfigString("lgMaxY3")); 
  LineGraph[2].yMin = int(getPlotterConfigString("lgMinY3"));
  
  LineGraph[3].xLabel = "Time(s)";
  LineGraph[3].yLabel = "Value(m/s²)";
  LineGraph[3].Title = "Acceleration";  
  LineGraph[3].xDiv = 5;
  LineGraph[3].xMax = currentTime;
  LineGraph[3].xMin = LineGraph[3].xMax - timePerGraphLength;  
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
