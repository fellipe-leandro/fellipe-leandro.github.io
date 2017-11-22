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
                       x = 8, y = 80,            \
                       width = 410, height = 440,   \
                       Visible = TRUE,           \
                       Image = [img],       \
                       Caption = 'LabelForm'
         ObjTemplate  tfChild, TTreeView, tvFolders,  \
                     x=450,y=200,\
                     width = 200,height = 200,\
                     SplitCell = SplitTest.cellTree,            \
                     Visible = TRUE
         ObjTemplate tfChild,TEdit,img1Name,\
                     x=32,y=8,\
                     width=152,height = 24,\
                     Visible=TRUE
         ObjTemplate tfChild,TEdit,img2Name,\
                    x=32,y=40,\
                    width=152,height=24,\
                    Visible=TRUE
         ObjTemplate tfChild,TButton,btnInsertImg1,\
                    x=192,y=8,\
                    width=88,height=24,\
                    Visible=TRUE,\
                    OnClick = insertImg1Proc,\
                    Caption='Insert Img 1'

         ObjTemplate tfChild,TButton,btnInsertImg2,\
                   x=192,y=40,\
                   width=88,height=24,\
                   Visible=TRUE,\
                   OnClick=insertImg2Proc,\
                   Caption='Insert Img 2'


         ObjTemplate tfChild or tfEnd, TButton, btnNegative, \
                      x=550, y=70, \
                      width = 120, height = 20,\
                      Visible = TRUE, \
                      Caption = 'Negativo'


SplitStart SplitTest

  Split stVert or stJustGap , 4, 24, 16, 48
    Split stHoriz or stOriginBR or stJustGap, 4, 64, 48, 200
      Cell cellEdit
      Cell cellButton

    Cell cellTree

SplitEnd







endg


uglobal
  ClickCount dd ?
  aClickCount dd ?
  textToCopy        dd ?
  img               dd ?
  img1Dir           dd ?
  img2Dir           dd ?

endg

cCaption text 'Clicked: '
aCaption text 'Fellipe Leandro'
aCaption2 text 'UFRN - 2017'
warningCopy text 'Nada Digitado'
char text 'a'
image file 'abraco_bike.png'
sizeof.image = $ - image
image2 file 'linux_wall.png'
sizeof.image2=$-image2


proc FormOnCreate as TObject.OnCreate
begin
;        mov eax,1

 ;

        stdcall CreateImagePNG,image,sizeof.image
        mov [img],eax
        return

endp

proc insertImg1Proc, .self,.button
begin
        push eax
       ; exec img1Name, TEdit:GetText ;Get Text
       ; mov [img1Dir],eax
      ;  getfile img0,"pic.png"
        stdcall CreateImagePNG,image2,sizeof.image2
        mov [img],eax

;        set [img2Name],TEdit:Text,eax

       set [imageForm],TImageLabel:Image,[img]

        pop eax
        return
endp
proc insertImg2Proc,.self,.button
begin
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

