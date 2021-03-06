%code requires{
    #include "ast.h"
}

%{

    #include <cstdio>
    using namespace std;
    int yylex();
    extern int yylineno;
    void yyerror(const char * s){
        fprintf(stderr, "¡Error! Line: %d, error: %s\n", yylineno, s);
    }

    #define YYERROR_VERBOSE 1
%}

%union{
  
    float float_t;
    char* ident_t;

}

%token THEN 
%token ENDIF 
%token ELSE
%token IF
%token <float_t>Number
%token ADD
%token ASSIGN
%token SUB
%token MUL
%token DIV
%token LParenthesis
%token RParenthesis
%token Comma
%token Semicolon
%token Greater
%token Less
%token LET
%token WHILE
%token DO
%token DONE
%token<ident_t> Identifier
%token EOL

%type<float_t> expr term relational_expr factor
%type<ident_t> Assign_ id

%%

start: stmt_list EOL_List
;

stmt_list: stmt_list EOL_List stmt { }
    | stmt { }
;

EOL_List: EOL_List EOL {  }
    | EOL
;

;
Assign_: Identifier ASSIGN expr { printf("Variable %s declarada\n",$1); }

stmt: LET Assign_
    | func_call { } 
    | LET Identifier LParenthesis PARAMS_List RParenthesis ASSIGN block { printf("Metodo %s declarado\n",$2); }
    | expr { printf("Resultado = %f\n",$1); }
;

block: WHILE LParenthesis expr RParenthesis DO stuff
    | expr
;

stuff: Assign_ Semicolon Assign_ DONE EOL_List func_call
    | Assign_ Semicolon
    | expr  Semicolon expr DONE EOL_List func_call
;

func_call: Identifier LParenthesis PARAMS_List RParenthesis
;

PARAMS_List: Identifier Comma PARAMS_List
    | expr Comma PARAMS_List { printf("Return: %f",$1); }
    | Identifier 
    | Number
;

expr: expr ADD term { $$ = $1 + $3; }
    | expr SUB term { $$ = $1 - $3; }
    | term { $$ = $1; }
;

term: term MUL factor { $$ = $1 * $3; }
    | term DIV factor { $$ = $1 / $3; }
    | relational_expr { $$ = $1; }
;

relational_expr: relational_expr Greater factor { $$ = $1 > $3; }
    | relational_expr Less factor { $$ = $1 < $3; }
    | factor { $$ = $1; }
;

factor: Number { $$ = $1; }
    | id
    | LParenthesis expr RParenthesis { $$ = $2; }
;

id: Identifier { $$ = $1; } 
;

%%
