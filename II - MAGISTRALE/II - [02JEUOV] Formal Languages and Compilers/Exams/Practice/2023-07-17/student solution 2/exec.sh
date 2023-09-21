#!/bin/bash

inputfile="test.txt"
scanner="Lexer.java"

runtime=$(date +'%H:%M:%S')
echo "===================== ${runtime} =====================                     <-----------"

jflex scanner.jflex && echo =================== COMPILAZIONE =================== && java java_cup.MainDrawTree parser.cup && javac *.java && java Main $inputfile

rm -f ./parser.java   2> /dev/null
rm -f ./parser.class  2> /dev/null
rm -f ./scanner.java  2> /dev/null
rm -f ./scanner.class 2> /dev/null
rm -f ./sym.java      2> /dev/null
rm -f ./Lexer.java    2> /dev/null
rm -f ./*.java~       2> /dev/null
rm -f ./*.class       2> /dev/null
