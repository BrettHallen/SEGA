LOAD"COM:DUMMY"
 1000 SCREEN 0: SKCLOSE :'Initialize screen, Close software keyboard
 1002 '
 1003 'Programed by BITS NAO.Honma
 1004 '
 1005 CLEAR 100,1360:CLS
 1006 PLAYINIT
 1007 FOR I=1 TO 47
 1008   FOR J=0 TO 4
 1009     LOCATE 10,10:PRINT "Wave Form = ";I
 1010     LOCATE 10,11:PRINT "      ml2 = ";J
 1011     USERDATA 0,0,"BUILDLAYER"
 1012     USERDATA     "FM"
 1013     USERDATA     "1",0                                        :'OP#
 1014     USERDATA     STR$(I),0                                    :'W
 1015     USERDATA     "1,1, 0, 7, 31,  0,  0, 31,  0,  0, 24",0    :'X,Y, M, S, AR, DR, SR, RR, SL, TL, ml1
 1016     USERDATA     STR$(J),0                                    :'ml2
 1017     USERDATA     "0,0",0                                      :'dt,KS
 1018     USERDATA     "ENDLAYER"
 1019     USERDATA     "ENDARRANGE"
 1020     TARG READ
 1021     PLAY "@1 O4 L8 CDE"
 1022   NEXT
 1023 NEXT
 1024 END
