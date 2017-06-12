// Need G4P library
import g4p_controls.*;
import processing.serial.*;
import processing.sound.*;
import ddf.minim.*;
import ddf.minim.analysis.*;


Minim minim;
Amplitude rms;
AudioInput in;
AudioIn device;
ddf.minim.analysis.FFT fft;
Serial port;


// Custom Bools
boolean settings_open;
boolean ready;
boolean handshake;
boolean connected;
boolean NoDraw;
// Existing EZHook values
String DebugText;
int appfps = 60;
int threadfps = 60;
int fftLines = 50;
color DebugTextColor;


float[] RawFFT;

// New EZhook values
Table LightSettings;
int pointer;
int[] id;
int[] Pin;
String[] LightName;
int[] LedsAmount;
int[] Pattern;
int[] Mode;
int[] BassSliderValue;
int[] TrebSliderValue;
int[] TrebArraySize;
int[] LowPass;
float[] MulBright;
float[] MulColor;
float[] MulSat;
float[] bass;
float[] treble;
String[] LightNameVisualBuffer;
String[] ports;
String[] command;
String SettingsFileName = "userdata";



void TableFirstLoad() {
  LightName = new String[1];
  command[0] = "loadTable";
  TableHandler(command);
  command[0] = "loadArraysFromTable";
  TableHandler(command);
  if(LightName[0] == null) {
    println("Error initializing table. Better make a new one!");
    command[0] = "new";
    TableHandler(command);
    println("Verifying new table has initialized correctly...");
    command[0] = "loadArraysFromTable";
    TableHandler(command);
    print(LightName[0]);
    if(LightName[0] == null) {
      println("Damn. Table is still missing! program cannot run. Maybe the CSV is currently in use?");
      
    }
    
    
    
  }
  
  println("TableFirstLoad:END");
  
  
}


 

void TableHandler(String[] data) {
  
  if(data[0] == "loadTable") {
    
    try {
    
     println("Loading Table...");
     LightSettings = loadTable("data/userdata.csv","header");
     // Table loaded fine, now to dump the table into useable values.
     command = new String[] {"loadArraysFromTable"};
     TableHandler(command);
       
     }
  
  catch(Exception e) {}
  }
     
  if(data[0] == "loadArraysFromTable") {
    
    try {
    
    println("LoadArraysFromTable Called.");
    int TableRowCount = LightSettings.getRowCount();
    
    id = new int[TableRowCount];
    Pin = new int[TableRowCount];
    LightName = new String[TableRowCount];
    LedsAmount = new int[TableRowCount];
    Pattern = new int[TableRowCount];
    Mode = new int[TableRowCount];
    BassSliderValue = new int[TableRowCount];
    TrebSliderValue = new int[TableRowCount];
    TrebArraySize = new int[TableRowCount];
    MulBright = new float[TableRowCount];
    MulColor = new float[TableRowCount];
    MulSat = new float[TableRowCount];
    LowPass = new int[TableRowCount];

    for(int i=0;i<TableRowCount;i++) {
       TableRow row = LightSettings.getRow(i);
       id[i] = row.getInt("id");
       Pin[i] = row.getInt("Pin");
       LightName[i] = row.getString("LightName");
       LedsAmount[i] = row.getInt("LedsAmount");
       Pattern[i] = row.getInt("Pattern");
       Mode[i] = row.getInt("Mode");
       BassSliderValue[i] = row.getInt("BassSliderValue");
       TrebSliderValue[i] = row.getInt("TrebSliderValue");
       TrebArraySize[i] = row.getInt("TrebArraySize");
       MulBright[i] = row.getFloat("MulBright");
       MulColor[i] = row.getFloat("MulColor");
       MulSat[i] = row.getFloat("MulSat");
       LowPass[i] = row.getInt("LowPass");
       println(LightName[i]);
     }
     ready = true;
     
    }
    
    catch(Exception e){}
     
     
    
  }
  
  if(data[0] == "saveTable") {
    
    println("saveTable called");
    saveTable(LightSettings,"data/userdata.csv");
    
  }
  
  
  if(data[0] == "saveArraysToTable") {
    
    println("saveArraysToTable called");
    for(int i=0;i<LightSettings.getRowCount();i++) {
      TableRow row = LightSettings.getRow(i);
      
    
      row.setInt("id",id[i]);
      row.setInt("Pin",Pin[i]);
      row.setString("LightName",LightName[i]);
      row.setInt("LedsAmount",LedsAmount[i]);
      row.setInt("Pattern",Pattern[i]);
      row.setInt("Mode",Mode[i]);
      row.setInt("BassSliderValue",BassSliderValue[i]);
      row.setInt("TrebSliderValue",TrebSliderValue[i]);
      row.setInt("TrebArraySize",TrebArraySize[i]);
      row.setFloat("MulBright",MulBright[i]);
      row.setFloat("MulColor",MulColor[i]);
      row.setFloat("MulSat",MulSat[i]);
      row.setInt("LowPass",LowPass[i]);
    
    
  }
  
  
    
  }
    
    
  
  if(data[0] == "new") {
    
    println("Creating new table...");
    LightSettings = new Table();
    LightSettings.addColumn("id",Table.INT);
    LightSettings.addColumn("Pin",Table.INT);
    LightSettings.addColumn("LightName",Table.STRING);
    LightSettings.addColumn("LedsAmount",Table.INT);
    LightSettings.addColumn("Pattern",Table.INT);
    LightSettings.addColumn("Mode",Table.INT);
    LightSettings.addColumn("BassSliderValue",Table.INT);
    LightSettings.addColumn("TrebSliderValue",Table.INT);
    LightSettings.addColumn("TrebArraySize",Table.INT);
    LightSettings.addColumn("MulBright",Table.FLOAT);
    LightSettings.addColumn("MulColor",Table.FLOAT);
    LightSettings.addColumn("MulSat",Table.FLOAT);
    LightSettings.addColumn("LowPass",Table.INT);
    // Okay, that's the table made, but it still doesn't have any values. Let's add some default values!
    TableRow row = LightSettings.addRow();
    row.setInt("id",0);
    row.setInt("Pin",12);
    row.setString("LightName","My First Light");
    row.setInt("LedsAmount",170);
    row.setInt("Pattern",1);
    row.setInt("Mode",1);
    row.setInt("BassSliderValue",3);
    row.setInt("TrebSliderValue",4); 
    row.setInt("TrebArraySize",15);
    row.setFloat("MulBright",1);
    row.setFloat("MulColor",1);
    row.setFloat("MulSat",1);
    row.setInt("LowPass",0);
    // That's the default values loaded into the table, now lets save the table into that pesky file...
    println("New: Saving table...");
    saveTable(LightSettings,"data/userdata.csv");
      
    
  }
  
  
  if(data[0] == "newline") {
    
    TableRow row = LightSettings.addRow();
    row.setInt("Pin",0);
    row.setString("LightName","new");
    row.setInt("LedsAmount",0);
    row.setInt("Pattern",1);
    row.setInt("Mode",1);
    row.setInt("BassSliderValue",0);
    row.setInt("TrebSliderValue",0);
    row.setInt("TrebArraySize",0);
    row.setFloat("MulBright",1.0);
    row.setFloat("MulColor",1.0);
    row.setFloat("MulSat",1.0);
    row.setInt("LowPass",0);
    command = new String[] {"loadArraysFromTable"};
    TableHandler(command);
    
  }
    
    
  delay(5);
  
    
    
  }
  
  
 
    
