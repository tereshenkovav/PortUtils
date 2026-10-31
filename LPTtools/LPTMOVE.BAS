' Утилита позволяет двигать клавишами a и d на клавиатуре
' текущий бит на LPT-порту от 0-го до 3-го

DEFINT A-Z

DIM v(4) AS INTEGER

v(0) = 1
v(1) = 2
v(2) = 4
v(3) = 8

idx = 0

Start:

K$ = INKEY$
IF K$ = CHR$(27) THEN END
IF (K$ = "d") AND (idx < 3) THEN idx = idx + 1
IF (K$ = "a") AND (idx > 0) THEN idx = idx - 1
           
OUT &H378, v(idx)

GOTO Start

