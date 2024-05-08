/* Auxillary declarations starts here */
%{
	#include "y.tab.h"
    
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
"scanf"                     {  return SCANFF; }
"int"                       {  return INT; }
"float"                     {  return FLOAT; }
"char"                      {  return CHAR; }
"void"                      {  return VOID; }
"return"                    {  return RETURN; }
"for"	                    {  return FOR; }
"if"	                    {  return IF; }
"else"	                    {  return ELSE; }
^"#include"[ ]*<.+\.h>      {  return INCLUDE; }
"true"                      {  return TRUE; }
"false"                     {  return FALSE; }
[-]?{digit}+                {  return NUMBER; }
[-]?{digit}+\.{digit}{1,6}  {  return FLOAT_NUM; }
{letter}				 { yylval.id = yytext[0]; return ID; }
{unary}                     {  return UNARY; }
"<="                        {  return LE; }
">="                        {  return GE; }
"=="                        {  return EQ; }
"!="                        {  return NE; }
">"	                        {  return GT; }
"<"	                        {  return LT; }
"&&"	                    {  return AND; }
"||"	                    {  return OR; }
"+"                         {  return ADD; }
"-"                         {  return SUBTRACT; }
"/"                         {  return DIVIDE; }
"*"                         {  return MULTIPLY; }
"("                         { return LPAREN;}
")"                         {return RPAREN;}
\/\/.*                      { ; } 					/* Handle the single line comments */
\/\*(.*\n)*.*\*\/           { ; } 					/* Handle the multi line comments*/
[ \t]*                      { ; }
[\n]                        { countn++; }
.	                        { return *yytext; }			/* Handles all other symbols */
["].*["]                    {  return STR; }
['].[']                     {  return CHARACTER; }

%%

/* Auxiliary functions */
int yywrap() {
    return 1;  // Always indicate end of input
}


