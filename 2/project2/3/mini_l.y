/* Mini_l bison spec*/
/* Samuel Villarreal*/

%{
#include "heading.h"
#include <iostream>
#include <stdio.h>
#include <map>
#include <string>
#include <stack>
#include <set>
#include <sstream>
int yyerror(char *s);
int yyerror(const char* s);
int yylex(void);
string code = "";
string prog_name = "";
stack<int> sc ; // continue stack
stack<int> sd ; // break stack
stack<string> ifs;

map<string, int> dec_type; // 0 is single 1 is array
//map<string, string> labels;

//these are counters for their respective stacks
int ic = 0;
int l = 0;
int t = 0;
int p = 0;
int errors = 0;

stack<string> i_stack; //identifiers
stack<string> v_stack; // var
stack<string> num_stack; // numbers
stack<string> l_stack; //labels
stack<string> p_stack; //predicates
stack<string> c_stack; //comp 

//used for reordering
stack<string> r_stack;

const string reserved[24] = { "program", "endprogram", "integer", "array", "of", "if", "then", "else", "endif", "while", "beginloop", "endloop", "true", "false", "read", "write", "and" , "or", "not", "break", "continue" , "exit", "elseif", "do"  };

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
		for(int i = 0; i < t ; i++)
		{
			stringstream s; 
			s << i;
			code = "\t. t" + s.str() + "\n" + code;
		}
		for(int j = 0; j < p ; j++)
		{
			stringstream s;
			s << j;
			code = "\t. p" + s.str() + "\n" + code;
		}
	//	cout << code;
	// write code to file instead
	if( errors > 0)
	{
		exit(0);
	}
	prog_name.erase(0,1);
	string fprog = prog_name + ".mil";
	FILE* f = fopen(fprog.c_str(), "w");
	fprintf(f, "%s", code.c_str());
	fclose(f);	
	}//printf( "Program -> program identifier ; Block endprogram\n" )}
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
	}//printf( "Block -> Declarations semi beginprogram Statements\n")}
	|
	Declarations error Statements
	|
	Declarations beginprogram error
;

Declarations:
	Declaration semi{
	}//printf( "Declarations -> Declaration ;\n")}
	|
	Declaration semi Declarations{
	}//printf("Declarations -> Declaration , Declarations\n")}
	|
	Declaration error
	
;

Statements:
	Statement semi{
	}//printf( "Statments -> Statement ;\n")}
	|
	Statement semi Statements{
	}//printf("Statements -> Statement , Statements\n")}
	|
	Statement error
;

Declaration:
	Identifiers colon int{
		while(i_stack.size() > 0)
		{
			code += "\t. " + i_stack.top() + "\n";
			dec_type[ i_stack.top()] = 0;
			i_stack.pop();
		}	
	}//printf("Declaration -> Identifiers : int\n")}
	|
	Identifiers colon array l_brac number r_brac of int{
		while(i_stack.size() > 0)
		{
			code += "\t.[] " + i_stack.top() + ", " + num_stack.top() + "\n";
			dec_type[ i_stack.top()] = 1;
			i_stack.pop();
		}
		int ier = atoi(num_stack.top().c_str());
		if(ier <= 0)
		{
			string m = " array of size <= 0\n";
			yyerror(m.c_str());
		}
		num_stack.pop();
	}//printf("Declaration -> Identifiers : array [ number ] of int\n")}
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
	}//printf("Identifiers -> identifier\n")}
	|
	identifier comma Identifiers{
	}//printf("Identifiers -> identifier , Identifiers")}
	|
	identifier comma error
;


Statement:
	Statement1{
	}//printf("Statement -> Statement1\n")}
	|
	Statement2{
	}//printf("Statement -> Statement2\n")}
	|
	Statement3{
	}//printf("Statement -> Statement3\n")}
	|
	Statement4{
	}//printf("Statement -> Statement4\n")}
	|
	Statement5{
	}//printf("Statement -> Statement5\n")}
	|
	Statement6{
	}//printf("Statement -> Statement6\n")}
	|
	Statement7{
	}//printf("Statement -> Statement7\n")}
;

