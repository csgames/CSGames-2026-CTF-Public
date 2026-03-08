#include <stdio.h>

// The vuln: one entry is missing, so we can try to write it while overwriting the flag, which
// does not overwrite the flag name

// The library is only allowed to lend 5 books at a time, minus the forbidden books.
// #define HEAP_SIZE 0x80
#define HEAP_SIZE 0x100
#define N_BOOKS 10

// Size is 0x10
struct Book {
    char borrowed; // 0 -> not borrowed, 1 -> borrowed, 2 -> forbidden
    char id;
    char *title;
};

char heap[HEAP_SIZE];
int chunk_size = sizeof(struct Book);
int heap_cursor = 0;
const char *book_names[N_BOOKS] = {
    "CSGAMES{PLACEHOLDER_CSFLAG}",
    "1984",
    "To Kill a Mockingbird",
    "The Great Gatsby",
    "Moby Dick",
    "War and Peace",
    "The Odyssey",
    "Crime and Punishment",
    "The Catcher in the Rye"
};

void* _malloc() {
    char *ptr = NULL;
    int counter = 0;
    do {
        if (heap_cursor + chunk_size > HEAP_SIZE) {
            heap_cursor -= HEAP_SIZE;
        }
        ptr = &heap[heap_cursor];
        heap_cursor += chunk_size;
        counter += 1;
        if (counter > HEAP_SIZE / 0x10) {
            ptr = NULL;
            break;
        }
    } while (ptr[0] == 1);
    return ptr;
}

void _free(char *ptr) {
    // Book is unborrowed
    ptr[0] = 0;
}

struct Book * get_book_in_heap(char book_number) {
    for (int i = 0; i < HEAP_SIZE; i += chunk_size) {
        struct Book *book = (struct Book*)&heap[i];
        if (book->id == book_number && book->borrowed == 1) {
            return book;
        }
    }
    return NULL;
}

void print_options() {
    printf("\nPlease select an option:\n");
    printf("1. List available books\n");
    printf("2. List borrowed books\n");
    printf("3. Borrow a book\n");
    printf("4. Return a book\n");
    printf("5. Exit\n");
}

char read_input() {
    printf(" > ");
    char buffer[10];
    fgets(buffer, sizeof(buffer), stdin);
    char option = buffer[0] - '0';
    return option;
}

char book_is_forbidden(int book_number) {
    for (int i = 0; i < HEAP_SIZE; i += chunk_size) {
        struct Book *book = (struct Book*)&heap[i];
        if (book->id == book_number && book->borrowed == 2) {
            return 1;
        }
    }
    return 0;
}

char borrow_limit_reached() {
    for (int i = 0; i < HEAP_SIZE; i += chunk_size) {
        struct Book *book = (struct Book*)&heap[i];
        if (book->borrowed == 0) {
            return 0;
        }
    }
    return 1;
}

void list_books() {
    printf("\nAvailable books:\n");
    int i = 0;
    while (1) {
        if (book_names[i] != NULL) {
            if (book_is_forbidden(i)) {
                printf("%d. **FORBIDDEN**\n", i);
            }
            else {
                printf("%d. %s\n", i, book_names[i]);
            }
        }
        else {
            return;
        }
        i++;
    }
}

void print_borrowed_books() {
    int n_books_borrowed = 0;
    printf("\n");
    for (int i = 0; i < HEAP_SIZE; i += chunk_size) {
        struct Book *book = (struct Book*)&heap[i];
        if (book->borrowed == 1 && book->title != NULL) {
            printf("%s\n", book->title);
            n_books_borrowed++;
        }
    }
    if (n_books_borrowed == 0) {
        printf("No books borrowed yet.\n");
    }
}

void borrow_book() {
    if (borrow_limit_reached()) {
        printf("You have reached the borrow limit. Please return a book before borrowing another one.\n");
        return;
    }

    printf("\nEnter the number of the book you want to borrow: ");
    char buffer[10];
    fgets(buffer, sizeof(buffer), stdin);
    char book_number = buffer[0] - '0';

    if (get_book_in_heap(book_number) != NULL) {
        printf("The book is already borrowed.\n");
        return;
    }
    else if (book_is_forbidden(book_number)) {
        printf("The book is forbidden and cannot be borrowed.\n");
        return;
    }

    struct Book *ptr = _malloc();
    ptr->borrowed = 1;
    if (book_number < 0 || book_number > N_BOOKS-1) {
        printf("This book can't be borrowed.\n");
        ptr->borrowed = 0;
        return;
    }
    ptr->id = book_number;
    
    if (book_names[book_number] == NULL) {
        printf("This book can't be borrowed.\n");
        ptr->id = -1;
        return;
    }
    ptr->title = (char *) book_names[book_number];
    printf("You have borrowed book number %d.\n", book_number);
}

void return_book() {
    printf("\nEnter the number of the book you are returning: ");
    char buffer[10];
    fgets(buffer, sizeof(buffer), stdin);
    char book_number = buffer[0] - '0';
    struct Book *book = get_book_in_heap(book_number);
    if (book == NULL) {
        printf("The book is not borrowed.\n");
        return;
    }
    else {
        if (book->borrowed == 2) {
            printf("You cannot return this book.\n");
            return;
        }
        _free((char *) book);
        printf("You have returned book number %d.\n", book_number);
        return;
    }
}

void blacklist_forbidden_books() {
    struct Book *ptr = _malloc();
    // Forbidden
    ptr->borrowed = 2;
    ptr->id = 0;
    ptr->title = (char *) book_names[0]; // It is profoundly forbidden to borrow this book.
}

int main() {
    printf("");
    blacklist_forbidden_books();
    while (1) {
        print_options();
        switch (read_input()) {
            case 1:
                list_books();
                break;
            case 2: 
                print_borrowed_books();
                break;
            case 3: {
                borrow_book();
                break;
            }
            case 4: {
                return_book();
                break;
            }
            case 5:
                return 0;
            default:
                break;
        }
    }
}
