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


/*id = [a-zA-Z_][a-zA-Z0-9_]*
word = [a-zA-Z]+*/

//numbers
/*number = [0-9]+
numberNonZero = [1-9][0-9]* */
uint = 0 | [1-9][0-9]*  /* //unsigned int
hexnum = [0-9a-fA-F] //hex value (single) */
realnum = ("+"|"-")? [0-9]+ ("." [0-9]+ ((e|E)("+"|"-")[0-9]+)? )?  //real number (signed int or float with exponent)
//time
/* date = ((0[1-9])|([1-2][0-9])|(3(0|1)))"/"((0[1-9])|(1(0|1|2)))"/"(2[0-9][0-9][0-9])
hour = (((0|1)[0-9])|(2[0-3]))":"([0-5][0-9])
timeAmPm = ((0[0-9])|(1[0-2]))":"([0-5][0-9]) ("am"|"pm")? */

//ip
ip_num = (2(([0-4][0-9])|(5[0-5])))|(1[0-9][0-9])|([1-9][0-9])|([0-9])
ip = {ip_num}"."{ip_num}"."{ip_num}"."{ip_num}

//email
email = ([a-zA-Z0-9_\.])+"@"([a-zA-Z])+"."([a-zA-Z])+
file = [a-zA-Z][a-zA-Z0-9]*"."[a-zA-Z]{3}

//various
nl = \r|\n|\r\n //newline or carriage return
ws = [ \t] //whitespace or indentation
qstring = \" ~ \"
comment_multiline = ("{{" ~ "}}")  //multiline comments, equals to ("/*" ~ "*/")
comment_singleline = ("//" ~ {nl}) //from '//' to newline

//separator
separator = "***"

/* 4 to 15 repetitions are written this way {4,15} */

/* EX date range between 03/09/2021 and 05/03/2022
date = (
    (0[3-9] | [12][0-9] | 30) "/" 09 "/" 2021
    |(0[1-9] | [12][0-9] | 3[0-1]) "/" (10 | 12) "/" 2021
    |(0[1-9] | [12][0-9] | 30) "/" 11 "/" 2021
    |(0[1-9] | [12][0-9] | 3[0-1]) "/" 01 "/" 2022
    |(0[1-9] | 1[0-9] | 2[0-8]) "/" 02 "/" 2022
    |0[1-5] "/" 03 "/" 2022
) */

/* EX hour range: between 07:39:19 and 22:39:23
hour = ( 07 ":" 3[7-9] ":" (19 | [2-5][0-9])
    | 07 ":" [45][0-9] ":" [0-5][0-9]
    | 0[89] ":" (0[0-9] | [1-5][0-9]) ":" (0[0-9] | [1-5][0-9])
    | 1[0-9] ":" (0[0-9] | [1-5][0-9]) ":" (0[0-9] | [1-5][0-9])
    | 2[01] ":" (0[0-9] | [1-5][0-9]) ":" (0[0-9] | [1-5][0-9])
    | 22 ":" (0[0-9] | [1-2][0-9] | 3[0-8]) ":" (0[0-9] | [1-5][0-9])
    | 22 ":" 39 ":" (0[0-9] | 1[0-9] | 2[0-3])
)
|
( 07 ":" 3[7-9]
    | 07 ":" [45][0-9]
    | 0[89] ":" (0[0-9] | [1-5][0-9])
    | 1[0-9] ":" (0[0-9] | [1-5][0-9])
    | 2[01] ":" (0[0-9] | [1-5][0-9])
    | 22 ":" (0[0-9] | [1-2][0-9] | 3[0-9])
) */ 

//EX bin between 101 1011011
/* bin = ((101) | (110) | (111)
    | (11[01]) 
    | ([01][01][01][01]) 
    | ([01][01][01][01][01]) 
    | ([01][01][01][01][01][01]) 
    | (0[01][01][01][01][01][01]) 
    | (100[01][01][01])
    | (1010[01][01][01]) 
    | (10110[01][01])) */

//token1
token1 = ((({hex} "*") ({alpha} "-"))) (({star_yxy})?)

