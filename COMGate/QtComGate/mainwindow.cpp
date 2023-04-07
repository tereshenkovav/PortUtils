#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QtSerialPort/QSerialPortInfo>
#include <QSettings>
#include "COMUtils.h"
#include <QDateTime>
#include <QDebug>
#include <QFileDialog>
#include <QMessageBox>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    QStringList ports ;
    for (auto info: QSerialPortInfo::availablePorts())
        ports.append(info.portName()) ;
    ports.sort() ;
    ui->comboPorts->addItems(ports) ;
    if (ports.count()>0) {
        QSettings ini("ports.ini",QSettings::IniFormat) ;
        ini.beginGroup("Port") ;
        ui->comboPorts->setCurrentIndex(ports.indexOf(ini.value("DefaultPort",ports[0]).toString())) ;
    }

    ui->butClose->hide() ;
    ui->widget_2->hide() ;
    //ui->textLog->hide() ;
    //ui->progressBar->hide() ;
}

MainWindow::~MainWindow()
{
    delete ui;
}


void MainWindow::on_butOpen_clicked()
{
    if (ui->comboPorts->currentIndex()==-1) {
        addLog("Ошибка - не найден или не указан порт") ;
        return ;
    }
    port.setPortName(ui->comboPorts->itemText(ui->comboPorts->currentIndex())) ;
    // Задействовать PORTSPEED
    port.setBaudRate(QSerialPort::Baud9600,QSerialPort::AllDirections) ;
    port.setDataBits(QSerialPort::Data8) ;
    port.setParity(QSerialPort::NoParity) ;
    port.setStopBits(QSerialPort::OneStop) ;
    port.setFlowControl(QSerialPort::NoFlowControl) ;

    if (!port.open(QIODevice::ReadWrite)) {
        addLog("Ошибка открытия порта") ;
        return ;
    }
    addLog("Порт "+port.portName()+" открыт") ;

    QSettings ini("ports.ini",QSettings::IniFormat) ;
    ini.beginGroup("Port") ;
    ini.setValue("DefaultPort",ui->comboPorts->itemText(ui->comboPorts->currentIndex())) ;
    ini.sync() ;

    ui->butOpen->hide() ;
    ui->butClose->show() ;
    ui->butClose->show() ;
    ui->widget_2->show() ;
    //ui->textLog->show() ;
    //ui->progressBar->show() ;
}

void MainWindow::addLog(const QString &str)
{
    ui->textLog->appendPlainText(str) ;
    qDebug()<<str ;
}

void MainWindow::on_butClose_clicked()
{
    port.flush() ;
    port.close() ;
    ui->butOpen->show() ;
    ui->butClose->hide() ;
    addLog("Порт "+port.portName()+" закрыт") ;
}

void MainWindow::on_butSend_clicked()
{
    ui->butSend->hide() ;
    QApplication::processEvents() ;
    QString filename=QFileDialog::getOpenFileName(this,"Выберите файл для отправки") ;
    if (filename.length()==0) return ;

    FilePacker packer ;
    if (!packer.doPack(filename)) {
        addLog("Ошибка упаковки файла") ;
        return ;
    }

    qint64 start = QDateTime::currentMSecsSinceEpoch() ;

    port.write(HEADERFILE) ;
    port.write(packer.getSize()) ;
    port.write(packer.getChecksum()) ;
    port.flush() ;
    waitAndReadNBytes(port,NEXTMARKER.length());

    const uint flen = packer.getData().length() ;
    ui->progressBar->setMaximum(flen) ;
    uint p = 0;
    ui->progressBar->setValue(p) ;
    while (p < flen)
    {
        int len = BLOCKSIZE;
        if (p + BLOCKSIZE >= flen) len = flen - p;
        addLog(QString("send at %0, bc=%1 from %2 bytes (%3%%)").arg(
                   p).arg(len).arg(flen).arg(100*p/flen));

        qDebug()<<port.write(packer.getData().mid(p,len));
        port.flush() ;

        p += BLOCKSIZE;
        ui->progressBar->setValue(p) ;
        if (p < flen) waitAndReadNBytes(port,NEXTMARKER.length());
    }
    ui->progressBar->setValue(flen) ;
    int secs = QDateTime::currentMSecsSinceEpoch()-start ;
    if (secs==0) secs=1 ;
    addLog(QString("send ok, sec: %0, speed: %1 byte/s, expected: %2 byte/s").arg(
               secs/1000).arg(flen/(secs/1000)).arg(PORTSPEED/9)) ;
    ui->butSend->show() ;
}

void MainWindow::on_butGet_clicked()
{
    addLog("Waiting data") ;
    QByteArray header = waitAndReadNBytes(port,HEADERSIZE);
    addLog("Header: " + header);

    QByteArray bsize = waitAndReadNBytes(port,LONGSIZE);
    uint filesize = FilePacker::BytesToUint(bsize);
    addLog(QString("FileSize: %0").arg(filesize)) ;

    QByteArray bsum = waitAndReadNBytes(port,LONGSIZE);
    uint checksum = FilePacker::BytesToUint(bsum);
    addLog(QString("Checksum: %0").arg(checksum)) ;

    port.write(NEXTMARKER);

    ui->progressBar->setMaximum(filesize) ;
    uint p = 0;
    ui->progressBar->setValue(p) ;

    QByteArray bytes ;
    while (p < filesize)
    {
        uint len = BLOCKSIZE;
        if (p + BLOCKSIZE >= filesize) len = filesize - p;
        bytes.append(waitAndReadNBytes(port,len));

        addLog(QString("get %0, bc=%1 from %2 bytes (%3%%)").arg(
            p).arg(len).arg(filesize).arg(100 * p / filesize));

        p += BLOCKSIZE;
        ui->progressBar->setValue(p) ;
        if (p < filesize) port.write(NEXTMARKER);
    }
    ui->progressBar->setValue(filesize) ;

    uint calcchecksum = FilePacker::calcCheckSum(bytes) ;
    if (calcchecksum != checksum) {
        addLog("Error checksum!!!");
        return ;
    }

    QString filename=QFileDialog::getSaveFileName(this,"Выберите файл для сохранения") ;
    if (filename.length()==0) return ;

    if (!FilePacker::writeToFile(filename, bytes)) {
        addLog("Error save file") ;
        return ;
    }

    else addLog("Save file OK");
}
