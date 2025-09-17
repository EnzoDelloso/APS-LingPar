# APS-LingPar

##  RoçaLang: Linguagem da Roça

RoçaLang possui uma sintaxe inspirada na fala do interior de Minas Gerais, buscando um código acessível e fácil de entender para quem não é programador profissional.

### Exemplos de Código RoçaLang

```rocalang
trem milho = 10;

inté milho > 0 {
    colhe(milho);
    armazena(milho)
    milho = milho - 1;
}

se sol_quente == é {
    liga_sombra();
}
```
## Palavras-chave da RoçaLang
| RoçaLang | Significado Tradicional | Descrição               |
| -------- | ----------------------- | ----------------------- |
| `trem`   | let                     | Declaração de variável  |
| `se`     | if                      | Condicional             |
| `senao`  | else                    | Condicional alternativa |
| `inté`   | while                   | Loop                    |
| `grita`  | print                   | Impressão               |
| `é`      | true                    | Booleano verdadeiro     |
| `numé`   | false                   | Booleano falso          |
| `e`      | and                     | Operador lógico AND     |
| `ou`     | or                      | Operador lógico OR      |
| `num`    | not                     | Operador lógico NOT     |


## EBNF Completa da RoçaLang
```
programa        = { comando } ;

comando         = declaracao
                | atribuicao
                | condicional
                | repeticao
                | acao
                ;

declaracao      = "trem" identificador [ "=" expressao ] ";" ;
atribuicao      = identificador "=" expressao ";" ;

condicional     = "se" condicao "{" { comando } [ "} senao {" { comando } ] "}" ;

repeticao       = "inté" condicao "{" { comando } "}" ;

acao            = identificador "(" [ argumentos ] ")" ";" ;

condicao        = expressao comparador expressao ;

expressao       = numero
                | identificador
                | expressao operador expressao
                ;

argumentos      = expressao { "," expressao } ;

identificador   = letra { letra | digito | "_" } ;
numero          = [ "-" ] digito { digito } ;

comparador      = ">" | "<" | ">=" | "<=" | "==" | "!=" ;
operador        = "+" | "-" | "*" | "/" ;

letra           = "a" | "b" | ... | "z" | "A" | ... | "Z" ;
digito          = "0" | "1" | ... | "9" ;
```
## FazendinhaVM: Máquina Virtual da Roça
A FazendinhaVM é uma máquina virtual simples e didática, projetada para executar o Assembly gerado a partir de programas escritos em RoçaLang.

Arquitetura da VM
### Registradores

| Registrador | Descrição                        |
| ----------- | -------------------------------- |
| `R1`        | Registrador de propósito geral 1 |
| `R2`        | Registrador de propósito geral 2 |

```
MOV R1, 5        ; R1 ← 5
ADD R1, R2       ; R1 ← R1 + R2
```

### Memória
1024 posições (ram[1024])

Leitura e escrita permitidas, exceto áreas de sensores (somente leitura)

Armazena variáveis e dados temporários

### Sensores (endereços read-only)
| Endereço | Sensor      | Descrição                    |
| -------- | ----------- | ---------------------------- |
| `1000`   | sol\_quente | 1 se o sol estiver forte     |
| `1001`   | chuva       | 1 se estiver chovendo        |
| `1002`   | umidade     | Valor entre 0 e 100          |
| `1003`   | dia         | 1 se for dia, 0 se for noite |


Exemplo de leitura:

```
LOAD R1, 1000      ; R1 ← valor de sol_quente
CMP R1, 1
JZ LIGA_SOMBRA
```

### Instruções da VM
| Instrução        | Descrição                                   |
| ---------------- | ------------------------------------------- |
| `MOV Rn, val`    | Move valor literal para o registrador       |
| `LOAD Rn, addr`  | Carrega valor da memória para o registrador |
| `STORE Rn, addr` | Salva valor do registrador na memória       |
| `ADD Rn, Rm`     | Soma dois registradores                     |
| `SUB Rn, Rm`     | Subtrai Rm de Rn                            |
| `CMP Rn, val`    | Compara Rn com valor (altera flag zero)     |
| `JMP label`      | Salto incondicional para label              |
| `JZ label`       | Salta se flag zero                          |
| `JNZ label`      | Salta se flag diferente de zero             |
| `CALL addr`      | Chama sub-rotina (ação da fazenda)          |
| `RET`            | Retorna de sub-rotina                       |
| `HALT`           | Finaliza programa                           |


### Ações da Fazenda (Sub-rotinas)
| Label / Endereço | Ação         | Descrição                 |
| ---------------- | ------------ | ------------------------- |
| `200`            | JOGA\_AGUA   | Aciona irrigação          |
| `201`            | COLHE        | Colhe planta atual        |
| `202`            | PLANTA       | Planta nova semente       |
| `203`            | ESPERA       | Aguarda um tempo simulado |
| `204`            | LIGA\_SOMBRA | Liga proteção contra sol  |
| `205`            | ACENDE\_LUZ  | Liga luz para plantações  |
| `206`            | ARMAZENA     | Armazena item colhido     |


### Exemplo de Código Assembly - se sol está quente, liga sombra:

```
LOAD R1, 1000        ; R1 ← sensor sol_quente
CMP R1, 1            ; Compara com 1 (quente)
JZ LIGA              ; Se for, pula para ligar

JMP FIM              ; Senão, fim

LIGA:
CALL 204             ; Chama rotina LIGA_SOMBRA
JMP FIM
```
