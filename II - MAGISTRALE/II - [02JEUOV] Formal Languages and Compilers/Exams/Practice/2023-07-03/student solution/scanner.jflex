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
separator = "$$$"("$$")*
comment="<*" ~ "*>"
qstring = \" ~ \"
posint= 0|[1-9][0-9]*



hour1 = 07":"37":"19|07":"37":"[2-5][0-9]|07":"3[89]":"[0-5][0-9]|07":"[45][0-9]":"[0-5][0-9]
hour2 = 0[89]":"[0-5][0-9]":"[0-5][0-9]
hour3 = 1[0-9]":"[0-5][0-9]":"[0-5][0-9]
hour4 = 2[01]":"[0-5][0-9]":"[0-5][0-9]
hour5 = 22":"[0-2][0-9]":"[0-5][0-9]|22":"3[0-8]":"[0-5][0-9]|22":"39":"[01][0-9]|22":"39":"2[0-3]
hour6 = 07":"3[789]|07":"[45][0-9]|0[89]":"[0-5][0-9]|1[0-9]":"[0-5][0-9]|2[01]":"[0-5][0-9]|22":"[0-3][0-9]
hour = {hour1}|{hour2}|{hour3}|{hour4}|{hour5}|{hour6}


date1 = 0[2-9]"/"07"/"2023|[12][0-9]"/"07"/"2023|3[01]"/"07"/"2023|2023"/"07"/"0[2-9]|2023"/"07"/"[12][0-9]|2023"/"07"/"3[01]
date2 = 0[1-9]"/"08"/"2023|[12][0-9]"/"08"/"2023|3[01]"/"08"/"2023|2023"/"08"/"0[1-9]|2023"/"08"/"[12][0-9]|2023"/"08"/"3[01]
date3 = 0[1-9]"/"09"/"2023|[12][0-9]"/"09"/"2023|30"/"09"/"2023|2023"/"09"/"0[1-9]|2023"/"09"/"[12][0-9]|2023"/"09"/"30
date4 = 0[1-6]"/"07"/"2023|2023"/"07"/"0[1-6]
date = {date1}|{date2}|{date3}|{date4}

evenum = "-"1[02468]|"-"?[02468]|[1-9][02468]|1[0-9][02468]|2[0-7][02468]|28[0246]

token1 = [\!]{4}[\!]{2}{evenum}" "*";"|[\?]{5}[\?]{2}" "*";"

token2 = {date}" "*";"

token3 = {hour}" "*";"



%%


{token3}	{return symbol(sym.TOK3);}
{token2}	{return symbol(sym.TOK2);}
{token1}	{return symbol(sym.TOK1);}
{separator}	{return symbol(sym.SEP);}
{posint}	{return symbol(sym.INT, Integer.parseInt(yytext()));}
{qstring}	{return symbol(sym.QSTRING, new String(yytext()));}		
"house"		{return symbol(sym.HOUSE);}	
"start"		{return symbol(sym.STRT);}
"end"		{return symbol(sym.END);}
"if"		{return symbol(sym.IF);}
"then"		{return symbol(sym.THEN);}
"fi"		{return symbol(sym.FI);}
"and"		{return symbol(sym.AND);}
"or"		{return symbol(sym.OR);}
"not"		{return symbol(sym.NOT);}
"print"		{return symbol(sym.PRINT);}
	
","	    {return symbol(sym.CM);}
"."		{return symbol(sym.DOT);}
"("    	{return symbol(sym.RO);}
")"    	{return symbol(sym.RC);}
"=="	{return symbol(sym.EQUAL);}
";"   	{return symbol(sym.S);}



{comment}		{;}
{ws}|{nl}|" "   	{;}
. {System.out.println("SCANNER ERROR: "+yytext());}
