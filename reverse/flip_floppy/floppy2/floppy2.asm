; Évaluation perso: Medium/Hard

; TODO
; - Tester défi avec gdb-multiarch pour voir si plus faisable avec un gdb 16 bits

; Description du défi doit contenir:
; - WASD pour commencer et jouer
; - Inciter les joueurs à vouloir gagner parce qu'ils vont voir le flag en mangeant les nourritures.

; Optimisations possibles au besoin
; - Réutiliser esp et ebp (vm_x, vm_y)
; - J'ai accès à r14, etc?

org 0x7c00
bits 16

jmp start

direction db 5
last_scancode db 1
food_x db 10
food_y db 10
vm_x db 0 ; Used as temp params for video mem read and write
vm_y db 0

; TODO: Si besoin d'être plus dur, faire qu'une partie de cette table est écrite dynamiquement en utilisant les bytes qu'il me reste pour rouler plus de code. Demanderait alors que les gens comprennent statiquement ce qu'il se passe ou qu'ils le regardent dans gdb
; CSGAMES{SNAKESUCCESSSSS}
flag_indices db 0x7e, 0xae, 0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf2, 0xb6, 0x51, 0x8f, 0xf4, 0x29, 0xe4, 0x51, 0xfe, 0xf1, 0xf1, 0xe4, 0x51, 0x51, 0x51, 0x51, 0x51, 0x72

is_started equ 0x0510
cursor_y equ 0x0511
cursor_x equ 0x0512 
video_mem equ 0xB800
screen_width equ 80
screen_height equ 24
screen_width_height equ 1920

start:
	xor ax, ax
	mov [is_started], ax
	mov si, ax ; si will hold the food_count
	mov ax, 12
	mov [cursor_y], ax
	mov ax, 40
	mov [cursor_x], ax
	mov ax, 5
	mov [direction], ax
	mov ax, video_mem
	mov es, ax
	sti
	call clear_screen
	call next_food

main:
	hlt
	call move
	call read_input

; delay
    mov bx, [0x046C]; get current tick
.wait:
    mov ax, [0x046C]
    sub ax, bx
    cmp ax, 0   ; default: 18 for ~1 second
    jb .wait
	jmp main

game_over:
	mov si, message_game_over
	mov di, 1988 ; This is the exact value we expect
.print_loop:
	mov ah, 0x04
	mov al, byte [si]
	or al, al
	jz halt
	mov [es:di], ax
	inc si
	add di, 2
	jmp .print_loop

halt:
	mov ah, 0 ; Blocking read
	int 16h
	jmp start

read_input:
	mov al, byte [is_started]
	cmp al, 0
	je .blocking_read
	mov ah, 1 ; Non-blocking read
	int 16h
	jz .no_key
.blocking_read:
	mov byte [is_started], ah
	mov ah, 0 ; Blocking read
	int 16h
	cmp ah, byte [last_scancode]
	je .no_key
	mov [last_scancode], ah
	mov bl, 1
	cmp al, 'w'
	je .read_input_end
	mov bl, 4
	cmp al, 's'
	je .read_input_end
	mov bl, 2
	cmp al, 'a'
	je .read_input_end
	mov bl, 3
	cmp al, 'd'
	je .read_input_end
	ret
.read_input_end:
	mov cl, byte [direction]
	add cl, bl
	cmp cl, 5
	je .no_key
	mov byte [direction], bl
.no_key:
	ret

move:
	cmp byte [direction], 1
	je .move_up
	cmp byte [direction], 4
	je .move_down
	cmp byte [direction], 2
	je .move_left
	; Possible optimization: Relative jump
	; jmp .move_right + [direction]*4
.move_right:
	inc byte [cursor_x]
	jmp .move_check_bounds
.move_left:
	dec byte [cursor_x]
	jmp .move_check_bounds
.move_down:
	inc byte [cursor_y]
	jmp .move_check_bounds
.move_up:
	dec byte [cursor_y]