Statement1:
	Var assign Expression{
		while(v_stack.size())
		{
			string s = v_stack.top();
			string tcode;
			v_stack.pop();
			if( dec_type[s] == 1 && num_stack.size() > 0)
			{
				stringstream ss;
				ss << "t" << t;
				t++;
				code += "\t=[] " + ss.str() + ", " + s + ", " + num_stack.top() + "\n";
				s = ss.str();
				num_stack.pop();
			}
			
			string s2 = v_stack.top();
			v_stack.pop();
			if(dec_type[s2] == 1 && num_stack.size() > 0)
			{
				code += "\t[]= " + s2 + ", " + num_stack.top() + ", " + s + "\n";
			}
			else
			{
				code += "\t= " + s2 + ", " + s + "\n";
			}
		}
	}//printf("Statement1 -> Var := Expression\n")}
	|
	Var assign Bool_Exp question Expression colon2 Expression{
		string s = v_stack.top();
		v_stack.pop();

		if(dec_type[s] == 1 && num_stack.size() > 0)
		{
			stringstream ss;
			ss << "t" << t;
			t++;
			code += "\t=[] " + ss.str() + ", " + s + ", " + num_stack.top() + "\n";
			s = ss.str();
			num_stack.pop();
		}
		string s2 = v_stack.top();
		v_stack.pop();

		if(dec_type[s2] == 1 && num_stack.size() > 0)
		{
			stringstream ss;
			ss << "t" << t;
			t++;
			code += "\t=[] " + ss.str() + ", " + s2 + ", " + num_stack.top() + "\n";
			s2 = ss.str();
			num_stack.pop();
		}	

		code += "\t= " + s2 + ", " + s + "\n";
		code += ": " + l_stack.top() + "\n";
		l_stack.pop();
		
	}//printf("Statement1 -> Var := Bool_Exp ? Expression : Expression\n")}
	|
	error assign Expression
	|
	error assign Bool_Exp question Expression colon2 Expression
	|
	Var error Expression
	|
	Var error Bool_Exp question Expression colon2 Expression
	|
	Var assign error
	|
	Var assign error question Expression colon2 Expression
	|
	Var assign Bool_Exp error Expression colon2 Expression
	|
	Var assign Bool_Exp question error colon2 Expression
	|
	Var assign Bool_Exp question Expression error Expression
	|
	Var assign Bool_Exp question Expression colon2 error

;

colon2:
	COLON{
		string s = v_stack.top();
		v_stack.pop();

		if(dec_type[s] == 1 && num_stack.size() > 0)
		{
			stringstream ss;
			ss << "t" << t;
			t++;
			code += "\t=[] " + ss.str() + ", " + s + ", " + num_stack.top() + "\n";
			s = ss.str();
			num_stack.pop();
		}

		string s2 = v_stack.top();
//		v_stack.pop();

		if(dec_type[s2] == 1 && num_stack.size() > 0)
		{
			stringstream ss;
			ss << "t" << t;
			t++;
			code += "\t=[] " + ss.str() + ", " + s2 + ", " + num_stack.top() + "\n";
			s2 = ss.str();
			num_stack.pop();
		}	

		code += "\t= " + s2 + ", " + s + "\n";
		
		stringstream sl;
		sl << "l" << l;
		l++;

		code += "\t:= " + sl.str() + "\n";
		code += ": " + l_stack.top() + "\n";
		l_stack.pop();
		l_stack.push(sl.str());
	}
;


Statement2:
	if Bool_Exp then Statements endif{
		size_t pos = code.find(ifs.top());
		string ins = ifs.top();
		ifs.pop();
		string ins2 = ifs.top();
		ifs.pop();
		for(size_t i = 0 ; i < ins2.size(); i++)
		{
			code[pos + i] = ins2[i];
		}
		if( ins2.size() < ins.size())
		{
			code.erase(pos + ins2.size(), 1);
		}
	}//printf("Statement2 -> if Bool_Exp then Statements endif\n")}
	|
	if Bool_Exp then Statements Split2{
	}//printf("Statement2 -> if Bool_Exp then Statements Split2\n")}
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
	}//printf("Split2 -> New_elseif\n")}
	|
	else Statements endif{
	}//printf("Splict2 -> else Statements endif\n")}
	|
	else error endif
	|
	else Statements error
