%{
#include <stdio.h>
#include <string.h>
#include "lista_encadeada.h"
#include "tabelas.h"

#define UNKNOW 100
#define REDECLARACAO_VARIAVEL 101
#define EXPECTED_COMMA 102
#define UNCLOSE_COMMENT 103
#define INVALID_TYPE 104

extern char *yytext;
extern int erro_code;
extern int Nlinha;
extern char id[20];
char escopo[20];
char tipo_atribuicao[20];
char tipo_esperado[20];
char tipo_chamada[20];
void empilha(char*);
void empilha_indice(char*);
Lista_Encadeada pilha = NULL;
Lista_Encadeada indices = NULL;
Lista_Encadeada variaveis_entrada = NULL;
Lista_Encadeada argumentos = NULL;
Variavel *variavel_saida = NULL;
Hash tabela_variaveis;
Hash tabela_funcoes;
void insere_tabela_variaveis(char*);
void insere_variavel_entrada(char*);
void insere_tabela_funcoes();
void set_retorno(char*);
void inicializa_tabela_funcoes();
%}

%token token_identificador
%token token_algoritmo
%token token_caracter
%token token_string
%token token_coma
%token token_inteiro
%token token_real
%token token_logico
%token token_atribuicao
%token token_desconhecido
%token token_variaveis
%token token_fim_variaveis
%token token_fim
%token token_virgula
%token token_tipo_inteiro 
%token token_tipo_literal 
%token token_tipo_real 
%token token_tipo_caracter 
%token token_tipo_logico 
%token token_inicio
%token token_dois_pontos
%token token_soma
%token token_sub
%token token_vezes
%token token_div
%token token_mod
%token token_abre_parentesis
%token token_fecha_parentesis
%token token_se
%token token_senao
%token token_entao
%token token_fim_se
%token token_maior
%token token_igual
%token token_menor
%token token_maior_igual
%token token_menor_igual
%token token_diferente
%token token_enquanto
%token token_faca
%token token_fim_enquanto
%token token_para
%token token_de
%token token_ate
%token token_passo
%token token_fim_para
%token token_funcao
%token token_retorne
%token token_abre_colchetes
%token token_fecha_colchetes
%token token_matriz
%token token_caso
%token token_escolha
%token token_fim_escolha
%start PROG

%%
BLOCO_MAIN:
	  token_inicio BLOCO_CMD token_fim
	| token_variaveis DECLARACAO_VAR token_fim_variaveis token_inicio BLOCO_CMD token_fim
;

DECLARACAO_VAR:
	  VAR_AUX token_dois_pontos TIPO {insere_tabela_variaveis(yytext);erro_code = EXPECTED_COMMA;} token_coma
	| DECLARACAO_VAR VAR_AUX token_dois_pontos TIPO {insere_tabela_variaveis(yytext);erro_code = EXPECTED_COMMA;}  token_coma
;

VAR_AUX:
	  VAR_AUX token_virgula token_identificador {empilha(yytext);}
	| token_identificador {empilha(yytext);}
;

DECLARACAO_FUNCOES:
          CABECALHO_FUNCAO {insere_tabela_funcoes();} BLOCO_MAIN
        | DECLARACAO_FUNCOES CABECALHO_FUNCAO {insere_tabela_funcoes();} BLOCO_MAIN
	| CABECALHO_FUNCAO token_dois_pontos TIPO {set_retorno(yytext);insere_tabela_funcoes();} BLOCO_MAIN
	| DECLARACAO_FUNCOES CABECALHO_FUNCAO token_dois_pontos TIPO {set_retorno(yytext);insere_tabela_funcoes();} BLOCO_MAIN
;

CABECALHO_FUNCAO:
	token_funcao token_identificador {strcpy(escopo,yytext);} token_abre_parentesis PARAMETROS token_fecha_parentesis
;

PARAMETROS:
	  token_identificador {empilha(yytext);} token_dois_pontos TIPO {insere_variavel_entrada(yytext);}
        | PARAMETROS token_virgula token_identificador {empilha(yytext);} token_dois_pontos TIPO{insere_variavel_entrada(yytext);}
	|
;

INDICE:
	  token_abre_colchetes token_inteiro {empilha_indice(yytext);} token_fecha_colchetes
	| INDICE token_abre_colchetes token_inteiro {empilha_indice(yytext);} token_fecha_colchetes
;

TIPO:
	  TIPO_PRIMITIVO
	| token_matriz INDICE token_de TIPO_PRIMITIVO
