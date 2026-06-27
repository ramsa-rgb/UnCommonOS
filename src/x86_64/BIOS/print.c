void _start() {
    volatile unsigned int* FRAMEBUFFEROri = (volatile unsigned int*)0x4000;
    unsigned int FRAMEBUFFERADR = *FRAMEBUFFEROri;
    volatile unsigned short* PitchOri = (volatile unsigned short*)0x4004;
    unsigned short PitchAR = *FRAMEBUFFEROri;
    volatile unsigned char* ReqCharOri = (volatile unsigned char*)0x4008;
    unsigned int ReqCharAR = *ReqCharOri;
    volatile unsigned int* ReturnReqCharOri = (volatile unsigned int*)0x4010;
    unsigned int ReturnReqCharAR = *ReturnReqCharOri;
    volatile unsigned short* CHARSEGOri = (volatile unsigned short*)0x2000;
    unsigned int CHARSEGAR = *CHARSEGOri;
    volatile unsigned short* CHAROFFORI = (volatile unsigned short*)0x2004;
    unsigned int CHAROFFAR = *CHAROFFORI;
    volatile unsigned short* CHAROFFORI = (volatile unsigned short*)0x2004;
    unsigned int CHAROFFAR = *CHAROFFORI;
    volatile unsigned short* BYTESCHARORI = (volatile unsigned short*)0x2008;
    unsigned int BYTESCHARAR = *BYTESCHARORI;

    volatile unsigned int* FRAMEBUFFER = (volatile unsigned int*)FRAMEBUFFERADR;
    volatile unsigned short* Pitch = (volatile unsigned short*)PitchAR;
    volatile unsigned char* ReqChar = (volatile unsigned char*)ReqCharAR;
    volatile unsigned int* ReturnReqChar = (volatile unsigned int*)ReturnReqCharAR;
    volatile unsigned char* CHARSEG = (volatile unsigned char*)CHARSEGAR;
    volatile unsigned short* CHAROFF = (volatile unsigned short*)CHAROFFAR;
    volatile unsigned short* BYTESCHAR = (volatile unsigned short*)BYTESCHARAR;

    FRAMEBUFFER[0] = 0x00FFFFFF;
    FRAMEBUFFER[1] = 0x00FFFFFF;

    while (1) {
        
    }
}