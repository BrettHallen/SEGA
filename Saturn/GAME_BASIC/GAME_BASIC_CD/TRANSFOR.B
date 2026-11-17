  100 '
  110 ' .D Ì§²Ù¦ Basterm Í
  120 ' ÃÝ¿³ ½Ù ÌßÛ¸Þ×Ñ
  130 '
  140 INPUT "Open Device ID ",B$
  150 FILES B$+":"
  160 INPUT "Read File NAME ",A$
  170 OPEN B$+":"+A$ FOR INPUT AS 1
  180 OPEN "COM:"+A$ FOR OUTPUT AS 2
  190 PRINT 
  200 FOR GF=0 TO LOF(1)-1
  210 PRINT USING "File Transformed by ###"; GF/(LOF(1)-1)*100;
  220 PRINT "%";CHR$(&H1E)
  230  FREAD #1,DT$,1
  240  FWRITE #2,DT$
  250 NEXT 
  260 PRINT 
  270 PRINT "complete"
  280 CLOSE 
