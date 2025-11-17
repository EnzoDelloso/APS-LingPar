%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE *out;
int yylex(void);
void yyerror(const char *s);

char *strdup_s(const char *s) {
    if (!s) return NULL;
    char *r = malloc(strlen(s)+1);
    strcpy(r,s);
    return r;
}

char *reg_for_index(int idx) {
    if (idx==0) return "TIME";
    if (idx==1) return "POWER";
    return "TIME";
}

#define MAX_VARS 16
char *vars[MAX_VARS];
int var_count = 0;

int find_var(const char *name) {
    for (int i=0;i<var_count;++i) if (strcmp(vars[i],name)==0) return i;
    return -1;
}

int ensure_var(const char *name) {
    int idx = find_var(name);
    if (idx>=0) return idx;
    if (var_count < MAX_VARS) {
        vars[var_count] = strdup_s(name);
        return var_count++;
    }
    return 0;
}

int new_label_id() {
    static int lbl = 0;
    return lbl++;
}
%}

%union {
    char *str;
    int num;
}

%token <str> IDENT STRING
%token <num> NUMBER
%token TREM TEM INTE FAZ FINTE GRITA MINUS PLUS
%token PUSH POP

%type <str> declaracao atribuicao acao instrucoes repeticao pilha

%%

program:
    instrucoes { fprintf(out,"HALT\n"); }
;

instrucoes:
    /* vazio */ { }
  | instrucoes declaracao { }
  | instrucoes atribuicao { }
  | instrucoes acao { }
  | instrucoes repeticao { }
  | instrucoes pilha { }
;

declaracao:
    TREM IDENT {
        int idx = ensure_var($2);
        if (idx==0) fprintf(out,"SET TIME 0\n");
        else if (idx==1) fprintf(out,"SET POWER 0\n");
        free($2);
    }
  | TREM IDENT TEM NUMBER {
        int idx = ensure_var($2);
        char *reg = reg_for_index(idx);
        fprintf(out,"SET %s %d\n", reg, $4);
        free($2);
    }
;

atribuicao:
    IDENT TEM NUMBER {
        int idx = ensure_var($1);
        char *reg = reg_for_index(idx);
        fprintf(out,"SET %s %d\n", reg, $3);
        free($1);
    }
  | IDENT TEM IDENT PLUS NUMBER {
        int a = ensure_var($1);
        char *reg = reg_for_index(a);
        for (int i=0;i<$5;++i) fprintf(out,"INC %s\n", reg);
        free($1); free($3);
    }
  | IDENT TEM IDENT MINUS NUMBER {
        int a = ensure_var($1);
        char *reg = reg_for_index(a);
        int lbl = new_label_id();
        fprintf(out,"DECJZ %s L_DEC_%d\n", reg, lbl);
        fprintf(out,"L_DEC_%d:\n", lbl);
        free($1); free($3);
    }
;

acao:
    GRITA STRING {
        fprintf(out,"PRINT\n");
        free($2);
    }
;

repeticao:
    INTE IDENT FAZ instrucoes FINTE {
        int idx = ensure_var($2);
        char *reg = reg_for_index(idx);
        int id = new_label_id();
        fprintf(out,"LOOP_%d:\n", id);
        fprintf(out,"DECJZ %s LOOP_END_%d\n", reg, id);
        fprintf(out,"GOTO LOOP_BODY_%d\n", id);
        fprintf(out,"LOOP_BODY_%d:\n", id);
        fprintf(out,"GOTO LOOP_%d\n", id);
        fprintf(out,"LOOP_END_%d:\n", id);
        free($2);
    }
;

pilha:
    PUSH IDENT {
        int idx = ensure_var($2);
        char *reg = reg_for_index(idx);
        fprintf(out, "PUSH %s\n", reg);
        free($2);
    }
  | POP IDENT {
        int idx = ensure_var($2);
        char *reg = reg_for_index(idx);
        fprintf(out, "POP %s\n", reg);
        free($2);
    }
;

%%

void yyerror(const char *s) {
    fprintf(stderr,"Erro sintático: %s (linha ?)\n", s);
}