;

New_elseif:
	elseif fBool_Exp Statements endif{
	}//printf("New_elseif -> elseif Bool_Exp Statements endif\n")}
	|
	elseif fBool_Exp Statements Split2{
	}//printf("New_elseif -> elseif Bool_Exp Statements Split2\n")}
	|
	elseif error Statements endif
	|
	elseif fBool_Exp error endif
	|
	elseif fBool_Exp Statements error
	|
	elseif error Statements Split2
	|
	elseif fBool_Exp error Split2
;

fBool_Exp:
	Relation_And_Exp{ /*TODO*/
		string s = p_stack.top();
		p_stack.pop();
		stringstream ps;
		ps << "p" << p;
		p++;
		code += "\t== " + ps.str() + ", " + s + ", 0\n";
		p_stack.push(ps.str());

		string ss = p_stack.top();
		p_stack.pop();

		stringstream ls;
		ls << "l" << l;
		code += "\t?:= " + ls.str() + ", " + ss + "\n";
	
	}//printf("Bool_Exp -> Relation_And_Exp\n")}
	|
	Relation_And_Exp or Bool_Exp{
		stringstream ps;
		ps << "p" << p;
		string r = p_stack.top();
		p_stack.pop();
		string l = p_stack.top();
		p_stack.pop();

		code += "\t|| " + ps.str() + ", " + l + ", " + r + "\n";
		p++;
		p_stack.push(ps.str());

		string ss = p_stack.top();
		p_stack.pop();

		stringstream ls;
		ls << "l" << l;
		code += "\t?:= " + ls.str() + ", " + ss + "\n";

	}//printf("Bool_Exp -> Relation_And_Exp or Bool_Exp\n")}
	|
	Relation_And_Exp or error
;


Statement3:
	while Bool_Exp beginloop Statements endloop{
	}//printf("Statement3 -> while Bool_Exp beginloop Statements endloop\n")}
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
	do dbeginloop Statements dendloop dwhile dBool_Exp{	
		//begin of normal while	
		string s = p_stack.top();
		p_stack.pop();
		code += "\t?:= " + l_stack.top() + ", " + s + "\n";
		
		stringstream ss;
		ss << "l" << sd.top();
		sd.pop();
		//l++;
		code += ": " + ss.str() + "\n";
	
		l_stack.pop();
	}//printf("Statement4 -> do beginloop Statements endloop while Bool_Exp\n")}
	|
	do error Statements dendloop dwhile Bool_Exp
	|
	do dbeginloop error dendloop dwhile Bool_Exp
	|
	do dbeginloop Statements error dwhile Bool_Exp
	|
	do dbeginloop Statements dendloop error Bool_Exp
	|
	do dbeginloop Statements dendloop dwhile error
;

dBool_Exp:
	Relation_And_Exp{ /*TODO*/
		string s = p_stack.top();
		p_stack.pop();
		stringstream ps;
		ps << "p" << p;
		p++;
		code += "\t== " + ps.str() + ", " + s + ", 1\n";
		p_stack.push(ps.str());
	
	}//printf("Bool_Exp -> Relation_And_Exp\n")}
	|
	Relation_And_Exp or Bool_Exp{
		stringstream ps;
		ps << "p" << p;
		string r = p_stack.top();
		p_stack.pop();
		string l = p_stack.top();
		p_stack.pop();

		code += "\t|| " + ps.str() + ", " + l + ", " + r + "\n";
		p++;
		p_stack.push(ps.str());

	}//printf("Bool_Exp -> Relation_And_Exp or Bool_Exp\n")}
	|
	Relation_And_Exp or error
;

dwhile:
	WHILE{
		stringstream s;
		s << l;
		code +=  ": l" + s.str() + "\n";
		l++;
	}
;

dendloop:
	ENDLOOP{
	sc.pop();
	//sd.pop();
	}
;

dbeginloop:
	BEGINLOOP{
	}//printf("beginloop -> BEGINLOOP\n")}
;

do:
	DO{
		stringstream s;
		s << l;
		code +=  ": l" + s.str() + "\n";
		l++;
		l_stack.push("l"+ s.str());
		sc.push(l-1);
		sd.push(l);
		l++;	
	}//printf("do -> DO\n")}
