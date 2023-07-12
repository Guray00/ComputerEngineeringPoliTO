/**************************
 Scanner
***************************/

import java_cup.runtime.*;

%%

%class scanner
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

nl = \r|\n|\r\n
ws = [ \t]
separator = "$$$$"("$$")*
comment = "(*-"~"-*)"

word1 = "%*"|"*%"|"%%"
hex1 = ([A-F]|[a-f]|[0-9]){2}|([A-F]|[a-f]|[0-9]){3}|([A-F]|[a-f]|[0-9]){6}
token1 = {word1}{6,17}(({hex1}\+){2}|({hex1}\+){5}){hex1}" "*";"


token2 = ({date}[\$\%]){2}{date}(-{binary})*" "*";"
date = {november}|{december}|{january}|{february}|{march}
november = 2022"/"11"/"1[5-9]|2022"/"11"/"2[0-9]|2022"/"11"/"30
december = 2022"/"12"/"0[0-9]|2022"/"12"/"1[0-2]|2022"/"12"/"1[4-9]|2022"/"12"/"2[0-9]|2022"/"12"/"3[01]
january = 2023"/"01"/"[0-2][0-9]|2023"/"01"/"3[01]
february = 2023"/"02"/"0[0-9]|2023"/"02"/"1[0-3]|2023"/"02"/"1[5-9]|2023"/"02"/"2[0-8]
march = 2023"/"03"/"[0-2][0-9]|2023"/"03"/"30
binary = 1011|11[01]{2}|10[01]{3}
qstring = \" ~ \"
integ = (0|[1-9][0-9]*)
real =  [0-9]+\.[0-9]{2}
w = [0-9]+\.[0-9]+

//varName=[a-zA-Z_][a-zA-Z0-9_]*

%%

{token2}	  {return symbol(sym.TOK2);}
{token1}	  {return symbol(sym.TOK1);}
{separator}	{return symbol(sym.SEP);}
{integ}		  {return symbol(sym.INT, Integer.parseInt(yytext()));}
{real}		  {return symbol(sym.REAL, Float.parseFloat(yytext()));}
{w}		      {return symbol(sym.WEIGHT, Float.parseFloat(yytext()));}
{qstring}	  {return symbol(sym.QSTRING, new String(yytext()));}
"kg" 		    {return symbol(sym.KG);}
"EURO/kg"	  {return symbol(sym.EKG);}

"."		      {return symbol(sym.DOT);}
":"		      {return symbol(sym.DD);}
"["         {return symbol(sym.SO);}
"]"         {return symbol(sym.SC);}	
","	        {return symbol(sym.CM);}
";"    	    {return symbol(sym.S);}

{comment}		{;}
{ws}|{nl}|" "   	{;}
.           {System.out.println("SCANNER ERROR: "+yytext());}
