%option noyywrap
%option nodefault
%option yylineno
%option caseless

%{
    #include "tokens.h"
%}

%%

[0-9]+("."[0-9]+)? { yylval.float_t = atof(yytext);  return Number; }
"+" return ADD;
"=" return ASSIGN;
"-" return SUB;
"*" return MUL;
"/" return DIV;
"(" return LParenthesis;
")" return RParenthesis;
"," return Comma;
";" return Semicolon;
">" return Greater;
"<" return Less;
"let" return LET;
"while" return WHILE;
"do" return DO;
"done" return DONE;
[a-zA-Z]+ { yylval.ident_t = strdup(yytext); return Identifier; }
[\n]+ return EOL;
[ \t] ;
. ;

%%