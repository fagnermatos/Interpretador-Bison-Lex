%{
	#include <stdio.h>
	#include <stdlib.h>
    #include <string.h>
    #include <math.h>
	#include "lib.h"
	void yyerror(char *);
	int yylex(void);
	data *head;
    extern FILE *yyin;
%}

/****
 *
 *  To execute code
 *  bison -d y.y && flex l.l && gcc y.tab.c lex.yy.c -lfl -o a && ./a
 *
 * */

%union {
	int i;
	float f;
	char *s;
}

%token T_EOL T_AND T_OR T_EQ T_DIF T_LE T_ME T_EXP T_END

%token T_QUOT 0

%token <s> T_ID T_FLOAT T_CHAR T_INT
%token <i> T_NUM T_ATTR
%token <f> T_NUMFLT

%type <i> cond
%type <f> op values
%type <s> decl idint idchar idfloat ident charsValue

%right T_AT

%left '+' '-'
%left '*' '/' '%'
%right T_EXP

%left T_AND T_OR T_EQ T_DIF T_LE T_ME
%right '!'

%start code

%%

/**** Start code */
code:
	decl ';' T_EOL code
	| ops ';' T_EOL code
	| attrs ';' T_EOL code
	| conds ';' T_EOL code
	|
	| T_EOL code
    | T_END                     {printVars(head); exit(1);}
	;

/***** Variable declarations */

decl:
    T_INT idint
	| T_CHAR idchar
    | T_FLOAT idfloat
    ;

idint:
    idint ',' T_ID                  { add(head, "int", toString($3));}
    | T_ID                          { add(head, "int", toString($1));}
    ;

idchar:
    idchar ',' T_ID					{ add(head, "char", toString($3));}
    | T_ID							{ add(head, "char", toString($1));}
    ;

idfloat:
    idfloat ',' T_ID				{ add(head, "float", toString($1));}
    | T_ID							{ add(head, "float", toString($1));}
    ;


/**** Math operations */
ops:
	op							{printOp($1);}
	;

op:
	op '+' op					{$$ = $1 + $3;}
	| op '-' op					{$$ = $1 - $3;}
	| op '*' op					{$$ = $1 * $3;}
	| op '/' op					{$$ = $1 / $3;}
	| op T_EXP op				{$$ = powf($1, $3);}
	| op '%' op					{$$ = (int) $1 % (int) $3;}
	| '(' op ')'				{$$ = $2;}
	| T_ID						{$$ = getNumValue(head, $1);}
	| T_NUM						{$$ = $1;}
	| T_NUMFLT					{$$ = $1;}
    ;

/****  ATTRS */

attrs:
	attrCharValues
	| attrValues
	;

attrCharValues:
	ident T_AT charsValue				{attrChar(head, $1, $3);}
	;

attrValues:
	ident T_AT values				{attrNum(head, $1, $3);}
	;

charsValue:
	T_QUOT T_ID  T_QUOT				{$$ = $2;}
    ;

values:
	op							{$$ = $1;}
	;

ident:
    T_ID						{$$ = $1;}
    ;

/**** Conditions expressions */
conds:
	cond                            {printf("%s\n", round($1) ? "True" : "False");}
	;

cond:
    cond T_AND cond				{$$ = $1 && $3;}
    | cond T_OR cond			{$$ = $1 || $3;}
    | cond T_EQ cond            {$$ = $1 == $3;}
    | cond T_DIF cond			{$$ = $1 != $3;}
    | op '<' op					{$$ = $1 < $3;}
    | op '>' op					{$$ = $1 > $3;}
    | op T_LE op				{$$ = $1 <= $3;}
    | op T_ME op				{$$ = $1 >= $3;}
    | op T_AND op				{$$ = $1 && $3;}
    | op T_OR op				{$$ = $1 || $3;}
    | op T_EQ op				{$$ = $1 == $3;}
    | op T_DIF op				{$$ = $1 != $3;}
    | '(' cond ')'			    {$$ = $2;}
    | '!' cond			        {$$ = $2 == 0 ? 1 : 0;}
    ;

%%

void yyerror(char *s) {
	printf("Erro de sintaxe! \n");
}

void main(int argc, char *argv[]) {
    head = malloc(sizeof(struct cell));
    yyin = fopen(argv[1], "r");
    yyparse();
}
