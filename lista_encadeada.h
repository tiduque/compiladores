#ifndef LISTA_ENCADEADA_H_
#define LISTA_ENCADEADA_H_
/*Lista Encadeada Genéria que recebe qualquer tipo de dados como parametro*/
#include <stdio.h>
#include <stdlib.h>
typedef struct lista_encadeada* Lista_Encadeada;

Lista_Encadeada construtor_lista_encadeada (void);
Lista_Encadeada destrutor_lista_encadeada (Lista_Encadeada lista,void (*destrutor_elemento)(void* elem));
Lista_Encadeada push_lista_encadeada (Lista_Encadeada lista, void* elem);
Lista_Encadeada pop_lista_encadeada (Lista_Encadeada lista);
Lista_Encadeada insere_ordenado_lista_encadeada (Lista_Encadeada lista,void* elem, int (*cmp)(void* elem1,void* elem2));
int insere_final (void *a, void* b);
void* busca_lista_encadeada (Lista_Encadeada lista,void* elem,int (*cmp)(void* a,void* b));
void imprime_lista_encadeada (FILE* arquivo,Lista_Encadeada lista, void (*imprime)(FILE* _arquivo_,void *elem));
void imprime_lista (Lista_Encadeada lista,void (*imprime)());
void destrutor_void (void* elem);
Lista_Encadeada retorna_prox (Lista_Encadeada lista);
void* retorna_conteudo (Lista_Encadeada lista);
int tam_lista(Lista_Encadeada l);
#endif
