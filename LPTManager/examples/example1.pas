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
f:=TFileStream.Create('/dev/parport0',fmOpenReadWrite); // ��������� ���� ��� ������ � ������
f.Seek(n, soFromBeginning);// ��������� �� �������� n
f.Write(ch,1);// ���������� � ���� �������� ��������� � edit1
f.Seek(n+1, soFromBeginning);// ��������� ��� �� 1 ������������ n
f.Read(a,1);// ������ ���� �� ������ n+1
f.Free; // ����������� ������
edit2.Text:=inttostr(a);// � edit2 ����� �������� ����� �� ������ n+1
end;
