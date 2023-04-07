program lpt_manager ;

{$ifdef fpc}{$mode objfpc}{$h+}{$endif}

{$define ONLY_EMULATE}

uses crt,SysUtils, lpt_tools ;

type
  Tbyteset = set of byte ;

procedure WriteState(pins:Tbyteset) ;
var i:Integer ;
    c:char ;
begin
  ClrScr() ;
  Writeln() ;
  Writeln('*** Manage PINS of LPT port at /dev/port ***') ;
  Writeln() ;
  Writeln(StringOfChar('-',8*4+1)) ;

  Write('|') ;
  for i:=1 to 8 do
    Write(' '+IntToStr(i)+' |') ;
  Writeln() ;

  Writeln(StringOfChar('-',8*4+1)) ;

  Write('|') ;
  for i:=0 to 7 do begin
    if i in pins then c:='+' else c:=' ' ;
    Write(' '+c+' |') ;
  end ;
  Writeln() ;

  Writeln(StringOfChar('-',8*4+1)) ;
  Writeln() ;
  Writeln('Press 1-8 to switch LPT PIN, Esc for exit') ;
end ;

var key:char ;
    pins:Tbyteset ;
    pin:byte ;
begin

   pins:=[] ;
   {$IFNDEF ONLY_EMULATE}
   initPort() ;
   offAllPins() ;
   {$ENDIF}
 
   repeat
     WriteState(pins) ;

     repeat
     until KeyPressed() ;

     key:=ReadKey() ;
     if (ord(key)>=49)and(ord(key)<=56) then begin
       pin:=ord(key)-49 ; 
       if pin in pins then Exclude(pins,pin) else Include(pins,pin) ;
       {$IFNDEF ONLY_EMULATE}
       setPins(pins) ;
       {$ENDIF}
     end ;
       
   until key=chr(27) ; 

   {$IFNDEF ONLY_EMULATE}
   closePort() ;
   {$ENDIF}
 
end.