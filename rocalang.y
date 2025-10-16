%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

FILE *outfile;
int yylex(void);
void yyerror(const char *s);
extern FILE *yyin;
extern int yylineno;

char *strdup_s(const char *s) {
    if (!s) return NULL;
    char *r = malloc(strlen(s)+1);
    strcpy(r,s);
    return r;
}
char *make_binop(const char *a, const char *op, const char *b) {
    size_t n = strlen(a)+strlen(op)+strlen(b)+10;
    char *r = malloc(n);
    snprintf(r,n,"(%s %s %s)", a, op, b);
    return r;
}
%}

/* YYSTYPE */
%union {
    char *str;
}

/* tokens */
%token <str> IDENT NUMBER STRING
%token TREM TEM SE SENAO ENTAO FAZ INTE FINTE FIMSE GRITA
%token TRUE_TOK FALSE_TOK
%token AND OR NOT
%token IGUAL DIFERENTE
%token GT LT GE LE
%token PLUS MINUS MUL DIV

/* apenas nonterminals que de fato produzem strings recebem tipo <str> */
%type <str> declaracao atribuicao acao condicao expressao termo argumentos booleano

/* precedência */
%left OR
%left AND
%right NOT
%left IGUAL DIFERENTE GT LT GE LE
%left PLUS MINUS
%left MUL DIV

%%

/* programa e comando ficam sem tipo (não retornam string diretamente) */
programa:
    /* empty */
    | programa comando
    ;

comando:
    declaracao           { fprintf(outfile,"DECLARACAO: %s\n", $1); free($1); }
    | atribuicao         { fprintf(outfile,"ATRIBUICAO: %s\n", $1); free($1); }
    | condicional         { fprintf(outfile,"CONDICIONAL\n"); }
    | repeticao           { fprintf(outfile,"REPETICAO\n"); }
    | acao                { fprintf(outfile,"ACAO: %s\n", $1); free($1); }
    ;

declaracao:
    TREM IDENT { $$ = $2; }
    | TREM IDENT TEM expressao {
            size_t n = strlen($2)+strlen($4)+20;
            $$ = malloc(n);
            snprintf($$, n, "%s = %s", $2, $4);
            free($2); free($4);
        }
    ;

atribuicao:
    IDENT TEM expressao {
        size_t n = strlen($1)+strlen($3)+20;
        $$ = malloc(n);
        snprintf($$, n, "%s = %s", $1, $3);
        free($1); free($3);
    }
    ;

condicional:
    /* aceita com chaves */
    SE condicao '{' programa '}' FIMSE
        { /* corpo já processado por 'programa' */ }
    | SE condicao '{' programa '}' SENAO '{' programa '}' FIMSE
        { /* corpo já processado */ }

    /* aceita por palavras-chave: entao ... [senao ...] fimse */
    | SE condicao ENTAO programa FIMSE
        { /* corpo já processado */ }
    | SE condicao ENTAO programa SENAO programa FIMSE
        { /* corpo já processado */ }
    ;

repeticao:
    /* aceita com chaves */
    INTE condicao '{' programa '}' FINTE
    /* aceita por palavra-chave: inte <cond> faz <programa> finte */
    | INTE condicao FAZ programa FINTE
    ;

acao:
    /* ação simples por identificador, ex: colhe */
    IDENT { $$ = $1; }
    /* ação com argumentos: nome(arg1, arg2) */
    | IDENT '(' argumentos ')' {
        size_t n = strlen($1)+strlen($3)+10;
        $$ = malloc(n);
        snprintf($$, n, "%s(%s)", $1, $3);
        free($1); free($3);
    }
    /* grita "texto" -> tratar como ação com argumento string */
    | GRITA STRING {
        size_t n = strlen("grita")+strlen($2)+10;
        $$ = malloc(n);
        snprintf($$, n, "grita(%s)", $2);
        free($2);
    }
    ;

condicao:
    expressao IGUAL expressao { $$ = make_binop($1, "==", $3); free($1); free($3); }
    | expressao DIFERENTE expressao { $$ = make_binop($1, "!=", $3); free($1); free($3); }
    | expressao GT expressao { $$ = make_binop($1, ">", $3); free($1); free($3); }
    | expressao LT expressao { $$ = make_binop($1, "<", $3); free($1); free($3); }
    | expressao GE expressao { $$ = make_binop($1, ">=", $3); free($1); free($3); }
    | expressao LE expressao { $$ = make_binop($1, "<=", $3); free($1); free($3); }
    | '(' condicao ')' { $$ = $2; }
    | NOT condicao { size_t n = strlen($2)+10; $$ = malloc(n); snprintf($$, n, "(not %s)", $2); free($2); }
    | condicao AND condicao { $$ = make_binop($1, "and", $3); free($1); free($3); }
    | condicao OR condicao { $$ = make_binop($1, "or", $3); free($1); free($3); }
    ;

expressao:
    termo { $$ = $1; }
    | expressao PLUS termo { $$ = make_binop($1, "+", $3); free($1); free($3); }
    | expressao MINUS termo { $$ = make_binop($1, "-", $3); free($1); free($3); }
    | expressao MUL termo { $$ = make_binop($1, "*", $3); free($1); free($3); }
    | expressao DIV termo { $$ = make_binop($1, "/", $3); free($1); free($3); }
    ;

termo:
    NUMBER { $$ = $1; }
    | IDENT { $$ = $1; }
    | booleano { $$ = $1; }
    | '(' expressao ')' { $$ = $2; }
    ;

argumentos:
    /* vazio */ { $$ = strdup_s(""); }
    | expressao { $$ = $1; }
    | expressao ',' argumentos {
        size_t n = strlen($1) + strlen($3) + 5;
        $$ = malloc(n);
        if (strlen($3)==0) snprintf($$, n, "%s", $1);
        else snprintf($$, n, "%s, %s", $1, $3);
        free($1); free($3);
    }
    ;

booleano:
    TRUE_TOK { $$ = strdup_s("true"); }
    | FALSE_TOK { $$ = strdup_s("false"); }
    ;

%%

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr,"Usage: %s <input.roca>\n", argv[0]);
        return 1;
    }
    outfile = fopen("output.asm","w");
    if (!outfile) { perror("fopen"); return 1; }

    FILE *f = fopen(argv[1],"r");
    if (!f) { perror("input"); return 1; }
    fclose(f);

    yyin = fopen(argv[1],"r");
    if (!yyin) { perror("yyin"); return 1; }

    yyparse();

    fprintf(outfile,"; Parse finalizado\n");
    fclose(outfile);
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr,"Erro sintático: %s (linha %d)\n", s, yylineno);
}
