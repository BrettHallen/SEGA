' Hello world for GAME BASIC for SEGA SATURN.
' Written without line numbers: turn on "gameBasic.autoLineNumbers"
' (the inlay hints show the numbers each line will be sent with).
*START
CLS
FOR I = 1 TO 10
  PRINT "HELLO SATURN"; I
NEXT I
GOSUB *WAIT
GOTO *START

*WAIT
FOR W = 1 TO 1000: NEXT W
RETURN
