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

// EMAIL
email = ([a-zA-Z0-9_\.])+"@"([a-zA-Z])+"."([a-zA-Z])+

sep = "$$$"
comment = "{++" (.*) "++}" 
end_token = [ \t]* ";"
letter = [a-aA-F]

id = [a-z][a-zA-Z0-9]* 
quoteds = \"[a-zA-Z ]*\"

neg_oct = "-" (  (1[0-2][0-7]) | ([1-7][0-7]) | ([0-7])   )

oct = ( {neg_oct} | [0-7] | [1-7][0-7]) | (1[0-7][0-7]) | (2[0-7][0-7]) | (3[01][0-7]) | (32[0-3])

rep = ("xx" | "yy" | "zz")
token1 = "?" {letter}{6} ({letter}{letter})? {oct} ({rep}{3} {rep}+)? {end_token}

email_sep = {email} ("!" | "/")
token2 = ({email_sep} | {email_sep}{11} | {email_sep}{14}) {email} {end_token}

token3 = "tk3" {end_token}


%%

// common
";"         {return symbol(sym.PV);}
","         {return symbol(sym.COMMA);}
"("         {return symbol(sym.RO);}
")"         {return symbol(sym.RC);}

// generics
"="         {return symbol(sym.EQ);}
"["         {return symbol(sym.SO);}
"]"         {return symbol(sym.SC);}

// common words
"print"		{return symbol(sym.PRINT);}
"CMP"       {return symbol(sym.CMP);}
"WITH"		{return symbol(sym.WITH);}
"T"		    {return symbol(sym.TRUE);}
"F"		    {return symbol(sym.FALSE);}
"NOT"		{return symbol(sym.NOT);}
"AND"		{return symbol(sym.AND);}
"OR"    	{return symbol(sym.OR);}
"fz_and"    {return symbol(sym.FZ_AND);}

{comment}   {;}
{sep}       {return symbol(sym.SEP);}
{id}        {return symbol(sym.VAR, yytext() );}

// TYPES
{quoteds}   {return symbol(sym.QUOTEDS, yytext() );}

{token1}    {return symbol(sym.TOK1);}
{token2}    {return symbol(sym.TOK2);}
{token3}    {return symbol(sym.TOK3);}



\r | \n | \r\n| " " | \t {;}

.           {System.out.println("Scanner error: " + yytext());}
