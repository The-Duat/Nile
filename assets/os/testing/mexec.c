#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>


int checkpass(char *givenpass)
{
    char truepass[254];
    FILE *passfile;
    passfile = fopen("/var/mizOS/security/password");
    for (int i = 0; (c = fgetc(passfile)) != EOF; i++) {
        truepass[i] = c;
    }
    
    if (truepass == givenpass) {
        return 1;
    } else {
        return 0;
    }
}


int main(int argc, char *argv[]) {
    int euid = geteuid();
    char arguments[300];
    memset(arguments, 0, sizeof(arguments));

    int argstart = 2;

    if (argv[1] == "exec") {
        for (int i = 3; i <= argc; i++) {
            if (argv[i] != NULL && argv[i] != "(null)") {
                strcat(arguments, argv[i]);
                strcat(arguments, " ");
            }
        }
    }

    printf("EUID: %d\n\nArguments: %s", euid, arguments);
    return 0;
}