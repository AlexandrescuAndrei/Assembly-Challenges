%include "../include/io.mac"

extern printf
extern position
global solve_labyrinth

; you can declare any helper variables in .data or .bss

section .text

; void solve_labyrinth(int *out_line, int *out_col, int m, int n, char **labyrinth);
solve_labyrinth:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     eax, [ebp + 8]  ; unsigned int *out_line, pointer to structure containing exit position
    mov     ebx, [ebp + 12] ; unsigned int *out_col, pointer to structure containing exit position
    mov     ecx, [ebp + 16] ; unsigned int m, number of lines in the labyrinth
    mov     edx, [ebp + 20] ; unsigned int n, number of colons in the labyrinth
    mov     esi, [ebp + 24] ; char **a, matrix represantation of the labyrinth
    ;; DO NOT MODIFY
   
    ;; Freestyle starts here
    push eax
    push ebx
    xor eax, eax
    xor ebx, ebx
    dec ecx  ;in ecx avem m - 1
    dec edx  ;in edx avem n - 1
outer_loop:
    cmp eax, ecx
    ;daca am ajuns la ultima linie 
    je end_loop
    cmp ebx, edx
    ;daca am ajuns la ultima coloana 
    je end_loop
    push ecx
    push edx
    xor ecx, ecx
    imul ecx, eax, 4
    add ecx, esi
    mov edx, [ecx]
    add edx, ebx
    ;punem 1 in elementul curent 
    mov byte[edx], '1'


    ;elementul din nord
nord:
    dec eax
    cmp eax, -1
    je vest
    xor ecx, ecx
    imul ecx, eax, 4
    add ecx, esi
    mov edx, [ecx]
    add edx, ebx
    cmp byte[edx], '0'
    je next


    ;elementul din vest
vest:
    inc eax
    dec ebx
    cmp ebx, -1
    je sud
    xor ecx, ecx
    imul ecx, eax, 4
    add ecx, esi
    mov edx, [ecx]
    add edx, ebx
    cmp byte[edx], '0'
    je next


    ;elementul din sud
sud:
    inc ebx
    inc eax
    xor ecx, ecx
    imul ecx, eax, 4
    add ecx, esi
    mov edx, [ecx]
    add edx, ebx
    cmp byte[edx], '0'
    je next


    ;elementul din est
est:
    dec eax
    inc ebx



next:
    pop edx
    pop ecx
    jmp outer_loop
end_loop:
    mov ecx, eax  ;ecx contine linia
    mov edx, ebx  ;edx contine coloana 
    pop ebx
    pop eax
    mov dword[eax], ecx
    mov dword[ebx], edx 



    ;; Freestyle ends here
end:
    ;; DO NOT MODIFY

    popa
    leave
    ret
    
    ;; DO NOT MODIFY
