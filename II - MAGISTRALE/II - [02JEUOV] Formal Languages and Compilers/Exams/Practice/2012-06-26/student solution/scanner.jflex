import java_cup.runtime.*;

%%

%unicode
%cup
%line
%column

uint =(0 | (82[5-9]) | (8[3-9][0-9]) | (9[0-9][0-9]) | ([1-9]*([0-9]{3})*))
id = [a-zA-Z_][a-zA-Z0-9_]*
usercode = (([a-zA-Z]{3})([a-zA-Z])*)((\.)((1[2-9]) | ([2-9][0-9]) | (1[0-2][0-9]) | (13[0-2]))){2}(((\.)((1[2-9]) | ([2-9][0-9]) | (1[0-2][0-9]) | (13[0-2]))){2})*
// hexnum = [0-9a-fA-F]
real = ("+" | "-")? ((0\.[0-9]*) | [1-9][0-9]*\.[0-9]* | \.[0-9]+ | [1-9][0-9]*\. | 0\.)
qstring = \" ~  \"
token1 = ({date})
date = ((08\:31(\:1[2-9])?) | (08\:31(\:[2-5][0-9])?) | (08\:3[2-9](\:[0-5][0-9])?) | (08\:[4-5][0-9](\:[0-5][0-9])?) | (09\:[0-5][0-9](\:[0-5][0-9])?) | ([1-2]0\:[0-5][0-9](\:[0-5][0-9])?) | (1[0-9]\:[0-5][0-9](\:[0-5][0-9])?) | (2[1-2]\:[0-5][0-9](\:[0-5][0-9])?) | (23\:[0-1][0-9](\:[0-5][0-9])?) | (23\:20(\:[0-5][0-9])?) | (23\:21(\:0[0-9])?) | (23\:21(\:10)?))

token2 = ({sequence})({numberBetween})
sequence = ((X | Y){3})((X | Y){2})*
numberBetween = ((\-13[0-8]) | (-1[0-2][0-9]) | (-[1-9][0-9]) | (-[1-9]) | (0) | ([0-9]) | ([1-9][0-9]) | ([1-7][0-9][0-9]) | (8[0-1][0-9]) | (82[0-4]))

// comment = \(\+\+ (.*) \+\+\)
// sep = "==="
// nl = \r | \n | \r\n
// cpp_comment = "/-" ~ "-/"
// {sep} {return new Symbol(sym.SEP,yyline,yycolumn);}

%%
"*****" {return new Symbol(sym.DIVIDER,yyline,yycolumn);}
"Auction" {return new Symbol(sym.AUCTION_WD,yyline,yycolumn);}
"min" {return new Symbol(sym.MIN_WD,yyline,yycolumn);}
"->" {return new Symbol(sym.ARR_WD,yyline,yycolumn);}
"euro" {return new Symbol(sym.EURO_WD,yyline,yycolumn);}

{numberBetween} {return new Symbol(sym.NUM_BETWEEN,yyline,yycolumn);}
{token1} {return new Symbol(sym.TOK1,yyline,yycolumn);}
{token2} {return new Symbol(sym.TOK2,yyline,yycolumn);}
{uint} {return new Symbol(sym.UINT,yyline,yycolumn,new Integer(yytext()));}
{usercode} {return new Symbol(sym.USERCODE,yyline,yycolumn,new String(yytext()));}
{real} {return new Symbol(sym.REAL,yyline,yycolumn, new Double(yytext()));}
{qstring} {return new Symbol(sym.QSTRING,yyline,yycolumn,new String(yytext()));}
{id} {return new Symbol(sym.ID,yyline,yycolumn, new String(yytext()));}

":"         {return new Symbol(sym.COL,yyline,yycolumn);}
";"         {return new Symbol(sym.S,yyline,yycolumn);}
"."         {return new  Symbol(sym.DOT,yyline,yycolumn);}
","         {return new Symbol(sym.CM,yyline,yycolumn);}

// ALL INTRODUCED SYMBOLS NEED TO BE DECLARED AS TERMINALS INSIDE OF CUP FILE OTHERWISE YOU HAVE AN ERROR WHEN COMPILING WITH JAVAC
/*
"("         {return new Symbol(sym.RO,yyline,yycolumn);}
")"         {return new Symbol(sym.RC,yyline,yycolumn);}
"["         {return new Symbol(sym.SO,yyline,yycolumn);}
"]"         {return new Symbol(sym.SC,yyline,yycolumn);}
"{"         {return new Symbol(sym.BO,yyline,yycolumn);}
"}"         {return new Symbol(sym.BC,yyline,yycolumn);}
"="         {return new Symbol(sym.EQ,yyline,yycolumn);}
"=="        {return new Symbol(sym.EQEQ,yyline,yycolumn);}
"!="        {return new Symbol(sym.NEQ,yyline,yycolumn);}
"&&"        {return new Symbol(sym.AND,yyline,yycolumn);}
"||"        {return new Symbol(sym.OR,yyline,yycolumn);}
"!"         {return new Symbol(sym.NOT,yyline,yycolumn);}
"|"         {return new Symbol(sym.PIPE,yyline,yycolumn);}
"+"         {return new Symbol(sym.PLUS,yyline,yycolumn);}
"-"         {return new Symbol(sym.MINUS,yyline,yycolumn);}
"*"         {return new Symbol(sym.STAR,yyline,yycolumn);}
"/"         {return new Symbol(sym.DIV,yyline,yycolumn);}
"^"         {return new Symbol(sym.PWR,yyline,yycolumn);}
"<"         {return new Symbol(sym.MIN,yyline,yycolumn);}
">"         {return new Symbol(sym.MAJ,yyline,yycolumn);}
"`"         {return new Symbol(sym.BACKTICK,yyline,yycolumn);}
"~"         {return new Symbol(sym.TILDE,yyline,yycolumn);}
*/
//{cpp_comment} {;}
\r | \n | \r\n| " " | \t {;}

.           {System.out.println("Scanner error: " + yytext());}