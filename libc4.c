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
int get_input(size_t cols, int player) {
  int n;
  printf("\n[%c] Enter column [0-%zu] -> ", token_char(player), cols);
  scanf("%d", &n);
  return n;
}

int drop_token(size_t rows, size_t cols, int b[rows][cols], int col) {
  for (int i = rows - 1; i >= 0; i--) {
    if (b[i][col] == 0) {
      return i;
    }
  }
  return -1;
}

bool winning_pattern(size_t rows, size_t cols, int b[rows][cols], int row, int col) {
  int winning_value = b[row][col];

  // Horizontal pattern
  int s = 1;
  int curr_col = col;

  // track right and find as many winning tokens as possible.
  while ((curr_col >= 0 && curr_col < cols) && b[row][curr_col + 1] == winning_value) {
    curr_col++;
    s++;
  }

  // Track left and find as many winning tokens as possible.
  while ((curr_col >= 0 && curr_col < cols) && b[row][curr_col - 1] == winning_value) {
    curr_col--;
    s++;
  }

  if (s >= 4) { return true; } else
   
  // Vertical pattern
  s = 1;
  int curr_row = row;

  // Track down and find as many winning tokens as possible.
  // There is no case where tracking up should be needed, since the token is
  // always at the top.
  while ((curr_row >= 0 && curr_row < rows) && b[curr_row + 1][col] == winning_value) {
    curr_row++;
    s++;
  }

  if (s >= 4) { return true; }
  
  // Diagonal pattern
  s = 1;
  curr_row = row;
  curr_col = col;

  // Track SE
  // r- c+
  while ((curr_row >= 0) && (curr_col < cols) && b[curr_row - 1][curr_col + 1] == winning_value) {
    curr_row--;
    curr_col++;
    s++;
  }
  
  // r+ c- 
  while ((curr_row < rows) && (curr_col >= 0) && b[curr_row + 1][curr_col - 1] == winning_value) {
    curr_row++;
    curr_col--;
    s++;
  }

  if (s >= 4) { return true; }
  
  s = 1;
  curr_row = row;
  curr_col = col;
  
  // r+ c+
  while ((curr_row < rows) && (curr_col < cols) && b[curr_row + 1][curr_col + 1] == winning_value) {
    curr_row--;
    curr_col--;
    s++;
  }
  
  // r- c- 
  while ((curr_row >= 0) && (curr_col >= 0) && b[curr_row - 1][curr_col - 1] == winning_value) {
    curr_row--;
    curr_col--;
    s++;
  }

  if (s >= 4) { return true; } else { return false; }
}