;

Statement5:
	read Vars{
		while(v_stack.size())
		{
			string s = v_stack.top();
			string tcode;
			v_stack.pop();
			if( dec_type[s] == 0)
			{
				tcode = "\t.< " + s + "\n";
				r_stack.push(tcode);
			}
			else 
			{
				if(num_stack.empty())
				{
					cout << "Error at S5\n";
				}
				string index = num_stack.top();
				num_stack.pop();
				tcode = "\t.[]< " + s + ", " + index + "\n";
				r_stack.push(tcode);
			}
		}
		while(r_stack.size())
		{
			code += r_stack.top();
			r_stack.pop();
		}
	}//printf("Statement5 -> read Vars\n")}
	|
	read error
;

Vars:
	Var comma Vars{
	}//printf("Vars -> Var , Vars\n")}
	|
	Var{
	}//printf("Vars -> Var\n")}
	|
	Var comma error
;

Statement6:
	write Vars{
		while(v_stack.size())
		{
			string s = v_stack.top();
			string tcode;
			v_stack.pop();
			if( dec_type[s] == 0)
			{
				tcode = "\t.> " + s + "\n";
				r_stack.push(tcode);
			}
			else 
			{
				if(num_stack.empty())
				{
					cout << " error at statement6\n";
				}
				string index = num_stack.top();
				num_stack.pop();
				tcode = "\t.[]> " + s + ", " + index + "\n";
				r_stack.push(tcode);
			}
		}
		while(r_stack.size())
		{
			code += r_stack.top();
			r_stack.pop();
		}
	}//printf("Statement6 -> write Vars\n")}
	|
	write error
;

Statement7:
	break{
	}//printf("Statement7 -> break\n")}
	|
	continue{
	}//printf("Statement7 -> continue\n")}
	|
	exit{
	}//printf("Statement7 -> exit\n")}
;

Bool_Exp:
	Relation_And_Exp{ /*TODO*/
		string s = p_stack.top();
		p_stack.pop();
		stringstream ps;
		ps << "p" << p;
		p++;
		code += "\t== " + ps.str() + ", " + s + ", 0\n";
		p_stack.push(ps.str());
	
	}//printf("Bool_Exp -> Relation_And_Exp\n")}
	|
	Relation_And_Exp or Bool_Exp{
		stringstream ps;
		ps << "p" << p;
		string r = p_stack.top();
		p_stack.pop();
		string l = p_stack.top();
		p_stack.pop();

		code += "\t|| " + ps.str() + ", " + l + ", " + r + "\n";
		p++;
		p_stack.push(ps.str());

	}//printf("Bool_Exp -> Relation_And_Exp or Bool_Exp\n")}
	|
	Relation_And_Exp or error
;

Relation_And_Exp:
	Relation_Exp{
	}//printf("Relation_And_Exp -> Relation_Exp\n")}
	|
	Relation_Exp and Relation_And_Exp{
		stringstream ps;
		ps << "p" << p;
		string r = p_stack.top();
		p_stack.pop();
		string l = p_stack.top();
		p_stack.pop();

		code += "\t&& " + ps.str() + ", " + l + ", " + r + "\n";
		p++;
		p_stack.push(ps.str());
	}//printf("Relation_And_Exp -> _Relation_Exp and Relation_And_Exp\n")}
	|
	Relation_Exp and error
;

Relation_Exp:
	not Re1{
		string ps = p_stack.top();
		p_stack.pop();

		stringstream s;
		s << "p" << p;
		p++;
		
		code += "\t! " + s.str() + ", " + ps + "\n";
		p_stack.push(s.str());
	}//printf("Relation_Exp -> not Re1\n")}
	|
	Re1{
	}//printf("Relation_Exp -> Re1\n")}
	|
	not error
;

