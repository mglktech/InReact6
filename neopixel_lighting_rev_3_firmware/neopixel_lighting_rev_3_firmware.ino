


#include <FastLED.h>


// <-- declare globals

const int num_lights_connected = 3;


const int leds_a_num = 176;
const int leds_a_pin = 12;
const int leds_a_start = 0;
int leds_a_pattern = 1;

const int leds_b_num = 4;
const int leds_b_pin = 11;
const int leds_b_start = leds_a_num;
int leds_b_pattern = 3;



const int leds_c_num = 19;
const int leds_c_pin = 10;
const int leds_c_start = leds_b_start+leds_b_num;
int leds_c_pattern = 3;
/*
const int leds_d_num = 0;
const int leds_d_pin = 9;
const int leds_d_start = leds_c_start + leds_c_num;

const int leds_e_num = 0;
const int leds_e_pin = 8;
const int leds_e_start = leds_d_start + leds_d_num;


*/
const int num_leds_connected = leds_a_num + leds_b_num + leds_c_num;


bool handshake;
String ReadString;
int read_count;
bool settings_data;
bool stringComplete;
int bass[13];
int treble[13];
int r[13];
int g[13];
int b[13];
bool beat;
bool settingsResponse;
// <-- Prerequisites
CRGB leds[num_leds_connected];
int PatternType;
String settingsResponseString;
int FFT[50];
String ReadStrings[13];
int Num_Commands_Recieved;



int LedArray_CurSize = 0;


//Adafruit_NeoPixel strip = Adafruit_NeoPixel(60, 11, NEO_GRB + NEO_KHZ800);
//Adafruit_NeoPixel strip_a[12];
void setup() {

  
  FastLED.addLeds<NEOPIXEL, leds_a_pin>(leds,leds_a_start,leds_a_num);
  FastLED.addLeds<NEOPIXEL, leds_b_pin>(leds,leds_b_start,leds_b_num);
  FastLED.addLeds<NEOPIXEL, leds_c_pin>(leds,leds_c_start,leds_c_num);
  
   Serial.begin(1000000);
   Serial.setTimeout(1); 
   read_count = 0;
   PatternType=0;
   ReadString.reserve(32);
   handshake = false;
   settingsResponse = false;
   settings_data = false;
   for(int i=0;i<num_leds_connected;i++)
   {
    leds[i]=CHSV(0,0,0);
    
   }

 
   
   FastLED.show();
   
   
   
}

void FlashColRGB(uint8_t R,uint8_t G,uint8_t B,int LedStart,int LedAmount)
{

  for(int i=LedStart+LedAmount;i>=LedStart;i--)
  {
    leds[i] = CRGB(R,G,B);
  }
}

void ChaseStartRGB(uint8_t R,uint8_t G,uint8_t B,int LedStart,int LedAmount)
{
  for(int i=LedStart+LedAmount;i>LedStart;i--)
  {
    leds[i] = leds[i-1];
  }

  leds[LedStart] = CRGB(R,G,B);


  
}

void ChasePatternRGB(uint8_t R,uint8_t G,uint8_t B,int LedStart,int LedAmount)
{
  //Serial.println("Amp: "+String(amp)+" Treb: "+String(treb)+" Start:"+String(LedStart)+" Amnt:" +String(LedAmount));
  int halfleds = floor(LedAmount/2);
  int halfway = LedStart+halfleds;

 for(int i = LedStart;i<halfway; i++)
 {
  leds[i] = leds[i+1];
 }
 for (int i=LedStart + LedAmount;i>halfway;i--)
 {
  leds[i] = leds[i-1];
 }
  
  
  
  leds[halfway] = CRGB(R,G,B);
  leds[halfway+2] = CRGB(R,G,B);
  
 
  

  

  
}






void loop() {
     
    if(handshake == false)
    {
      Serial.print('N');
      delay(300);
    }
   
   

}

void v4way() {

  int len = num_leds_connected*3;
  

}


