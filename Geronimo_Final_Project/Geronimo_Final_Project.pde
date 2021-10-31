// jet - paint.
// 1-7-2019

int toolMode = 1; // 1 = brush, 2 = line, 3 = eraser.
PImage brush;
PImage line;
PImage eraser;
PImage screenshot;

boolean makingLine = false;
int point1X;
int point2X;
int point1Y;
int point2Y;

color[] currentPalette = {#000000, #FFFFFF, #FF0000, #00FF00, #0000FF};
color[] palette = {#000000, #FFFFFF, #FF0000, #00FF00, #0000FF};
color[] palette1 = {#FF0000, #FF5A00, #FFF400, #2FFF00, #002BFF};
color[] palette2 = {#4694AE, #7AcA5E, #EDBF5C, #9F659D, #F3706B};
color[] palette3 = {#711c91, #ea00d9, #0abdc6, #133e7c, #091833};
color[] palette4 = {#ff00c1, #9600ff, #4900ff, #00b8ff, #00fff9};
color[] palette5 = {#75c8ae, #5a3d2b, #ffecb4, #e5771e, #f4a127};
color[] palette6 = {#2f1374, #4233e3, #fff968, #215cff, #5718ba};
color[] palette7 = {#4b3333, #f6f3f3, #a7917c, #470101, #222222};
color[] palette8 = {#4ca1cc, #3f943f, #795638, #eea747, #a360b2};
color[] palette9 = {51, 102, 153, 204, 255};
color[] random;
color[][] palettes = {palette, palette1, palette2, palette3, palette4, palette5, palette6, palette7, palette8, palette9, random};
color primary = #000000;
int mouse1X, mouse1Y;
float thickness = 5;

void setup() {
  background(#e5e5e5);
  size(800, 650);
  
  brush = loadImage("brush.png");
  line = loadImage("line.png");
  eraser = loadImage("eraser.png");
  screenshot = loadImage("screenshot.png");
}

void draw() {
  // display the toolbar.
  noStroke();
  fill(#89CFF0);
  rect(0, 0, width, 105);
  
  // display the palette.
  for (int i = 0, x = 0; i < currentPalette.length; i++, x+=50) {
    noStroke();
    fill(currentPalette[i]);
    rect(x, 0, 50, 100);
  }
  
  // indicator of color and brush size.
  fill(primary);
  ellipse(350, 52.5, thickness, thickness);
  
  // tool buttons.
  if (toolMode == 1) {
    fill(#ff0000);
  } else {
    fill(#ffd195);
  }
  rect(450, 20, 50, 50);
  image(brush, 450, 20, 50, 50);
  if (toolMode == 2) {
    fill(#ff0000);
  } else {
    fill(#ffd195);
  }
  rect(505, 20, 50, 50);
  image(line, 505, 20, 50, 50);
  if (toolMode == 3) {
    fill(#ff0000);
  } else {
    fill(#ffd195);
  }
  rect(560, 20, 50, 50);
  image(eraser, 560, 20, 50, 50);
  fill(#ffd195);
  rect(615, 20, 50, 50);
  image(screenshot, 615, 20, 50, 50);
  
  
  // create tool actions.
  if (mousePressed && mouseY >= 100) {
    if (toolMode == 1) {
      strokeWeight(thickness);
      stroke(primary);
      line(mouse1X, mouse1Y, mouseX, mouseY);
    } else if (toolMode == 2 && makingLine == false) {
      point1X = mouseX;
      point1Y = mouseY;
      makingLine = true;
      println(point1X + ", " + point1Y + ", " + mouseX + ", " + mouseY + ", " + " on");
    } else if (toolMode == 3) {
      strokeWeight(thickness);
      stroke(#e5e5e5);
      line(mouse1X, mouse1Y, mouseX, mouseY);
    }
  }
  
  // palette selector.
  if (keyPressed) {
    if (Character.getNumericValue(key) >= 0 && Character.getNumericValue(key) <= palettes.length) {
      if(Character.getNumericValue(key) == 0) {
        for(int i = 0; i < 5; i++) {
          currentPalette[i] = palettes[9][i];
        }
      } else {
        for(int i = 0; i < 5; i++) {
          currentPalette[i] = palettes[Character.getNumericValue(key)-1][i];
        }
      }
    }
    
    if (key == 'r') {
      for(int i = 0; i < currentPalette.length; i++){
        currentPalette[i] = color(random(0, 256), random(0, 256), random(0, 256));
      }
    }
    
    if (key == 'x') {
      background(#e5e5e5);
    }
  }
  
  // store mouse position for brush tool.
  mouse1X = mouseX;
  mouse1Y = mouseY;
}

void mouseReleased() {
  // palette color selector.
  if (mouseX/50 < currentPalette.length && mouseX >= 0 && mouseY >= 0 && mouseY < 100) {
    primary = currentPalette[mouseX/50];
    println(mouseX/50);
  }
  
  // tool button selector.
  if (mouseY >= 20 && mouseY <= 70) {
    if (mouseX >= 450 && mouseX <= 500) {
      toolMode = 1;
    }
    
    if (mouseX >= 505 && mouseX <= 555) {
      toolMode = 2;
    }
    
    if (mouseX >= 560 && mouseX <= 610) {
      toolMode = 3;
    }
    
    if (mouseX > 615 && mouseX <= 665) {
      saveFrame();
    }
  }
  
  // line tool.
  if (toolMode == 2 && makingLine == true) {
    strokeWeight(thickness);
    stroke(primary);
    line(point1X, point1Y, mouseX, mouseY);
    makingLine = false;
  }
  
  /* if (mouseX/100 < palettes.length && mouseY > height-50) {
    palette = palettes[mouseX/100];
    println(mouseX/100);
  } */
}

void mouseWheel(MouseEvent event){
  // control thickness.
  if (keyPressed) {
    if (keyCode == CONTROL) { // while CTRL button is held down, then fine adjustment.
      thickness = constrain(thickness - event.getCount(), 1, 100);
    } else if (keyCode == SHIFT) { // while SHIFT is held down, then coarse adjustment.
      thickness = constrain(thickness - event.getCount() * 10, 1, 100);
    }
  } else { // if nothing else if being held down, then regular adjustment
    thickness = constrain(thickness - event.getCount() * 5, 1, 100);
  }
}
