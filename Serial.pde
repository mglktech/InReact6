String queue = "";

void portWrite()
{
  boolean running = true;
  while(running)
  {
  
  
  
  //println("Constr: "+constr);
  
  if(connected)
  {
  int TableRowCount = LightSettings.getRowCount();
  String constr = "";
  for(int point = 0;point<TableRowCount;point++) {
    if(treble[point]>=LowPass[point]) {
      int total = 0;
      total = floor(bass[point] + treble[point] / 2);
      constr += ChasePattern(floor(bass[point]),floor(treble[point]),point);
    }
    if(treble[point]<LowPass[point]){
      constr +="R000G000B000";
      
    }
    
  }
  if(queue != "")
  {
    port.write(queue+'#');
    queue = "";
    delay(1000/threadfps);
  }
  if(queue == "")
  {
     port.write(constr+'#');
     delay(1000/threadfps);
  
  }
 }
  
  if(handshake == false) {//println("No Handshake"); 
delay(300);}
}
}



void serialEvent(Serial p) { 
  char InChar = (char)p.read();
  print(InChar);
  if(InChar == 'N' && handshake == false) {
      println("Handshake Successful!");
      handshake=true; 
      port.write('A');
      DebugTextColor = color(0,255,0);
      DebugText = "Connected.";
      btnExecute.setText("Disconnect");
      connected = true;
      //port.write("S010003015001003005007178000#");
      
    }
   
  //if(InChar == '\n')
  //{postEvent(SerialBuffer);
  //SerialBuffer = "";
 // }
 // else {
 //   SerialBuffer += InChar;
 // }
}