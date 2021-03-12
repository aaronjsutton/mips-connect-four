/* 
* Connect Four - Reference Implementation
* Main Library
* Aaron Sutton
*/

#include "libc4.h"

// Simply print out a nice welcome message.
void welcome() {
  printf("Welcome to connect-4: C version\n");
  printf("This is a 2 player game, each player will take turns placing a token.\n");
  printf("The objective is to create a line of four consecutive tokens.\n");
  printf("Good luck!\n"); 
}

// Match a board value to it's relevant token character.
char token_char(int v) {
  switch (v) {
    case VALUE_PLAYER_1: 
      return PLAYER_1_CHAR;
    case VALUE_PLAYER_2:
      return PLAYER_2_CHAR;
    default:
      return EMPTY_CHAR;
  }
}

// Render the board out to a string on the command line.
void render(size_t rows, size_t cols, int b[rows][cols]) {

  // Print header column indices.
  printf(" ");
  for (int h = 0; h < cols; h++) {
    printf("%d ", h);
  }

  printf("\n");

  // Print board body.
  for (int i = 0; i < rows; i++) {
    printf("%c", BORDER_CHAR);
    for (int k = 0; k < cols; k++) {
      printf("%c%c", token_char(b[i][k]), BORDER_CHAR);
    }
    printf("\n");
  }
}

// Prompt for input and return selected col.
int get_input(size_t cols) {
  int n;
  printf("\nEnter column [0-%zu] -> ", cols);
  scanf("%d", &n);
  return n;
}

void drop_token(int col) {

}
