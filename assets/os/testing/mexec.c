#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
    int euid = geteuid();
    char password[254] = "password";
    char arguments[300];
    memset(arguments, 0, sizeof(arguments));

    if (argv[1] != password) {
        printf("Error - invalid password.");
        exit(1);
    }

    for (int i = 2; i <= argc; i++) {
        if (argv[i] != NULL && argv[i] != "(null)") {
            strcat(arguments, argv[i]);
            strcat(arguments, " ");
        }
    }

    

    printf("EUID: %d\n\nArguments: %s", euid, arguments);
    return 0;
}