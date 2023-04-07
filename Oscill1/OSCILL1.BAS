'$DYNAMIC
DEFINT A-Z
DECLARE SUB FILLPINS (pins() AS INTEGER)
DECLARE SUB fillViews (scann AS INTEGER, freq0 AS LONG, freq1 AS LONG, waitmode AS INTEGER)
DECLARE SUB printInfo (scann AS INTEGER, freq0 AS LONG, freq1 AS LONG)
DECLARE SUB drawLevels ()
DECLARE SUB switchPage ()
DECLARE SUB waitAnyData ()

CONST PIN0 = 5
CONST PIN1 = 6
DIM pins(8) AS INTEGER
DIM t0 AS SINGLE
DIM tstart AS SINGLE
DIM freq0 AS LONG
DIM freq1 AS LONG

  CONST Y1PIN0 = 20
  CONST Y0PIN0 = 90
  CONST Y1PIN1 = 132
  CONST Y0PIN1 = 202
  CONST ZONEWIDTH = 600
  CONST SPACE = 20
  CONST FALSE = 0
  CONST TRUE = 1

  DIM SHARED view0(ZONEWIDTH) AS INTEGER
  DIM SHARED view1(ZONEWIDTH) AS INTEGER
  DIM SHARED levels0(32000) AS INTEGER
  DIM SHARED levels1(32000) AS INTEGER
  DIM SHARED tekpage
  DIM SHARED lcnt
  DIM SHARED delay AS SINGLE
  DIM SHARED extrares

  SCREEN 9, 0, 0, 1
  tekpage = 1

  scann = 1
  extrares = 0

  DO
    t0 = TIMER
    tstart = t0
    DO WHILE t0 = TIMER: LOOP ' align
   
    CALL fillViews(scann, freq0, freq1, FALSE)
   
    CLS
    CALL printInfo(scann, freq0, freq1)
    CALL drawLevels
    CALL switchPage
   
    DO WHILE TIMER - tstart < 1!: LOOP
   
    SELECT CASE INKEY$
      CASE CHR$(27): END
      CASE CHR$(13)
        CLS
        CALL printInfo(scann, freq0, freq1)
        COLOR 15: LOCATE 21, 5: PRINT "Waiting for any data..."
        CALL switchPage
       
        CALL fillViews(scann, freq0, freq1, TRUE)
       
        CLS
        CALL printInfo(scann, freq0, freq1)
        CALL drawLevels
        COLOR 15: LOCATE 21, 5: PRINT "Data collected, press Esc to back"
        CALL switchPage
       
        DO WHILE INKEY$ <> CHR$(27): LOOP
      CASE "1": scann = 1
      CASE "2": scann = 2
      CASE "3": scann = 3
      CASE "4": scann = 9
      CASE "5": scann = 18
      CASE "0": extrares = 1 - extrares
    END SELECT

  LOOP WHILE 1 = 1

REM $STATIC
SUB drawLevels
    FOR x = 1 TO ZONEWIDTH - 1
      IF view0(x) = 1 THEN PSET (SPACE + x, Y1PIN0), 15 ELSE PSET (SPACE + x, Y0PIN0), 15
      IF view0(x) <> view0(x - 1) THEN LINE (SPACE + x, Y1PIN0)-(SPACE + x, Y0PIN0), 15
      IF view1(x) = 1 THEN PSET (SPACE + x, Y1PIN1), 15 ELSE PSET (SPACE + x, Y0PIN1), 15
      IF view1(x) <> view1(x - 1) THEN LINE (SPACE + x, Y1PIN1)-(SPACE + x, Y0PIN1), 15
    NEXT x
END SUB

SUB FILLPINS (pins() AS INTEGER)
  p = INP(&H379)
  v = 1
  FOR i = 0 TO 7
    IF (p AND v) = v THEN pins(i) = 0 ELSE pins(i) = 1
    v = v * 2
  NEXT i
END SUB

