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
  
  int player = 1;
  while (true) {
    
    int c = get_input(B_WIDTH, player);
    int r = drop_token(B_WIDTH, B_LENGTH, board, c);
    board[r][c] = player == 1 ? VALUE_PLAYER_1 : VALUE_PLAYER_2;

    render(B_WIDTH, B_LENGTH, board);

    if (winning_pattern(B_WIDTH, B_LENGTH, board, r, c)) {
      printf("Player %d wins!\n", player);
      break;
    }

    player = player == 1 ? 2 : 1;
  }

  return 0;
}