;

TIPO_PRIMITIVO:
	  token_tipo_inteiro
	| token_tipo_literal
	| token_tipo_real
	| token_tipo_caracter
	| token_tipo_logico
;

SE_NA:
	  token_se EXPR0 token_entao BLOCO_CMD token_fim_se
;

SE_A:
	  token_se EXPR0 token_entao BLOCO_CMD token_senao BLOCO_CMD token_fim_se
;

SE:
	  SE_A
	| SE_NA
;

ENQUANTO_FACA:
	  token_enquanto EXPR0 token_faca BLOCO_CMD token_fim_enquanto
	| token_faca BLOCO_CMD token_enquanto EXPR0 token_fim_enquanto
;


PARA:	  
	  token_para token_identificador token_de EXPR0 token_ate EXPR0 token_passo EXPR0 token_faca BLOCO_CMD token_fim_para
;

RETURN:
	  token_retorne EXPR0 {erro_code = EXPECTED_COMMA;}token_coma
;

ESCOLHA:
	  token_escolha token_identificador token_dois_pontos CASO token_fim_escolha
;

CASO:
	  token_caso EXPR0 token_faca BLOCO_CMD
	| CASO token_caso EXPR0 token_faca BLOCO_CMD
;

ATRIBUICAO:	   
	  token_identificador {
	    Variavel* aux = busca(&tabela_variaveis,id,cmp_vars_nome); 
	    if(aux != NULL && !strcmp(escopo,aux->escopo)){
		strcpy(tipo_esperado,aux->tipo); 
		printf("TE -> aux->tipo\n");
	    }else{
		printf("Erro na linha %d. Variavel '%s' não declarada.\n",Nlinha,id);
		return;
	    }
	  } token_atribuicao EXPR0 token_coma {strcpy(tipo_esperado,"NA");}
;

BLOCO_CMD:
	  ATRIBUICAO
	| CHAMADA_FUNCAO token_coma
	| BLOCO_CMD ATRIBUICAO
	| BLOCO_CMD CHAMADA_FUNCAO token_coma
	| SE
	| BLOCO_CMD SE
        | ENQUANTO_FACA
	| BLOCO_CMD ENQUANTO_FACA
	| PARA
	| BLOCO_CMD PARA
	| RETURN
	| BLOCO_CMD RETURN
	| ESCOLHA
	| BLOCO_CMD ESCOLHA
;

EXPR0:
	  EXPR0 token_mod EXPR1	
	| EXPR0 token_menor EXPR1
	| EXPR0 token_maior EXPR1
	| EXPR0 token_igual EXPR1
	| EXPR0 token_menor_igual EXPR1
	| EXPR0 token_maior_igual EXPR1
	| EXPR0 token_diferente EXPR1
	| token_string 
	| token_caracter
	| EXPR1
;

EXPR1:	
	  EXPR1 token_soma EXPR2
	| EXPR1 token_sub EXPR2
	| EXPR2
;

EXPR2:
	  EXPR2 token_vezes EXPR3 
	| EXPR2 token_div EXPR3
	| EXPR3
;

EXPR3:
	  token_identificador {
	    Variavel* aux = busca(&tabela_variaveis,id,cmp_vars_nome); 
	    if(aux != NULL && !strcmp(escopo,aux->escopo)){
		if (strcmp(tipo_esperado,aux->tipo)){
		      erro_code = INVALID_TYPE;
		      yyerror();
		      return;
		}
	    }else{
		printf("Erro na linha %d. Variavel '%s' não declarada.\n",Nlinha,id);
		return;
	    }
	  }
	| token_abre_parentesis EXPR0 token_fecha_parentesis
	| VALOR
	| CHAMADA_FUNCAO
;

SINAL:  token_soma | token_sub
;

VALOR:
	  token_inteiro {if (strcmp(tipo_esperado,"inteiro") && strcmp(tipo_esperado,"NA")){ erro_code = INVALID_TYPE; yyerror();}}
	| token_real    {if (strcmp(tipo_esperado,"real") && strcmp(tipo_esperado,"NA")){ erro_code = INVALID_TYPE; yyerror();}}
	| token_logico  {if (strcmp(tipo_esperado,"lógico") && strcmp(tipo_esperado,"NA")){ erro_code = INVALID_TYPE; yyerror();}}
	| SINAL token_inteiro  {if (strcmp(tipo_esperado,"inteiro") && strcmp(tipo_esperado,"NA")){ erro_code = INVALID_TYPE; yyerror();}}
	| SINAL token_real     {if (strcmp(tipo_esperado,"real") && strcmp(tipo_esperado,"NA")){ erro_code = INVALID_TYPE; yyerror();}}
