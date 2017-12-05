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

  cCaption text 'Clicked: '
  aCaption text 'Fellipe Leandro'
  aCaption2 text 'UFRN - 2017'
  warningCopy text 'Nada Digitado'
  char text 'a'
  image file 'jubs.png'
  sizeof.image = $ - image
  ;image2 file 'linux_wall.png'
  ;sizeof.image2=$-image2
  name1 text 'fromfresh.txt'
  name2 text 'teste'
  countLines db 0
  msg_t dd 0,1,2,3,4,5








  endg


  uglobal
    ClickCount        dd ?
    aClickCount       dd ?
    textToCopy        dd ?
    img               dd ?
    img1Dir           dd ?
    img2Dir           dd ?
    hImg1             dd ?
    hImg2             dd ?
    msg               rd 50
    hFile             dd ?
    pixel_array       rd 5

  endg




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
         ; stdcall StrSaveToFile,name2,[msg_t]
          exec img1Name, TEdit:GetText      ;Get Text
          mov [img1Dir],eax
        ;  getfile img0,"pic.png"
          stdcall FileOpen,[img1Dir]        ;Open File with name img1Dir
          jc      .file_not_found
         ; stdcall FileWriteString, [STDERR], <'Deu bom.', 13, 10> ;For debug
          mov [hImg1],eax               ; handle to file (pointer)
          mov  ebx,msg
         ; stdcall FileOpen,'fromfresh.txt'
          ;jc .file_not_found
          ;mov [hImg2],eax

  .readLines:
          ;cmp [pixel_array+countLines],'EOF'
          cmp [countLines],2
          jne .repita
          jmp .fim_enquanto
  .repita:
          inc [countLines]
          stdcall FileReadLine,[hImg1]      ;read line
          jc      .error_read
          mov [ebx], eax                     ;move line to variable
          inc ebx
         ; stdcall StrSaveToFile,name1,[msg] ;writes string [msg] into file name1
        ; stdcall FileWriteString, [hImg1], [msg]
          ;stdcall FileReadLine,[hImg2]
          jmp .readLines
  .fim_enquanto:
          ;Fazer uma estrutura while(line!=EOF)
          stdcall StrSaveToFile,name1,[msg] ;writes string [msg] into file name1
          stdcall FileWriteString, [STDERR], <'Fim do while.', 13, 10>
          jmp     .retProc
;
  .file_not_found:
          stdcall FileWriteString, [STDERR], <'Coudnt open file.', 13, 10>
          jmp .retProc
;
  .error_read:
          stdcall FileWriteString, [STDERR], <'Source file read error.', 13, 10>
          jmp .retProc


    ;        stdcall CreateImagePNG,image2,sizeof.image2
    ;        mov [img],eax
    ;       set [img2Name],TEdit:Text,[img1Dir]
    ;      set [imageForm],TImageLabel:Image,[img]
;
          pop eax
.retProc:
        ;stdcall FileClose, ebx
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