SUB fillViews (scann AS INTEGER, freq0 AS LONG, freq1 AS LONG, waitmode AS INTEGER)
  DIM t0 AS SINGLE
  DIM pins(8) AS INTEGER
  DIM cellstep AS SINGLE
  DIM idxs AS SINGLE
   
    lcnt = 0
    freq0 = 0
    freq1 = 0

    last0 = 0
    last1 = 0
   
    IF waitmode = 1 THEN
      CALL FILLPINS(pins())
      startpin0 = pins(PIN0)
      startpin1 = pins(PIN1)
      DO
        CALL FILLPINS(pins())
      LOOP WHILE (startpin0 = pins(PIN0)) AND (startpin1 = pins(PIN1))
      levels0(lcnt) = startpin0
      levels1(lcnt) = startpin1
      lcnt = lcnt + 1
      levels0(lcnt) = pins(PIN0)
      levels1(lcnt) = pins(PIN1)
      lcnt = lcnt + 1
    END IF

    FOR S = 0 TO scann - 1
    t0 = TIMER
    DO WHILE t0 = TIMER
      CALL FILLPINS(pins())
      IF extrares = 0 THEN
        FOR z = 1 TO 50 * scann
          delay = delay * -1!
        NEXT z
      END IF
      levels0(lcnt) = pins(PIN0)
      levels1(lcnt) = pins(PIN1)
      IF last0 <> pins(PIN0) THEN freq0 = freq0 + 1
      IF last1 <> pins(PIN1) THEN freq1 = freq1 + 1
      last0 = pins(PIN0)
      last1 = pins(PIN1)
      lcnt = lcnt + 1
    LOOP
    NEXT S
  
    freq0 = freq0 * 18.25 / (2 * scann)
    freq1 = freq1 * 18.25 / (2 * scann)

    IF extrares = 1 THEN cellstep = 1 ELSE cellstep = lcnt / ZONEWIDTH

    idxs = 0!
    FOR x = 0 TO ZONEWIDTH - 1
      view0(x) = levels0(CINT(idxs))
      view1(x) = levels1(CINT(idxs))
      idxs = idxs + cellstep
    NEXT x

END SUB

SUB printInfo (scann AS INTEGER, freq0 AS LONG, freq1 AS LONG)

    COLOR 15
    LOCATE 1, 35: PRINT "Channel 0: "; freq0; "Hz"
    LOCATE 9, 35: PRINT "Channel 1: "; freq1; "Hz"
    LOCATE 2, 2: PRINT "1"
    LOCATE 10, 2: PRINT "1"

    COLOR 8
    LOCATE 7, 2: PRINT "0"
    LOCATE 15, 2: PRINT "0"

    LOCATE 17, 5: PRINT "Press 1-5 to width, Enter to wait mode, Esc to exit, 0 to extrares"
    IF scann = 1 THEN COLOR 15 ELSE COLOR 8
    LOCATE 19, 5: PRINT "Mode 1: 1/18s"
    IF scann = 2 THEN COLOR 15 ELSE COLOR 8
    LOCATE 19, 21: PRINT "Mode 2: 1/9s"
    IF scann = 3 THEN COLOR 15 ELSE COLOR 8
    LOCATE 19, 36: PRINT "Mode 3: 1/6s"
    IF scann = 9 THEN COLOR 15 ELSE COLOR 8
    LOCATE 19, 51: PRINT "Mode 4: 1/2s"
    IF scann = 18 THEN COLOR 15 ELSE COLOR 8
    LOCATE 19, 66: PRINT "Mode 5: 1s"

    COLOR 8
    LOCATE 23, 5: PRINT "buffer used:"; lcnt
    
    LOCATE 23, 25
    IF extrares = 0 THEN
      COLOR 8: PRINT "Extrares off"
    ELSE
      COLOR 15: PRINT "Extrares ON"
    END IF

    LINE (SPACE, Y1PIN0)-(SPACE + ZONEWIDTH, Y1PIN0), 8
    LINE (SPACE, Y0PIN0)-(SPACE + ZONEWIDTH, Y0PIN0), 8
    LINE (SPACE, Y1PIN1)-(SPACE + ZONEWIDTH, Y1PIN1), 8
    LINE (SPACE, Y0PIN1)-(SPACE + ZONEWIDTH, Y0PIN1), 8

    LINE (SPACE, Y0PIN0 + 7)-(SPACE + ZONEWIDTH, Y0PIN0 + 7), 8
    LINE (SPACE, Y0PIN1 + 7)-(SPACE + ZONEWIDTH, Y0PIN1 + 7), 8
    FOR x = 0 TO 10
      px = SPACE + x * ZONEWIDTH / 10
      IF x MOD 5 = 0 THEN
        LINE (px, Y0PIN0 + 2)-(px, Y0PIN0 + 12), 8
        LINE (px, Y0PIN1 + 2)-(px, Y0PIN1 + 12), 8
      ELSE
        LINE (px, Y0PIN0 + 4)-(px, Y0PIN0 + 10), 8
        LINE (px, Y0PIN1 + 4)-(px, Y0PIN1 + 10), 8
      END IF
    NEXT x

END SUB

SUB switchPage
   tekpage = 1 - tekpage
   IF tekpage = 1 THEN SCREEN 9, 0, 0, 1 ELSE SCREEN 9, 0, 1, 0
END SUB

SUB waitAnyData
  DIM pins(8) AS INTEGER
     
  CALL FILLPINS(pins())
  startpin0 = pins(PIN0)
  startpin1 = pins(PIN1)
  DO
     CALL FILLPINS(pins())
  LOOP WHILE (startpin0 = pins(PIN0)) AND (startpin1 = pins(PIN1))
END SUB

