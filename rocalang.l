%{
#include "rocalang.tab.h"
#include <string.h>
#include <ctype.h>
#include <stdlib.h>

void yyerror(const char *s);
extern int yylineno;
extern FILE *yyin;
%}

DIGIT       [0-9]
ID          [A-Za-z_][A-Za-z0-9_]*
NUMBER      -?{DIGIT}+
STRING      \"([^\"\n]|\\.)*\"
WS          [ \t\r]+

%%

{WS}            { }
{STRING}        {
                    yylval.str = strdup(yytext+1);
                    yylval.str[strlen(yylval.str)-1] = '\0';
                    return STRING;
                }
{NUMBER}        {
                    yylval.num = atoi(yytext);
                    return NUMBER;
                }
[tT]rem         { return TREM; }
[tT]em          { return TEM; }
[gG]rita        { return GRITA; }
[iI]nt[eé]      { return INTE; }
[fF]int[eé]     { return FINTE; }
[fF]az          { return FAZ; }
[eE]mpurra      { return PUSH; }
[pP]uxa         { return POP; }
[ \t]+          { }
\n              { ++yylineno; }
{ID}            {
                    char *s = strdup(yytext);
                    for (size_t i = 0; i < strlen(s); ++i) s[i] = tolower((unsigned char)s[i]);
                    yylval.str = s;
                    return IDENT;
                }
"+"             { return PLUS; }
"-"             { return MINUS; }
.               { }
%%

int yywrap(void) { return 1; }