%{
	#include <stdio.h>
	# include "y.tab.h"
%}
         
digito  [0-9]
letra [_A-Za-z]     
id  {letra}({letra}|{digito})*

%%

"int"              			{return T_INT;}
"char"              			{return T_CHAR;}
"float"               			{return T_FLOAT;}
{id}					{ 
							yylval.s = strdup(yytext); 
							return T_ID;
						}
{digito}+				{
							yylval.i = atoi(yytext);
							return T_NUM;
						}


[-+]?[0-9]*\.?[0-9][0-9]*			{
									yylval.f = atof(yytext);
									return T_NUMFLT;
								}

";"						{return yytext[0];}
[+-/*%()<>"!]   			{ return yytext[0]; }
[']						{return T_QUOT;}
"="						{return  T_AT;}
"**"					{return T_EXP;}
"&&"					{return T_AND;}
"||"					{return T_OR;}
"=="					{return T_EQ;}
"!="					{return T_DIF;}
"<="					{return T_LE;}
">="					{return T_ME;}
\n   					{ return T_EOL; } /* FIm de expressão*/
[ \r\t]					{ /* ignore whitespace */ }
<<EOF>>				{return T_END;}
.      					{ printf("Expressao com caractere invalido: %s\n", yytext);}

%%

int yywrap(void){
	return 1;
}
