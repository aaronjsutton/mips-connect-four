  /* 
  * Connect Four - Reference Implementation
  * Driver Program
  * Aaron Sutton
  */

#include <stdio.h>
#include <stdbool.h>

#include "libc4.h"

// These will be constant values for the duration of the game.
#define B_COLS   7
#define B_ROWS   6

int main(int argc, char* argv[]) {
  welcome();
  
  // Initialize board.
  int board[B_ROWS][B_COLS] = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0},
  };

  render(B_ROWS, B_COLS, board);
  
  int player = 1;
  while (true) {
    
    int c = get_input(B_ROWS, player);
    int r = drop_token(B_ROWS, B_COLS, board, c);
    board[r][c] = player == 1 ? VALUE_PLAYER_1 : VALUE_PLAYER_2;

    render(B_ROWS, B_COLS, board);

    if (winning_pattern(B_ROWS, B_COLS, board, r, c)) {
      printf("Player %d wins!\n", player);
      break;
    }

    player = player == 1 ? 2 : 1;
  }

  return 0;
}

