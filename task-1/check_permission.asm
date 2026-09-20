%include "../include/io.mac"

extern ant_permissions

extern printf
global check_permission

section .text

check_permission:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     eax, [ebp + 8]  ; id and permission
    mov     ebx, [ebp + 12] ; address to return the result
    ;; DO NOT MODIFY
   
    ;; Your code starts here
    ; in edx am salile pe care vrea sa le rezerve
    mov edx, eax
    shl edx, 8
    shr edx, 8
    ; in ecx am id-ul furnicii
    mov ecx, eax
    shr ecx, 24
    ; pun in eax permisiunile furnicii
    mov eax, dword[ant_permissions + 4 * ecx]
    and eax, edx
    cmp eax, edx 
    jne negative
    mov dword[ebx], 1
    jmp end_function

negative:
    mov dword[ebx], 0
end_function:
    ;; Your code ends here
    
    ;; DO NOT MODIFY

    popa
    leave
    ret
    
    ;; DO NOT MODIFY
