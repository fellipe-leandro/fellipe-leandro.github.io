section .data

senha1      db 'casa'
msg_1       db 'Bem-vindo',0
len_msg_1   equ $-msg_1       
msg_2       db 'Digite sua senha',0
len_msg_2   equ $-msg_2
msg_err     db 'Senha errada,digite novamente',0
len_msg_err equ $-msg_err
msg_ok      db 'Senha correta - FIM',0
len_msg_ok  equ $-msg_ok
cr          db  0xd
lf          db  0xa
psswd       times 4 db 0

section .text
global main
main:
    mov ebp, esp; for correct debugging
;Printar Msg inicial
    mov     eax,4       ;sys_write: system call to write string
    mov     ebx,1       ;stdout: file descriptor (1=stdout,0=stdin,2 = stderr)
    mov     ecx,msg_1 ;pointer to variable
    mov     edx,len_msg_1 ;size of buffer
    int     0x80
    call    endl
    mov eax,4       ;sys_write
    mov ebx,1       ;stdout
    mov ecx,msg_2 ;pointer to variable
    mov edx,len_msg_2 ;size of buffer
    int 0x80
    
InsertCharSetup:
    mov ecx,0x4    ;working with 32-bits now!
    mov esi,psswd  ;in masm, it will require OFFSET keyword
;    xor esi,esi
InsertChar:
   ; read and store user input
    mov eax,3       ;sys_read
    mov ebx,0       ;stdin?
    push ecx
    mov ecx,esi
    mov edx,1
    int 0x80
    pop ecx
    inc esi
    loop InsertChar

CompPsswdSetup:
    mov ecx,0x4
    mov esi,senha1
    mov ebx,psswd
CompPsswd:
    mov al,[esi]
    mov ah,[esi]
    cmp al,ah
;    jne MsgErr
;    inc esi
;    inc ebx
;    loop CompPsswd
;    jmp MsgOk
    
    

    
    ;Exit
    mov eax,1
    ;mov ebx,0
    int 0x80
;

endl:
    mov eax,4
    mov ebx,1
    mov ecx,lf
    mov edx,0x01
    int 0x80
    mov eax,4
    mov ebx,1
    mov ecx,cr
    mov edx,0x01
    int 0x80
        ret


















;endl:
