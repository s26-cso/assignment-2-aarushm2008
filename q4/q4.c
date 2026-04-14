#include <stdio.h>
#include <dlfcn.h>

int main() {
    char op[6];
    int num1, num2;
  

    while(scanf("%s %d %d", op, &num1, &num2)!=EOF){
        char libname[16];
        libname[0]='.';
        libname[1]='/';
        libname[2]='l';
        libname[3]='i';
        libname[4]= 'b';
        
        int i=0;

        while (op[i]!='\0'){
            libname[5 + i]=op[i];
            i++;
        }

        libname[5+i]='.';
        libname[5+i+1]='s';
        libname[5+i+2]='o';
        libname[5+i+3]='\0';

        void *handle = dlopen(libname, RTLD_LAZY);
        int (*fn)(int, int) = dlsym(handle, op);
        printf("%d\n", fn(num1, num2));
        dlclose(handle);
    }

    return 0;
}