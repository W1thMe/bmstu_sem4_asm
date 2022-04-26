#include <iostream>
#include <string>

using namespace std;
#define SIZE 15

extern "C" void my_memmove(char* buf, const char* src, int len);

int my_strlen(const char* str);

int main()
{
    char src[SIZE] = "Hello, World!";
    char buf[SIZE], buf2[SIZE], buf3[SIZE];

    std::cout << "String: " << src << std::endl;
    std::cout << "(1) my_strlen = " << my_strlen(src) << std::endl;
    std::cout << "(1) strlen    = " << strlen(src) << std::endl;
    std::cout << std::endl;

    std::cout << "Empty String: " << "" << std::endl;
    std::cout << "(2) my_strlen = " << my_strlen("") << std::endl;
    std::cout << "(2) strlen    = " << strlen("") << std::endl;
    std::cout << std::endl;

    std::cout << "String: " << "a" << std::endl;
    std::cout << "(3) my_strlen = " << my_strlen("a") << std::endl;
    std::cout << "(3) strlen    = " << strlen("a") << std::endl;
    std::cout << std::endl;



    std::cout << "---- my_memmove tests ----: " << std::endl;
    std::cout << std::endl;

    std::cout << "String: " << "Hello, World!" << std::endl;
    std::cout << "Len = " << 14 << std::endl;
    my_memmove(buf, src, 14);
    std::cout << "(1) my_memmove = " << buf << std::endl;
    memmove(buf, src, 14);
    std::cout << "(1) memmove    = " << buf << std::endl;
    std::cout << std::endl;
    
    std::cout << "Len = " << 10 << std::endl;
    my_memmove(buf2, src, 10);
    std::cout << "(2) my_memmove = " << buf2 << std::endl;
    memmove(buf2, src, 10);
    std::cout << "(2) memmove    = " << buf2 << std::endl;
    std::cout << std::endl;

    std::cout << "Len = " << 18 << std::endl;
    my_memmove(buf3, src, 18);
    std::cout << "(3) my_memmove = " << buf3 << std::endl;
    memmove(buf3, src, 18);
    std::cout << "(3) memmove    = " << buf3 << std::endl;
    std::cout << std::endl;

    std::cout << "pointers intersected" << std::endl;
    std::cout << "SRC == DST" << std::endl;
    my_memmove(src, src, 14);
    std::cout << "(5) my_memmove = " << src << std::endl;
    memmove(src, src, 14);
    std::cout << "(5) memmove    = " << src << std::endl;
    std::cout << std::endl;

    std::cout << "SRC < DST \n Len = 10" << std::endl;

    char src1[SIZE] = "Hello, World!";
    char src2[SIZE] = "Hello, World!";
    my_memmove(src1, src1 + 5, 10);
    std::cout << "(6) my_memmove = " << src1 << std::endl;
    memmove(src2, src2 + 5, 10);
    std::cout << "(6) memmove    = " << src2 << std::endl;
    std::cout << std::endl;

    std::cout << "SRC > DST (SRC - DST < Len)\nLen = 7" << std::endl;

    char src3[SIZE] = "Hello, World!";
    char src4[SIZE] = "Hello, World!";
    my_memmove(src3 +  2, src3, 7);
    std::cout << "(7) my_memmove = " << src3 << std::endl;
    memmove(src4 + 2, src4, 7);
    std::cout << "(7) memmove    = " << src4 << std::endl;
    std::cout << std::endl;


    std::cout << "SRC > DST (SRC - DST >= Len)\nLen = 7" << std::endl;

    char src5[SIZE] = "Hello, World!";
    char src6[SIZE] = "Hello, World!";
    my_memmove(src5 + 7, src5, 7);
    std::cout << "(8) my_memmove = " << src5 << std::endl;
    memmove(src6 + 7, src6, 7);
    std::cout << "(8) memmove    = " << src6 << std::endl;
    std::cout << std::endl;

    return 0;
}

int my_strlen(const char* src)
{
    int len = 0;

    __asm
    {
        mov ecx, -1
        mov esi, src    // Адрес начала строки
        mov edi, src

        xor eax, eax    // Пока 0
        cld             // Сброс флага DF, чтобы адрес автоматически увеличивался

        repne scasb      // SCASB сравнивает регистр AL с байтом в ячейке памяти по адресу ES:EDI
                         // Сканирование строки байтов, пока не встретится 0, DI увеличиватся автоматически

        sub edi, esi
        dec edi
        mov len, edi
    }

    return len;
}
