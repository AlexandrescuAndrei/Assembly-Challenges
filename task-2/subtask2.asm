%include "../include/io.mac"

; declare your structs here

section .text
    global check_passkeys
    extern printf

check_passkeys:
    ;; DO NOT MODIFY
    enter 0, 0
    pusha

    mov ebx, [ebp + 8]      ; requests
    mov ecx, [ebp + 12]     ; length
    mov eax, [ebp + 16]     ;
    ;; DO NOT MODIFY

    ;; Your code starts here
outer_loop:
    push ebx
    push eax
    push ecx
    ;in eax avem elementul curent
    mov eax, 0
    imul eax, ecx, 55
    sub eax, 55
    add eax, ebx
    ;pun in dx parola elementului curent 
    mov dx, word[eax + 2]
    xor ebx, ebx
    mov bx, 1
    and bx, dx
    cmp bx, 0
    ;daca ultimul bit din parola este 0 
    je no_hacker
    shl bx, 15
    and bx, dx
    cmp bx, 0
    ;daca primul bit din parola este 0 
    je no_hacker
    xor ebx, ebx
    mov bx, dx
    shl bx, 8
    shr bx, 8
    mov eax, 1
    xor ecx, ecx
    ;in bx avem ultimii 8 biti din parola 
last_bits_loop:
    push eax
    and al, bl
    cmp al, 0
    je no_increment
    inc ecx
no_increment:
    pop eax
    shl eax, 1
    cmp ah, 0
    je last_bits_loop
    ; nr par de 1 rezulta ca nu e hacker
    test ecx, 1
    jz no_hacker
    xor ebx, ebx
    mov bx, dx
    shr bx, 8
    mov eax, 1
    xor ecx, ecx
    ;in bx avem primii 8 biti din parola 
first_bits_loop:
    push eax
    and al, bl
    cmp eax, 0
    je no_inc
    inc ecx
    no_inc
    pop eax
    shl eax, 1
    cmp ah, 0
    je first_bits_loop
    ;numar impar de 1 rezulta ca nu e hacker
    test ecx, 1
    jnz no_hacker

hacker:
    pop ecx
    pop eax
    mov byte[eax + ecx - 1], 1
    jmp continue
no_hacker:
    pop ecx
    pop eax
    mov byte[eax + ecx - 1], 0
continue:
    pop ebx
    dec ecx
    cmp ecx, 0
    ja outer_loop
    ;; Your code ends here

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY