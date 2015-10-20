import processing.serial.*;

import org.firmata.*;
import cc.arduino.*;

import guru.ttslib.*;

import gab.opencv.*;
import processing.video.*;
import java.awt.*;

TTS tts;

Arduino arduino;

Capture video;
OpenCV opencv;
int w=640;
int h=480;
void setup() {
size(w,h);
frameRate(60);
tts = new TTS();
arduino = new Arduino(this, Arduino.list()[0], 57600);

video = new Capture(this, w/2, h/2);
opencv = new OpenCV(this, w/2, h/2);
opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);

arduino.pinMode(7, Arduino.OUTPUT);
arduino.pinMode(6, Arduino.OUTPUT);
arduino.pinMode(5, Arduino.OUTPUT);
arduino.pinMode(4, Arduino.OUTPUT);
arduino.pinMode(3, Arduino.OUTPUT);

video.start();
}

void draw() {
scale(2);
opencv.loadImage(video);

image(video, 0, 0);

noFill();
stroke(65, 60, 255);
strokeWeight(3);
Rectangle[] faces = opencv.detect();
println(faces.length);

for (int i = 0; i < faces.length; i++) {
println(faces[i].x + "," + faces[i].y);
ellipseMode(CORNER);
ellipse(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
}
if(faces.length==1){
arduino.digitalWrite(13,Arduino.HIGH);
arduino.digitalWrite(6,Arduino.LOW);
arduino.digitalWrite(5,Arduino.LOW);
arduino.digitalWrite(4,Arduino.LOW);
arduino.digitalWrite(3,Arduino.LOW);
tts.speak("One person on the screen at position x"+faces[0].x+"and at position y"+faces[0].y);
}
else if (faces.length==0){
tts.speak("Nobody on the screen");
arduino.digitalWrite(13,Arduino.LOW);
arduino.digitalWrite(6,Arduino.LOW);
arduino.digitalWrite(5,Arduino.LOW);
arduino.digitalWrite(4,Arduino.LOW);
arduino.digitalWrite(3,Arduino.LOW);
}
else if (faces.length==2){
saveFrame();
tts.speak("There are"+faces.length+"people on the screen");
arduino.digitalWrite(7,Arduino.HIGH);
arduino.digitalWrite(6,Arduino.HIGH);
arduino.digitalWrite(5,Arduino.LOW);
arduino.digitalWrite(4,Arduino.LOW);
arduino.digitalWrite(3,Arduino.LOW);

}
else if (faces.length==3){

tts.speak("There are"+faces.length+"people on the screen");
arduino.digitalWrite(7,Arduino.HIGH);
arduino.digitalWrite(6,Arduino.HIGH);
arduino.digitalWrite(5,Arduino.HIGH);
arduino.digitalWrite(4,Arduino.LOW);
arduino.digitalWrite(3,Arduino.LOW);

}
else if (faces.length==4){
tts.speak("There are"+faces.length+"people on the screen");
arduino.digitalWrite(7,Arduino.HIGH);
arduino.digitalWrite(6,Arduino.HIGH);
arduino.digitalWrite(5,Arduino.HIGH);
arduino.digitalWrite(4,Arduino.HIGH);
arduino.digitalWrite(3,Arduino.LOW);

}
else if (faces.length==5){
tts.speak("There are"+faces.length+"people on the screen");
arduino.digitalWrite(7,Arduino.HIGH);
arduino.digitalWrite(6,Arduino.HIGH);
arduino.digitalWrite(5,Arduino.HIGH);
arduino.digitalWrite(4,Arduino.HIGH);
arduino.digitalWrite(3,Arduino.HIGH);

}
}
void captureEvent(Capture c) {
c.read();
}
