	#include <string>
	#include "heading.h"
	#include "tok.h"
LETTER [a-zA-Z]+
DIGIT [0-9]+
NUMBER {DIGIT}+
NN {DIGIT}+{LETTER}
IDE {LETTER}+((_|{LETTER}|{DIGIT})*({LETTER}|{DIGIT})+)*
COMMENT "##".*\n
SPACE " "
	int num_line = 0, col = 0; 
%%
program 	col += strlen(yytext); return PROGRAM;
beginprogram 	col += strlen(yytext); return BEGIN_PROGRAM;
endprogram      col += strlen(yytext); return END_PROGRAM;
integer 	col += strlen(yytext); return INTEGER;
array 		col += strlen(yytext); return ARRAY;
of 		col += strlen(yytext); return OF;
if 		col += strlen(yytext); return IF;
then 		col += strlen(yytext); return THEN;
endif 		col += strlen(yytext); return ENDIF;
else 		col += strlen(yytext); return ELSE;
elseif 		col += strlen(yytext); return ELSEIF;
while 		col += strlen(yytext);  return WHILE;
do 		col += strlen(yytext); return DO;
beginloop 	col += strlen(yytext); return BEGINLOOP;
endloop 	col += strlen(yytext); return ENDLOOP;
break 		col += strlen(yytext); return BREAK;
continue 	col += strlen(yytext); return CONTINUE;
exit 		col += strlen(yytext); return EXIT;
read 		col += strlen(yytext); return READ;
write 		col += strlen(yytext); return WRITE;
and 		col += strlen(yytext); return AND;
or 		col += strlen(yytext); return OR;
not 		col += strlen(yytext); return NOT;
true 		col += strlen(yytext); return TRUE;
false 		col += strlen(yytext); return FALSE;
\+ 		col += strlen(yytext); return ADD;
\- 		col += strlen(yytext); return SUB;
\* 		col += strlen(yytext); return MULT;
\/ 		col += strlen(yytext); return DIV;
\% 		col += strlen(yytext); return MOD;
== 		col += strlen(yytext); return EQ;
\<\> 		col += strlen(yytext); return NEQ;
\< 		col += strlen(yytext); return LT;
\> 		col += strlen(yytext); return GT;
\<= 		col += strlen(yytext); return LTE;
\>= 		col += strlen(yytext); return GTE;
{IDE} 		col += strlen(yytext); yylval.str_val = yytext; return IDENT;
{NUMBER} 	col += strlen(yytext); yylval.int_val = atoi(yytext); return NUMBER;
; 		col += strlen(yytext); return SEMICOLON;
: 		col += strlen(yytext); return COLON;
, 		col += strlen(yytext); return COMMA;
\? 		col += strlen(yytext); return QUESTION;
\[ 		col += strlen(yytext); return L_BRACKET;
\] 		col += strlen(yytext); return R_BRACKET;
\(		col += strlen(yytext); return L_PAREN;
\) 		col += strlen(yytext); return R_PAREN;
:= 		col += strlen(yytext); return ASSIGN;
\n num_line++; col  = 0;
{COMMENT} num_line++; col =0; 
{SPACE} col++;
\t col++;
{IDE}"_" printf("Error at line %i, column %i: Identifier \"%s\" must not end with \"_\"\n", num_line, col, yytext); //exit(0);
"_"{IDE} printf("Error at line %i, column %i: Identifier \"%s\" must begin with letter\n", num_line, col, yytext); //exit(0);
{NN} printf("Error at line %i, column %i: Identifier \"%s\" must begin with letter\n", num_line, col, yytext); //exit(0);
. printf("Error at line %i, column %i: unrecognized symbol %s\n", num_line, col, yytext); //exit(0);
