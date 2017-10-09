; _______________________________________________________________________________________
;|                                                                                       |
;| Portable GUI application in assembler.                                                |
;|_______________________________________________________________________________________|
;
;  Description: The main file of very simple example demonstrating how to write portable
;               GUI applications using FreshLib.
;
;  Target OS: Any
;
;  Dependencies: FreshLib - see includes in the source.
;_________________________________________________________________________________________

include '%lib%/freshlib.inc'
@BinaryType GUI

ThemeGUI equ win_gui            ; flat_gui, win_gui or any other theme in the "gui/themes/" directory.

include '%lib%/freshlib.asm'

options.FastEnter         = 0           ; enter/leave or push ebp/pop ebp approach to the procedures.
options.ShowSkipped       = 0           ; shows the procedures skiped because of no use.
options.ShowSizes         = 1           ; enable/disable work of DispSize macro.
options.DebugMode         = 0           ; enable/disable macroses of simpledebug library.


iglobal
  frmMainForm:
        ObjTemplate  tfParent or tfEnd, TForm, frmMain, \
                     x = 100,        \
                     y = 90,         \
                     width = 320,    \
                     height = 240,   \
                     Caption = 'FreshLib portable application.'

           ObjTemplate tfChild, TButton, btnTest,  \
                       x = 50, y = 50,            \
                       width = 128, height = 24,   \
                       Visible = TRUE,           \
                       TextAlign = dtfAlignCenter or dtfAlignMiddle, \
                       IconPosition = AlignLeft,                     \
                       OnClick = procOnClick, \
                       Caption = 'Do something'
          ObjTemplate tfChild, TButton, btnCopy, \
                      x=50, y=150, \
                      width = 128, height = 24,\
                      Visible = TRUE, \
                      OnClick = procCopy,\
                      Caption = 'Copy!'

          ObjTemplate tfChild, TEdit,Text1 ,\
                      x=50,y=80, \
                      width=150,height =20, \
                      Visible = TRUE
          ObjTemplate tfChild, TEdit,Text2,\
                      x=50,y=110, \
                      width = 150,height = 20 ,\
                      Visible = TRUE


           ObjTemplate tfChild or tfEnd, TButton, btnTest1,  \
                      x = 50, y = 200, \
                      width = 128, height = 24, \
                      Visible = TRUE,   \
                      TextAlign = dtfAlignCenter or dtfAlignMiddle, \
                      IconPosition = AlignLeft, \
                      OnClick = myproc, \
                      Caption = 'Author'
endg


uglobal
  ClickCount dd ?
  aClickCount dd ?
  textToCopy        dd ?

endg

cCaption text 'Clicked: '
aCaption text 'Fellipe Leandro'
aCaption2 text 'UFRN - 2017'
warningCopy text 'Nada Digitado'
char text 'a'




proc procOnClick, .self, .button
begin
; On click handler for the button.

        inc     [ClickCount]

        stdcall NumToStr, [ClickCount], ntsDec or ntsUnsigned
        push    eax
        push    eax
        stdcall StrDup, cCaption
        stdcall StrCat, eax ; second from the stack.
        stdcall StrDel ; from the stack.
        push    eax

        set     [btnTest], TButton:Caption, eax

        stdcall StrDel ; from the stack.

        return
endp

proc myproc, .self,.button
begin
        inc [aClickCount]
        mov eax,[aClickCount]
        cmp eax,0x01
        jne .SecondClick     ; Local labels start with '.'
        mov eax,aCaption
        set [btnTest1],TButton:Caption,eax
        jmp .returnProc
       .SecondClick:

        mov eax,aCaption2
        set [btnTest1],TButton:Caption,eax
        mov eax,0x00
        mov [aClickCount],eax
       .returnProc:
        return
endp
proc procCopy, .self,.button
begin
        exec Text1, TEdit:GetText ;Metodo da classe TEdit. Retorna em ponteiro para string em eax
;        mov textToCopy,eax
;         pop eax
;         mov eax,char
        push eax    ;to save string
        stdcall StrLen,eax    ;Returns the length of the string in bytes, in eax
        cmp eax,0x00 ; checa se usuario digitou algo
        je .StringVazia
        pop eax    ;return string to eax
;        set [btnTest1],TButton:Caption,eax
        set [Text2],TEdit:Text,eax
        jmp .procReturn
        .StringVazia:
;        mov eax, warningCopy
         stdcall ShowMessage,[frmMain],smiWarning,"Dialog",warningCopy ,smbOK
         .procReturn:



return
endp




; Main Program
start:
        InitializeAll

        create  ebx, TApplication
        jc      .terminate

        mov     [pApplication], ebx

        call    GUI.Init

        stdcall CreateFromTemplate, frmMainForm, 0

        set     [pApplication], TApplication:MainWindow, frmMain

        set     [frmMain], TWindow:Visible, TRUE

        stdcall Run

.terminate:
        push    eax
        FinalizeAll

        stdcall TerminateAll    ; from the stack

; end of main program

               
