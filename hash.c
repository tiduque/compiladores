#include "hash.h"
#include<stdio.h>
#include<stdlib.h>
#include "lista_encadeada.h"

typedef Lista_Encadeada tb_variaveis[1021] Hash;

void  inserir_hash  (Hash h,char* n){
      int i,k;
      for (i=0,k = 0;n[k]!='\0';k++) 
	i=i+(int)n[k];
      h[i] = insere_ordenado_lista_encadeada(h[i],strcmp);
}
void* buscar_hash   (Hash, char*);
void  imprimir_hash (Hash);
void  limpa_hash    (Hash); 