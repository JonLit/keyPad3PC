import controlP5.*; //<>// //<>// //<>// //<>// //<>//
import websockets.*;
import java.awt.*;
import java.awt.Robot.*;
import java.awt.event.KeyEvent.*;
import java.io.*;

WebsocketClient wsc;
Robot robot;

//ControlP5 cp5;

boolean[] bts;
String mode = "usb";
String status = "startup";
public Process adbproc;

void setup() {
  connect();
  
  size(200, 200);
  
  frameRate(240);
  
  /*cp5 = new ControlP5(this);
  
  cp5.addTextfield("IP:Port")
  .setPosition(10, 170)
  .setSize(150, 20)
  .setFocus(true);

  cp5.addButton("connect")
  .setPosition(160, 170)
  .setSize(20, 20);*/
  
  try {
    robot = new Robot();
  }
  catch (Exception e) {
    e.printStackTrace();
  }
}

void draw() {
  fill(0);
  background(255);
  switch (status) {
    case "running":
      if (bts[0] == true) {
        rect(0, 0, width*0.5, height);
        robot.keyPress(88);
      } else {
        robot.keyRelease(88);
      }
      if (bts[1] == true) {
        rect(width*0.5, 0, width*0.5, height);
        robot.keyPress(89);
      } else {
        robot.keyRelease(89);
      }
    break;
    case "adbcrash":
      pushStyle();
      textAlign(CENTER, CENTER);
      fill(0);
      text("adb crashed,\n restart Program!", width*0.5, height*0.5);
      popStyle();
  }
  //println(bts);
  //println(int(bts[0]) + "  ;  " + int(bts[1]));
}

void webSocketEvent(String msg) {
  bts = boolean(int(split(msg, ',')));
  //println(msg);
}

void connect() {
  status = "adbstart";
  switch (mode) {
    case "usb":
      ProcessBuilder taskkillProcessBuilder = new ProcessBuilder("taskkill", "/IM", "adb.exe", "/F");
      ProcessBuilder killallProcessBuilder = new ProcessBuilder("killall", "adb");
      ProcessBuilder processBuilder = new ProcessBuilder("adb", "forward", "tcp:8025", "tcp:8025");
      try {
        println(millis() + "\t: killing adb...");
        killallProcessBuilder.start();
        taskkillProcessBuilder.start();
        delay(50);
        println(millis() + "\t: trying adb forward...");
        adbproc = processBuilder.start();
        BufferedReader stdoutReader = new BufferedReader(new InputStreamReader(adbproc.getInputStream()));
        BufferedReader stderrReader = new BufferedReader(new InputStreamReader(adbproc.getErrorStream()));
        String line;
        while ((line = stdoutReader.readLine()) != null) {
          println("stdout: " + line);
        }
        while ((line = stderrReader.readLine()) != null) {
          println("stderr: " + line);
        }
        int exitCode = adbproc.waitFor();
        println(millis() + "\t: ADB exited with code: " + exitCode);
        if (exitCode > 0) {
          println(millis() + "\t: adb didn't execute properly, please restart");
        }
        } catch (IOException | InterruptedException e) {
        e.printStackTrace();
      }
      break;
  }
  status = "connecting";
  try {
    wsc = new WebsocketClient(this, "ws://localhost:8025/keypad");
  } catch (Exception e) {
    e.printStackTrace();
  }
  bts = new boolean[2];
  status = "running";
}

void mouseClicked() {
  connect();
}
