/* Mini_l bison spec*/
/* Samuel Villarreal*/

%{
#include "heading.h"
int yyerror(char *s);
int yylex(void);
%}

%union{
	int int_val;
	char* str_val;
}

%start Program 
%token <str_val> IDENT "identifier"
%token <int_val> NUMBER "number"
%token PROGRAM "program" BEGIN_PROGRAM "begin_program" END_PROGRAM "end_program" 
%token INTEGER "integer" ARRAY "array" OF "of"
%token IF "if" THEN "then" ENDIF "endif" ELSE "else" ELSEIF "elseif" WHILE "while" DO "do" BEGINLOOP "beginloop" ENDLOOP "endloop" BREAK "break"
%token CONTINUE "continue" EXIT "exit" READ "read" WRITE "write"
%token AND "and" OR "or" 
%left AND OR
%token TRUE "true" FALSE "false"
%token NOT "not" ASSIGN "assign"
%right NOT ASSIGN
%token ADD "+" SUB "-" MULT "*" DIV "/" MOD "%"
%left ADD SUB MULT DIV MOD
%token EQ "==" NEQ "<>" LT "<" GT ">" LTE "<=" GTE ">="
%left EQ NEQ LT GT LTE GTE
%token SEMICOLON ";" COMMA ","
%token L_BRACKET "[" R_BRACKET "]" L_PAREN "(" R_PAREN ")" QUESTION "?" COLON ":"
%left L_BRACKET R_BRACKET L_PAREN R_PAREN QUESTION COLON
%error-verbose

%%
/* rules for the grammar/ */
Program:
	program identifier semi Block endprogram{
	printf( "Program -> program identifier ; Block endprogram\n" )}
	|
	error identifier semi Block endprogram
	|
	program error semi Block endprogram
	|
	program identifier error Block endprogram
	|
	program identifier semi error endprogram
	|
	program identifier semi Block error
	
;

Block:
	Declarations beginprogram Statements{
	printf( "Block -> Declarations semi beginprogram Statements\n")}
	|
	Declarations error Statements
	|
	Declarations beginprogram error
;

Declarations:
	Declaration semi{
	printf( "Declarations -> Declaration ;\n")}
	|
	Declaration semi Declarations{
	printf("Declarations -> Declaration , Declarations\n")}
	|
	Declaration error
	
;

Statements:
	Statement semi{
	printf( "Statments -> Statement ;\n")}
	|
	Statement semi Statements{
	printf("Statements -> Statement , Statements\n")}
	|
	Statement error
;

Declaration:
	Identifiers colon int{
	printf("Declaration -> Identifiers : int\n")}
	|
	Identifiers colon array l_brac number r_brac of int{
	printf("Declaration -> Identifiers : array [ number ] of int\n")}
	|
	Identifiers error int
	|
	Identifiers error array l_brac number r_brac of int
	|
	Identifiers colon error l_brac number r_brac of int
	|
	Identifiers colon array error number r_brac of int
	|
	Identifiers colon array l_brac error r_brac of int
	|
	Identifiers colon array l_brac number error of int
	|
	Identifiers colon array l_brac number r_brac error int
	|
	Identifiers colon array l_brac number r_brac of error
	
;

Identifiers:
	identifier{
	printf("Identifiers -> identifier\n")}
	|
	identifier comma Identifiers{
	printf("Identifiers -> identifier , Identifiers")}
	|
	identifier comma error
;


Statement:
	Statement1{
	printf("Statement -> Statement1\n")}
	|
	Statement2{
	printf("Statement -> Statement2\n")}
	|
	Statement3{
	printf("Statement -> Statement3\n")}
	|
	Statement4{
	printf("Statement -> Statement4\n")}
	|
	Statement5{
	printf("Statement -> Statement5\n")}
	|
	Statement6{
	printf("Statement -> Statement6\n")}
	|
	Statement7{
	printf("Statement -> Statement7\n")}
;

Statement1:
	Var assign Expression{
	printf("Statement1 -> Var := Expression\n")}
	|
	Var assign Bool_Exp question Expression colon Expression{
	printf("Statement1 -> Var := Bool_Exp ? Expression : Expression\n")}
	|
	error assign Expression
	|
	error assign Bool_Exp question Expression colon Expression
	|
	Var error Expression
	|
	Var error Bool_Exp question Expression colon Expression
	|
	Var assign error
	|
	Var assign error question Expression colon Expression
	|
	Var assign Bool_Exp error Expression colon Expression
	|
	Var assign Bool_Exp question error colon Expression
	|
	Var assign Bool_Exp question Expression error Expression
	|
	Var assign Bool_Exp question Expression colon error

;


