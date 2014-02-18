%{
#define UNKNOW 100
#define REDECLARACAO_VARIAVEL 101
#define EXPECTED_COMMA 102
#define UNCLOSE_COMMENT 103
#define INVALID_TYPE 104

int  Nlinha = 1;
int  erro_code=0;
char msg[100];
char id[20];
%}


  /*palavras reservadas*/
algoritmo        "algoritmo"
variaveis        "variáveis"
fim_variaveis    "fim-variáveis"
fim              "fim"
tipo_inteiro     "inteiro"
tipo_literal     "literal"
tipo_real        "real"
tipo_caracter    "caractere"
tipo_logico      "lógico"
inicio           "início"
se               "se"
senao            "senão"
entao            "então"
fim_se           "fim-se"
enquanto         "enquanto"
faca             "faça"
fim_enquanto     "fim-enquanto"
para             "para"
de               "de"
ate              "até"
passo            "passo"
fim_para         "fim-para"
funcao           "função"
retorne          "retorne"
matriz           "matriz"
caso             "caso"
escolha          "escolha"
fim_escolha      "fim-escolha"

logico           verdadeiro|falso
  /*números*/
sinal            [+|-]
oct              0(c|C)([0-8])+
hex              0(x|X)([0-9|a-f|A-F])+
bin              0(b|B)[01]+
dec              [0-9]+
inteiro          {oct}|{hex}|{bin}|{dec}
real             {dec}["."]{dec}
  /*operadores*/
add              "+"
sub              "-"
div              "/"
mul              "*"
mod              "%"
incre            "++"
decre            "--"
operador_A       {sub}|{add}|{div}|{mul}|{mod}|{incre}|{decre}

maior            ">"
menor            "<"   
igual            "="
maior_igual      ">="
menor_igual      "<="
diferente        "<>"
operador_R       {maior}|{menor}|{igual}|{maior_igual}|{menor_igual}|{diferente}

atribuicao       ":="

and              "&&"|"e"
or               "||"|"ou" 
not              "!"
operador_L       {and}|{or}|{not}

  /*strings e caracteres*/
aspas_duplas      \"
aspas_simples     '
virgula           ","
abre_parentesis   "("
fecha_parentesis  ")"
abre_colchetes    "["
fecha_colchetes   "]"
ponto             "."
coma              ";"
dois_pontos       ":"
abre_chaves       "{"
fecha_chaves      "}"
jogo_velha        "#"
contra_barra      "\\"
comentario_inicio "/*"
comentario_fim    "*/"
caracter          {aspas_simples}(.|{contra_barra}.){aspas_simples}
string            {aspas_duplas}.*{aspas_duplas}
simbolo_E         {aspas_simples}|{aspas_duplas}|{abre_parentesis}|{fecha_parentesis}|{ponto}|{coma}|{dois_pontos}|{abre_chaves}|{fecha_chaves}|{jogo_velha}|{contra_barra}|{virgula}|{abre_colchetes}|{fecha_colchetes}

  /*identificador*/
ident             [a-zA-Z]+[a-zA-Z0-9]*
identificador     {ident}(_{dec}{ident}?|_{ident})*

%%
"/*"              {  /* regra para o comentario */
                  register int c;
                  
                  for ( ; ; )
                      {
                          while ( (c = input()) != '*' && c != EOF )
                          Nlinha++;    /* eat up text of comment */
                          
                          if ( c == '*' )
                              {
                                 while ( (c = input()) == '*' );
                                 if ( c == '/' )
                                     break;    /* found the end */
                              }                    
                          if ( c == EOF )
                              {
				  erro_code = UNCLOSE_COMMENT;				                                    
                                  break;
                              }
                      }
                  }
                  
{algoritmo}         {return token_algoritmo;}
{caracter}          {return token_caracter;}
{string}            {return token_string;}
{coma}              {return token_coma;}
{inteiro}           {return token_inteiro;}
{real}              {return token_real;}
{logico}	    {return token_logico;}
{atribuicao}        {return token_atribuicao;}
{variaveis}         {return token_variaveis;}
{fim_variaveis}     {return token_fim_variaveis;}
{fim}               {return token_fim;}
{virgula}           {return token_virgula;}
{tipo_inteiro}      {return token_tipo_inteiro ;}
{tipo_literal}      {return token_tipo_literal ;}
{tipo_real}         {return token_tipo_real ;}
{tipo_caracter}     {return token_tipo_caracter ;}
{tipo_logico}       {return token_tipo_logico ;}
{inicio}            {return token_inicio;}
{dois_pontos}       {return token_dois_pontos;}
{add}               {return token_soma;}
{sub}               {return token_sub;}
{mul}               {return token_vezes;}
{div}               {return token_div;}
{mod}               {return token_mod;}
{abre_parentesis}   {return token_abre_parentesis;}
{fecha_parentesis}  {return token_fecha_parentesis;}
{se}                {return token_se;}
{senao}             {return token_senao;}
{entao}             {return token_entao;}
{fim_se}            {return token_fim_se;}
{maior}             {return token_maior;}
{igual}             {return token_igual;}
{menor}             {return token_menor;}
{maior_igual}       {return token_maior_igual;}
{menor_igual}       {return token_menor_igual;}
{diferente}         {return token_diferente;}
{enquanto}          {return token_enquanto;}
{faca}              {return token_faca;}
{fim_enquanto}      {return token_fim_enquanto;}
{para}              {return token_para;}
{de}                {return token_de;}
{ate}               {return token_ate;}
{passo}             {return token_passo;}
{fim_para}          {return token_fim_para;}
{funcao}            {return token_funcao;}
{retorne}           {return token_retorne;}
{abre_colchetes}    {return token_abre_colchetes;}
{fecha_colchetes}   {return token_fecha_colchetes;}
{matriz}            {return token_matriz;}
{caso}              {return token_caso;}
{escolha}           {return token_escolha;}
{fim_escolha}       {return token_fim_escolha;}
{identificador}     {strcpy(id,yytext);return token_identificador;}
[\n]		    {Nlinha++;}
[ \t]               ; /* são ignorados */
.                   {strcpy(msg,yytext);erro_code = UNKNOW;return token_desconhecido;}
%%
