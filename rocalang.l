%{
#include "rocalang.tab.h"
#include <string.h>
#include <ctype.h>
#include <stdlib.h>

void yyerror(const char *s);
extern int yylineno;
extern FILE *yyin;
%}

/* definições portáveis (ASCII identifiers para evitar erros do flex) */
DIGIT       [0-9]
ID          [A-Za-z_][A-Za-z0-9_]*
NUMBER      -?{DIGIT}+
STRING      \"([^\"\n]|\\.)*\"
WS          [ \t\r]+

%%

{WS}            { /* ignora espaços/tabs */ }

{STRING}        {
                    /* copia sem as aspas */
                    yylval.str = strdup(yytext+1);
                    yylval.str[strlen(yylval.str)-1] = '\0';
                    return STRING;
                }

{NUMBER}        {
                    yylval.str = strdup(yytext);
                    return NUMBER;
                }

{ID}            {
                    char *s = strdup(yytext);
                    for (size_t i = 0; i < strlen(s); ++i) s[i] = tolower((unsigned char)s[i]);

                    /* palavras reservadas (formas sem acento) */
                    if (strcmp(s,"trem")==0) { free(s); return TREM; }
                    if (strcmp(s,"tem")==0) { free(s); return TEM; }
                    if (strcmp(s,"se")==0) { free(s); return SE; }
                    if (strcmp(s,"senao")==0 || strcmp(s,"senão")==0) { free(s); return SENAO; }
                    if (strcmp(s,"entao")==0 || strcmp(s,"então")==0) { free(s); return ENTAO; }
                    if (strcmp(s,"faz")==0) { free(s); return FAZ; }
                    if (strcmp(s,"inte")==0 || strcmp(s,"inté")==0) { free(s); return INTE; }
                    if (strcmp(s,"finte")==0 || strcmp(s,"finté")==0) { free(s); return FINTE; }
                    if (strcmp(s,"fimse")==0) { free(s); return FIMSE; }
                    if (strcmp(s,"grita")==0) { free(s); return GRITA; }
                    if (strcmp(s,"é")==0 || strcmp(s,"verdade")==0) { free(s); return TRUE_TOK; }
                    if (strcmp(s,"numé")==0 || strcmp(s,"nume")==0) { free(s); return FALSE_TOK; }
                    if (strcmp(s,"e")==0) { free(s); return AND; }
                    if (strcmp(s,"ou")==0) { free(s); return OR; }
                    if (strcmp(s,"num")==0) { free(s); return NOT; }
                    if (strcmp(s,"igual")==0) { free(s); return IGUAL; }
                    if (strcmp(s,"diferente")==0) { free(s); return DIFERENTE; }

                    /* senão, identificador */
                    yylval.str = s;
                    return IDENT;
                }

">="             { return GE; }
"<="             { return LE; }
">"              { return GT; }
"<"              { return LT; }
"("              { return '('; }
")"              { return ')'; }
","              { return ','; }
"{"              { return '{'; }
"}"              { return '}'; }
"+"              { return PLUS; }
"-"              { return MINUS; }
"*"              { return MUL; }
"/"              { return DIV; }

\n               { ++yylineno; }
.                { /* ignora outros caracteres */ }

%%

int yywrap(void) { return 1; }
