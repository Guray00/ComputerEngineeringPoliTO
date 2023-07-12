import java_cup.runtime.*;

%%

%unicode
%cup
%line
%column


uint = 0 | [1-9][0-9]*
id = [a-zA-Z_][a-zA-Z0-9_]*
// hexnum = [0-9a-fA-F]
// real = ("+" | "-")? ((0\.[0-9]*) | [1-9][0-9]*\.[0-9]* | \.[0-9]+ | [1-9][0-9]*\. | 0\.)
// qstring = \" ~  \"
comment = \(\+\+ (.*) \+\+\)
token1 = ({letters}#({hexNum})?)
letters = ((a | b | c){7}((a | b | c){2})*)
hexNum = ((\-5[aAcC]) | (\-[1-4][02468aAcC]) | (\-[2468aAcC]) | (2468aAcC) | ([1-9a-fA-F][02468aAcCeE]) | ([1-9][0-9a-fA-F][02468aAcCeE]) | ([aA][0-9aA][02468aAcCeE]) | ([aA][bB][246]))

token2 = (({hour})\:({binNum}))
hour = ((07\:13\:2[4-9]) | (07\:13\:[3-5][0-9]) | (07\:1[4-5]\:[0-5][0-9]) | (07\:[2-5][0-9]\:[0-5][0-9]) | (0[8-9]\:[0-5][0-9]\:[0-5][0-9]) | (1[0-6]\:[0-5][0-9]\:[0-5][0-9]) | (17\:[0-2][0-9]\:[0-5][0-9]) | (17\:3[0-6]\:[0-5][0-9]) | (17\:37\:[0-3][0-9]) | (17\:37\:4[0-3]))
binNum = ((101) | (1[0-1][0-1][0-1]) | (10[0-1][0-1][0-1]) | (110[0-1][0-1]) | (1100[0-1]) | (11010))
// 11010
// comment = \(\+\+ (.*) \+\+\)
// sep = "==="
// nl = \r | \n | \r\n
// cpp_comment = "/-" ~ "-/"
// {sep} {return new Symbol(sym.SEP,yyline,yycolumn);}
// {qstring} {return new Symbol(sym.QSTRING,yyline,yycolumn,new String(yytext()));}
// {real} {return new Symbol(sym.REAL,yyline,yycolumn, new Double(yytext()));}

%%
"$$" {return new Symbol(sym.DIVIDER,yyline,yycolumn);}
"compare" {return new Symbol(sym.COMPARE_WD,yyline,yycolumn);}
"with" {return new Symbol(sym.WITH_WD,yyline,yycolumn);}
"end" {return new Symbol(sym.END_WD,yyline,yycolumn);}

{token1} {return new Symbol(sym.TOK1,yyline,yycolumn);}
{token2} {return new Symbol(sym.TOK2,yyline,yycolumn);}
";"         {return new Symbol(sym.S,yyline,yycolumn);}
","         {return new Symbol(sym.CM,yyline,yycolumn);}
":"         {return new Symbol(sym.COL,yyline,yycolumn);}
"="         {return new Symbol(sym.EQ,yyline,yycolumn);}
"("         {return new Symbol(sym.RO,yyline,yycolumn);}
")"         {return new Symbol(sym.RC,yyline,yycolumn);}
"+"         {return new Symbol(sym.PLUS,yyline,yycolumn);}
"-"         {return new Symbol(sym.MINUS,yyline,yycolumn);}
"*"         {return new Symbol(sym.STAR,yyline,yycolumn);}
"/"         {return new Symbol(sym.DIV,yyline,yycolumn);}
"{"         {return new Symbol(sym.BO,yyline,yycolumn);}
"}"         {return new Symbol(sym.BC,yyline,yycolumn);}
"print"     {return new Symbol(sym.PRINT_WD,yyline,yycolumn);}
{uint} {return new Symbol(sym.UINT,yyline,yycolumn,new Integer(yytext()));}
{id} {return new Symbol(sym.ID,yyline,yycolumn,new String(yytext()));}

/*
// ALL INTRODUCED SYMBOLS NEED TO BE DECLARED AS TERMINALS INSIDE OF CUP FILE OTHERWISE YOU HAVE AN ERROR WHEN COMPILING WITH JAVAC
"."         {return new  Symbol(sym.DOT,yyline,yycolumn);}
","         {return new Symbol(sym.CM,yyline,yycolumn);}
":"         {return new Symbol(sym.COL,yyline,yycolumn);}

"["         {return new Symbol(sym.SO,yyline,yycolumn);}
"]"         {return new Symbol(sym.SC,yyline,yycolumn);}

"=="        {return new Symbol(sym.EQEQ,yyline,yycolumn);}
"!="        {return new Symbol(sym.NEQ,yyline,yycolumn);}
"&&"        {return new Symbol(sym.AND,yyline,yycolumn);}
"||"        {return new Symbol(sym.OR,yyline,yycolumn);}
"!"         {return new Symbol(sym.NOT,yyline,yycolumn);}
"|"         {return new Symbol(sym.PIPE,yyline,yycolumn);}

"^"         {return new Symbol(sym.PWR,yyline,yycolumn);}
"<"         {return new Symbol(sym.MIN,yyline,yycolumn);}
">"         {return new Symbol(sym.MAJ,yyline,yycolumn);}
"`"         {return new Symbol(sym.BACKTICK,yyline,yycolumn);}
"~"         {return new Symbol(sym.TILDE,yyline,yycolumn);}

*/
//{cpp_comment} {;}
\r | \n | \r\n| " " | \t {;}
{comment} {System.out.println("comment found > " + yytext());}
.           {System.out.println("Scanner error: " + yytext());}