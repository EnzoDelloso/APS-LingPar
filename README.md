# APS-LingPar

##  RoçaLang: Linguagem da Roça

RoçaLang possui uma sintaxe inspirada na fala do interior de Minas Gerais, buscando um código acessível e fácil de entender para quem não é programador profissional.

### Exemplos de Código RoçaLang

```rocalang

trem x tem 3
grita "Iniciando loop de incremento"
inté x faz
grita "Incrementando x"
finte

```
###  Palavras da Roça
| Palavra RoçaLang | Significado             |
| ---------------- | ----------------------: |
| `trem`           | Declara uma variável    |
| `tem`            | Atribui um valor        |
| `se`             | Condicional             |
| `senao`          | Alternativa             |
| `inté`           | Repetição               |
| `grita`          | Mostra algo na tela     |
| `é`              | Valor verdadeiro        |
| `numé`           | Valor falso             |
| `e`              | Operador lógico E       |
| `ou`             | Operador lógico OU      |
| `num`            | Negação lógica          |
| `igual`          | Comparação de igualdade |
| `diferente`      | Comparação de diferença |



## EBNF Completa da RoçaLang
```
programa        = { comando } ;

comando         = declaracao
                | atribuicao
                | condicional
                | repeticao
                | acao
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

acao            = identificador [ argumentos ]
                | identificador { " " expressao } ;

condicao        = expressao comparador expressao
                | "(" condicao ")"
                | "num" condicao
                | condicao "e" condicao
                | condicao "ou" condicao
                ;

expressao       = termo { operador termo } ;

termo           = numero
                | identificador
                | booleano
                | "(" expressao ")"
                ;

argumentos      = "(" [ expressao { "," expressao } ] ")" ;

booleano        = "é" | "numé" ;

comparador      = ">" | "<" | ">=" | "<=" | "igual" | "diferente" ;

operador        = "+" | "-" | "*" | "/" ;

identificador   = letra { letra | digito | "_" } ;

numero          = [ "-" ] digito { digito } ;

letra           = "a" | "b" | ... | "z"
                | "A" | ... | "Z" ;

digito          = "0" | "1" | ... | "9" ;
```
