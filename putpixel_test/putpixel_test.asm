global _main
extern _ExitProcess@4
extern _pix_init
extern _pix_deinit
extern _pix_process_events
extern _pix_put
extern _pix_clear
extern _pix_flip
extern _pix_is_window_open


;;;;;;;;;;;;
; CODE
;;;;;;;;;;;;

section .text

draw_rect:
    %define offset_x dword [ebp + 8]
    %define offset_y dword [ebp + 12]
    %define w dword [ebp + 16]
    %define h dword [ebp + 20]
    %define r dword [ebp + 24]
    %define g dword [ebp + 28]
    %define b dword [ebp + 32]

    push ebp
    mov ebp, esp
    sub esp, 8
    %define current_x dword [ebp - 4]
    mov current_x, 0
    %define current_y dword [ebp - 8]
    mov current_y, 0
    push eax

    .loop_x:
        .loop_y:
            push r
            push g
            push b
            mov eax, current_y
            add eax, offset_y
            push eax
            mov eax, current_x
            add eax, offset_x
            push eax
            call _pix_put
            add esp, 5*4
            inc current_y
            mov eax, h
            cmp current_y, eax
            jl .loop_y

        mov current_y, 0
        inc current_x
        mov eax, w
        cmp current_x, eax
        jl .loop_x

    pop eax
    mov esp, ebp
    pop ebp
    ret

_main:
    push 720
    push 1280
    push window_title
    call _pix_init
    add esp, 3*4

    .window_loop:
        call _pix_clear

        ; x, y, w, h, r, g, b
        mov eax, 255
        sub eax, dword [color]
        push color
        push eax
        push 255
        push dword [move]
        push dword [move]
        push 0
        push dword [move]
        call draw_rect
        add esp, 7*4

        inc dword [move]
        cmp dword [move], 500
        jl .no_move_reset
        mov dword [move], 0
        .no_move_reset:

        inc dword [color]
        cmp dword [color], 255
        jl .no_color_reset
        mov dword [color], 0
        .no_color_reset:

        call _pix_flip
        call _pix_process_events
        call _pix_is_window_open
        cmp eax, 0
        jne .window_loop

    push 0
    call _ExitProcess@4


;;;;;;;;;;;;
; DATA
;;;;;;;;;;;;

section .data
window_title: db "PUTPIXEL TEST 2000", 0
move: dd 0
color: dd 0
