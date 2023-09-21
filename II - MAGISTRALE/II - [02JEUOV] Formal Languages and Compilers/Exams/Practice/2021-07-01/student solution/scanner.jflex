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

hour = ((03\:51\:4[7-9]) | (03\:5[2-9]\:[0-5][0-9]) | ([0-1][0-9]\:[0-5][0-9]\:[0-5][0-9]) | (2[0-2]\:[0-5][0-9]\:[0-5][0-9]) | (23\:[0-3][0-9]\:[0-5][0-9]) | (23\:4[0-4]\:[0-5][0-9]) | (23\:45\:([0-2][0-9] | 3[0-4])))

sep = "####"
comment = "(*" (.*) "*)" 

int       = 0 | [1-9][0-9]*
real      = ("+" | "-")? ((0\.[0-9]*) | [1-9][0-9]*\.[0-9]* | \.[0-9]+ | [1-9][0-9]*\. | 0\.)
quoteds = \"[a-zA-Z ]*\"

bin = (101) | (11(0|1)) | (1(0|1){3,5}) | (100 (0|1){4}) | (1010001) 

token1 = "X-" {hour} ( ("aa" | "ab" | "ba" | "bb"){5} (("aa" | "ab" | "ba" | "bb"){2})* )? [\t ]* ";"
token2 = "Y-" (({bin}"-"){3} | ({bin}"-"){122} ) {bin} [\t ]* ";"


%%

// common
";"         {return symbol(sym.PV);}
","         {return symbol(sym.COMMA);}
":"         {return symbol(sym.DD);}
"{"         {return symbol(sym.BO);}
"}"         {return symbol(sym.BC);}

{comment}   {;}
{sep}       {return symbol(sym.SEP);}

// TYPES
{int}       {return symbol(sym.INT, Integer.valueOf( yytext() ));}
{real}      {return symbol(sym.REAL, Double.valueOf( yytext() ));}
{quoteds}   {return symbol(sym.QUOTEDS, yytext() );}
"euro/kg"   {return symbol(sym.EUROKG);}
"euro"      {return symbol(sym.EURO);}
"kg"        {return symbol(sym.KG);}

{token1}    {return symbol(sym.TOK1);}
{token2}    {return symbol(sym.TOK2);}



\r | \n | \r\n| " " | \t {;}

.           {System.out.println("Scanner error: " + yytext());}
