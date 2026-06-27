[ORG 0x7c00]
[BITS 16]

section .text

boot:
    jmp 0x0000:_start
    times 8-($-$$) db 0
    RES resd 44

_start:
    push dx

    ; 세그먼트 정리
    mov ax, 0
    mov ds, ax
    mov es, ax
    mov fs, ax
    
    ; 인터럽트 활성화
    sti

    ; A20 Line 키기
    in al, 0x92
    or al, 2
    out 0x92, al

    pop dx ; 디스크 ID

    mov ax, 40 ; lba
    mov bx, 0x0 ; offset
    mov cx, 0x2000 ; segment
    call READCDROM

    ; 메모리맵 구하기
    call GETMEMMAP

    mov ax, 1130h
    mov bh, 06h
    int 10h

    mov [GRAPCHARBYTES], cx

    mov [CHARSEG], es
    mov [CHAROFF], bp

    ; VBE로 해상도 설정
    mov ax, 0x4f02
    mov bx, 0x0112
    int 10h

    ; VBE로 비디오 정보 얻기
    mov ax, 0
    mov es, ax
    mov di, VideoModeInfo

    mov ax, 0x4f01
    mov cx, 0x0112

    int 10h

    ; 32bit 진입
    cli
    lgdt [GDTR32]

    mov eax, cr0
    mov eax, 1
    mov cr0, eax

    jmp 08h:_32start

NO_PROTECTEDVBE:
    mov ah, 0Eh
    mov al, 'N'
    mov bh, 0

    int 10h
    
    mov ah, 0Eh
    mov al, 'O'
    mov bh, 0

    int 10h

    mov ah, 0Eh
    mov al, ' '
    mov bh, 0

    int 10h

    mov ah, 0Eh
    mov al, 'P'
    mov bh, 0

    int 10h

    mov ah, 0Eh
    mov al, 'r'
    mov bh, 0

    int 10h
    
    mov ah, 0Eh
    mov al, 'o'
    mov bh, 0

    int 10h

    mov ah, 0Eh
    mov al, 't'
    mov bh, 0

    int 10h

    mov ah, 0Eh
    mov al, 'e'
    mov bh, 0

    int 10h

    mov ah, 0Eh
    mov al, 'c'
    mov bh, 0

    int 10h

    mov ah, 0Eh
    mov al, 't'
    mov bh, 0

    int 10h

    mov ah, 0Eh
    mov al, 'e'
    mov bh, 0

    int 10h

    mov ah, 0Eh
    mov al, 'd'
    mov bh, 0

    int 10h

    mov ah, 0Eh
    mov al, ' '
    mov bh, 0

    int 10h

    mov ah, 0Eh
    mov al, 'V'
    mov bh, 0

    int 10h

    mov ah, 0Eh
    mov al, 'B'
    mov bh, 0

    int 10h

    mov ah, 0Eh
    mov al, 'E'
    mov bh, 0

    int 10h

    mov ah, 0Eh
    mov al, '2'
    mov bh, 0

    int 10h

    mov ah, 0Eh
    mov al, '!'
    mov bh, 0

    int 10h

    cli
    hlt
READCDROM:
    push ax
    push cx
    push bx

    mov ax, 0
    mov ds, ax
    mov ax, 0x1000
    mov si, ax 

    mov al, 10h
    mov [0x1000], al

    mov al, 0
    mov [0x1001], al

    mov al, 1
    mov [0x1002], al

    pop bx
    mov [0x1004], bx
    
    pop cx
    mov [0x1006], cx

    pop ax
    mov [0x1008], ax

    mov ah, 42h
    int 13h

    ret

GETMEMMAP:
    mov ax, 0x1000
    mov es, ax
    mov ax, 0x0
    mov di, ax


    xor ebx, ebx
    mov edx, 0x534d4150

    E820:
        mov eax, 0xe820
        mov ecx, 24

        int 15h

        add di, 24

        cmp ebx, 0
        jz END
        jnz E820
    END:

    ret


section .data
    CHARSEG equ 0x2000
    CHAROFF equ 0x2004
    GRAPCHARBYTES equ 0x2008

    GDT32:
        GDT32.NULL:
            GDT32.NULL.LIMITL dw 0
            GDT32.NULL.BASEL dw 0
            GDT32.NULL.BASEM db 0
            GDT32.NULL.ACCESS db 0b00000000
            GDT32.NULL.FLAGSLIMITH db 0b00000000
            GDT32.NULL.BASEH db 0
        GDT32.KRNLCODE:
            GDT32.KRNLCODE.LIMITL dw 0xFFFF
            GDT32.KRNLCODE.BASEL dw 0
            GDT32.KRNLCODE.BASEM db 0
            GDT32.KRNLCODE.ACCESS db 0b10011010
            GDT32.KRNLCODE.FLAGSLIMITH db 0b11001111
            GDT32.KRNLCODE.BASEH db 0
        GDT32.KRNLDATA:
            GDT32.KRNLDATA.LIMITL dw 0xFFFF
            GDT32.KRNLDATA.BASEL dw 0
            GDT32.KRNLDATA.BASEM db 0
            GDT32.KRNLDATA.ACCESS db 0b10010010
            GDT32.KRNLDATA.FLAGSLIMITH db 0b11001111
            GDT32.KRNLDATA.BASEH db 0
        GDT32.USERCODE:
            GDT32.USERCODE.LIMITL dw 0xFFFF
            GDT32.USERCODE.BASEL dw 0
            GDT32.USERCODE.BASEM db 0
            GDT32.USERCODE.ACCESS db 0b10111010
            GDT32.USERCODE.FLAGSLIMITH db 0b11001111
            GDT32.USERCODE.BASEH db 0
        GDT32.USERDATA:
            GDT32.USERDATA.LIMITL dw 0xFFFF
            GDT32.USERDATA.BASEL dw 0
            GDT32.USERDATA.BASEM db 0
            GDT32.USERDATA.ACCESS db 0b10110010
            GDT32.USERDATA.FLAGSLIMITH db 0b11001111
            GDT32.USERDATA.BASEH db 0

    GDTR32:
        GDTR32.SIZE dw (GDTR32 - GDT32) - 1
        GDTR32.OFFSET dd GDT32

    VideoModeInfo equ 0x3000
    FrameBuffer equ 0x4000
    Pitch equ 0x4004

    ReqChar equ 0x4008
    ReturnReqChar equ 0x4010

section .text

[BITS 32]
_32start:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x9fc00

    mov eax, [VideoModeInfo + 0x28]
    mov [FrameBuffer], eax

    mov eax, [VideoModeInfo + 0x10]
    mov [Pitch], eax

    call scan_cpu_ext

    mov byte [ReqChar], 'A'
    mov dword [ReturnReqChar], retaddress
    jmp 08h:0x20000
    
    retaddress:
    
    hlt

no_sse3:
    int 0x7 ; 고의적으로 cpu 충돌

scan_cpu_ext:
    mov eax, 1
    mov ebx, 0
    mov ecx, 0
    mov edx, 0
    cpuid ; CPU 기능 보기

    bt ecx, 0
    jnc no_sse3

    ret

section .data

times 8192-($-$$) db 0