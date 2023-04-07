var
Form1: TForm1;
f:TfileStream ;//
n, g:integer;
ch, a:byte;

implementation

{ TForm1 }

procedure TForm1.Timer1Timer(Sender: TObject);
begin
n:=$378;
ch:=strtoint(edit1.Text);
f:=TFileStream.Create('/dev/parport0',fmOpenReadWrite); // открываем файл для записи и чтения
f.Seek(n, soFromBeginning);// смещаемся на величину n
f.Write(ch,1);// записываем в порт величину введенную в edit1
f.Seek(n+1, soFromBeginning);// смещаемся еще на 1 относительно n
f.Read(a,1);// читаем байт по адресу n+1
f.Free; // освобождаем память
edit2.Text:=inttostr(a);// в edit2 пишем значения байта по адресу n+1
end;
