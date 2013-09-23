#include <iostream>
#include <time.h>
#include "USBtoI2C32.h"

using namespace std;

void wait ( int seconds )
{
  clock_t endwait;
  endwait = clock () + seconds * CLOCKS_PER_SEC ;
  while (clock() < endwait) {}
}

unsigned char write()
{
	unsigned char errMsg;
	unsigned char address;
	short int nBytes;
	unsigned char WriteData[2];
	short int SendStop;

	address = 0xA4; // 52*2 = A4
	nBytes = 2;
	WriteData[0] = 0;
	WriteData[1] = 0;
	SendStop = 1;
	cout<<"Writing to the chemical sensor...\n";
	errMsg = I2C_Write( address, nBytes, WriteData, SendStop );
	return errMsg;
}

unsigned char read()
{
	unsigned char errMsg;
	unsigned char address;
	short int nBytes;
	unsigned char ReadData[4];
	short int SendStop;

	address = 0xA4; // 52*2 = A4
	nBytes = 4;
	SendStop = 1;
	cout<<"Reading from the chemical sensor...\n";
	errMsg = I2C_Read( address, nBytes, ReadData, SendStop );
	cout<<"Read values:\n";
	for ( int i = 0; i < nBytes; i++ ) {
		cout<<(int)ReadData[i]<<"\n";
	}
	return errMsg;
}

int main()
{
	unsigned char errMsg;
	short int enable5V;
	int frequency;

	Get_DLL_Version(); // a call so the DLL gets loaded
	wait ( 1 ); // gives the DLL time to find the hardware

	enable5V = 1;
	Enable5VOutputPower( enable5V );
	frequency = 40000;
	I2C_SetFrequency( frequency );

	errMsg = write();
	for ( int i=0; i<=20; i++ ) {
		wait( 2 );
		errMsg = read();
	}
	cout<<"...exited with error message: "<<static_cast<int> ( errMsg ) <<"\n";
	cin.get();
}