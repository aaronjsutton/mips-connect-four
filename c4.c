 /* 
  * Connect Four - Reference Implementation
  * Driver Program
  * Aaron Sutton
  */

#include <stdio.h>
#include <stdbool.h>

#include "libc4.h"

// These will be constant values for the duration of the game.
#define B_WIDTH   6
#define B_LENGTH  7

int main(int argc, char* argv[]) {
  welcome();
  
  // Initialize board.
  int board[B_WIDTH][B_LENGTH] = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0},
  };

  render(B_WIDTH, B_LENGTH, board);
  int c = get_input(B_WIDTH);

  return 0;
}

