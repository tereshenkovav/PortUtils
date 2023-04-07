#include "COMUtils.h"
#include <QApplication>
#include <QThread>
#include <QFile>

QByteArray NEXTMARKER("NEXT") ;
QByteArray HEADERFILE("FILE") ;

uint FilePacker::calcCheckSum(const QByteArray & data)
{
    uint sum = 0 ;
    for (unsigned char b: data) {
       sum += b;
       if (sum > QB_MAX_LONG) sum -= QB_MAX_LONG;
    }
    return sum ;
}

bool FilePacker::writeToFile(const QString & filename, const QByteArray &data)
{
    QFile f(filename) ;
    if (!f.open(QIODevice::WriteOnly)) return false ;

    if (f.write(data)!=data.size()) {
        f.close() ;
        return false ;
    }

    f.close() ;
    return true ;
}

QByteArray FilePacker::uintToBytes(uint v)
{
    QByteArray sz(4,'0') ;
    for (int i = 0; i < 4; i++)
    {
        sz[i] = v & MASK;
        v = v >> 8;
    }
    return sz;
}

uint FilePacker::BytesToUint(const QByteArray & data)
{
    uint r = 0;
    uint v = 1;
    for (unsigned char c: data)
    {
        r += v * c;
        v *= 256;
    }
    return r;
}

QByteArray waitAndReadNBytes(QSerialPort & port, unsigned int cnt)
{
    QThread::msleep(1000);
    QApplication::processEvents();
    while (port.bytesAvailable() < cnt) {
        QApplication::processEvents(); QThread::msleep(1000);
    };
    QByteArray buf = port.read(cnt) ;
    return buf ;
}

FilePacker::FilePacker() {

}

bool FilePacker::doPack(const QString & filename) {

    QFile f(filename) ;
    if (!f.open(QIODevice::ReadOnly)) return false ;

    data = f.readAll() ;
    size = uintToBytes(f.size()) ;
    checksum = uintToBytes(calcCheckSum(data)) ;

    f.close() ;
    return true ;
}
