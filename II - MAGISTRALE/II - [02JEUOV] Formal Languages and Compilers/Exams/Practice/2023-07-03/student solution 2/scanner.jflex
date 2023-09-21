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


sep = "$$$" "$$"*
comment = "<*" (.*) "*>" 
end_token = [ \t]* ";"
int       = 0 | [1-9][0-9]*

quoteds = \"[a-zA-Z \-]*\"

neg_num = "-" (1[0-8]) | ([1-9])
pos_num = [0-9] | [1-9][0-9] | 1[0-9][0-9] | 2[0-7][0-9] | 28[0-7]
num = {neg_num} | {pos_num}

date7  =  ( (0[2-9]) | (1[0-9]) | (2[0-9]) | (3[01]))  "/" (07 | "July")      "/" "2023"
date8  =  ( (0[1-9]) | (1[0-9]) | (2[0-9]) | (3[01]))  "/" (08 | "August")    "/" "2023"
date9  =  ( (0[1-9]) | (1[0-9]) | (2[0-9]) | (3[0] ))  "/" (09 | "September") "/" "2023"
date10 =  ( (0[1-6]) )  "/" (10 | "October")   "/" "2023"

rev_date7  = "2023" "/" (07 | "July")      "/" ( (0[2-9]) | (1[0-9]) | (2[0-9]) | (3[01]) )
rev_date8  = "2023" "/" (08 | "August")    "/" ( (0[1-9]) | (1[0-9]) | (2[0-9]) | (3[01]) )
rev_date9  = "2023" "/" (09 | "September") "/" ( (0[1-9]) | (1[0-9]) | (2[0-9]) | (3[0 ]) )
rev_date10 = "2023" "/" (10 | "October")   "/" ( (0[1-6]) )



date = {date7} | {date8} | {date9} | {date10} | {rev_date7} | {rev_date8} | {rev_date9} | {rev_date10}

hour7  = 07 ":" ([3-5][0-9]) (":" ( ([3][7-9] | [4-5][0-9]) ))?
hour8  = 08 ":" ([0-5][0-9]) (":" ([0-5][0-9]))?
hour9  = 09 ":" ([0-5][0-9]) (":" ([0-5][0-9]))?
hour10 = 10 ":" ([0-5][0-9]) (":" ([0-5][0-9]))?
hour11 = 11 ":" ([0-5][0-9]) (":" ([0-5][0-9]))?
hour12 = 12 ":" ([0-5][0-9]) (":" ([0-5][0-9]))?
hour13 = 13 ":" ([0-5][0-9]) (":" ([0-5][0-9]))?
hour14 = 14 ":" ([0-5][0-9]) (":" ([0-5][0-9]))?
hour15 = 15 ":" ([0-5][0-9]) (":" ([0-5][0-9]))?
hour16 = 16 ":" ([0-5][0-9]) (":" ([0-5][0-9]))?
hour17 = 17 ":" ([0-5][0-9]) (":" ([0-5][0-9]))?
hour18 = 18 ":" ([0-5][0-9]) (":" ([0-5][0-9]))?
hour19 = 19 ":" ([0-5][0-9]) (":" ([0-5][0-9]))?
hour20 = 20 ":" ([0-5][0-9]) (":" ([0-5][0-9]))?
hour21 = 21 ":" ([0-5][0-9]) (":" ([0-5][0-9]))?
hour22 = 22 ":" ([0-3][0-9]) (":" ([0-1][0-9] | 2[0-3]))?

hour = {hour7} | {hour8} | {hour9} | {hour10} | {hour11} | {hour12} | {hour13} | {hour14} | {hour15} | {hour16} | {hour17} | {hour18} | {hour19} | {hour20} | {hour21} | {hour22}

token1 = (("!!" "!!"+ {num} ) | "?????" "??"*) {end_token}
token2 = {date} {end_token}
token3 = {hour} {end_token}


%%

// common
";"         {return symbol(sym.PV);}
// ":"         {return symbol(sym.DD);}
","         {return symbol(sym.COMMA);}
"."         {return symbol(sym.DOT);}
"("         {return symbol(sym.RO);}
")"         {return symbol(sym.RC);}

// generics
"=="         {return symbol(sym.EQEQ);}

// common words
"end"		{return symbol(sym.END);}
"house"		{return symbol(sym.HOUSE);}
"start"		{return symbol(sym.STARTER);}
"if"		{return symbol(sym.IF);}
"fi"		{return symbol(sym.FI);}
"then"		{return symbol(sym.THEN);}
"true"		{return symbol(sym.TRUE);}
"false"		{return symbol(sym.FALSE);}
"print"		{return symbol(sym.PRINT);}
"and"		{return symbol(sym.AND);}
"or"		{return symbol(sym.OR);}
"not"		{return symbol(sym.NOT);}

{comment}   {;}
{sep}       {return symbol(sym.SEP);}

// TYPES
{int}       {return symbol(sym.INT, Integer.valueOf( yytext() ));}
{quoteds}   {return symbol(sym.QUOTEDS, yytext() );}

{token1}    {return symbol(sym.TOK1);}
{token2}    {return symbol(sym.TOK2);}
{token3}    {return symbol(sym.TOK3);}



\r | \n | \r\n| " " | \t {;}

.           {System.out.println("Scanner error: " + yytext());}