Re1:
	Expression Comp Expression{
		stringstream s;
		s << "p" << p;
		string r = v_stack.top();
		if(dec_type[r] == 1 && num_stack.size() > 0)
		{
			stringstream ts;
			ts << "t" << t;
			code += "\t=[] " + ts.str() + ", " + r + ", " + num_stack.top() + "\n";
			r = ts.str();
			num_stack.pop();
			t++;
		}
		v_stack.pop();
		string l = v_stack.top();
		if( dec_type[l] == 1 && num_stack.size() > 0)
		{
			stringstream ts;
			ts << "t" << t;
			code += "\t=[] " + ts.str() + ", " + l + ", " + num_stack.top() + "\n";
			l = ts.str();
			num_stack.pop();
			t++;
		}
		v_stack.pop();
		
		string c = c_stack.top();
		c_stack.pop();
		
		code += "\t" + c + " " + s.str() + ", " + l + ", " + r + "\n";
		p_stack.push(s.str());
		p++; 
	}//printf("Re1 -> Expression Comp Expression\n")}
	|
	true{
		stringstream s;
		s << "p" << p;
		code += "\t== " + s.str() + ", 1, 1\n";
		p_stack.push(s.str());
		p++;
	}//printf("Re1 -> true\n")}
	|
	false{
		stringstream s;
		s << "p" << p;
		code += "\t== " + s.str() + ", 1, 0\n";
		p_stack.push(s.str());
		p++;	
	}//printf("Re1 -> false\n")}
	|
	l_para Bool_Exp r_para{
	//	code += "l b r\n";
	}//printf("Re1 -> [ Bool_Exp r_para]\n")}
	|
	Expression Comp error
	|
	l_para error r_para
	|
	l_para Comp error
;

Comp:
	eq{
		c_stack.push("==");
	}//printf("Comp -> ==\n")}
	|
	neq{
		c_stack.push("!=");
	}//printf("Comp -> <>\n")}
	|
	lt{
		c_stack.push("<");
	}//printf("Comp -> <\n")}
	|
	gt{
		c_stack.push(">");
	}//printf("Comp -> >\n")}
	|
	lte{
		c_stack.push("<=");
	}//printf("Comp -> <=\n")}
	|
	gte{
		c_stack.push(">=");
	}//printf("Comp -> >=\n")}
;

Expression:
	Multiplicative_Exp{
	}//printf("Expression -> Multiplicative_Exp\n")}
	|
	Multiplicative_Exp plus Expression{
		string r = v_stack.top();
		if(dec_type[r] == 1 && num_stack.size() > 0) // tempoary recieves from array
		{
			stringstream s;
			s << "t" << t;
			code += "\t=[] " + s.str() + ", " + r + ", " + num_stack.top() +"\n";
			t++;
			r = s.str();
			num_stack.pop();
		}
		v_stack.pop();
	
		string l = v_stack.top();
		if(dec_type[l] == 1 && num_stack.size() > 0)
		{
			stringstream s;
			s << "t" << t;
			code += "\t=[] " + s.str() + ", " + r + ", " + num_stack.top() + "\n";
			t++;
			l = s.str();
			num_stack.pop();
		}
		v_stack.pop();
		stringstream st;
		st << "t" << t;
		code += "\t+ " + st.str() + ", " + l + ", " + r + "\n";
		v_stack.push(st.str());
		t++;

	}//printf("Experssion -> Multiplicative_Exp + Expression\n")}
	|
	Multiplicative_Exp minus Expression{
		string r = v_stack.top();
		if(dec_type[r] == 1 && num_stack.size() > 0) // tempoary recieves from array
		{
			stringstream s;
			s << "t" << t;
			code += "\t=[] " + s.str() + ", " + r + ", " + num_stack.top() +"\n";
			t++;
			r = s.str();
			num_stack.pop();
		}
		v_stack.pop();
	
		string l = v_stack.top();
		if(dec_type[l] == 1 && num_stack.size() > 0)
		{
			stringstream s;
			s << "t" << t;
			code += "\t=[] " + s.str() + ", " + r + ", " + num_stack.top() + "\n";
			t++;
			l = s.str();
			num_stack.pop();
		}
		v_stack.pop();
		stringstream st;
		st << "t" << t;
		code += "\t- " + st.str() + ", " + l + ", " + r + "\n";
		v_stack.push(st.str());
		t++;

	}//printf("Expression -> Multiplicative_Exp - Expression\n")}
	|
	Multiplicative_Exp plus error
	|
	Multiplicative_Exp minus error
;

