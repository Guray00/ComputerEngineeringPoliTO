@ECHO OFF

SET inputfile="test.txt"
SET scanner="Lexer.java"

jflex scanner.jflex & echo: & echo ======================================== & echo: & java java_cup.MainDrawTree parser.cup & javac *.java & java Main %inputfile%

IF EXIST .\parser.java DEL /F parser.java
IF EXIST .\scanner.java DEL /F scanner.java
IF EXIST .\scanner.java~ DEL /F scanner.java~
IF EXIST .\scanner.class DEL /F scanner.class