import java_cup.runtime.*;

%%

%unicode
%cup
%line
%column

divider = ((####) | (######))
token1 = ((\%){5}(((\%){2})*) | ({reptok1}))({oddNum})?
reptok1 = (((\*\*){2,3}) | (\?\?\?){2,3} | ((\*\*)(\?\?\?)) | ((\?\?\?)(\*\*)) | ((\?\?\?)((\*\*){2})) | (((\?\?\?){2})(\*\*)) | ((\*\*)(\?\?\?)(\*\*)) | ((\?\?\?)(\*\*)(\?\?\?)))
oddNum = ((\-3[135]) | (\-1-2[13579]) | (\-[13579]) | ([13579]) | ([1-9][13579]) | ([1-2][0-9][13579]) | (3[0-2][13579]) | (33[13]))


token2 = (({date})(\- | \+)({date}))
date = ((2015\/12\/1[2-9]) | (2015\/12\/2[0-9]) | (2015\/12\/3[01]) | (2016\/01\/0[1-4]) | (2016\/01\/0[6-9]) | (2016\/01\/1-2[0-9]) | (2016\/01\/3[0-1]) | (2016\/0[2-3]\/0[1-9]) | (2016\/0[2-3]\/2[0-9]) | (2016\/03\/0[1-9]) | (2016\/03\/1[1-3]) )

token3 = \$({bin})
bin = ((101) | (11[0-1]) | (1[0-1][0-1][0-1]) | (1[0-1][0-1][0-1][0-1]) | (100[0-1][0-1][0-1]) | (101000))
uint = 0 | [1-9][0-9]*
// id = [a-zA-Z_][a-zA-Z0-9_]*
// hexnum = [0-9a-fA-F]
// real = ("+" | "-")? ((0\.[0-9]*) | [1-9][0-9]*\.[0-9]* | \.[0-9]+ | [1-9][0-9]*\. | 0\.)
qstring = \" ~  \"

// comment = \(\+\+ (.*) \+\+\)
// sep = "==="
// nl = \r | \n | \r\n
// cpp_comment = "/-" ~ "-/"
// {sep} {return sym(sym.SEP,yyline,yycolumn);}
// {real} {return sym(sym.REAL,yyline,yycolumn, new Double(yytext()));}

%%
"//".* {;}
"m/s" {return new Symbol(sym.MEASURE,yyline,yycolumn);}
"m" {return new Symbol(sym.M_CHAR,yyline,yycolumn);}
"PRINT_MIN_MAX" {return new Symbol(sym.PRINT_WD,yyline,yycolumn);}
"PART" {return new Symbol(sym.PART_WD,yyline,yycolumn);}
{qstring} {return new Symbol(sym.QSTRING,yyline,yycolumn,new String(yytext()));}
{uint} {return new Symbol(sym.UINT,yyline,yycolumn,new Integer(yytext()));}

{token1} {return new Symbol(sym.TOK1,yyline,yycolumn);}
{token2} {return new Symbol(sym.TOK2,yyline,yycolumn);}
{token3} {return new Symbol(sym.TOK3,yyline,yycolumn);}
";"         {return new Symbol(sym.S,yyline,yycolumn);}
{divider}   {return new Symbol(sym.DIVIDER,yyline,yycolumn);}
"{"         {return new Symbol(sym.BO,yyline,yycolumn);}
"}"         {return new Symbol(sym.BC,yyline,yycolumn);}
"="         {return new Symbol(sym.EQ,yyline,yycolumn);}
","         {return new Symbol(sym.CM,yyline,yycolumn);}
"->" {return new Symbol(sym.ARROW,yyline,yycolumn);}
"("         {return new Symbol(sym.RO,yyline,yycolumn);}
")"         {return new Symbol(sym.RC,yyline,yycolumn);}
"|"         {return new Symbol(sym.PIPE,yyline,yycolumn);}
":"         {return new Symbol(sym.COL,yyline,yycolumn);}

// ALL INTRODUCED SYMBOLS NEED TO BE DECLARED AS TERMINALS INSIDE OF CUP FILE OTHERWISE YOU HAVE AN ERROR WHEN COMPILING WITH JAVAC
/*
"."         {return new  Symbol(sym.DOT,yyline,yycolumn);}
"["         {return new Symbol(sym.SO,yyline,yycolumn);}
"]"         {return new Symbol(sym.SC,yyline,yycolumn);}
"=="        {return new Symbol(sym.EQEQ,yyline,yycolumn);}
"!="        {return new Symbol(sym.NEQ,yyline,yycolumn);}
"&&"        {return new Symbol(sym.AND,yyline,yycolumn);}
"||"        {return new Symbol(sym.OR,yyline,yycolumn);}
"!"         {return new Symbol(sym.NOT,yyline,yycolumn);}
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
.       {System.out.println("Scanner error: " + yytext());}