Multiplicative_Exp:
	Term{
	}//printf("Multiplicative_Exp -> Term\n")}
	|
	Term mult  Multiplicative_Exp{
		string r = v_stack.top();
		if(dec_type[r] == 1 && num_stack.size() > 0) // tempoary recieves from array
		{
			stringstream s;
			s << "t" << t;
			code += "\t=[] " + s.str() + ", " + r + ", " + num_stack.top() +"\n";
			t++;
			r = s.str();
			num_stack.pop();
		}
		v_stack.pop();
	
		string l = v_stack.top();
		if(dec_type[l] == 1 && num_stack.size() > 0)
		{
			stringstream s;
			s << "t" << t;
			code += "\t=[] " + s.str() + ", " + r + ", " + num_stack.top() + "\n";
			t++;
			l = s.str();
			num_stack.pop();
		}
		v_stack.pop();
		stringstream st;
		st << "t" << t;
		code += "\t* " + st.str() + ", " + l + ", " + r + "\n";
		v_stack.push(st.str());
		t++;
	}//printf("Multiplicative -> Term * Multiplicative_Exp\n")}
	|
	Term div Multiplicative_Exp{
		string r = v_stack.top();
		if(dec_type[r] == 1 && num_stack.size() > 0) // tempoary recieves from array
		{
			stringstream s;
			s << "t" << t;
			code += "\t=[] " + s.str() + ", " + r + ", " + num_stack.top() +"\n";
			t++;
			r = s.str();
			num_stack.pop();
		}
		v_stack.pop();
	
		string l = v_stack.top();
		if(dec_type[l] == 1 && num_stack.size() > 0)
		{
			stringstream s;
			s << "t" << t;
			code += "\t=[] " + s.str() + ", " + r + ", " + num_stack.top() + "\n";
			t++;
			l = s.str();
			num_stack.pop();
		}
		v_stack.pop();
		stringstream st;
		st << "t" << t;
		code += "\t/ " + st.str() + ", " + l + ", " + r + "\n";
		v_stack.push(st.str());
		t++;
	}//printf("Multiplicative_Exp -> Term / Multiplicative_Exp\n")}
	|
	Term mod Multiplicative_Exp{
		string r = v_stack.top();
		if(dec_type[r] == 1 && num_stack.size() > 0) // tempoary recieves from array
		{
			stringstream s;
			s << "t" << t;
			code += "\t=[] " + s.str() + ", " + r + ", " + num_stack.top() +"\n";
			t++;
			r = s.str();
			num_stack.pop();
		}
		v_stack.pop();
	
		string l = v_stack.top();
		if(dec_type[l] == 1 && num_stack.size() > 0)
		{
			stringstream s;
			s << "t" << t;
			code += "\t=[] " + s.str() + ", " + r + ", " + num_stack.top() + "\n";
			t++;
			l = s.str();
			num_stack.pop();
		}
		v_stack.pop();
		stringstream st;
		st << "t" << t;
		code += "\t% " + st.str() + ", " + l + ", " + r + "\n";
		v_stack.push(st.str());
		t++;

	}//printf("Multiplicative_Exp -> Term mod Multiplicative_Exp\n")}
	|
	Term mult error
	|
	Term div error
	|
	Term mod error
;

Term:
	minus T1{ 
		string s = v_stack.top();
		v_stack.pop();
		if(dec_type[s] == 1 && num_stack.size() > 0)
		{
			stringstream ss;
			ss << "t" << t ;
			code += "\t=[] " + ss.str() + ", " + s + ", " + num_stack.top() + "\n";
			t++;
			s = ss.str();
			num_stack.pop();
		}
		stringstream ss2;
		ss2 << "t" << t;
		t++;
		code += "* " + ss2.str() + ", " + s + ", -1\n";
		v_stack.push(ss2.str());
	}//printf("Term -> - T1\n")}
	|
	T1{
	}//printf("Term -> T1\n")}
	|
	minus error
;

T1:
	Var{
	}//printf ("T1 -> Var\n")}
	|
	number{
		v_stack.push(num_stack.top());
		num_stack.pop();
	}//printf("T1 -> number\n")}
	|
	l_para Expression r_para{
	}//printf("T1 -> ( Expression )\n")}
	|
	l_para Expression error
