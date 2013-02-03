import controlP5.*;
import oscP5.*;
import netP5.*;

// gui
ControlP5 cp5;
int myColor = color(0,0,0);

// android stuff (maybe using keitai library instead)
//http://ketai.googlecode.com/svn/trunk/ketai/reference/ketai/ui/class-use/KetaiKeyboard.html
/*import android.view.inputmethod.InputMethodManager;
import android.content.Context;
void showVirtualKeyboard() {
  InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
  imm.toggleSoftInput(InputMethodManager.SHOW_FORCED,0);
}

void hideVirtualKeyboard() {
  InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
  imm.toggleSoftInput(InputMethodManager.HIDE_IMPLICIT_ONLY, 0);
}
*/

// osc
OscP5 oscP5;
NetAddress myRemoteLocation;

// define
int sliderValue = 10;
int myColorBackground = color(0,0,0);

void setup() {
  
  size(800,600);
  frameRate(25);
  
  // gui
  cp5 = new ControlP5(this);
  
  // start oscP5, listening for incoming messages at port 12000
  oscP5 = new OscP5(this,11000);
  //send OSC mesage to ip / port
  myRemoteLocation = new NetAddress("192.168.1.100",12000);

  // gui
  cp5.addSlider("sliderValue")
     .setPosition(100,50)
     .setRange(0,255)
     ;
     
}

void draw() {
  background(myColorBackground); 
}

void mousePressed() {
  print("sending to OSC /sliderValue/");
  print(sliderValue);
  OscMessage myMessage = new OscMessage("/sliderValue");
  myMessage.add(sliderValue);
  myColorBackground = color(sliderValue);
  oscP5.send(myMessage, myRemoteLocation); 
}

void oscEvent(OscMessage theOscMessage) {
  if(theOscMessage.checkAddrPattern("/sliderValue")==true) {
      int sv = theOscMessage.get(0).intValue();
      myColorBackground = color(sv);
      println("/sliderValue: "+sv);
  }  
  println("### received an osc message. with address pattern "+theOscMessage.addrPattern());
}
