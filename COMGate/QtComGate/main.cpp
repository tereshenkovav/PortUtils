#include "mainwindow.h"

#include <QApplication>
#include "COMUtils.h"

int main(int argc, char *argv[])
{
    //assert(FilePacker::BytesToUint(FilePacker::uintToBytes(100))==100) ;
    //assert(FilePacker::BytesToUint(FilePacker::uintToBytes(200))==200) ;

    QApplication a(argc, argv);
    MainWindow w;
    w.show();
    return a.exec();
}
