# RoçaLang

## A linguagem do cowboy raiz.

### O que é:

RoçaLang é uma linguagem de programação de alto nível inspirada no jeito simples e direto de falar do interior de Minas Gerais. Criada como parte do projeto da disciplina de Linguagens e Paradigmas, ela é compilada via Flex & Bison e gera código de baixo nível compatível com a MicrowaveVM.

### Filosofia da linguagem

A RoçaLang valoriza a clareza, a simplicidade e a familiaridade com o vocabulário rural. Em vez de termos técnicos pesados, usamos expressões populares que tornam a programação mais acessível para quem vive e trabalha no campo.


###  Palavras da Roça

| Palavra RoçaLang | Significado                                     |
|------------------|-------------------------------------------------|
| `trem`           | Declara uma variável (`declaracao`)             |
| `tem`            | Atribui um valor (`atribuicao`)                 |
| `se`             | Início de condicional (`condicional`)           |
| `senao`          | Bloco alternativo do condicional (`condicional`)|
| `fimse`          | Fim do condicional (`condicional`)              |
| `inté`           | Início da repetição (`repeticao`)               |
| `finté`          | Fim da repetição (`repeticao`)                  |
| `grita`          | Mostra algo na tela (`grita`)                   |
| `empurra`        | Push de um item na pilha (`empurra`)            |
| `puxa`           | Pop de um item da pilha (`puxa`)                |
| `num`            | Negação lógica (`condicao`)                     |
| `é`              | Valor booleano verdadeiro (`booleano`)          |
| `numé`           | Valor booleano falso (`booleano`)               |
| `igual`          | Comparação de igualdade (`comparador`)          |
| `diferente`      | Comparação de diferença (`comparador`)          |
| `e`              | Operador lógico E (`condicao`)                  |
| `ou`             | Operador lógico OU (`condicao`)                 |
| `#`              | Comentário (`comentario`)                       |


## EBNF Completa da RoçaLang
```
programa        = { comando } ;

comando         = declaracao
                | atribuicao
                | condicional
                | repeticao
                | acao
                | comentario
                ;

declaracao      = "trem" identificador [ "tem" expressao ] ;

atribuicao      = identificador "tem" expressao ;

condicional     = "se" condicao "então"
                    { comando }
                  [ "senao"
                    { comando } ]
                  "fimse" ;

repeticao       = "inté" condicao "faz"
                    { comando }
                  "finté" ;

acao            = chamada_built_in
                | chamada_identificador
                ;

chamada_built_in = grita
                | empurra
                | puxa
                ;

grita           = "grita" ( "(" [ lista_expressao ] ")" | expressao | string ) ;
empurra         = "empurra" "(" [ lista_expressao ] ")" ;
puxa            = "puxa" "(" [ expressao ] ")" ;

chamada_identificador = identificador [ argumentos ]
                      | identificador { " " expressao } ;

condicao        = expressao comparador expressao
                | "(" condicao ")"
                | "num" condicao
                | condicao "e" condicao
                | condicao "ou" condicao
                ;

expressao       = termo { operador termo } ;

lista_expressao = expressao { "," expressao } ;

termo           = numero
                | identificador
                | booleano
                | string
                | chamada_identificador
                | "(" expressao ")"
                ;

argumentos      = "(" [ lista_expressao ] ")" ;

booleano        = "é" | "numé" ;

comparador      = ">" | "<" | ">=" | "<=" | "igual" | "diferente" ;

operador        = "+" | "-" | "*" | "/" ;

identificador   = letra { letra | digito | "_" } ;

numero          = [ "-" ] digito { digito } ;

string          = "\"" { caractere_string } "\"" ;

comentario      = "#" { qualquer_caractere } ;

letra           = "a" | "b" | ... | "z"
                | "A" | ... | "Z" ;

digito          = "0" | "1" | ... | "9" ;

caractere_string = qualquer_caractere_except_quotation_mark ;

qualquer_caractere = qualquer byte válido do source file ;
 ;

letra           = "a" | "b" | ... | "z"
                | "A" | ... | "Z" ;

digito          = "0" | "1" | ... | "9" ;
```


## Exemplo de Programa

### Código `increment.roca`

```rocalang
trem x tem 3
grita "Iniciando loop de incremento"
inté x faz
grita "Incrementando x"
finte
```

### Código gerado (`output.asm`)

```asm
SET TIME 3
PRINT
PRINT
LOOP_0:
DECJZ TIME LOOP_END_0
GOTO LOOP_BODY_0
LOOP_BODY_0:
GOTO LOOP_0
LOOP_END_0:
HALT

```

### Saída esperada (MicrowaveVM)

```
TIME: 3
TIME: 3
BEEEEEEP!
Final state: {'TIME': 0, 'POWER': 0}
Final readonly state: {'TEMP': 0, 'WEIGHT': 100}
Final stack: []
```

### Executar um programa RoçaLang

```bash
make
./rocalang <arquivo.roca> <output.asm>
```

### Limpar arquivos gerados

```bash
make clean
```

