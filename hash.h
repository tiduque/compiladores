//hash.h
#ifndef hash_h
#define hash_h

#define tam 1021

typedef Lista_Encadeada tb_variaveis[tam] Hash;

void  inserir_hash(Hash);
void* buscar_hash(Hash, char*);
void  imprimir_hash(Hash);
void  limpa_hash(Hash); 
#endif
