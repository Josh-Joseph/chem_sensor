//   ========================================================================
//   =================  USB-to-I2C Elite  DLL interface  ====================
//   =================          www.i2ctools.com      =======================
//   ===========    Copyright (c) 2004-2008 SB Solutions          ===========
//   ========================================================================
//   ===========                                                  ===========
//   ===========            http://www.i2ctools.com               ===========
//   ========================================================================

extern "C" short int     __stdcall Enable3VOutputPower(short int);
extern "C" short int     __stdcall Enable5VOutputPower(short int);
extern "C" unsigned char __stdcall GetFirmwareRevision(void);
extern "C" unsigned char __stdcall GetHardwareInfo(unsigned char *HardwareData);
extern "C" int           __stdcall GetNumberOfDevices(void);
extern "C" int           __stdcall GetSerialNumbers(int *SerialNumbers);
extern "C" int           __stdcall SelectBySerialNumber(int dwSerialNumber);
extern "C" void          __stdcall ShutdownProcedure(void);
extern "C" int           __stdcall Get_DLL_Version(void);

// IO Functions
extern "C" int           __stdcall GPIO_Configure(unsigned char PortConfiguation);
extern "C" int           __stdcall GPIO_IN(void);
extern "C" int           __stdcall GPIO_OUT(unsigned char GPIOData);

// I2C Master Functions
extern "C" int           __stdcall I2C_BusRecovery(void); 
extern "C" int           __stdcall I2C_GetFrequency(void);
extern "C" unsigned char __stdcall I2C_Read(unsigned char address, short int nBytes, unsigned char *ReadData, short int SendStop);
extern "C" unsigned char __stdcall I2C_10ReadArray(short int address, unsigned char subaddress, short int nBytes, unsigned char *ReadData);
extern "C" unsigned char __stdcall I2C_10WriteArray(short int address, unsigned char subaddress, short int nBytes, unsigned char *ReadData);
extern "C" unsigned char __stdcall I2C_ReadArray(unsigned char address, unsigned char subaddress, short int nBytes, unsigned char *ReadData);
extern "C" unsigned char __stdcall I2C_ReadByte(unsigned char address, unsigned char subaddress, unsigned char *ReadData);
extern "C" unsigned char __stdcall I2C_ReceiveByte(unsigned char address, unsigned char *ReadData);
extern "C" unsigned char __stdcall I2C_SendByte(unsigned char address, unsigned char SendData);
extern "C" unsigned char __stdcall I2C_Write(unsigned char address, short int nBytes, unsigned char *WriteData, short int SendStop);
extern "C" unsigned char __stdcall I2C_WriteArray(unsigned char address, unsigned char subaddress, short int nBytes, unsigned char *WriteData);
extern "C" unsigned char __stdcall I2C_WriteByte(unsigned char address,unsigned char subaddress,unsigned char dataByte);
extern "C" unsigned char __stdcall I2C_WriteRepWrite(unsigned char address0,short int nBytes0,unsigned char *WriteData0,unsigned char address1,short int nBytes1,unsigned char *WriteData1);
extern "C" int           __stdcall I2C_SetFrequency(int frequency);
extern "C" unsigned char __stdcall I2C_ReadArrayDB(unsigned char address, unsigned char saHigh, unsigned char saLow, short int nBytes, unsigned char *ReadData);
extern "C" unsigned char __stdcall I2C_WriteArrayDB(unsigned char address, unsigned char saHigh, unsigned char saLow, short int nBytes, unsigned char *WriteData);


// I2C Slave Functions
extern "C" unsigned char __stdcall I2C_SetToSlaveMode(unsigned char SlaveAddress);
extern "C" unsigned char __stdcall I2C_SetToMasterMode(void);
extern "C" unsigned char __stdcall I2C_SlaveIdle(void);
extern "C" unsigned char __stdcall I2C_SlaveResume(void);
extern "C" unsigned char __stdcall I2C_SlaveReadBuffer(short int nBytes, unsigned char *ReadPointer);
extern "C" unsigned char __stdcall I2C_SlaveSetSize(short int SlaveSize);
extern "C" unsigned char __stdcall I2C_SlaveFillBuffer(unsigned char FillData);

// MSA Functions
extern "C" unsigned char __stdcall MSA_Write(unsigned char address, unsigned char *WriteData);
extern "C" unsigned char __stdcall MSA_Read(unsigned char address, unsigned char *ReadData);
extern "C" unsigned char __stdcall MSA_WriteRead(unsigned char address, unsigned char *WriteData, short int Delay, unsigned char *ReadData);


// SPI Funcitons
extern "C" unsigned char __stdcall SPI_Configure(unsigned char SPI_Mode);
extern "C" int           __stdcall SPI_GetConfiguration(unsigned char *SPI_Mode);
extern "C" int           __stdcall SPI_SetFrequency(int frequency);
extern "C" unsigned char __stdcall SPI_Generic(short int nBytes, int SS, unsigned char *WriteData, unsigned char *ReadData);
extern "C" unsigned char __stdcall SPI_Togglebyte (short int nBytes, int SS, unsigned char *WriteData, unsigned char *ReadData);
extern "C" unsigned char __stdcall SPI_Write(short int nBytes, int SS, unsigned char *SPI_Data);
extern "C" unsigned char __stdcall SPI_WriteRead(short int nBytesWrite, short int nBytesRead, int SS, unsigned char *WriteData,unsigned char *ReadData);
extern "C" unsigned char __stdcall SPI_WriteWithOC(short int nBytes, int SS, unsigned char *WriteData);

