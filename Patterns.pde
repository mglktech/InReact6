

String HSBConstr (int hue, int sat, int brightness)
{
  NoDraw = true;
  String constr2 = "";
  colorMode(HSB, 255);
  color c = color(hue,sat,brightness);
  String r = normaliseint(floor(red(c)));
  String g = normaliseint(floor(green(c)));
  String b = normaliseint(floor(blue(c)));
  colorMode(RGB, 255);
  NoDraw = false;
  constr2+="R"+r+"G"+g+"B"+b;
  return constr2;
  
}


String ChasePattern(int amp, int treb,int point)
{
  int total = floor(amp+treb / 2);
  int brightness = (amp+treb)-255;
  int opptreb = 255-treb;
  int oppamp = 255-amp;
  if(treb < 10)
  {
    treb = 0;
  }
  if(amp<10)
  {
    amp=0;
  }
  return HSBConstr(floor(constrain(treb*MulColor[point],0,255)),floor(MulSat[point]),floor(constrain(total*MulBright[point],0,255)));
  
}