DEFINT A-Z

CLS

PRINT "OPEN COM1"

OPEN "COM1:9600, N, 8, 1, RS, CS, DS, CD, BIN" FOR RANDOM AS #2

PRINT "Start COM ECHO server"
PRINT "Press Esc to stop server"

msg$ = ""

start:

WHILE LOC(2) = 0
  IF INKEY$ = CHR$(27) THEN GOTO fin
WEND

cnt = LOC(2)
buf$ = INPUT$(cnt, #2)
FOR i = 1 TO cnt
  s$ = MID$(buf$, i, 1)
  IF ASC(s$) = 0 THEN
    PRINT "Get msg:"; msg$
    MID$(msg$, 1, 1) = "@"
    MID$(msg$, LEN(msg$), 1) = "#"
    PRINT #2, msg$;
    msg$ = ""
  ELSE
    msg$ = msg$ + s$
  END IF
NEXT i
 
GOTO start

CLOSE #2

fin:
END

