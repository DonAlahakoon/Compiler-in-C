%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void yyerror(const char *s);
int yylex();


// Symbol table entry structure
struct dataType {
    char *id_name;
    char *data_type;
    char *type;
    int line_no;
} symbol_table[40];

int count = 0;
char type[10]; // Temporary storage for data type

// Function prototypes
void add(char);
void insert_type();
int search(char *);

%}

%token VOID CHARACTER PRINTFF SCANFF INT FLOAT CHAR FOR IF ELSE TRUE FALSE NUMBER FLOAT_NUM ID LE GE EQ NE GT LT AND OR STR ADD MULTIPLY DIVIDE SUBTRACT UNARY INCLUDE RETURN

%left '+' '-'
%left '*' '/'
%right UNARY

%%


%%

int main() {
    yyparse();

    // Printing the symbol table
    printf("\n\n");
    printf("\t\t\t\t\t\t\t\t PHASE 1: LEXICAL ANALYSIS \n\n");
    printf("\nSYMBOL   DATATYPE   TYPE   LINE NUMBER \n");
    printf("_______________________________________\n\n");

    for (int i = 0; i < count; i++) {
        printf("%s\t%s\t%s\t%d\n", symbol_table[i].id_name, symbol_table[i].data_type, symbol_table[i].type, symbol_table[i].line_no);
        free(symbol_table[i].id_name);
        free(symbol_table[i].data_type);
        free(symbol_table[i].type);
    }
    printf("\n\n");

    return 0;
}

// Function to search for an identifier in the symbol table
int search(char *id) {
    for (int i = count - 1; i >= 0; i--) {
        if (strcmp(symbol_table[i].id_name, id) == 0) {
            return -1; // Found
        }
    }
    return 0; // Not found
}

// Function to add an entry to the symbol table based on the token type
void add(char c) {
    int found = search(yytext);
    if (!found) {
        symbol_table[count].id_name = strdup(yytext);
        if (c == 'H') {
            symbol_table[count].data_type = strdup(type);
            symbol_table[count].type = strdup("Header");
        } else if (c == 'F') {
            symbol_table[count].data_type = strdup(type);
            symbol_table[count].type = strdup("Function");
        } else if (c == 'K') {
            symbol_table[count].data_type = strdup("N/A");
            symbol_table[count].type = strdup("Keyword");
        } else if (c == 'V') {
            symbol_table[count].data_type = strdup(type);
            symbol_table[count].type = strdup("Variable");
        } else if (c == 'C') {
            symbol_table[count].data_type = strdup("CONST");
            symbol_table[count].type = strdup("Constant");
        }
        symbol_table[count].line_no = countn;
        count++;
    }
}

// Function to insert data type into temporary storage
void insert_type() {
    strcpy(type, yytext);
}

// Error handler function
void yyerror(const char *msg) {
    fprintf(stderr, "%s\n", msg);
}

