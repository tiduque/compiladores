all:	
	flex -i analizador_lexico.l
	bison analizador_sintatico.y
	gcc -c lista_encadeada.c analizador_sintatico.tab.c tabelas.c
	gcc -o trab3 lista_encadeada.o analizador_sintatico.tab.o tabelas.o -lfl
	rm -f analizador*.c
	rm -f lex*.c
	rm -f *.o
#	pdflatex trab2.tex
clean:
#	rm -f analizador*.c
#	rm -f lex*.c
#	rm -f *.o
	rm -f trab3
	rm -f *~

test:
	./trab3 < ../trab2/exemplos/in1.gpt
	./trab3 < ../trab2/exemplos/in2.gpt
	./trab3 < ../trab2/exemplos/in3.gpt
	./trab3 < ../trab2/exemplos/in4.gpt
	./trab3 < ../trab2/exemplos/in5.gpt