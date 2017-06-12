void GetFFTData()
{
  if(ready) {
  int TableRowCount = LightSettings.getRowCount();
  for(int point = 0;point<TableRowCount;point++) {
  
  //fft.forward(in.mix);
  float bassavg = 0;
  float trebavg = 0;
  float newtreble = 0;
  
  for(int i = 1; i < fftLines; i++)
  {
    float band = fft.getBand(i);
    band = constrain(band,0,255);
    //RawFFT[i] = band;
  if(i>=TrebSliderValue[point] && i<=TrebSliderValue[point]+TrebArraySize[point])
    {

        if(band>newtreble)
        {
          newtreble = band;
        }
     
    }
    
    //BASS WORKING
    
    if(i>TrebSliderValue[point] && i<=BassSliderValue[point])
    {
      bassavg = bassavg + band;
     
    }
    
 }

  if(Mode[point] == 0)
  {
    
  trebavg = trebavg / TrebArraySize[point];
  treble[point] = constrain(MulBright[point],0,255);
  bassavg = bassavg / BassSliderValue[pointer];
  bass[point] = constrain(bassavg*MulColor[point],0,255);
  }
  if(Mode[point] == 1)
  {
  //treble[point] = constrain(newtreble*MulBright[point],0,255);
  treble[point] = newtreble;
  bassavg = bassavg / BassSliderValue[point];
  bass[point] = bassavg;
  }
  //println(bass, treble);
  
  
  
  
}
}
}