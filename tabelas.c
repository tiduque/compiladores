#include "tabelas.h"
#define tam_h 53
#include <string.h>
/***********************************************************************/
/************** Funções para manipulação da struct de variáveis ********/
/***********************************************************************/
int cmp_vars_nome(void *a, void *b){
    Variavel *A = a;
    Variavel *B = b;
    return strcmp(A->nome,B->nome);
}


Variavel* construtor_variavel(char* nome, char* escopo, char* tipo, Lista_Encadeada indices, int linha){
    Variavel *novo = (Variavel*)malloc(sizeof(Variavel));
    strcpy(novo->nome,nome);
    strcpy(novo->escopo,escopo);
    strcpy(novo->tipo,tipo);
    novo->indices = indices;
    novo->linha = linha;
    int produto = 1;
    while (indices != NULL){      
      char *aux;
      aux = (retorna_conteudo(indices));
      if (aux != NULL){
	produto *= atoi(aux);	
      }
      indices = retorna_prox(indices);
    }    
    if (!strcmp(tipo,"inteiro"))  { novo->endereco = malloc(produto*sizeof(int));} else
    if (!strcmp(tipo,"real"))     { novo->endereco = malloc(produto*sizeof(float));} else
    if (!strcmp(tipo,"caracter")) { novo->endereco = malloc(produto*sizeof(char));} else
    if (!strcmp(tipo,"literal"))  { novo->endereco = malloc(produto*sizeof(char*));} else
    if (!strcmp(tipo,"lógico"))   { novo->endereco = malloc(produto*sizeof(int));}  
    return  novo;
}

void imprime_variavel(Variavel *v){
  if (v!= NULL){
    printf("Nome:     %s\n",v->nome);
    printf("Escopo:   %s\n",v->escopo);
    printf("Tipo:     %s\n",v->tipo);    
    printf("Indice:   ");
    if (v->indices != NULL) 
    imprime_lista (v->indices,print_string);
    printf("\nLinha:    %d\n",v->linha);
    printf("Endereco: 0x%x\n\n",v->endereco);
  }
}

void destrutor_variavel(void *A){
  Variavel *a = A;
  if (a != NULL){
    free(a->endereco);
    destrutor_lista_encadeada(a->indices,free);
    free(a);
  }
}

/***********************************************************************/
/************** Funções para manipulação de tabela de variáveis ********/
/***********************************************************************/

//Apesar do nome de construtor, esta função faz apenas a inicialização da tabela de variável, 
//uma vez que, não precisa alocar memória para ela, mas sim para a tabela detro dela.
void construtor_h (Hash* novo){    
    int i = 0;
    for( i=0; i<tam_h ;i++){
      novo->tabela[i] = construtor_lista_encadeada();
    }    
}

void insere (Hash *h,void *v,char* indice,int (cmp)(void*,void*)){
   if (h != NULL){
      int i,k;
      for (i=0,k = 0;indice[k]!='\0';k++) 
	  i=i+(int)indice[k];
      i = i%tam_h;
      h->tabela[i] = insere_ordenado_lista_encadeada(h->tabela[i],v,cmp_vars_nome);
   }
}
Variavel* busca (Hash *h,char* nome, int (cmp)(void *a,void *b)){
  if (h != NULL){
    int i,k;
    for (i=0,k = 0;nome[k]!='\0';k++) 
	i=i+(int)nome[k];
    i = i%tam_h;
    return busca_lista_encadeada(h->tabela[i],nome,cmp);
  }else
    return NULL;
}

void imprime_Hash(Hash* h,void (*imprime)()){
  if (h != NULL){
    int i=0;
    for(i=0;i<tam_h;i++){
      imprime_lista(h->tabela[i],imprime);
    }
  }
}

Hash* destrutor_h (Hash *h){    
  if (h != NULL ){
    int i = 0;
    for( i=0;i<tam_h;i++){
      h->tabela[i] = destrutor_lista_encadeada(h->tabela[i],destrutor_variavel);      
    }
  }
  return NULL;
}


/***********************************************************************/
/************** Funções para manipulação da struct Função **************/
/***********************************************************************/
Funcao* construtor_funcao(char* nome,Lista_Encadeada variaveis_entrada,Variavel *variavel_saida){
    Funcao *novo = (Funcao*)malloc(sizeof(Funcao));
    strcpy(novo->nome,nome);
    novo->variavel_saida = variavel_saida;
    novo->aridade = tam_lista(variaveis_entrada);
    novo->variaveis_entrada = variaveis_entrada;    
}

void imprime_funcao(Funcao* f){
    char aux[20];
    printf("-------------------------------------------\n");
    printf("----------- Função: %s ",f->nome);    
    strcpy(aux,"----------------------\n");
    strcpy(aux,&aux[strlen(f->nome)]);
    printf("%s",aux);
    printf("-------------------------------------------\n\n");
    printf("Aridade: %d\n\n",f->aridade);
    printf("Variaveis_Entrada:\n\n");
    imprime_lista(f->variaveis_entrada,imprime_variavel);
    printf("Variavel_Saida:\n\n");
    imprime_variavel(f->variavel_saida);
}

int cmp_func_nome(void *a, void *b){
    Funcao *A = (Funcao*)a;
    Funcao *B = (Funcao*)b;
    return strcmp(A->nome,B->nome);
}
/***********************************************************************/
/************** Funções Auxiliares *************************************/
/***********************************************************************/

void print_string(void *a){
    printf("%s ",(char*)a);
}

