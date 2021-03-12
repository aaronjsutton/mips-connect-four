// Header for all libc4 functions
#include <stdio.h>

#define VALUE_PLAYER_1  1
#define VALUE_PLAYER_2  2

#define BORDER_CHAR       '|'
#define EMPTY_CHAR        '_'
#define PLAYER_1_CHAR     '*'
#define PLAYER_2_CHAR     '+'

void welcome();
char token_char(int v);
void render(size_t rows, size_t cols, int b[rows][cols]);
int get_input(size_t cols);
