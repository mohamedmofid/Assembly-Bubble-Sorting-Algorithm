.MODEL small
.STACK 100h

.DATA
    array DB 5, 2, 7, 1, 9, 3, 6, 4, 8, 0  ; Sample array to be sorted
    array_size equ 10                      ; Size of the array
    seprator DB ' ', '$'                   
    pre_msg DB 10, 'The unsorted array is: ', '$'
    after_msg DB 10, 'The sorted array is: ', '$'

.CODE
MAIN PROC
.STARTUP
    ;Display the unsorted array
    lea dx, pre_msg
    call print_str
    call display_array

    mov cx, array_size  ; Outer loop counter
    dec cx              ; Set loop iterations
    mov bl, 1           ; Set flag initially to true (1)

outer_loop:
    mov bx, 0           ; Inner loop counter
    mov bh, 0           ; Reset the swap flag for each outer loop iteration
    
inner_loop:
    mov si, bx               ; Save current index
    inc si                   ; Increment index for comparison
    
    mov al, [array + bx]     ; Load array element
    cmp al, [array + si]     ; Compare with next element
    
    jle no_swap          ; If not greater, no swap needed
    
    ; Swap elements
    mov al, [array + bx]     ; Load first element to AL
    mov dl, [array + si]     ; Load second element to DL
    mov [array + bx], dl     ; Move second element to first position
    mov [array + si], al     ; Move first element to second position
    
    mov bh, 1               ; Set swap flag to true (1)
    
no_swap:
    inc bx               ; Move to next element
    cmp bx, cx           ; Check inner loop end condition
    jl inner_loop
    
    test bh, bh          ; Check if any swap occurred in this iteration
    jnz outer_loop       ; If so, continue sorting
    
    ; Display sorted array
    lea dx, after_msg
    call print_str
    call display_array


.EXIT    
MAIN ENDP
display_array PROC NEAR
    mov cx, array_size   ; Counter for looping through array
    mov si, 0            ; init index
    
print_loop:
    mov dl, [array + si]   ; Load value from array
    add dl, '0'            ; Convert numeric value to ASCII character
    
    mov ah, 02h            ; DOS function to print character
    int 21h                ; Call DOS

    call insert_seprator
    
    inc si                 ; Move to next element
    loop print_loop         ; Loop until all elements printed
display_array ENDP
print_str PROC NEAR
    MOV AH,09H
    INT 21H 
    RET
print_str ENDP

insert_seprator PROC NEAR
    LEA DX,seprator
    CALL print_str
    RET
insert_seprator ENDP

END MAIN