void UpdateGDropBoxes() {
  
  lstSelectLight.setItems(LightName, 0);
  lstSelectLight.setSelected(pointer);
  if(settings_open) {
    
    lstLoadLightSettings.setItems(LightName, 0);
    lstLoadLightSettings.setSelected(pointer);
  }
  
  
}

void UpdateSelectionsFromPointer() {
  
  println("UpdateSelectionsFromPointer() called");
  int i = pointer;
  println("UpdateSelectionsFromPointer() called. MulSat = "+MulSat[i]);
  sliMul.setValueX(MulColor[i]);
  sliMul.setValueY(MulBright[i]);
  sliBass.setValue(BassSliderValue[i]);
  sliTreble.setValue(TrebSliderValue[i]);
  sliLowPass.setValue(LowPass[i]);
  sliMulSat.setValue(MulSat[i]);
  txbTrebArraySize.setText(str(TrebArraySize[i]));
  if(Mode[i] == 1) {
  chkMode.setSelected(true);
  }
  if(Mode[i] == 0) {
    chkMode.setSelected(false);
  }
  if(settings_open) {
    txbPin.setText(str(Pin[i]));
    txbLightName.setText(LightName[i]);
    txbLEDsAmount.setText(str(LedsAmount[i]));
    
    
    
    
  }
  
    
  
  
  
}

void SaveSelectionsToArray() {
  
  int i = pointer;
  
 
  MulColor[i] = sliMul.getValueXF();
  MulBright[i] = sliMul.getValueYF();
  BassSliderValue[i] = sliBass.getValueI();
  TrebSliderValue[i] = sliTreble.getValueI();
  TrebArraySize[i] = int(txbTrebArraySize.getText());
  LowPass[i] = sliLowPass.getValueI();
  MulSat[i] = sliMulSat.getValueF();
  if(chkMode.isSelected()) {
  Mode[i] = 1;
  }
  if(chkMode.isSelected() == false) {
    Mode[i] = 0;
  }
  
  if(settings_open) {
    Pin[i] = int(txbPin.getText());
    LedsAmount[i] = int(txbLEDsAmount.getText());
    LightName[i] = txbLightName.getText();
    
    
    
    
  }
  
  
  
  
}

String normaliseint(int i)
{
  String add = "";
  String result = "";
  
  if(i<10)
  {
    add = "00";
    
  }
  if(i>=10 && i<100)
  {
    add = "0";
   
  }
  
  
  result = add+str(i);
  
  return result;
  
}



public void setup(){
  size(800, 300, JAVA2D);
  command = new String[] {"",""};
  LightNameVisualBuffer = new String[] {"Loading..."};
  bass = new float[60];
  treble = new float[60];
  pointer = 0;
  TableFirstLoad();
  Construct();
  createGUI();
  UpdateGDropBoxes();
  UpdateSelectionsFromPointer();
  thread("portWrite");
  
   

  
  
 
  
}



void Construct()
{
  
  
 
  
  minim = new Minim(this);
  in = minim.getLineIn();
  device = new AudioIn(this, 0);
  device.start();
  rms = new Amplitude(this);
  rms.input(device);
  ports = Serial.list();
  
  
  fft = new ddf.minim.analysis.FFT(in.bufferSize(), in.sampleRate());
  /*
  port = new Serial(this, Serial.list()[COMval],1000000); 
  port.clear();
  port.stop();
  */
    
  
  
  //fft.forward(in.mix);
  
  //RawFFT = new float[specSize];
  
  
  
}

// Use this method to add additional statements
// to customise the GUI controls