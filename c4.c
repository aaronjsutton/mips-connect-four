 /* 
  * Connect Four - Reference Implementation
  * Aaron Sutton
  */

#include <stdio.h>
#include <stdbool.h>

// Simply print out a nice welcome message.
void welcome() {
  printf("Welcome to connect-4: C version\n");
  printf("This is a 2 player game, each player will take turns placing a token.\n");
  printf("The objective is to create a line of four consecutive tokens.\n");
  printf("Good luck!\n");
}

int main(int argc, char* argv[]) {
  welcome();

  int board[6][7] = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0},
  };

  return 0;
}
