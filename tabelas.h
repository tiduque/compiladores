/*tabelas.h*/
#ifndef tabelas_h
#define tabelas_h
#include "lista_encadeada.h"

typedef struct {
  char nome[32];
  char escopo[16];
  char tipo[10];
  Lista_Encadeada indices;
  int linha;
  void* endereco;    
} Variavel;

typedef struct {
  char nome[32];  
  Variavel *variavel_saida;
  int aridade;
  Lista_Encadeada variaveis_entrada;
} Funcao;

typedef struct {
  Lista_Encadeada tabela[53];  
}Hash;

// Funções para manipulação da struct de variáveis
int cmp_vars_nome(void *a, void *b);
Variavel* construtor_variavel(char* nome, char* escopo, char* tipo, Lista_Encadeada indices, int linha);
void imprime_variavel(Variavel *v);
void destrutor_variavel(void *A);


//Funções para manipulação da tabela hash
void construtor_h (Hash*);
void insere (Hash*,void*,char*,int (cmp)(void*,void*));
Variavel* busca (Hash*,char*,int (cmp)(void*,void*));
void imprime_Hash(Hash*,void (*imprime)());
Hash* destrutor_h (Hash *h);

//Funções para manipulação da struct Função
Funcao* construtor_funcao(char* nome,Lista_Encadeada variaveis_entrada,Variavel *variavel_saida);
void imprime_funcao(Funcao*);
//Funções Auxiliares
void print_string(void *a);
int cmp_func_nome(void *a, void *b);

#endif