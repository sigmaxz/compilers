	#include <string.h>
LETTER [a-zA-Z]+
DIGIT [0-9]+
NUMBER {DIGIT}+
NN {DIGIT}+{LETTER}
IDE {LETTER}+((_|{LETTER}|{DIGIT})*({LETTER}|{DIGIT})+)*
COMMENT "##".*\n
SPACE " "
	int num_line = 0, col = 0; 
%%
program printf("PROGRAM\n"); col += strlen(yytext);
beginprogram printf("BEGIN_PROGRAM\n"); col += strlen(yytext);
endprogram printf("END_PROGRAM\n");col += strlen(yytext);
integer printf("INTEGER\n");col += strlen(yytext);
array printf("ARRAY\n");col += strlen(yytext);
of printf("OF\n");col += strlen(yytext);
if printf("IF\n");col += strlen(yytext);
then printf("THEN\n");col += strlen(yytext);
endif printf("ENDIF\n");col += strlen(yytext);
else printf("ELSE\n");col += strlen(yytext);
elseif printf("ELSEIF\n");col += strlen(yytext);
while printf("WHILE\n");col += strlen(yytext);
do printf("DO\n");col += strlen(yytext);
beginloop printf("BEGINLOOP\n");col += strlen(yytext);
endloop printf("ENDLOOP\n");col += strlen(yytext);
break printf("BREAK\n"); col += strlen(yytext);
continue printf("CONTINUE\n");col += strlen(yytext);
exit printf("EXIT\n");col += strlen(yytext);
read printf("READ\n");col += strlen(yytext);
write printf("WRITE\n");col += strlen(yytext);
and printf("AND\n");col += strlen(yytext);
or printf("OR\n");col += strlen(yytext);
not printf("NOT\n");col += strlen(yytext);
true printf("TRUE\n");col += strlen(yytext);
false printf("FALSE\n");col += strlen(yytext);
\+ printf("ADD\n");col += strlen(yytext);
\- printf("SUB\n");col += strlen(yytext);
\* printf("MULT\n");col += strlen(yytext);
\/ printf("DIV\n");col += strlen(yytext);
\% printf("MOD\n");col += strlen(yytext);
== printf("EQ\n");col += strlen(yytext);
\<\> printf("NEQ\n");col += strlen(yytext);
\< printf("LT\n");col += strlen(yytext);
\> printf("GT\n");col += strlen(yytext);
\<= printf("LTE\n");col += strlen(yytext);
\>= printf("GTE\n");col += strlen(yytext);
{IDE} printf("IDENT %s\n", yytext);col += strlen(yytext);
{NUMBER} printf("NUMBER %s\n", yytext);col += strlen(yytext);
; printf("SEMICOLON\n");col += strlen(yytext);
: printf("COLON\n");col += strlen(yytext);
, printf("COMMA\n");col += strlen(yytext);
\? printf("QUESTION\n");col += strlen(yytext);
\[ printf("L_BRACKET\n");col += strlen(yytext);
\] printf("R_BRACKET\n");col += strlen(yytext);
\( printf("L_PAREN\n");col += strlen(yytext);
\) printf("R_PAREN\n");col += strlen(yytext);
:= printf("ASSIGN\n");col += strlen(yytext);
\n num_line++; col  = 0;
{COMMENT} /* do nothing*/
{SPACE} col++;
\t col++;
{IDE}"_" printf("Error at line %i, column %i: Identifier \"%s\" must not end with \"_\"\n", num_line, col, yytext); exit(0);
"_"{IDE} printf("Error at line %i, column %i: Identifier \"%s\" must begin with letter\n", num_line, col, yytext); exit(0);
{NN} printf("Error at line %i, column %i: Identifier \"%s\" must begin with letter\n", num_line, col, yytext); exit(0);
. printf("Error at line %i, column %i: unrecognized symbol %s\n", num_line, col, yytext); exit(0);

%%
main()
{
  yylex();
}