Statement2:
	if Bool_Exp then Statements endif{
	printf("Statement2 -> if Bool_Exp then Statements endif\n")}
	|
	if Bool_Exp then Statements Split2{
	printf("Statement2 -> if Bool_Exp then Statements Split2\n")}
	|
	if error then Statements endif
	|
	if Bool_Exp error Statements endif
	|
	if Bool_Exp then error endif
	|
	if Bool_Exp then Statements error
	|
	if error then Statements Split2
	|
	if Bool_Exp error Statements Split2
	|
	if Bool_Exp then error Split2
;

Split2:
	New_elseif{
	printf("Split2 -> New_elseif\n")}
	|
	else Statements endif{
	printf("Splict2 -> else Statements endif\n")}
	|
	else error endif
	|
	else Statements error
;

New_elseif:
	elseif Bool_Exp Statements endif{
	printf("New_elseif -> elseif Bool_Exp Statements endif\n")}
	|
	elseif Bool_Exp Statements Split2{
	printf("New_elseif -> elseif Bool_Exp Statements Split2\n")}
	|
	elseif error Statements endif
	|
	elseif Bool_Exp error endif
	|
	elseif Bool_Exp Statements error
	|
	elseif error Statements Split2
	|
	elseif Bool_Exp error Split2
;

Statement3:
	while Bool_Exp beginloop Statements endloop{
	printf("Statement3 -> while Bool_Exp beginloop Statements endloop\n")}
	|
	while error beginloop Statements endloop
	|
	while Bool_Exp error Statements endloop
	|
	while Bool_Exp beginloop error endloop
	|
	while Bool_Exp beginloop Statements error
;

Statement4:
	do beginloop Statements endloop while Bool_Exp{
	printf("Statement4 -> do beginloop Statements endloop while Bool_Exp\n")}
	|
	do error Statements endloop while Bool_Exp
	|
	do beginloop error endloop while Bool_Exp
	|
	do beginloop Statements error while Bool_Exp
	|
	do beginloop Statements endloop error Bool_Exp
	|
	do beginloop Statements endloop while error
;

Statement5:
	read Vars{
	printf("Statement5 -> read Vars\n")}
	|
	read error
;

Vars:
	Var comma Vars{
	printf("Vars -> Var , Vars\n")}
	|
	Var{
	printf("Vars -> Var\n")}
	|
	Var comma error
;

Statement6:
	write Vars{
	printf("Statement6 -> write Vars\n")}
	|
	write error
;

Statement7:
	break{
	printf("Statement7 -> break\n")}
	|
	continue{
	printf("Statement7 -> continue\n")}
	|
	exit{
	printf("Statement7 -> exit\n")}
;

Bool_Exp:
	Relation_And_Exp{
	printf("Bool_Exp -> Relation_And_Exp\n")}
	|
	Relation_And_Exp or Bool_Exp{
	printf("Bool_Exp -> Relation_And_Exp or Bool_Exp\n")}
	|
	Relation_And_Exp or error
;

Relation_And_Exp:
	Relation_Exp{
	printf("Relation_And_Exp -> Relation_Exp\n")}
	|
	Relation_Exp and Relation_And_Exp{
	printf("Relation_And_Exp -> _Relation_Exp and Relation_And_Exp\n")}
	|
	Relation_Exp and error
;

Relation_Exp:
	not Re1{
	printf("Relation_Exp -> not Re1\n")}
	|
	Re1{
	printf("Relation_Exp -> Re1\n")}
	|
	not error
;

Re1:
	Expression Comp Expression{
	printf("Re1 -> Expression Comp Expression\n")}
	|
	true{
	printf("Re1 -> true\n")}
	|
	false{
	printf("Re1 -> false\n")}
	|
	l_para Bool_Exp r_para{
	printf("Re1 -> [ Bool_Exp r_para]\n")}
	|
	Expression Comp error
	|
	l_para error r_para
	|
	l_para Comp error
;

Comp:
	eq{
	printf("Comp -> ==\n")}
	|
	neq{
	printf("Comp -> <>\n")}
	|
	lt{
	printf("Comp -> <\n")}
	|
	gt{
	printf("Comp -> >\n")}
	|
	lte{
	printf("Comp -> <=\n")}
	|
	gte{
	printf("Comp -> >=\n")}
;

Expression:
	Multiplicative_Exp{
	printf("Expression -> Multiplicative_Exp\n")}
	|
	Multiplicative_Exp plus Expression{
	printf("Experssion -> Multiplicative_Exp + Expression\n")}
	|
	Multiplicative_Exp minus Expression{
	printf("Expression -> Multiplicative_Exp - Expression\n")}
	|
	Multiplicative_Exp plus error
	|
	Multiplicative_Exp minus error
;

Multiplicative_Exp:
	Term{
	printf("Multiplicative_Exp -> Term\n")}
	|
	Term mult  Multiplicative_Exp{
	printf("Multiplicative -> Term * Multiplicative_Exp\n")}
	|
	Term div Multiplicative_Exp{
	printf("Multiplicative_Exp -> Term / Multiplicative_Exp\n")}
	|
	Term mod Multiplicative_Exp{
	printf("Multiplicative_Exp -> Term mod Multiplicative_Exp\n")}
	|
	Term mult error
	|
	Term div error
	|
	Term mod error