;

Var:
	videntifier{
	if(dec_type[v_stack.top()] != 0)
	{
		string m = "forgetting to specify array index";
		yyerror(m.c_str());
	}
	}//printf("Var -> identifier\n")}
	|
	videntifier l_brac Expression r_brac{
		num_stack.push(v_stack.top());
		v_stack.pop();
	if(dec_type[v_stack.top()] != 1)
	{
		string m = "indexing regular variable";
		yyerror(m.c_str());
	}
	}//printf("Var -> identifier [ Expression ]\n")}
	|
	videntifier l_brac error r_brac
	|
	videntifier l_brac Expression error
;

gte:
	GTE{
	}//printf("gte -> GTE\n")}
;

or:
	OR{
	}//printf("or -> OR\n")}
;



mult:
	MULT{
	}//printf("mult -> MULT\n")}
;

endloop:
	ENDLOOP{ /*TODO*/
		string s = l_stack.top();
		l_stack.pop();
		string s2 = l_stack.top();
		l_stack.pop();
		code += "\t:= " + s2 + "\n";
		code += ": " + s + "\n";
		sc.pop(); // drops the loop pos for continue/break
		sd.pop(); 
	}//printf("endloop -> ENDLOOP\n")}
;

not:
	NOT{
	}//printf("not -> NOT\n")}
;

plus:
	ADD{
	}//printf("plus -> ADD\n")}
;

semi:
	SEMICOLON{
	}//printf("semi -> SEMICOLON\n")}
;

eq:
	EQ{
	}//printf("eq -> EQ\n")}
;

break:
	BREAK{
		if(sd.size() <= 0 )
		{
			string m = " using break outside a loop";
			yyerror(m.c_str());
			exit(0);
		}
		int next = sd.top();
		stringstream ss;
		ss << next;
		code += "\t:= l" + ss.str() + "\n";
	}//printf("break -> Break\n")}
;

beginloop:
	BEGINLOOP{
		string s = p_stack.top();
		p_stack.pop();
		stringstream ls;
		ls << "l" << l;
		l++;
		code += "\t?:= " + ls.str() + ", " + s + "\n";
		l_stack.push(ls.str());
	}//printf("beginloop -> BEGINLOOP\n")}
;

identifier:
	IDENT{
		map<string , int>::iterator it;
		string s = $1;
		it = dec_type.find("_" + s);
		if(it == dec_type.end())
		{
			i_stack.push("_"+s);
		}
		else{
			string m = " " + s + " was previously defined";
			yyerror(m.c_str());
		//	exit(0);
		}
		if(ic == 0 && i_stack.size() > 0){
			ic++;
			prog_name  = i_stack.top();
			i_stack.pop(); 
		}
	}//printf("identifier -> IDENT (%s)\n", $1)}
;

videntifier:
	IDENT{
		map<string, int>::iterator it;
		string s = $1;
		it = dec_type.find("_" + s);
		if(it == dec_type.end())
		{
			string m = " " +  s + " was not previously declared";
			yyerror(m.c_str());
		//	exit(0);
		}
		for( int i = 0; i < 24; i++)
		{
			if( reserved[i] == s)
			{
				string m =  s + " is a reserved word";
				yyerror(m.c_str());
		//		exit(0);
			}
		}

		v_stack.push("_" + s);
	
	}
;

number:
	NUMBER{
		stringstream s;
		s << $1;
		num_stack.push(s.str());
	}//printf("number -> NUMBER (%i)\n", $1)}
;

gt:
	GT{
	}//printf("gt -> GT\n")}
;

lt:
	LT{
	}//printf("lt -> LT\n")}
;

write:
	WRITE{
	}//printf("write -> WRITE\n")}
;

comma:
	COMMA{
	}//printf("comma -> COMMA\n")}
;

colon:
	COLON{
	}//printf("colon -> COLON\n")}
;

neq:
	NEQ{
	}//printf("neq -> NEQ\n")}
;

then:
	THEN{
		string s = p_stack.top();
		p_stack.pop();
		stringstream ss;
		ss << "l" << l;
		code += "\t?:= " + ss.str() + ", " + s + "\n";
	
	}//printf("then -> THEN\n")}
;

beginprogram:
	BEGIN_PROGRAM{
		code += ": START\n";
	}//printf("beginprogram -> BEGIN_PROGRAM\n")}
;

minus:
	SUB{
	}//printf("minus -> SUB\n")}
;

program:
	PROGRAM{
	}//printf("program -> PROGRAM\n")}
;


question:
	QUESTION{
	string s = p_stack.top();
	p_stack.pop();
	stringstream ss;
	ss << "l" << l;
	l++;
	code += "\t?:= " + ss.str() + ", " + s + "\n";
	l_stack.push(ss.str());
 
	}//printf("question -> QUESTION\n")}
;

false:
	FALSE{
	}//printf("false -> FALSE\n")}
;

true:
	TRUE{
	}//printf("true -> TRUE\n")}
;


lte:
	LTE{
	}//printf("lte -> LTE\n")}
;

r_para:
	R_PAREN{
	}//printf("rpara -> R_PAREN\n")}
;

endprogram:
	END_PROGRAM{
		code += ": EndLabel\n";
	}//printf("endprogram -> END_PROGRAM\n")}
;

l_para:
	L_PAREN{
	}//printf("l_para -> L_PAREN\n")}
;

mod:
	MOD{
	}//printf("mod -> MOD\n")}
;

while:
	WHILE{
		stringstream s;
		s << l;
		code +=  ": l" + s.str() + "\n";
		l++;
		l_stack.push("l"+ s.str());
		sc.push(l -1);
		sd.push(l);
	}//printf("while -> WHILE\n")}
;

int:
	INTEGER{
	}//printf("int -> INTEGER\n")}
;

div:
	DIV{
	}//printf("div -> DIV\n")}
;

if:
	IF{
		stringstream s;
		s << l;
		code += ": l" + s.str() + "\n";
		l++;
		stringstream s2;
		s2 << "l" << l;
		l++;
		l_stack.push(s2.str());
		ifs.push(s2.str());
		stringstream fs;
		fs << "l" << l;
		ifs.push(fs.str());
	}//printf("if -> IF\n")}
;

endif:
	ENDIF{
		code += ": " + l_stack.top() + "\n";
		l_stack.pop();
	}//printf("endif -> ENDIF\n")}
;

elseif:
	ELSEIF{
		stringstream s;
		s << l;
		code += "\t:= "+ l_stack.top() + "\n";
		code += ": l" + s.str() + "\n";
		l++;
	}//printf("elseif -> ELSEIF\n")}
;

else:
	ELSE{
		stringstream s;
		s <<l;
		l++;
		code += "\t:= " + l_stack.top() + "\n";
		code += ": l" + s.str() + "\n";
	}//printf("else -> ELSE\n")}
;




array:
	ARRAY{
	}//printf("array -> ARRAY\n")}
;

r_brac:
	R_BRACKET{
	}//printf("r_brac -> R_BRACKET\n")}
;

exit:
	EXIT{ /*TODO*/
		code += "\t:= EndLabel\n";	
	}//printf("exit -> EXIT\n")}
;

continue:
	CONTINUE{
		stringstream ss;
		if(sc.size() <= 0)
		{
			string m = " using continue statement outside a loop";
			yyerror(m.c_str());
			exit(0);
		}
		ss << sc.top();
		code += "\t:= l" + ss.str() + "\n";
	}//printf("continue -> CONTINUE\n")}
;

assign:
	ASSIGN{
	}//printf("assign -> ASSIGN\n")}
;


of:
	OF{
	}//printf("of -> OF\n")}
;

read:
	READ{
	}//printf("read -> READ\n")}
;

l_brac:
	L_BRACKET{
	}//printf("l_brac -> L_BRACKET\n")}
;

and:
	AND{
	}//printf("and -> AND\n")}
;


%%

int yyerror(string s)
{
	extern int num_line;
	extern char *yytext;
	errors++;

	cerr << "ERROR: " << s << " at symbol \"" << yytext;
	cerr << "\" on line " << num_line + 1 << endl;

//	exit(1);
}

int yyerror(char *s)
{
	return yyerror(string(s));
}

int yyerror(const char* s)
{
	return yyerror(string(s));
}
