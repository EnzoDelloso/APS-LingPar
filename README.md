# APS-LingPar

##  RoçaLang: Linguagem da Roça

RoçaLang possui uma sintaxe inspirada na fala do interior de Minas Gerais, buscando um código acessível e fácil de entender para quem não é programador profissional.

### Exemplos de Código RoçaLang

```rocalang
trem milho tem 10

inté milho > 0 faz
grita "Colhendo um milho"
colhe milho
armazena milho
milho tem milho - 1
finté
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
## FazendinhaVM: Máquina Virtual da Roça
A FazendinhaVM é uma máquina virtual simples e didática, projetada para executar o Assembly gerado a partir de programas escritos em RoçaLang.

Arquitetura da VM
### Visão Geral

| Recurso                 | Descrição                                                          |
| ----------------------- | ------------------------------------------------------------------ |
| **Trilhos (T1–T4)**     | Caminhos por onde os dados (“trem”) correm.                        |
| **Depósito**            | Memória principal (1024 posições), onde os “trem” ficam guardados. |
| **Sensores da Fazenda** | Endereços fixos de leitura (sol, chuva, umidade, dia).             |
| **Buzina (PC)**         | Indica a próxima instrução a ser executada.                        |
| **Galpão de Ações**     | Conjunto de comandos fixos da fazenda.                             |
| **Modo de Operação**    | Pode ser *Plantio*, *Colheita* ou *Repouso*.                       |

### Tipos de Trem

| Tipo      | Código | Exemplo             |
| --------- | ------ | ------------------- |
| `INTEIRO` | 0      | 42                  |
| `VERDADE` | 1      | é / numé            |
| `SENSOR`  | 2      | sol_quente, umidade |
| `ITEM`    | 3      | milho, semente      |


### Sensores (endereços read-only)
| Endereço | Nome         | Descrição                    |
| -------- | ------------ | ---------------------------- |
| 900      | `sol_quente` | 1 se o sol estiver forte     |
| 901      | `chuva`      | 1 se estiver chovendo        |
| 902      | `umidade`    | valor entre 0 e 100          |
| 903      | `dia`        | 1 se for dia, 0 se for noite |


### Instruções da Roça
| Instrução            | Descrição                                                          |
| -------------------- | ------------------------------------------------------------------ |
| **POE Tn, valor**    | Coloca um valor direto em `Tn`. (≃ MOV)                            |
| **PEGA Tn, lugar**   | Lê `Depósito[lugar]` e joga em `Tn`. (≃ LOAD)                      |
| **GUARDA Tn, lugar** | Escreve o conteúdo de `Tn` no depósito. (≃ STORE)                  |
| **AJUNTA Tn, Tm**    | Soma os valores de `Tn` e `Tm`. (≃ ADD)                            |
| **TIRA Tn, Tm**      | Subtrai `Tm` de `Tn`. (≃ SUB)                                      |
| **VÊ Tn, Tm**        | Compara os valores e ajusta as bandeiras de verdade (Z/N). (≃ CMP) |
| **SIEH vai_pra**     | Salta se a bandeira de verdade for verdadeira. (≃ JZ)              |
| **SINUMEH vai_pra**  | Salta se a bandeira de verdade for falsa. (≃ JNZ)                  |
| **VORTA vai_pra**    | Salto incondicional. (≃ JMP)                                       |
| **CHAMA nome**       | Chama uma ação do galpão. (≃ CALL)                                 |
| **DEVORVI**          | Retorna da ação chamada. (≃ RET)                                   |
| **PERAE**            | Pausa a execução por um tempo simulado. (≃ WAIT)                   |
| **ACABA**            | Finaliza o programa. (≃ HALT)                                      |



### Ações do Galpão
| Ação          | Código | Descrição                            |
| ------------- | ------ | ------------------------------------ |
| `PLANTA`      | 10     | Planta um novo trem (semente).       |
| `COLHE`       | 11     | Colhe o que tiver pronto.            |
| `ARMAZENA`    | 12     | Guarda o item colhido no depósito.   |
| `JOGA_AGUA`   | 13     | Irriga a plantação.                  |
| `LIGA_SOMBRA` | 14     | Liga a sombra se o sol tiver quente. |
| `ACENDE_LUZ`  | 15     | Acende a luz de cultivo.             |



### Exemplo de Código Assembly - se sol está quente, liga sombra:

```
PEGA T1, sol_quente      ; vê se o sol tá quente
VÊ T1, é                 ; compara com verdade
SIEH LIGA_SOMBRA         ; se for, vai pra ligar a sombra
VORTA FIM                ; sinumeh, pula pro fim

LIGA_SOMBRA:
CHAMA LIGA_SOMBRA
DEVORVI

FIM:
ACABA

```

### Modos de operação

| Modo         | Descrição                             | Uso                |
| ------------ | ------------------------------------- | ------------------ |
| **Plantio**  | Carrega variáveis e inicializa dados. | início do programa |
| **Colheita** | Executa lógica e ações.               | execução normal    |
| **Repouso**  | Espera sensores ou eventos.           | pausa ou espera    |


### Programa de exemplo maior

```
POE T1, 10           ; tem 10 milho
PLANTA               ; planta o primeiro

ENQUANTO:
VÊ T1, 0
SINUMEH FIM
CHAMA COLHE
CHAMA ARMAZENA
TIRA T1, 1
VORTA ENQUANTO

FIM:
ACABA
```
