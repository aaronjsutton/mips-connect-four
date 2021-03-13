// Header for all libc4 functions
#include <stdio.h>
#include <stdbool.h>

#define VALUE_PLAYER_1  1
#define VALUE_PLAYER_2  2

#define BORDER_CHAR       '|'
#define EMPTY_CHAR        '_'
#define PLAYER_1_CHAR     '*'
#define PLAYER_2_CHAR     '+'

void welcome();
void render(size_t rows, size_t cols, int b[rows][cols]);
int get_input(size_t cols, int player);

int drop_token(size_t rows, size_t cols, int b[rows][cols], int col);
bool winning_pattern(size_t rows, size_t cols, int b[rows][cols], int row, int col);
