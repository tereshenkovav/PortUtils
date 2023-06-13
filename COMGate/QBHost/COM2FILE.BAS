DEFINT A-Z
DECLARE FUNCTION GetLongFrom4Byte& (bytes$)

CLS

PRINT "OPEN COM1"

filename$ = COMMAND$
IF filename$ = "" THEN filename$ = "inbox.fil"

ON ERROR GOTO skipdelete
KILL filename$
skipdelete:
RESUME NEXT
ON ERROR GOTO 0

OPEN "COM1:9600, N, 8, 1, RS, CS, DS, CD, BIN" FOR RANDOM AS #2
OPEN filename$ FOR BINARY AS #3

DIM p AS LONG
DIM FileSize AS LONG
DIM CheckSum AS LONG
DIM CheckSumCalc AS LONG

p = 0
FileSize = 0
CheckSum = 0
CheckSumCalc = 0
oldproc = 0

CONST SIZEOFLONG = 4
CONST HEADERSIZE = 4
CONST MsgNext$ = "next"
CONST PACKETSIZE = 1024

WHILE LOC(2) < HEADERSIZE: WEND

buf$ = INPUT$(HEADERSIZE, #2)
PRINT "Header:", buf$

WHILE LOC(2) < SIZEOFLONG: WEND

buf$ = INPUT$(SIZEOFLONG, #2)
FileSize = GetLongFrom4Byte&(buf$)
PRINT "FileSize=" + STR$(FileSize)

WHILE LOC(2) < SIZEOFLONG: WEND

buf$ = INPUT$(SIZEOFLONG, #2)
CheckSum = GetLongFrom4Byte&(buf$)
PRINT "CheckSum=" + STR$(CheckSum)

PRINT #2, MsgNext$

start:

teklen = 0
WHILE teklen < PACKETSIZE
  IF p >= FileSize THEN GOTO fin
  IF INKEY$ = CHR$(27) THEN GOTO fin
  WHILE LOC(2) = 0
    IF INKEY$ = CHR$(27) THEN GOTO fin
  WEND
  cnt = LOC(2)
  buf$ = INPUT$(cnt, #2)
  PUT #3, , buf$
  teklen = teklen + cnt
  p = p + cnt
  FOR i = 1 TO cnt
    CheckSumCalc = CheckSumCalc + ASC(MID$(buf$, i, 1))
  NEXT i
WEND
          
tekproc = 100 * p / FileSize
IF oldproc <> tekproc THEN
  PRINT STR$(tekproc) + "%";
  oldproc = tekproc
END IF
 
PRINT #2, MsgNext$

GOTO start

fin:

PRINT ""
IF CheckSumCalc <> CheckSum THEN PRINT "Checksum error!!!" ELSE PRINT "Checksum OK"

CLOSE #2
CLOSE #3

DEFSNG A-Z
FUNCTION GetLongFrom4Byte& (bytes$)
   
  DIM r AS LONG
  DIM n AS LONG
  r = 0
  n = 1

  FOR i = 1 TO 4
    r = r + ASC(MID$(bytes$, i, 1)) * n
    IF i < 4 THEN n = n * 256
  NEXT i
  
  GetLongFrom4Byte& = r
END FUNCTION

