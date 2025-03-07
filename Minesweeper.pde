import de.bezier.guido.*;
public boolean isLost = false;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int r = 0; r < NUM_ROWS ; r++){
      for(int c = 0; c< NUM_COLS; c++){
        buttons[r][c] = new MSButton(r,c);
      }
    }

    
    setMines();
}

public void setMines()
{
   int totalMines = (NUM_ROWS * NUM_COLS) / 6;
   while (mines.size() < totalMines) {
   int r = (int)(Math.random()*NUM_ROWS);
   int c = (int)(Math.random()*NUM_COLS);
   if(!mines.contains(buttons[r][c])){
     mines.add(buttons[r][c]);
   }
}
}
public void draw ()
{
    background( 0 );
    
    fill(255);
}
public boolean isWon()
{
 for (int r = 0; r < NUM_ROWS; r++) {
 for (int c = 0; c < NUM_COLS; c++) {
  if (!mines.contains(buttons[r][c]) && !buttons[r][c].clicked) {
   return false;
     }
    }
    }
    return true;
}
public void displayLosingMessage()
{
   text("GAME OVER!",200,200);
}
public void displayWinningMessage()
{
    text("YOU WIN!",200,200);
}
public boolean isValid(int r, int c)
{
    return(r<NUM_ROWS && r>=0 && c<NUM_COLS && c>=0);
}
public int countMines(int row, int col)
{
  int numMines = 0;
  for(int r = row-1; r <= row + 1; r++){
  for(int c = col-1; c <= col+1; c++){
      if (isValid(r, c) && mines.contains(buttons[r][c]) && !(r == row && c == col)) {
        numMines++;
      }
    }
  }
  return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
      if(mouseButton == RIGHT){
      flagged = !flagged;
      if(!flagged){
       clicked = false;
          }
        }
        else if (!flagged) {
          clicked = true;
         if (mines.contains(this)) {
          isLost = true;
          for (MSButton mine : mines) {
        mine.clicked = true;
                }
            }
 else if (countMines(myRow, myCol) > 0) {
                setLabel(countMines(myRow, myCol));
  }
 else {
for (int r = myRow - 1; r <= myRow + 1; r++) {
for (int c = myCol - 1; c <= myCol + 1; c++) {
 if (isValid(r, c) && !buttons[r][c].clicked) {
  buttons[r][c].mousePressed();
    }
}  }
 }
        }
    }
    public void draw () 
    {   
        if (flagged)
            fill(0);
         else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else
            fill( 100 );
        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
        if(isWon()){
          fill(255,0,0);
          displayWinningMessage();
        }
        else if(isLost){
          fill(255,0,0);
          displayLosingMessage();
        }
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
