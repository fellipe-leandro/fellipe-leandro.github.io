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
                     width = 720,    \
                     height = 480,   \
                     OnCreate = FormOnCreate,                   \
                     Caption = 'Digital Image Processing App'

           ObjTemplate tfChild, TImageLabel, imageForm,  \
                       x = 16, y = 64,            \
                       width = 410, height = 440,   \
                       Visible = TRUE,           \
                       Image = [img],       \
                       Caption = 'LabelForm'
          ObjTemplate tfChild or tfEnd, TButton, btnNegative, \
                      x=550, y=70, \
                      width = 120, height = 32,\
                      Visible = TRUE, \
                      Caption = 'Negativo'






endg


uglobal
  ClickCount dd ?
  aClickCount dd ?
  textToCopy        dd ?
  img               dd ?

endg

cCaption text 'Clicked: '
aCaption text 'Fellipe Leandro'
aCaption2 text 'UFRN - 2017'
warningCopy text 'Nada Digitado'
char text 'a'
image file 'jubs.png'
sizeof.image = $ - image


proc FormOnCreate as TObject.OnCreate
begin
;        mov eax,1

 ;

        stdcall CreateImagePNG,image,sizeof.image
        mov [img],eax
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