;

Term:
	minus T1{
	printf("Term -> - T1\n")}
	|
	T1{
	printf("Term -> T1\n")}
	|
	minus error
;

T1:
	Var{
	printf ("T1 -> Var\n")}
	|
	number{
	printf("T1 -> number\n")}
	|
	l_para Expression r_para{
	printf("T1 -> ( Expression )\n")}
	|
	l_para Expression error
;

Var:
	identifier{
	printf("Var -> identifier\n")}
	|
	identifier l_brac Expression r_brac{
	printf("Var -> identifier [ Expression ]\n")}
	|
	identifier l_brac error r_brac
	|
	identifier l_brac Expression error
;

gte:
	GTE{
	printf("gte -> GTE\n")}
;

or:
	OR{
	printf("or -> OR\n")}
;

do:
	DO{
	printf("do -> DO\n")}
;

mult:
	MULT{
	printf("mult -> MULT\n")}
;

endloop:
	ENDLOOP{
	printf("endloop -> ENDLOOP\n")}
;

not:
	NOT{
	printf("not -> NOT\n")}
;

plus:
	ADD{
	printf("plus -> ADD\n")}
;

semi:
	SEMICOLON{
	printf("semi -> SEMICOLON\n")}
;

eq:
	EQ{
	printf("eq -> EQ\n")}
;

break:
	BREAK{
	printf("break -> Break\n")}
;

beginloop:
	BEGINLOOP{
	printf("beginloop -> BEGINLOOP\n")}
;

identifier:
	IDENT{
	printf("identifier -> IDENT (%s)\n", $1)}
;

number:
	NUMBER{
	printf("number -> NUMBER (%i)\n", $1)}
;

gt:
	GT{
	printf("gt -> GT\n")}
;

lt:
	LT{
	printf("lt -> LT\n")}
;

write:
	WRITE{
	printf("write -> WRITE\n")}
;

comma:
	COMMA{
	printf("comma -> COMMA\n")}
;

colon:
	COLON{
	printf("colon -> COLON\n")}
;

neq:
	NEQ{
	printf("neq -> NEQ\n")}
;

then:
	THEN{
	printf("then -> THEN\n")}
;

else:
	ELSE{
	printf("else -> ELSE\n")}
;

beginprogram:
	BEGIN_PROGRAM{
	printf("beginprogram -> BEGIN_PROGRAM\n")}
;

minus:
	SUB{
	printf("minus -> SUB\n")}
;

program:
	PROGRAM{
	printf("program -> PROGRAM\n")}
;

elseif:
	ELSEIF{
	printf("elseif -> ELSEIF\n")}
;

question:
	QUESTION{
	printf("question -> QUESTION\n")}
;

false:
	FALSE{
	printf("false -> FALSE\n")}
;

true:
	TRUE{
	printf("true -> TRUE\n")}
;


lte:
	LTE{
	printf("lte -> LTE\n")}
;

r_para:
	R_PAREN{
	printf("rpara -> R_PAREN\n")}
;

endprogram:
	END_PROGRAM{
	printf("endprogram -> END_PROGRAM\n")}
;

l_para:
	L_PAREN{
	printf("l_para -> L_PAREN\n")}
;

mod:
	MOD{
	printf("mod -> MOD\n")}
;

while:
	WHILE{
	printf("while -> WHILE\n")}
;

int:
	INTEGER{
	printf("int -> INTEGER\n")}
;

div:
	DIV{
	printf("div -> DIV\n")}
;

if:
	IF{
	printf("if -> IF\n")}
;

array:
	ARRAY{
	printf("array -> ARRAY\n")}
;

r_brac:
	R_BRACKET{
	printf("r_brac -> R_BRACKET\n")}
;

exit:
	EXIT{
	printf("exit -> EXIT\n")}
;

continue:
	CONTINUE{
	printf("continue -> CONTINUE\n")}
;

assign:
	ASSIGN{
	printf("assign -> ASSIGN\n")}
;

endif:
	ENDIF{
	printf("endif -> ENDIF\n")}
;

of:
	OF{
	printf("of -> OF\n")}
;

read:
	READ{
	printf("read -> READ\n")}
;

l_brac:
	L_BRACKET{
	printf("l_brac -> L_BRACKET\n")}
;

and:
	AND{
	printf("and -> AND\n")}
;


%%

int yyerror(string s)
{
	extern int num_line;
	extern char *yytext;

	cerr << "ERROR: " << s << " at symbol \"" << yytext;
	cerr << "\" on line " << num_line << endl;

//	exit(1);
}

int yyerror(char *s)
{
	return yyerror(string(s));
}