.move_check_bounds:
	mov ax, [cursor_x]
	mov [vm_x], ax
	mov ax, [cursor_y]
	mov [vm_y], ax
	xor cx, cx
	call rw_video_mem
	cmp cx, 0x0720
	je .move_write_screen
.move_not_space:
	cmp ch, 0x5F
	jne .move_dead
	; jmp .move_check_food
.move_write_screen:
	mov cx, 0x0a40
	call rw_video_mem
.move_check_food:
	mov al, [food_x]
	cmp byte [cursor_x], al
	jne .move_end
	mov al, [food_y]
	cmp byte [cursor_y], al
	jne .move_end
	call next_food
.move_end:
	ret
.move_dead:
	call game_over

; Leave here to enhance the confusion
dummy_var_1 db 'K'

next_food:
	mov ax, [0x046C] ; Take randomness from system ticks
	mov bx, screen_width
	xor dx, dx
	div bx
	mov [food_x], dl
	mov [vm_x], dl
	
	mov ax, [0x046C] ; Take randomness from system ticks
	mov bx, screen_height
	xor dx, dx
	div bx
	mov [food_y], dl
	mov [vm_y], dl

	xor cx, cx
	call rw_video_mem
	cmp cx, 0x0720
	jne next_food

	; Increment food count
	inc si
	mov cx, si
	
	cmp si, 1
	jbe .normal_food
	cmp si, 26
	jae .normal_food
.flag_food:
	; TODO: see if i can use a register here
	push si ; push si because it's used for food_count
	mov si, flag_indices
	mov ch, 0
	add si, cx
	mov cl, byte [si]
	mov si, 0x7d00
	add si, cx
	mov cl, byte [si]
	mov ch, 0x5F
	pop si
	jmp .print_food
.normal_food:
	mov cx, 0x5F20
.print_food:
	mov al, [food_y]
	mov byte [vm_y], al
	mov al, [food_x]
	mov byte [vm_x], al
	call rw_video_mem
	ret

; Leave here to enhance the confusion
dummy_var_2 db 'N'

; Takes vm_y and vm_x and moves index to di
get_index:
	xor ax, ax
	mov al, byte [vm_y]
	mov bl, screen_width
	mul bl
	mov bl, [vm_x]
	xor bh, bh
	add ax, bx
	shl ax, 1
	mov di, ax
	ret

; Expects cx to hold the value to be written
rw_video_mem:
	call get_index
	cmp cx, 0
	jz .read
.write:
	mov [es:di], cx
	ret
.read:
	mov cx, [es:di]
	ret

; Leave here to enhance the confusion
dummy_var_3 db '{'

clear_screen:
	xor di, di
	mov cx, screen_width_height
.clear_loop:
	xor dx, dx
	mov ax, di
	shr ax, 1
	mov bx, screen_width
	; mov bx, screen_height ; Interesting result
	div bx
	cmp dx, 0
	je .wall
	cmp dx, screen_width-1
	je .wall
	cmp ax, 0
	je .wall
	cmp ax, screen_height-1
	je .wall
	; TODO: Add other conditions to make impossible (walls)
.empty:
	mov byte [es:di+1], 0x07
	jmp .next
.wall:
	mov byte [es:di+1], 0x77
.next:
	mov byte [es:di], ' '
	add di, 2
	loop .clear_loop
	ret

; Do not use because it completely disaligns the values so it changes the offsets for the flag...
; The only thing I can do to debug the flag is to increase the delay to make the game easier
; DEBUG ONLY
; debug_print_flag:
; 	mov si, flag_indices
; 	mov di, 1988 ; This is the exact value we expect
; .debug_print_loop:
; 	mov ch, 0
; 	mov cl, byte [si]
; 	or cl, cl
; 	jz halt
; 	mov bp, 0x7d00
; 	add bp, cx
; 	mov cl, byte [bp]
; 	mov ch, 0x5F
; 	mov [es:di], cx
; 	inc si
; 	add di, 2
; 	jmp .debug_print_loop


message_game_over db "CSGAME OVER!", 0

times 510-($-$$) db 0
dw 0xAA55

