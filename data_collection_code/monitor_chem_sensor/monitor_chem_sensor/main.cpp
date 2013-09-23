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

unsigned char read_status()
{
	unsigned char errMsg;
	unsigned char address;
	short int nBytes;
	unsigned char ReadData[4];
	short int SendStop;

	address = 0xA4; // 52*2 = A4
	nBytes = 4;
	SendStop = 1;
	errMsg = I2C_Read( address, nBytes, ReadData, SendStop );
	cout<<"Read status exited with error message: "<<(int)errMsg <<"\n";
	cout<<"Status: "<<(int)ReadData[0]<<"\n";
	cout<<"Temperature: "<<((int)ReadData[1])/2.0<<"C (nominal: 40 C)\n";
	cout<<"Pump Voltage: "<<((int)ReadData[2])/20.0<<"V (nominal: 5 V)\n";
	cout<<"Hydrometry: "<<((int)ReadData[3])/2.0<<"%\n";
	return errMsg;
}

unsigned char read_sensor_resistance()
{
	unsigned char errMsg;
	unsigned char address;
	short int nBytes;
	unsigned char WriteData[1];
	unsigned char ReadData[6];
	short int SendStop;
	int SensorReadings[3];

	address = 0xAE; // 57*2 = AE
	nBytes = 1;
	WriteData[0] = 0x00;
	SendStop = 1;
	errMsg = I2C_Write( address, nBytes, WriteData, SendStop );
	if ( (int)errMsg != 0 ) {
		cout<<"Read sensor resistance (write) exited with error message: "<<(int)errMsg<<"\n";
	}
	nBytes = 6;
	errMsg = I2C_Read( address, nBytes, ReadData, SendStop );
	if ( (int)errMsg != 0 ) {
		cout<<"Read sensor resistance (read) exited with error message: "<<(int)errMsg<<"\n";
	}
	SensorReadings[0] = (ReadData[0] << 8) | ReadData[1];
	SensorReadings[1] = (ReadData[2] << 8) | ReadData[3];
	SensorReadings[2] = (ReadData[4] << 8) | ReadData[5];
	cout<<"Sensor 1 resistance: "<<(SensorReadings[0])<<" Ohms\n";
	cout<<"Sensor 2 resistance: "<<(SensorReadings[1])<<" Ohms\n";
	cout<<"Sensor 3 resistance: "<<(SensorReadings[2])<<" Ohms\n";


	return errMsg;
}

int main()
{
	unsigned char errMsg;
	short int enable5V;
	int frequency;

	Get_DLL_Version(); //a call simply to load the DLL
	wait ( 1 ); //gives the DLL time to find the hardware
	
	while ( true ) {
		read_status();
		read_sensor_resistance();
		wait ( 1 );
	}
}