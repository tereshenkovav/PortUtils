program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, ports, x86, sysutils, Crt
  { you can add units after this };

{$R *.res}

Var
  i, j: Integer;
  aTime: TDateTime;

begin
  fpIOperm($9c00, 8, 1);
  For i := 0 To 10 Do
    Begin
      aTime := Now;
      For j := 1 To 50 + (10 - i) * 10 Do
        Begin
          port[$9c00] := 255;
          Sleep(i);
          port[$9c00] := 0;
          Sleep(5);
          If KeyPressed Then
            Begin
              Port[$9c00] := 0;
              Break;
            End;
        End;
      WriteLn(FormatDateTime('ss:zz', Now - aTime));
      WriteLn('Step: ' + IntToStr(i));
    End;
  For i := 9 DownTo 0 Do
    Begin
      aTime := Now;
      For j := 1 To 150 + (10 - i) * 10 Do
        Begin
          port[$9c00] := 255;
          Sleep(i);
          port[$9c00] := 0;
          Sleep(5);
          If KeyPressed Then
            Begin
              Port[$9c00] := 0;
              Break;
            End;
        End;
      WriteLn(FormatDateTime('ss:zz', Now - aTime));
      WriteLn('Step: ' + IntToStr(i));
    End;
  fpIOperm($9c00, 8, 0);
end.
