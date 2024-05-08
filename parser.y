%{
void yyerror (char *s);
int yylex();
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>

int symbols[52];// 26 for lowercase letters, 26 for uppercase letters
// Function prototypes for symbol table operations
int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val);
%}

/* Yacc definitions */
%token  VOID CHARACTER PRINTFF SCANFF INT FLOAT CHAR FOR IF ELSE TRUE FALSE FLOAT_NUM LE GE EQ NE GT LT AND OR STR ADD MULTIPLY DIVIDE SUBTRACT UNARY INCLUDE RETURN LPAREN RPAREN
%union {int num; char id;}         
%start E
%token <num> NUMBER
%token <id> ID
%type <num> E T F E_prime T_prime


%%

	E	:	T E_prime			{printf("Executing rule 1 \n");$$ = $1;}
		|	PRINTFF	E			{printf("Printing %d \n",$2);}
		;
	
	E_prime	:	ADD T E_prime			{printf("Executing rule 2 \n");$$ = $2 + $3;}
		|	/* Empty production for E' */	{ /* Do nothing for empty production */ }
		;
		
	T	:	F T_prime			{printf("Executing rule 3 \n");$$ = $1;}
		;
	
	T_prime	:	MULTIPLY F T_prime		{printf("Executing rule 4 \n");$$ = $2 * $3;}
		|	/* Empty production for E' */	{ /* Do nothing for empty production */ }
		;
	
	F	:	LPAREN E RPAREN			{printf("Executing rule 5 \n");$$ = $2;}
		|	ID				{printf("Executing rule 52 \n");$$ = symbolVal($1);}
		|	NUMBER				{printf("Executing rule 53 \n");$$ = symbolVal($1);}
		;
			



%%                     /* C code */

int computeSymbolIndex(char token)
{
	int idx = -1;
	if(islower(token)) {
		idx = token - 'a' + 26;
	} else if(isupper(token)) {
		idx = token - 'A';
	}
	return idx;
} 

/* returns the value of a given symbol */
int symbolVal(char symbol)
{
	int bucket = computeSymbolIndex(symbol);
	return symbols[bucket];
}

/* updates the value of a given symbol */
void updateSymbolVal(char symbol, int val)
{
	int bucket = computeSymbolIndex(symbol);
	symbols[bucket] = val;
}

int main (void) {
	/* init symbol table */
	int i;
	for(i=0; i<52; i++) {
		symbols[i] = 0;
	}

	return yyparse ( );
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 
