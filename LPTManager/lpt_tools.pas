unit lpt_tools ;

{$ifdef fpc}{$mode objfpc}{$h+}{$endif}

{$DEFINE USE_DEV}

interface

type
  TByteSet = set of byte ;

function initPort(defaultPort:Integer=$378):Boolean ;
function closePort():Boolean ;
procedure onPin(n:Integer) ;
procedure offPin(n:Integer) ;
procedure onAllPins() ;
procedure offAllPins() ;
procedure setPins(pins:TByteSet) ;
procedure wait(ms:Integer) ;
procedure Delay977() ;

var 
  dup2con:Boolean = false ;

implementation
uses Classes, SysUtils {$IFNDEF USE_DEV}, Ports {$ENDIF};

var 
  tekpins:byte ;
  pn:Integer ;
  f:TFileStream ;

// internal proc
procedure updatePort() ;
begin
  if (dup2con) then Writeln('pins: ',tekpins) ;
  {$IFDEF USE_DEV}
  f.Seek(pn, soFromBeginning);
  f.Write(tekpins,1);
  {$ELSE}
  port[pn]:=tekpins ;
  {$ENDIF}
end ;

function initPort(defaultPort:Integer=$378):Boolean ;
begin
  {$IFDEF USE_DEV}
  f:=TFileStream.Create('/dev/port',fmOpenReadWrite); 
  {$ENDIF}
  pn:=defaultPort ;
  Result:=True ;
end ;

function closePort():Boolean ;
begin
  {$IFDEF USE_DEV}
  f.Free() ;
  {$ENDIF}
  Result:=True ;
end ;

procedure onPin(n:Integer) ;
begin
  tekpins:=tekpins or (1 shl n) ;
  updatePort() ;
end ;

procedure offPin(n:Integer) ;
begin
  tekpins:=tekpins and (not (1 shl n)) ;
  updatePort() ;
end ;

procedure onAllPins() ;
begin
  tekpins:=255 ;
  updatePort() ;
end ;

procedure offAllPins() ;
begin
  tekpins:=0 ;
  updatePort() ;
end ;

procedure setPins(pins:TByteSet) ;
var i:byte ;
begin
  tekpins:=0 ;
  for i:=0 to 7 do
    if i in pins then tekpins:=tekpins+(1 shl i) ;
  updatePort() ;
end ;

procedure wait(ms:Integer) ;
begin
  // simple ver
  sleep(ms) ;
end ;

// Задержка 977 мс.
// На некоторых BIOS, задержка в два раза короче.
// Для DOSBox, показатели точные.
procedure Delay977() ; assembler ;
asm
  mov al,0
  mov ah,86h
  mov cx,0
  mov dx,1
  int 15h
end ;

end.