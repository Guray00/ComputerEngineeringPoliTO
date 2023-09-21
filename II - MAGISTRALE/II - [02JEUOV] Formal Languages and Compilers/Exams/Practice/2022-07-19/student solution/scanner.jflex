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


sep     = "%%"("%%")+
comment = "(((-" (.*) "-)))" | "---"[ \ta-zA-Z0-9.,]*

real     = ("+" | "-")? ((0\.[0-9]*) | [1-9][0-9]*\.[0-9]* | \.[0-9]+ | [1-9][0-9]*\. | 0\.)

bin = (1*01*01*) | (1*01*01*01*01*01*)
second_part = ("+" ("*+")*  "*"?) | ("*" ("+*")*  "+"?)

token1 = "A_" ({bin} | ({second_part})?) (" " | \t)* ";"

tk2sep = "$" | "*" | "+"
pos_word = (( ([1-9]?[1-9]?) | (11[0-9]))(2 | 4 | 6 | 8 | 0)) | (12[0-4](0 | 2 | 4 | 6))
neg_word = (-[1-9]) | (-[1-3][0-9]) | (-[4][0-2])
token2 = "B_" ( ({pos_word} {tk2sep}) | ({neg_word} {tk2sep}) ){3} ( ({pos_word} {tk2sep}) | ({neg_word} {tk2sep}) )* ({pos_word} | {neg_word}) (" " | \t)* ";"

%%

// common
";"         {return symbol(sym.PV);}
","         {return symbol(sym.COMMA);}
"("         {return symbol(sym.RO);}
")"         {return symbol(sym.RC);}

// generics
"-"         {return symbol(sym.MINUS);}
"START"		    {return symbol(sym.STARTER);}
"BATTERY"		{return symbol(sym.BATTERY);}
"liters"		{return symbol(sym.LITERS);}
"FUEL"		    {return symbol(sym.FUEL);}
"kWh"		    {return symbol(sym.KWH);}
"MAX"		    {return symbol(sym.MAX);}
"PLUS"          {return symbol(sym.PLUS);}
"STAR"          {return symbol(sym.STAR);}
"DO"          {return symbol(sym.DO);}
"units/km"          {return symbol(sym.UNITSKM);}
"km"          {return symbol(sym.KM);}
"MOD"          {return symbol(sym.MOD);}
"USE"          {return symbol(sym.USE);}
"DONE"          {return symbol(sym.DONE);}

{comment}   {;}
{sep}       {return symbol(sym.SEP);}
{real}      {return symbol(sym.REAL, Double.valueOf( yytext() ));}

{token1}    {return symbol(sym.TOK1);}
{token2}    {return symbol(sym.TOK2);}
// "."         {return symbol(sym.DOT);}


\r | \n | \r\n| " " | \t {;}

.           {System.out.println("Scanner error: " + yytext());}
