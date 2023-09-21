import java_cup.runtime.*;

%%

%class Lexer
%unicode
%cup
%line
%column


%{
	private Symbol symbol(int type) { return new Symbol(type, yyline, yycolumn);}
	private Symbol symbol(int type, Object value) { return new Symbol(type, yyline, yycolumn, value);}
%}


// IP
ip_num = (2(([0-4][0-9])|(5[0-5])))|(1[0-9][0-9])|([1-9][0-9])|([0-9])
ip = {ip_num}"."{ip_num}"."{ip_num}"."{ip_num}

int       = 0 | [1-9][0-9]*
real      = ("+" | "-")? ((0\.[0-9]*) | [1-9][0-9]*\.[0-9]* | \.[0-9]+ | [1-9][0-9]*\. | 0\.)
char = [a-zA-Z]

quoteds = \"[a-zA-Z \-]*\"

// =============================================================================================
sep         = "***"
comment     = "{{" (.*) "}}" 
end_token   = [ \t]* ";"
nl       = \r | \n | \r\n
inline_comment = "//" (.)* {nl}


// token1 ======================================================================================
hex = 27[A-Fa-f] | 2[8-9A-Fa-f][0-9A-Fa-f] | [3-9a-fA-F][0-9A-Fa-f][0-9A-Fa-f] | 1[0-1][0-9A-Fa-f][0-9A-Fa-f] | 12[0-9aA][0-9A-Fa-f] | 12b[0-3]
xstr = "Y" "X" "XX"* "Y"
token1 = {hex} "*" {char}{5} ({char} {char})* "-" (("**" ("**")+) | {xstr} )? {end_token}



// token2 ======================================================================================
rev_date10 = "2023" "/" (10)  "/" ( (0[5-9]) | (1[0-9]) | (2[0-9]) | (3[01]) )
rev_date11 = "2023" "/" (11)  "/" ( (0[1-9]) | (1[0-9]) | (2[0-9]) | (3[0 ]) )
rev_date12 = "2023" "/" (12)  "/" ( (0[1-9]) | (1[0-9]) | (2[0-9]) | (3[01]) )
rev_date1  = "2024" "/" (01)  "/" ( (0[1-9]) | (1[0-9]) | (2[0-9]) | (3[01]) )
rev_date2  = "2024" "/" (02)  "/" ( (0[1-9]) | (1[0-9]) | (2[0-9])           )
rev_date3  = "2024" "/" (03)  "/" ( (0[1-3]) )
rev_date = {rev_date1} | {rev_date2} | {rev_date3} | {rev_date10} | {rev_date11} | {rev_date12}
token2 = {ip} "-" {rev_date} {end_token}

// token2 ======================================================================================
num = [1-9][0-9]{3} ([0-9][0-9])?
numsep = "-" | "+"
token3 = ({num} {numsep}){2} {num}  (({numsep}{num}){2})? {end_token}

%%

// common
";"         {return symbol(sym.PV);}
","         {return symbol(sym.COMMA);}
"%"         {return symbol(sym.PERC);}
"-"         {return symbol(sym.MINUS);}
"euro"      {return symbol(sym.EURO);}


{comment}   		{;}
{inline_comment}    {;}

{sep}       {return symbol(sym.SEP);}
{int}       {return symbol(sym.INT, Integer.valueOf( yytext() ));}
{real}      {return symbol(sym.REAL, Double.valueOf( yytext() ));}
{quoteds}   {return symbol(sym.QUOTEDS, yytext() );}


{token1}    {return symbol(sym.TOK1);}
{token2}    {return symbol(sym.TOK2);}
{token3}    {return symbol(sym.TOK3);}

\r | \n | \r\n| " " | \t {;}
.           {System.out.println("Scanner error: " + yytext());}
