/*                                  
 OUTPUT - MS WERNER
 Jedes Modul in Processing auf 16 x 16 angelegt. An 
 der Wand sind die Module jedoch vom Index und der
 Anzahl nicht gleich. Damit alles passt, hier die
 Lösung des Problems:
 
 
 Modul an der Wand: 
 /--------------------------------------------------/
 /    x    /    x    /    x    /    x    /    1     /
 /--------------------------------------------------/
 /    x    /    x    /    x    /    3    /    2     /
 /--------------------------------------------------/
 /    x    /    x    /    4    /    5    /    6     /
 /--------------------------------------------------/
 /    x    /   10    /    9    /    8    /    7     /
 /--------------------------------------------------/
 /    x    /   11    /    12   /    13   /    14    /
 /--------------------------------------------------/ usw.
 
 Modul in Processing:
 /--------------------------------------------------/
 /    1    /    2    /    3    /    4    /    5     /
 /--------------------------------------------------/
 /    6    /    7    /    8    /    9    /    10    /
 /--------------------------------------------------/
 /    11   /   12    /    13   /    14   /    15    /
 /--------------------------------------------------/
 /    16   /   17    /    18   /    19   /    20    /
 /--------------------------------------------------/
 /    21   /   22    /    23   /    24   /    25    /
 /--------------------------------------------------/ usw.
 
 
 Somit muss das Array zum Auslesen für das ProcessingModul wie 
 folgt aussehen: [5,10,9,13,14,15,20,19,18,17,22,23,24,25],
 damit es am Display in Reihe ausgegeben werden kann. 
 
 
 println( c ); // -16711936        
 println( hex(c) ); // FF00FF00                         
 */

class LEDOutput {

  PApplet pa;
  PGraphics pg;
  
  LEDOutput(PApplet pa){
    this.pa = pa;
  }

  //VARIABLEN
  int WidthModule = 16;
  int[] Pixels;
  int state;
  int count;
  int state1;
  int state2;
  boolean firstRaw;
  //Serial
  Serial myPort;  // Create object from Serial class
  //byte[][] allModulesLED;
  byte[] dataLED;

  //MODULE
  int[][] allModules;
  float[][] rgbModules;
  void setupDisplay() {

    println(Serial.list()[3]);
    //INIZIALISIEREN


    //Serial
    //println(Serial.list());
    String portName = Serial.list()[3]; //3 entspricht ...usbmodem1635641
    myPort = new Serial(pa, portName, 115200);  //9600 ist langsam -> hochsetzen auf 115200
    myPort.setDTR(true);
    //println(Serial.list());

    //strokeWeight(12);  
    firstRaw = true;
    Pixels = new int[0];
    count = 0;
    state1=0;
    state2=5;
    allModules = new int[10][0];
    rgbModules = new float[10][0];
    dataLED =  new byte[735];    //Hier für 245LEDs pro Modul -> muss später angepasst werden!!!
  }

  void drawDisplay() {
    fillPixelArray();  //HIER FEHLER SUCHEN - DAUER ZU LANGE
    moduleAufbau();
    //drawAll();
    
    drawM1();
    /* drawM2();
     drawM3();
     drawM4();
     drawM5();
     drawM6();
     drawM7();
     drawM8();
     drawM9();
     drawM10();*/

    float[] newrgb = makeRightOrder(rgbModules[0], moduleOrder2); //hier richtiges Modul übergeben!
    makeDataLED(newrgb);
    myPort.write(dataLED);
    clearAll();
    //delay(10);
  }


  /*#########################################*/
  
  void getGraphic(PGraphics graphic){
    pg = graphic;
  }
  
  /*#########################################*/
  
  
  void fillPixelArray() {
    pg.loadPixels();
    for (int i = 0; i < pg.height; i += 1) {
      for (int j = 0; j < pg.width; j += 1) { 
        Pixels = append(Pixels, pg.pixels[j + i*pg.width ]);
      }
    }
  }

