
  ;|                                                                                       |
  ;| Digital Image Processing application in assembler.                                                |
  ;|_______________________________________________________________________________________|
  ;
  ;  Description: The main file of an application that execute simples DIP transformations.
  ; Authors: Felipe Omar and Fellipe Augusto
  ;
  ;  Target OS: Any
  ;
  ;  Dependencies: FreshLib - see includes in the source.
  ;
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

            ObjTemplate tfChild, TButton, btnStegJoin, \
                        x=550, y=150, \
                        width = 120, height = 24,\
                        Visible = TRUE, \
                        OnClick = stegJoinProc,\
                        Caption = 'Steg-Join'
            ObjTemplate tfChild, TButton, btnStegSplit, \
                        x=550, y=190, \
                        width = 120, height = 24,\
                        Visible = TRUE, \
                        OnClick = stegSplitProc,\
                        Caption = 'Steg-Split'


           ObjTemplate tfChild, TButton, btnNegative, \
                        x=550, y=70, \
                        width = 120, height = 24,\
                        Visible = TRUE, \
                        OnClick = negativeProc,\
                        Caption = 'Negativo'
          ObjTemplate tfChild or tfEnd,TButton,btnBlur,\
                      x=550, y=110,\
                      width=120,height=24,\
                      Visible=TRUE,\
                      OnClick=blurProc,\
                      Caption='Blur'


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
  insertIm1Msg text 'Img1 inserida com sucesso'
  insertIm2Msg text 'Img2 inserida com sucesso'
  insertIm1MsgErr text 'Erro ao Inserir Img1'
  insertIm2MsgErr text 'Erro ao Inserir Img2'

  char text 'a'
  image file 'UFRN-PNG.png'
  sizeof.image = $ - image
  ;image2 file 'linux_wall.png'
  ;sizeof.image2=$-image2
  name1 text 'fromfresh1.ppm'
  nameSteg text 'stegJoin.ppm'
  nameStegMain text 'stegMain.ppm'
  nameStegHide  text 'stegHide.ppm'
  countLines dd 0
  mychar dd 'c'
  ;pixel dd 'c'
  file_name db 'b'
  end_of_file dd 'EOF'


endg


  uglobal
    ClickCount dd ?
    aClickCount dd ?
    textToCopy        dd ?
    img               dd ?
    img1Dir           dd ?
    img2Dir           dd ?
    hImg1             dd ?
    hImg2             dd ?
    hImgNeg           dd ?
    msg               dd ?
    hFile             dd ?
    pixel_array       rd  1444
    pixel             dd ?
    cvtMsg            dd ?
    fd_out             rd 1
    ;Variaveis para esteganografia
    MSbits          dd ?
    LSbits          dd ?
    stegPixelFinal  dd ?
    hImgSteg        dd ?
    hImgMain        dd ?
    hImgHide       dd ?
    pixel2          dd ?
    msgIm2          dd ?
    cvtMsgMain      dd ?
    cvtMsgHide      dd ?



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
          exec img1Name, TEdit:GetText      ;Get Text
          mov [img1Dir],eax
          stdcall FileOpen,[img1Dir]        ;Open File with name img1Dir
          jc      .file_not_found
          mov     [hImg1],eax               ; move eax to hImg1
          stdcall ShowMessage,[frmMain],smiInformation,"Dialog",insertIm1Msg ,smbOK
          jmp .retProc

  .file_not_found:
          stdcall FileWriteString, [STDERR], <'Coudnt open file.', 13, 10>
          stdcall ShowMessage,[frmMain],smiError,"Dialog",insertIm1MsgErr ,smbOK
          jmp .retProc
          pop eax
.retProc:
          return
  endp


 proc insertImg2Proc,.self,.button
  begin
          push eax
          exec img2Name, TEdit:GetText      ;Get Text
          mov [img2Dir],eax
          stdcall FileOpen,[img2Dir]        ;Open File with name img1Dir
          jc      .file_not_found
          mov     [hImg2],eax               ; move eax to hImg1
          stdcall ShowMessage,[frmMain],smiInformation,"Dialog",insertIm2Msg ,smbOK
          jmp .retProc

  .file_not_found:
          stdcall FileWriteString, [STDERR], <'Coudnt open file.', 13, 10>
          stdcall ShowMessage,[frmMain],smiError,"Dialog",insertIm2MsgErr ,smbOK
          jmp .retProc
          pop eax
