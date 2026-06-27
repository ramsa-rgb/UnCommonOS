@echo off

set "UMASM=C:\Program Files\Microsoft Visual Studio\18\Community\VC\Tools\MSVC\14.50.35717\bin\Hostx64\x64\ml64.exe"
set "ULINK=C:\Program Files\Microsoft Visual Studio\18\Community\VC\Tools\MSVC\14.50.35717\bin\Hostx64\x64\link.exe"

echo x86_64 (BIOS / UEFI) 빌드 시작
echo -------------------------------------------

echo BIOS
nasm -f bin .\src\x86_64\BIOS\boot.asm -o .\x86_64-ISO\BOOT\BIOS\BOOT
i686-elf-gcc -c ./src/x86_64/BIOS/print.c -o ./obj/x86_64/BIOS/print.o
i686-elf-objcopy -O binary ./obj/x86_64/BIOS/print.o  .\x86_64-ISO\BOOT\BIOS\PRINT

echo UEFI

"%UMASM%" -h
"%ULINK%" -h

echo CD 만들기
xorriso -as mkisofs -no-emul-boot -boot-load-size 8 -boot-info-table -b BOOT/BIOS/BOOT -o bin/UNCOMMONOS.iso x86_64-ISO