/*
 * lista_encadeada.c
 *
 *  Created on: 13/04/2011
 *      Author: tiago
 */
#include "lista_encadeada.h"

struct lista_encadeada{
	void* elem;
	struct lista_encadeada *prox;
};

Lista_Encadeada construtor_lista_encadeada (void){
	Lista_Encadeada novo = (Lista_Encadeada)malloc(sizeof(struct lista_encadeada));
	novo->elem = NULL;
	novo->prox = NULL;
	return novo;
}

Lista_Encadeada destrutor_lista_encadeada (Lista_Encadeada lista,void (*destrutor_elemento)(void* elem)){
	if (lista != NULL){
		destrutor_elemento(lista->elem);
		destrutor_lista_encadeada (lista->prox,destrutor_elemento);
		free(lista);
	}
	return NULL;
}

Lista_Encadeada push_lista_encadeada (Lista_Encadeada lista, void* elem){
	if (lista == NULL){
	Lista_Encadeada novo = construtor_lista_encadeada();
	novo->elem = elem;
	novo->prox = lista;
	return novo;
	}else
	  if(lista->elem == NULL){
	    lista->elem = elem;
	    return lista;
	  }else{
	    Lista_Encadeada novo = construtor_lista_encadeada();
	    novo->elem = elem;
	    novo->prox = lista;
	    return novo;
	  }
}

Lista_Encadeada pop_lista_encadeada (Lista_Encadeada lista){
	if (lista != NULL){
           Lista_Encadeada aux = lista->prox;	   
	   if (aux->elem != NULL);
	   //free(aux->elem);	   
	   free(lista);
	   return aux;
	}
	return NULL;
};

void* busca_lista_encadeada (Lista_Encadeada lista,void* elem,int (*cmp)(void* a,void* b)){
	if(lista != NULL){
		if(!(*cmp)(lista->elem,elem))
			return lista->elem;
		else
			return busca_lista_encadeada(lista->prox,elem,(*cmp));
	}return NULL;
}

void imprime_lista_encadeada (FILE* arquivo,Lista_Encadeada lista, void (*imprime)(FILE* _arquivo_,void *elem)){
	if (lista != NULL){
	imprime (arquivo,lista->elem);
	imprime_lista_encadeada(arquivo,lista->prox,imprime);
	}
}

void imprime_lista (Lista_Encadeada lista,void (*imprime)()){
	if (lista != NULL){
	  if (lista->elem != NULL){
	      imprime(lista->elem);
	      imprime_lista(lista->prox,imprime);
	  }
	}
};

Lista_Encadeada insere_ordenado_lista_encadeada (Lista_Encadeada lista,void* elem, int (*cmp)(void* elem1,void* elem2)){
	if (elem != NULL){
		if (lista == NULL){
			Lista_Encadeada novo = construtor_lista_encadeada();
			novo->elem = elem;
			return novo;
		}else{
			if (((*cmp)(lista->elem,elem)+1))
				return push_lista_encadeada(lista,elem);
			else
			{
				lista->prox = insere_ordenado_lista_encadeada(lista->prox,elem,cmp);}
				return lista;
		}
	}else
	return lista;
}

int insere_final (void *a, void* b){
	return -1;
}

void destrutor_void (void* elem){}

Lista_Encadeada retorna_prox (Lista_Encadeada lista){
	if (lista != NULL)
	return lista->prox;
	else return NULL;
}

void* retorna_conteudo (Lista_Encadeada lista){
	return lista->elem;
}

int tam_lista(Lista_Encadeada l){
      if(l == NULL)
	return 0;
      else 
	return 1 + tam_lista(l->prox);
}