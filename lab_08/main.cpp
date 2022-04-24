#pragma warning(disable : 4996)
#include <iostream>

using namespace std;
#define SIZE 256

extern "C" void my_memmove(char* buf, const char* str, int len);

int asm_insertion_len(const char* str);

int main(int argc, char** argv)
{
    char str[SIZE] = "Hello, World!";
    char buf[SIZE];

    int len = 0;

    len = asm_insertion_len(str);
    std::cout << "(1) len = " << len << std::endl;

    my_memmove(str+1, str, 10);
    std::cout << "(2) string = " << str << std::endl;

    return 0;
}

int asm_insertion_len(const char* str)
{
    int len = 0;

    __asm
    {
        mov ecx, -1
        mov esi, str    // Адрес начала строки
        mov edi, str

        xor eax, eax    // Пока 0
        cld             // Сброс флага DF, чтобы адрес автоматически увеличивался
 
        repne scasb     // Сканирование строки байтов, пока не встретится 0, т.к. DF = 0, автоматически увеличиватся DI

        sub edi, esi
        dec edi
        mov len, edi
    }

    return len;
}
//          ; repne - повторять операцию, пока флаг ZF показывает "не равно или не ноль".
//          ; Прекратить операцию при флаге ZF, указывающему на "равно или нуль" или при CX равном
