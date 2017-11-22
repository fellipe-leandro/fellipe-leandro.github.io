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
file_name db '/home/fellipe/fresh_2.6.1/projects/text'
name text '/home/fellipe/fresh_2.6.1/projects/fromfresh.txt'
name1 text '/home/fellipe/fresh_2.6.1/projects/tofresh.txt'
txt text  'ooioioii'
endg
uglobal

fd_out rd 1
hFile dd ?
msg   dd ?
info rd  1
mytext rd 1
endg




start:
        InitializeAll
       ; stdcall FileCreate, 'fromfresh.txt'; Funcao testada - OK
       ; stdcall StrSaveToFile,name1,txt ; Funcao testada (parametros devem ser definidos como text)
       stdcall FileOpen,name ;open file and get its handle
       jc      .file_not_found
       mov [hFile],eax
;       mov myfile,eax
       stdcall FileReadLine,[hFile]
       jc      .error_read
       mov [msg],eax


       ;mov [mytext],eax

       stdcall StrSaveToFile,name1,[msg]
      ; stdcall FileClose,[fd_in]
       stdcall FileClose, ebx
       jmp .terminate

       .error_read:
       stdcall FileWriteString, [STDERR], <'Source file read error.', 13, 10>
       jmp .terminate

       .file_not_found:
       stdcall FileWriteString, [STDERR], <'Coudnt open file.', 13, 10>
       jmp .terminate










.terminate:
        push    eax
        FinalizeAll

        stdcall TerminateAll   ; from the stack
