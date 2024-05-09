%{
#include <stdio.h>
#include <stdlib.h>

int nodeCounter = 0;

void yyerror(const char *s);
int yylex();
%}

%union {
    int num;        // For NUMBER token
    char* id;       // For ID token
}

%token PRINTFF ADD MULTIPLY DIVIDE SUBTRACT UNARY LPAREN RPAREN
%token <num> NUMBER
%token <id> ID
%type <num> E T F E_prime T_prime

%start E

%%

E : T                      { printf("%d [label=\"E\"];\n", ++nodeCounter); }
    E_prime                { printf("%d -> %d [label=\"E_prime\"];\n", nodeCounter - 1, $1); }
  ;

E_prime : ADD T E_prime     { printf("%d [label=\"+\"];\n", ++nodeCounter); }
        | /* Empty */        { $$ = -1; }
        ;

T : F                      { printf("%d [label=\"T\"];\n", ++nodeCounter); }
    T_prime                { printf("%d -> %d [label=\"T_prime\"];\n", nodeCounter - 1, $1); }
  ;

T_prime : MULTIPLY F T_prime { printf("%d [label=\"*\"];\n", ++nodeCounter); }
        | /* Empty */         { $$ = -1; }
        ;

F : LPAREN E RPAREN        { printf("%d [label=\"()\"];\n", ++nodeCounter); }
  | ID                      { printf("%d [label=\"ID: %s\"];\n", ++nodeCounter, $1); }
  | NUMBER                  { printf("%d [label=\"NUMBER: %d\"];\n", ++nodeCounter, $1); }
  ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
    printf("digraph ParseTree {\n");
    yyparse();
    printf("}\n");
    return 0;
}
