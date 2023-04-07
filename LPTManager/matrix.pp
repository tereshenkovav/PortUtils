program prog1 ;

{$mode objfpc}{$h+}

uses crt,SysUtils, lpt_tools ;

var digits:array[0..9,0..4,0..1] of boolean ;

procedure loadToDigit(n:Integer; matrix:string) ;
var i,j,p:Integer ;
begin
  p:=1 ;
  for j:=0 to 4 do
    for i:=0 to 1 do begin
      digits[n,j,i]:=matrix[p]<>' ' ;
      Inc(p) ;
    end ;
end ;

const MS=1 ;
const MIN=1 ;

var i:Integer ;
    dig:Integer ;
    dt:Integer ;
begin
   loadToDigit(0,'1 '+'  '+'  '+'  '+'  ');
   loadToDigit(1,'11'+'  '+'  '+'  '+'  ');
   loadToDigit(2,'11'+'  '+' 1'+'  '+'  ');
   loadToDigit(3,'11'+'  '+' 1'+'  '+' 1');
   loadToDigit(4,'11'+'1 '+'1 '+'  '+'  ');
   loadToDigit(5,'11'+'1 '+'11'+'  '+'  ');
   loadToDigit(6,'11'+'1 '+'11'+'  '+' 1');
   loadToDigit(7,'11'+'1 '+'1 '+'1 '+'1 ');
   loadToDigit(8,'11'+'1 '+'11'+'1 '+'1 ');
   loadToDigit(9,'11'+'1 '+'11'+'1 '+'11');

   Writeln('Press Esc to exit') ;

   dt:=0 ;
   initPort() ;
   dig:=0 ;
   while true do begin
      if (digits[dig,0,0]) then onPin(2) else offPin(2) ;
      if (digits[dig,0,1]) then onPin(7) else offPin(7) ;

      onPin(1) ;
      sleep(MIN) ;
      offPin(1) ;
      sleep(MS) ;

      for i:=1 to 4 do begin
        if (digits[dig,i,0]) then onPin(2) else offPin(2) ;
        if (digits[dig,i,1]) then onPin(7) else offPin(7) ;

        onPin(0) ;
        sleep(MIN) ;
        offPin(0) ;
        sleep(MS) ;
      end ;

      Inc(dt) ;
      if (dt>=100) then begin
        Inc(dig) ;
        if (dig>9) then dig:=0 ;
        dt:=0 ; 
      end ;

      if keyPressed() then
        if readKey()=chr(27) then  break ;
   end ;
   closePort() ;

end.