star_yxy = ({yxy} |{odd_star})
odd_star = (("****")("**")*)
yxy = ("Y" {x_char} "Y")
x_char = (("X")("XX")*)

hex = (27[BbDdFf] | 2[7-9a-fA-F][13579BbDdFf]
      | [3-9a-fA-F][0-9a-fA-F][13579BbDdFf]
      | 1[01][0-9a-fA-F][13579BbDdFf]
      | 12[0-9aA][13579BbDdFf]
      | 12b[13])

alpha = ((([a-zA-Z]){5}) (([a-zA-Z])*))
//token2
token2 = ({ip} "-" {date})

date = (0[5-9] \/10\/2023)|  ([12][0-9] \/1[012]\/2023)
       | (0[1-9] \/1[12]\/2023) | (30 \/ 1[012] \/ 2023)
       |(31\/1[02]\/2023) | (0[1-9] \/01\/2024)
       |([12][0-9] \/0[012]\/2024)
       | (0[123] \/ 03 \/ 2024)

//token3
token3 = ((({digits}("-"|"+")){2}){digits}) |((({digits}("-"|"+")){4})({digits}))

digits = ([0-9][0-9][0-9][0-9]) | ([0-9][0-9][0-9][0-9][0-9][0-9])
 

%%
/*
UNCOMMENT WHAT YOU NEED 

"("     {return symbol(sym.RO);}
")"     {return symbol(sym.RC);}
"["     {return symbol(sym.SO);}
"]"     {return symbol(sym.SC);}
"{"     {return symbol(sym.BO);}
"}"     {return symbol(sym.BC);}

"="     {return symbol(sym.EQ);}
"+"     {return symbol(sym.PLUS);}
"-"     {return symbol(sym.MINUS);}
"*"     {return symbol(sym.STAR);}
"/"     {return symbol(sym.DIV);}
"^"		{return symbol(sym.EXP);}
"~"		{return symbol(sym.TILDE);}

"<"     {return symbol(sym.MIN);}
">"     {return symbol(sym.MAJ);}
"<="    {return symbol(sym.MIN_EQ);}
"=<"    {return symbol(sym.MIN_EQ);}
">="    {return symbol(sym.MAJ_EQ);}
"=>"    {return symbol(sym.MAJ_EQ);}

"&"     {return symbol(sym.AND);}
"|"     {return symbol(sym.OR);}
"!"     {return symbol(sym.NOT);}
"AND"     {return symbol(sym.AND);}
"OR"     {return symbol(sym.OR);}
"NOT"     {return symbol(sym.NOT);}

","	{return symbol(sym.CM);}
"." {return symbol(sym.DOT);}
":" {return symbol(sym.DD);}

"int"   {return symbol(sym.INT_TYPE);}
"print" {return symbol(sym.PRINT);}

{number} {return symbol(sym.CONST, new Integer( yytext()));}
{realnum} {return symbol(sym.REAL, new Double( yytext()));}
{word} {return symbol(sym.CONST, yytext());}

"m" {return symbol(sym.MWORD);}

*/
"%" {return symbol(sym.PERC);}
";"	{return symbol(sym.S);}
","	{return symbol(sym.CM);}
"-"     {return symbol(sym.MINUS);}
"euro"	{return symbol(sym.EUROWORD);}
{uint} {return symbol(sym.INT, new Integer( yytext()));}

{realnum} {return symbol(sym.REAL, new Double( yytext()));}
{qstring} {return symbol(sym.QSTRING, new String(yytext()));}
{token1} { return symbol(sym.TOK1);}
{token2} {return symbol(sym.TOK2);}
{token3} {return symbol(sym.TOK3);}
{separator} {return symbol(sym.SEP);}

//put ID here for priority, otherwise it will use it instead of specific words (es "double") or other stuff (es {word})
//{id} {return symbol(sym.VAR, new String(yytext()));}

{nl} | {ws} | {comment_multiline} | { comment_singleline}     {;}
. {System.out.println("SCANNER ERROR: "+yytext());} //if i read this it means I missed something