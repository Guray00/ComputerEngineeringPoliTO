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

sep = "$$"("$$")+
comment = "(*-" (.*) "-*)"

// parte in cui recupero 2-3-6 cifre hex con il separatore
hex     = [0-9a-fA-F]+
real    = ("+" | "-")? ((0\.[0-9]*) | [1-9][0-9]*\.[0-9]* | \.[0-9]+ | [1-9][0-9]*\. | 0\.)
int     = 0 | [1-9][0-9]*

first_part = ("%*" | "*%" | "%%"){6,17}
second_part = ({hex}{2} | {hex}{3} | {hex}{6})
third_part = {second_part}("+"{second_part}){1,2} | {second_part}("+"{second_part}){5}
token1 = {first_part}{third_part} " "* ";"

rev_date1 = "2023"  \/ (01 | "January")  \/ (([0-2][1-9]) | ([12]0) | (3[01]))
rev_date2 = "2023"  \/ (02 | "February") \/ ([0-1][1-9] | [12]0 | 2[1-8])
rev_date3 = "2023"  \/ (03 | "March")    \/ (([0-2][1-9]) | ([12]0) | (3[01]))

rev_date11 = "2022" \/ (11 | "November") \/ (([0-2][1-9]) | ([12]0) | (3[0]))
rev_date12 = "2022" \/ (12 | "December") \/ ([0-2][1-9] | [12]0 | 3[01])

date = {rev_date1} | {rev_date2} | {rev_date3} | {rev_date11} | {rev_date12}
exclude_dates = 2023\/02\/14 | 2022\/12\/13 | 2023\/03\/31

token2 = {date}[$%]{date}[$%]{date}(-(1011 | 11(0|1){2}(0|1)?))? " "* ";"

quoteds = \"[a-zA-Z ]*\"

%%


","         {return symbol(sym.COMMA);}
"."         {return symbol(sym.DOT);}
{comment}       {;}
{sep}           {return symbol(sym.SEP);}
{token1}        {return symbol(sym.TOK1);}
{exclude_dates} {;}
{token2}        {return symbol(sym.TOK2);}
{quoteds}       {return symbol(sym.QUOTEDS, new String(yytext()));}
{real}          {return symbol(sym.REAL, Double.valueOf(yytext()));}
{int}           {return symbol(sym.INT, Integer.valueOf(yytext()));}

"EURO/kg"       {return symbol(sym.EUROKG);}
"kg"            {return symbol(sym.KG);}
"["             {return symbol(sym.SO);}
"]"             {return symbol(sym.SC);}
";"             {return symbol(sym.PV);}
":"             {return symbol(sym.DD);}

\r | \n | \r\n| " " | \t {;}
.           {System.out.println("Scanner error: " + yytext());}
