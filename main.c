#include <stdio.h>
#include <stdlib.h>

extern int yyparse(void);
extern FILE *yyin;
FILE *out;

int main(int argc, char **argv) {
    if (argc < 3) {
        fprintf(stderr, "Uso: %s <entrada.roca> <saida.asm>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("Erro ao abrir arquivo de entrada");
        return 1;
    }

    out = fopen(argv[2], "w");
    if (!out) {
        perror("Erro ao abrir arquivo de saída");
        fclose(yyin);
        return 1;
    }

    yyparse();

    fclose(yyin);
    fclose(out);
    return 0;
}