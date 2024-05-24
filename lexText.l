/* Auxillary declarations starts here */
%{
	#include "y.tab.h"
	void yyerror (char *s);
	int yylex();
    
    	 int countn=0;       /* for keeping track of the line number */
%}

/* Regular expressions */
%option yylineno

digit [0-9]
letter [A-Za-z]
id     {letter}({letter}|{digit})*
unary "++"|"--"

/* Translation rules */
%%


"printf"                    {  return PRINTFF; }
[-]?{digit}+                { yylval.num = atoi(yytext); return NUMBER; }
{letter} 	{ yylval.id = (char*)malloc(2); strncpy(yylval.id, yytext, 1); yylval.id[1] = '\0'; return ID; }
{unary}                     {  return UNARY; }
"+"                         {  return ADD; }
"-"                         {  return SUBTRACT; }
"/"                         {  return DIVIDE; }
"*"                         {  return MULTIPLY; }
"("                         { return LPAREN;}
")"                         { return RPAREN;}
\/\/.*                      { ; } 					/* Handle the single line comments */
\/\*(.*\n)*.*\*\/           { ; } 					/* Handle the multi line comments*/
[ \t]*                      { ; }
[\n]                        { countn++; }
.	                        { ECHO; yyerror ("unexpected character"); }			/* Handles all other symbols */

%%

/* Auxiliary functions */
int yywrap() {
    return 1;  // Always indicate end of input
}

