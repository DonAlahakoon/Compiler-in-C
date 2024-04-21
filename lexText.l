/* Auxillary declarations starts here */
%{
        #include <stdio.h>
        #include <stdlib.h>
%}

/* Regular expressions */
number [0-9]+
op     [-+*/=]
letter [A-Za-z]
id     {letter}({letter}|{number})*

/* Translation rules */
%%
{number} {printf("<number,%d>\n", atoi(yytext));}
{op} {printf("<op,%s>\n",yytext);}
{id} {printf("<id, %s>\n",yytext);}

[\t \n]  ;  // Ignore whitespace and newline characters

.        { printf("Error: Unrecognized character '%s'\n", yytext); }

%%

/* Auxiliary functions */
int yywrap() {
    return 1;  // Always indicate end of input
}
int main()
{
        printf("Enter text to tokenize (Ctrl+D to end):\n");

        // Set yyin to stdin (standard input)
         yyin = stdin;

        // Call yylex to start tokenizing from user input
        yylex();
        return 0;
}
