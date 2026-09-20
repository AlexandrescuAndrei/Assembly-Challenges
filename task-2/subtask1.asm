%include "../include/io.mac"

; declare your structs here

section .text
    global sort_requests
    extern printf

sort_requests:
    ;; DO NOT MODIFY
    enter 0,0
    pusha

    mov ebx, [ebp + 8]      ; requests
    mov ecx, [ebp + 12]     ; length
    ;; DO NOT MODIFY

    ;; Your code starts here
outer_loop:
    mov eax, ecx
    dec eax

inner_loop:
    ;pun pe stiva elementul din vector de la pozitia eax - 1
    mov edx, eax
    dec edx
    mov eax, 0
    imul eax, edx, 55
    add eax, ebx
    push eax
    mov eax, edx
    inc eax

    ;pun pe stiva elementul din vector de la pozitia ecx - 1
    mov edx, ecx
    dec edx
    mov ecx, 0
    imul ecx, edx, 55
    add ecx, ebx
    push ecx
    mov ecx, edx
    inc ecx

    ;compar elementele
    push ebx
    mov ebx, [esp + 4]
    mov edx, [esp + 8]
    push eax
    push ecx

    ;mut in al primul byte din v[eax - 1]
    ;mut in cl primul byte din v[ecx - 1]
    mov eax, 0
    mov ecx, 0
    mov al, byte[edx]
    mov cl, byte[ebx]
    cmp ecx, eax
    ja schimbare
    jb sortat
    ;mut in al al doilea byte din v[eax - 1]
    ;mut in cl al doilea byte din v[ecx - 1]
    mov eax, 0
    mov ecx, 0
    mov al, byte[edx + 1]
    mov cl, byte[ebx + 1]
    cmp eax, ecx
    ja schimbare
    jb sortat
    ;comparam username 
    mov eax, 0
    mov ecx, 0
    char_loop:
    mov ah, byte[ebx + ecx + 4]
    mov al, byte[edx + ecx + 4]
    inc ecx
    cmp ah, al
    ja sortat
    jb schimbare
    cmp ecx, 51
    jb char_loop
schimbare:
    push eax
    push ecx
    mov ecx, 0
swap_55bytes:
    mov ah, byte[ebx + ecx]
    mov al, byte[edx + ecx]
    mov byte[ebx + ecx], al
    mov byte[edx + ecx], ah
    inc ecx
    cmp ecx, 55
    jb swap_55bytes
    pop ecx
    pop eax
sortat:
    pop ecx
    pop eax
    pop ebx
    pop edx
    pop edx
    dec eax
    cmp eax, 0
    ja inner_loop
    dec ecx
    cmp ecx, 1
    ja outer_loop
    ;; Your code ends here

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY