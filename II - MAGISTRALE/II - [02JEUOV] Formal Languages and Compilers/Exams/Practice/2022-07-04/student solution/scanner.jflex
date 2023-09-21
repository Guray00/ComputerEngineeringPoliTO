import java_cup.runtime.*;

%%

%class Lexer
%unicode
%cup
%line
%column


%{
	private Symbol symbol(int type) {
		return new Symbol(type, yyline, yycolumn);
	}
	
	private Symbol symbol(int type, Object value) {
		return new Symbol(type, yyline, yycolumn, value);
	}
	
%}


sep = "===="
comment = "[[--" (.)* "--]]"

id = [a-z][a-zA-Z]* 
quoteds = \"[a-zA-Z ]*\"

date1  =  ((0[1-9]) | (1[0-5]))  \/ (01 | "January")   \/ "2023"

date7  =  ((0[4-9]) | ([1-2][1-9]) | ([12]0) | (3[01]))  \/ (07 | "July")      \/ "2022"

date8  =  (([0-2][1-9]) | ([12]0) | (3[01]))  \/ (08 | "August")    \/ "2022"
date9  =  (([0-2][1-9]) | ([12]0) | (3[0] ))  \/ (09 | "September") \/ "2022"
date10 =  (([0-2][1-9]) | ([12]0) | (3[01]))  \/ (10 | "October")   \/ "2022"
date11 =  (([0-2][1-9]) | ([12]0) | (3[0] ))  \/ (11 | "November")  \/ "2022"
date12 =  (([0-2][1-9]) | ([12]0) | (3[01]))  \/ (12 | "December")  \/ "2022"

date = {date1}|{date7}|{date8}|{date9}|{date10}|{date11}|{date12}
token1 = "D-" {date} ("-" {date})? " "* ";"

token2 = "R-" ("XX" | "YY" | "ZZ"){3,15} ("?"{4} "?"*)? " "* ";"

hex_digit = [0-9A-Fa-f]
hex = (2[A-F]) | ([3-F]{hex_digit}) | ([0-9Aa]{hex_digit}{2}) | ([bB][0-9A-Ba-b]{hex_digit}) | ([bB][cC][0-3])

hex_sep = "/" | "*" | "+"
token3 = "N-" ({hex} {hex_sep}){4} {hex} ( ({hex_sep} {hex}){2} )* " "* ";"

%%

// common
";"         {return symbol(sym.PV);}
"("         {return symbol(sym.RO);}
")"         {return symbol(sym.RC);}

// generics
"="         {return symbol(sym.EQ);}
"!"         {return symbol(sym.NOT);}
"&"         {return symbol(sym.AND);}
"|"         {return symbol(sym.OR);}

{comment}   {;}
{sep}       {return symbol(sym.SEP);}
{id}        {return symbol(sym.VAR, yytext());}
"IF"        {return symbol(sym.IF);}
"FI"        {return symbol(sym.FI);}
"DONE"      {return symbol(sym.DONE);}
"DO"        {return symbol(sym.DO);}
"PRINT"     {return symbol(sym.PRINT);}
"AND"       {return symbol(sym.ANDW);}
"OR"        {return symbol(sym.ORW);}
"FALSE"     {return symbol(sym.FALSE);}
"TRUE"      {return symbol(sym.TRUE);}



// TYPES
{quoteds}   {return symbol(sym.QUOTEDS, yytext() );}

{token1}    {return symbol(sym.TOK1);}
{token2}    {return symbol(sym.TOK2);}
{token3}    {return symbol(sym.TOK3);}



\r | \n | \r\n| " " | \t {;}

.           {System.out.println("Scanner error: " + yytext());}
