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

unsigned char start_furnace_and_pump()
{
	unsigned char errMsg;
	unsigned char address;
	short int nBytes;
	unsigned char WriteData[2];
	short int SendStop;

	address = 0xA4; // 52*2 = A4
	nBytes = 2;
	WriteData[0] = 80;
	cout<<"Setting furance temperature setpoint to 80 (40 C)...\n";
	WriteData[1] = 100;
	cout<<"Setting pump voltage to 100 (5 V)...\n";
	SendStop = 1;
	errMsg = I2C_Write( address, nBytes, WriteData, SendStop );
	cout<<"...exited with error message: "<<(int)errMsg <<"\n";
	return errMsg;
}

unsigned char set_sensor_tension()
{
	unsigned char errMsg;
	unsigned char address;
	short int nBytes;
	unsigned char WriteData[4];
	short int SendStop;

	address = 0xAE; // 57*2 = AE
	nBytes = 4;
	WriteData[0] = 0x06;
	WriteData[1] = 86;
	cout<<"Setting sensor 1 tension to 86 (2.39 V)...\n";
	WriteData[2] = 244;
	cout<<"Setting sensor 2 tension to 244 (5.1 V)...\n";
	WriteData[3] = 244;
	cout<<"Setting sensor 3 tension to 244 (5.1 V)...\n";
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

	enable5V = 1;
	Enable5VOutputPower( enable5V );
	frequency = 40000;
	I2C_SetFrequency( frequency );
	
	start_furnace_and_pump();
	set_sensor_tension();
}