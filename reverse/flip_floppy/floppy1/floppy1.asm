; Évaluation perso: Easy

; bootloader.asm
org 0x7C00          ; BIOS loads the bootloader at this address

start:
    mov si, message

print_loop:
    lodsb
	xor al, 16h
    or al, al
    jz halt
    mov ah, 0x0E    ; BIOS teletype output
    int 0x10
    jmp print_loop

halt:
    cli
    hlt

; CSGAMES{N07_QU173_Z3LD4_189AC7F}
message db 55h, 45h, 51h, 57h, 5bh, 53h, 45h, 6dh, 58h, 26h, 21h, 49h, 47h, 43h, 27h, 21h, 25h, 49h, 4ch, 25h, 5ah, 52h, 22h, 49h, 27h, 2eh, 2fh, 57h, 55h, 21h, 50h, 6bh, 16h,        75h, 66h, 7ah, 64h, 64h, 7bh, 73h, 7bh, 65h, 75h, 75h, 70h, 73h, 65h, 64h, 71h, 7bh, 71h, 77h, 73h, 64h, 7bh, 77h, 7bh, 75h, 7bh, 71h, 65h, 64h, 70h, 66h, 73h, 66h, 73h, 77h, 66h, 70h, 73h, 64h, 66h, 64h, 70h, 77h, 77h, 66h, 73h, 77h, 7bh, 71h, 66h, 73h, 77h, 70h, 7ah, 71h, 65h, 64h, 73h, 70h, 3bh, 77h, 64h, 73h, 7bh, 7ah, 65h, 7bh, 71h, 77h, 65h, 66h, 73h, 65h, 64h, 3bh, 66h, 73h, 71h, 66h, 66h, 73h, 71h, 7bh, 7bh, 66h, 7bh, 73h, 73h, 7bh, 75h, 73h, 66h, 65h, 3bh, 66h, 7bh, 70h, 77h, 64h, 73h, 71h, 64h, 64h, 77h, 71h, 66h, 73h, 70h, 7ah, 77h, 64h, 66h, 70h, 66h, 73h, 7bh, 64h, 73h, 71h, 66h, 77h, 65h, 77h, 71h, 65h, 3bh, 71h, 64h, 64h, 75h, 3bh, 7bh, 77h, 3bh, 73h, 64h, 71h, 64h, 65h, 65h, 73h, 70h, 73h, 3bh, 3bh, 7bh, 66h, 64h, 66h, 71h, 64h, 73h, 7bh, 71h, 64h, 75h, 71h, 77h, 77h, 3bh, 73h, 73h, 70h, 70h, 77h, 64h, 73h, 66h, 65h, 66h, 73h, 3bh, 73h, 73h, 65h, 77h, 71h, 64h, 66h, 64h, 7ah, 64h, 75h, 7bh, 7bh, 66h, 65h, 66h, 75h, 7bh, 73h, 65h, 71h, 73h, 71h, 65h, 73h, 73h, 7ah, 65h, 75h, 71h, 65h, 64h, 3bh, 7ah, 71h, 3bh, 65h, 70h, 64h, 75h, 70h, 73h, 7bh, 71h, 73h, 64h, 73h, 66h, 64h, 3bh, 73h, 65h, 7bh, 75h, 71h, 71h, 7ah, 77h, 75h, 65h, 64h, 3bh, 71h, 73h, 7ah, 7bh, 73h, 77h, 70h, 77h, 75h, 64h, 3bh, 64h, 3bh, 71h, 75h, 64h, 73h, 75h, 71h, 77h, 66h, 73h, 75h, 73h, 73h, 7bh, 66h, 73h, 65h, 7bh, 64h, 64h, 73h, 65h, 73h, 70h, 64h, 75h, 7bh, 7ah, 66h, 71h, 77h, 7bh, 7bh, 65h, 75h, 65h, 64h, 65h, 65h, 3bh, 66h, 66h, 65h, 73h, 7bh, 7bh, 66h, 73h, 7ah, 66h, 7bh, 3bh, 65h, 66h, 70h, 75h, 77h, 73h, 65h, 75h, 71h, 64h, 73h, 65h, 66h, 77h, 7ah, 64h, 66h, 73h, 77h, 73h, 73h, 3bh, 65h, 71h, 71h, 64h, 7bh, 75h, 75h, 77h, 3bh, 73h, 71h, 7bh, 64h, 7bh, 71h, 7bh, 64h, 73h, 77h, 71h, 64h, 77h, 71h, 77h, 7bh, 7bh, 73h, 64h, 66h, 64h, 64h, 77h, 70h, 65h, 71h, 73h, 64h, 65h, 73h, 77h, 77h, 70h, 77h, 73h, 73h, 66h, 71h, 3bh, 3bh, 66h, 64h, 66h, 66h, 64h, 7ah, 64h, 66h, 7bh, 64h, 65h, 73h, 65h, 70h, 3bh, 73h, 64h, 66h, 71h, 73h, 66h, 65h, 71h, 66h, 73h, 73h, 7bh, 73h, 7bh, 70h, 65h, 77h, 71h, 64h, 73h, 7bh, 65h, 73h, 73h, 77h, 71h, 66h, 64h, 65h, 73h, 66h, 7ah, 77h, 71h, 65h, 3bh, 64h, 3bh, 70h, 70h, 77h, 71h, 65h, 70h, 3bh, 65h, 65h, 70h, 77h, 64h, 73h, 70h, 66h, 70h, 77h, 77h, 3bh, 3bh, 7bh, 7ah, 66h, 70h, 70h, 66h, 64h, 64h, 75h, 73h, 65h, 71h, 65h, 7bh, 7bh, 73h

times 510 - ($ - $$) db 0
dw 0xAA55           ; Boot signature

