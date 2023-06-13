DEFINT A-Z
DECLARE FUNCTION GetBytesFromLong$ (v&)

CLS

PRINT "OPEN COM1"

filename$ = COMMAND$
IF filename$ = "" THEN filename$ = "inbox.fil"

OPEN "COM1:9600, N, 8, 1, RS, CS, DS, CD, BIN" FOR RANDOM AS #2

DIM p AS LONG
DIM FileSize AS LONG
DIM CheckSum AS LONG

CONST PACKETSIZE = 1024

OPEN filename$ FOR BINARY AS #3
FileSize = LOF(3)

CheckSum = 0
p = 0
WHILE p < FileSize
  sz = PACKETSIZE
  IF p + PACKETSIZE > FileSize THEN sz = FileSize - p

  buf$ = INPUT$(sz, #3)
  FOR i = 1 TO sz
    CheckSum = CheckSum + ASC(MID$(buf$, i, 1))
  NEXT i
                      
  p = p + PACKETSIZE
WEND
CLOSE #3

CONST MARKERSIZE = 4
Header$ = "FILE"

PRINT "FileSize: ", FileSize
PRINT "CheckSum: ", CheckSum

PRINT #2, Header$;
buf$ = GetBytesFromLong$(FileSize)
PRINT #2, buf$;
buf$ = GetBytesFromLong$(CheckSum)
PRINT #2, buf$;

WHILE LOC(2) < MARKERSIZE: WEND
buf$ = INPUT$(MARKERSIZE, #2)
           
OPEN filename$ FOR BINARY AS #3
p = 0
oldproc = 0
WHILE p < FileSize
  sz = PACKETSIZE
  IF p + PACKETSIZE > FileSize THEN sz = FileSize - p

  buf$ = INPUT$(sz, #3)
  PRINT #2, buf$;
                       
  p = p + PACKETSIZE
  IF p < FileSize THEN
     WHILE LOC(2) < MARKERSIZE: WEND
     buf$ = INPUT$(MARKERSIZE, #2)
  END IF

  tekproc = 100 * p / FileSize
  IF oldproc <> tekproc THEN
    PRINT STR$(tekproc) + "%";
    oldproc = tekproc
  END IF

WEND

PRINT
PRINT "Send OK"

CLOSE #2
CLOSE #3

DEFSNG A-Z
FUNCTION GetBytesFromLong$ (v&)
   
  x& = v&
  r$ = ""
  FOR i = 1 TO 4
    'PRINT x&;
    r$ = r$ + CHR$(x& MOD 256)
    'PRINT x& MOD 256;
    x& = x& \ 256
  NEXT i
  PRINT ""
  
  GetBytesFromLong$ = r$
END FUNCTION