  //Zeichnet und gibt dem makeRGBModule() die rgb-Werte
  void drawPixels(int index1, int posX, int posY) {
    int index2 = 0;

    //println("0: "+allModules[0]);
    for (int y = 0; y < WidthModule; y++) { 
      for (int x = 0; x < WidthModule; x++) { 
        float red = (allModules[index1][index2]) >> 16 & 0xFF;
        float green = (allModules[index1][index2]) >> 8 & 0xFF;
        float blue =  (allModules[index1][index2]) & 0xFF;
        //println("red: "+bed);
        //println("green: "+breen);
        //println("blue: "+bbue);
        //println(byte(-1));
        //float all = byte(colorWiring(allModules[index1][index2]));
        //println("all: "+ all);
        makeRGBModules(index1, red, green, blue);
        //stroke(red, green, blue);
        //point(x*16+posX, y*16+posY);

        index2++;
      }
    }
  }

  //Erstellt ein RGB-Modul-Array
  void makeRGBModules(int index1, float red, float green, float blue) {
    rgbModules[index1] = append(rgbModules[index1], red);
    rgbModules[index1] = append(rgbModules[index1], green);
    rgbModules[index1] = append(rgbModules[index1], blue);
  }

  //Erstellt aus der RGB-Array ein Byte-Array
  void makeDataLED(float[] rgbArray) {
    for (int i = 0; i<rgbArray.length; i++) {
      dataLED[i] = byte(rgbArray[i]);
      //println(dataLED[i]);
    }
  }

  //ganz wichtig, zum Schluss alles leeren.
  void clearAll() {
    Pixels = new int[0];
    allModules = new int[10][0];
    rgbModules = new float[10][0];
    dataLED =  new byte[735];
    count = 0;
    state1=0;
    state2=5;
  }

  //Funktionen zum Zeichnen der Module
  void drawM1() {
    drawPixels(0, 9, 110);
  }

  void drawM2() {
    drawPixels(1, 264, 110);
  }

  void drawM3() {
    drawPixels(2, 519, 110);
  }

  void drawM4() {
    drawPixels(3, 774, 110);
  }

  void drawM5() {
    drawPixels(4, 1029, 110);
  }

  void drawM6() {
    drawPixels(5, 9, 365);
  }

  void drawM7() {
    drawPixels(6, 264, 365);
  }
  void drawM8() {
    drawPixels(7, 519, 365);
  }

  void drawM9() {
    drawPixels(8, 774, 365);
  }

  void drawM10() {
    drawPixels(9, 1029, 365);
  }

  //Zum Zeichen aller Module
  void drawAll() {
    int index = 0;
    for (int i = 20; i < height; i += 22) {
      for (int j = 8; j < width+8; j += 16) { 
        float red = (Pixels[index]) >> 16 & 0xFF;
        float green = (Pixels[index]) >> 8 & 0xFF;
        float blue =  (Pixels[index]) & 0xFF;    //shiften geht schneller
        stroke(red, green, blue);
        point(j, i);
        index++;
      }
    }
  }

  //Zum Füllen der Module
  void fillModules(int state, int value) {
    switch(state) {
    case 0: 
      allModules[0] = append(allModules[0], value);
      break;
    case 1: 
      allModules[1] = append(allModules[1], value);
      break;
    case 2: 
      allModules[2] = append(allModules[2], value);
      break;
    case 3: 
      allModules[3] = append(allModules[3], value);
      break;
    case 4: 
      allModules[4] = append(allModules[4], value);
      break;
    case 5: 
      allModules[5] = append(allModules[5], value);
      break;
    case 6: 
      allModules[6] = append(allModules[6], value);
      break;
    case 7:  
      allModules[7] = append(allModules[7], value);
      break;
    case 8: 
      allModules[8] = append(allModules[8], value);
      break;
    case 9: 
      allModules[9] = append(allModules[9], value);
      break;
    default:             
      println("ERROR fillModules"); 
      break;
    }
  }

  //Grundlegende Funktion für den Modulaufbau
  void moduleAufbau() {
    state = 0;
    for (int i = 0; i < Pixels.length; i++) {
      updateState(i);
      fillModules(state, Pixels[i]);
    }
  }

