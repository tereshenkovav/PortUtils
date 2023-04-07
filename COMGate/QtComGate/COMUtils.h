#ifndef COMUTILS_H
#define COMUTILS_H

#include <QtSerialPort/QSerialPort>

class FilePacker {
private:
    QByteArray data ;
    QByteArray checksum ;
    QByteArray size ;   
public:
    FilePacker() ;
    bool doPack(const QString & filename) ;
    QByteArray getData() const { return data ; } ;
    QByteArray getChecksum() const { return checksum ; } ;
    QByteArray getSize() const { return size ; } ;
    static QByteArray uintToBytes(uint v) ;
    static uint BytesToUint(const QByteArray & data) ;
    static uint calcCheckSum(const QByteArray & data) ;
    static bool writeToFile(const QString & filename, const QByteArray & data) ;

};

QByteArray waitAndReadNBytes(QSerialPort & port, unsigned int cnt) ;

const uint HEADERSIZE = 4;
const uint LONGSIZE = 4;
const uint BLOCKSIZE = 1024;
extern QByteArray NEXTMARKER ;
extern QByteArray HEADERFILE ;
const uint QB_MAX_LONG = 2147483647 ;
const uint MASK = 0xFF;
const uint PORTSPEED = 9600 ;

#endif // COMUTILS_H
