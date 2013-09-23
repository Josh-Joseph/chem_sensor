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

unsigned char stop_furnace_and_pump()
{
	unsigned char errMsg;
	unsigned char address;
	short int nBytes;
	unsigned char WriteData[2];
	short int SendStop;

	address = 0xA4; // 52*2 = A4
	nBytes = 2;
	WriteData[0] = 00;
	cout<<"Setting furance temperature setpoint to 0 (0 C)...\n";
	WriteData[1] = 0;
	cout<<"Setting pump voltage to 0 (0 V)...\n";
	SendStop = 1;
	errMsg = I2C_Write( address, nBytes, WriteData, SendStop );
	cout<<"...exited with error message: "<<(int)errMsg <<"\n";
	return errMsg;
}

int main()
{
	unsigned char errMsg;
	short int enable5V;
	int frequency;

	Get_DLL_Version(); //a call simply to load the DLL
	wait ( 1 ); //gives the DLL time to find the hardware

	enable5V = 0;
	Enable5VOutputPower( enable5V );
	
	stop_furnace_and_pump();
}