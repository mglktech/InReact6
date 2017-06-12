// Button Events

public void HandleButtonEvents(GButton source, GEvent event) {
  
  if(source == btnSettings && event == GEvent.CLICKED) {
    CreateSettingsWindow();
    settings_open = true;
    UpdateGDropBoxes();
    UpdateSelectionsFromPointer();
    
  }
  if(source == btnSave && event == GEvent.CLICKED) {
    
    
    SaveSelectionsToArray();
    command[0] = "saveArraysToTable";
    TableHandler(command);
    command[0] = "saveTable";
    TableHandler(command);
    UpdateSelectionsFromPointer();
    UpdateGDropBoxes();
    
    
  }
  if(source == btnSaveSelection && event == GEvent.CLICKED) {
    
    
    SaveSelectionsToArray();
    command[0] = "saveArraysToTable";
    TableHandler(command);
    command[0] = "saveTable";
    TableHandler(command);
    UpdateSelectionsFromPointer();
    UpdateGDropBoxes();
    DebugText = "Light Settings Saved!";
    
    
  }
  
  if(source == btnNewLight && event == GEvent.CLICKED) {
    command[0] = "newline";
    TableHandler(command);
    UpdateGDropBoxes();
    UpdateSelectionsFromPointer();
    
  }
  if(source == btnExecute && event == GEvent.CLICKED) {
    if(connected == false) {
      int sel = lstCom.getSelectedIndex();
      String curport = Serial.list()[sel].toString();
      port = new Serial(this, Serial.list()[sel],1000000);
      DebugText = "Connecting to: "+curport+" ...";
      
      
    }
    if(connected == true) {
      
      port.clear();
      port.stop();
      
      DebugText = "Disconnected.";
      connected = false;
      handshake = false;
      btnExecute.setText("Connect");
    }
    
    
    
    
  }
  
  
  
}

// Slider Events

public void HandleSliderEvents(GSlider source, GEvent event) {
  
  if(source == sliBass && event == GEvent.VALUE_STEADY) {
    lblsliBass.setText(sliBass.getValueS());
    SaveSelectionsToArray();
    
  }
  if(source == sliTreble && event == GEvent.VALUE_STEADY) {
    lblsliTreble.setText(sliTreble.getValueS());
    SaveSelectionsToArray();
    
  }
  if(source == sliLowPass && event == GEvent.VALUE_STEADY) {
    
    SaveSelectionsToArray();
  }
  if(source == sliMulSat && event == GEvent.VALUE_STEADY) {
    
    SaveSelectionsToArray();
  }
  
  
  
}

public void Handle2DSliderEvents(GSlider2D source, GEvent event) {
  
  if(source == sliMul && event == GEvent.VALUE_STEADY) {
    
    float x = sliMul.getValueXF();
    float y = sliMul.getValueYF();
    String strX = sliMul.getValueXS();
    String strY = sliMul.getValueYS();
    lblsliMul.setText(strX+" , "+strY);
    SaveSelectionsToArray();
    
  }
  
  
  
   //lblsliMul
  
}

// TextBox Events

public void HandleTextboxEvents(GTextField source, GEvent event) {
  
  if(source == txbTrebArraySize && event == GEvent.ENTERED) {
    
    try {
      TrebArraySize[pointer] = int(txbTrebArraySize.getText());
      println("worked. "+TrebArraySize);
      SaveSelectionsToArray();
    }
    catch(IllegalArgumentException e)  {
   
    println("Please put Numbers not Letters!");
  }
    
  }
  if(source == txbPatternNum && event == GEvent.ENTERED) 
    
  {
    //try {
        String constru = "S";
        String LightNum = normaliseint(lstSelectLight.getSelectedIndex()+1);
        String PatternNum = normaliseint(int(txbPatternNum.getText()));
        constru += LightNum;
        constru += PatternNum;
        println(constru);
        queue = constru;
        
   // }
   // catch(IllegalArgumentException e) {
      //println("Please put Numbers not Letters!");
   // }
    
    
    
  }
  
  
  
}

// DropListEvents

public void HandleDropListEvents(GDropList source, GEvent event) {
  
  if(source == lstCom && event == GEvent.SELECTED) {
    
    DebugText = "Ready to Connect: "+lstCom.getSelectedText()+"...";
    
  }
  if(source == lstSelectLight && event == GEvent.SELECTED) {
    
    if(settings_open) {
      
      pointer = lstLoadLightSettings.getSelectedIndex();
      
    }
    
    else {pointer = lstSelectLight.getSelectedIndex();}
    UpdateSelectionsFromPointer();
    
    
    
  }
  if(source == lstLoadLightSettings && event == GEvent.SELECTED) {
    
    pointer = lstLoadLightSettings.getSelectedIndex();
    UpdateSelectionsFromPointer();
    
  }
  
  
  
  
 
  
}

// Other Misc Handlers

public void chkMode_clicked(GCheckbox checkbox, GEvent event) {
  
  SaveSelectionsToArray();
}

public void winLightSettings_OnClose(GWindow window) {
  settings_open = false;
  
}