;

CHAMADA_FUNCAO: 
	  token_identificador {
	    Funcao* aux = (Funcao*)busca(&tabela_funcoes,id,cmp_func_nome); 
	      if(aux != NULL){
		if(aux->variavel_saida != NULL) 
		  strcpy(tipo_atribuicao,aux->variavel_saida->tipo);
		else 
		  strcpy(tipo_atribuicao,"vazio");
	      }else{
		  printf("Erro de sintaxe na linha %d.Função '%s' não declarada.\n",Nlinha,id);
		  return;
	      }
	      printf("chamada: %s\n",aux->nome);
	  } token_abre_parentesis ARGS_LIST token_fecha_parentesis {printf("\n");}
;

ARGS_LIST:
	  EXPR0	{printf("%s ",tipo_chamada);}
	| ARGS_LIST token_virgula EXPR0	{printf("%s ",tipo_chamada);}
	|
;

PROG:	
	  token_algoritmo token_identificador token_coma BLOCO_MAIN
	| token_algoritmo token_identificador token_coma DECLARACAO_FUNCOES {strcpy(escopo,"main");} BLOCO_MAIN
;


%%

#include "lex.yy.c"

void empilha(char* s){
    char* novo = (char*)malloc((strlen(s)+1)*sizeof(char));
    strcpy(novo,s);
    pilha = push_lista_encadeada(pilha,novo);    
}

void empilha_indice(char* s){
    char* novo = (char*)malloc((strlen(s)+1)*sizeof(char));
    strcpy(novo,s);
    indices = push_lista_encadeada(indices,novo);
}

// desempilha a lista de identificadores e cria as variaveis
void insere_tabela_variaveis(char* tipo){
    Lista_Encadeada iterator = pilha;
    do{            
      Variavel *novo;
      char* var_nome = retorna_conteudo(iterator);
      Variavel* aux = busca(&tabela_variaveis,var_nome,cmp_vars_nome);
      if (aux != NULL){
	  if (!strcmp(aux->escopo,escopo)){
	      erro_code = REDECLARACAO_VARIAVEL;
	      printf("Erro semantico na linha %d. Variavel '%s' redeclarada. Esta variavel foi declarada anteriormente na linha %d.\n",Nlinha,var_nome,aux->linha);
	      return;
	  }
      }
      novo = construtor_variavel(retorna_conteudo(iterator),escopo,tipo,indices,Nlinha);      
      insere(&tabela_variaveis,novo,novo->nome,cmp_vars_nome);
      iterator = pop_lista_encadeada(iterator);            
    }while(iterator!=NULL);    
//    pilha = destrutor_lista_encadeada(pilha,destrutor_void);
    pilha = construtor_lista_encadeada();
    indices = construtor_lista_encadeada();
};

void insere_variavel_entrada(char* tipo){
    Lista_Encadeada iterator = pilha;
    do{            
      Variavel *novo;      
      novo = construtor_variavel(retorna_conteudo(iterator),escopo,tipo,indices,-2);      
      variaveis_entrada = push_lista_encadeada(variaveis_entrada,novo);
      insere(&tabela_variaveis,novo,novo->nome,cmp_vars_nome);
      iterator = pop_lista_encadeada(iterator);
//      imprime_variavel(novo);
    }while(iterator!=NULL);
    pilha = construtor_lista_encadeada();
    indices = construtor_lista_encadeada();    
};

void insere_tabela_funcoes(){
      insere(&tabela_funcoes,construtor_funcao(escopo,variaveis_entrada,variavel_saida),escopo,cmp_func_nome);
//    imprime_Hash(&tabela_funcoes,imprime_funcao);
      variaveis_entrada = NULL;
      variavel_saida = NULL;
};

void set_retorno(char* tipo){
      char nome[100];
      strcpy(nome,escopo);
      strcat(nome,".out");      
      variavel_saida = construtor_variavel(nome,escopo,tipo,indices,-2);            
};