.retProc:

  return
  endp


  proc negativeProc,.self,.button
  begin
         xor ebx,ebx
         mov eax,8
         mov ebx,name1
         mov ecx,777
         int 0x80
         mov [hImgNeg],eax
        ;stdcall FileCreate,'fromfresh.txt'
        ;stdcall FileOpen,'fromfresh.txt'
        ; jc      .file_not_found
       ; mov [hImg2],eax



  .readLines:
          ;cmp [pixel_array+countLines],'EOF'
          ;cmp [countLines],3
          ;jne .readHeader
          stdcall FileReadLine,[hImg1]      ;read line
          jc      .error_read
          mov [msg],eax
         ; test  [msg],dword 'EOF'
          ;cmp eax, -1
          cmp  eax,0                            ;0 Indicates EOF
          jne .readFile
          jmp .fim_enquanto


;  .readHeader
;        inc [countLines]
;        stdcall FileReadLine,[hImg1]
;        jc .error_read
;        mov [msg],eax
;        stdcall FileWriteString,[STDERR],<eax,13,10>
;        jmp readLines

  .readFile:
          inc [countLines]
          cmp [countLines],4
          jle .readHeader                       ;se count <=4, ir para leitura do cabecalho
          jmp .readPixels
 .readHeader:
           stdcall FileWriteString, [STDERR], [msg]
           stdcall FileWriteString, [STDERR], <' ',13,10> ; print newline and line feed
           stdcall FileWriteString, [hImgNeg], [msg]
           stdcall FileWriteString, [hImgNeg], <' ',13,10> ; print newline and line feed
          jmp .readLines
 .readPixels:
          stdcall FileWriteString, [STDERR], [msg]
          stdcall FileWriteString, [STDERR], <' ',13,10> ; print newline and line feed
          stdcall StrToNum,[msg]
          mov [pixel],eax                     ;pixel is a number variable
          ;add [pixel],5
          mov edx,255
          sub edx,[pixel]
          mov [pixel],edx
          ;mov ebx,5
          stdcall NumToStr,[pixel],ntsDec or ntsUnsigned
          mov [cvtMsg],eax

;          stdcall CreateArray
         ; mov [pixel],eax
         ;stdcall FileWriteString, [STDERR], [cvtMsg]
          ;mov [pixel],eax
          ; add [pixel],5
;          stdcall NumToStr,[pixel],ntsUnsigned or ntsFixedWidth + 8
;          mov [cvtMsg],eax


;          stdcall FileWriteString,[STDOUT],pixel
         ; stdcall StrSaveToFile,name1
;          stdcall CreateArray,4
;          mov edx,eax
;          mov dword [edx],'casa'
;          mov dword [edx+1],13
;          mov dword [edx+2],10
;          mov dword [edx+3],'k'
;          add edx,4
         ;Open file using syscall linux
;         mov eax,4
;         mov ebx,[fd_out]
;         mov ecx,cvtMsg
;         mov edx,4
;         int 0x80
         stdcall FileWriteString, [hImgNeg], [cvtMsg]
         stdcall FileWriteString,[hImgNeg],<'',13,10>


          jmp .readLines
  .fim_enquanto:
            stdcall FileWriteString, [STDERR], <'Fim do while', 13, 10>
            mov     eax,6
            mov     ebx,[fd_out]
            int     0x80
            jmp    .retProc

  .error_read:
          stdcall FileWriteString, [STDERR], <'Source file read error.', 13, 10>
          jmp .retProc

  .retProc:
;        set [imageForm],TImageLabel:Image,[hImgNeg]
        return
  endp
  proc blurProc
  begin
  return
  endp

