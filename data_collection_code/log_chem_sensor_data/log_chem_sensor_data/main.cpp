#include <fstream>
#include <iostream>
#include <stdio.h>
#include <time.h>
#include "USBtoI2C32.h"

using namespace std;

void wait ( int seconds )
{
	clock_t endwait;
	endwait = clock () + seconds * CLOCKS_PER_SEC ;
	while (clock() < endwait) {}
}

void read_sensor_resistance( int *SensorReadings )
{
	unsigned char errMsg;
	unsigned char address;
	short int nBytes;
	unsigned char WriteData[1];
	unsigned char ReadData[6];
	short int SendStop;

	address = 0xAE; // 57*2 = AE
	nBytes = 1;
	WriteData[0] = 0x00;
	SendStop = 1;
	errMsg = I2C_Write( address, nBytes, WriteData, SendStop );
	nBytes = 6;
	errMsg = I2C_Read( address, nBytes, ReadData, SendStop );
	SensorReadings[0] = (ReadData[0] << 8) | ReadData[1];
	SensorReadings[1] = (ReadData[2] << 8) | ReadData[3];
	SensorReadings[2] = (ReadData[4] << 8) | ReadData[5];
}

int main()
{
	clock_t start_clock;
	time_t rawtime;
	struct tm * timeinfo;
	char str [5], log_file_name [13], timestamp [9];
	int n, VerticalDiff, HorizontalDiff, logTime; 
	int SensorReadings[3];

	Get_DLL_Version(); // a call so the DLL gets loaded
	wait ( 1 ); // gives the DLL time to find the hardware

	cout<<"Enter the length of time (seconds) to log data: ";
	cin>>logTime;
	cout<<"Enter the height the sensor is above the chemical: ";
	cin>>VerticalDiff;
	cin.ignore();
	cout<<"Enter the horizontal distance between the sensor and the chemical: ";
	cin>>HorizontalDiff;
	cin.ignore();

	//Name the file with the current date
	time ( &rawtime );
	timeinfo = localtime ( &rawtime );
	strftime ( log_file_name, 13, "%Y%m%d.txt", timeinfo );

	ofstream log_file ( log_file_name, ios::app );

	n = 0;
	start_clock = clock();
	cout<<"Logging Data...";
	do {
		n++;
		while ( clock() < start_clock + CLOCKS_PER_SEC*n ) {}
		time ( &rawtime );
		timeinfo = localtime ( &rawtime );
		strftime ( timestamp, 9, "%X", timeinfo );
		read_sensor_resistance( SensorReadings );
		log_file<<timestamp<<" "<<SensorReadings[0]<<" "<<SensorReadings[1]
		<<" "<<SensorReadings[2]<<" "<<HorizontalDiff<<" "<<VerticalDiff<<"\n";
		cout<<"Sensor 1 resistance: "<<(SensorReadings[0])<<" Ohms\n";
		cout<<"Sensor 2 resistance: "<<(SensorReadings[1])<<" Ohms\n";
		cout<<"Sensor 3 resistance: "<<(SensorReadings[2])<<" Ohms\n";
		cout<<"---------------------------------\n";
	} while ( clock() < start_clock + logTime * CLOCKS_PER_SEC );
	log_file.close();
}