void inicializa_tabela_funcoes(){
      variaveis_entrada = push_lista_encadeada(variaveis_entrada,construtor_variavel("literal.in","leia","literal",indices,-1));      
      variavel_saida = NULL;
      insere(&tabela_funcoes,construtor_funcao("leia",variaveis_entrada,variavel_saida),"leia",cmp_func_nome);
      variaveis_entrada = NULL;
      variavel_saida = NULL;

      variaveis_entrada = push_lista_encadeada(variaveis_entrada,construtor_variavel("literal.in","leia_ln","literal",indices,-1));      
      variavel_saida = NULL;
      insere(&tabela_funcoes,construtor_funcao("leia_ln",variaveis_entrada,variavel_saida),"leia_ln",cmp_func_nome);
      variaveis_entrada = NULL;
      variavel_saida = NULL;

      variaveis_entrada = push_lista_encadeada(variaveis_entrada,construtor_variavel("literal.in","imprima","literal",indices,-1));      
      variavel_saida = NULL;
      insere(&tabela_funcoes,construtor_funcao("imprima",variaveis_entrada,variavel_saida),"imprima",cmp_func_nome);
      variaveis_entrada = NULL;
      variavel_saida = NULL;

      variaveis_entrada = push_lista_encadeada(variaveis_entrada,construtor_variavel("literal.in","imprima_ln","literal",indices,-1));      
      variavel_saida = NULL;
      insere(&tabela_funcoes,construtor_funcao("imprima_ln",variaveis_entrada,variavel_saida),"imprima_ln",cmp_func_nome);
      variaveis_entrada = NULL;
      variavel_saida = NULL;

      variaveis_entrada = push_lista_encadeada(variaveis_entrada,construtor_variavel("inteiro_1.in","maximo","inteiro",indices,-1));      
      variaveis_entrada = push_lista_encadeada(variaveis_entrada,construtor_variavel("inteiro_2.in","maximo","inteiro",indices,-1));      
      variavel_saida    = construtor_variavel("inteiro_3.out","maximo","inteiro",indices,-1);
      insere(&tabela_funcoes,construtor_funcao("maximo",variaveis_entrada,variavel_saida),"maximo",cmp_func_nome);
      variaveis_entrada = NULL;
      variavel_saida = NULL;

      variaveis_entrada = push_lista_encadeada(variaveis_entrada,construtor_variavel("inteiro_1.in","minimo","inteiro",indices,-1));      
      variaveis_entrada = push_lista_encadeada(variaveis_entrada,construtor_variavel("inteiro_2.in","minimo","inteiro",indices,-1));      
      variavel_saida    = construtor_variavel("inteiro_3.out","minimo","inteiro",indices,-1);
      insere(&tabela_funcoes,construtor_funcao("minimo",variaveis_entrada,variavel_saida),"minimo",cmp_func_nome);
      variaveis_entrada = NULL;
      variavel_saida = NULL;

      variaveis_entrada = push_lista_encadeada(variaveis_entrada,construtor_variavel("inteiro_1.in","media","inteiro",indices,-1));      
      variaveis_entrada = push_lista_encadeada(variaveis_entrada,construtor_variavel("inteiro_2.in","media","inteiro",indices,-1));      
      variavel_saida    = construtor_variavel("inteiro_3.out","media","inteiro",indices,-1);
      insere(&tabela_funcoes,construtor_funcao("media",variaveis_entrada,variavel_saida),"media",cmp_func_nome);
      variaveis_entrada = NULL;
      variavel_saida = NULL;
//      imprime_Hash(&tabela_funcoes,imprime_funcao);
};

main(){	
	strcpy(escopo,"main");	
	strcpy(tipo_esperado,"NA");	
	inicializa_tabela_funcoes();
	yyparse();
//	imprime_Hash(&tabela_variaveis,imprime_variavel);
//	imprime_Hash(&tabela_funcoes,imprime_funcao);
//	destrutor_tv(&tabela_variaveis);
	pilha = destrutor_lista_encadeada(pilha,free);
        indices = destrutor_lista_encadeada(indices,free);
}

/* rotina chamada por yyparse quando encontra erro */
yyerror (void){	
	if (erro_code == UNKNOW){ printf("Caracter desconhecido %s\n",msg),exit(1);}else
	if (erro_code == UNCLOSE_COMMENT ) printf("Bloco de comentários não fechado\n");else
	if (erro_code == INVALID_TYPE){ printf("Erro semantico na linha %d, Tipo inválido associado à variável.\n",Nlinha);printf("%s\n",tipo_esperado);}
//	printf("Erro na Linha: %d\n", Nlinha);
}