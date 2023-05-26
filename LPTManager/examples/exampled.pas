program inttest ;
{$asmmode intel}

uses crt,dos ;

// Задержка 977 мс
procedure Delay977 ; assembler ;
asm
  mov al,0
  mov ah,86h
  mov cx,0
  mov dx,1
  int 15h
end ;

var oldfix:Integer ;

procedure WriteTime ;
var h,m,s,ss:Word ;
begin
  gettime(h,m,s,ss) ;
  if oldfix>0 then Writeln('ms delta: ',s*1000+ss-oldfix) ;
  oldfix:=s*1000+ss ;
  Writeln(h,':',m,':',s,':',ss) ;
end ;

var i,q,ticks:Integer ;
begin

  ClrScr ;
  oldfix:=-1 ;
  for q:=0 to 10 do begin
  WriteTime ;
  ticks:=0 ;
  for i:=0 to 999 do begin
     Delay977 ;
     Inc(ticks) ;
  end ;
  Writeln('Ticks: ',ticks) ;
  end ;
  Writeln('End') ;
  Readln ;
end.