proc stegJoinProc,.self,.button
    begin

         mov eax,8
         mov ebx,nameSteg
         mov ecx,777
         int 0x80
         mov [hImgSteg],eax
         mov [countLines],0
  .readLines:
         stdcall FileReadLine,[hImg1]      ;read line
         jc      .error_read
         mov [msg],eax
         stdcall FileReadLine, [hImg2]
         jc      .error_read
         mov [msgIm2], eax
         cmp  eax,0
         jne    .readFile
         jmp    .fim_enquanto
 .readFile:
          inc [countLines]
          cmp [countLines],4
          jle .readHeader                       ;se count <=4, ir para leitura do cabecalho
          jmp .readPixels
 .readHeader:
           stdcall FileWriteString, [STDERR], [msg]
           stdcall FileWriteString, [STDERR], <' ',13,10> ; print newline and line feed
           stdcall FileWriteString, [hImgSteg], [msgIm2]
           stdcall FileWriteString, [hImgSteg], <' ',13,10> ; print newline and line feed
          jmp .readLines

 .readPixels:
          ;stdcall FileWriteString, [STDERR], [msg]
          ;stdcall FileWriteString, [STDERR], <' ',13,10> ; print newline and line feed

          stdcall StrToNum,[msg]        ;componente da imagem 1
          mov [pixel],eax
          stdcall StrToNum,[msgIm2]
          mov [pixel2],eax
          ;Steganography process
          and [pixel],0x00F8
          and [pixel2],0x00E0
          shr [pixel2],5        ;right-shift 5 positions
          mov eax,[pixel2]
          or eax,[pixel]
          mov [stegPixelFinal],eax
          stdcall NumToStr,[stegPixelFinal],ntsDec or ntsUnsigned
          mov [cvtMsg],eax
          stdcall FileWriteString, [hImgSteg], [cvtMsg]
          stdcall FileWriteString,[hImgSteg],<'',13,10>
           stdcall FileWriteString, [STDERR], [cvtMsg]
          stdcall FileWriteString,[STDERR],<'',13,10>

         jmp .readLines
 .fim_enquanto:
          stdcall FileWriteString, [STDERR], <'Fim do while', 13, 10>
            mov     eax,6
            mov     ebx,[hImgSteg]
            int     0x80
          jmp .retProc
 .error_read:
          stdcall FileWriteString, [STDERR], <'Source file read error.', 13, 10>
          jmp .retProc





 .retProc:
         return
  endp
  proc stegSplitProc, .self,.button
       begin
       mov eax,8
       mov ebx,nameStegMain   ;create files for Main Image and Hide Image
       mov ecx,777
       int 0x80
       mov [hImgMain],eax
       mov eax,8
       mov ebx,nameStegHide
       mov ecx,777
       int 0x80
       mov [hImgHide],eax
       mov [countLines],0
       mov [msg],0
       mov [pixel],0
       mov [pixel2],0
       mov [cvtMsg],0
.readLines:
      ;Read Lines from uploaded image on field 1
       stdcall FileReadLine,[hImg1]
       jc      .error_read
       mov [msg],eax
       cmp  eax,0                            ;0 Indicates EOF
       jne .readFile
       jmp .fim_enquanto
.readFile:
       inc [countLines]
       cmp [countLines],4
       jle .readHeader                       ;se count <=4, ir para leitura do cabecalho
       jmp .readPixels
 .readHeader:
       stdcall FileWriteString, [STDERR], [msg]
       stdcall FileWriteString, [STDERR], <' ',13,10> ; print newline and line feed
       stdcall FileWriteString, [hImgMain], [msg]
       stdcall FileWriteString, [hImgMain], <' ',13,10> ; print newline and line feed
       stdcall FileWriteString, [hImgHide], [msg]
       stdcall FileWriteString, [hImgHide], <' ',13,10> ; print newline and line feed
       jmp .readLines
.readPixels:
       ;Write Main Image
       stdcall StrToNum,[msg]        ;componente da imagem
       mov [pixel],eax
       mov [pixel2],eax
       and [pixel2],0x00F8
       stdcall NumToStr,[pixel2],ntsDec or ntsUnsigned
       mov [cvtMsg],eax
       stdcall FileWriteString, [hImgMain], [cvtMsg]
       stdcall FileWriteString,[hImgMain],<'',13,10>
       ;Write Hide Image
       and [pixel],0x0007       ;get 3 first bits
       shl [pixel],5            ;left-shift by 5
       stdcall NumToStr,[pixel],ntsDec or ntsUnsigned ;convert to string to write in file
       mov[cvtMsg],eax                 ;cvtMsg = string that will be write in image
       stdcall FileWriteString, [hImgHide], [cvtMsg]
       stdcall FileWriteString,[hImgHide],<'',13,10>
       jmp .readLines
.fim_enquanto:
        stdcall FileWriteString,[STDERR],<'Fim do while',13,10>
        jmp .retProc
 .error_read:
          stdcall FileWriteString, [STDERR], <'Source file read error.', 13, 10>
          jmp .retProc












 .retProc:
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