  //Wichtige Funktion zum Aufteilen der Module -> State: SwitchCase
  void updateState(int index) {

    if (index < 1280) { //1280 = 16 * 80 -> die ersten 16 Reihen fuer Module 1-5
      firstRaw = true;
      if ((index%16)==0 && index != 0) {
        state1 = state1 + 1;
      }
      if (state1 == 5) {
        state1 = 0;
      }
    } else {
      firstRaw = false;
      if ((index%16)==0) {
        if (count > 0) {
          state2 = state2 + 1;
        }

        count++;
      }
      if (state2 == 10) {
        state2=5;
      }
    }
    if (firstRaw) {
      state = state1;
    } else {
      state = state2;
    }
  }

  /*ZUM MERKEN
   
   int colorWiring(int c) {
   //   return c;  // RGB
   return ((c & 0xFF0000) >> 8) | ((c & 0x00FF00) << 8) | (c & 0x0000FF); // GRB - most common wiring
   }
   
   void changePixelsHorizontal() {
   for (int x = 0; x < width; x ++) {
   for (int y = 0; y < height; y+=4) {
   pixels[y*width+x] = color(255, 0, 0);
   }
   }
   }
   
   void changePixelsVertical() {
   for (int y = 0; y < height; y ++) {
   for (int x = 0; x < width; x+=4) {
   pixels[y*width+x] = color(255, 0, 0);
   }
   }
   }
   */

  //BoilerModule mit 256 Pixel
  int[] boiler = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 
    32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 
    33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 
    64, 63, 62, 61, 60, 59, 58, 57, 56, 55, 54, 53, 52, 51, 50, 49, 
    65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 
    96, 95, 94, 93, 92, 91, 90, 89, 88, 87, 86, 85, 84, 83, 82, 81, 
    97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 
    128, 127, 126, 125, 124, 123, 122, 121, 120, 119, 118, 117, 116, 115, 114, 113, 
    129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 
    160, 159, 158, 157, 156, 155, 154, 153, 152, 151, 150, 149, 148, 147, 146, 145, 
    161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 
    192, 191, 190, 189, 188, 187, 186, 185, 184, 183, 182, 181, 180, 179, 178, 177, 
    193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 
    224, 223, 222, 221, 220, 219, 218, 217, 216, 215, 214, 213, 212, 211, 210, 209, 
    225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 
    256, 255, 254, 253, 252, 251, 250, 249, 248, 247, 246, 245, 244, 243, 242, 241, 
  };

  //Modul mit 245 Pixel
  int[] moduleOrder2 = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 
    32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, -1, 
    33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 
    64, 63, 62, 61, 60, 59, 58, 57, 56, 55, 54, 53, 52, 51, 50, -1, 
    65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, -1, 
    96, 95, 94, 93, 92, 91, 90, 89, 88, 87, 86, 85, 84, 83, 82, -1, 
    97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, -1, 
    128, 127, 126, 125, 124, 123, 122, 121, 120, 119, 118, 117, 116, 115, 114, -1, 
    129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 
    160, 159, 158, 157, 156, 155, 154, 153, 152, 151, 150, 149, 148, 147, 146, -1, 
    161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, -1, 
    192, 191, 190, 189, 188, 187, 186, 185, 184, 183, 182, 181, 180, 179, 178, -1, 
    193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, -1, 
    224, 223, 222, 221, 220, 219, 218, 217, 216, 215, 214, 213, 212, 211, 210, -1, 
    225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, -1, 
    256, 255, 254, 253, 252, 251, 250, 249, 248, 247, 246, 245, 244, 243, 242, 241, 
  };                    

  //Erstellt die Reihenfolge für die Module.
  float[] makeRightOrder(float[] rgb, int[] order) {
    int count = 1;
    float[] newrgb = new float[735];
    for (int i = 0; i<order.length; i++) {
      if (order[i] != -1) {
        newrgb[(count*3)-3] = rgb[(order[i]*3)-3];
        newrgb[(count*3)-2] = rgb[(order[i]*3)-2];
        newrgb[(count*3)-1] = rgb[(order[i]*3)-1];
        count += 1;
      }
    }
    return newrgb;
  }
}