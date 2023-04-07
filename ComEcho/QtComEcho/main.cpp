#include <QCoreApplication>
#include <QtSerialPort/QSerialPort>
#include <QString>
#include <QTextStream>

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    QTextStream qout(stdout) ;
    QTextStream qin(stdin) ;

    QSerialPort port ;

    const char STOPBYTE = 0x00 ;

    QString name="" ;
    if (argc<2) {
        qout<<"Enter port [COM1]:"<<endl ;
        qin>>name ;
    }
    else
        name = argv[1] ;
    if (name.length()==0) name="COM1" ;

    port.setPortName(name);
        if (!port.setBaudRate(QSerialPort::Baud9600,QSerialPort::AllDirections))
            qout<<"err1"<<endl ;
        if (!port.setDataBits(QSerialPort::Data8))
            qout<<"err2"<<endl ;
        if (!port.setParity(QSerialPort::NoParity))
            qout<<"err3"<<endl ;
        if (!port.setStopBits(QSerialPort::OneStop))
            qout<<"err4"<<endl ;
        port.setFlowControl(QSerialPort::NoFlowControl) ;

    if (port.open(QIODevice::ReadWrite)) {

    //port.setFlowControl(QSerialPort.NoFlowControl) ;

      qout<<"Port open"<<endl ;

      QString msg = "" ;
      while (true) {
        qout<<"Enter message or 'exit' for quit"<<endl ;
        qin>>msg ;
        if (msg=="exit") break ;
        QByteArray data = msg.toLocal8Bit() ;
        int msglen = data.length() ;
        int r = port.write(data) ;
        QByteArray end(1,STOPBYTE) ;
       // end[0]=0 ;
        r = port.write(end) ;
        port.flush() ;

        //port.waitForReadyRead() ;
        while (true) {
            if (port.bytesAvailable()>=msglen) break ;
            a.processEvents();
        }

        QByteArray buf = port.readAll() ;
        QString reply = QString::fromLocal8Bit(buf) ;
        qout<<"Reply:"<<endl<<reply<<endl ;

      }

      port.close();
      qout<<"Port closed"<<endl ;
    }
    else {
        qout<<"Error open"<<endl ;
    }

    //return a.exec();
}
