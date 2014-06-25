class HScrollbar 
{
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;

  HScrollbar (float xp, float yp, int sw, int sh, int l)
  {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
  }

  void update() {
    if (overEvent()) 
    {
      over = true;
    } 
    
    else 
    {
      over = false;
    }
    
    if (mousePressed && over) 
    {
      locked = true;
    }
    if (!mousePressed) 
    {
      locked = false;
    }
    if (locked) 
    {
      newspos = constrain(mouseX, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 1) 
    {
      spos = spos + (newspos-spos)/loose;
    }
  }

  float constrain(float val, float minv, float maxv) 
  {
    return min(max(val, minv), maxv);
  }

  boolean overEvent() 
  {
    if (mouseX > spos-16 && mouseX < spos+16 &&
       mouseY > ypos-16 && mouseY < ypos+16) {
      return true;
    } 
    else 
    {
      return false;
    }
  }

  void display() 
  {
    noStroke();
    fill(17, 131, 141);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) 
    {
      fill(0, 208, 225);
    } 
    else 
    {
      fill(0, 79, 86);
    }
    ellipse(spos, ypos, 16, 16);
  }

  float getPos() 
  {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }
}

