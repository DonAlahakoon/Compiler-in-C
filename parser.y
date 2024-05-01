%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include "lex.yy.c"

void yyerror(const char *s);
int yylex();
int yywrap();
%}

%token VOID CHARACTER PRINTFF SCANFF INT FLOAT CHAR FOR IF ELSE TRUE FALSE NUMBER FLOAT_NUM ID LE GE EQ NE GT LT AND OR STR ADD MULTIPLY DIVIDE SUBTRACT UNARY INCLUDE RETURN

%left '+' '-'
%left '*' '/'

%%
program: headers main_func
;

headers: /* empty */
       | headers INCLUDE
       ;

main_func: datatype ID '(' ')' '{' body return_statement '}'
         ;

datatype: INT
        | FLOAT
        | CHAR
        | VOID
        ;

body: /* empty */
    | body statement
    | body PRINTFF '(' STR ')' ';'
    | body SCANFF '(' STR ',' '&' ID ')' ';'
    | body IF '(' condition ')' '{' body '}'
    | body IF '(' condition ')' '{' body '}' ELSE '{' body '}'
    | body FOR '(' statement ';' condition ';' statement ')' '{' body '}'
    ;

statement: datatype ID init ';'
          | ID '=' expression ';'
          | ID relop expression ';'
          | ID UNARY ';'
          | UNARY ID ';'
          ;

init: '=' value
    | /* empty */
    ;

expression: expression '+' expression
          | expression '-' expression
          | expression '*' expression
          | expression '/' expression
          | value
          ;

condition: value relop value
         | TRUE
         | FALSE
         ;

return_statement: RETURN value ';'
                | RETURN ';'
                ;

value: NUMBER
     | FLOAT_NUM
     | CHARACTER
     | ID
     ;

relop: LE
     | GE
     | EQ
     | NE
     | GT
     | LT
     ;

%%
int main() {
    yyparse();
    return 0;
}

void yyerror(const char *msg) {
    fprintf(stderr, "Error: %s\n", msg);
}

