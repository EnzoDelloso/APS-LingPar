# APS-LingPar


RoçaLang: Linguagem de Programação da Roça

RoçaLang é uma linguagem de programação de alto nível inspirada no jeito simples e direto de falar do interior de Minas Gerais. Ela foi criada para controlar uma VM de automação rural chamada FazendinhaVM, responsável por tarefas como irrigar plantações, colher produtos, armazenar, e reagir ao clima.

Exemplos de Código
fala milho = 10;

inté milho > 0 {
    colhe("milho");
    bota_no_cesto("milho");
    milho = milho - 1;
}

se sol_quente == é {
    liga_sombra();
}

🧠 Palavras-chave da RoçaLang
Função	Palavra-chave mineira
let (declara)	fala
if	se
else	senao
while	inté
print	grita
true / false	é / numé
and / or	e / ou
not	num
EBNF da RoçaLang
programa        = { comando } ;

comando         = declaracao
                | atribuicao
                | condicional
                | repeticao
                | acao
                ;

declaracao      = "fala" identificador [ "=" expressao ] ";" ;
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

🖥VM: FazendinhaVM (em construção)

A FazendinhaVM será capaz de interpretar o assembly gerado a partir de programas escritos em RoçaLang.

Recursos da VM:

Registradores: R1, R2

Sensores (read-only):

sol_quente

chuva

umidade

dia

Instruções da VM:

JOGA_AGUA

COLHE

PLANTA

ESPERA

LIGA_SOMBRA

ACENDE_LUZ

ARMAZENA
