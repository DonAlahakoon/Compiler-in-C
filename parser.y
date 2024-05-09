%{

#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <stdarg.h>
#include <ctype.h>
#include <string.h>

typedef struct Node {
    char* type;              // Type of the node (e.g., "E", "T", "F", "+", "NUMBER", "ID")
    int num_children;        // Number of child nodes
    struct Node** children;  // Array of pointers to child nodes
}Node;
#include "lex.yy.c"




void yyerror (char *s);
int yylex();

int symbols[52];// 26 for lowercase letters, 26 for uppercase letters
// Function prototypes for symbol table operations
int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val);



Node* createNode(char* type, int num_children, ...);
Node* createLeafNode(void* data);
void printParseTree(Node* node, int level);
Node* rootNode = NULL;


%}

/* Yacc definitions */

%token  PRINTFF ADD MULTIPLY DIVIDE SUBTRACT UNARY LPAREN RPAREN
%union {
    int num;        // For NUMBER token
    char* id;       // For ID token
    Node* node;     // For non-terminal nodes in the parse tree
}       

%token <num> NUMBER
%token <id> ID
%type <node> E T F E_prime T_prime

%start E
%%

	E	:	T E_prime			{$$ = createNode("E", 2, $1, $2);}
		|	PRINTFF	E			{$$ = createNode("PRINTFF", 1, $2);}
		;
	
	E_prime	:	ADD T E_prime			{$$ = createNode("+", 2, $2, $3);}
		|	/* Empty production for E' */	{ $$ = NULL;}
		;
		
	T	:	F T_prime			{$$ = createNode("T", 2, $1, $2);}
		;
	
	T_prime	:	MULTIPLY F T_prime		{$$ = createNode("*", 2, $2, $3);}
		|	/* Empty production for T' */	{ $$ = NULL;}
		;
	
	F	:	LPAREN E RPAREN			{$$ = createNode("()", 1, $2);}
		|	ID				{$$ = createNode("ID", 1, createLeafNode($1));}
		|	NUMBER				{
                                int* num = (int*)malloc(sizeof(int));
                                *num = $1;
                                $$ = createNode("NUMBER", 1, createLeafNode(num));
                            }

		;
			



%%                     /* C code */


Node* createNode(char* type, int num_children, ...) {
    Node* node = (Node*)malloc(sizeof(Node));
    node->type = strdup(type);
    node->num_children = num_children;
    node->children = (Node**)malloc(num_children * sizeof(Node*));

    va_list args;
    va_start(args, num_children);
    for (int i = 0; i < num_children; i++) {
        node->children[i] = va_arg(args, Node*);
    }
    va_end(args);

    return node;
}

Node* createLeafNode(void* data) {
    Node* leaf = (Node*)malloc(sizeof(Node));
    leaf->type = (char*)data;
    leaf->num_children = 0;
    leaf->children = NULL;
    return leaf;
}
void printParseTree(Node* node, int level) {
    if (node == NULL) {
        return;
    }

    for (int i = 0; i < level; i++) {
        printf("  ");
    }
    printf("%s\n", node->type);

    for (int i = 0; i < node->num_children; i++) {
        printParseTree(node->children[i], level + 1);
    }
}
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

	yyparse ( );
	
	if (rootNode != NULL) {
        printf("Parse Tree:\n");
        printParseTree(rootNode, 0);
    }
    	
    	return 0;
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 