void serialEvent()
{
  
  while(Serial.available()) {
  
    char inChar = (char)Serial.read();
    
    
    //Serial.print(inChar);
    if(inChar == 'A') {handshake = true; ReadString = ""; read_count = 0;return;}
   

      
    if(handshake == true && inChar == 'R') {Num_Commands_Recieved+=1;}
    if(handshake == true && inChar !='A')
    {
      ReadString += inChar;
    
    if(inChar == '#') {

      if(ReadString.substring(0,1)=="S")
      {
        serial_settings();
        
      }
      if(ReadString.substring(0,1)=="R")
      {
        serial_breakdown();
      }
      //Serial.println(ReadString);
      ReadString = ""; 
      Num_Commands_Recieved = 0;
      
    }
    if(inChar == ';') {

      //Serial breakdown for stream

      ReadString = "";

    }
    
    }
    
   
    }
    
  }
  
  



int CheckOccurence(String str,char c) {

  

  
}
void PatCheck()
{
  if(leds_a_pattern == 1)
  {
    ChasePatternRGB(r[0],g[0],b[0],leds_a_start,leds_a_num);
  }
  if(leds_a_pattern == 2)
  {
    ChaseStartRGB(r[0],g[0],b[0],leds_a_start,leds_a_num);
  }
  if(leds_a_pattern == 3)
  {
    FlashColRGB(r[0],g[0],b[0],leds_a_start,leds_a_num);
  }


  if(leds_b_pattern == 1)
  {
    ChasePatternRGB(r[1],g[1],b[1],leds_b_start,leds_b_num);
  }
   if(leds_b_pattern == 2)
  {
    ChaseStartRGB(r[1],g[1],b[1],leds_b_start,leds_b_num);
  }
  if(leds_b_pattern == 3)
  {
    FlashColRGB(r[1],g[1],b[1],leds_b_start,leds_b_num);
  }


  if(leds_c_pattern == 1)
  {
    ChasePatternRGB(r[2],g[2],b[2],leds_c_start,leds_c_num);
  }
  if(leds_c_pattern == 2)
  {
    ChaseStartRGB(r[2],g[2],b[2],leds_c_start,leds_c_num);
  }
  if(leds_c_pattern == 3)
  {
    FlashColRGB(r[2],g[2],b[2],leds_c_start,leds_c_num);
  }
}
void serial_settings()
{
  int LightNum = ReadString.substring(1,4).toInt();
  int PatNum = ReadString.substring(4,7).toInt();
  Serial.println("LightNum: "+ReadString.substring(1,4)+" PatNum: "+ReadString.substring(4,7));
  if(LightNum == 1)
  {
    leds_a_pattern = PatNum;
  }
  if(LightNum == 2)
  {
    leds_b_pattern = PatNum;
  }
  if(LightNum == 3)
  {
    leds_c_pattern = PatNum;
  }


}
void serial_breakdown()
{
  int command_pointer = 0;
  for(int i=0;i<Num_Commands_Recieved;i++) {

    r[i] = 0;
    g[i] = 0;
    b[i] = 0;

    // each command has 12 characters, R255G255B255, with a # finishing the command string and sending it to this code.
    // At the moment, serial_breakdown will recieve R255G255B255R255G255B255# and must split this.

    if(ReadString.substring(command_pointer,command_pointer+1)=="R")
    {
     
     r[i] = ReadString.substring(command_pointer+1,command_pointer+4).toInt();
     
     
    }
    if(ReadString.substring(command_pointer+4,command_pointer+5)=="G")
    {
      
     g[i] = ReadString.substring(command_pointer+5,command_pointer+8).toInt();
     
     
    
    }
    if(ReadString.substring(command_pointer+8,command_pointer+9)=="B")
    {
      
     b[i] = ReadString.substring(command_pointer+9,command_pointer+12).toInt();
    }



    
    //Serial.println("Pointer: "+String(command_pointer)+" B: "+ String(bass[i]) + " T: " + String(treble[i])+" END");
    command_pointer+=12;
    //PUT PATTERN DATA HERE FOR EACH LIGHT
   
    
    }
    
   PatCheck();

   FastLED.show();
    
}


