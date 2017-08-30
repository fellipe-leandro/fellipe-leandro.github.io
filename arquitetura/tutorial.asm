TITLE - PROGRAMA TUTORIAL  1 - TASM 
COMMENT *PROGRAMA EXEMPLO FEITO EM UMA UNICA PROCEDURE -
         ESTE PROGRAMA DEVE SER EXECUTADO ATRAVES DO DEBUG
         AUTOR: FELLIPE AUGUSTO *

SENHA1 EQU "ca"
SENHA2 EQU "sa"

;Area de definição de modelo
	DOSSEG
	.MODEL small
;Area de definição de pilha
	.STACK
	
;Area de definição de dados

	.DATA
val1	DW 	00H
val2 	DW	00H
MSG_1   DB 'Bem-vindo','$'

	.CODE
PPrinc  PROC		; Inicio do procedimento "PPrinc"
    MOV AX,@DATA   	; 
    MOV DS,Ax       ; Faz DS apontar para area de dados do programa
    ;lea dx,val1
    ;lea dx, val2
    LEA DX,MSG_1
    MOV AH,09H
    INT 21H










    MOV AH,4Ch	; Função para encerrar programa e retornar ao SO
    INT 21H	
PPrinc  ENDP		; Diretiva para enceramento da procedure "PPrinc"
        END PPrinc	; Diretiva de encerramento de montagem
