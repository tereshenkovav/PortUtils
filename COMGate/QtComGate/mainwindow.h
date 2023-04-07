#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QtSerialPort/QSerialPort>

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void on_butOpen_clicked();

    void on_butClose_clicked();

    void on_butSend_clicked();

    void on_butGet_clicked();

private:
    Ui::MainWindow *ui;
    QSerialPort port ;
    void addLog(const QString & str) ;
};
#endif // MAINWINDOW_H
