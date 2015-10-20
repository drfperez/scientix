/**In this project I suggest to my student to use Augmented Reality, Text to Speech and Arduino
Francisco Pérez
NyARToolkit for proce55ing/2.2.1
© 2014-2015 nyatla
Sergi Bosquet & Michael Omar project

/** Modified from:
NyARToolkit for proce55ing/1.0.0
(c)2008-2011 nyatla
airmail(at)ebony.plala.or.jp

人マーカの上に右手系、Hiroマーカの上に左手系の立方体を表示します。

This sample program shows rotation of 2 coordinate system.(left and right).
The marker is “patt.hiro” and “patt.kanji”
*/
import processing.serial.*;
import processing.video.*;
import jp.nyatla.nyar4psg.*;
import guru.ttslib.*;
import org.firmata.*;
import cc.arduino.*;

Arduino arduino;
TTS tts;
Capture cam;
MultiMarker hiro;
MultiMarker kanji;
PFont font=createFont("Century-48.vlw", 48);
void setup() {
size(640,480,P3D);
colorMode(RGB, 100);
println(MultiMarker.VERSION);

//キャプチャを作成
arduino = new Arduino(this, Arduino.list()[0], 57600);
tts=new TTS ();
cam=new Capture(this,640,480);

kanji=new MultiMarker(this,width,height,"camera_para.dat",new NyAR4PsgConfig(NyAR4PsgConfig.CS_LEFT_HAND,NyAR4PsgConfig.TM_NYARTK));
kanji.addARMarker("patt.kanji",80);

hiro=new MultiMarker(this,width,height,"camera_para.dat",new NyAR4PsgConfig(NyAR4PsgConfig.CS_RIGHT_HAND,NyAR4PsgConfig.TM_NYARTK));
hiro.addARMarker("patt.hiro",80);

arduino.pinMode(13, Arduino.OUTPUT);
cam.start();

}

int c=0;
void drawgrid()
{
pushMatrix();
stroke(0);
strokeWeight(2);
line(0,0,0,100,0,0);
textFont(font,20.0); text("X",100,0,0);
line(0,0,0,0,100,0);
textFont(font,20.0); text("Y",0,100,0);
line(0,0,0,0,0,100);
textFont(font,20.0); text("Z",0,0,100);
popMatrix();
}
void draw()
{
c++;
if (cam.available() !=true) {
return;
}
cam.read();
hiro.detect(cam);
kanji.detect(cam);
background(0);
hiro.drawBackground(cam);//frustumを考慮した背景描画

//right
if((hiro.isExistMarker(0))){
hiro.beginTransform(0);
tts.speak("red led");
arduino.digitalWrite(13,Arduino.HIGH);
arduino.digitalWrite(9,Arduino.LOW);
fill(255,0,0);
drawgrid();
translate(0,0,20);
rotate((float)c/100);
box(40);
hiro.endTransform();
}
else if((kanji.isExistMarker(0))){
kanji.beginTransform(0);
tts.speak("green led");
arduino.digitalWrite(9,Arduino.HIGH);
arduino.digitalWrite(13,Arduino.LOW);
fill(0,255,0);
drawgrid();
translate(0,0,20);
rotate((float)c/100);
box(40);
kanji.endTransform();
}

else {
tts.speak("");
arduino.digitalWrite(9,Arduino.LOW);
arduino.digitalWrite(10,Arduino.LOW);
}
}
