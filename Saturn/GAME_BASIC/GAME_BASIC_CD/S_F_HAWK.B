LOAD "COM:S_F_HAWK.B"
 1000 ' GAME BASIC for SEGASATURN Sound Sample Program Ver 1.1
 1001 ' [ S_F_HAWK.B ]
 1002 ' Programmed by Naozumi Honma (nao)
 1003 '               Kanayama Motoyuki (motos)
 1004 '               M.Mitsuhashi  
 1005 '
 1006   SCREEN 0: SKCLOSE         :'Initialize screen, Close software keyboard
 1007   CLEAR 10,1360:IF PEEK(0,3)<>78 THEN KLOAD ON:CLEAR 10,1360:POKE 0,0,56:POKE 0,1,1:POKE 0,2,13:POKE 0,3,78:POKE 0,4,10:POKE 0,5,1
 1008   WIDTH 1,1,38,26:PLAYINIT:COLOR ,RGB(31,31,31):COLOROFS ON,0:COLOROFS(-255,-255,-255):VSYNC:OFS=255
 1009 '
 1010   TITLE$="FIRE HAWK"        :'<<< Polygon Title   >>>
 1011   NUM_OF_MSTR=14            :'<<< MENU ｺｳﾓｸ ﾉ ｶｽﾞ >>>
 1012   PROG$="***** MML Programed by Masakuni Mitsuhashi ***** Sound System Programed by Naozumi Honma (nao) / Bits Laboratory ***** BASIC Main System Programed by Motoyuki Kanayama (motos) / Bits Laboratory *****"
 1013   PROG$=PROG$+" Special Thanks - Kenichi Kunishima, Tomoyuki Shimada *****"
 1014   Q$=SPACE$(40)+PROG$+SPACE$(300):QCUT=1
 1015   GOTO *START_THIS_PROGRAM
 1016 '
 1017 '---------------- MENU DATA
 1018 *MENU_STR
 1019   DATA " ﾌｧｲﾔｰﾎｰｸ - THEXDER 2 - (C)GAME ARTS "
 1020   DATA " 1: プロローグ   :MECANO ASSOCIATES:#"
 1021   DATA " 2: 月 光        :ベートーヴェン   :P"
 1022   DATA " 3: オープニング :MECANO ASSOCIATES:O"
 1023   DATA " 4: STAGE 1      :三橋 正邦        :#"
 1024   DATA " 5: STAGE 2      :MECANO ASSOCIATES:#"
 1025   DATA " 6: STAGE 3      :三橋 正邦        :#"
 1026   DATA " 7: STAGE 4      :M.Yoshimura      :#"
 1027   DATA " 8: STAGE 5      :M.Yoshimura      :#"
 1028   DATA " 9: STAGE 6      :MECANO ASSOCIATES:#"
 1029   DATA "10: STAGE 7      :三橋 正邦        :#"
 1030   DATA "11: STAGE 8      :三橋 正邦        :#"
 1031   DATA "12: STAGE 9      :M.Yoshimura      :#"
 1032   DATA "13: 巨大テグザー :三橋 正邦        :#"
 1033   DATA "14: エンディング :三橋 正邦        :E"
 1034 '
 1035 '---------------- Exit Program
 1036 *EXIT_THIS_PROGRAM
 1037   GOSUB *MUSIC_FADE_OUT:OBJ CLEAR:GOSUB *FADEOUT:INTERVAL (0) OFF:INTERVAL (1) OFF:SCREEN 0:LOCATE 5,0:COLOR 7:PRINT "Loading S_G_ARTS.B":LOAD"CD:S_G_ARTS",R
 1038   END
 1039 '
 1040 '---------------- Start Program
 1041 *START_THIS_PROGRAM
 1042   GOSUB *INIT_SYS
 1043   GOSUB *SET_OBJECTS
 1044 '
 1045 '================ Main Loop
 1046 *PAD_WATCH
 1047   TRIGGA=0
 1048   *PAD_W2:IF TRIGGA THEN KEY$="":KEY=0:GOTO *PAD_TRIGGA
 1049     IF PLAYSTAT(0)=0 THEN EMNUM=-1:GOSUB *DISPLAY_MENU
 1050     KEY$=INKEY$:IF KEY$="" THEN *PAD_W2 ELSE KEY=ASC(KEY$)
 1051   *PAD_TRIGGA
 1052     WTIME=0
 1053     IF KEY=KEY_DOWN  OR KEY=KEY_D2 OR (TRIGGA AND @PAD_DOWN) THEN GOSUB *MOVE_DOWN:GOTO *PAD_WATCH
 1054     IF KEY=KEY_UP    OR KEY=KEY_U2 OR (TRIGGA AND @PAD_UP)   THEN GOSUB *MOVE_UP:  GOTO *PAD_WATCH
 1055     IF KEY=KEY_ENTER OR (TRIGGA AND (@PAD_START OR @PAD_C))  THEN EMNUM=CNUM:GOSUB *MUSIC_FADE_OUT:GOTO *PLAY_GO
 1056     IF KEY=KEY_ESC   OR (TRIGGA AND (@PAD_Y     OR @PAD_B))  THEN *EXIT_THIS_PROGRAM
 1057     GOTO *PAD_WATCH
 1058 '
 1059 '================
 1060 *MOVE_DOWN
 1061   IF CNUM < NUM_OF_MSTR THEN CNUM=CNUM+1
 1062   IF (CNUM > 4) AND (CNUM <= (NUM_OF_MSTR - 3)) THEN MTOP=MTOP+1
 1063   GOSUB *DISPLAY_MENU
 1064   RETURN
 1065 '
 1066 '----------------
 1067 *MOVE_UP
 1068   IF CNUM > 1 THEN CNUM=CNUM-1
 1069   IF (CNUM > 3) AND (CNUM < (NUM_OF_MSTR - 3)) THEN MTOP=MTOP-1
 1070   GOSUB *DISPLAY_MENU
 1071   RETURN
 1072 '
 1073 '----------------
 1074 *DISPLAY_MENU
 1075   MDY=38
 1076   FOR I=MTOP TO MTOP+6
 1077     IF I=CNUM THEN
 1078       IF I=EMNUM THEN
 1079         KPRINT (10,MDY),MSTR$(I),RGB(31,31,31),,RGB(20,20,0)
 1080       ELSE
 1081         KPRINT (10,MDY),MSTR$(I),RGB(31,31,31),,RGB(0,20,20)
 1082       ENDIF
 1083     ELSE
 1084       IF I=EMNUM THEN
 1085         KPRINT (10,MDY),MSTR$(I),RGB(31,31,0),,RGB(16,16,16)
 1086       ELSE
 1087         KPRINT (10,MDY),MSTR$(I),RGB(31,31,31)
 1088       ENDIF
 1089     ENDIF
 1090     MDY=MDY+18
 1091   NEXT
 1092   RETURN
 1093 '
 1094 '================ Subroutines
 1095 *INIT_SYS
 1096   MTOP=1:CNUM=1:EMNUM=-1
 1097   DIM MSTR$(NUM_OF_MSTR)
 1098   RESTORE *MENU_STR:FOR I=0 TO NUM_OF_MSTR:READ MSTR$(I):NEXT
 1099 '
 1100   PAD_ABCXYZSTART = @PAD_A+@PAD_B+@PAD_C+@PAD_START+@PAD_X+@PAD_Y+@PAD_Z
 1101   PAD_UDLR  = @PAD_RIGHT+@PAD_LEFT+@PAD_DOWN+@PAD_UP+@PAD_L+@PAD_R
 1102   KEY_DOWN  = 31:  KEY_D2=ASC("X")-64
 1103   KEY_UP    = 30:  KEY_U2=ASC("E")-64
 1104   KEY_ENTER = 13: KEY_ESC = 27
 1105 '
 1106   SCREEN 0:WIDTH 1,1,38,26:PALETTE ,8*16+15,RGB(31,21,3)
 1107   INITIAL_TOUCH=20:AFTER_TOUCH=3
 1108   ON INTERVAL (0) GOSUB *INT_COUNT: INTERVAL (0) ON,1
 1109   ON INTERVAL (1) GOSUB *DISPLAY_PFONT: INTERVAL (1) ON,1
 1110 *CLEAR_INKEY: IF INKEY$<>"" THEN *CLEAR_INKEY
 1111   TRIGGA=PAD(0,2) :' Clear trigga
 1112   KPRINT (10,20),MSTR$(0),,,RGB(20,0,20)    :'ﾀｲﾄﾙﾋｮｳｼﾞ
 1113   LINE(10,164)-(307,164),RGB(31,31,0)
 1114   KPRINT (10,166),"↑↓";,RGB(31,22,22):KPRINT FIX "(ﾎｳｺｳ ﾎﾞﾀﾝ )--- ";,RGB(21,21,10):KPRINT FIX "Move Cursor",RGB(0,31,20)
 1115   KPRINT (10,182-8),FIX "  START / Cﾎﾞﾀﾝ";,RGB(31,22,22):KPRINT FIX " --- ";,RGB(21,21,10):KPRINT FIX "Start BGM  ",RGB(0,31,20)
 1116   KPRINT (10,198-16),FIX "          Bﾎﾞﾀﾝ";,RGB(31,22,22):KPRINT FIX " --- ";,RGB(21,21,10):KPRINT FIX "RETURN Main Menu",RGB(0,31,20)
 1117   GOSUB *DISPLAY_MENU
 1118   GOSUB *SOUND_INIT    :'Sound Sample ｺﾕｳﾉ ｼｮｷｶ ﾙｰﾁﾝ
 1119   RETURN
 1120 '
 1121 '----------------
 1122 *INT_COUNT:' Make repeat trigga of PAD ULDR
 1123   IF PAD(0)=52 THEN *INT_COUNT_RET: 'Ignore keyboard pad
 1124   TRIGGA=TRIGGA OR (PAD(0,2) AND PAD_ABCXYZSTART): 'Update A,B,C,START buttons
 1125   TESTBTN=PAD(0,1):IF (TESTBTN AND PAD_UDLR) = 0 THEN REPEAT_COUNT=0: GOTO *INT_COUNT_RET
 1126   IF TESTBTNL<>TESTBTN THEN TESTBTNL=TESTBTN: REPEAT_COUNT=0
 1127   IF REPEAT_COUNT=0 THEN REPEAT_COUNT=INITIAL_TOUCH: TRIGGA=TESTBTN: GOTO *INT_COUNT_RET
 1128   REPEAT_COUNT=REPEAT_COUNT-1: IF REPEAT_COUNT <= 0 THEN REPEAT_COUNT=AFTER_TOUCH: TRIGGA=TESTBTN
 1129 *INT_COUNT_RET
 1130   SKCLOSE
 1131   RETURN
 1132 '
 1133 '----------------
 1134 *SET_OBJECTS
 1135 'Object Item Number
 1136   TYPE = 0: XP = 4: XR = 8: XS = 12
 1137   PARENT = 20: XRV= 36
 1138 '
 1139   SETDISP 3: SETPERS 105
 1140   SETLIGHT .5,-1,.5:PRIORITY 10,1
 1141   PFONT$=TITLE$:GOSUB *MAKE_PFONT
 1142   WTIME = 0:SOFS=-255: COLOROFS ON,10:COLOROFS (SOFS,SOFS,SOFS)
 1143   OBJ(1,TYPE)=6:OBJ(1,XRV)=&H0.0018,&H0.0024,-&H0.002
 1144   OBJ(0,XP+2)=110
 1145   RETURN
 1146 '
 1147 '----------------
 1148 *MAKE_PFONT
 1149   SLEN=LEN(PFONT$): PT=-SLEN/2*45 : ND=RND(255)/255:OBJ(1,XP+2)=90+SLEN*10
 1150   FOR SP=1 TO SLEN
 1151     CH$=MID$(PFONT$,SP,1): CH2$=MID$(PFONT$,SP+1,1)
 1152     IF CH$=" " THEN
 1153       PT=PT+40
 1154     ELSE
 1155       OBJ(SP+2,XP)=PT,60:OBJ(SP+2,PARENT)=1:OBJ(SP+2,TYPE)=4: OBJ(SP+2,XRV)=&H0.001
 1156       SETPFONT SP+2,ASC(CH$),(1,1.2,3),RGB(30,24,30)
 1157       IF CH$="I" OR CH2$="I" THEN PT=PT+50 ELSE PT=PT+60
 1158     ENDIF
 1159   NEXT SP
 1160   RETURN
 1161 '
 1162 '----------------
 1163 *DISPLAY_PFONT:GOSUB *DISP_COPYRIGHT
 1164   IF WTIME = 0 THEN *DISP_HIDDEN
 1165   IF WTIME > 60*20 THEN *DISP_APEAR
 1166   WTIME = WTIME + 1: RETURN
 1167 *DISP_HIDDEN
 1168   IF SOFS > -330 THEN SOFS = SOFS - 5
 1169   IF SOFS <= -330 THEN SOFS = -330: WTIME = 1
 1170   GOTO *DISP_RET
 1171 *DISP_APEAR
 1172   IF SOFS < -110 THEN SOFS = SOFS + .5
 1173 *DISP_RET
 1174   OX=SOFS+XSIN(ND)*50: IF OX < -255 THEN OX = -255
 1175   OY=SOFS+XSIN(ND+1/3)*50: IF OY < -255 THEN OY = -255
 1176   OZ=SOFS+XSIN(ND+2/3)*50: IF OZ < -255 THEN OZ = -255
 1177   ND=ND+&H0.0004: COLOROFS (OX,OY,OZ)
 1178   RETURN
 1179 '
 1180 '---------------- SCREEN Fade Out
 1181 *FADEOUT
 1182   COLOROFS ON,0:IF OFS=255 THEN RETURN
 1183   FOR OFS=0 TO 255 STEP 32
 1184     COLOROFS(-OFS,-OFS,-OFS)
 1185     VSYNC
 1186   NEXT OFS
 1187   OFS=255
 1188   COLOROFS(-255,-255,-255)
 1189   CLS 0
 1190   VSYNC
 1191   RETURN
 1192 '
 1193 '================ Sound Sample ｺﾕｳﾉ ｼｮｷｶ ﾙｰﾁﾝ
 1194 *SOUND_INIT
 1195   ON MMLSTAT GOSUB *CHANGE_SOUND                              :'!ｺﾏﾝﾄﾞｦ ｼﾞｯｺｳｼﾀﾄｷﾉ ﾄﾋﾞｻｷ
 1196   AM=4
 1197   S=-1
 1198   RETURN
 1199 '
 1200 '================ MUSIC FADE OUT
 1201 *MUSIC_FADE_OUT:IF PLAYSTAT(0)=0 THEN RETURN
 1202   TMP_F=CNUM:CNUM=-1:GOSUB *DISPLAY_MENU:LOCATE 5,0:COLOR 7:PRINT " Music Fade Out...":PLAYFADE 0,0,4:VSYNC 2
 1203   *MFO_LOOP
 1204     IF PLAYSTAT(0)=1 THEN *MFO_LOOP
 1205   CNUM=TMP_F:GOSUB *DISPLAY_MENU:LOCATE 5,0:PRINT "                  ":RETURN
 1206 '
 1207 '================ Start Sound Sample Program
 1208 *PLAY_GO
 1209   PLAYSTOP:VSYNC 2
 1210   TMP=CNUM:CNUM=-1:GOSUB *DISPLAY_MENU:ON TMP GOSUB *MPRO,*MMOON,*MOPEN,*M1,*M2,*M3,*M4,*M5,*M6,*M7,*M8,*M9,*MBIG,*MEND:LOCATE 5,0:PRINT "                 ":CNUM=TMP
 1211   IF CNUM=1 OR CNUM=2 OR CNUM=3 OR CNUM=13 OR CNUM=14 THEN GOSUB *DISPLAY_MENU:VOLUME 111:BGM:VSYNC 2:GOTO *PAD_WATCH
 1212 '
 1213 '---------------- BGM ﾁｪﾝｼﾞｽﾙ Song
 1214   TMP=CNUM:CNUM=-1:GOSUB *DISPLAY_MENU:CHG_FLAG=0:BNUM=1
 1215   KPRINT (10,166),"                               "
 1216   KPRINT (10,182-8),FIX "                               "
 1217   KPRINT (10,198-16),FIX "                                    "
 1218   LOCATE 5,20:COLOR 7:PRINT "Cﾎﾞﾀﾝ/ENTER";:COLOR 5:PRINT " -> ";:COLOR 6:PRINT "BOSS Music  ":LOCATE 5,21:COLOR 7:PRINT "      Bﾎﾞﾀﾝ";:COLOR 5:PRINT " -> ";:COLOR 6:PRINT "Fade Out... ":COLOR 7
 1219   VOLUME 111:BGM 1:VSYNC 2
 1220 '
 1221 '---------------- Change Loop
 1222 *LOOP
 1223   TRIGGA=0
 1224   *FF_PAD_W2
 1225     IF TRIGGA THEN KEY$="":KEY=0:GOTO *FF_PAD_TRIGGA
 1226     IF BNUM=2 THEN
 1227       S=-1
 1228       KPRINT (10,166),"↑↓";,RGB(31,22,22):KPRINT FIX "(ﾎｳｺｳ ﾎﾞﾀﾝ )--- ";,RGB(21,21,10):KPRINT FIX "Move Cursor",RGB(0,31,20)
 1229       KPRINT (10,182-8),FIX "  START / Cﾎﾞﾀﾝ";,RGB(31,22,22):KPRINT FIX " --- ";,RGB(21,21,10):KPRINT FIX "Start BGM  ",RGB(0,31,20)
 1230       KPRINT (10,198-16),FIX "          Bﾎﾞﾀﾝ";,RGB(31,22,22):KPRINT FIX " --- ";,RGB(21,21,10):KPRINT FIX "RETURN Main Menu",RGB(0,31,20)
 1231       LOCATE 10,23:PRINT "             ":LOCATE 10,24:PRINT "               ":LOCATE 5,20:PRINT "                           ":LOCATE 5,21:PRINT "                           "
 1232       COLOR 7:CNUM=TMP:GOSUB *DISPLAY_MENU
 1233       GOTO *PAD_WATCH
 1234     ENDIF
 1235     KEY$=INKEY$:IF KEY$="" THEN *FF_PAD_W2 ELSE KEY=ASC(KEY$)
 1236   *FF_PAD_TRIGGA
 1237     IF KEY=KEY_ENTER OR (TRIGGA AND (@PAD_START OR @PAD_C))  THEN
 1238       LOCATE 10,24:COLOR 5:PRINT "CHANGE REQUEST!":CHG_FLAG=1  :'ｸｷﾞﾘｶﾞﾖｲﾄｺﾛﾏﾃﾞｴﾝｿｳｽﾙﾏﾃﾞBGMｦ ﾍﾝｺｳｼﾅｲ
 1239     ENDIF
 1240     IF KEY=KEY_ESC OR (TRIGGA AND (@PAD_Y OR @PAD_B)) THEN GOSUB *MUSIC_FADE_OUT:BNUM=2
 1241   GOTO *LOOP
 1242 '
 1243 '---------------- ON MMLSTAT GOSUB ﾜﾘｺﾐ ﾙｰﾁﾝ
 1244 *CHANGE_SOUND
 1245   LOCK
 1246   DUMMY=MMLSTAT(0,0)                                          :'Readｼﾃ Statusｦ Clearｼﾃｲﾙ
 1247   CC=(CC+1 AND 7)+1:COLOR CC:LOCATE 10,23:PRINT "Change Point!"
 1248   IF CHG_FLAG=0 THEN UNLOCK:RETURN                            :'Keyｦ ｵｼﾃｲﾅｲﾅﾗ ｿﾉﾏﾏRETURN
 1249   CHG_FLAG=0:BNUM=2:VOLUME 111:BGM 2:VSYNC 2
 1250   LOCATE 10,23:PRINT "             ":LOCATE 10,24:PRINT "               "
 1251   LOCATE 5,20:PRINT "                           ":LOCATE 5,21:PRINT "                           "
 1252   UNLOCK
 1253   RETURN
 1254 '
 1255 '---------------- TONE & SONG SET
 1256 *MOPEN
 1257   IF AM<>0 THEN
 1258     AM=0
 1259     LOCATE 5,0:COLOR 7
 1260     IF PEEK(0,5)=1 THEN PRINT " Tone Data Set...":PLAYINIT "FH_OPEN",2,50,2,200 ELSE PRINT " Arrange Tone....":PLAYINIT 2,50,2,200:RESTORE *MAOPEN:TARG READ
 1261   ENDIF
 1262   LOCATE 5,0:COLOR 7:PRINT " Set Song Data..."
 1263   RESTORE *MSOPEN:SETSONG
 1264   RETURN
 1265 '
 1266 *M1
 1267   GOSUB *MUS1TO9:RESTORE *MS1:SETSONG:RETURN
 1270 '
 1271 *M2
 1272   GOSUB *MUS1TO9:RESTORE *MS2:SETSONG:RETURN
 1275 '
 1276 *M3
 1277   GOSUB *MUS1TO9:RESTORE *MS3:SETSONG:RETURN
 1280 '
 1281 *M4
 1282   GOSUB *MUS1TO9:RESTORE *MS4:SETSONG:RETURN
 1285 '
 1286 *M5
 1287   GOSUB *MUS1TO9:RESTORE *MS5:SETSONG:RETURN
 1290 '
 1291 *M6
 1292   GOSUB *MUS1TO9:RESTORE *MS6:SETSONG:RETURN
 1295 '
 1296 *M7
 1297   GOSUB *MUS1TO9:RESTORE *MS7:SETSONG:RETURN
 1300 '
 1301 *M8
 1302   GOSUB *MUS1TO9:RESTORE *MS8:SETSONG:RETURN
 1305 '
 1306 *M9
 1307   GOSUB *MUS1TO9:RESTORE *MS9:SETSONG:RETURN
 1310 '
 1311 *MBIG
 1312   GOSUB *MUS1TO9:RESTORE *MSBIG:SETSONG:RETURN
 1315 '
 1316 *MEND
 1317   IF AM<>2 THEN
 1318     AM=2
 1319     LOCATE 5,0:COLOR 7
 1320     IF PEEK(0,5)=1 THEN PRINT " Tone Data Set...":PLAYINIT "FH_END",2,50,2,200 ELSE PRINT " Arrange Tone....":PLAYINIT 2,50,2,200:RESTORE *MAEND:TARG READ
 1321   ENDIF
 1322   LOCATE 5,0:COLOR 7:PRINT " Set Song Data..."
 1323   RESTORE *MSEND:SETSONG
 1324   RETURN
 1325 '
 1326 *MPRO
 1327   GOSUB *MUS1TO9:RESTORE *MSPRO:SETSONG:RETURN
 1330 '
 1331 *MMOON
 1332   IF AM<>3 THEN
 1333     AM=3
 1334     LOCATE 5,0:COLOR 7:PRINT " PIANO Tone Set.."
 1335     PLAYINIT "DSP","PIANO":TPROP(1,ALL,@IMIX)=5
 1336   ENDIF
 1337   LOCATE 5,0:COLOR 7:PRINT " Set Song Data..."
 1338   RESTORE *MSMOON:SETSONG
 1339   RETURN
 1340 '
 1341 *MUS1TO9
 1342   IF AM<>1 THEN
 1343     AM=1
 1344     LOCATE 5,0:COLOR 7
 1345     IF PEEK(0,5)=1 THEN PRINT " Tone Data Set...":PLAYINIT "FH_STAGE",2,50,2,200 ELSE PRINT " Arrange Tone....":PLAYINIT 2,50,2,200:RESTORE *MABGM:TARG READ 51
 1346   ENDIF
 1347   LOCATE 5,0:COLOR 7:PRINT " Set Song Data..."
 1348   RETURN
 1349 '
 1350 '###############################
 1351 '      OPENING TONE DATA
 1352 '###############################
 1353 *MAOPEN
 1354  REM  ----------GrandPiano  1
 1355 DATA BUILDLAYER
 1356 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML, ML2, DT ,SC
 1357 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 ,  0 ,  7,  0 ,  8 , 64,  36,  0 ,  2 ,0
 1358 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 22 ,  7 ,  3, 14 ,  6 ,  0,  36,  0 ,  0 ,0
 1359 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 31 ,  0 ,  7,  0 ,  8 , 56,  55,  0 ,  2 ,0
 1360 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 22 ,  7 ,  3, 14 ,  6 ,  0,  36,  0 ,  1 ,0
 1361 DATA ENDLAYER
 1362  REM  ----------E.organ1  2
 1363 DATA BUILDLAYER
 1364 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML, ML2, DT ,SC
 1365 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 ,  0 ,  0, 20 ,  0 , 66,  48,  0 ,  0 ,0
 1366 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  6 , 31 ,  0 ,  0, 20 ,  0 ,  0,  48,  0 ,  0 ,0
 1367 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  6 , 31 ,  0 ,  0, 20 ,  0 ,  0,  36,  0 ,  0 ,0
 1368 DATA FM, 4 , 1 ,  4 ,  4 ,  0 ,  6 , 31 ,  0 ,  0, 20 ,  0 ,  0,  24,  0 ,  0 ,0
 1369 DATA ENDLAYER
 1370  REM  ----------SP LEAD   3
 1371 DATA BUILDLAYER
 1372 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML, ML2, DT ,SC
 1373 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 ,  8 ,  0 ,  0,  6 ,  0 , 56,  24,  0 , -3 ,0
 1374 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 16 , 16 , 15,  8 ,  0 , 54,  48,  0 ,  2 ,0
 1375 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 24 ,  4 , 13,  0 ,  0 , 16,  36,  0 ,  0 ,0
 1376 DATA FM, 4 , 1 ,  3 ,  1 , 12 ,  6 , 24 ,  0 , 13, 12 ,  8 ,  0,  48,  0 ,  1 ,0
 1377 DATA ENDLAYER
 1378  REM  ----------LowAtStrng  4
 1379 DATA BUILDLAYER
 1380 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML, ML2, DT ,SC
 1381 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 16 ,  6 ,  2,  8 ,  0 , 56,  36,  0 ,  0 ,0
 1382 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  6 , 16 ,  9 ,  0, 12 ,  2 ,  0,  36,  0 , -3 ,0
 1383 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 17 ,  6 ,  2,  4 ,  0 , 34,  36,  0 ,  0 ,0
 1384 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  6 , 16 ,  0 ,  0, 12 ,  8 ,  0,  36,  0 , -3 ,0
 1385 DATA ENDLAYER
 1386  REM  ----------RVmarnba  5
 1387 DATA BUILDLAYER
 1388 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML, ML2, DT ,SC
 1389 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 25 , 23 , 10,  4 , 28 , 44,  55,  0 ,  5 ,0
 1390 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  6 , 25 , 10 , 11,  8 , 31 ,  0,  36,  0 ,  0 ,0
 1391 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 25 , 20 , 11,  4 , 28 , 30,  58,  0 , -80 ,0
 1392 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  6 , 25 , 10 , 12,  8 , 31 ,  0,  24,  0 ,  0 ,0
 1393 DATA ENDLAYER
 1394  REM  ----------Sitar 6
 1395 DATA BUILDLAYER
 1396 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML, ML2, DT ,SC
 1397 DATA FM, 1 , 1 ,  1 ,  1 ,  3 ,  0 , 31 ,  7 ,  3,  4 , 14 , 56,  58,  0 , -77 ,0
 1398 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 ,  6 ,  8 ,  6, 10 , 12 , 92,  62,  0 ,  9 ,0
 1399 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 31 ,  2 ,  2,  4 ,  6 , 66,  24,  0 ,  0 ,0
 1400 DATA FM, 4 , 1 ,  3 ,  1 , 12 ,  6 , 31 , 10 ,  8, 16 ,  8 ,  0,  24,  0 ,  0 ,0
 1401 DATA ENDLAYER
 1402  REM  ----------Echo synth  7
 1403 DATA BUILDLAYER
 1404 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML, ML2, DT ,SC
 1405 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 ,  9 , 15,  0 ,  6 , 46,  36,  0 , -3 ,0
 1406 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  6 , 31 ,  9 ,  8, 10 , 12 ,  0,  43,  0 ,  5 ,0
 1407 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 31 ,  9 , 15,  0 ,  6 , 42,  24,  0 ,  3 ,0
 1408 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  6 , 31 ,  9 ,  8, 10 , 12 ,  4,  36,  0 ,  0 ,0
 1409 DATA ENDLAYER
 1410  REM  ----------SOLO      8
 1411 DATA BUILDLAYER
 1412 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML, ML2, DT ,SC
 1413 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 20 ,  4 ,  6, 12 ,  4 , 64,  48,  0 , -3 ,0
 1414 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  6 , 15 ,  5 ,  6, 12 , 10 ,  0,  36,  0 ,  2 ,0
 1415 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 18 ,  4 ,  5, 10 , 10 , 34,  36,  0 ,  0 ,0
 1416 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  6 , 17 ,  5 ,  6, 12 , 10 ,  0,  24,  0 ,  0 ,0
 1417 DATA ENDLAYER
 1418  REM  ----------space1    9
 1419 DATA BUILDLAYER
 1420 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML, ML2, DT ,SC
 1421 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 12 , 12 ,  0, 10 ,  0 , 42,  48,  0 ,  0 ,0
 1422 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 16 , 18 , 15,  8 ,  0 , 42,  48,  0 ,  2 ,0
 1423 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 24 ,  4 , 12,  0 ,  0 , 26,  36,  0 ,  0 ,0
 1424 DATA FM, 4 , 1 ,  3 ,  1 , 12 ,  6 , 24 ,  0 , 13, 12 ,  8 ,  0,  48,  0 ,  1 ,0
 1425 DATA ENDLAYER
 1426  REM  ----------Vibe3 10
 1427 DATA BUILDLAYER
 1428 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML, ML2, DT ,SC
 1429 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 , 10 ,  7, 10 , 20 , 60,  64,  0 , -38 ,0
 1430 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  6 , 31 , 13 ,  0, 14 , 10 ,  0,  36,  0 ,  3 ,0
 1431 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  6 , 25 ,  6 ,  2, 10 , 10 ,  0,  24,  0 , -1 ,0
 1432 DATA FM, 4 , 1 ,  4 ,  4 ,  0 ,  6 , 28 , 10 ,  2, 10 , 10 ,  0,  24,  0 ,  1 ,0
 1433 DATA ENDLAYER
 1434  REM  ----------FANTASM   11
 1435 DATA BUILDLAYER
 1436 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML, ML2, DT ,SC
 1437 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 12 , 12 ,  0, 10 ,  0 , 56,  48,  0 ,  0 ,0
 1438 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 16 , 18 , 15,  8 ,  0 , 24,  48,  0 ,  2 ,0
 1439 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 24 ,  4 , 12,  0 ,  0 , 22,  36,  0 ,  0 ,0
 1440 DATA FM, 4 , 1 ,  3 ,  1 , 12 ,  6 , 24 ,  8 ,  6, 12 ,  8 ,  0,  48,  0 ,  1 ,0
 1441 DATA ENDLAYER
 1442  REM  ----------GOM BASS  12
 1443 DATA BUILDLAYER
 1444 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML, ML2, DT ,SC
 1445 DATA FM, 1 , 1 ,  1 ,  1 ,  5 ,  0 , 31 ,  9 ,  3, 18 , 10 , 34,  24,  0 ,  0 ,0
 1446 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  6 , 31 , 15 ,  7, 18 , 12 , 18,  24,  0 ,  0 ,0
 1447 DATA FM, 3 , 1 ,  1 ,  1 , 12 ,  6 , 31 ,  9 ,  7, 18 , 12 , 14,  12,  0 , -3 ,0
 1448 DATA FM, 4 , 1 ,  1 ,  1 , 12 ,  6 , 31 ,  6 , 11, 12 ,  8 ,  0,  12,  0 ,  0 ,0
 1449 DATA ENDLAYER
 1450  REM  ----------RV BRASS  13
 1451 DATA BUILDLAYER
 1452 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML, ML2, DT ,SC
 1453 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 14 , 14 ,  0,  6 ,  2 , 42,  24,  0 ,  3 ,0
 1454 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 14 ,  8 ,  0, 20 , 16 , 70,  58,  0 , -77 ,0
 1455 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 13 , 14 ,  0,  6 ,  2 , 60,  24,  0 ,  3 ,0
 1456 DATA FM, 4 , 1 ,  3 ,  1 , 12 ,  6 , 23 ,  3 ,  0, 12 ,  0 ,  0,  24,  0 ,  3 ,0
 1457 DATA ENDLAYER
 1458  REM  ----------SP SNAREo2  14
 1459 DATA BUILDLAYER
 1460 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML, ML2, DT ,SC
 1461 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 ,  0 ,  0,  4 ,  0 ,  0,  64,  0 , -35 ,0
 1462 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 31 , 21 , 16, 16 ,  4 ,  0,  64,  0 , -35 ,0
 1463 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 31 , 21 ,  0, 31 , 22 ,  0,  48,  0 ,  1 ,0
 1464 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 31 , 19 , 17, 18 ,  4 ,  0,  12,  0 , -3 ,0
 1465 DATA ENDLAYER
 1466  REM  ----------multiString2  15
 1467 DATA BUILDLAYER
 1468 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML, ML2, DT ,SC
 1469 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 25 ,  3 ,  0,  4 ,  4 , 58,  24,  0 , -2 ,0
 1470 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  0 , 25 ,  3 ,  0,  4 ,  4 , 56,  36,  0 ,  0 ,0
 1471 DATA FM, 3 , 1 ,  3 ,  2 ,  0 ,  0 , 25 ,  3 ,  0,  4 ,  4 , 68,  43,  0 ,  7 ,0
 1472 DATA FM, 4 , 1 ,  2 ,  3 , 12 ,  6 , 10 ,  5 ,  0, 14 ,  4 ,  0,  36,  0 ,  0 ,0
 1473 DATA ENDLAYER
 1474  REM  ----------DGUITER2 16
 1475 DATA BUILDLAYER
 1476 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML, ML2, DT ,SC
 1477 DATA FM, 1 , 1 ,  1 ,  1 ,  8 ,  0 , 31 ,  0 ,  0, 12 ,  0 , 52,  24,  0 ,  3 ,0
 1478 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 31 ,  0 ,  0, 12 ,  0 , 64,  24,  0 ,  3 ,0
 1479 DATA FM, 3 , 1 ,  1 ,  2 , 12 ,  0 , 31 ,  0 ,  0, 12 ,  0 , 36,  48,  0 , -1 ,0
 1480 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  6 , 31 ,  0 ,  0, 12 ,  0 ,  0,  24,  0 , -1 ,0
 1481 DATA ENDLAYER
 1482  REM  ----------metasynth 17
 1483 DATA BUILDLAYER
 1484 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML, ML2, DT ,SC
 1485 DATA FM, 1 , 1 ,  1 ,  1 ,  6 ,  0 , 26 ,  8 ,  0,  4 , 12 , 28,  48,  0 ,  0 ,0
 1486 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  6 , 24 ,  6 , 10, 12 , 14 ,  0,  36,  0 , -2 ,0
 1487 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 24 ,  7 ,  3,  8 ,  8 , 56,  36,  0 ,  3 ,0
 1488 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  6 , 24 ,  3 ,  6, 12 ,  0 ,  8,  24,  0 ,  0 ,0
 1489 DATA ENDLAYER
 1490  REM  ----------EXPLOSN  18
 1491 DATA BUILDLAYER
 1492 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML, ML2, DT ,SC
 1493 DATA FM, 1 , 1 ,  1 ,  1 ,  7 ,  0 , 29 ,  8 ,  0,  0 , 22 , 32,  52,  0 , -32 ,0
 1494 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 31 ,  8 ,  1,  4 , 24 , 18,  36,  0 ,  0 ,0
 1495 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 29 , 10 ,  1,  8 ,  4 , 36,  36,  0 ,  3 ,0
 1496 DATA FM, 4 , 1 ,  3 ,  1 , 12 ,  7 , 31 ,  7 ,  3,  8 ,  8 ,  0,  12,  0 , -3 ,0
 1497 DATA ENDLAYER
 1498  REM  ----------SP BASS 19
 1499 DATA BUILDLAYER
 1500 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML, ML2, DT ,SC
 1501 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 28 , 16 ,  8, 18 , 31 , 40,  64,  0 , -37 ,0
 1502 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 24 , 12 ,  6, 12 , 10 , 40,  24,  0 , -3 ,0
 1503 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 26 ,  2 ,  6, 12 ,  0 , 40,  24,  0 , -1 ,0
 1504 DATA FM, 4 , 1 ,  3 ,  1 , 12 ,  6 , 24 ,  9 ,  3, 12 ,  0 ,  0,  48,  0 , -2 ,0
 1505 DATA ENDLAYER
 1506  REM  ----------GYO BASS  20
 1507 DATA BUILDLAYER
 1508 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML, ML2, DT ,SC
 1509 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 , 15 ,  3, 12 , 18 , 66,  24,  0 ,  0 ,0
 1510 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 31 , 15 ,  7, 12 , 12 , 68,  12,  0 ,  0 ,0
 1511 DATA FM, 3 , 1 ,  1 ,  2 , 12 ,  0 , 31 ,  9 ,  7, 12 , 12 , 20,  12,  0 , -3 ,0
 1512 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  6 , 31 ,  6 , 11, 16 ,  8 ,  0,  24,  0 ,  0 ,0
 1513 DATA ENDLAYER
 1514 REM -------------Drams  21
 1515 REM DATA "STANDARD",31
 1516 DATA "BUILDLAYER"              :' (21)[Drum Set]
 1517 DATA "STANDARD",31,00,-1,-1, -1:'        kick
 1518 DATA            31,01,-1,-1, -1:'        Snere
 1519 DATA            31,02,-1,-1, -1:'        Electric Snere
 1520 DATA            31,03,-1,-1, -1:'        close H H
 1521 DATA            31,04,-1,-1, -1:'        open H H
 1522 DATA            31,05,-1,-1, -1:'        Low Tom
 1523 DATA            31,06,-1,-1, -1:'        Mid Tom
 1524 DATA            31,07,-1,-1, -1:'        High Tom
 1525 DATA "ROCK",    31,07,-1,-1, -1:'        clash Cymbal 1
 1526 DATA "STANDARD",31,09,-1,-1, -1:'        Ride Cymbal
 1527 DATA "ROCK",    31,08,52,72, -1:'        clash Cymbal 2
 1528 DATA "ENDLAYER"
 1529 REM -------------OcheHIT  22
 1530 DATA BUILDLAYER
 1531 DATA EXTRA1,3,0,-1,-1,-1
 1532 DATA EXTRA1,3,0,-1,-1,-1
 1533 DATA ENDLAYER
 1534 DATA ENDARRANGE
 1535 '
 1536 '###############################
 1537 '      BGM TONE DATA
 1538 '###############################
 1539 *MABGM
 1540  REM  ----------ﾌﾞﾗｽ       : @1
 1541 DATA BUILDLAYER
 1542 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1543 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 13 , 14 ,  0,  6 ,  2 , 50,  24 ,  0 ,   3 ,0
 1544 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 13 , 14 ,  0,  6 , 31 , 80,  58 ,  0 , -77 ,0
 1545 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 14 , 14 ,  0,  6 ,  2 , 76,  24 ,  0 ,   3 ,0
 1546 DATA FM, 4 , 1 ,  3 ,  1 , 12 ,  7 , 19 ,  3 ,  0, 14 ,  0 ,  0,  24 ,  0 ,   3 ,0
 1547 DATA ENDLAYER
 1548  REM  ----------ｼﾝｾ2       : @2
 1549 DATA BUILDLAYER
 1550 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1551 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 ,  7 ,  0,  6 ,  2 , 60,  36 ,  0 ,   3 ,0
 1552 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 24 , 31 ,  0, 12 ,  0 , 32,  36 ,  0 ,   3 ,0
 1553 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 31 ,  7 ,  0,  6 ,  2 , 24,  24 ,  0 ,  -3 ,0
 1554 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 30 , 31 ,  0, 12 ,  0 , 32,  36 ,  0 ,   0 ,0
 1555 DATA ENDLAYER
 1556  REM  ----------ﾃﾞｨｽﾄｷﾞﾀｰ3 : @3
 1557 DATA BUILDLAYER
 1558 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1559 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 ,  0 ,  0,  6 ,  0 , 60,  36 ,  0 ,   3 ,0
 1560 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 31 ,  0 ,  0,  6 ,  0 , 60,  24 ,  0 ,  -3 ,0
 1561 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 31 ,  0 ,  0,  6 ,  0 , 40,  36 ,  0 ,  -3 ,0
 1562 DATA FM, 4 , 1 ,  3 ,  1 , 12 ,  7 , 31 ,  0 ,  1, 14 ,  0 ,  0,  24 ,  0 ,   0 ,0
 1563 DATA ENDLAYER
 1564  REM  ----------ﾋﾞﾌﾞﾗﾌｫﾝ1  : @4
 1565 DATA BUILDLAYER
 1566 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1567 DATA FM, 1 , 1 ,  1 ,  1 ,  3 ,  0 , 31 , 15 , 14, 20 , 10 , 90,  64 ,  0 , -32 ,0
 1568 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 24 , 17 ,  5,  8 ,  0 , 90,  36 ,  0 ,   3 ,0
 1569 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 31 , 14 ,  8, 12 , 12 , 94,  52 ,  0 , -36 ,0
 1570 DATA FM, 4 , 1 ,  3 ,  1 , 12 ,  7 , 31 , 17 ,  5,  8 ,  0 ,  0,  24 ,  0 ,  -1 ,0
 1571 DATA ENDLAYER
 1572  REM  ----------ｼﾝｾﾍﾞｰｽ1   : @5
 1573 DATA BUILDLAYER
 1574 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1575 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 , 18 ,  0, 12 ,  4 , 72,  64 ,  0 , -32 ,0
 1576 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  0 , 31 , 14 ,  4, 12 ,  4 , 90,  12 ,  0 ,   3 ,0
 1577 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 31 , 10 ,  4, 12 ,  4 , 36,  12 ,  0 ,   3 ,0
 1578 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 31 , 10 ,  3, 12 ,  4 ,  0,  12 ,  0 ,   3 ,0
 1579 DATA ENDLAYER
 1580  REM  ----------alarm2     : @6
 1581 DATA BUILDLAYER
 1582 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1583 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 27 ,  3 ,  2, 16 ,  2 , 70,  43 ,  0 ,   2 ,0
 1584 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  0 , 24 ,  4 ,  0, 16 ,  2 , 66,  36 ,  0 ,   3 ,0
 1585 DATA FM, 3 , 1 ,  3 ,  2 ,  0 ,  0 , 17 ,  0 ,  0,  0 , 12 , 68,  55 ,  0 ,   8 ,0
 1586 DATA FM, 4 , 1 ,  2 ,  3 , 12 ,  7 , 29 ,  0 ,  4, 16 ,  4 ,  0,  48 ,  0 ,  -3 ,0
 1587 DATA ENDLAYER
 1588  REM  ----------ﾄﾗﾝﾍﾟｯﾄ1   : @7
 1589 DATA BUILDLAYER
 1590 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1591 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 13 ,  6 ,  2, 16 ,  2 , 46,  36 ,  0 ,   3 ,0
 1592 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 15 ,  8 ,  0, 16 ,  2 , 56,  55 ,  0 ,   4 ,0
 1593 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 21 ,  7 ,  0, 16 ,  4 , 78,  36 ,  0 ,   3 ,0
 1594 DATA FM, 4 , 1 ,  3 ,  1 , 12 ,  7 , 18 ,  4 ,  0, 16 ,  4 ,  0,  36 ,  0 ,   0 ,0
 1595 DATA ENDLAYER
 1596  REM  ----------ｺｰﾗｽ2      : @8
 1597 DATA BUILDLAYER
 1598 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1599 DATA FM, 1 , 1 ,  1 ,  1 ,  3 ,  0 , 18 ,  0 ,  0, 12 ,  0 , 70,  48 ,  0 ,  -2 ,0
 1600 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 18 ,  0 ,  0, 12 ,  0 ,  0,  36 ,  0 ,  -1 ,0
 1601 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 18 ,  0 ,  0, 12 ,  0 , 70,  48 ,  0 ,   1 ,0
 1602 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 18 ,  0 ,  0, 12 ,  0 ,  0,  36 ,  0 ,   0 ,0
 1603 DATA ENDLAYER
 1604  REM  ----------ﾀﾝﾊﾞﾘﾝ     : @9
 1605 DATA BUILDLAYER
 1606 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1607 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 , 17 , 24, 12 , 20 ,  0,  12 ,  0 ,   1 ,0
 1608 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 31 , 12 , 14, 31 ,  0 ,  4,  64 ,  0 , -38 ,0
 1609 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 31 , 31 , 31, 20 ,  0 ,  0,  12 ,  0 ,  -3 ,0
 1610 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 31 , 21 , 17, 31 , 31 ,  0,  55 ,  0 ,   8 ,0
 1611 DATA ENDLAYER
 1612  REM  ----------snare2     : @10
 1613 DATA BUILDLAYER
 1614 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1615 DATA FM, 1 , 1 ,  1 ,  1 ,  9 ,  0 , 31 ,  0 ,  0,  0 ,  0 ,  0,  64 ,  0 , -35 ,0
 1616 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 31 , 13 , 13, 18 , 26 ,  0,  12 ,  0 ,   0 ,0
 1617 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 31 , 20 ,  0, 18 , 31 ,  0,  48 ,  0 ,   1 ,0
 1618 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 31 , 11 , 11, 22 ,  8 ,  0,  24 ,  0 ,  -3 ,0
 1619 DATA ENDLAYER
 1620  REM  ----------ｽﾈｱ1       : @11
 1621 DATA BUILDLAYER
 1622 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1623 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 ,  0 ,  0, 14 ,  0 ,  0,  64 ,  0 , -35 ,0
 1624 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 31 , 15 , 14, 18 ,  4 ,  0,  64 ,  0 , -35 ,0
 1625 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 31 , 19 ,  0, 31 , 22 , 16,  12 ,  0 ,   2 ,0
 1626 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 31 , 12 , 17, 18 ,  4 ,  0,  12 ,  0 ,  -3 ,0
 1627 DATA ENDLAYER
 1628  REM  ----------ﾏﾙﾁﾄﾞﾗﾑ2   : @12
 1629 DATA BUILDLAYER
 1630 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1631 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 , 21 , 21, 14 , 31 ,  0,  36 ,  0 ,   0 ,0
 1632 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 31 , 14 , 11, 16 , 31 ,  4,  36 ,  0 ,   0 ,0
 1633 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  7 , 31 , 15 , 23, 14 , 10 ,  4,  36 ,  0 ,   3 ,0
 1634 DATA FM, 4 , 1 ,  4 ,  4 ,  0 ,  7 , 31 , 15 , 10, 14 , 12 ,  4,  36 ,  0 ,  -2 ,0
 1635 DATA ENDLAYER
 1636  REM  ----------ﾊﾞｽﾄﾞﾗﾑ2   : @13
 1637 DATA BUILDLAYER
 1638 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1639 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 ,  0 ,  0,  4 ,  0 ,  0,  64 ,  0 , -35 ,0
 1640 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 31 , 19 , 16, 14 , 20 ,  0,  24 ,  0 ,   0 ,0
 1641 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 31 , 19 ,  0, 12 , 22 , 20,  24 ,  0 ,   0 ,0
 1642 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 31 ,  9 ,  0, 18 , 31 ,  8,  12 ,  0 ,   0 ,0
 1643 DATA ENDLAYER
 1644  REM  ----------ｼﾝｾｻｳﾝﾄﾞ18 : @14
 1645 DATA BUILDLAYER
 1646 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1647 DATA FM, 1 , 1 ,  1 ,  1 ,  3 ,  7 , 22 ,  0 ,  0, 10 ,  0 , 24,  48 ,  0 ,   3 ,0
 1648 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  7 , 22 ,  0 ,  0, 10 ,  0 , 24,  24 ,  0 ,   3 ,0
 1649 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  7 , 22 ,  0 ,  0, 10 ,  0 , 24,  48 ,  0 ,  -1 ,0
 1650 DATA FM, 4 , 1 ,  4 ,  4 ,  0 ,  7 , 22 ,  0 ,  0, 10 ,  0 , 18,  24 ,  0 ,  -1 ,0
 1651 DATA ENDLAYER
 1652  REM  ----------ﾋﾞﾌﾞﾗﾌｫﾝ3  : @15
 1653 DATA BUILDLAYER
 1654 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1655 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 , 10 ,  7, 10 , 20 , 60,  64 ,  0 , -38 ,0
 1656 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 31 , 13 ,  0, 14 , 10 , 22,  36 ,  0 ,   3 ,0
 1657 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  7 , 25 ,  6 ,  2, 10 , 10 ,  2,  24 ,  0 ,  -1 ,0
 1658 DATA FM, 4 , 1 ,  4 ,  4 ,  0 ,  7 , 28 , 10 ,  2, 10 , 10 ,  0,  24 ,  0 ,   1 ,0
 1659 DATA ENDLAYER
 1660  REM  ----------ｼﾝｾｻｳﾝﾄﾞ19 : @16
 1661 DATA BUILDLAYER
 1662 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1663 DATA FM, 1 , 1 ,  1 ,  1 ,  3 ,  7 , 22 ,  0 ,  0, 10 ,  0 , 24,  48 ,  0 ,  -3 ,0
 1664 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  7 , 22 ,  0 ,  0, 10 ,  0 , 24,  24 ,  0 ,   0 ,0
 1665 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  7 , 22 ,  0 ,  0, 10 ,  0 , 24,  48 ,  0 ,   2 ,0
 1666 DATA FM, 4 , 1 ,  4 ,  4 ,  0 ,  7 , 22 ,  0 ,  0, 10 ,  0 , 18,  24 ,  0 ,   3 ,0
 1667 DATA ENDLAYER
 1668  REM  ----------ﾃﾞｨｽﾄｷﾞﾀｰ2 : @17
 1669 DATA BUILDLAYER
 1670 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1671 DATA FM, 1 , 1 ,  1 ,  1 ,  8 ,  0 , 31 ,  0 ,  0, 12 ,  0 , 60,  36 ,  0 ,   1 ,0
 1672 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 31 ,  0 ,  0, 12 ,  0 , 66,  36 ,  0 ,   1 ,0
 1673 DATA FM, 3 , 1 ,  1 ,  2 , 12 ,  0 , 31 ,  0 ,  0, 12 ,  0 , 26,  60 ,  0 ,  -1 ,0
 1674 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 31 ,  0 ,  0, 12 ,  0 ,  0,  36 ,  0 ,  -1 ,0
 1675 DATA ENDLAYER
 1676  REM  ----------ｴﾚｷｵﾙｶﾞﾝ5  : @18
 1677 DATA BUILDLAYER
 1678 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1679 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 ,  0 ,  0, 20 ,  0 , 66,  48 ,  0 ,   0 ,0
 1680 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 31 ,  0 ,  0, 20 ,  0 , 24,  48 ,  0 ,   0 ,0
 1681 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  7 , 31 ,  0 ,  0, 20 ,  0 , 24,  36 ,  0 ,   0 ,0
 1682 DATA FM, 4 , 1 ,  4 ,  4 ,  0 ,  7 , 31 ,  0 ,  0, 20 ,  0 , 24,  24 ,  0 ,   0 ,0
 1683 DATA ENDLAYER
 1684  REM  ----------ﾍﾞﾙ3       : @19
 1685 DATA BUILDLAYER
 1686 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1687 DATA FM, 1 , 1 ,  1 ,  1 ,  3 ,  0 , 31 , 11 ,  0, 12 , 31 , 18,  48 ,  0 ,   0 ,0
 1688 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 31 , 11 ,  0,  6 ,  0 , 32,  60 ,  0 ,   0 ,0
 1689 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  7 , 31 , 11 ,  0,  6 ,  2 , 32,  60 ,  0 ,   0 ,0
 1690 DATA FM, 4 , 1 ,  4 ,  4 ,  0 ,  7 , 31 , 11 ,  0,  6 ,  0 , 32,  36 ,  0 ,   0 ,0
 1691 DATA ENDLAYER
 1692  REM  ----------ﾊｰﾄﾞｽﾈｱ1   : @20
 1693 DATA BUILDLAYER
 1694 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1695 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 ,  0 ,  0, 14 ,  0 ,  0,  48 ,  0 ,   0 ,0
 1696 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 31 , 15 , 16, 18 ,  4 ,  0,  12 ,  0 ,   0 ,0
 1697 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 31 , 22 ,  3, 16 , 24 , 16,  48 ,  0 ,   1 ,0
 1698 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 31 , 13 , 16, 18 ,  4 ,  0,  12 ,  0 ,  -3 ,0
 1699 DATA ENDLAYER
 1700  REM  ----------ﾊｲﾊｯﾄｸﾛｰｽﾞ : @21
 1701 DATA BUILDLAYER
 1702 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1703 DATA FM, 1 , 1 ,  1 ,  1 ,  8 ,  0 , 31 , 28 ,  0, 12 ,  0 ,  0,  64 ,  0 , -38 ,0
 1704 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 31 , 25 , 17, 20 ,  6 ,  0,  36 ,  0 ,  -3 ,0
 1705 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 31 , 25 ,  0, 16 ,  4 ,  0,  64 ,  0 , -35 ,0
 1706 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 31 , 25 , 19, 24 , 10 ,  0,  58 ,  0 , -80 ,0
 1707 DATA ENDLAYER
 1708  REM  ----------ｼﾝｾﾀﾑ1     : @22
 1709 DATA BUILDLAYER
 1710 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1711 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 , 19 , 15, 18 ,  0 ,  0,  58 ,  0 , -79 ,0
 1712 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 31 , 19 , 15, 18 , 20 ,  0,  58 ,  0 , -78 ,0
 1713 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 31 , 18 , 15, 16 , 22 , 100,  24 ,  0 ,   0 ,0
 1714 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 31 , 18 , 15, 24 ,  4 ,  0,  24 ,  0 ,  -3 ,0
 1715 DATA ENDLAYER
 1716  REM  ----------ｽﾈｱﾄﾞﾗﾑ3   : @23
 1717 DATA BUILDLAYER
 1718 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1719 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 , 23 ,  0,  0 ,  2 ,  0,  64 ,  0 , -35 ,0
 1720 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 31 , 14 , 21, 14 , 31 ,  0,  24 ,  0 ,   0 ,0
 1721 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 31 , 23 , 20,  4 , 18 ,  0,  36 ,  0 ,   0 ,0
 1722 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 31 , 15 , 16, 14 ,  4 ,  0,  24 ,  0 ,   0 ,0
 1723 DATA ENDLAYER
 1724  REM  ----------ﾍﾞﾙｻｳﾝﾄﾞ   : @24
 1725 DATA BUILDLAYER
 1726 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1727 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 , 12 ,  8, 12 ,  6 , 44,  60 ,  0 ,  -3 ,0
 1728 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 31 , 12 ,  8, 12 ,  6 ,  0,  48 ,  0 ,  -1 ,0
 1729 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  7 , 20 ,  0 ,  0, 12 ,  0 , 20,  48 ,  0 ,  -1 ,0
 1730 DATA FM, 4 , 1 ,  4 ,  4 ,  0 ,  7 , 20 ,  0 ,  0, 12 ,  0 , 20,  36 ,  0 ,   3 ,0
 1731 DATA ENDLAYER
 1732  REM  ----------ｽｽﾞﾌﾞﾗｽ    : @25
 1733 DATA BUILDLAYER
 1734 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1735 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 15 , 16 ,  5, 18 ,  2 , 50,  24 ,  0 ,   3 ,0
 1736 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 22 ,  2 ,  4, 12 , 31 ,  0,  24 ,  0 ,  -3 ,0
 1737 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 31 , 13 , 22,  4 , 18 , 34,  64 ,  0 , -38 ,0
 1738 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 31 , 12 , 10, 18 ,  8 , 16,  60 ,  0 ,   3 ,0
 1739 DATA ENDLAYER
 1740  REM  ----------ﾍﾞﾙｻｳﾝﾄﾞ2  : @26
 1741 DATA BUILDLAYER
 1742 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1743 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 , 22 , 15, 18 ,  0 , 38,  64 ,  0 , -38 ,0
 1744 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 31 , 12 , 10, 14 ,  6 , 28,  60 ,  0 ,  -1 ,0
 1745 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  7 , 31 ,  9 ,  2, 12 ,  6 ,  0,  36 ,  0 ,  -3 ,0
 1746 DATA FM, 4 , 1 ,  4 ,  4 ,  0 ,  7 , 31 ,  9 ,  2, 12 ,  6 ,  0,  24 ,  0 ,   3 ,0
 1747 DATA ENDLAYER
 1748  REM  ----------ｼﾝｾﾍﾞｰｽ2   : @27
 1749 DATA BUILDLAYER
 1750 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1751 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 , 18 ,  0, 12 ,  4 , 74,  64 ,  0 , -32 ,0
 1752 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  0 , 31 , 14 ,  4, 12 ,  4 , 76,  12 ,  0 ,   3 ,0
 1753 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 31 , 10 ,  4, 12 ,  4 , 36,  12 ,  0 ,   3 ,0
 1754 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 31 , 10 ,  3, 12 ,  4 ,  0,  24 ,  0 ,   3 ,0
 1755 DATA ENDLAYER
 1756  REM  ----------ｼﾝｾｽﾄﾘﾝｸﾞ2 : @28
 1757 DATA BUILDLAYER
 1758 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1759 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 25 , 10 ,  0, 10 ,  2 , 58,  24 ,  0 ,   0 ,0
 1760 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 25 , 11 ,  0, 16 , 10 , 30,  52 ,  0 , -35 ,0
 1761 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 28 , 13 ,  0, 12 ,  4 , 96,  24 ,  0 ,   3 ,0
 1762 DATA FM, 4 , 1 ,  3 ,  1 , 12 ,  7 , 14 ,  4 ,  0, 12 ,  4 ,  0,  24 ,  0 ,   0 ,0
 1763 DATA ENDLAYER
 1764  REM  ----------ﾌﾙｰﾄ3      : @29
 1765 DATA BUILDLAYER
 1766 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1767 DATA FM, 1 , 1 ,  1 ,  1 ,  5 ,  0 , 16 , 14 ,  3, 10 , 12 , 44,  24 ,  0 ,  -1 ,0
 1768 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  0 , 17 , 16 ,  2, 10 , 10 , 108,  36 ,  0 ,   0 ,0
 1769 DATA FM, 3 , 1 ,  3 ,  2 ,  0 ,  0 , 11 ,  4 ,  0, 10 ,  4 , 70,  24 ,  0 ,   3 ,0
 1770 DATA FM, 4 , 1 ,  2 ,  3 , 12 ,  7 , 15 ,  4 ,  0, 16 ,  0 ,  0,  24 ,  0 ,   0 ,0
 1771 DATA ENDLAYER
 1772  REM  ----------ｼｬｸﾊﾁ      : @30
 1773 DATA BUILDLAYER
 1774 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1775 DATA FM, 1 , 1 ,  1 ,  1 ,  3 ,  0 ,  8 , 14 , 12, 24 , 31 , 70,  48 ,  0 ,  -3 ,0
 1776 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 10 ,  0 ,  4, 14 ,  8 ,  0,  24 ,  0 ,  -3 ,0
 1777 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 ,  8 , 13 , 12, 24 , 31 , 66,  36 ,  0 ,  -3 ,0
 1778 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 10 ,  0 ,  1, 14 ,  8 ,  0,  24 ,  0 ,  -3 ,0
 1779 DATA ENDLAYER
 1780  REM  ----------ﾄﾗﾝﾍﾟｯｯﾄ   : @31
 1781 DATA BUILDLAYER
 1782 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1783 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 24 ,  6 ,  2, 20 ,  2 , 50,  36 ,  0 ,   3 ,0
 1784 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 16 ,  8 ,  0, 20 ,  2 , 52,  55 ,  0 ,   4 ,0
 1785 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 20 ,  9 ,  0, 24 ,  4 , 70,  36 ,  0 ,   3 ,0
 1786 DATA FM, 4 , 1 ,  3 ,  1 , 12 ,  7 , 25 ,  6 ,  0, 22 ,  4 ,  2,  36 ,  0 ,   0 ,0
 1787 DATA ENDLAYER
 1788  REM  ----------ﾄﾗﾝﾍﾟｯﾄ1   : @32
 1789 DATA BUILDLAYER
 1790 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1791 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 13 ,  6 ,  2, 16 ,  2 , 54,  36 ,  0 ,   3 ,0
 1792 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 15 ,  8 ,  0, 16 ,  2 , 56,  55 ,  0 ,   4 ,0
 1793 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 21 ,  7 ,  0, 16 ,  4 , 78,  36 ,  0 ,   3 ,0
 1794 DATA FM, 4 , 1 ,  3 ,  1 , 12 ,  7 , 18 ,  4 ,  0, 16 ,  4 ,  0,  36 ,  0 ,   0 ,0
 1795 DATA ENDLAYER
 1796  REM  ----------ﾄﾗﾝﾍﾟｯﾄ2   : @33
 1797 DATA BUILDLAYER
 1798 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1799 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 14 ,  8 ,  0,  8 ,  2 , 54,  24 ,  0 ,   0 ,0
 1800 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 18 ,  8 ,  0, 16 ,  2 ,  0,  24 ,  0 ,   0 ,0
 1801 DATA FM, 3 , 1 ,  1 ,  1 , 12 ,  7 , 20 , 14 ,  0, 16 ,  2 ,  0,  24 ,  0 ,   0 ,0
 1802 DATA FM, 4 , 1 ,  1 ,  1 , 12 ,  7 , 12 ,  3 ,  0, 20 ,  2 , 54,  24 ,  0 ,   0 ,0
 1803 DATA ENDLAYER
 1804  REM  ----------ｴﾚｷﾍﾞｰｽ1   : @34
 1805 DATA BUILDLAYER
 1806 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1807 DATA FM, 1 , 1 ,  1 ,  1 ,  7 ,  0 , 31 ,  7 ,  7, 18 ,  4 , 56,  55 ,  0 ,   3 ,0
 1808 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  0 , 31 ,  6 ,  6, 18 ,  2 , 116,  52 ,  0 , -37 ,0
 1809 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 31 ,  9 ,  6, 18 ,  2 , 44,  12 ,  0 ,  -2 ,0
 1810 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 31 ,  6 ,  8, 18 , 31 ,  0,  24 ,  0 ,  -2 ,0
 1811 DATA ENDLAYER
 1812  REM  ----------ｼﾝｾﾍﾞﾙ     : @35
 1813 DATA BUILDLAYER
 1814 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1815 DATA FM, 1 , 1 ,  1 ,  1 ,  6 ,  0 , 26 , 12 , 14,  2 , 12 , 62,  58 ,  0 , -81 ,0
 1816 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 28 ,  6 ,  4,  4 , 16 , 20,  36 ,  0 ,   2 ,0
 1817 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 31 , 11 , 19,  0 , 10 , 62,  58 ,  0 , -82 ,0
 1818 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 24 , 24 ,  3,  4 ,  2 , 20,  36 ,  0 ,   1 ,0
 1819 DATA ENDLAYER
 1820  REM  ----------ﾃﾞｨｽﾄｷﾞﾀｰ1 : @36
 1821 DATA BUILDLAYER
 1822 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1823 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 16 , 14 ,  0,  6 ,  6 , 52,  43 ,  0 ,   3 ,0
 1824 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  0 , 19 ,  0 ,  0, 10 ,  0 , 50,  24 ,  0 ,   3 ,0
 1825 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 26 ,  0 ,  0,  6 ,  0 , 52,  24 ,  0 ,   3 ,0
 1826 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 27 ,  0 ,  0, 22 ,  0 ,  0,  24 ,  0 ,   3 ,0
 1827 DATA ENDLAYER
 1828  REM  ----------ｴﾚｷｵﾙｶﾞﾝ5  : @37
 1829 DATA BUILDLAYER
 1830 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1831 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 ,  0 ,  0, 20 ,  0 , 66,  48 ,  0 ,   0 ,0
 1832 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 31 ,  0 ,  0, 20 ,  0 , 24,  48 ,  0 ,   0 ,0
 1833 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  7 , 31 ,  0 ,  0, 20 ,  0 , 24,  36 ,  0 ,   0 ,0
 1834 DATA FM, 4 , 1 ,  4 ,  4 ,  0 ,  7 , 31 ,  0 ,  0, 20 ,  0 , 24,  24 ,  0 ,   0 ,0
 1835 DATA ENDLAYER
 1836  REM  ----------ﾌﾚｯﾄﾚｽﾍﾞｰｽ : @38
 1837 DATA BUILDLAYER
 1838 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1839 DATA FM, 1 , 1 ,  1 ,  1 ,  6 ,  0 , 30 , 13 ,  8, 12 , 22 , 88,  58 ,  0 , -77 ,0
 1840 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  0 , 28 ,  6 , 10, 12 , 22 , 68,  12 ,  0 ,   3 ,0
 1841 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 28 ,  4 ,  3, 12 ,  6 , 40,  12 ,  0 ,   3 ,0
 1842 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 28 ,  1 ,  5, 12 ,  4 ,  0,  24 ,  0 ,   3 ,0
 1843 DATA ENDLAYER
 1844  REM  ----------ﾊﾝﾄﾞｸﾗｯﾌﾟ  : @39
 1845 DATA BUILDLAYER
 1846 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1847 DATA FM, 1 , 1 ,  1 ,  1 ,  6 ,  0 , 31 , 12 , 18, 16 ,  8 ,  4,  43 ,  0 ,   8 ,0
 1848 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 31 , 20 , 18, 18 ,  6 ,  2,  12 ,  0 ,  -1 ,0
 1849 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 31 , 13 , 30,  8 ,  6 , 22,  12 ,  0 ,   2 ,0
 1850 DATA FM, 4 , 1 ,  3 ,  1 , 12 ,  7 , 31 , 16 , 19, 31 ,  2 ,  0,  12 ,  0 ,  -3 ,0
 1851 DATA ENDLAYER
 1852  REM  ----------ｽｸｰﾙﾋﾟｱﾉ   : @40
 1853 DATA BUILDLAYER
 1854 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1855 DATA FM, 1 , 1 ,  1 ,  1 ,  9 ,  0 , 31 ,  5 ,  2,  2 ,  2 , 70,  24 ,  0 ,  -3 ,0
 1856 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 25 ,  5 ,  2,  2 ,  2 , 86,  36 ,  0 ,   0 ,0
 1857 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 31 ,  5 ,  2,  2 ,  2 , 58,  43 ,  0 ,   8 ,0
 1858 DATA FM, 4 , 1 ,  3 ,  1 , 12 ,  7 , 20 ,  7 ,  2, 12 , 20 ,  0,  24 ,  0 ,   0 ,0
 1859 DATA ENDLAYER
 1860  REM  ----------ﾘｺｰﾀﾞ1     : @41
 1861 DATA BUILDLAYER
 1862 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1863 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 20 , 20 ,  0, 20 , 10 , 68,  36 ,  0 ,   3 ,0
 1864 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 20 , 31 , 15, 31 ,  0 , 68,  24 ,  0 ,   0 ,0
 1865 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 20 ,  0 ,  0,  6 ,  0 , 124,  48 ,  0 ,  -1 ,0
 1866 DATA FM, 4 , 1 ,  3 ,  1 , 12 ,  7 , 18 ,  8 ,  0, 20 ,  2 ,  0,  24 ,  0 ,   3 ,0
 1867 DATA ENDLAYER
 1868  REM  ----------ｽｽﾞﾌﾞﾗｽ    : @42
 1869 DATA BUILDLAYER
 1870 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1871 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 15 , 16 ,  5, 18 ,  2 , 50,  24 ,  0 ,   3 ,0
 1872 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 22 ,  2 ,  4, 12 , 31 ,  0,  24 ,  0 ,  -3 ,0
 1873 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 31 , 13 , 22,  4 , 18 , 34,  64 ,  0 , -38 ,0
 1874 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 31 , 12 , 10, 18 ,  8 ,  8,  60 ,  0 ,   3 ,0
 1875 DATA ENDLAYER
 1876  REM  ----------ｼﾝｾﾌﾞﾗｽ1   : @43
 1877 DATA BUILDLAYER
 1878 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1879 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 ,  7 ,  0,  6 ,  2 , 60,  48 ,  0 ,   3 ,0
 1880 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  0 , 19 , 31 ,  0, 12 ,  0 , 68,  48 ,  0 ,   3 ,0
 1881 DATA FM, 3 , 1 ,  3 ,  2 ,  0 ,  0 , 31 ,  7 ,  0,  6 ,  2 , 24,  36 ,  0 ,  -3 ,0
 1882 DATA FM, 4 , 1 ,  2 ,  3 , 12 ,  7 , 30 , 31 ,  0, 16 ,  0 ,  0,  48 ,  0 ,   0 ,0
 1883 DATA ENDLAYER
 1884  REM  ----------ｼﾝｾﾍﾞｰｽ1   : @44
 1885 DATA BUILDLAYER
 1886 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1887 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 , 18 ,  0, 12 ,  4 , 72,  64 ,  0 , -32 ,0
 1888 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  0 , 31 , 14 ,  4, 12 ,  4 , 90,  12 ,  0 ,   3 ,0
 1889 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 31 , 10 ,  4, 12 ,  4 , 36,  12 ,  0 ,   3 ,0
 1890 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 31 , 10 ,  3, 12 ,  4 ,  0,  12 ,  0 ,   3 ,0
 1891 DATA ENDLAYER
 1892  REM  ----------ﾍﾞﾙ4       : @45
 1893 DATA BUILDLAYER
 1894 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1895 DATA FM, 1 , 1 ,  1 ,  1 ,  9 ,  0 , 27 ,  4 ,  0, 12 , 31 , 70,  43 ,  0 ,   8 ,0
 1896 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 31 ,  7 ,  0, 14 , 31 ,  0,  24 ,  0 ,   0 ,0
 1897 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 31 ,  7 ,  0,  8 , 28 , 82,  64 ,  0 , -38 ,0
 1898 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 31 ,  8 ,  0, 14 , 31 ,  6,  48 ,  0 ,  -3 ,0
 1899 DATA ENDLAYER
 1900  REM  ----------ALARM      : @46
 1901 DATA BUILDLAYER
 1902 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1903 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 13 ,  6 ,  2, 16 ,  2 , 58,  36 ,  0 ,   3 ,0
 1904 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 15 ,  8 ,  0, 16 ,  2 , 64,  36 ,  0 ,  -1 ,0
 1905 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 10 ,  7 ,  0,  0 , 12 , 84,  64 ,  0 , -32 ,0
 1906 DATA FM, 4 , 1 ,  3 ,  1 , 12 ,  7 , 19 ,  0 ,  0, 16 ,  4 ,  0,  36 ,  0 ,   0 ,0
 1907 DATA ENDLAYER
 1908  REM  ----------CHOPPER    : @47
 1909 DATA BUILDLAYER
 1910 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1911 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 , 24 , 12, 14 , 28 ,  6,  62 ,  0 ,  10 ,0
 1912 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 31 , 13 , 23, 14 , 24 , 74,  62 ,  0 ,   7 ,0
 1913 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 31 , 11 , 23, 14 , 26 , 40,  12 ,  0 ,  -3 ,0
 1914 DATA FM, 4 , 1 ,  3 ,  1 , 12 ,  7 , 31 ,  9 , 26, 18 , 26 ,  0,  24 ,  0 ,   0 ,0
 1915 DATA ENDLAYER
 1916  REM  ----------ﾌﾚｯﾄﾚｽﾍﾞｰｽ : @48
 1917 DATA BUILDLAYER
 1918 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1919 DATA FM, 1 , 1 ,  1 ,  1 ,  6 ,  0 , 30 , 13 ,  8, 12 , 22 , 88,  48 ,  0 ,   3 ,0
 1920 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  0 , 28 ,  6 , 10, 12 , 22 , 68,  12 ,  0 ,   3 ,0
 1921 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 28 ,  4 ,  3, 12 ,  6 , 40,  12 ,  0 ,   3 ,0
 1922 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 28 ,  1 ,  5, 12 ,  4 ,  0,  24 ,  0 ,   3 ,0
 1923 DATA ENDLAYER
 1924  REM  ----------STRINGS 1  : @49
 1925 DATA BUILDLAYER
 1926 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1927 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 11 ,  6 ,  4,  8 , 14 , 64,  64 ,  0 , -38 ,0
 1928 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 ,  9 , 17 ,  1, 12 ,  0 ,  0,  60 ,  0 ,   3 ,0
 1929 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 10 , 12 ,  4,  8 , 10 , 38,  36 ,  0 ,   3 ,0
 1930 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 12 ,  4 ,  1, 12 ,  4 , 16,  36 ,  0 ,  -3 ,0
 1931 DATA ENDLAYER
 1932  REM  ----------RV BRASS   : @50
 1933 DATA BUILDLAYER
 1934 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1935 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 14 , 14 ,  0,  6 ,  2 , 42,  24 ,  0 ,   3 ,0
 1936 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 14 ,  8 ,  0, 20 , 16 , 70,  58 ,  0 , -77 ,0
 1937 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 13 , 14 ,  0,  6 ,  2 , 60,  24 ,  0 ,   3 ,0
 1938 DATA FM, 4 , 1 ,  3 ,  1 , 12 ,  7 , 23 ,  3 ,  0, 12 ,  0 ,  0,  24 ,  0 ,   3 ,0
 1939 DATA ENDLAYER
 1940  REM  ----------PIPES      : @51
 1941 DATA BUILDLAYER
 1942 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1943 DATA FM, 1 , 1 ,  1 ,  1 ,  8 ,  0 , 15 ,  8 ,  0, 10 ,  0 , 42,  36 ,  0 ,  -1 ,0
 1944 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 13 , 31 ,  3, 12 ,  0 ,  0,  36 ,  0 ,  -2 ,0
 1945 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 15 ,  8 ,  0, 10 ,  0 , 32,  48 ,  0 ,   0 ,0
 1946 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 13 , 31 ,  3, 14 ,  0 ,  0,  48 ,  0 ,   1 ,0
 1947 DATA ENDLAYER
 1948  REM  ----------SOLO       : @52
 1949 DATA BUILDLAYER
 1950 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1951 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 20 ,  4 ,  6, 12 ,  4 , 64,  60 ,  0 ,  -3 ,0
 1952 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 15 ,  7 ,  6, 12 , 10 ,  0,  48 ,  0 ,   2 ,0
 1953 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 18 ,  4 ,  5, 10 , 10 , 34,  48 ,  0 ,   0 ,0
 1954 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 17 ,  9 ,  6, 12 , 10 , 24,  36 ,  0 ,   0 ,0
 1955 DATA ENDLAYER
 1956  REM  ----------Echo synth : @53
 1957 DATA BUILDLAYER
 1958 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1959 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 ,  9 , 15,  0 ,  6 , 34,  36 ,  0 ,  -3 ,0
 1960 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 31 ,  9 ,  8, 10 , 12 ,  0,  43 ,  0 ,   5 ,0
 1961 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 31 ,  9 , 15,  0 ,  6 , 34,  24 ,  0 ,   3 ,0
 1962 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 31 ,  9 ,  8, 10 , 12 ,  4,  36 ,  0 ,   0 ,0
 1963 DATA ENDLAYER
 1964  REM  ----------synBS2     : @54
 1965 DATA BUILDLAYER
 1966 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1967 DATA FM, 1 , 1 ,  1 ,  1 ,  9 ,  0 , 10 ,  2 ,  2, 16 , 31 , 56,  48 ,  0 ,  -3 ,0
 1968 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 31 ,  2 , 11, 16 , 18 , 30,  12 ,  0 ,  -3 ,0
 1969 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 31 ,  1 ,  1, 12 , 14 , 24,  12 ,  0 ,  -3 ,0
 1970 DATA FM, 4 , 1 ,  3 ,  1 , 12 ,  7 , 31 ,  8 ,  1, 16 , 31 ,  0,  12 ,  0 ,  -3 ,0
 1971 DATA ENDLAYER
 1972  REM  ----------R2.BASS    : @55
 1973 DATA BUILDLAYER
 1974 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1975 DATA FM, 1 , 1 ,  1 ,  1 ,  8 ,  0 , 30 , 18 ,  9, 12 , 22 , 46,  12 ,  0 ,  -3 ,0
 1976 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  0 , 24 , 16 ,  8, 12 , 22 , 102,  12 ,  0 ,  -3 ,0
 1977 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 28 ,  8 ,  6, 12 , 22 , 48,  12 ,  0 ,  -3 ,0
 1978 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 28 ,  8 ,  2, 16 , 16 ,  0,  12 ,  0 ,  -3 ,0
 1979 DATA ENDLAYER
 1980  REM  ----------metasynth  : @56
 1981 DATA BUILDLAYER
 1982 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1983 DATA FM, 1 , 1 ,  1 ,  1 ,  6 ,  0 , 26 ,  8 ,  0,  4 , 12 , 28,  48 ,  0 ,   0 ,0
 1984 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 24 ,  6 , 10, 12 , 14 ,  0,  36 ,  0 ,  -2 ,0
 1985 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 24 ,  7 ,  3,  8 ,  8 , 56,  36 ,  0 ,   3 ,0
 1986 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 24 ,  3 ,  6, 12 ,  0 ,  8,  24 ,  0 ,   0 ,0
 1987 DATA ENDLAYER
 1988  REM  ----------SP BASS    : @57
 1989 DATA BUILDLAYER
 1990 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1991 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 28 , 16 ,  8, 18 , 31 , 80,  62 ,  0 ,   8 ,0
 1992 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 24 , 12 ,  6, 12 , 10 , 42,  12 ,  0 ,  -3 ,0
 1993 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 26 ,  2 ,  6, 12 ,  0 , 40,  12 ,  0 ,  -1 ,0
 1994 DATA FM, 4 , 1 ,  3 ,  1 , 12 ,  7 , 24 ,  9 ,  3, 12 ,  0 ,  0,  12 ,  0 ,  -2 ,0
 1995 DATA ENDLAYER
 1996  REM  ----------RVmarnba   : @58
 1997 DATA BUILDLAYER
 1998 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 1999 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 25 , 23 , 10,  4 , 28 , 44,  55 ,  0 ,   5 ,0
 2000 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 25 , 14 , 11, 10 , 31 ,  0,  36 ,  0 ,   0 ,0
 2001 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 25 , 20 , 11,  4 , 28 , 30,  58 ,  0 , -80 ,0
 2002 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 25 , 14 , 12, 10 , 31 ,  0,  24 ,  0 ,   0 ,0
 2003 DATA ENDLAYER
 2004  REM  ----------SP LEAD    : @59
 2005 DATA BUILDLAYER
 2006 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2007 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 ,  7 , 12 ,  0, 10 ,  0 , 90,  12 ,  0 ,   0 ,0
 2008 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 16 , 18 , 15,  8 ,  0 , 106,  43 ,  0 ,   7 ,0
 2009 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 24 ,  4 , 13,  0 ,  0 , 16,  24 ,  0 ,   0 ,0
 2010 DATA FM, 4 , 1 ,  3 ,  1 , 12 ,  7 , 24 ,  0 , 13, 12 ,  8 ,  0,  36 ,  0 ,   1 ,0
 2011 DATA ENDLAYER
 2012  REM  ----------LowAtStrng : @60
 2013 DATA BUILDLAYER
 2014 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2015 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 16 ,  6 ,  2,  8 ,  0 , 46,  36 ,  0 ,   0 ,0
 2016 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 13 ,  9 ,  0, 12 ,  2 ,  0,  36 ,  0 ,  -3 ,0
 2017 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 17 ,  6 ,  2,  4 ,  0 , 34,  36 ,  0 ,   0 ,0
 2018 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 11 ,  0 ,  0, 12 ,  8 ,  0,  36 ,  0 ,  -3 ,0
 2019 DATA ENDLAYER
 2020  REM  ----------STICKBS    : @61
 2021 DATA BUILDLAYER
 2022 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2023 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 30 ,  8 ,  0, 12 ,  0 , 80,  60 ,  0 ,   3 ,0
 2024 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  0 , 31 , 12 ,  0, 12 ,  0 , 86,  36 ,  0 ,   0 ,0
 2025 DATA FM, 3 , 1 ,  3 ,  2 ,  0 ,  0 , 18 , 10 ,  1, 12 ,  0 , 24,  24 ,  0 ,  -3 ,0
 2026 DATA FM, 4 , 1 ,  2 ,  3 , 12 ,  7 , 31 ,  2 ,  5, 14 ,  4 ,  0,  24 ,  0 ,   0 ,0
 2027 DATA ENDLAYER
 2028  REM  ----------space1     : @62
 2029 DATA BUILDLAYER
 2030 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2031 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 12 , 12 ,  0, 10 ,  0 , 30,  48 ,  0 ,   0 ,0
 2032 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 16 , 18 , 15,  8 ,  0 , 34,  48 ,  0 ,   2 ,0
 2033 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 24 ,  4 , 12,  0 ,  0 , 10,  36 ,  0 ,   0 ,0
 2034 DATA FM, 4 , 1 ,  3 ,  1 , 12 ,  7 , 24 ,  0 , 13, 12 ,  8 ,  0,  48 ,  0 ,   1 ,0
 2035 DATA ENDLAYER
 2036  REM  ----------SP SNAREo2 : @63
 2037 DATA BUILDLAYER
 2038 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2039 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 ,  0 ,  0, 14 ,  0 ,  0,  64 ,  0 , -35 ,0
 2040 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 31 , 21 , 16, 14 ,  4 ,  0,  64 ,  0 , -35 ,0
 2041 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 31 , 21 ,  0, 31 , 22 ,  0,  48 ,  0 ,   1 ,0
 2042 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 31 , 19 , 17, 18 ,  4 ,  0,  12 ,  0 ,  -3 ,0
 2043 DATA ENDLAYER
 2044  REM  ----------GYO BASS   : @64
 2045 DATA BUILDLAYER
 2046 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2047 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 , 15 ,  3, 18 , 18 , 66,  24 ,  0 ,   0 ,0
 2048 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 31 , 15 ,  7, 18 , 12 , 68,  24 ,  0 ,   0 ,0
 2049 DATA FM, 3 , 1 ,  1 ,  2 , 12 ,  0 , 31 ,  9 ,  7, 18 , 12 , 20,  12 ,  0 ,  -3 ,0
 2050 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 31 ,  6 , 11, 12 ,  8 ,  0,  12 ,  0 ,   0 ,0
 2051 DATA ENDLAYER
 2052  REM  ----------GrandPiano : @65
 2053 DATA BUILDLAYER
 2054 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2055 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 ,  0 ,  7,  0 ,  8 , 64,  36 ,  0 ,   2 ,0
 2056 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 22 ,  7 ,  3, 14 ,  6 ,  0,  36 ,  0 ,   0 ,0
 2057 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 31 ,  0 ,  7,  0 ,  8 , 56,  55 ,  0 ,   2 ,0
 2058 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 22 ,  7 ,  3, 14 ,  6 ,  0,  36 ,  0 ,   1 ,0
 2059 DATA ENDLAYER
 2060  REM  ----------E.organ1   : @66
 2061 DATA BUILDLAYER
 2062 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2063 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 ,  0 ,  0, 20 ,  0 , 66,  48 ,  0 ,   0 ,0
 2064 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 31 ,  0 ,  0, 20 ,  0 ,  0,  48 ,  0 ,   0 ,0
 2065 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  7 , 31 ,  0 ,  0, 20 ,  0 ,  0,  36 ,  0 ,   0 ,0
 2066 DATA FM, 4 , 1 ,  4 ,  4 ,  0 ,  7 , 31 ,  0 ,  0, 20 ,  0 ,  0,  24 ,  0 ,   0 ,0
 2067 DATA ENDLAYER
 2068  REM  ----------SP LEAD    : @67
 2069 DATA BUILDLAYER
 2070 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2071 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 ,  8 ,  0 ,  0,  6 ,  0 , 56,  24 ,  0 ,  -3 ,0
 2072 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 16 , 16 , 15,  8 ,  0 , 54,  48 ,  0 ,   2 ,0
 2073 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 24 ,  4 , 13,  0 ,  0 , 16,  36 ,  0 ,   0 ,0
 2074 DATA FM, 4 , 1 ,  3 ,  1 , 12 ,  7 , 24 ,  0 , 13, 12 ,  8 ,  0,  48 ,  0 ,   1 ,0
 2075 DATA ENDLAYER
 2076  REM  ----------LowAtStrng : @68
 2077 DATA BUILDLAYER
 2078 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2079 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 16 ,  6 ,  2,  8 ,  0 , 56,  36 ,  0 ,   0 ,0
 2080 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 16 ,  9 ,  0, 12 ,  2 ,  0,  36 ,  0 ,  -3 ,0
 2081 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 17 ,  6 ,  2,  4 ,  0 , 34,  36 ,  0 ,   0 ,0
 2082 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 16 ,  0 ,  0, 12 ,  8 ,  0,  36 ,  0 ,  -3 ,0
 2083 DATA ENDLAYER
 2084  REM  ----------RVmarnba   : @69
 2085 DATA BUILDLAYER
 2086 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2087 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 25 , 23 , 10,  4 , 28 , 44,  55 ,  0 ,   5 ,0
 2088 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 25 , 10 , 11,  8 , 31 ,  0,  36 ,  0 ,   0 ,0
 2089 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 25 , 20 , 11,  4 , 28 , 30,  58 ,  0 , -80 ,0
 2090 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 25 , 10 , 12,  8 , 31 ,  0,  24 ,  0 ,   0 ,0
 2091 DATA ENDLAYER
 2092  REM  ----------ｼﾀｰﾙ       : @70
 2093 DATA BUILDLAYER
 2094 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2095 DATA FM, 1 , 1 ,  1 ,  1 ,  3 ,  0 , 31 ,  7 ,  3,  4 , 14 , 56,  58 ,  0 , -77 ,0
 2096 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 ,  6 ,  8 ,  6, 10 , 12 , 92,  62 ,  0 ,   9 ,0
 2097 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 31 ,  2 ,  2,  4 ,  6 , 66,  24 ,  0 ,   0 ,0
 2098 DATA FM, 4 , 1 ,  3 ,  1 , 12 ,  7 , 31 , 10 ,  8, 16 ,  8 ,  0,  24 ,  0 ,   0 ,0
 2099 DATA ENDLAYER
 2100  REM  ----------Echo synth : @71
 2101 DATA BUILDLAYER
 2102 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2103 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 ,  9 , 15,  0 ,  6 , 46,  36 ,  0 ,  -3 ,0
 2104 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 31 ,  9 ,  8, 10 , 12 ,  0,  43 ,  0 ,   5 ,0
 2105 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 31 ,  9 , 15,  0 ,  6 , 42,  24 ,  0 ,   3 ,0
 2106 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 31 ,  9 ,  8, 10 , 12 ,  4,  36 ,  0 ,   0 ,0
 2107 DATA ENDLAYER
 2108  REM  ----------SOLO       : @72
 2109 DATA BUILDLAYER
 2110 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2111 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 20 ,  4 ,  6, 12 ,  4 , 64,  48 ,  0 ,  -3 ,0
 2112 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 15 ,  5 ,  6, 12 , 10 ,  0,  36 ,  0 ,   2 ,0
 2113 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 18 ,  4 ,  5, 10 , 10 , 34,  36 ,  0 ,   0 ,0
 2114 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 17 ,  5 ,  6, 12 , 10 ,  0,  24 ,  0 ,   0 ,0
 2115 DATA ENDLAYER
 2116  REM  ----------space1     : @73
 2117 DATA BUILDLAYER
 2118 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2119 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 12 , 12 ,  0, 10 ,  0 , 42,  48 ,  0 ,   0 ,0
 2120 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 16 , 18 , 15,  8 ,  0 , 42,  48 ,  0 ,   2 ,0
 2121 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 24 ,  4 , 12,  0 ,  0 , 26,  36 ,  0 ,   0 ,0
 2122 DATA FM, 4 , 1 ,  3 ,  1 , 12 ,  7 , 24 ,  0 , 13, 12 ,  8 ,  0,  48 ,  0 ,   1 ,0
 2123 DATA ENDLAYER
 2124  REM  ----------ﾋﾞﾌﾞﾗﾌｫﾝ3  : @74
 2125 DATA BUILDLAYER
 2126 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2127 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 , 10 ,  7, 10 , 20 , 60,  64 ,  0 , -38 ,0
 2128 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 31 , 13 ,  0, 14 , 10 ,  0,  36 ,  0 ,   3 ,0
 2129 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  7 , 25 ,  6 ,  2, 10 , 10 ,  0,  24 ,  0 ,  -1 ,0
 2130 DATA FM, 4 , 1 ,  4 ,  4 ,  0 ,  7 , 28 , 10 ,  2, 10 , 10 ,  0,  24 ,  0 ,   1 ,0
 2131 DATA ENDLAYER
 2132  REM  ----------FANTASM    : @75
 2133 DATA BUILDLAYER
 2134 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2135 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 12 , 12 ,  0, 10 ,  0 , 56,  48 ,  0 ,   0 ,0
 2136 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 16 , 18 , 15,  8 ,  0 , 24,  48 ,  0 ,   2 ,0
 2137 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 24 ,  4 , 12,  0 ,  0 , 22,  36 ,  0 ,   0 ,0
 2138 DATA FM, 4 , 1 ,  3 ,  1 , 12 ,  7 , 24 ,  8 ,  6, 12 ,  8 ,  0,  48 ,  0 ,   1 ,0
 2139 DATA ENDLAYER
 2140  REM  ----------GOM BASS   : @76
 2141 DATA BUILDLAYER
 2142 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2143 DATA FM, 1 , 1 ,  1 ,  1 ,  5 ,  0 , 31 ,  9 ,  3, 18 , 10 , 34,  24 ,  0 ,   0 ,0
 2144 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 31 , 15 ,  7, 18 , 12 , 18,  24 ,  0 ,   0 ,0
 2145 DATA FM, 3 , 1 ,  1 ,  1 , 12 ,  7 , 31 ,  9 ,  7, 18 , 12 , 14,  12 ,  0 ,  -3 ,0
 2146 DATA FM, 4 , 1 ,  1 ,  1 , 12 ,  7 , 31 ,  6 , 11, 12 ,  8 ,  0,  12 ,  0 ,   0 ,0
 2147 DATA ENDLAYER
 2148  REM  ----------RV BRASS   : @77
 2149 DATA BUILDLAYER
 2150 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2151 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 14 , 14 ,  0,  6 ,  2 , 42,  24 ,  0 ,   3 ,0
 2152 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 14 ,  8 ,  0, 20 , 16 , 70,  58 ,  0 , -77 ,0
 2153 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 13 , 14 ,  0,  6 ,  2 , 60,  24 ,  0 ,   3 ,0
 2154 DATA FM, 4 , 1 ,  3 ,  1 , 12 ,  7 , 23 ,  3 ,  0, 12 ,  0 ,  0,  24 ,  0 ,   3 ,0
 2155 DATA ENDLAYER
 2156  REM  ----------SP SNAREo2 : @78
 2157 DATA BUILDLAYER
 2158 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2159 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 ,  0 ,  0,  4 ,  0 ,  0,  64 ,  0 , -35 ,0
 2160 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 31 , 21 , 16, 16 ,  4 ,  0,  64 ,  0 , -35 ,0
 2161 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 31 , 21 ,  0, 31 , 22 ,  0,  48 ,  0 ,   1 ,0
 2162 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 31 , 19 , 17, 18 ,  4 ,  0,  12 ,  0 ,  -3 ,0
 2163 DATA ENDLAYER
 2164  REM  ----------ﾏﾙﾁｽﾄﾘﾝｸﾞ2 : @79
 2165 DATA BUILDLAYER
 2166 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2167 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 25 ,  3 ,  0,  4 ,  4 , 58,  24 ,  0 ,  -2 ,0
 2168 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  0 , 25 ,  3 ,  0,  4 ,  4 , 56,  36 ,  0 ,   0 ,0
 2169 DATA FM, 3 , 1 ,  3 ,  2 ,  0 ,  0 , 25 ,  3 ,  0,  4 ,  4 , 68,  43 ,  0 ,   7 ,0
 2170 DATA FM, 4 , 1 ,  2 ,  3 , 12 ,  7 , 10 ,  5 ,  0, 14 ,  4 ,  0,  36 ,  0 ,   0 ,0
 2171 DATA ENDLAYER
 2172  REM  ----------ﾃﾞｨｽﾄｷﾞﾀｰ2 : @80
 2173 DATA BUILDLAYER
 2174 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2175 DATA FM, 1 , 1 ,  1 ,  1 ,  8 ,  0 , 31 ,  0 ,  0, 12 ,  0 , 52,  24 ,  0 ,   3 ,0
 2176 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 31 ,  0 ,  0, 12 ,  0 , 64,  24 ,  0 ,   3 ,0
 2177 DATA FM, 3 , 1 ,  1 ,  2 , 12 ,  0 , 31 ,  0 ,  0, 12 ,  0 , 36,  48 ,  0 ,  -1 ,0
 2178 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 31 ,  0 ,  0, 12 ,  0 ,  0,  24 ,  0 ,  -1 ,0
 2179 DATA ENDLAYER
 2180  REM  ----------metasynth  : @81
 2181 DATA BUILDLAYER
 2182 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2183 DATA FM, 1 , 1 ,  1 ,  1 ,  6 ,  0 , 26 ,  8 ,  0,  4 , 12 , 28,  48 ,  0 ,   0 ,0
 2184 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 24 ,  6 , 10, 12 , 14 ,  0,  36 ,  0 ,  -2 ,0
 2185 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 24 ,  7 ,  3,  8 ,  8 , 56,  36 ,  0 ,   3 ,0
 2186 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 24 ,  3 ,  6, 12 ,  0 ,  8,  24 ,  0 ,   0 ,0
 2187 DATA ENDLAYER
 2188  REM  ----------EXPLOSN    : @82
 2189 DATA BUILDLAYER
 2190 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2191 DATA FM, 1 , 1 ,  1 ,  1 ,  7 ,  0 , 29 ,  8 ,  0,  0 , 22 , 32,  52 ,  0 , -32 ,0
 2192 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 31 ,  8 ,  1,  4 , 24 , 18,  36 ,  0 ,   0 ,0
 2193 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 29 , 10 ,  1,  8 ,  4 , 36,  36 ,  0 ,   3 ,0
 2194 DATA FM, 4 , 1 ,  3 ,  1 , 12 ,  7 , 31 ,  7 ,  3,  8 ,  8 ,  0,  12 ,  0 ,  -3 ,0
 2195 DATA ENDLAYER
 2196  REM  ----------SP BASS    : @83
 2197 DATA BUILDLAYER
 2198 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2199 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 28 , 16 ,  8, 18 , 31 , 40,  64 ,  0 , -37 ,0
 2200 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 24 , 12 ,  6, 12 , 10 , 40,  24 ,  0 ,  -3 ,0
 2201 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 26 ,  2 ,  6, 12 ,  0 , 40,  24 ,  0 ,  -1 ,0
 2202 DATA FM, 4 , 1 ,  3 ,  1 , 12 ,  7 , 24 ,  9 ,  3, 12 ,  0 ,  0,  48 ,  0 ,  -2 ,0
 2203 DATA ENDLAYER
 2204  REM  ----------GYO BASS   : @84
 2205 DATA BUILDLAYER
 2206 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2207 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 , 15 ,  3, 12 , 18 , 66,  24 ,  0 ,   0 ,0
 2208 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 31 , 15 ,  7, 12 , 12 , 68,  12 ,  0 ,   0 ,0
 2209 DATA FM, 3 , 1 ,  1 ,  2 , 12 ,  0 , 31 ,  9 ,  7, 12 , 12 , 20,  12 ,  0 ,  -3 ,0
 2210 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 31 ,  6 , 11, 16 ,  8 ,  0,  24 ,  0 ,   0 ,0
 2211 DATA ENDLAYER
 2212  REM  ----------ﾌﾞﾗｽ1      : @85
 2213 DATA BUILDLAYER
 2214 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2215 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 13 , 14 ,  0,  6 ,  2 , 46,  24 ,  0 ,   3 ,0
 2216 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 13 , 14 ,  0, 20 , 31 , 80,  58 ,  0 , -77 ,0
 2217 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 14 , 14 ,  0,  6 ,  2 , 76,  24 ,  0 ,   3 ,0
 2218 DATA FM, 4 , 1 ,  3 ,  1 , 12 ,  7 , 19 ,  3 ,  0, 20 ,  0 ,  0,  24 ,  0 ,   3 ,0
 2219 DATA ENDLAYER
 2220  REM  ----------ﾃﾞｨｽﾄｷﾞﾀｰ1 : @86
 2221 DATA BUILDLAYER
 2222 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2223 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 16 , 14 ,  0,  6 ,  6 , 52,  43 ,  0 ,   3 ,0
 2224 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  0 , 19 ,  0 ,  0, 10 ,  0 , 50,  24 ,  0 ,   3 ,0
 2225 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 26 ,  0 ,  0,  6 ,  0 , 52,  24 ,  0 ,   3 ,0
 2226 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 27 ,  0 ,  0, 22 ,  0 ,  0,  24 ,  0 ,   3 ,0
 2227 DATA ENDLAYER
 2228  REM  ----------ｸﾞﾛｯｹﾝ     : @87
 2229 DATA BUILDLAYER
 2230 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2231 DATA FM, 1 , 1 ,  1 ,  1 ,  6 ,  0 , 31 , 14 ,  0, 31 , 31 , 66,  64 ,  0 , -32 ,0
 2232 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 30 ,  9 ,  7, 12 ,  2 , 16,  24 ,  0 ,   0 ,0
 2233 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 31 , 16 ,  5,  0 , 20 , 46,  58 ,  0 , -80 ,0
 2234 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 30 ,  7 ,  4, 14 ,  2 ,  0,  24 ,  0 ,  -3 ,0
 2235 DATA ENDLAYER
 2236  REM  ----------ﾁｭｰﾊﾞ      : @88
 2237 DATA BUILDLAYER
 2238 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2239 DATA FM, 1 , 1 ,  1 ,  1 ,  9 ,  0 , 15 , 10 ,  1, 10 , 12 , 42,  12 ,  0 ,   1 ,0
 2240 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 17 ,  2 ,  1, 16 ,  6 ,  0,  24 ,  0 ,   3 ,0
 2241 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  7 , 30 ,  2 , 18, 20 , 10 ,  0,  24 ,  0 ,  -3 ,0
 2242 DATA FM, 4 , 1 ,  4 ,  4 ,  0 ,  7 , 15 ,  2 ,  1, 20 , 10 ,  0,  12 ,  0 ,   3 ,0
 2243 DATA ENDLAYER
 2244  REM  ----------ｼﾝｾﾍﾞｰｽ1   : @89
 2245 DATA BUILDLAYER
 2246 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2247 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 , 18 ,  0, 12 ,  4 , 72,  64 ,  0 , -32 ,0
 2248 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  0 , 31 , 14 ,  4, 12 ,  4 , 90,  12 ,  0 ,   3 ,0
 2249 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 31 , 10 ,  4, 12 ,  4 , 36,  12 ,  0 ,   3 ,0
 2250 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 31 , 10 ,  3, 12 ,  4 ,  0,  12 ,  0 ,   3 ,0
 2251 DATA ENDLAYER
 2252  REM  ----------ｺｰﾗｽ1      : @90
 2253 DATA BUILDLAYER
 2254 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2255 DATA FM, 1 , 1 ,  1 ,  1 ,  8 ,  0 , 31 ,  0 ,  0,  0 ,  0 , 44,  36 ,  0 ,  -3 ,0
 2256 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 31 ,  0 ,  0, 12 ,  2 ,  0,  60 ,  0 ,  -3 ,0
 2257 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 31 ,  0 ,  0,  0 ,  0 , 46,  48 ,  0 ,   3 ,0
 2258 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 31 ,  0 ,  0, 12 ,  2 ,  0,  48 ,  0 ,   3 ,0
 2259 DATA ENDLAYER
 2260  REM  ----------ｼﾝｾｻｳﾝﾄﾞ18 : @91
 2261 DATA BUILDLAYER
 2262 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2263 DATA FM, 1 , 1 ,  1 ,  1 ,  3 ,  7 , 22 ,  0 ,  0, 10 ,  0 ,  0,  48 ,  0 ,   3 ,0
 2264 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  7 , 22 ,  0 ,  0, 10 ,  0 ,  0,  24 ,  0 ,   3 ,0
 2265 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  7 , 22 ,  0 ,  0, 10 ,  0 ,  0,  48 ,  0 ,  -1 ,0
 2266 DATA FM, 4 , 1 ,  4 ,  4 ,  0 ,  7 , 22 ,  0 ,  0, 10 ,  0 ,  0,  24 ,  0 ,  -1 ,0
 2267 DATA ENDLAYER
 2268  REM  ----------ﾀﾝﾊﾞﾘﾝ     : @92
 2269 DATA BUILDLAYER
 2270 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2271 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 , 17 , 24, 12 , 20 ,  0,  12 ,  0 ,   1 ,0
 2272 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 31 , 12 , 14, 31 ,  0 ,  4,  64 ,  0 , -38 ,0
 2273 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 31 , 31 , 31, 20 ,  0 ,  0,  12 ,  0 ,  -3 ,0
 2274 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 31 , 21 , 17, 31 , 31 ,  0,  55 ,  0 ,   8 ,0
 2275 DATA ENDLAYER
 2276  REM  ----------ﾃﾞｨｽﾄｷﾞﾀｰ2 : @93
 2277 DATA BUILDLAYER
 2278 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2279 DATA FM, 1 , 1 ,  1 ,  1 ,  8 ,  0 , 31 ,  0 ,  0, 12 ,  0 , 62,  24 ,  0 ,   3 ,0
 2280 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 31 ,  0 ,  0, 12 ,  0 , 64,  24 ,  0 ,   3 ,0
 2281 DATA FM, 3 , 1 ,  1 ,  2 , 12 ,  0 , 31 ,  0 ,  0, 12 ,  0 , 48,  48 ,  0 ,  -1 ,0
 2282 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 31 ,  0 ,  0, 12 ,  0 ,  0,  24 ,  0 ,  -1 ,0
 2283 DATA ENDLAYER
 2284  REM  ----------Hi.hat     : @94
 2285 DATA BUILDLAYER
 2286 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2287 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 , 31 ,  5, 10 ,  4 ,  0,  64 ,  0 , -34 ,0
 2288 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 31 , 19 , 31, 31 , 10 ,  0,  64 ,  0 , -38 ,0
 2289 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 31 ,  8 , 31, 31 , 20 ,  0,  64 ,  0 , -32 ,0
 2290 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 31 , 20 , 31, 31 , 16 ,  0,  64 ,  0 , -32 ,0
 2291 DATA ENDLAYER
 2292  REM  ----------Bass.DRM   : @95
 2293 DATA BUILDLAYER
 2294 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2295 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 , 21 , 21, 14 , 31 ,  0,  24 ,  0 ,   0 ,0
 2296 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 31 , 14 , 11, 16 , 31 ,  0,  24 ,  0 ,   0 ,0
 2297 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  7 , 31 , 15 , 23, 14 , 10 ,  0,  24 ,  0 ,   3 ,0
 2298 DATA FM, 4 , 1 ,  4 ,  4 ,  0 ,  7 , 31 , 15 , 10, 14 , 12 ,  0,  24 ,  0 ,  -2 ,0
 2299 DATA ENDLAYER
 2300  REM  ----------ｽﾈｱ1       : @96
 2301 DATA BUILDLAYER
 2302 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2303 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 ,  0 ,  0, 14 ,  0 ,  0,  64 ,  0 , -35 ,0
 2304 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 31 , 15 , 14, 18 ,  4 ,  0,  36 ,  0 ,   0 ,0
 2305 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 31 , 22 ,  2, 18 , 16 , 24,  12 ,  0 ,   2 ,0
 2306 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 31 , 15 , 17, 24 ,  4 ,  0,  12 ,  0 ,  -3 ,0
 2307 DATA ENDLAYER
 2308  REM  ----------ｼﾝｾﾀﾑ      : @97
 2309 DATA BUILDLAYER
 2310 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2311 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 , 13 ,  5, 10 ,  4 ,  0,  64 ,  0 , -37 ,0
 2312 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 31 , 17 , 10, 12 , 10 ,  0,  12 ,  0 ,   3 ,0
 2313 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  7 , 31 , 17 ,  4, 12 , 20 ,  0,  12 ,  0 ,   3 ,0
 2314 DATA FM, 4 , 1 ,  4 ,  4 ,  0 ,  7 , 31 , 12 ,  9, 14 , 16 ,  0,  12 ,  0 ,   3 ,0
 2315 DATA ENDLAYER
 2316  REM  ----------ｽﾈｱ1       : @98
 2317 DATA BUILDLAYER
 2318 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2319 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 ,  0 ,  0, 14 ,  0 ,  0,  64 ,  0 , -35 ,0
 2320 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 31 , 15 , 14, 18 ,  4 ,  0,  36 ,  0 ,   0 ,0
 2321 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 31 , 22 ,  2, 18 , 16 ,  0,  24 ,  0 ,   2 ,0
 2322 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 31 , 15 , 17, 24 ,  4 ,  0,  12 ,  0 ,  -3 ,0
 2323 DATA ENDLAYER
 2324  REM  ----------CHURCH BEL : @99
 2325 DATA BUILDLAYER
 2326 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2327 DATA FM, 1 , 1 ,  1 ,  1 ,  8 ,  0 , 31 , 10 ,  1, 10 , 24 , 60,  52 ,  0 , -38 ,0
 2328 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 29 ,  7 ,  3, 10 , 20 , 34,  36 ,  0 ,  -1 ,0
 2329 DATA FM, 3 , 1 ,  1 ,  1 , 12 ,  7 , 31 ,  7 ,  0,  6 ,  2 , 34,  12 ,  0 ,   2 ,0
 2330 DATA FM, 4 , 1 ,  1 ,  1 , 12 ,  7 , 30 ,  7 ,  3, 10 , 20 ,  0,  58 ,  0 , -80 ,0
 2331 DATA ENDLAYER
 2332  REM  ----------atc strng  : @100
 2333 DATA BUILDLAYER
 2334 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2335 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 18 , 15 ,  4,  8 ,  0 , 56,  48 ,  0 ,   0 ,0
 2336 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 15 ,  4 ,  1, 12 ,  0 ,  0,  48 ,  0 ,   0 ,0
 2337 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 18 , 12 ,  4,  8 ,  0 , 52,  36 ,  0 ,   3 ,0
 2338 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 15 ,  4 ,  1, 12 ,  0 ,  0,  36 ,  0 ,  -3 ,0
 2339 DATA ENDLAYER
 2340  REM  ----------HARP       : @101
 2341 DATA BUILDLAYER
 2342 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2343 DATA FM, 1 , 1 ,  1 ,  1 ,  8 ,  0 , 24 , 10 ,  0, 20 , 22 , 94,  43 ,  0 ,   3 ,0
 2344 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 24 , 19 , 10, 10 , 14 ,  0,  36 ,  0 ,   3 ,0
 2345 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 21 , 16 , 11,  8 , 31 , 74,  36 ,  0 ,  -3 ,0
 2346 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 21 ,  8 ,  9, 10 ,  4 ,  0,  24 ,  0 ,   0 ,0
 2347 DATA ENDLAYER
 2348  REM  ----------ｼﾝｾﾍﾞｰｽ1   : @102
 2349 DATA BUILDLAYER
 2350 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2351 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 , 18 ,  0, 12 ,  4 , 72,  64 ,  0 , -32 ,0
 2352 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  0 , 31 , 14 ,  4, 12 ,  4 , 90,  12 ,  0 ,   3 ,0
 2353 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 31 , 10 ,  4, 12 ,  4 , 36,  12 ,  0 ,   3 ,0
 2354 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 31 , 10 ,  3, 12 ,  4 ,  0,  12 ,  0 ,   3 ,0
 2355 DATA ENDLAYER
 2356  REM  ----------CHOPPER    : @103
 2357 DATA BUILDLAYER
 2358 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2359 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 , 23 , 12, 14 , 28 ,  6,  62 ,  0 ,  10 ,0
 2360 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 31 , 13 , 23, 14 , 24 , 74,  62 ,  0 ,   7 ,0
 2361 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 31 , 11 , 23, 14 , 26 , 40,  12 ,  0 ,  -3 ,0
 2362 DATA FM, 4 , 1 ,  3 ,  1 , 12 ,  7 , 31 ,  9 , 26, 18 , 26 ,  0,  24 ,  0 ,   0 ,0
 2363 DATA ENDLAYER
 2364  REM  ----------ﾅｷﾉｷﾞﾀｰｿﾛ  : @104
 2365 DATA BUILDLAYER
 2366 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2367 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 , 10 , 18, 10 ,  0 , 18,  64 ,  0 , -35 ,0
 2368 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  0 , 29 , 11 ,  0, 16 ,  8 , 34,  60 ,  0 ,   0 ,0
 2369 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 28 , 13 ,  0, 12 ,  2 , 58,  48 ,  0 ,   3 ,0
 2370 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 27 ,  4 ,  0, 12 ,  0 ,  0,  48 ,  0 ,   0 ,0
 2371 DATA ENDLAYER
 2372  REM  ----------ｼﾝｾｻｳﾝﾄﾞ8  : @105
 2373 DATA BUILDLAYER
 2374 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2375 DATA FM, 1 , 1 ,  1 ,  1 ,  8 ,  0 , 31 ,  0 ,  0,  0 ,  0 , 44,  24 ,  0 ,  -3 ,0
 2376 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 18 ,  5 ,  0, 14 , 10 ,  0,  48 ,  0 ,  -3 ,0
 2377 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 31 ,  0 ,  0,  0 ,  0 , 46,  36 ,  0 ,   3 ,0
 2378 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 18 ,  5 ,  0, 14 , 10 ,  0,  24 ,  0 ,   3 ,0
 2379 DATA ENDLAYER
 2380  REM  ----------ｼﾝｾｻｳﾝﾄﾞ18 : @106
 2381 DATA BUILDLAYER
 2382 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2383 DATA FM, 1 , 1 ,  1 ,  1 ,  3 ,  7 , 14 ,  0 ,  0, 10 ,  0 ,  0,  48 ,  0 ,   3 ,0
 2384 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  7 , 14 ,  0 ,  0, 10 ,  0 ,  0,  24 ,  0 ,   3 ,0
 2385 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  7 , 14 ,  0 ,  0, 10 ,  0 ,  0,  48 ,  0 ,  -1 ,0
 2386 DATA FM, 4 , 1 ,  4 ,  4 ,  0 ,  7 , 14 ,  0 ,  0, 10 ,  0 ,  0,  24 ,  0 ,  -1 ,0
 2387 DATA ENDLAYER
 2388  REM  ----------ﾃﾞｨｽﾄｷﾞﾀｰ2 : @107
 2389 DATA BUILDLAYER
 2390 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2391 DATA FM, 1 , 1 ,  1 ,  1 ,  8 ,  0 , 31 ,  0 ,  0, 12 ,  0 , 60,  36 ,  0 ,   1 ,0
 2392 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 31 ,  0 ,  0, 12 ,  0 , 66,  36 ,  0 ,   1 ,0
 2393 DATA FM, 3 , 1 ,  1 ,  2 , 12 ,  0 , 31 ,  0 ,  0, 12 ,  0 , 26,  60 ,  0 ,  -1 ,0
 2394 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 31 ,  0 ,  0, 12 ,  0 ,  0,  36 ,  0 ,  -1 ,0
 2395 DATA ENDLAYER
 2396  REM  ----------ﾌﾞﾗｽ1      : @108
 2397 DATA BUILDLAYER
 2398 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2399 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 13 , 14 ,  0,  6 ,  2 , 46,  24 ,  0 ,   3 ,0
 2400 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 13 , 14 ,  0, 20 , 31 , 80,  58 ,  0 , -77 ,0
 2401 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 14 , 14 ,  0,  6 ,  2 , 76,  24 ,  0 ,   3 ,0
 2402 DATA FM, 4 , 1 ,  3 ,  1 , 12 ,  7 , 19 ,  3 ,  0, 20 ,  0 ,  0,  24 ,  0 ,   3 ,0
 2403 DATA ENDLAYER
 2404  REM  ----------ﾃﾞｨｽﾄｷﾞﾀｰ1 : @109
 2405 DATA BUILDLAYER
 2406 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2407 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 16 , 14 ,  0,  6 ,  6 , 52,  43 ,  0 ,   3 ,0
 2408 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  0 , 19 ,  0 ,  0, 10 ,  0 , 50,  24 ,  0 ,   3 ,0
 2409 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 26 ,  0 ,  0,  6 ,  0 , 52,  24 ,  0 ,   3 ,0
 2410 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 27 ,  0 ,  0, 22 ,  0 ,  0,  24 ,  0 ,   3 ,0
 2411 DATA ENDLAYER
 2412  REM  ----------ｼﾝﾊﾞﾙ      : @110
 2413 DATA BUILDLAYER
 2414 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2415 DATA FM, 1 , 1 ,  1 ,  1 ,  9 ,  0 , 31 ,  0 ,  0,  0 ,  0 , 14,  64 ,  0 , -38 ,0
 2416 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 31 , 25 , 10, 12 ,  6 ,  0,  64 ,  0 , -38 ,0
 2417 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 31 , 25 ,  0,  4 ,  0 , 16,  64 ,  0 , -35 ,0
 2418 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 31 , 25 , 12, 16 , 10 ,  0,  64 ,  0 , -35 ,0
 2419 DATA ENDLAYER
 2420  REM  ----------ｴﾚｷｵﾙｶﾞﾝ3  : @111
 2421 DATA BUILDLAYER
 2422 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2423 DATA FM, 1 , 1 ,  1 ,  1 ,  6 ,  7 , 28 , 18 ,  0, 31 , 31 ,  2,  55 ,  0 ,   3 ,0
 2424 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  7 , 24 , 15 ,  0, 31 ,  0 ,  4,  24 ,  0 ,   3 ,0
 2425 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  7 , 31 , 15 ,  0, 31 ,  0 ,  0,  43 ,  0 ,   4 ,0
 2426 DATA FM, 4 , 1 ,  4 ,  4 ,  0 ,  7 , 31 , 15 ,  0, 31 ,  0 ,  0,  36 ,  0 ,   3 ,0
 2427 DATA ENDLAYER
 2428  REM  ----------ﾅｷﾉｷﾞﾀｰｿﾛ  : @112
 2429 DATA BUILDLAYER
 2430 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2431 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 ,  9 , 20, 10 ,  0 , 10,  64 ,  0 , -35 ,0
 2432 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  0 , 29 , 11 ,  0, 16 ,  8 , 34,  60 ,  0 ,   0 ,0
 2433 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 28 , 13 ,  0, 12 ,  2 , 58,  48 ,  0 ,   3 ,0
 2434 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 27 ,  4 ,  0, 12 ,  0 ,  0,  48 ,  0 ,   0 ,0
 2435 DATA ENDLAYER
 2436  REM  ----------ALARM      : @113
 2437 DATA BUILDLAYER
 2438 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2439 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 13 ,  6 ,  2, 16 ,  2 , 58,  36 ,  0 ,   3 ,0
 2440 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 15 ,  8 ,  0, 16 ,  2 , 64,  36 ,  0 ,  -1 ,0
 2441 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 10 ,  7 ,  0,  0 , 12 , 84,  64 ,  0 , -32 ,0
 2442 DATA FM, 4 , 1 ,  3 ,  1 , 12 ,  7 , 19 ,  0 ,  0, 16 ,  4 ,  0,  36 ,  0 ,   0 ,0
 2443 DATA ENDLAYER
 2444  REM  ----------ﾄﾗﾝﾍﾟｯﾄ1   : @114
 2445 DATA BUILDLAYER
 2446 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2447 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 13 ,  6 ,  2, 16 ,  2 , 50,  36 ,  0 ,   3 ,0
 2448 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 15 ,  8 ,  0, 16 ,  2 , 64,  55 ,  0 ,   4 ,0
 2449 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 21 ,  7 ,  0, 16 ,  4 , 84,  36 ,  0 ,   3 ,0
 2450 DATA FM, 4 , 1 ,  3 ,  1 , 12 ,  7 , 18 ,  4 ,  0, 16 ,  4 ,  0,  36 ,  0 ,   0 ,0
 2451 DATA ENDLAYER
 2452  REM  ----------ﾍﾞﾙ4       : @115
 2453 DATA BUILDLAYER
 2454 REM    ,OP , WF,  X ,  Y ,  M , SL , AT , DT , ST, RR , SL , TL,  ML , ML2,  DT ,SC
 2455 DATA FM, 1 , 1 ,  1 ,  1 ,  9 ,  0 , 27 ,  4 ,  0, 12 , 31 , 70,  43 ,  0 ,   8 ,0
 2456 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 31 ,  7 ,  0, 14 , 31 ,  0,  24 ,  0 ,   0 ,0
 2457 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 31 ,  7 ,  0,  8 , 28 , 82,  64 ,  0 , -38 ,0
 2458 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 31 ,  8 ,  0, 14 , 31 ,  6,  48 ,  0 ,  -3 ,0
 2459 DATA ENDLAYER
 2460 REM @116
 2461 REM DATA "STANDARD",31
 2462 DATA "BUILDLAYER"              :' (116)[Drum Set]
 2463 DATA "STANDARD",31,00,-1,-1, -1:'        kick
 2464 DATA            31,01,-1,-1, -1:'        Snere
 2465 DATA            31,02,-1,-1, -1:'        Electric Snere
 2466 DATA            31,03,-1,-1, -1:'        close H H
 2467 DATA            31,04,-1,-1, -1:'        open H H
 2468 DATA            31,05,-1,-1, -1:'        Low Tom
 2469 DATA            31,06,-1,-1, -1:'        Mid Tom
 2470 DATA            31,07,-1,-1, -1:'        High Tom
 2471 DATA "ROCK",    31,07,-1,-1, -1:'        clash Cymbal 1
 2472 DATA "STANDARD",31,09,-1,-1, -1:'        Ride Cymbal
 2473 DATA "ROCK",    31,08,52,72, -1:'        clash Cymbal 2
 2474 DATA "ENDLAYER"
 2475 REM @117 --perc
 2476 DATA "STANDARD",32
 2477 REM @118 --OcheHit
 2478 DATA "EXTRA1",3
 2479 REM @119 --Hah
 2480 DATA "STANDARD",9
 2481 REM @120 --Hua
 2482 DATA "STANDARD",2
 2483 DATA endarrange
 2484 '
 2485 '###############################
 2486 '      ENDING TONE DATA
 2487 '###############################
 2488 *MAEND
 2489 REM  --@"SOLO"  1--------
 2490 DATA BUILDLAYER
 2491 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 ,  9 , 20, 10 ,  0 , 10,  64 , 0,-35,0
 2492 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  0 , 29 , 11 ,  0, 16 ,  8 , 34,  60 , 0, 0,0
 2493 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 28 , 13 ,  0, 12 ,  2 , 58,  48 , 0, 3,0
 2494 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 27 ,  4 ,  0, 12 ,  0 ,  0,  48 , 0, 0,0
 2495 DATA ENDLAYER
 2496 REM  --@"SYNTH"  2--------
 2497 DATA BUILDLAYER
 2498 DATA FM, 1 , 1 ,  1 ,  1 ,  3 ,  7 , 22 ,  0 ,  0, 10 ,  0 , 26,  48 , 0, 3,0
 2499 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  7 , 22 ,  0 ,  0, 10 ,  0 , 26,  24 , 0, 3,0
 2500 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  7 , 22 ,  0 ,  0, 10 ,  0 , 26,  48 , 0,-1,0
 2501 DATA FM, 4 , 1 ,  4 ,  4 ,  0 ,  7 , 22 ,  0 ,  0, 10 ,  0 , 20,  24 , 0,-1,0
 2502 DATA ENDLAYER
 2503 REM ---@"ELEPI"  3
 2504 DATA STANDARD, 36
 2505 REM  --@"HARP"   4--------HARP
 2506 DATA BUILDLAYER
 2507 DATA FM, 1 , 1 ,  1 ,  1 ,  8 ,  0 , 24 , 16 ,  0, 20 , 22 , 94,  43 , 0, 3,0
 2508 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 24 , 19 , 10, 10 , 14 , 24,  36 , 0, 3,0
 2509 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 21 , 16 , 11,  8 , 31 , 74,  36 , 0,-3,0
 2510 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 21 ,  8 ,  9, 10 ,  4 ,  8,  24 , 0, 0,0
 2511 DATA ENDLAYER
 2512 REM  --@"BELL"  5--------
 2513 DATA BUILDLAYER
 2514 DATA FM, 1 , 1 ,  1 ,  1 ,  9 ,  0 , 27 ,  4 ,  0, 12 , 31 , 70,  43 , 0, 8,0
 2515 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 31 ,  7 ,  0, 14 , 31 ,  0,  24 , 0, 0,0
 2516 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 31 ,  7 ,  0,  8 , 28 , 82,  64 , 0,-38,0
 2517 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 31 ,  8 ,  0, 14 , 31 ,  6,  48 , 0,-3,0
 2518 DATA ENDLAYER
 2519 REM  --@"ORGAN"  6--------
 2520 DATA BUILDLAYER
 2521 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 31 ,  0 ,  0, 20 ,  0 , 66,  48 , 0, 0,0
 2522 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 31 ,  0 ,  0, 20 ,  0 , 24,  48 , 0, 0,0
 2523 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  7 , 31 ,  0 ,  0, 20 ,  0 , 24,  36 , 0, 0,0
 2524 DATA FM, 4 , 1 ,  4 ,  4 ,  0 ,  7 , 31 ,  0 ,  0, 20 ,  0 , 24,  24 , 0, 0,0
 2525 DATA ENDLAYER
 2526  REM  --@"BASS"   7--------
 2527 DATA BUILDLAYER
 2528 DATA FM, 1 , 1 ,  1 ,  1 ,  7 ,  0 , 31 ,  7 ,  7, 18 ,  4 , 56,  55 , 0, 3,0
 2529 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  0 , 31 ,  6 ,  6, 18 ,  2 , 116,  52 , 0,-37,0
 2530 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 31 ,  9 ,  6, 18 ,  2 , 44,  12 , 0,-2,0
 2531 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 31 ,  6 ,  8, 18 , 31 ,  0,  24 , 0,-2,0
 2532 DATA ENDLAYER
 2533 REM  --@"STRING"   8--------atc strng
 2534 DATA BUILDLAYER
 2535 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 18 , 15 ,  4,  8 ,  0 , 56,  48 , 0, 0,0
 2536 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 15 ,  4 ,  1, 12 ,  0 , 18,  48 , 0, 0,0
 2537 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 18 , 12 ,  4,  8 ,  0 , 52,  36 , 0, 3,0
 2538 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 15 ,  4 ,  1, 12 ,  0 , 16,  36 , 0,-3,0
 2539 DATA ENDLAYER
 2540 REM  --@"CALIOPE"   9--------caliope
 2541 DATA BUILDLAYER
 2542 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 17 , 15 , 12,  8 ,  2 , 12,  48 , 0, 3,0
 2543 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  7 , 17 ,  8 ,  5, 16 ,  4 , 48,  36 , 0, 1,0
 2544 DATA FM, 3 , 1 ,  3 ,  3 ,  0 ,  0 , 15 , 15 ,  0, 12 , 31 , 98,  36 , 0, 3,0
 2545 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 28 , 31 ,  0, 16 ,  0 , 10,  36 , 0, 0,0
 2546 DATA ENDLAYER
 2547 REM  --@"DGUITER"   10--------
 2548 DATA BUILDLAYER
 2549 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 16 , 14 ,  0,  6 ,  6 , 52,  43 , 0, 3,0
 2550 DATA FM, 2 , 1 ,  1 ,  1 , 12 ,  0 , 19 ,  0 ,  0, 10 ,  0 , 50,  24 , 0, 3,0
 2551 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 26 ,  0 ,  0,  6 ,  0 , 52,  24 , 0, 3,0
 2552 DATA FM, 4 , 1 ,  3 ,  3 , 12 ,  7 , 27 ,  0 ,  0, 22 ,  0 ,  0,  24 , 0, 3,0
 2553 DATA ENDLAYER
 2554 REM  --@"RICODA"    11--------
 2555 DATA BUILDLAYER
 2556 DATA FM, 1 , 1 ,  1 ,  1 , 10 ,  0 , 20 , 20 ,  0, 20 , 10 , 68,  36 , 0, 3,0
 2557 DATA FM, 2 , 1 ,  2 ,  2 ,  0 ,  0 , 20 , 31 , 15, 31 ,  0 , 68,  24 , 0, 0,0
 2558 DATA FM, 3 , 1 ,  2 ,  2 , 12 ,  0 , 20 ,  0 ,  0,  6 ,  0 , 124,  48 , 0,-1,0
 2559 DATA FM, 4 , 1 ,  3 ,  1 , 12 ,  7 , 18 ,  8 ,  0, 20 ,  2 ,  0,  24 , 0, 3,0
 2560 DATA ENDLAYER
 2561 REM  --@drum       12
 2562 REM DATA STANDARD, 31
 2563 DATA "BUILDLAYER"              :' (12)[Drum Set]
 2564 DATA "STANDARD",31,00,-1,-1, -1:'        kick
 2565 DATA            31,01,-1,-1, -1:'        Snere
 2566 DATA            31,02,-1,-1, -1:'        Electric Snere
 2567 DATA            31,03,-1,-1, -1:'        close H H
 2568 DATA            31,04,-1,-1, -1:'        open H H
 2569 DATA            31,05,-1,-1, -1:'        Low Tom
 2570 DATA            31,06,-1,-1, -1:'        Mid Tom
 2571 DATA            31,07,-1,-1, -1:'        High Tom
 2572 DATA "ROCK",    31,07,-1,-1, -1:'        clash Cymbal 1
 2573 DATA "STANDARD",31,09,-1,-1, -1:'        Ride Cymbal
 2574 DATA "ROCK",    31,08,52,72, -1:'        clash Cymbal 2
 2575 DATA "ENDLAYER"
 2576 REM  --@perc       13
 2577 DATA ETHNIC, 10
 2578 REM ---clearguiter 14
 2579 DATA rock, 35
 2580 REM --strings      15
 2581 DATA orchest,35
 2582 DATA ENDARRANGE
 2583 '
 2584 '###############################
 2585 '      OPENING SONG DATA
 2586 '###############################
 2587 *MSOPEN
 2588 DATA \a=\(N46'8 N30'8) N30'8 (N46'4 N38'4) (N46'16 N30'16) N30'8 N30'16 (N46'4 N38'4)\
 2589 DATA \b=\(N46'8 N30'8) N30'8 (N46'4 N38'4) (N46'16 N30'16) N30'8 N30'16 (N46'4 N38'4)\
 2590 DATA \c=\L8(N46N30)N30(N38'16N46'16)N30 N30'16  N46'8. L16 N30 (N38N46) N30'8.\
 2591 DATA \d=\L16(N46'8N30'8)N30N30(N38'4N49'4) (N30'8N46'8) N30 N30 (N49'4N38'4)\
 2592 DATA \e=\(N49'8 N46'8 N30'8) N30 N30 (N38'4 N49'4) (N30'8 N46'8) N30 N30 (N49'4 N38'4)\
 2593 DATA \f=\(N46'8 N30'8) N30 N30 (N38'4 N49'4) (N30'8 N30'8N46'8) N30 N30 (N49'8 N38'8) N45'8\
 2594 DATA \g=\L16(N46'8 N30'8) N30 N30 (N38'4 N49'4) (N30'8 N46'8) N30 N30 (N45 N49 N38) N45 N49'8\
 2595 DATA \h=\L16(N30'8N49'8)N45N45'8N45'8N38'4N30'8N30'8N38\
 2596 DATA \i=\(N30'4N49'4)R16N38'8.L24N30P104N45N45N45N30P64N45N45N45N30P24N45N45N45P6 4\
 2597 DATA \j=\L16(N30'8N49'8)P104N45N45'8N45'8P24N45P64N38P104N45'8P64(N30'8N49'8)(N30'8N49'8)N38\
 2598 DATA --
 2599 DATA \k=\L16(N30'8 N38'8) P104 N45 N45'8 N45'8 P24 N45 P64 N38N38 N38N38 N38N38 N38N38\
 2600 DATA \l=\L16(N38N46N30)(N38N46N30)(N30N38)(N30N38)N49'4(N38N46N30)(N38N46N30)(N30 N38)(N30N38)N49'4\
 2601 DATA \m=\L16(N38N46N30)(N38N46N30)(N30N38)(N30N38)N49'4\
 2602 DATA \N=\(N46N30)(N45N30N46)(N45N30)(N45N30)(N45'32N49'32)N45'32N45N45\
 2603 DATA \o=\L16(N38N30N46)(N38N30N46)(N30N38)(N30N38)N49'4\
 2604 DATA \p=\L32(N45N46N30)N45L16(N45N30N46)(N45N30)(N45N30N38)(N45N49)N45N45N45\
 2605 DATA \q=\L16(N38N30)(N38N30)(N38N30)(N38N30)(N38N30)(N38N30)(N38N30)(N38N30)(N38' 8N30'8)R4R8\
 2606 DATA \r=\L8(N49N46N30)N30L16(N38N46)N38'8N38 N46'8. N30(N38N46)N30'8.\
 2607 DATA \s=\L8(N46N30)N30L16(N38N46)N38'8N38 N46'8. N30(N38N46)N30'8N49\
 2608 DATA --
 2609 DATA \t=\L8(N38N30N46)P104L16 N45N45(N46N49)N45'8L32N45N45\
 2610 DATA \u=\L16N45(N46N45)P64 L32N45N45  L16N45N45 P24L32 (N46N45)N45 L16N45N45\
 2611 DATA \Z=\<E16E16E16E16 {GA+>C+EGA}16 A+32B32 >{CC+D}16 D+32E32 <\
 2612 DATA \A= \L16@21N49'4N38'2N38'2N38'2 N38'8 P104 N41'8\
 2613 DATA \B= \R4 P64N38'2 N38'2 N38'2 P24 N48'16 N48'16 P64 N49'8\
 2614 DATA \C= \R4 N38'2 N38'2 N38'2 N38'4\
 2615 DATA \D= \L24@21N49'4  R16N38'8R16 @22O4CP24@21N48N48 N48P64@22O3A@21N45 N45N45@22O3F P104@21N41N41N41P64\
 2616 DATA \E= \L16 @21N49'8 P24N48N48'8N48'8P104N41 P64N38 P24N48'8P64N49'8N48'8N38\
 2617 DATA \F= \L16 @21N49'8 P24N48N48'8N48'8 P64N38'2 N38\
 2618 DATA \G= \L16 @21N38'8 P24N48N48'8N48'8 P104N41 P64N38N38N38N38N38N38N38N38\
 2619 DATA \H= \L16 @21N38N38N38N38N49'4N38N38N38N38N49'4\
 2620 DATA \I= \N38N38N38N38N49'4RP24N48N48N48P64N45'32N45'32N45P104N41N41P64\
 2621 DATA \J= \L16@21N38N38N38N38 N49'4 P24N48'32N48'32N48P64N45N45 N45N45P104N45N45 P64\
 2622 DATA \K= \N38N38N38N38N38N38N38N38 N38'2\
 2623 DATA --
 2624 DATA #0,T60@9P104O3V5L32 DD [2 DD16 D16D [2 DD DD16[2 D16D  DDD[2 D16D16D  [2 DDD[2 D16D16[2 D
 2625 DATA #1,@2O5P64V6D4 V7D4 V9D4 V11D4
 2626 DATA #2,@2O5P104V5A4 V7A4 V9A4 V11A4
 2627 DATA #3,@2O5P24V5G4 V7G4 V9G4 V11G4
 2628 DATA #4,P64@8V3O8L48E8[2ED+DC+C<B[2BBA+AG+G[2GGF+FFE[2ED+DC+C<B[2BBA+AG+G[2GF+FEE E[2ED+DDDD
 2629 DATA #5,@9P24O3V5L32DD[2 DD16 D16D[2 DD DD16[2 D16D DDD[2 D16D16D[2 DDD[2 D16D16[2 D
 2630 DATA #6,L16@21 R2R4 P64 N45'32 N45N45 N45'32 N45'32 N45'32
 2631 DATA #7,P64L8O5V15 @21 R2R4 P24N48'32 P64N45'16N45'16N45'32 P104N41'32N41'32 P64
 2632 DATA --
 2633 DATA #0,T126 L16 P64@9O3V11L16 E1& EEEE8E8E EEEE8E8E
 2634 DATA #1,R2R4R8P104@3O5V12E8& {FF+GG+AA+B>CC+DD+E}8E2&E8{D+DC+C<BA+AG+GF+FED+DC+C<BA+AG+GF+FE}4
 2635 DATA #2,P104@18V12O1D1P64R1
 2636 DATA #3,R2..P24@3O5V12E8 {FF+GG+AA+B>CC+DD+E}8E2&E8{D+DC+C<BA+AG+GF+FED+DC+C<BA+AG+GF+FE}4
 2637 DATA #4,P24@18V12O1D1P64R1
 2638 DATA #5,V13P64L8O3@19E@20B>D16<AB16D+A16@19ED@20B16L8O3@19E@20B>D16<AB16D+A16@19E D@20B16
 2639 DATA #6,\h \i
 2640 DATA #7,\F \D
 2641 DATA --
 2642 DATA #0,L16 E1& EEEE8E8E EEEE8E8E
 2643 DATA #1,E4&E4&E4E8 {FF+GG+AA+B>CC+DD+E}8{FF+GG+AA+B>CC+DD+E}8E8 ]2E4 P64@4V11[2O5 G8.F+8.{FEED+DD}8
 2644 DATA #2,R1R2P64@4V11[2O5 E8.{D+DD}16D8{C+CC}16<B16
 2645 DATA #3,E4&E4&E4E8 {FF+GG+AA+B>CC+DD+E}8 {FF+GG+AA+B>CC+DD+E}8 E8 ]2E4 P64]2E8 ]2E8 ]2E8 ]2E8
 2646 DATA #4,R1R1
 2647 DATA #5,L8O3@19E@20B>D16<AB16D+A16@19ED@20B16L8O3@19E@20B>D16<AB16G.A.B
 2648 DATA #6,\j \k
 2649 DATA #7,\E \G
 2650 DATA --
 2651 DATA #0,@13O4V11L16 R8 B>E GR <B>E G2 R8>C8.<B8. A8.G8.F+8
 2652 DATA #1,{C+CC}16C2&C8{DD+E FF+G G+AA}16.A16.B8  {BA+A G+GF+}16 F+4&F+8&F+16 {GG+A A+BB}8 A8G8F+8
 2653 DATA #2,L48A+A24&A2&A8L96A+B>CC+DD+EFF+F16.G8L96F+FE D+D48&D4..L48D+EFF+G24F+8E8D8
 2654 DATA #3,@2V10O6P104C1P24D1
 2655 DATA #4,@9V7O5L16P64C<AP104BGP64AF+P24GE>P64C<AP104BGP64AF+P24GE>P64C<AP104BGP64A F+P24GE>P64C<AP104BGP64AF+P24GE>
 2656 DATA #5,L8O4 CCC16>C<<B16>C16C16R16>C16<C>C<L8 DDD16>D<C+16D16D16R16>D16<D16D16D+8
 2657 DATA #6,L8(N46N49N30)N30'8L4(N46N38)L16(N46N30)N30'8N30(N46'4N38'4) \b
 2658 DATA #7,@21N49'4 N38'4 R4 N38'4 R4 N38'4 R4 N38'4
 2659 DATA --
 2660 DATA #0,R8 DF+ AR DF+ A2 @14V13O2P104 BB P64 EG P24 BB P64 R8 @13O5V11 B8.A8.GF+
 2661 DATA #1,G2 {G+AA+ B>CC+}16 D4D8D16{C+C<B}16 A16&A4.G8.F+8.{FEED+DD}8
 2662 DATA #2,L96C2C+DD+EFF+GG+AA+B48&B4.L48A+AG+GF+24&F+4.L48E8.D+D24&D8C+C24<B16
 2663 DATA #3,P104E1P24F+1
 2664 DATA #4,L16P64C<AP104BGP64AF+P24GE>P64C<AP104BGP64AF+P24GE>P64C<AP104BGP64AF+P24G E>P64C<AP104BGP64AF+P24GE>
 2665 DATA #5,L8O4 CCC16>C<<B16>C16C16R16>C16<C>C<L8 DDD16>D<C+16D16D16R16>D16<D16D16D+8
 2666 DATA #6,\a \b
 2667 DATA #7,R4 N38'4 R4 N38'4 R4 N38'4 R4 N38'4
 2668 DATA --
 2669 DATA #0,G2>D2 C4<B8 A4G4F+8
 2670 DATA #1,{C+CC}16 C4C8C16 {C+DD+EFF+GG+AA+BB}8 B4. A4G8F+4E4D8
 2671 DATA #2,L48A+A24&A4..L96B>CC+DD+EFF+G&G4.&G32F+4E8D4C4<A8
 2672 DATA #3,P104C1P24D1
 2673 DATA #4,L16P64C<AP104BGP64AF+P24GE>P64C<AP104BGP64AF+P24GE>P64C<AP104BGP64AF+P24G E>P64C<AP104BGP64AF+P24GE>
 2674 DATA #5,L8O4 CCC16>C<<B16>C16C16R16>C16<C>C<L8 DDD16>D<C+16D16D16R16>D16<D16D16D+8
 2675 DATA #6,\a L8(N46N30)N30L4(N46N38)L16(N46N30)N30'8N30(N46N45)N45N38'8
 2676 DATA #7,R4 N38'4 R4 N38'4 R4 N38'4 R4 N45'16 N45'16 N38'8
 2677 DATA --
 2678 DATA #0,G1R1
 2679 DATA #1,{D+EE}32 E2&E4&E8&E16&E32R1
 2680 DATA #2,L96AA+B&B2&B4&B8&B16&B32R1
 2681 DATA #3,@14V13O3L16 P104EE>P64EE<P24EE>P64EE<R2L16 P24EE>P64EE<P104EE>P64EE<R2
 2682 DATA #4,V11P64L16E<BAE>E<BAE>E<BAE>E<BAE>E<BAE>E<BAE>E<BAE>E<BAE>
 2683 DATA #5,L16O3 E8>E<E>D<E8>C8<E8F+AGF+DL16O3 E8>E<E>D<E8>C8<E8F+AGF+D
 2684 DATA #6,L8(N46N30N38)(N30N38)L16(N38N46)L8(N30N38)N30'16 N46'8. L16 N30(N38N46) N30'8. \c
 2685 DATA #7,L16 N38'8 N38'8 N38 N38'4.. N38'2 N38'2 N38'4
 2686 DATA --
 2687 DATA #0,R1R1
 2688 DATA #1,R1R2P64@4V11[2O5 G8.F+8.{FEED+DD}8
 2689 DATA #2,R1R2P64@4V11[2O5 E8.{D+DD}16D8{C+CC}16<B16
 2690 DATA #3,@14V13O3L16 P104EE>P64EE<P24EE>P64EE<R2L16 P24EE>P64EE<P104EE>P64EE<R2
 2691 DATA #4,L16E<BAE>E<BAE>E<BAE>E<BAE>E<BAE>E<BAE>E<BAEAGF+D
 2692 DATA #5,L16O3 E8>E<E>D<E8>C8<E8F+AGF+DL16O3 E8>E<E>D<E8>C8<E8F+AGAB
 2693 DATA #6,\r \s
 2694 DATA #7,N49'4 N38'2 N38'2 @22O4 E2 @21 N38'8. N49
 2695 DATA --
 2696 DATA #0,@13O4V11L16 R8 B>E GR <B>E G2 R8>C8.<B8. A8.G8.F+8
 2697 DATA #1,{C+CC}16 C2&C8 {DD+E FF+G G+AA}16. A16. B8 {BA+A G+GF+}16 F+4&F+8&F+16{GG+A A+BB}8 A8G8F+8
 2698 DATA #2,L48A+A24&A2&A8L96A+B>CC+DD+EFF+F16.G8L96F+FE D+D48&D4..L48D+EFF+G24F+8E8D8
 2699 DATA #3,@2V10O6P104C1P24D1
 2700 DATA #4,@9V7O5L16P64C<AP104BGP64AF+P24GE>P64C<AP104BGP64AF+P24GE>P64C<AP104BGP64A F+P24GE>P64C<AP104BGP64AF+P24GE>
 2701 DATA #5,L8O4 CCC16>C<<B16>C16C16R16>C16<C>C<L8 DDD16>D<C+16D16D16R16>D16<D16D16D+8
 2702 DATA #6,L8(N46N49N30)N30'8L4(N46N38)L16(N46N30)N30'8N30(N46'4N38'4)\b
 2703 DATA #7,@21N49'4 N38'4 R4N38'4 R4 N38'4 R4 N38'4
 2704 DATA --
 2705 DATA #0,R8 DF+ AR DF+ A2 @14V13O2P104 BB P64 EG P24 BB P64 R8 @13O5V11 B8.A8.GF+
 2706 DATA #1,G2 {G+AA+ B>CC+}16 D4D8D16{C+C<B}16 A16&A4.G8. F+8. {FEED+DD}8
 2707 DATA #2,L96C2C+DD+EFF+GG+AA+B48&B4.L48A+AG+GF+24&F+4.L48E8.D+D24&D8C+C24<B16
 2708 DATA #3,P104E1P24F+1
 2709 DATA #4,L16P64C<AP104BGP64AF+P24GE>P64C<AP104BGP64AF+P24GE>P64C<AP104BGP64AF+P24G E>P64C<AP104BGP64AF+P24GE>
 2710 DATA #5,L8O4 CCC16>C<<B16>C16C16R16>C16<C>C<L8 DDD16>D<C+16D16D16R16>D16<D16D16D+8
 2711 DATA #6,\a\b
 2712 DATA #7,R4 N38'4 R4 N38'4 R4 N38'4 R4 N38'4
 2713 DATA --
 2714 DATA #0,G2>D2 C4<B8 A4G4F+8
 2715 DATA #1,{C+CC}16 C4C8C16 {C+DD+EFF+GG+AA+BB}8 B4.A4G8F+4E4D8
 2716 DATA #2,L48A+A24&A4..L96B>CC+DD+EFF+G&G4.&G32F+4E8D4C4<A8
 2717 DATA #3,P104C1P24D1
 2718 DATA #4,L16P64C<AP104BGP64AF+P24GE>P64C<AP104BGP64AF+P24GE>P64C<AP104BGP64AF+P24G E>P64C<AP104BGP64AF+P24GE>
 2719 DATA #5,L8O4 CCC16>C<<B16>C16C16R16>C16<C>C<L8 DDD16>D<C+16D16D16R16>D16<D16D16D+8
 2720 DATA #6,\a L8(N46N30)N30L4(N46N38)L16(N46N30)N30'8N30(N46N45)N45N38'8
 2721 DATA #7,R4 N38'4 R4 N38'4 R4 N38'4 R4 N45'16 N45'16 N49'8
 2722 DATA --
 2723 DATA #0,G1 R2 L16 @2V10O5RDEF+GAB>D
 2724 DATA #1,{D+EE}32 E2&E4&E8&E16&E32R1
 2725 DATA #2,L96AA+B&B2&B4&B8&B16&B32R1
 2726 DATA #3,@14V13O3L16 P104EE>P64EE<P24EE>P64EE<R2L16 P24EE>P64EE<P104EE>P64EE<R2
 2727 DATA #4,V11P64L16 E<BAE>E<BAE>E<BAE>E<BAE> E<BAE>E<BAE P64R8@2V9O5RDEF+G A
 2728 DATA #5,L16O3 E8>E<E>D<E8>C8<E8F+AGF+DL16O3 E8>E<E>D<E8>C8<E8F+AGF+D
 2729 DATA #6,\c \c
 2730 DATA #7,@22O4E4 @21 N38'2 N38'2 N38'2 N38'4
 2731 DATA --
 2732 DATA #0,L16 E2&E8D4C8<B2&B8G4A8
 2733 DATA #1,P104@16V11O5E2&E8 {FF+G}32  G8.. F+8&F+8 F96E48E16. {D+DD}32 D2&D8..
 2734 DATA #2,P24@16V11O5C2&C8 {C+DD+}32 E8.. {D+DD}32 D16.&D8 {C+CC}32C16. <B 2.
 2735 DATA #3,@17V11O6L16P64BEP104CGP64ECP24GEP64GEP104CGP64ECP24GEP64AF+P104DAP64F+DP2 4AF+P64AF+P104DAP64F+DP24AF+
 2736 DATA #4,B>DL16 E2&E8D4C8<B2&B8G4
 2737 DATA #5,L16O3 A8 AA AA AA A8 AA AA AA L16 B8BBBBBBB8BBBBBB
 2738 DATA #6,\e\f
 2739 DATA #7,\A
 2740 DATA --
 2741 DATA #0,B1 R2R4R8 B>D
 2742 DATA #1,E2&E8 {FF+F+}32 G8.. G8 {G+AA}32 A8&A32 G+32G32F+2.
 2743 DATA #2,>C2&C8 {C+DD}32 D8.. {D+EE}32 E16.{FF+F+}32 F+8&F+32 F32 E32 {D+DD}32 D2&D8..
 2744 DATA #3,P64BGP104EBP64GEP24BGP64BGP104EBP64GEP24BGP64>C<AP104F+>C<P64AF+>P24C<A>P 64C<AP104F+>C<P64AF+>P24C<A
 2745 DATA #4,A8 B1 R2R4R8
 2746 DATA #5,L16O4 C8CCCCCCC8CCCCCC L16 D8DDDDDDD8DDDDDD
 2747 DATA #6,\d\g
 2748 DATA #7,\B
 2749 DATA --
 2750 DATA #0,E2&E8F+8G8F+8&F2&F8<B4A8
 2751 DATA #1,E2&E8 {FF+G}32 G8.. F+8F+8 {FEE}32 E16. {D+DD}32D4&D16. {C+C<B}32 B8.. {A+AA}32 A16.
 2752 DATA #2,{C+CC}32 C4&C8..&C8 {C+DD+}32 E8.. {D+DD}32D16.&D8 {C+CC}32 C16. <B4. {A+AG+}32 G8.. F+8
 2753 DATA #3,P64BEP104CGP64ECP24GEP64GEP104CGP64ECP24GEP64AF+P104DAP64F+DP24AF+P64AF+P 104DAP64F+DP24AF+
 2754 DATA #4,B>DE2&E8F+8G8F+8&F2&F8<B4
 2755 DATA #5,L16O3 A8AAAAAAA8AAAAAA L16 B8BBBBBBB8BBBBBB
 2756 DATA #6,\d\d
 2757 DATA #7,\C
 2758 DATA --
 2759 DATA #0,G1>E2.R8ED
 2760 DATA #1,{A+BB}32 B2&B4&B8&B16&B32&B1 >
 2761 DATA #2,G1&G1>
 2762 DATA #3,[2P104\Z ]2P64\Z[2P24\Z]2L16<P64EEP104EE>P64GF+P24ED
 2763 DATA #4,A8 G1>E2.R8
 2764 DATA #5,L16 EEEEE4EEEEE4 L16 EEEEE4E8E8AGF+D
 2765 DATA #6,\l\N\N
 2766 DATA #7,\H \I
 2767 DATA --
 2768 DATA #0,L16 E2&E8D4C8<B2&B8G4A8
 2769 DATA #1,E2&E8 {FF+G}32  G8.. F+8&F+8 F96E48E16. {D+DD}32 D2&D8..
 2770 DATA #2,C2&C8 {C+DD+}32 E8.. {D+DD}32 D16.&D8 {C+CC}32C16. <B2.
 2771 DATA #3,L16P64BEP104CGP64ECP24GEP64GEP104CGP64ECP24GEP64AF+P104DAP64F+DP24AF+P64A F+P104DAP64F+DP24AF+
 2772 DATA #4,EDE2&E8D4C8<B2&B8G4
 2773 DATA #5,L16O3 A8 AA AA AA A8 AA AA AA L16 B8BBBBBBB8BBBBBB
 2774 DATA #6,\e\f
 2775 DATA #7,\A
 2776 DATA --
 2777 DATA #0,B1 R2R4R8 B>D
 2778 DATA #1,E2&E8 {FF+F+}32 G8.. G8 {G+AA}32 A8&A32 G+32G32F+2.
 2779 DATA #2,>C2&C8 {C+DD}32 D8.. {D+EE}32 E16.{FF+F+}32 F+8&F+32 F32 E32 {D+DD}32 D2&D8..
 2780 DATA #3,P64BGP104EBP64GEP24BGP64BGP104EBP64GEP24BGP64>C<AP104F+>C<P64AF+>P24C<A>P 64C<AP104F+>C<P64AF+>P24C<A
 2781 DATA #4,A8 B1 R2R4R8
 2782 DATA #5,L16O4 C8CCCCCCC8CCCCCC L16 D8DDDDDDD8DDDDDD
 2783 DATA #6,\d\g
 2784 DATA #7,\B
 2785 DATA --
 2786 DATA #0,E2&E8F+8G8F+8&F2&F8<B4A8
 2787 DATA #1,E2&E8 {FF+G}32 G8.. F+8F+8 {FEE}32 E16. {D+DD}32D4&D16. {C+C<B}32 B8.. {A+AA}32 A16.
 2788 DATA #2,{C+CC}32 C4&C8..&C8 {C+DD+}32 E8.. {D+DD}32D16.&D8 {C+CC}32 C16. <B4. {A+AG+}32 G8.. F+8
 2789 DATA #3,P64BEP104CGP64ECP24GEP64GEP104CGP64ECP24GEP64AF+P104DAP64F+DP24AF+P64AF+P 104DAP64F+DP24AF+
 2790 DATA #4,B>DE2&E8F+8G8F+8&F2&F8<B4
 2791 DATA #5,L16O3 A8AAAAAAA8AAAAAA L16 B8BBBBBBB8BBBBBB
 2792 DATA #6,\d\d
 2793 DATA #7,\C
 2794 DATA --
 2795 DATA #0,L16 D+4 R<B >D+F+ D+F+ AA+ B4 @9O3V3 P64BB[2P104BB[2BB[2BB[2BB[2BB[2BB[2BB
 2796 DATA #1,{A+B>C C+DD+}16 D+2&D+4&D+8&D+16{EFF+}32 F+4&F+8&F+16&F+32  F+8 R4R8
 2797 DATA #2,F+1 {GG+A A+BB}16 B4.. B8 R4.
 2798 DATA #3,L16P64F+D+<P24B>F+P64D+<B>P104F+D+P64F+D+<P24B>F+P64D+<B>P104F+D+P64D+<B> P24F+<B>P64AD+P104A+D+P64B8R4.
 2799 DATA #4,A8L16 D+4 R<B> D+F+ D+F+ AA+ B4P24@9O3V5[2BB[2BB[2BB[2BB[2BB[2BB[2BB
 2800 DATA #5,L16 BB BB BB BB BB BB BA GF+ L16O4 D+<B>F+<B>ADA+DB8R4.
 2801 DATA #6,\o\p\q
 2802 DATA #7,\J \K
 2803 DATA --
 2804 DATA #0,L16 P64@9O3V11L16 E1& EEEE8E8E EEEE8E8E
 2805 DATA #1,R2R4R8 P104@3O5V12E8{FF+GG+AA+B>CC+DD+E}8E2&E8{D+DC+C<BA+AG+GF+FED+DC+C<BA+AG+GF+FE }4
 2806 DATA #2,P104@18V12O1D1P64R1
 2807 DATA #3,R2..P24@3O5V12L96E8  {FF+GG+AA+B>CC+DD+E}8E2&E8{D+DC+C<BA+AG+GF+FED+DC+C<BA+AG+GF+FE}4
 2808 DATA #4,P24@18V12O1D1P64R1
 2809 DATA #5,L8O3@19E@20B>D16<AB16D+A16@19ED@20B16L8O3@19E@20B>D16<AB16D+A16@19ED@20B1 6
 2810 DATA #6,\h \i
 2811 DATA #7,\F \D
 2812 DATA --
 2813 DATA #0,L16 E1&EEEE8E8E L16 @2V10O5RDEF+GAB>D
 2814 DATA #1,E4&E4&E4 E8 {FF+GG+AA+B>CC+DD+E}8{FF+GG+AA+B>CC+DD+E}8 E8  ]2E4  ]2E4 ]2E4
 2815 DATA #2,R1R2R2
 2816 DATA #3,E4&E4&E4 E8 {FF+GG+AA+B>CC+DD+E}8 {FF+GG+AA+B>CC+DD+E}8 E8 ]2E4 ]2E4 ]2E4
 2817 DATA #4,R1R2P64R8@2V9O5RDEF+GA
 2818 DATA #5,L8O3@19E@20B>D16<AB16D+A16@19ED@20B16L8O3@19E@20B>D16<AB16R16 L16E8F+AGF+D
 2819 DATA #6,\j \k
 2820 DATA #7,\E \G
 2821 DATA --
 2822 DATA #0,L16 E2&E8D4C8<B2&B8G4A8
 2823 DATA #1,P104@16V11O5E2&E8 {FF+G}32  G8.. F+8&F+8 F96E48E16. {D+DD}32 D2&D8..
 2824 DATA #2,P24@16V11O5C2&C8 {C+DD+}32 E8.. {D+DD}32 D16.&D8 {C+CC}32C16. <B 2.
 2825 DATA #3,@17V11O6L16P64BEP104CGP64ECP24GEP64GEP104CGP64ECP24GEP64AF+P104DAP64F+DP2 4AF+P64AF+P104DAP64F+DP24AF+
 2826 DATA #4,B>DE2&E8D4C8<B2&B8G4
 2827 DATA #5,L16O3 A8 AA AA AA A8 AA AA AA L16 B8BBBBBBB8BBBBBB
 2828 DATA #6,\e\f
 2829 DATA #7,\A
 2830 DATA --
 2831 DATA #0,B1 R2R4R8 B>D
 2832 DATA #1,E2&E8 {FF+F+}32 G8.. G8 {G+AA}32 A8&A32 G+32G32F+2.
 2833 DATA #2,>C2&C8 {C+DD}32 D8.. {D+EE}32 E16.{FF+F+}32 F+8&F+32 F32 E32 {D+DD}32 D2&D8..
 2834 DATA #3,P64BGP104EBP64GEP24BGP64BGP104EBP64GEP24BGP64>C<AP104F+>C<P64AF+>P24C<A>P 64C<AP104F+>C<P64AF+>P24C<A
 2835 DATA #4,A8 B1 R2R4R8
 2836 DATA #5,L16O4 C8CCCCCCC8CCCCCC L16 D8DDDDDDD8DDDDDD
 2837 DATA #6,\d\g
 2838 DATA #7,\B
 2839 DATA --
 2840 DATA #0,E2&E8F+8G8F+8&F2&F8<B4A8
 2841 DATA #1,E2&E8 {FF+G}32 G8.. F+8F+8 {FEE}32 E16. {D+DD}32D4&D16. {C+C<B}32 B8.. {A+AA}32 A16.
 2842 DATA #2,{C+CC}32 C4&C8..&C8 {C+DD+}32 E8.. {D+DD}32D16.&D8 {C+CC}32 C16. <B4. {A+AG+}32 G8.. F+8
 2843 DATA #3,P64BEP104CGP64ECP24GEP64GEP104CGP64ECP24GEP64AF+P104DAP64F+DP24AF+P64AF+P 104DAP64F+DP24AF+
 2844 DATA #4,B>DE2&E8F+8G8F+8&F2&F8<B4
 2845 DATA #5,L16O3 A8AAAAAAA8AAAAAA L16 B8BBBBBBB8BBBBBB
 2846 DATA #6,\d\d
 2847 DATA #7,\C
 2848 DATA --
 2849 DATA #0,G1>E2.R8ED
 2850 DATA #1,{A+BB}32 B2&B4&B8&B16&B32&B1>
 2851 DATA #2,G1G1>
 2852 DATA #3,[2P104\Z]2P64\Z[2P24\Z]2L16<P64EEP104EE>P64GF+P24ED
 2853 DATA #4,A8 G1>E2.R8
 2854 DATA #5,L16 EEEEE4EEEEE4 L16 EEEEE4E8E8AGF+D
 2855 DATA #6,\l\N\N
 2856 DATA #7,\H \I
 2857 DATA --
 2858 DATA #0,L16 E2&E8D4C8<B2&B8G4A8
 2859 DATA #1,E2&E8 {FF+G}32  G8.. F+8&F+8 F96E48E16. {D+DD}32 D2&D8..
 2860 DATA #2,C2&C8 {C+DD+}32 E8.. {D+DD}32 D16.&D8 {C+CC}32C16. <B2.
 2861 DATA #3,L16P64BEP104CGP64ECP24GEP64GEP104CGP64ECP24GEP64AF+P104DAP64F+DP24AF+P64A F+P104DAP64F+DP24AF+
 2862 DATA #4,EDE2&E8D4C8<B2&B8G4
 2863 DATA #5,L16O3 A8 AA AA AA A8 AA AA AA L16 B8BBBBBBB8BBBBBB
 2864 DATA #6,\e\f
 2865 DATA #7,\A
 2866 DATA --
 2867 DATA #0,B1 R2R4R8 B>D
 2868 DATA #1,E2&E8 {FF+F+}32 G8.. G8 {G+AA}32 A8&A32 G+32G32F+2.
 2869 DATA #2,>C2&C8 {C+DD}32 D8.. {D+EE}32 E16.{FF+F+}32 F+8&F+32 F32 E32 {D+DD}32 D2&D8..
 2870 DATA #3,P64BGP104EBP64GEP24BGP64BGP104EBP64GEP24BGP64>C<AP104F+>C<P64AF+>P24C<A>P 64C<AP104F+>C<P64AF+>P24C<A
 2871 DATA #4,A8 B1 R2R4R8
 2872 DATA #5,L16O4 C8CCCCCCC8CCCCCC L16 D8DDDDDDD8DDDDDD
 2873 DATA #6,\d\g
 2874 DATA #7,\B
 2875 DATA --
 2876 DATA #0,E2&E8F+8G8F+8&F2&F8<B4A8
 2877 DATA #1,E2&E8 {FF+G}32 G8.. F+8F+8 {FEE}32 E16. {D+DD}32D4&D16. {C+C<B}32 B8.. {A+AA}32 A16.
 2878 DATA #2,{C+CC}32 C4&C8..&C8 {C+DD+}32 E8.. {D+DD}32D16.&D8 {C+CC}32 C16. <B4. {A+AG+}32 G8.. F+8
 2879 DATA #3,P64BEP104CGP64ECP24GEP64GEP104CGP64ECP24GEP64AF+P104DAP64F+DP24AF+P64AF+P 104DAP64F+DP24AF+
 2880 DATA #4,B>DE2&E8F+8G8F+8&F2&F8<B4
 2881 DATA #5,L16O3 A8AAAAAAA8AAAAAA L16 B8BBBBBBB8BBBBBB
 2882 DATA #6,\d\d
 2883 DATA #7,\C
 2884 DATA --
 2885 DATA #0,L16 D+4 R<B >D+F+ D+F+ AA+ B4 @9O3V3 P64BB[2P104BB[2BB[2BB[2BB[2BB[2BB[2BB
 2886 DATA #1,{A+B>C C+DD+}16 D+2&D+4&D+8&D+16{EFF+}32 F+4&F+8&F+16&F+32  F+8 R4R8
 2887 DATA #2,F+1 {GG+A A+BB}16 B4.. B8 R4.
 2888 DATA #3,L16P64F+D+<P24B>F+P64D+<B>P104F+D+P64F+D+<P24B>F+P64D+<B>P104F+D+P64D+<B> P24F+<B>P64AD+P104A+D+P64B8R4.
 2889 DATA #4,A8L16 D+4 R<B> D+F+ D+F+ AA+ B4P24@9O3V5[2BB[2BB[2BB[2BB[2BB[2BB[2BB
 2890 DATA #5,L16 BB BB BB BB BB BB BA GF+ L16O4 D+<B>F+<B>ADA+DB8R4.
 2891 DATA #6,\o\p\q
 2892 DATA #7,\J \K
 2893 DATA --
 2894 DATA #0,P64@9O3V11L16 E1& EEEE8E8E EEEE8E8E
 2895 DATA #1,R2..P104@3O5V12L96E8{FF+GG+AA+B>CC+DD+E}8 E2&E8{D+DC+C<BA+AG+GF+FED+DC+C<BA+AG+GF+FE}4
 2896 DATA #2,P104@18V12O1D1R1
 2897 DATA #3,R2..P24@3O5V12E8  {FF+GG+AA+B>CC+DD+E}8E2&E8&{D+DC+C<BA+AG+GF+FED+DC+C<BA+AG+GF+FE}4
 2898 DATA #4,P24@18V12O1D1R1
 2899 DATA #5,L8O3@19E@20B>D16<AB16D+A16@19ED@20B16L8O3@19E@20B>D16<AB16D+A16@19ED@20B1 6
 2900 DATA #6,\h \i
 2901 DATA #7,@21N49'8P24N48'16N48'8N48'8P64N38'2R16 \D
 2902 DATA --
 2903 DATA #0,E1R1
 2904 DATA #1,E4&E4&E4&E4R1
 2905 DATA #2,R1R1
 2906 DATA #3,E4&E4&E4E4P64R1
 2907 DATA #4,R1R1
 2908 DATA #5,L8O3@19E@20B>D16<AB16D+A16@19ED@20B16R1
 2909 DATA #6,\j \t\u
 2910 DATA #7,\E L16N38'8 P24N48N48 P64N49 P24N48'8 N48'32N48'32 N48N48 P64N45'32N4'32 N45N45 N41'32N41'32 N41N41P64
 2911 DATA --
 2912 DATA #0,EEEEEEEER8R16
 2913 DATA #1,P64@4V11O5D16 {D+EE}32E32 {DC+C<BA+A}16 {A+BB}32 B32 {A+AA}32A32 {A+BB}32B32 >{CC+DD+EE}16 E16
 2914 DATA #2,P64@4V11O3E16{FF+G}32G32{AA+B}32B32>{CC+DD+EE}16{DC<A+G+F+E}16{FF+G}32G32 {F+FE}32E32E16R4P104@18V15O1D4&D1
 2915 DATA #3,L16V11DE<ABEG>EE
 2916 DATA #4,R2.V15P24D+4&D+2
 2917 DATA #5,L16O4 DE<ABEGEE
 2918 DATA #6,(N30N38)(N30N38)N38N38N38N38(N30N38)(N30N38)
 2919 DATA #7,N38N38N38N38N38N38N38N38 R4 N38'4
 2920 DATA ENDSONG
 2921 '
 2922 '###############################
 2923 '      STAGE 1 SONG DATA
 2924 '###############################
 2925 *MS1
 2926 '------DATA SET ------
 2927 DATA SONG 1
 2928 DATA #0,"T160@108V10P64O5L16"
 2929 DATA #1,"@108V11P100O4L16"
 2930 DATA #2,"@103V11P64O3L16"
 2931 DATA #3,"@108V11P28O4L16"
 2932 DATA #4,"@108V11P28O4L16"
 2933 DATA #5,"@108V11P100O4L16"
 2934 DATA #6,"@116V15P100O4L8"
 2935 DATA #7,"@116V15P64O4L16"
 2936 '
 2937 DATA -=> MACRO SET <=-
 2938 DATA "\A=\N36\"
 2939 DATA "\B=\N38\"
 2940 DATA "\C=\N42';112N42';107\"
 2941 DATA "\D=\N42';112\"
 2942 DATA "\E=\N41\"
 2943 DATA "\F=\N45\"
 2944 DATA "\G=\N48\"
 2945 DATA "\H=\L16 (N36 N38)(N36';112 N38)\"
 2946 DATA "\I=\L8 (N36N38N45)\"
 2947 DATA "\J=\L4 (N36N45)\"
 2948 DATA "\K=\N45 N45 N45'8\"
 2949 '
 2950 '------ TRACK SET ------
 2951 DATA -=> Bar 1-4 <=-
 2952 DATA #0,"R8|EEEEE&]1E[1G&]1G8.[1G&]1G8.[1G&]1G[1"
 2953 DATA #1,"R8|BBBBB&]1B[1>D&]1D8.[1D&]1D8.[1D&]1D[1<"
 2954 DATA #2,"R8|EEEEE8E4E4EE"
 2955 DATA #3,"R8|AAAAA&]1A[1G+&]1G+8.[1G+&]1G+8.[1G+&]1G+[1"
 2956 DATA #4,"R8|BBBBB&]1B[1>D&]1D8.[1D&]1D8.[1D&]1D[1<"
 2957 DATA #5,"R8|AAAAA&]1A[1G+&]1G+8.[1G+&]1G+8.[1G+&]1G+[1"
 2958 DATA #6,"R8|R1"
 2959 DATA #7,"R8|\H\H\I\J\J\H"
 2960 DATA -
 2961 DATA #0,"|EEEEE&]1E[1G&]1G8.[1G&]1G8.[1G&]1G[1"
 2962 DATA #1,"|BBBBB&]1B[1>D&]1D8.[1D&]1D8.[1D&]1D[1<"
 2963 DATA #2,"|EEEEE8E4E4EE"
 2964 DATA #3,"|AAAAA&]1A[1G+&]1G+8.[1G+&]1G+8.[1G+&]1G+[1"
 2965 DATA #4,"|BBBBB&]1B[1>D&]1D8.[1D&]1D8.[1D&]1D[1<"
 2966 DATA #5,"|AAAAA&]1A[1G+&]1G+8.[1G+&]1G+8.[1G+&]1G+[1"
 2967 DATA #6,"|R1"
 2968 DATA #7,"|\H\H\I\J\J\H"
 2969 DATA -
 2970 DATA #0,"|EEEEE&]1E[1G&]1G8.[1G&]1G8.[1G&]1G[1"
 2971 DATA #1,"|BBBBB&]1B[1>D&]1D8.[1D&]1D8.[1D&]1D[1<"
 2972 DATA #2,"|EEEEE8E4E4EE"
 2973 DATA #3,"|AAAAA&]1A[1G+&]1G+8.[1G+&]1G+8.[1G+&]1G+[1"
 2974 DATA #4,"|BBBBB&]1B[1>D&]1D8.[1D&]1D8.[1D&]1D[1<"
 2975 DATA #5,"|AAAAA&]1A[1G+&]1G+8.[1G+&]1G+8.[1G+&]1G+[1"
 2976 DATA #6,"|R1"
 2977 DATA #7,"|\H\H\I\J\J\H"
 2978 DATA -
 2979 DATA #0,"|EEEEE&]1E[1G&]1G8.[1A&]1A8.[1B&]1B[1"
 2980 DATA #1,"|BBBBB&]1B[1>D&]1D8.[1E&]1E8.[1G&]1G[1<"
 2981 DATA #2,"|EEEEE8E4E4EE"
 2982 DATA #3,"|AAAAA&]1A[1G+&]1G+8.[1G+&]1G+8.[1G+&]1G+[1"
 2983 DATA #4,"|BBBBB&]1B[1>D&]1D8.[1E&]1E8.[1G&]1G[1<"
 2984 DATA #5,"|AAAAA&]1A[1G+&]1G+8.[1G+&]1G+8.[1G+&]1G+[1"
 2985 DATA #6,"|R1"
 2986 DATA #7,"|\H\H\I\J\J\H"
 2987 '
 2988 DATA -=> Bar 5-8 <=-
 2989 DATA #0,"dc|@107O4V8 L8 AEA>C<BG>D<B"
 2990 DATA #1,"  |@107P100V8 O4L8 ECEAGDBG"
 2991 DATA #2,"  |@102V12L8 AA>C<AEAED8;;2/1"
 2992 DATA #3,"  |@101P64V9 O5L8 R8P100EA>P28CEP100C<AP28E"
 2993 DATA #4,"  |@107P28V8 O4L8 ECEAGDBG"
 2994 DATA #5,"  |@101P64V8 O5L8 R8EA>CEC<AE"
 2995 DATA #6,"  |\C\C\C\C"
 2996 DATA #7,"  |L8\AR\BR\A\A\B\A"
 2997 DATA -
 2998 DATA #0,"|>C<A4A4AB>C"
 2999 DATA #1,"|AF4F4FGA"
 3000 DATA #2,"|RFA_>D~38;64;240&DC<AF"
 3001 DATA #3,"|R8P100DFP28A>CP100<AFP28D"
 3002 DATA #4,"|AF4F4FGA"
 3003 DATA #5,"|R8DFA>C<AFD"
 3004 DATA #6,"|\C\C\C\C"
 3005 DATA #7,"|\AR\BR\A\A\B\A"
 3006 DATA -
 3007 DATA #0,"|<B4B4G>D<BA8;;2/1"
 3008 DATA #1,"|G4G4DGGE8;;2/1"
 3009 DATA #2,"|GGDGDBAG"
 3010 DATA #3,"|R8P100GBP28>DGP100D<BP28G"
 3011 DATA #4,"|G4G4DGGE8;;2/1"
 3012 DATA #5,"|R8GB>DGD<BG"
 3013 DATA #6,"|\C\C\C\C"
 3014 DATA #7,"|\AR\BR\A\A\B\A"
 3015 DATA -
 3016 DATA #0,"|RB>CDECEA<"
 3017 DATA #1,"|RGAB>C<A>CE<"
 3018 DATA #2,"|AEA_>E4~32;64;240EEE<"
 3019 DATA #3,"|R8P100EAP28>CEP100C<AP28E"
 3020 DATA #4,"|RGAB>C<A>CE<"
 3021 DATA #5,"|R8EA>CEC<AE"
 3022 DATA #6,"|\C\C\C\C"
 3023 DATA #7,"|\AR\BR\A\A\B\A"
 3024 '
 3025 DATA -=> Bar 9-12 <=-
 3026 DATA #0,"|AEA>C<BG>D<B"
 3027 DATA #1,"|ECEAGDBG"
 3028 DATA #2,"|AA>C<AEAED8;;2/1"
 3029 DATA #3,"|R8P100EA>P28CEP100C<AP28E"
 3030 DATA #4,"|ECEAGDBG"
 3031 DATA #5,"|R8EA>CEC<AE"
 3032 DATA #6,"|\C\C\C\C"
 3033 DATA #7,"|\AR\BR\A\A\B\A"
 3034 DATA -
 3035 DATA #0,"|>C<A4A4AB>C"
 3036 DATA #1,"|AF4F4FGA"
 3037 DATA #2,"|RFA_>D~38;64;240&DC<AF"
 3038 DATA #3,"|R8P100DFP28A>CP100<AFP28D"
 3039 DATA #4,"|AF4F4FGA"
 3040 DATA #5,"|R8DFA>C<AFD"
 3041 DATA #6,"|\C\C\C\C"
 3042 DATA #7,"|\AR\BR\A\A\B\A"
 3043 DATA -
 3044 DATA #0,"|<B4B4G>D<BA8;;2/1"
 3045 DATA #1,"|G4G4DGGE8;;2/1"
 3046 DATA #2,"|GGDGDBAG"
 3047 DATA #3,"|R8P100GBP28>DGP100D<BP28G"
 3048 DATA #4,"|G4G4DGGE8;;2/1"
 3049 DATA #5,"|R8GB>DGD<BG"
 3050 DATA #6,"|\C\C\C\C"
 3051 DATA #7,"|\AR\BR\A\A\B\A"
 3052 DATA -
 3053 DATA #0,"|RB>C<BA @105O5V8  L8AAGl160 !1 Rl80"          :'command ﾂｲｶ
 3054 DATA #1,"|RGAGE @105P100V8 O4L8 EEE"
 3055 DATA #2,"|AEA_>E4~32;64;240EE<B"
 3056 DATA #3,"|R8P100EAP28>CE[2 @107P64V8 O4AAG"
 3057 DATA #4,"|RGAGE @105P28V8 O4L8 EEE"
 3058 DATA #5,"|R8EA>CE [2 @107V7 O4A~65;65;AG"
 3059 DATA #6,"|\C\C\C\C"
 3060 DATA #7,"|\AR\BR\A\A\B\A"
 3061 '
 3062 DATA -=> Bar 13-16 <=-
 3063 DATA #0,"|F4F4FGAG8;;2/1"
 3064 DATA #1,"|A4A4A>CF<B8;;2/1"
 3065 DATA #2,"|DDDDDF>D<B8;;2/1"
 3066 DATA #3,"|@100V9 O5 P100D1"
 3067 DATA #4,"|A4A4A>CF<B8;;2/1"
 3068 DATA #5,"|@100V9 O5 P44D1~65;65;"
 3069 DATA #6,"|\C\C\C\C"
 3070 DATA #7,"|\AR\BR\A\A\B\A"
 3071 DATA -
 3072 DATA #0,"|RA4B4>CC+16D16<B"
 3073 DATA #1,"|R>C4D4EGG"
 3074 DATA #2,"|R>C<B>C<GGGG"
 3075 DATA #3,"|P64G1"
 3076 DATA #4,"|R>C4D4EGG"
 3077 DATA #5,"|G1"
 3078 DATA #6,"|\C\CR2"
 3079 DATA #7,"|\AR\B(\A\F)L16\K\K"
 3080 DATA -
 3081 DATA #0,"|G4G4GEGB8;;2/1"
 3082 DATA #1,"|<B4B4BBB>D8;;2/1"
 3083 DATA #2,"|EEEEEGEA8;;2/1"
 3084 DATA #3,"|P28E1"
 3085 DATA #4,"|<B4B4BBB>D8;;2/1"
 3086 DATA #5,"|E1"
 3087 DATA #6,"|\C\C\C\C"
 3088 DATA #7,"|L8\AR\BR\A\A\B\A"
 3089 DATA -
 3090 DATA #0,"|R>C4<B4>C<BA"
 3091 DATA #1,"|RE4E4EDC<"
 3092 DATA #2,"|RAAAA4A4"
 3093 DATA #3,"|P64A1"
 3094 DATA #4,"|RE4E4EDC<"
 3095 DATA #5,"|A1"
 3096 DATA #6,"|\C\CR2"
 3097 DATA #7,"|\AR\B(\A\F)L16\K\K"
 3098 '
 3099 DATA -=> Bar 17-20 <=-
 3100 DATA #0,"|F4F4FGAG8;;2/1"
 3101 DATA #1,"|A4A4A>CF<B8;;2/1"
 3102 DATA #2,"|DDDDDF>D<B8;;2/1"
 3103 DATA #3,"|P100D1"
 3104 DATA #4,"|A4A4A>CF<B8;;2/1"
 3105 DATA #5,"|D1"
 3106 DATA #6,"|\C\C\C\C"
 3107 DATA #7,"|L8\AR\BR\A\A\B\A"
 3108 DATA -
 3109 DATA #0,"|RA4B4>CC+16D16<B"
 3110 DATA #1,"|R>C4D4EGG"
 3111 DATA #2,"|R>C<B>C<GGGG"
 3112 DATA #3,"|P64G1"
 3113 DATA #4,"|R>C4D4EGG"
 3114 DATA #5,"|G1"
 3115 DATA #6,"|\C\CR2"
 3116 DATA #7,"|\AR\B(\A\F)L16\K\K"
 3117 DATA -
 3118 DATA #0,"|G4G4GEGG+8;;2/1"
 3119 DATA #1,"|<B4B4BBB>D8;;2/1"
 3120 DATA #2,"|EEEEEGEE8;;2/1"
 3121 DATA #3,"|P28E1"
 3122 DATA #4,"|<B4B4BBB>D8;;2/1"
 3123 DATA #5,"|E1"
 3124 DATA #6,"|\C\C\C\C"
 3125 DATA #7,"|L8\AR\BR\A\A\B\A"
 3126 DATA -
 3127 DATA #0,"|RA4A+16B8.G+ABl160  !1 Rl80"
 3128 DATA #1,"|RF+4G+4DF+G+"
 3129 DATA #2,"|REG+BEG+BE"
 3130 DATA #3,"|P64G+1"
 3131 DATA #4,"|RF+4G+4DF+G+"
 3132 DATA #5,"|G+1"
 3133 DATA #6,"|\C\CR2"
 3134 DATA #7,"|\AR\B(\A\F)L16\E\E\G\G\F\F\E\E"
 3135 '
 3136 DATA -=> Bar 21-24 <=-
 3137 DATA #0,"|@104V11O4 EA>CED<BG>C8;;2/1"
 3138 DATA #1,"|@106P100V7 O5 E1"
 3139 DATA #2,"|A1]2"
 3140 DATA #3,"|@99O5V8 L16P64 AB>C<]1AB>C<]1AB>C<]1AB>C<]1AB>C<A[4"
 3141 DATA #4,"|@106P28V7 O5 E1~65;65;"
 3142 DATA #5,"|@99O5V7L16 AB>C<]1AB>C<]1AB>C<]1AB>C<]1AB>C<A[4"
 3143 DATA #6,"|\C\C\C\C"
 3144 DATA #7,"|L8\BR4.\F\F\F\B"
 3145 DATA -
 3146 DATA #0,"|R<A4B4>CC+16_D16<B"
 3147 DATA #1,"|>E1~0;64;480"
 3148 DATA #2,"|R8A[1AA[1AA[1AA"
 3149 DATA #3,"|P100 AB>C<]1AB>C<]1AB>C<]1AB>C<]1AB>C<A[4"
 3150 DATA #4,"|>E1~1;65;480"
 3151 DATA #5,"|AB>C<]1AB>C<]1AB>C<]1AB>C<]1AB>C<A[4"
 3152 DATA #6,"|\DRR2."
 3153 DATA #7,"|RL16\E\E\G\G\G\G\F\F\F\F\E\E\E\E"
 3154 DATA -
 3155 DATA #0,"|EA>CED<BG>C8;;2/1"
 3156 DATA #1,"|<F1"
 3157 DATA #2,"|F1]3"
 3158 DATA #3,"|P64 AB>C<]1AB>C<]1AB>C<]1AB>C<]1AB>C<A[4"
 3159 DATA #4,"|<F1"
 3160 DATA #5,"|AB>C<]1AB>C<]1AB>C<]1AB>C<]1AB>C<A[4"
 3161 DATA #6,"|\C\C\C\C"
 3162 DATA #7,"|L8\BR4.\F\F\F\B"
 3163 DATA -
 3164 DATA #0,"|R<A4B4>CC+16_D16<B"
 3165 DATA #1,"|>F1~0;64;480"
 3166 DATA #2,"|R8F[1FF[1FF[1FF"
 3167 DATA #3,"|P28 AB>C<]1AB>C<]1AB>C<]1AB>C<]1AB>C<A[4"
 3168 DATA #4,"|>F1~1;65;480"
 3169 DATA #5,"|AB>C<]1AB>C<]1AB>C<]1AB>C<]1AB>C<A[4"
 3170 DATA #6,"|\DRR2."
 3171 DATA #7,"|RL16\E\E\G\G\G\G\F\F\F\F\E\E\E\E"
 3172 '
 3173 DATA -=> Bar 25-28 <=-
 3174 DATA #0,"|FA>CEG2"
 3175 DATA #1,"|<D1"
 3176 DATA #2,"|D1]3"
 3177 DATA #3,"|P64 AB>C<]1AB>C<]1AB>C<]1AB>C<]1AB>C<A[4"
 3178 DATA #4,"|<D1"
 3179 DATA #5,"|AB>C<]1AB>C<]1AB>C<]1AB>C<]1AB>C<A[4"
 3180 DATA #6,"|\C\C\C\C"
 3181 DATA #7,"|L8\BR4.\F\F\F\B"
 3182 DATA -
 3183 DATA #0,"|E4_FE4_FE_F[1"
 3184 DATA #1,"|>D1~0;64;480"
 3185 DATA #2,"|R8D[1DD[1DD[1DD"
 3186 DATA #3,"|P100 AB>C<]1AB>C<]1AB>C<]1AB>C<]1AB>C<A[4"
 3187 DATA #4,"|>D1~1;65;480"
 3188 DATA #5,"|AB>C<]1AB>C<]1AB>C<]1AB>C<]1AB>C<A[4"
 3189 DATA #6,"|\DRR2."
 3190 DATA #7,"|RL16\E\E\G\G\G\G\F\F\F\F\E\E\E\E"
 3191 DATA -
 3192 DATA #0,"|B1"
 3193 DATA #1,"|<E1"
 3194 DATA #2,"|E1]3"
 3195 DATA #3,"|P64 EG+B]1EG+B]1EG+B]1EG+B]1EG+BG+[4"
 3196 DATA #4,"|<E1"
 3197 DATA #5,"|EG+B]1EG+B]1EG+B]1EG+B]1EG+BG+[4"
 3198 DATA #6,"|\C\C\C\C"
 3199 DATA #7,"|L8(\B\F)(\A\F)(\A\F)\B(\A\F)(\A\F)\B\F"
 3200 DATA -
 3201 DATA #0,"|>E1]1<"
 3202 DATA #1,"|>E1~0;64;480"
 3203 DATA #2,"|R8E[1EE[1EE[1EE]1"
 3204 DATA #3,"|P28 EG+B]1EG+B]1EG+B]1EG+B]1EG+BG+[4"
 3205 DATA #4,"|>E1~1;65;480"
 3206 DATA #5,"|EG+B]1EG+B]1EG+B]1EG+B]1EG+BG+[4"
 3207 DATA #6,"|R1"
 3208 DATA #7,"|L16\H\H\I\H\H\I\H\I"
 3209 '
 3210 DATA -=> Bar 29-32 <=-
 3211 DATA #0,"|O4 EA>CED<BG>C8;;2/1"
 3212 DATA #1,"|O5 E1"
 3213 DATA #2,"|A1]2"
 3214 DATA #3,"|P64 AB>C<]1AB>C<]1AB>C<]1AB>C<]1AB>C<A[4"
 3215 DATA #4,"|O5 E1"
 3216 DATA #5,"|AB>C<]1AB>C<]1AB>C<]1AB>C<]1AB>C<A[4"
 3217 DATA #6,"|\C\C\C\C"
 3218 DATA #7,"|L8\BR4.\F\F\F\B"
 3219 DATA -
 3220 DATA #0,"|R<A4B4>CC+16_D16<B"
 3221 DATA #1,"|>E1~0;64;480"
 3222 DATA #2,"|R8A[1AA[1AA[1AA"
 3223 DATA #3,"|P100 AB>C<]1AB>C<]1AB>C<]1AB>C<]1AB>C<A[4"
 3224 DATA #4,"|>E1~1;65;480"
 3225 DATA #5,"|AB>C<]1AB>C<]1AB>C<]1AB>C<]1AB>C<A[4"
 3226 DATA #6,"|\DRR2."
 3227 DATA #7,"|RL16\E\E\G\G\G\G\F\F\F\F\E\E\E\E"
 3228 DATA -
 3229 DATA #0,"|EA>CED<BG>C8;;2/1"
 3230 DATA #1,"|<F1"
 3231 DATA #2,"|F1]3"
 3232 DATA #3,"|P64 AB>C<]1AB>C<]1AB>C<]1AB>C<]1AB>C<A[4"
 3233 DATA #4,"|<F1"
 3234 DATA #5,"|AB>C<]1AB>C<]1AB>C<]1AB>C<]1AB>C<A[4"
 3235 DATA #6,"|\C\C\C\C"
 3236 DATA #7,"|L8\BR4.\F\F\F\B"
 3237 DATA -
 3238 DATA #0,"|R<A4B4>CC+16_D16<B"
 3239 DATA #1,"|>F1~0;64;480"
 3240 DATA #2,"|R8F[1FF[1FF[1FF"
 3241 DATA #3,"|P28 AB>C<]1AB>C<]1AB>C<]1AB>C<]1AB>C<A[4"
 3242 DATA #4,"|>F1~1;65;480"
 3243 DATA #5,"|AB>C<]1AB>C<]1AB>C<]1AB>C<]1AB>C<A[4"
 3244 DATA #6,"|\DRR2."
 3245 DATA #7,"|RL16\E\E\G\G\G\G\F\F\F\F\E\E\E\E"
 3246 '
 3247 DATA -=> Bar 33-36 <=-
 3248 DATA #0,"|FA>CEG2"
 3249 DATA #1,"|<D1"
 3250 DATA #2,"|D1]3"
 3251 DATA #3,"|P64 AB>C<]1AB>C<]1AB>C<]1AB>C<]1AB>C<A[4"
 3252 DATA #4,"|<D1"
 3253 DATA #5,"|AB>C<]1AB>C<]1AB>C<]1AB>C<]1AB>C<A[4"
 3254 DATA #6,"|\C\C\C\C"
 3255 DATA #7,"|L8\BR4.\F\F\F\B"
 3256 DATA -
 3257 DATA #0,"|E4_FE4_FE_F[1"
 3258 DATA #1,"|>D1~0;64;480"
 3259 DATA #2,"|R8D[1DD[1DD[1DD"
 3260 DATA #3,"|P100 AB>C<]1AB>C<]1AB>C<]1AB>C<]1AB>C<A[4"
 3261 DATA #4,"|>D1~1;65;480"
 3262 DATA #5,"|AB>C<]1AB>C<]1AB>C<]1AB>C<]1AB>C<A[4"
 3263 DATA #6,"|\DRR2."
 3264 DATA #7,"|RL16\E\E\G\G\G\G\F\F\F\F\E\E\E\E"
 3265 DATA -
 3266 DATA #0,"|B1"
 3267 DATA #1,"|<E1"
 3268 DATA #2,"|E1]3"
 3269 DATA #3,"|P64 EG+B]1EG+B]1EG+B]1EG+B]1EG+BG+[4"
 3270 DATA #4,"|<E1"
 3271 DATA #5,"|EG+B]1EG+B]1EG+B]1EG+B]1EG+BG+[4"
 3272 DATA #6,"|\C\C\C\C"
 3273 DATA #7,"|L8(\B\F)(\A\F)(\A\F)\B(\A\F)(\A\F)\B\F"
 3274 DATA -
 3275 DATA #0,"|>E2&E4&E8&E16&El40  !1 Rl80   ]1<"
 3276 DATA #1,"|>E1~0;64;480"
 3277 DATA #2,"|R8E[1EE[1EE[1EE]1"
 3278 DATA #3,"|P28 EG+B]1EG+B]1EG+B]1EG+B]1EG+BG+[4"
 3279 DATA #4,"|>E1~1;65;480"
 3280 DATA #5,"|EG+B]1EG+B]1EG+B]1EG+B]1EG+BG+[4"
 3281 DATA #6,"|R1"
 3282 DATA #7,"|L16\H\H\I\H\H\I\H\I"
 3283 '
 3284 DATA -=> Bar 37-40 <=-
 3285 DATA #0,"|A1"
 3286 DATA #1,"|@108P100V11O5L16 CCCCC&]1C[1C&]1C8.[1C&]1C8.[1C&]1C[1"
 3287 DATA #2,"|@103L16 AAAAA8G4A4BG"
 3288 DATA #3,"|@108P28V10L16 AAAAA&]1A[1A&]1A8.[1A&]1A8.[1A&]1A[1"
 3289 DATA #4,"|@108P28V11O5L16 C~65;65;CCCC&]1C[1C&]1C8.[1C&]1C8.[1C&]1C[1"
 3290 DATA #5,"|@108P100V10L16 A~65;65;AAAA&]1A[1A&]1A8.[1A&]1A8.[1A&]1A[1"
 3291 DATA #6,"|R1"
 3292 DATA #7,"|\H\H\I\H\H\I\H\I"
 3293 DATA -
 3294 DATA #0,"|@108V10O5L16 EEEEE&]1E[1E&]1E8.[1E&]1E8.[1E&]1E[1"
 3295 DATA #1,"|V10 CCCCC&]1C[1C&]1C8.[1C&]1C8.[1C&]1C[1"
 3296 DATA #2,"|AAAAA8A4A4BG"
 3297 DATA #3,"|AAAAA&]1A[1A&]1A8.[1A&]1A8.[1A&]1A[1"
 3298 DATA #4,"|V10 CCCCC&]1C[1C&]1C8.[1C&]1C8.[1C&]1C[1"
 3299 DATA #5,"|AAAAA&]1A[1A&]1A8.[1A&]1A8.[1A&]1A[1"
 3300 DATA #6,"|R1"
 3301 DATA #7,"|\H\H\I\H\H\I\H\I"
 3302 DATA -
 3303 DATA #0,"|V11 EEEEE&]1E[1E&]1E8.[1E&]1E8.[1E&]1E[1"
 3304 DATA #1,"|V8  CCCCC&]1C[1C&]1C8.[1C&]1C8.[1C&]1C[1"
 3305 DATA #2,"|AAAAA8G4A4BG"
 3306 DATA #3,"|AAAAA&]1A[1A&]1A8.[1A&]1A8.[1A&]1A[1"
 3307 DATA #4,"|V8  CCCCC&]1C[1C&]1C8.[1C&]1C8.[1C&]1C[1"
 3308 DATA #5,"|AAAAA&]1A[1A&]1A8.[1A&]1A8.[1A&]1A[1"
 3309 DATA #6,"|R1"
 3310 DATA #7,"|\H\H\I\H\H\I\H\I"
 3311 DATA -
 3312 DATA #0,"|EEEEE&]1E[1E&]1E8.[1E&]1E8.[1E&]1El40 !1 Rl80 [1dc"  :'command ﾂｲｶ nao
 3313 DATA #1,"|CCCCC&]1C[1C&]1C8.[1C&]1C8.[1C&]1C[1"
 3314 DATA #2,"|AAAAA8A4A4AA"
 3315 DATA #3,"|AAAAA&]1A[1A&]1A8.[1A&]1A8.[1A&]1A[1"
 3316 DATA #4,"|CCCCC&]1C[1C&]1C8.[1C&]1C8.[1C&]1C[1"
 3317 DATA #5,"|AAAAA&]1A[1A&]1A8.[1A&]1A8.[1A&]1A[1"
 3318 DATA #6,"|R1"
 3319 DATA #7,"|\H\H\I\H\H\I\H\I"
 3320 '
 3321 '###############################
 3322 '      STAGE 1 BOSS
 3323 '###############################
 3324 DATA SONG 2
 3325 DATA #0,"T160@109 V8 P64O4L8"
 3326 DATA #1,"@113 V10 P100O4L8"
 3327 DATA #2,"@102 V12P64O3L8"
 3328 DATA #3,"@114 V11 P64O4L8"
 3329 DATA #4,"@114 V11 P64O4L8"
 3330 DATA #5,"@113 V8  P28O4L8"
 3331 DATA #6,"@116 V15P64O4L8"
 3332 DATA #7,"@116 V15P64O4L8"
 3333 '
 3334 DATA -=> MACRO SET <=-
 3335 DATA "\A=\N36'\"
 3336 DATA "\B=\N38'\"
 3337 DATA "\C=\N42';112N42';107\"
 3338 DATA "\D=\(N38'N45')(N38';122N45';122)\"
 3339 DATA "\E=\(N36'16N48'16)N48'16;122N48'\"
 3340 DATA "\F=\(N38'16N45'16)N45'16;122(N38N45)\"
 3341 DATA "\G=\(N36N38)N38';122\"
 3342 DATA "\H=\(N36N49';97)\"
 3343 DATA "\I=\(N38N45N49';97)v122(N38'N45')\"
 3344 DATA "\J=\N39';100N39';105\"
 3345 '
 3346 '------ TRACK SET ------
 3347 DATA -=> Bar 1-4 <=-
 3348 DATA #0,"|D4.E-4.A4|B-4.E-4.A4"
 3349 DATA #1,"|Dl1280~65;124;Dl1280~65;124;Dl1280~65;124;"
 3350 DATA #2,"|L8DD>D<DDD>D<D|DD>D<DDD>D<D"
 3351 DATA #3,"|B-1|R8B-8B-4B-2"
 3352 DATA #4,"|E1|R8E8E4E2"
 3353 DATA #5,"|Dl1280~63;122;Dl1280~63;122;Dl1280~63;122;"
 3354 DATA #6,"|\C\C\C\C|\C\C\C\C"
 3355 DATA #7,"|\AR\BR\A\A\B\A|\AR\BR\A\A\B\A"
 3356 DATA -
 3357 DATA #0,"|D4.E-4.A4|G4.F+4.A4"
 3358 DATA #1,"|Dl1280~65;124;Dl1280~65;124;Dl1280~65;124;"
 3359 DATA #2,"|L8DD>D<DDD>D<D|DD>D<DDD>D<D"
 3360 DATA #3,"|B-1|R8B-8B-4B-2"
 3361 DATA #4,"|E1|R8E8E4E2"
 3362 DATA #5,"|Dl1280~63;122;Dl1280~63;122;Dl1280~63;122;"
 3363 DATA #6,"|\C\C\C\C|\C\C\C\C"
 3364 DATA #7,"|\AR\BR\A\A\B\A|\AR\BR\A\A\B\A"
 3365 '
 3366 DATA -=> Bar 5-8 <=-
 3367 DATA #0,"|D4.E-4.A4|B-4.E-4.A4"
 3368 DATA #1,"|Dl1280~65;124;Dl1280~65;124;Dl1280~65;124;"
 3369 DATA #2,"|L8DD>D<DDD>D<D|DD>D<DDD>D<D"
 3370 DATA #3,"|B-1|R8B-8B-4B-2"
 3371 DATA #4,"|E1|R8E8E4E2"
 3372 DATA #5,"|Dl1280~63;122;Dl1280~63;122;Dl1280~63;122;"
 3373 DATA #6,"|\C\C\C\C|\C\C\C\C"
 3374 DATA #7,"|\AR\BR\A\A\B\A|\AR\BR\A\A\B\A"
 3375 DATA -
 3376 DATA #0,"|D4.E-4.A4|G4.F+4.A4"
 3377 DATA #1,"|Dl1280~65;124;Dl1280~65;124;Dl1280~65;124;"
 3378 DATA #2,"|L8DD>D<DDD>D<D|DD>D<DDD>D<D"
 3379 DATA #3,"|B-1|R8B-8B-4B-2"
 3380 DATA #4,"|E1|R8E8E4E2"
 3381 DATA #5,"|Dl1280~63;122;Dl1280~63;122;Dl1280~63;122;"
 3382 DATA #6,"|\C\C\C\C|\C\C\C\C"
 3383 DATA #7,"|\AR\BR\A\A\B\A|\AR\BR\A\A\B\A"
 3384 '
 3385 DATA -=> Bar 9-12 <=-
 3386 DATA #0,"dc|P64@109 V9 O5 L8GAB-G4B-4_G8~74;64;80|L8AFCF4A4_F8~80;64;120"
 3387 DATA #1,"  |@109 P100V9 O5L8 DFGD4G4_D8~85;64;160|L8FC<A>C4F4_D8~74;64;80"
 3388 DATA #2,"  |O3 GGGG16G16GGGG16G16|GGGG16G16GGGG16G16"
 3389 DATA #3,"  |@111 V7O6 B-1|A1"
 3390 DATA #4,"  |@111 V7O6 D1|C1"
 3391 DATA #5,"  |@109 P28V9 O5L8 DFGD4G4_D8~85;64;160|L8FC<A>C4F4_D8~74;64;80"
 3392 DATA #6,"  |R1|R1"
 3393 DATA #7,"  |\AR\D\AR\D|\AR\D\AR\D"
 3394 DATA -
 3395 DATA #0,"|L8E-GB->D4<GB-G|AB-4_G8~74;64;80&G2"
 3396 DATA #1,"|L8<B->E-GB-4DGD|FG4_D+8~80;64;120_D2"
 3397 DATA #2,"|O3 GGGG16G16GGGG16G16|GGGG16G16GGGG16G16"
 3398 DATA #3,"|G1|G1"
 3399 DATA #4,"|E-1|D1"
 3400 DATA #5,"|L8<B->E-GB-4DGD|FG4_D+8~80;64;120_D2"
 3401 DATA #6,"|R1|R1"
 3402 DATA #7,"|\AR\D\AR\D|\AR\D\E\F"
 3403 '
 3404 DATA -=> Bar 13-16 <=-
 3405 DATA #0,"|P64@109 V9 O5 L8GAB-G4B-4_G8~74;64;80|L8AFCF4A4_F8~80;64;120"
 3406 DATA #1,"|O5L8 DFGD4G4_D8~85;64;160|L8FC<A>C4F4_D8~74;64;80"
 3407 DATA #2,"|O3 GGGG16G16GGGG16G16|GGGG16G16GGGG16G16"
 3408 DATA #3,"|B-1|A1"
 3409 DATA #4,"|D1|C1"
 3410 DATA #5,"|O5L8 DFGD4G4_D8~85;64;160|L8FC<A>C4F4_D8~74;64;80"
 3411 DATA #6,"|R1|R1"
 3412 DATA #7,"|\AR\D\AR\D|\AR\D\AR\D"
 3413 DATA -
 3414 DATA #0,"|L8E-GB->D4<GB-G|AB-4_G8~74;64;80&G2"
 3415 DATA #1,"|L8<B->E-GB-4DGD|FG4_D+8~80;64;120_D2"
 3416 DATA #2,"|O3 GGGG16G16GGGG16G16|GGGG16G16GGGG16G16"
 3417 DATA #3,"|G1|G1"
 3418 DATA #4,"|E-1|D1"
 3419 DATA #5,"|L8<B->E-GB-4DGD|FG4_D+8~80;64;120_D2"
 3420 DATA #6,"|R1|R1"
 3421 DATA #7,"|\AR\D\AR\D|\AR\D\E\F"
 3422 '
 3423 DATA -=> Bar 17-20 <=-
 3424 DATA #0,"|L4 R @111 V9  O5GAB-|A8F8A8B-4.>C<"
 3425 DATA #1,"|L4 R @111 P100V9  O5E-FG|F8C8F8G4.A"
 3426 DATA #2,"|O3 E-E-E-E-16E-16E-E-E-E-16E-16|FFFF16F16FFFF16F16"
 3427 DATA #3,"|@115 V9 O4 B-4.B-2&B-8|R8A8A4A2"
 3428 DATA #4,"|@115 V9 O5 G4.G2&G8|R8F8F4F2"
 3429 DATA #5,"|L4 R @111 P28V7 O5E-FG|F8C8F8G4.A"
 3430 DATA #6,"|@117 V9 P28R4\JR4\J|R4\JR4\J"
 3431 DATA #7,"|\HR\D\AR\D|\AR\D\AR\D"
 3432 DATA -
 3433 DATA #0,"|R O5B->CD|<B-8G]1B-8G8[1G8G8G8"
 3434 DATA #1,"|R O5GAB-|G8D]1G8D8[1D8D8D8"
 3435 DATA #2,"|O3 GGGG16G16GGGG16G16|GGGG16G16GGGG16G16"
 3436 DATA #3,"|B-4.B-2&B-8|R8B-8B-4B-2"
 3437 DATA #4,"|G4.G2&G8|R8G8G4G2"
 3438 DATA #5,"|R O5GAB-|G8D]1G8D8[1D8D8D8"
 3439 DATA #6,"|R4\JR4\J|R4\JR2"
 3440 DATA #7,"|\HR\D\AR\D|\AR\D\E\F"
 3441 '
 3442 DATA -=> Bar 21-24 <=-
 3443 DATA #0,"|R O5GAB-|A8F8A8B-4.>C<"
 3444 DATA #1,"|R O5E-FG|F8C8F8G4.A"
 3445 DATA #2,"|O3 E-E-E-E-16E-16E-E-E-E-16E-16|FFFF16F16FFFF16F16"
 3446 DATA #3,"|B-4.B-2&B-8|R8A8A4A2>"
 3447 DATA #4,"|G4.G2&G8|R8F8F4F2"
 3448 DATA #5,"|R O5E-FG|F8C8F8G4.A"
 3449 DATA #6,"|R4\JR4\J|R4\JR4\J"
 3450 DATA #7,"|\HR\D\AR\D|\AR\D\AR\D"
 3451 DATA -
 3452 DATA #0,"|R O5AEG|F+4.G4.A"
 3453 DATA #1,"|R O5CCE|D4.E4.F+"
 3454 DATA #2,"|O3 AAAA16A16AAAA16A16|DDDD16D16DDDD16D16"
 3455 DATA #3,"|C4.C2&C8|R8C8C4C8C4C8"
 3456 DATA #4,"|A4.A2&A8|R8F+8F+4F+8F+4F+8"
 3457 DATA #5,"|R O5CCE|D4.E4.F+"
 3458 DATA #6,"|R4\JR4\J|R1"
 3459 DATA #7,"|\HR\D\AR\D|]2\G[1\D[1\G\I]2v127"
 3460 '
 3461 DATA -=> Bar 25-28 <=-
 3462 DATA #0,"|@112 V7 O4L8 G4.G4DB-G|AF4 ]1 AF4 ]1 AF [2"
 3463 DATA #1,"|@112 P100V7 O4L8 D4.D4<B->GD|FC4 ]1 FC4 ]1 FC[2"
 3464 DATA #2,"|O3 GGGG16G16GGGG16G16|FFFF16F16FFFF16F16"
 3465 DATA #3,"|@114 V7 O4 G1|F1"
 3466 DATA #4,"|@114 V7 O4 B-1|A1"
 3467 DATA #5,"|@112 P28V7 O4L8 D4.D4<B->GD|FC4 ]1 FC4 ]1 FC[2"
 3468 DATA #6,"|R1|R1"
 3469 DATA #7,"|V15\AR\D\AR\D|\AR\D\AR\D"
 3470 DATA -
 3471 DATA #0,"|G4.G4E-B-G|{AB->C<}2]1{AB->C<}2[1"
 3472 DATA #1,"|E-4.E-4<B->GE-|{FGA}2]1{FGA}2[1"
 3473 DATA #2,"|O3 E-E-E-E-16E-16E-E-E-E-16E-16|FFFF16F16FFFF16F16"
 3474 DATA #3,"|E-1|F1"
 3475 DATA #4,"|G1|A1"
 3476 DATA #5,"|E-4.E-4<B->GE-|{FGA}2]1{FGA}2[1"
 3477 DATA #6,"|R1|R1"
 3478 DATA #7,"|\AR\D\AR\D|\AR\D\E\F"
 3479 '
 3480 DATA -=> Bar 29-32 <=-
 3481 DATA #0,"|L8G4.G4DB-G|AF4 ]1 AF4 ]1 AF [2"
 3482 DATA #1,"|L8D4.D4<B->GD|FC4 ]1 FC4 ]1 FC[2"
 3483 DATA #2,"|O3 GGGG16G16GGGG16G16|FFFF16F16FFFF16F16"
 3484 DATA #3,"|G1|F1"
 3485 DATA #4,"|B-1|A1"
 3486 DATA #5,"|L8D4.D4<B->GD|FC4 ]1 FC4 ]1 FC[2"
 3487 DATA #6,"|R1|R1"
 3488 DATA #7,"|\AR\D\AR\D|\AR\D\AR\D"
 3489 DATA -
 3490 DATA #0,"|G4.G4EB-G|{GAB-}2]1{GAB-}2[1"
 3491 DATA #1,"|E4.E4CGE|{E-FG}2]1{E-FG}2[1"
 3492 DATA #2,"|O3 EEEE16E16EEEE16E16|E-E-E-E-16E-16E-E-E-E-16E-16"
 3493 DATA #3,"|E1|E-1"
 3494 DATA #4,"|G1|G1"
 3495 DATA #5,"|E4.E4CGE|{E-FG}2]1{E-FG}2[1"
 3496 DATA #6,"|R1|R1"
 3497 DATA #7,"|\AR\D\AR\D|\AR\D\E\F"
 3498 '
 3499 DATA -=> Bar 33-36 <=-
 3500 DATA #0,"|G1;;4/1|R1"
 3501 DATA #1,"|@113 P100V8 O4 Dl1280~65;124;Dl1280~65;124;Dl1280~65;124;"
 3502 DATA #2,"|O3 GGGG16G16GGGG16G16|GGGG16G16GGGG16G16"
 3503 DATA #3,"|%1D1|R1"
 3504 DATA #4,"|%1G1|R1"
 3505 DATA #5,"|@113 P28V8 O4 Dl1280~63;122;Dl1280~63;122;Dl1280~63;122;"
 3506 DATA #6,"|R1|R1"
 3507 DATA #7,"|\AR\D\AR\D|\AR\D\AR\D"
 3508 DATA -
 3509 DATA #0,"|R1|R1dc"
 3510 DATA #1,"|Dl1280~65;124;Dl1280~65;124;Dl1280~65;124;"
 3511 DATA #2,"|O3 GGGG16G16GGGG16G16|GGGG16G16GGGG16G16"
 3512 DATA #3,"|R1|R2...R32.%0R64"
 3513 DATA #4,"|R1|R2...R32.%0R64"
 3514 DATA #5,"|Dl1280~63;122;Dl1280~63;122;Dl1280~63;122;"
 3515 DATA #6,"|R1|R1"
 3516 DATA #7,"|\AR\D\AR\D|\AR\D\AR\D"
 3517 '
 3518 DATA ENDSONG
 3519 '
 3520 '###############################
 3521 '      STAGE 2 SONG DATA
 3522 '###############################
 3523 *MS2
 3524 DATA SONG 1
 3525 DATA \A = \(N46N30) N46 (N46N30) (N46N38) N46 (N46N30) (N46N30) N46 (N46N30) (N46N38) N46 (N46N30)\
 3526 DATA \B = \(N30N49) N46 (N46N30) (N46N38) (N46N46) (N46N30) (N46N30) N46 (N46N30) (N46N38) N46 (N46N30)\
 3527 DATA \C = \(N46N30) N46 (N46N30) (N46N38) N46 (N46N30) (N46N30) N46 (N46N30) (N46N38)   N38  N45\
 3528 DATA \D = \(N49N30) N46 (N46N30) (N46N38) N46 (N46N30) (N46N30) N46 (N46N30) (N45N45N38) N46 (N46N45N30)\
 3529 DATA \E = \(N46N30) N46 (N46N30) (N46N38) N46 (N46N30) (N46N30) N46 (N46N30) (N45N45N38)  N46 (N46N45)\
 3530 DATA \F = \(N46N30) N46 (N46N30) (N46N38) N46 (N46N30) (N46N30) N46 (N46N30) (N46N38)  N46 (N46N45N45)\
 3531 DATA \G = \(N30N49) N46 (N46N30) (N46N38) N46 (N46N30) (N46N30) N46 (N46N30) (N46N38)  N46 (N46N45N45)\
 3532 DATA --
 3533 DATA #0, T155 P64@36V10 L12O4R2F+6D&D4
 3534 DATA #1,P64@36V9  L12O4 R2D6<A12&A4>
 3535 DATA #2,P64@44V11R2O4A6A12&A4
 3536 DATA #3,P64@51V7 R4L48O2E8F+G+A+>CDEF+G+A+>CDEF+G+A+>CDEE4
 3537 DATA #4,R1
 3538 DATA #5, P64@51V8 O2 L48 E8 F+ G+ A+ >C D E F+ G+ A+ >C D E F+ G+ A+ >C D E E2
 3539 DATA #6,@116 L24 N45N45 L12 N45 N45 P24 L24 N45  N45 L12 N45  N45 P64 (N38'6N30'6) N49'4 R12
 3540 DATA --
 3541 DATA #0, dc G1   F+6G4A12&A2
 3542 DATA #1,E1 D6E4F+12&F+2
 3543 DATA #2,L12O4EEF+EGEA6D4F+ EEF+EGED6F+4D
 3544 DATA #3,@53O6L12V8 L12 EAG]2EF+D[2EAG]2EF+G[2 EAG]2EF+D[2EAG]2EF+G[2
 3545 DATA #4,P64@53O6L12V7 R12 L12 EAG]2EF+D[2EAG]2EF+G[2 L12 EAG]2EF+D[2EAG]2EF+
 3546 DATA #5, P64@51V8O5L48[2E1]2O2E8F+G+A+>CDEF+G+A+>CDEF+G+A+>CDEE2[2
 3547 DATA #6,L12 \B \A
 3548 DATA --
 3549 DATA #0, F+6G12&G2. F+6G4D12&D2
 3550 DATA #1,D6E12&E2. D6E4<A12&A2>
 3551 DATA #2,L12O4EEF+EGEA6D4F+ EEF+EGED6F+4D
 3552 DATA #3,L12 EAG]2EF+D[2EAG]2EF+G[2 EAG]2EF+D[2EAG]2EF+G[2
 3553 DATA #4,G[2 L12 EAG]2EF+D[2EAG]2EF+G[2 L12 EAG]2EF+D[2EAG]2E8[2
 3554 DATA #5, E1D+DC+C<BA+AG+GF+FED+DC+C<BA+AG+GF+FED+DC+C<BA+AG+GF+FE&E4
 3555 DATA #6,\A (N46N30)N46(N46N30)(N46N38)N46(N46N30)(N46N30)N46(N46N30)(N46N38)N46P64(N46N45)
 3556 DATA --
 3557 DATA #0, G1   F+6G4A12&A2
 3558 DATA #1,E1 D6E4F+12&F+2
 3559 DATA #2,L12O4EEF+EGEA6D4F+ EEF+EGED6F+4D
 3560 DATA #3,@49O4V9 E1 <B2>F+2
 3561 DATA #4,@49O4V8 R8 P24E1~65;65; P104<B2>F+4.
 3562 DATA #5, @4 V12O5L12 E<B>D]2<A>D<B>]2E<B>D]2<A>D<B>[6]2 EA>D<G>CF<A>DGF+E<A [2
 3563 DATA #6,\B \A
 3564 DATA --
 3565 DATA #0, F+6G12&G2. F+6G4D12&D2
 3566 DATA #1,D6E12&E2. D6E4<A12&A2>
 3567 DATA #2,L12O4EEF+EGEA6D4F+ EEF+EGED6F+4D
 3568 DATA #3,G1 F+2D2
 3569 DATA #4,R8 P24G1 P104F+2D4.
 3570 DATA #5, E<B>D]2<A>D<B>]2E<B>D]2<A>D<B>[6]2 EA>D<G>CF<A>DGF+E<A [2
 3571 DATA #6,\A \C
 3572 DATA --
 3573 DATA #0, D6E12&E2.  F+6G4A12&A2
 3574 DATA #1,<B6>C12&C2.D6E4F+12&F+2
 3575 DATA #2,L12O4 CCDCECF+6C4D< AA>C<A>D<AA6>D4D+
 3576 DATA #3,C1 <A2>D2
 3577 DATA #4,R8 P24C1 P104<A2>D4.
 3578 DATA #5, E<B>D]2<A>D<B>]2E<B>D]2<A>D<B>[6E<B>D]2<A>D<B>]2E<B>D]2<A>D<B>[6
 3579 DATA #6,\D \E
 3580 DATA --
 3581 DATA #0, A6B12&B2.&B2 F+6D12&D8&D16&Dl40 !1 Rl80
 3582 DATA #1,F+6G12&G2.&G2D6<A12&A4>
 3583 DATA #2,EEF+EGEA6D4F+ EEEEEEA6D&D4
 3584 DATA #3,<B1&B1>
 3585 DATA #4,R8 P24<B1&B2..>
 3586 DATA #5, E<B>D]2<A>D<B>]2E<B>D]2<A>D<B>[6]2 EA>D<G>CF<A>DGF+E<A [2
 3587 DATA #6,\B (N46N30) N46 (N46N30) (N46N38) N46 (N46N30) (N46'6N38'6) (N49'6N30'6) N38  N38
 3588 DATA --
 3589 DATA #0, G1   F+6G4A12&A2
 3590 DATA #1,E1 D6E4F+12&F+2
 3591 DATA #2,L12O4EEF+EGEA6D4F+ EEF+EGED6F+4D
 3592 DATA #3,E1 <B2>F+2
 3593 DATA #4,R8 P24E1 P104<B2>F+4.
 3594 DATA #5, E<B>D]2<A>D<B>]2E<B>D]2<A>D<B>[6]2 EA>D<G>CF<A>DGF+E<A [2
 3595 DATA #6,\B \A
 3596 DATA --
 3597 DATA #0, F+6G12&G2. F+6G4D12&D2
 3598 DATA #1,D6E12&E2. D6E4<A12&A2>
 3599 DATA #2,L12O4EEF+EGEA6D4F+ EEF+EGED6F+4D
 3600 DATA #3,G1 F+2D2
 3601 DATA #4,R8 P24G1 P104F+2D4.
 3602 DATA #5, E<B>D]2<A>D<B>]2E<B>D]2<A>D<B>[6]2 EA>D<G>CF<A>DGF+E<A [2
 3603 DATA #6,\A \C
 3604 DATA --
 3605 DATA #0, D6E12&E2.  F+6G4A12&A2
 3606 DATA #1,<B6>C12&C2.D6E4F+12&F+2
 3607 DATA #2,L12O4 CCDCECF+6C4D< AA>C<A>D<AA6>D4D+
 3608 DATA #3,C1 <A2>D2
 3609 DATA #4,R8 P24C1 P104<A2>D4.
 3610 DATA #5, E<B>D]2<A>D<B>]2E<B>D]2<A>D<B>[6E<B>D]2<A>D<B>]2E<B>D]2<A>D<B>[6
 3611 DATA #6,\D \E
 3612 DATA --
 3613 DATA #0, A6B12&B2.&B2R6G12&G8&G16&Gl40 !1 Rl80
 3614 DATA #1,F+6G12&G2.&G2R6D12&D4
 3615 DATA #2,EEF+EGEA6D4F+ EEE EEE F+F+F+ GGG
 3616 DATA #3,E1&E2 @52V9O4L12DEF+GAB
 3617 DATA #4,R12 P24E1&E2  @52V8O4L12P104DEF+GA
 3618 DATA #5, E<B>D]2<A>D<B>]2E<B>D]2<A>D<B>[6]2EA>D<G>CF<A>DF+GAB
 3619 DATA #6,\B (N46N30) N46 (N46N30) (N46N38)  N46 (N46N30) N38'24 N38'24  N38  N38  P24 N45 N45 N45P64
 3620 DATA --
 3621 DATA #0, @49V9O4 E1F+1
 3622 DATA #1,@49V8O4C1D1
 3623 DATA #2,L12O4 AAAEAEA6E4G  DDDF+DF+G6F+4D
 3624 DATA #3,L12 >C<B>C<AGAF+EF+DCD  C<B>CDEF+EF+GF+GA
 3625 DATA #4,B L12 P24>C<B>C<AGAF+EF+DCP104D  C<B>CDEF+EF+GF+GP24
 3626 DATA #5, P64@51V9O3 L6 A2 ^B3UP^>E2   ^B1DN^D2  EDC<
 3627 DATA #6,\G \F
 3628 DATA --
 3629 DATA #0, D1E1
 3630 DATA #1,<B1>C1
 3631 DATA #2,GGGDGDG6D4F+  CCDCECG6F+4D
 3632 DATA #3,BABGF+GEDEDC<B>  CDEDEF+EF+GF+GB
 3633 DATA #4,A BABGF+GEDEDC<P104B>  CDEDEF+EF+GF+GP24
 3634 DATA #5, B2    ^B3UP^>F+2  ^B1DN^E2  EDC<
 3635 DATA #6,\F \F
 3636 DATA --
 3637 DATA #0, C1D1
 3638 DATA #1,<A1A1
 3639 DATA #2,<AA>C<A>D<A>E6C4C+  DDEDF+DG6F+4D
 3640 DATA #3,AGAF+EF+DC<B>C<BG+  AB>C<B>CDCDEF+GA
 3641 DATA #4,B AGAF+EF+DC<B>C<BP104G+  AB>C<B>CDCDEF+G
 3642 DATA #5, A2E2  ^B1UP^ F+2   F+GA
 3643 DATA #6,\G \F
 3644 DATA --
 3645 DATA #0, <B1>D2&D4&D8&D16&Dl40 !1 Rl80
 3646 DATA #1,G1G+1>
 3647 DATA #2,L12O4 GGAGBG>C6<B4G G+G+G+G+G+G+G+6F6EG+
 3648 DATA #3,BAB>C<B>CDCDEDC  DC<B>C<BAG+AB>DC<B
 3649 DATA #4,A P24BAB>C<B>CDCDEDC P104DC<B>C<BAG+AB>DC<
 3650 DATA #5, ^B1UP^ B2. A4  G+4&G+6 A12 B>CD<
 3651 DATA #6,\F (N46N30)N46(N46N30)(N46N38)N46(N46N30)P64L24N45N45L12N45N45P24L24N45N45L12N45N45P64
 3652 DATA --
 3653 DATA #0, E1F+1
 3654 DATA #1,C1D1
 3655 DATA #2,L12O4 AAAEAEA6E4G  DDDF+DF+G6F+4D
 3656 DATA #3,L12 >C<B>C<AGAF+EF+DCD  C<B>CDEF+EF+GF+GA
 3657 DATA #4,B L12 P24>C<B>C<AGAF+EF+DCP104D  C<B>CDEF+EF+GF+GP24
 3658 DATA #5, L6 A2  ^B3UP^ >E2 ^B1DN^ D2   EDC<
 3659 DATA #6,\G \F
 3660 DATA --
 3661 DATA #0, D1E1
 3662 DATA #1,<B1>C1
 3663 DATA #2,GGGDGDG6D4F+  CCDCECG6F+4D
 3664 DATA #3,BABGF+GEDEDC<B>  CDEDEF+EF+GF+GB
 3665 DATA #4,A BABGF+GEDEDC<P104B>  CDEDEF+EF+GF+GP24
 3666 DATA #5, B2 ^B3UP^>F+2 ^B1DN^   E2  EDC<
 3667 DATA #6,\F \F
 3668 DATA --
 3669 DATA #0, C1D1
 3670 DATA #1,<A1A1
 3671 DATA #2,<AA>C<A>D<A>E6C4C+  DDEDF+DG6F+4D
 3672 DATA #3,AGAF+EF+DC<B>C<BG+  AB>C<B>CDCDEF+GA
 3673 DATA #4,B AGAF+EF+DC<B>C<BP104G+  AB>C<B>CDCDEF+G
 3674 DATA #5, A2E2 ^B1UP^ F+2 F+GA
 3675 DATA #6,\G \F
 3676 DATA --
 3677 DATA #0, E1&E2@36V10O4F+6D12&D8&D16&Dl40 !1 Rl80 dc
 3678 DATA #1,B1&B2@36V9 O4D6<A12&A4>
 3679 DATA #2,L12O4 EEF+EGEF+6D4D+ EEEEEEA6D&D4
 3680 DATA #3,L12 EAG]2EF+D[2EAG]2EF+G[2 EAG]2EF+D[2EAG]2EF+G[2
 3681 DATA #4,A P64  L12 EAG]2EF+D[2EAG]2EF+G[2  EAG]2EF+D[2EAG]2EF+ [2
 3682 DATA #5, E1&E2R2
 3683 DATA #6,\G N38  N38  N38  N45  N45 N45 (N38'6 N30'6) N493
 3684 '
 3685 '###############################
 3686 '      STAGE 2 BOSS
 3687 '###############################
 3688 DATA SONG 2
 3689 DATA #0, T155 P64@36V10 O4E1&E2D2
 3690 DATA #1, P64@36V9 O3B1&B2A2
 3691 DATA #2, P64@44V11 L12O4EEF+EGEA6D4F+ EEF+EGED6F+4D]2
 3692 DATA #3, @53O6L12V8 L12 EAG]2EF+D[2EAG]2EF+G[2 EAG]2EF+D[2EAG]2EF+G[2
 3693 DATA #4, @53O6L12V7R8 P24 L12 EAG]2EF+D[2EAG]2EF+G[2 P104 L12 EAG]2EF+D[2EAG]2EF+24
 3694 DATA #5, P64@51V8 L48 O2E8F+G+A+>CDE F+G+A+>CDE F+G+A+>CDEE2 O2E8F+G+A+>CDE F+G+A+>CDE F+G+A+>CDEE2
 3695 DATA #7, @116V15 N49'4 L2 N38 N38 N38 N38'4
 3696 DATA --
 3697 DATA #0, E1&E2D2
 3698 DATA #1, B1&B2A2
 3699 DATA #2, L12O4EEF+EGEA6D4F+ EEF+EGED6F+4D
 3700 DATA #3, L12 EAG]2EF+D[2EAG]2EF+G[2 EAG]2EF+D[2EAG]2EF+G[2
 3701 DATA #4, R24G[2 P24 L12 EAG]2EF+D[2EAG]2EF+G[2 P104 L12 EAG]2EF+D[2EAG]2EF+24
 3702 DATA #5, L48 O2E8F+G+A+>CDE F+G+A+>CDE F+G+A+>CDEE2 O2E8F+G+A+>CDE F+G+A+>CDE F+G+A+>CDEE2
 3703 DATA #7, R4 N38N38 L12 N45N45N45 N41N41N41 N38N38N38
 3704 DATA --
 3705 DATA #0, dc @49O3V9 P64 E1D+1
 3706 DATA #1, P64@49O3V8B1>C1
 3707 DATA #2, L12O4 EEF+EGEAEGEF+E F+F+GF+AG+BF+AF+GF+
 3708 DATA #3, L12 EAG]2EF+D[2EAG]2EF+G[2 EAG]2EF+D[2EAG]2EF+G[2
 3709 DATA #4, R24G[2 P24 L12 EAG]2EF+D[2EAG]2EF+G[2 P104 L12 EAG]2EF+D[2EAG]2EF+24
 3710 DATA #5, R16 @49V7 O3E1~65;65;D+2&D+4..
 3711 DATA #7, @116 N49'4 L2 N38 N38 N38 N38'4
 3712 DATA --
 3713 DATA #0, G1F+1
 3714 DATA #1, E1D+1
 3715 DATA #2, GGAGBG>C<GBGAG F+F+GF+AF+GF+EF+ED
 3716 DATA #3, L12 EAG]2EF+D[2EAG]2EF+G[2 EAG]2EF+D[2EAG]2EF+G[2
 3717 DATA #4, R24G[2 P24 L12 EAG]2EF+D[2EAG]2EF+G[2 P104 L12 EAG]2EF+D[2EAG]2EF+24
 3718 DATA #5, R16 G1F+2&F+4..
 3719 DATA #7, R4 N38N38 N38'4 L6 N38 N38 N38
 3720 DATA --
 3721 DATA #0, G1F+1
 3722 DATA #1, D1D+1
 3723 DATA #2, EEF+EGEAEGEF+E F+F+GF+AG+BF+AF+GF+
 3724 DATA #3, L12 EAG]2EF+D[2EAG]2EF+G[2 EAG]2EF+D[2EAG]2EF+G[2
 3725 DATA #4, R24G[2 P24 L12 EAG]2EF+D[2EAG]2EF+G[2 P104 L12 EAG]2EF+D[2EAG]2EF+24
 3726 DATA #5, R16 G1F+2&F+4..
 3727 DATA #7, N49'4 L2 N38 N38 N38 N38'4
 3728 DATA --
 3729 DATA #0, A1F+2.@50V7O4L48 G+G+A A+A+B >CCC+ DDD+
 3730 DATA #1, E1D2.@50V7O4L48D+D+EFFF+GGG+AAA+
 3731 DATA #2, GGAGBG>C<GBGAG F+F+GF+AF+GF+EDC<B
 3732 DATA #3, L12 EAG]2EF+D[2EAG]2EF+G[2 EAG]2EF+D[2EAG]2EF+G[2
 3733 DATA #4, R24G[2 P24 L12 EAG]2EF+D[2EAG]2EF+G[2 P104 L12 EAG]2EF+D[2EAG]2EF+24
 3734 DATA #5, R16 A1F+2&F+8.@50V7O4L48G+G+AA+A+B>CCC+DDD+
 3735 DATA #7, R4 N38N38 N38'4 L12 N38 N38 N38 N38 N38 N38
 3736 DATA --
 3737 DATA #0, L12[2 P24 E6R R4R4 E6 R  P104D6RR4R4D6R
 3738 DATA #1, L12[1 P24B6RR4R4B6R P104A6RR4R4A6R
 3739 DATA #2, ERR12R4R4ERR12 DRR12R4R4DRR12
 3740 DATA #3, L12 EAG]2EF+D[2EAG]2EF+G[2 EAG]2EF+D[2EAG]2EF+G[2
 3741 DATA #4, R24G[2 P24 L12 EAG]2EF+D[2EAG]2EF+G[2 P104 L12 EAG]2EF+D[2EAG]2EF+24
 3742 DATA #5, L6[2 <P24GR4R4R12GR12 P104F+R4R4R12F+R12
 3743 DATA #7, @118P104 O4(E2E2) @116N49'6. @118O4P104(E4E4)P24(D4D4)@116 N49'4 L12 N38N38N38 @118 O4P24(D6.D6.)
 3744 DATA --
 3745 DATA #0, P24E6RR4R4E6R  P104F+6RP24F+6RP64 @49V6O3 L24EFF+GG+AA+B>CC+DD+ dc
 3746 DATA #1, P24B6RR4R4B6R P104>D6RP24D6RP64@49V6O2L24B>CC+DD+EFF+GG+AA+
 3747 DATA #2, ERR12R4R4ERR12 F+RR12F+RR12D2
 3748 DATA #3, L12 EAG]2EF+D[2EAG]2EF+G[2 EAG]2EF+D[2EAG]2EF+G[2
 3749 DATA #4, R24G[2 P24 L12 EAG]2EF+D[2EAG]2EF+G[2 P104 L12 EAG]2EF+D[2EAG]2EF+24
 3750 DATA #5, P24GR4R4R12GR12 P104AR12P24AR12 P64@49V8O3L24 EFF+GG+AA+B>CC+DD+
 3751 DATA #7, P104(E4E4) @116N49'6. R4@118O4P104(E4E4)P24(F+6.F+6.)P104(F+4F+4) @116 L12 N41N41N41 N38N38N38
 3752 DATA ENDSONG
 3753 '
 3754 '###############################
 3755 '      STAGE 3 SONG DATA
 3756 '###############################
 3757 *MS3
 3758 DATA SONG 1
 3759 DATA \A = \L4(N49N30N46)(N49N38N46)L8(N46N49N30)N30L4(N46N49N38)\
 3760 DATA \B = \L4(N46N30)(N49N38)L8 N38 N38 N38 N30\
 3761 DATA \C = \L4(N46N49N30)(N46N49N38) L8(N46N30N49) N30 L16 (N38N45) N45 N45 N45\
 3762 DATA \D = \@116N30N8 L8@117N39N39 L4@116N38 L4 @116N30N8 L8@117N39N39 L4@116N38\
 3763 DATA \E = \L4@116N30 R4 ^N38^L8N38N38N38 N30 L4 N30 N38 L8N30N30 L16 N45N45 N41N41\
 3764 DATA \F = \L4@116N30N38L8N38N38N38 N30 L4 N30 N38 L8N30 @118 O4(P24E8E8E8E8)(P104E4E4E4E4)\
 3765 DATA \G = \L4 @116N30N8 L8N30N30 L4@116N38 L4 @116N30N8 L8N30N30 L4@116N38 \
 3766 DATA --
 3767 DATA #0, T158 dcP64@36V9  O4L8 L8 E2 A~;;&A~64;101;&A~101;101; L8 > D8~64;64;&D2&D8<B>CD<
 3768 DATA #1, P64@36V8  O5L8  C2 E~;;&E~64;107;&E~107;107;   B8~64;64;&B2&B8 G AB
 3769 DATA #2, P64@38V10O3L8AAAA16AA16A16A16AA16A16O3L8AAAA16AA16A16A16AA16A16
 3770 DATA #3, P64@28V9 O4L8 A>EA<A>EA<A>E<GB>D<GB>D<GB
 3771 DATA #4, P104@40V10O6C1<B2R8B4.
 3772 DATA #5, P104@40V10O5E1D2R8D4.
 3773 DATA #6,@116V15\A\A
 3774 DATA #7,\D
 3775 DATA --
 3776 DATA #0, B4.>C4.D4<A2&A8AB>C<
 3777 DATA #1, G4. A4.B4 F2&F8 FG A
 3778 DATA #2, O3L8FFFF16FF16F16F16FF16F16O3L8FFFF16FF16F16F16FF16F16
 3779 DATA #3, F>CF<F>CF<F>C<F>CF<F>CF<F>C<
 3780 DATA #4, B4.A8&A1.
 3781 DATA #5, D4.C8&C1.
 3782 DATA #6,\A\A
 3783 DATA #7,\D
 3784 DATA --
 3785 DATA #0, B4.G8&G2 B4G4G8A4 E1&E1&E16&El30 !1Rl90
 3786 DATA #1, G4.D8&D2 G4D4D8F4C8&C1<G+1>
 3787 DATA #2, O3L8GGGG16GG16G16G16GG16G16O3L8GGGG16GG16G16G16GG16G16O4L8CCCC16CC16C16C16CC16C16O3L8EEEE16EE16E16E16EE16E16
 3788 DATA #3, L8 GB>D<GB>D<GBGAB>CL16DEFGFEDG<L8 EG>C<EG>E<EG+EG+BEG+BEG+
 3789 DATA #4, B1B2R4R8 >C8&C2.. E1R8
 3790 DATA #5, D1D2R4R8E8&E2..G+1R8
 3791 DATA #6,\A\A\A\A
 3792 DATA #7,\D\D
 3793 DATA --
 3794 DATA #0, L8 E2 A~;;&A~64;101;&A~101;101; L8 > D8~64;64;&D2&D8<B>CD<B4.>C4.D4<A2&A8AB>C<
 3795 DATA #1, C2E>C4<B8&B2&B8 G ABG4. A4.B4 F2&F8FG A
 3796 DATA #2, O3L8AAAA16AA16A16A16AA16A16O3L8AAAA16AA16A16A16AA16A16O3L8FFFF16FF16F16F16FF16F16O3L8FFFF16FF16F16F16FF16F16
 3797 DATA #3, L8 A>EA<A>EA<A>E<GB>D<GB>D<GB F>CF<F>CF<F>C<F>CF<F>CF<F>C<
 3798 DATA #4, C1<B2R8B4.B4.A8&A1.
 3799 DATA #5, E1D2R8D4.&D4.C8&C1.
 3800 DATA #6,\A\A\A\A
 3801 DATA #7,\D\D
 3802 DATA --
 3803 DATA #0, B4.G8&G2B4G4G8B4A8&A1.R8AAG16&Gl30 !1 Rl90
 3804 DATA #1, G4.D8&D2G4D4D8G4E8&E1&E1
 3805 DATA #2, O3L8GGGG16GG16G16G16GG16G16O3L8GGGG16GG16G16G16GG16G16O3L8AAAA16AA16A16A16AA16A16O3L8AAAA16AA16A16A16AA16A16
 3806 DATA #3, GB>D<GB>D<GBGAB>CL16DEFGFED<GL8A>EA<A>EA<A>E<A>EA<A>EA<L16AB>C<A
 3807 DATA #4, B1B2R4R8  A8&A2.. A1R8
 3808 DATA #5, D1D2R4R8E8&E2..E1R8
 3809 DATA #6,\A\A\A\A
 3810 DATA #7,\D\D
 3811 DATA --
 3812 DATA #0, L8 A8 R8 A4 R8 A8 A8 B4 B16B16 B8B16B16 B8B16B16 B8B16B16
 3813 DATA #1, L8 F8R8F4 R8F8F8  G4G16G16 G8G16G16 G8G16G16 G8G16G16
 3814 DATA #2, O4L8D8R8 D4DDDG4GGGGGGG
 3815 DATA #3, P64@37V10 L24A>DAR8<A4 L8A>DA<G4B>DGD<G>DG<
 3816 DATA #4, P104@41V8 O6A8R8A2&A8B1R8
 3817 DATA #5, P24@41V8O6F8R8F2&F8G1R8
 3818 DATA #6,\B\C
 3819 DATA #7,\E
 3820 DATA --
 3821 DATA #0, B8R8B4R8B8B8>C4C16C16 C8C16C16 C8C16C16 C8C16C16<
 3822 DATA #1, G8R8G4R8G8G8 A4A16A16 A8A16A16 A8A16A16 A8A16A16
 3823 DATA #2, O4L8E8R8 E4EEEA4AAAAAAA
 3824 DATA #3, L24GB>GR8<G4 L8GB>G<A4>CEAE<A>CA<
 3825 DATA #4, G8R8G2&G8>C1R8<
 3826 DATA #5, E8R8E2&E8A1R8
 3827 DATA #6,\B\C
 3828 DATA #7,\E
 3829 DATA --
 3830 DATA #0, L8 A8 R8 A4 R8 A8 A8 B4 B16B16 B8B16B16 B8B16B16 B8B16B16
 3831 DATA #1, L8 F8R8F4 R8F8F8  G4G16G16 G8G16G16 G8G16G16 G8G16G16
 3832 DATA #2, O4L8D8R8 D4DDDG4GGGGGGG
 3833 DATA #3, L24A>DAR8<A4 L8A>DA<G4B>DGD<G>DG<
 3834 DATA #4, A8R8A2&A8B1R8
 3835 DATA #5, F8R8F2&F8G1R8
 3836 DATA #6,\B\C
 3837 DATA #7,\E
 3838 DATA --
 3839 DATA #0, B8R8B4R8B8B8>E4E16E16 E8E16E16 E8E16E16 E8E16El30 !1Rl90
 3840 DATA #1, G8R8G4R8G8G8 G+4G+16G+16 G+8G+16G+16 G+8G+16G+16 G+8G+16G+16
 3841 DATA #2, O4L8E8R8 E4EEEE4EEEEEEE
 3842 DATA #3, L24GB>GR8<G4 L8GB>G<G+4B>EG+E<G+B>G+<
 3843 DATA #4, G8R8G2&G8G+1R8
 3844 DATA #5, E8R8E2&E8E1R8
 3845 DATA #6,\B\C
 3846 DATA #7,\F
 3847 DATA --
 3848 DATA #0, P64@37V10O5 L8 R4L4AB>C<L6B>CDC<BA
 3849 DATA #1, L8[2 EA>E~43;43;&E16~43;64;&E16~64;64;&E2~;;L16 E<AA>D<AA>C<AA>D<AA>E<AB>C<
 3850 DATA #2, O3L8AAAA16AA16A16A16AA16A16O3L8AAAA16AA16A16A16AA16A16
 3851 DATA #3, V8P84  R4~65;65;L4EGAL6GABAGE
 3852 DATA #4, @37V8P44 O5R4L4EGAL6GABAGE
 3853 DATA #5, @37V9 O4O5R4L4AB>C<L6B>CDC<BA
 3854 DATA #6,\A\A
 3855 DATA #7,\G
 3856 DATA --
 3857 DATA #0, L8 R4L4AB>C<L6B>CDC<BA
 3858 DATA #1, L8 EA>E~43;43;&E16~43;64;&E16~64;64;&E2~;;L16 E<AA>D<AA>C<AA>D<AA>E<AB>C<
 3859 DATA #2, O3L8GGGG16GG16G16G16GG16G16O3L8GGGG16GG16G16G16GG16G16
 3860 DATA #3, R4L4EGAL6GABAGE
 3861 DATA #4, R4L4EGAL6GABAGE
 3862 DATA #5, R4L4AB>C<L6B>CDC<BA
 3863 DATA #6,\A\A
 3864 DATA #7,\G
 3865 DATA --
 3866 DATA #0, L8 R4L4AB>C<L6B>CDC<B>C
 3867 DATA #1, L8 EA>E~43;43;&E16~43;64;&E16~64;64;&E2~;;L16 E<AA>D<AA>C<AA>D<AA>E<AB>C<
 3868 DATA #2, O3L8FFFF16FF16F16F16FF16F16O3L8FFFF16FF16F16F16FF16F16
 3869 DATA #3, R4L4FGAL6GABAGA
 3870 DATA #4, R4L4FGAL6GABAGA
 3871 DATA #5, L8 R4L4AB>C<L6B>CDC<B>C
 3872 DATA #6,\A\A
 3873 DATA #7,\G
 3874 DATA --
 3875 DATA #0, D2<B>CDE2&E4&E8&E16&El30 !1 Rl90 <
 3876 DATA #1, L8 EA->E~43;43;&E16~43;64;&E16~64;64;&E2~;;L16E<A-A->D<A-A->C<A-A->D<A-A->E<A-B>D<
 3877 DATA #2, O3L8EEEE16EE16E16E16EE16E16O3L8EEEE16EE16E16E16EE16E16
 3878 DATA #3, G+2G+G+G+G+1
 3879 DATA #4, G+2G+G+G+G+1
 3880 DATA #5, D2<B>CDE1<
 3881 DATA #6,\A\A
 3882 DATA #7,\G
 3883 DATA --
 3884 DATA #0, L8 R4L4AB>C<L6B>CDC<BA
 3885 DATA #1, L8 EA>E~43;43;&E16~43;64;&E16~64;64;&E2~;;L16 E<AA>D<AA>C<AA>D<AA>E<AB>C<
 3886 DATA #2, O3L8AAAA16AA16A16A16AA16A16O3L8AAAA16AA16A16A16AA16A16
 3887 DATA #3, R4L4EGAL6GABAGE
 3888 DATA #4, R4L4EGAL6GABAGE
 3889 DATA #5, R4L4AB>C<L6B>CDC<BA
 3890 DATA #6,\A\A
 3891 DATA #7,\G
 3892 DATA --
 3893 DATA #0, L8 R4L4AB>C<L6B>CDC<BA
 3894 DATA #1, L8 EA>E~43;43;&E16~43;64;&E16~64;64;&E2~;;L16 E<AA>D<AA>C<AA>D<AA>E<AB>C<
 3895 DATA #2, O3L8GGGG16GG16G16G16GG16G16O3L8GGGG16GG16G16G16GG16G16
 3896 DATA #3, R4L4EGAL6GABAGE
 3897 DATA #4, R4L4EGAL6GABAGE
 3898 DATA #5, R4L4AB>C<L6B>CDC<BA
 3899 DATA #6,\A\A
 3900 DATA #7,\G
 3901 DATA --
 3902 DATA #0, L8 R4L4AB>C<L6B>CDC<B>C
 3903 DATA #1, L8 EA>E~43;43;&E16~43;64;&E16~64;64;&E2~;;L16 E<AA>D<AA>C<AA>D<AA>E<AB>C<
 3904 DATA #2, O3L8FFFF16FF16F16F16FF16F16O3L8FFFF16FF16F16F16FF16F16
 3905 DATA #3, R4L4FGAL6GABAGA
 3906 DATA #4, R4L4FGAL6GABAGA
 3907 DATA #5, L8 R4L4AB>C<L6B>CDC<B>C
 3908 DATA #6,\A\A
 3909 DATA #7,\G
 3910 DATA --
 3911 DATA #0, D2<B>CDE2DC<B
 3912 DATA #1, L8 EA->E~43;43;&E16~43;64;&E16~64;64;&E2~;;L16E<A-A->D<A-A->C<A-A->D<A-A->E<A->C<B
 3913 DATA #2, O3L8EEEE16EE16E16E16EE16E16O3L8EEEE16EE16E16E16EE16E16
 3914 DATA #3, G+2G+G+G+G+1
 3915 DATA #4, G+2G+G+G+G+1
 3916 DATA #5, D2<B>CDE2L8R8DC<B
 3917 DATA #6,\A\A
 3918 DATA #7,\G
 3919 DATA --
 3920 DATA #0, A1R1
 3921 DATA #1, A1R1
 3922 DATA #2, O3L8AAAA16AA16A16A16AA16A16O3L8AAAA16AA16A16A16AA16A16
 3923 DATA #3, E1R1
 3924 DATA #4, E1R1
 3925 DATA #5, A1P64@38V8 O3L8AAAA16AA16A16A16AA16A16
 3926 DATA #6,\A\A
 3927 DATA #7,\G
 3928 DATA --
 3929 DATA #0, R1R2R4R8R16Rl30 !1 Rl90 dc
 3930 DATA #1, R1R1
 3931 DATA #2, O3L8AAAA16AA16A16A16AA16A16O3L8AAAA16AA16A16A16AA16A16
 3932 DATA #3, R1&R1
 3933 DATA #4, R1&R1
 3934 DATA #5, O3L8AAAA16AA16A16A16AA16A16O3L8AAAA16AA16A16A16AA16A16
 3935 DATA #6,\A\A
 3936 DATA #7,\G
 3937 '
 3938 '###############################
 3939 '      STAGE 3 BOSS
 3940 '###############################
 3941 DATA SONG 2
 3942 DATA \A = \L16 P24EP64AP104B>P64DP24C<P64B>P104C<P64A P24B>P64CP104D<P64B>P24CP64DP104EP64C<\
 3943 DATA \B = \L16 P24EP64G+P104B>P64DP24C<P64B>P104C<P64G+ P24B>P64CP104D<P64B>P24CP64DP104EP64C<\
 3944 DATA \C = \L16 P24DP64GP104B>P64DP24C<P64B>P104C<P64D P24B>P64CP104D<P64B>P24CP64D<P104BP64G\
 3945 DATA \a = \L4(N49N30N46)(N49N38N46)L8(N46N49N30)N30L4(N46N49N38)\
 3946 DATA \b = \L8 (N30N46)(N30N46)(N38N46)(N30N46)(N30N46)(N30N46)(N38N46)(N30N46)\
 3947 DATA \c = \L8 (N30N49N46)(N30N46)(N38N49N46)(N30N46)(N30N49N46)(N30N46)(N46N38N49)(N46N30)\
 3948 DATA \d = \L4(N49N46N30)(N46N49N38) L8(N49N46N30)N30 L4(N49N46N38)\
 3949 DATA --
 3950 DATA #0, T158 P64@36V10O4 E1 T160 F1
 3951 DATA #1, P64@46V11O4C3~64;127;1280 &C3 C3~64;127;1280&C3 C3~64;127;1280&C3
 3952 DATA #2, P64@38V11 O3L8AAAA16AA16A16A16AA16A16 O3L8AAAA16AA16A16A16AA16A16
 3953 DATA #3, P64@36V9 O4 C1C+1
 3954 DATA #4, R16P24@46V10O4C3~64;127;1280 &C3 C3~64;127;1280&C3 Cl1160~64;127;1160
 3955 DATA #5, R16P104@36V8O4 C1C+2&C+4..
 3956 DATA #6, @116 L8 \a\a
 3957 DATA --
 3958 DATA #0, T163 F+1 T166 G1 T170
 3959 DATA #1, C3~64;127;1280&C3 C3~64;127;1280&C3 C3~64;127;1280&C3
 3960 DATA #2, O3L8AAAA16AA16A16A16AA16A16 O3L8AAAA16AA16A16A16AA16A16
 3961 DATA #3, D1D+1
 3962 DATA #4, R16C3~64;127;1280&C3 C3~64;127;1280&C3 Cl1160~64;127;1160
 3963 DATA #5, R16D1D+2&D+4..
 3964 DATA #6, \d L16(N49N30N38N46) N38N38N38 (N49N38N46)N38N38N38  (N49N30N38N46) N38N38N38  (N46N49N38) N38N38N38
 3965 DATA --
 3966 DATA #0, dc @45V8O6  \A\A
 3967 DATA #1, P64@36V10O4 A4.~64;;E4.A4>E-4.D4.C4<
 3968 DATA #2, P64@47V11L8AAAEA>EDC<AAAEA>EDC<
 3969 DATA #3, P64@36V9 O4 E4.C4.E4>C4.<B4.A4
 3970 DATA #4, P24@36V7 O4 R16A4.~65;65;E4.A4>E-4.D4.C8.<
 3971 DATA #5, R16P104@36V8O4 E4.~65;65;C4.E4>C4.<B4.A8.
 3972 DATA #6, \b \b
 3973 DATA --
 3974 DATA #0, \A\A
 3975 DATA #1, B4.>C4.<B4A4.B4.>C4
 3976 DATA #2, L8AAAEA>EDC<AAAEA>EDC<
 3977 DATA #3, G4. A4. G4E4.G4. A4
 3978 DATA #4, R16B4.>C4.<B4A4.B4.>C8.
 3979 DATA #5, R16G4. A4. G4E4.G4. A8.
 3980 DATA #6, \b \b
 3981 DATA --
 3982 DATA #0, \A\A
 3983 DATA #1, L8 <E-EFGFEE-EFGAB-AGAG
 3984 DATA #2, L8AAAEA>EDC<AAAEA>EDC<
 3985 DATA #3,   L8<A4>CC<A4>CC<A4>CC<A4>CC<
 3986 DATA #4, R16L8 <E-EFGFEE-EFGAB-AGAG16
 3987 DATA #5, R16L8<A4>CC<A4>CC<A4>CC<A4>C<
 3988 DATA #6, \b \b
 3989 DATA --
 3990 DATA #0, \A\A
 3991 DATA #1, E-EFGFEE-EFGAB-AGAG
 3992 DATA #2, L8AAAEA>EDC<AAAEA>EDC<
 3993 DATA #3, A4>CC<A4>CC<A4>CC<A4>CC
 3994 DATA #4, R16E-EFGFEE-EFGAB-AGAG16
 3995 DATA #5, R16A4>CC<A4>CC<A4>CC<A4>C
 3996 DATA #6, \b \b
 3997 DATA --
 3998 DATA #0, \A\A
 3999 DATA #1, A4.E4.A4>E-4.D4.C4<
 4000 DATA #2, L8AAAEA>EDC<AAAEA>EDC<
 4001 DATA #3, E4.C4.E4>C4.<B4.A4
 4002 DATA #4, R16A4.E4.A4>E-4.D4.C8.<
 4003 DATA #5, R16E4.C4.E4>C4.<B4.A8.
 4004 DATA #6, \b \b
 4005 DATA --
 4006 DATA #0, \A\A
 4007 DATA #1, B4.>C4.<B4A4.B4.>C4
 4008 DATA #2, L8AAAEA>EDC<AAAEA>EDC<
 4009 DATA #3, G4. A4. G4E4.G4. A4
 4010 DATA #4, R16B4.>C4.<B4A4.B4.>C8.
 4011 DATA #5, R16G4. A4. G4E4.G4. A8.
 4012 DATA #6, \b \b
 4013 DATA --
 4014 DATA #0, \A\A
 4015 DATA #1, L8 <E-EFGFEE-EFGAB-AGAG
 4016 DATA #2, L8AAAEA>EDC<AAAEA>EDC<
 4017 DATA #3, L8<A4>CC<A4>CC<A4>CC<A4>CC<
 4018 DATA #4, R16L8 <E-EFGFEE-EFGAB-AGAG16
 4019 DATA #5, R16L8<A4>CC<A4>CC<A4>CC<A4>C<
 4020 DATA #6, \b \b
 4021 DATA --
 4022 DATA #0, \A\A
 4023 DATA #1, E-EFGFEE-EFGAB-AGAG
 4024 DATA #2, L8AAAEA>EDC<AAAEA>EDC<
 4025 DATA #3, A4>CC<A4>CC<A4>CC<A4>CC
 4026 DATA #4, R16E-EFGFEE-EFGAB-AGAG16
 4027 DATA #5, R16A4>CC<A4>CC<A4>CC<A4>C
 4028 DATA #6, \b \b
 4029 DATA --
 4030 DATA #0, @36V10O4 F8]4P24F4[4P104G4]4P24G4[4P104R8 A8]4P24A4[4P104B4]4P24B4[4P104R8
 4031 DATA #1, A8]4P104A4[4P24 B4]4P104B4[4P24R8 >C8]4P104C4[4P24D4]4P104D4[4P24R8
 4032 DATA #2, L8FFFAFAB>C<FFFAFAB>C<
 4033 DATA #3, D8]4D4[4E4]4E4[4R8 F8]4F4[4G4]4G4[4R8
 4034 DATA #4, R16A8]4P104A4[4P24 B4]4P104B4[4P24R8 >C8]4P104C4[4P24D4]4P104D4[4P24R16
 4035 DATA #5, R16D8]4D4[4E4]4E4[4R8 F8]4F4[4G4]4G4[4R16
 4036 DATA #6, \b \b
 4037 DATA --
 4038 DATA #0, A8]4P24A4[4P104G4]4P24G4[4P104R8 A8]4P24A4[4P104A4  G8F8E8
 4039 DATA #1, C8]4P104C4[4P24<B4]4P104B4[4P24R8 >C8]4P104C4[4P24C4 <B8A8G8
 4040 DATA #2, L8FFFAFAB>C<FFFAFAB>C<
 4041 DATA #3, F8]4F4[4E4]4E4[4R8 F8]4F4[4F4E8D8C8
 4042 DATA #4, R16C8]4P104C4[4P24<B4]4P104B4[4P24R8 >C8]4P104C4[4P24C4 <B8A8G16
 4043 DATA #5, R16F8]4F4[4E4]4E4[4R8 F8]4F4[4F4E8D8C16
 4044 DATA #6, \b \b
 4045 DATA --
 4046 DATA #0, @45V8O6 \A\A
 4047 DATA #1, P64 A4.E4.A4>E-4.D4.C4<
 4048 DATA #2, L8AAAEA>EDC<AAAEA>EDC<
 4049 DATA #3, E4.C4.E4>C4.<B4.A4
 4050 DATA #4, R16P24 A4.E4.A4>E-4.D4.C8.<
 4051 DATA #5, R16E4.C4.E4>C4.<B4.A8.
 4052 DATA #6, \b \b
 4053 DATA --
 4054 DATA #0, \A\A
 4055 DATA #1, B4.>C4.<B4A4.B4.>C4<
 4056 DATA #2, L8AAAEA>EDC<AAAEA>EDC<
 4057 DATA #3, G4. A4. G4E4.G4. A4
 4058 DATA #4, R16B4.>C4.<B4A4.B4.>C8.<
 4059 DATA #5, R16G4. A4. G4E4.G4. A8.
 4060 DATA #6, \b \b
 4061 DATA --
 4062 DATA #0, @36V10O4P64 F8]4P24F4[4P104G4]4P24G4[4P104R8 A8]4P24A4[4P104B4]4P24B4[4P104R8
 4063 DATA #1, A8]4P104A4[4P24 B4]4P104B4[4P24R8 >C8]4P104C4[4P24D4]4P104D4[4P24R8
 4064 DATA #2, L8FFFAFAB>C<FFFAFAB>C<
 4065 DATA #3, D8]4D4[4E4]4E4[4R8 F8]4F4[4G4]4G4[4R8
 4066 DATA #4, R16A8]4P104A4[4P24 B4]4P104B4[4P24R8 >C8]4P104C4[4P24D4]4P104D4[4P24R16
 4067 DATA #5, R16D8]4D4[4E4]4E4[4R8 F8]4F4[4G4]4G4[4R16
 4068 DATA #6, \b \b
 4069 DATA --
 4070 DATA #0, A8]4P24A4[4P104G4]4P24G4[4P104R8 A8]4P24A4[4P104A4  G8A8B8
 4071 DATA #1, C8]4P104C4[4P24<B4]4P104B4[4P24R8 >C8]4P104C4[4P24C4 <B8>C8D8
 4072 DATA #2, L8FFFAFAB>C<FFFAFAB>C<
 4073 DATA #3, F8]4F4[4E4]4E4[4R8 F8]4F4[4F4E8F8G8
 4074 DATA #4, R16C8]4P104C4[4P24<B4]4P104B4[4P24R8 >C8]4P104C4[4P24C4 <B8>C8D16
 4075 DATA #5, R16F8]4F4[4E4]4E4[4R8 F8]4F4[4F4E8F8G16
 4076 DATA #6, \b \b
 4077 DATA --
 4078 DATA #0, @45V8O6\B\B
 4079 DATA #1, P64E4.F4.E4D4.C4.<B4>
 4080 DATA #2, L8EEEBE>DC<BEEEBE>DC<B
 4081 DATA #3, G+4.B4.G+4A4.A4.G+4
 4082 DATA #4, R16P24 E4.F4.E4D4.C4.<B8.>
 4083 DATA #5, R16G+4.B4.G+4A4.A4.G+8.
 4084 DATA #6, \b \b
 4085 DATA --
 4086 DATA #0, \B\B
 4087 DATA #1, E4.F4.G4G+1
 4088 DATA #2, L8EEEBE>DC<BEEEBE>DC<B
 4089 DATA #3, B4.>C4.D4E1
 4090 DATA #4, R16E4.F4.G4G+2&G+4&G+8.
 4091 DATA #5, R16B4.>C4.D4E2&E4..
 4092 DATA #6, \b \b
 4093 DATA --
 4094 DATA #0, \A\A
 4095 DATA #1, P64@37V11O5L16 AEAEAR16AEAEAR16AG+GF+AEAEAR16AEAEAR16AG+GF+
 4096 DATA #2, L8AAAEA>EDC<AAAEA>EDC<
 4097 DATA #3, P64@37V10O5 L16ECECER16ECECER16ED+DC+L16ECECER16ECECER16ED+DC+
 4098 DATA #4, P24@37V8O5 L16 R AEAEAR16AEAEAR16AG+GF+AEAEAR16AEAEAR16AG+G
 4099 DATA #5, P64@37V8O5 L16 R ECECER16ECECER16ED+DC+L16ECECER16ECECER16ED+D
 4100 DATA #6, \c \c
 4101 DATA --
 4102 DATA #0, \A\A
 4103 DATA #1, GDGDGR16GDGDGR16GF+FE GDGDGR16GDGDGR16GF+FE
 4104 DATA #2, L8GGGBG>DC<BGGGBG>DC<B
 4105 DATA #3, D<B>D<B>DR16D<B>D<B>DR16DC+C<B> D<B>D<B>DR16D<B>D<B>DR16DC+C<B>
 4106 DATA #4, F+ GDGDGR16GDGDGR16GF+FE GDGDGR16GDGDGR16GF+F
 4107 DATA #5, C+ D<B>D<B>DR16D<B>D<B>DR16DC+C<B> D<B>D<B>DR16D<B>D<B>DR16DC+C<
 4108 DATA #6, \c \c
 4109 DATA --
 4110 DATA #0, \C\C
 4111 DATA #1, FCFCFR16FCFCFR16FGAF  FCFCFR16FCFCFR16FGAF
 4112 DATA #2, L8FFFAFAB>C<FFFAFAB>C<
 4113 DATA #3, C<A>C<A>CR16C<A>C<A>CR16CDFCC<A>C<A>CR16C<A>C<A>CR16CDFC
 4114 DATA #4, E FCFCFR16FCFCFR16FGAF  FCFCFR16FCFCFR16FGA
 4115 DATA #5, B> C<A>C<A>CR16C<A>C<A>CR16CDFCC<A>C<A>CR16C<A>C<A>CR16CDF
 4116 DATA #6, \c \c
 4117 DATA --
 4118 DATA #0, \C\C
 4119 DATA #1, GDGDGR16GDGDGR16GABG  GDGDGR16GDGDGR16GABG
 4120 DATA #2, L8GGGBG>DC<BGGGBG>DC<B
 4121 DATA #3, D<B>D<B>DR16D<B>D<B>DR16DFGDD<B>D<B>DR16D<B>D<B>DR16DFGD
 4122 DATA #4, F GDGDGR16GDGDGR16GABG  GDGDGR16GDGDGR16GAB
 4123 DATA #5, C D<B>D<B>DR16D<B>D<B>DR16DFGDD<B>D<B>DR16D<B>D<B>DR16DFG
 4124 DATA #6, \c \c
 4125 DATA --
 4126 DATA #0, \A\A
 4127 DATA #1, AEAEAR16AEAEAR16AG+GF+AEAEAR16AEAEAR16AG+GF+
 4128 DATA #2, L8AAAEA>EDC<AAAEA>EDC<
 4129 DATA #3, L16ECECER16ECECER16ED+DC+L16ECECER16ECECER16ED+DC+
 4130 DATA #4, G AEAEAR16AEAEAR16AG+GF+AEAEAR16AEAEAR16AG+G
 4131 DATA #5, D L16ECECER16ECECER16ED+DC+L16ECECER16ECECER16ED+D
 4132 DATA #6, \c \c
 4133 DATA --
 4134 DATA #0, \A\A
 4135 DATA #1, GDGDGR16GDGDGR16GF+FE GDGDGR16GDGDGR16GF+FE
 4136 DATA #2, L8GGGBG>DC<BGGGBG>DC<B
 4137 DATA #3, D<B>D<B>DR16D<B>D<B>DR16DC+C<B> D<B>D<B>DR16D<B>D<B>DR16DC+C<B>
 4138 DATA #4, F+ GDGDGR16GDGDGR16GF+FE GDGDGR16GDGDGR16GF+F
 4139 DATA #5, C+ D<B>D<B>DR16D<B>D<B>DR16DC+C<B> D<B>D<B>DR16D<B>D<B>DR16DC+C<
 4140 DATA #6, \c \c
 4141 DATA --
 4142 DATA #0, \C\C
 4143 DATA #1, FCFCFR16FCFCFR16FGAF  FCFCFR16FCFCFR16FGAF
 4144 DATA #2, L8FFFAFAB>C<FFFAFAB>C<
 4145 DATA #3, C<A>C<A>CR16C<A>C<A>CR16CDFCC<A>C<A>CR16C<A>C<A>CR16CDFC
 4146 DATA #4, E FCFCFR16FCFCFR16FGAF  FCFCFR16FCFCFR16FGA
 4147 DATA #5, B> C<A>C<A>CR16C<A>C<A>CR16CDFCC<A>C<A>CR16C<A>C<A>CR16CDF
 4148 DATA #6, \c \c
 4149 DATA --
 4150 DATA #0, \C\C
 4151 DATA #1, GDGDGR16GDGDGR16GABG  GDGDGR16GDGDGR16GABG
 4152 DATA #2, L8GGGBG>DC<BGGGBG>DC<B
 4153 DATA #3, D<B>D<B>DR16D<B>D<B>DR16DFGDD<B>D<B>DR16D<B>D<B>DR16DFGD
 4154 DATA #4, F GDGDGR16GDGDGR16GABG  GDGDGR16GDGDGR16GAB  ^G^
 4155 DATA #5, C D<B>D<B>DR16D<B>D<B>DR16DFGDD<B>D<B>DR16D<B>D<B>DR16DFG ^D^
 4156 DATA #6, \c \c
 4157 DATA --
 4158 DATA #0, \A\A
 4159 DATA #1, P64L24AA+B>CC+DP74D+EFF+GG+P84AA+B>CC+DP94D+EFF+GG+P104AA+B>CC+DP94D+EFF+GG+P84AG+GF+FEP74D+DC+C<BA+
 4160 DATA #2, L8AAAEA>EDC<AAAEA>EDC<
 4161 DATA #3, P64L24EFF+GG+AP74A+B>CC+DD+P84EFF+GG+AP94A+B>CC+DD+P104EFF+GG+AP94A+B>CC+DD+P84ED+DC+C<BP74A+AG+GF+F
 4162 DATA #4, P64L24RAA+B>CC+DP74D+EFF+GG+P84AA+B>C C+DP94D+EFF+GG+P104AA+B>CC+DP94D+E FF+GG+ P84 AG+GF+ FEP74D+D C+C<B
 4163 DATA #5, P64L24REFF+GG+AP74A+B>CC+DD+P84EFF+GG+AP94A+B>CC+DD+P104EFF+GG+AP94A+B >CC+DD+ P84 ED+DC+C<BP74A+AG+GF+
 4164 DATA #6, \c \c
 4165 DATA --
 4166 DATA #0, \A\A dc
 4167 DATA #1, P64AG+GF+FEP54D+DC+C<BA+ P44 AG+GF+FEP34D+DC+C<BA+P24AA+B>CC+DP34D+EFF+GG+P44AA+B>CC+DP54D+EFF+GG+
 4168 DATA #2, L8AAAEA>EDC<AAAEA>EDC<
 4169 DATA #3, P64ED+DC+C<BP54A+AG+GF+F P44 ED+DC+C<BP34A+AG+GF+FP24EFF+GG+AP34A+B>CC+DD+P44EFF+G G+AP54A+B>CC+DD+
 4170 DATA #4, A+P64AG+GF+FEP54D+DC+C<BA+P44AG+GF+ FEP34D+DC+C<BA+P24AA+B>CC+DP34D+E FF+GG+P44AA+B>C C+DP54D+E FF+G ^G+^
 4171 DATA #5, FP64ED+DC+C<BP54A+AG+GF+FP44 ED+DC+C<BP34A+AG+GF+FP24EFF+GG+AP34A+B>CC+DD+P44EFF+G G+AP54A+B>CC+D ^D+^
 4172 DATA #6, \c \c
 4173 DATA ENDSONG
 4174 '
 4175 '###############################
 4176 '      STAGE 4 SONG DATA
 4177 '###############################
 4178 *MS4
 4179 DATA SONG 1
 4180 DATA \A = \L8(N30N46) N46 (N38N46) N46 (N30N46) (N30N46) (N38N46) N46\
 4181 DATA \B = \L8(N30N46) N46 (N38N46) (N30N46) N46 N46 (N38N46) N46\
 4182 DATA --
 4183 DATA #0,T168R1&R1R1&R1
 4184 DATA #1,P64@27O3V8  L8 O3AAAAAAAAGGGGGGGGFFFFFFFFEEEEEEEE
 4185 DATA #2,P64@27O3V10 L8 O3AAAAAAAAGGGGGGGGFFFFFFFFEEEEEEEE
 4186 DATA #3,R1&R1R1&R1
 4187 DATA #4,R1&R1R1&R1
 4188 DATA #6,@116\A \A \A \A
 4189 DATA --
 4190 DATA #0,dc P64@25O5V11 L8A2&A8B>C<B& B2&B8>CDE&   E1&           E2&E8DE4
 4191 DATA #1,@25O5V10 L8C2&C8DED&  D2&D8EFG&  G1&          G2&G8GG4
 4192 DATA #2,L8 O3AAAA A16A16AAA GGGGG16G16GGG >CCCCCCC<G16A16 >CCCCC16C16<GA>C
 4193 DATA #3,P104V9 @28O6 q2L8 ACEA ECAC G<B>DGD<B>G<B> G<G>CGE<G>G<G> G<G>CGE<G>G<G>
 4194 DATA #4,P24V9 @28O6q2L8 ACEA ECAC G<B>DGD<B>G<B> G<G>CGE<G>G<G> G<G>CGE<G>G<G>
 4195 DATA #6,\A \A \A \A
 4196 DATA --
 4197 DATA #0,F2.ED         E4D4C4<B4    L8>C4DE&E2&   E1
 4198 DATA #1,>D4C4<B4A4   G+2E4G+4   L8A4B>C&C2&  C1
 4199 DATA #2,<BBBBB16B16BBB >EEE<B16>D16E<B>D16E16<B L8 AAAAAAAA GGGG16G16GGG16>G16<G
 4200 DATA #3,F<B>DAF<B>D<B> E<G+B>E<BG+>E<G+> q2L8 ACEAECAE ACEAECAE
 4201 DATA #4,F<B>DAF<B>D<B> E<G+B>E<BG+>E<G+> q2L8 ACEAECAE ACEAECAE
 4202 DATA #6,\A \A \A \A
 4203 DATA --
 4204 DATA #0,D2.C<B>       C4<F+4A4>C4  C<BAB&B2      >DC<B>E&E4&E8&E16&El40 !1 Rl80<
 4205 DATA #1,<A2.G4       F+4D4F+4A4 G4.D4.G4     G+4.G+2&G+8
 4206 DATA #2,F+F+F+F+F+16F+16F+F+F+ >DDDDD16D16<DEF+ GGGGG16G16GGG G+G+G+E&E8EEE
 4207 DATA #3,A<A>DAF+<A>A<A> F+<A>DAF+<A>D<A> GD<B>GDGD<B> G+<B>EBG+<B>E<B>
 4208 DATA #4,A<A>DAF+<A>A<A> F+<A>DAF+<A>D<A> GD<B>GDGD<B> G+<B>EBG+<B>E<B>
 4209 DATA #6,\A \A \A L4 N30 N38 L8 N30 L16 N38 N38 N48 N48 N45 N45
 4210 DATA --
 4211 DATA #0,L8A2&A8B>C<B& B2&B8>CDE&   E1&           E2&E8DE4
 4212 DATA #1,L8C2&C8DED&  D2&D8EFG&  G1&          G2&G8GG4
 4213 DATA #2,L8 O3AAAA A16A16AAA GGGGG16G16GGG >CCCCCCC<G16A16 >CCCCC16C16<GA>C
 4214 DATA #3,q2L8 ACEA ECAC G<B>DGD<B>G<B> G<G>CGE<G>G<G> G<G>CGE<G>G<G>
 4215 DATA #4,q2L8 ACEA ECAC G<B>DGD<B>G<B> G<G>CGE<G>G<G> G<G>CGE<G>G<G>
 4216 DATA #6,\A \A \A \A
 4217 DATA --
 4218 DATA #0,F2.ED         E4D4C4<B4    A1&           A2.R8R16R32 !1 R32
 4219 DATA #1,>D4C4<B4A4   G+2E4G+4   E1&          E2.R4
 4220 DATA #2,<BBBBB16B16BBB >EEE<B16>D16E<B>D16E16<B AAAAAAAE16G16 AAAAA>G16A16<G>G<
 4221 DATA #3,F<B>DAF<B>D<B> E<G+B>E<BG+>E<G+> q2L8 ACEAECAC ACEA>C<AEC
 4222 DATA #4,F<B>DAF<B>D<B> E<G+B>E<BG+>E<G+> q2L8 ACEAECAC ACEA>C<AEC
 4223 DATA #6,\A \A \A (N30N46)(N30N46)(N38N46) N46 (N30N46) L16 N38 N38 N38 N38 N48 N48 L8
 4224 DATA --
 4225 DATA #0,A4.B4.>C4     <B4.>C4.D4   C4.<B4.A4     B4AG8&G2
 4226 DATA #1,F4.G4.A4     G4.A4.B4   A4.G4.F4     G4FE&E2
 4227 DATA #2,F4R8F8&F2 F4R8F8&F2 F4R8F8&F2 F4R8F8&F4E4
 4228 DATA #3,@29V10O6q2L8 P104AB>CD<P24]4AB>CD<[4 P104AB>CD<P24]4AB>CD<[4 P104AB>CD<P24]4AB>CD<[4 P104AB>CD<P24]4AB>CD<[4
 4229 DATA #4,@29V10O6q2L8P104FGABP24]4FGAB[4P104FGABP24]4FGAB[4P104FGABP24]4FGAB[4P104FGABP24]4FGAB[4
 4230 DATA #6,\B \B \B \B
 4231 DATA --
 4232 DATA #0,A4.B4.>C4     <B4.>C4.D4   E4.D4.C4      D4C<B8&B4&B8&B16&Bl40 !1 Rl80>
 4233 DATA #1,F4.G4.A4     G4.A4.B4   >C4.<B4.A4   G+4EG+8&G+2
 4234 DATA #2,D4R8D8&D2 D4R8D8&D2 D4R8D8&D2 E4R8E8&E2
 4235 DATA #3,P104AB>CD<P24]4AB>CD<[4 P104AB>CD<P24]4AB>CD<[4 P104AB>CD<P24]4AB>CD<[4P104G+G+ABP24]4G+G+AB[4 P104V9 @28O6L16
 4236 DATA #4,P104FGABP24]4FGAB[4P104FGABP24]4FGAB[4P104FGABP24]4FGAB[4P104EEF+G+P24]4EEF+G+[4 P24V9 @28O6L16
 4237 DATA #6,\B \B \B (N46N30) N46 (N46N38) (N46N38) (N30N46) L16 N38 N38 N38 N38 N38 N38 L8
 4238 DATA --
 4239 DATA #0,C<BA>C&C8<BA>C&C8<BA>C&C8<BA>D&D8C<A>D&D8C<A>C <BG+AB&B8G+AB16&Bl40 !1 Rl80>
 4240 DATA #1,AECA&A8ECG&  G8ECG&G8ECA& A8F+DA&A8F+DA  G+DF+G+&G+8DF+G+
 4241 DATA #2,AAAAAAAA >CCCCCCCC DDDDDDDD EEEEEEEE<
 4242 DATA #3,AEC<A>AEC<A>AEC<A>AEC<A>GEC<G>GEC<G>GEC<G>GEC<G>F+D<AF+>F+D<AF+>F+D<AF+>F+D<AF+>G+E<BG+>G+E<BG+>G+E<BG+>G+E<BG+>
 4243 DATA #4,AEC<A>AEC<A>AEC<A>AEC<A>GEC<G>GEC<G>GEC<G>GEC<G>F+D<AF+>F+D<AF+>F+D<AF+>F+D<AF+>G+E<BG+>G+E<BG+>G+E<BG+>G+E<BG+>
 4244 DATA #6,\A \A \A (N46N30) N46 (N38N46) N46 (N30N46) (N30N46) L16 N38 N38 N38 N38 L8
 4245 DATA --
 4246 DATA #0,C<BA>C&C8<BA>C&C8<BA>C&C8<BA>D&D8C<A>D&D8C<A>C <BG+AB&B8G+AB16&Bl40 !1 Rl80>
 4247 DATA #1,AECA&A8ECG&  G8ECG&G8ECA& A8F+DA&A8F+DA  G+DF+G+&G+8DF+G+
 4248 DATA #2,AAAAAAAA >CCCCCCCC DDDDDDDD EEEEEEEE<
 4249 DATA #3,AEC<A>AEC<A>AEC<A>AEC<A>GEC<G>GEC<G>GEC<G>GEC<G>F+D<AF+>F+D<AF+>F+D<AF+>F+D<AF+>G+E<BG+>G+E<BG+>G+E<BG+>G+E<BG+>
 4250 DATA #4,AEC<A>AEC<A>AEC<A>AEC<A>GEC<G>GEC<G>GEC<G>GEC<G>F+D<AF+>F+D<AF+>F+D<AF+>F+D<AF+>G+E<BG+>G+E<BG+>G+E<BG+>G+E<BG+>
 4251 DATA #6,\A \A \A (N46N30) N46 (N38N46) N46 (N30N46) (N30N46) L16 N38 N38 N38 N38 L8
 4252 DATA --
 4253 DATA #0,<A1&A2. P64@27O3V8  L8 O3GGFFFFFFFFEEEEEEEE16&El40 !1 Rl80 dc
 4254 DATA #1,E1&E2.R4&R1&R1
 4255 DATA #2,L8 O3AAAAAAAAGGGGGGGGFFFFFFFFEEEEEEEE
 4256 DATA #3,P64@29V10O6AEC<A>AEC<A>AEC<A>AEC<A>AEC<A>AEC<A>AEC<A>AEC<A>AEC<A>AEC<A>AEC<A>AEC<A>AEC<A>AEC<A>G+E<BG+>G+E<BG+
 4257 DATA #4,P64@29V10O4 L16 AAAA AAAA AAAA AAAA AAAA AAAA AAAA AAAA AAAA AAAA AAAA AAAA AAAA AAAA G+G+G+G+ G+G+G+G+
 4258 DATA #6,\A \A \A \A
 4259 '
 4260 '###############################
 4261 '      STAGE 4 BOSS
 4262 '###############################
 4263 DATA SONG 2
 4264 DATA \A = \L8(N30N46) N46 (N38N46) N46 (N30N46) (N30N46) (N38N46) N46\
 4265 DATA --
 4266 DATA #0,T168 dc P64@25O6V11 L8 q2 RB-16B-16 q1 B-4 q4 A8 R4.R1
 4267 DATA #1,@25O6V10 P64 L8 q2 RG-16G-16 q1 G-4 q4 F8 R4.R1
 4268 DATA #2, P64@27O3V10 L8 E->E-D-E-<L8 E->E-D-E-<L8 E->E-D-E-<L8 E->E-D-E-<
 4269 DATA #3,@25O6V10 P24 L8 q2 R~65;65;G-16G-16 q1 G-4 q4 F8 R4.R1
 4270 DATA #4, P104@25O6V10 L8 q2 RE-16E-16 q1 D4 q4 A8R4.R1
 4271 DATA #5, P64@29V12O3 L16 R2AA]2AA]2AA]2AA[6 L16 R2AA]2AA]2AA]2AA[6
 4272 DATA #6,@116V15 \A\A
 4273 DATA --
 4274 DATA #0,L8 q2 RB-16B-16 q1 B-4 q4 A8 R4.R1
 4275 DATA #1,L8 q2 RG-16G-16 q1 G-4 q4 F8 R4.R1
 4276 DATA #2, L8 E->E-D-E-<L8 E->E-D-E-<L8 E->E-D-E-<L8 E->E-D-E-<
 4277 DATA #3,L8 q2 RG-16G-16 q1 G-4 q4 F8 R4.R1
 4278 DATA #4, L8 q2 RE-16E-16 q1 D4 q4 A8R4.R1
 4279 DATA #5, L16 R2AA]2AA]2AA]2AA[6 L16 R2AA]2AA]2AA]2AA[6
 4280 DATA #6,\A\A
 4281 DATA --
 4282 DATA #0,L8 q2 RB16 B16  q1 B4  q4 B-8R4.R1
 4283 DATA #1,L8 q2 RG16 G16  q1 G4  q4 G-8R4.R1
 4284 DATA #2, L8 E>EDE<L8 E>EDE<L8 E>EDE<L8 E>EDE<
 4285 DATA #3,L8 q2 RG16 G16  q1 G4  q4 G-8R4.R1
 4286 DATA #4, L8 q2 RE16 E16  q1 E4 q4 E-8R4.R1
 4287 DATA #5, L16 R2B-B-]2B-B-]2B-B-]2B-B-[6 L16 R2B-B-]2B-B-]2B-B-]2B-B-[6
 4288 DATA #6,\A\A
 4289 DATA --
 4290 DATA #0,L8 q2 RB16 B16  q1 B4  q4 B-8R4.R1
 4291 DATA #1,L8 q2 RG16 G16  q1 G4  q4 G-8R4.R1
 4292 DATA #2, L8 E>EDE<L8 E>EDE<L8 E>EDE<L8 E>EDE<
 4293 DATA #3,L8 q2 RG16 G16  q1 G4  q4 G-8R4.R1
 4294 DATA #4, L8 q2 RE16 E16  q1 E4 q4 E-8R4.R1
 4295 DATA #5, L16 R2B-B-]2B-B-]2B-B-]2B-B-[6 L16 R2B-B-]2B-B-]2B-B-]2B-B-[6
 4296 DATA #6,\A\A
 4297 DATA --
 4298 DATA #0,q1<L8 RFA->C<BGRB4>C<BGB-GR4
 4299 DATA #1,q1<P24L8 RCFA-GDRG4A-GDGDR4
 4300 DATA #2, L8 F>C<B>C<L8 F>C<B>C<L8 F>C<B>C<L8 F>C<B>C<
 4301 DATA #3,q1<P104L8 RCFA-GDRG4A-GDGDR4
 4302 DATA #4, @29V10O4 L2 C<B> L2 C<B>
 4303 DATA #5, P24V10 L2 A-G L2 A-G
 4304 DATA #6,\A\A
 4305 DATA --
 4306 DATA #0,L8 RFA->C<BGRB4>C<BGB-GR4>
 4307 DATA #1,L8 RCFA-GDRG4A-GDGDR4
 4308 DATA #2, L8 F>C<B>C<L8 F>C<B>C<L8 F>C<B>C<L8 F>C<B>C<
 4309 DATA #3,L8 RCFA-GDRG4A-GDGDR4
 4310 DATA #4, L2 C<B> L2 C<B>
 4311 DATA #5, L2 A-G L2 A-G >
 4312 DATA #6,\A\A
 4313 DATA --
 4314 DATA #0,L8 E-<B>]2E-<B>]2E-<B>]2E-<B>[6
 4315 DATA #1,L8 BA-]2BA-]2BA-]2BA-[6
 4316 DATA #2, L8 A->E-DE-<L8 A->E-DE-<
 4317 DATA #3,L8 BA-]2BA-]2BA-]2BA-[6
 4318 DATA #4, L2 ]4A-[4>E-<
 4319 DATA #5, L2 ]4E-[4B
 4320 DATA #6,\A
 4321 DATA --
 4322 DATA #0,L8 D<B->]2D<B->]2D<B->]2D<B->[6
 4323 DATA #1,L8 B-G]2B-G]2B-G]2B-G[6
 4324 DATA #2, L8 A->E-DE-<L8 A->E-DE-<
 4325 DATA #3,L8 B-G]2B-G]2B-G]2B-G[6
 4326 DATA #4, L2 ]4G[4>D<
 4327 DATA #5, L2 ]4D[4B-
 4328 DATA #6,\A
 4329 DATA --
 4330 DATA #0,L8 E-<B>]2E-<B>]2E-<B>]2E-<B>[6
 4331 DATA #1,L8 BA-]2BA-]2BA-]2BA-[6
 4332 DATA #2, L8 A->E-DE-<L8 A->E-DE-<
 4333 DATA #3,L8 BA-]2BA-]2BA-]2BA-[6
 4334 DATA #4, L2 ]4A-[4>E-<
 4335 DATA #5, L2 ]4E-[4B
 4336 DATA #6,\A
 4337 DATA --
 4338 DATA #0,L8 D<B->]2D<B->]2D<B->]2D<B->[6dc
 4339 DATA #1,L8 B-G]2B-G]2B-G]2B-G[6>
 4340 DATA #2, L8 A->E-DE-<L8 A->E-DE-<
 4341 DATA #3,L8 B-G]2B-G]2B-G]2B-G[6>
 4342 DATA #4, L2 ]4G[4>D<
 4343 DATA #5, L2 ]4D[4B-
 4344 DATA #6,\A
 4345 DATA ENDSONG
 4346 '
 4347 '###############################
 4348 '      STAGE 5 SONG DATA
 4349 '###############################
 4350 *MS5
 4351 DATA SONG 1
 4352 DATA \A = \(N46N30) N46 (N46N38N51) N46 (N46N30) (N46N30) (N38N51N46) N46\
 4353 DATA \B = \(N46N30) N46 (N38N51N46) (N46N30) N46 (N46N30) (N38N51N46) N46\
 4354 DATA \C = \(N46N30) N46 (N38N51N46) N46 (N30N46) N46 (N38N51N46) N46\
 4355 DATA \D = \(N49N30) N46 (N46N38N51) N46 (N30N46) N46 (N38N51N46) N46 \
 4356 DATA \E = \(N30N46) N46  N46 (N30N46) N46 (N30N46) (N38N51N46) N46\
 4357 DATA \F = \L4(N38N51)L8(N49N30) N46 (N30N46) N46 (N30N46) N46\
 4358 DATA \G = \(N30N46)N46(N30N46)N46L16(N38N51N30)(N38N51)(N38N51)(N38N51)P104(N30N45)N45P24N45N45L8@116\
 4359 DATA \H = \(N49N46N30) L16 (N38N51) (N38N51) L8(N38N51)  L4(N49N30) \
 4360 DATA \I = \L16P104 N45  N45  N45  N45 P24  N45  N45 L8@116 \
 4361 DATA \a = \F<]2A-[2>C]2F[2A-]2G[2F<]2A-[2> F<]2A-[2>C]2F[2A-]2G[2F<]2A-[2> \
 4362 DATA \b = \F<]2A-[2>D-]2F[2A-]2G[2F]2<A-[2> E-<]2G[2>C]2E-[2G]2F[2E-]2C[2 \
 4363 DATA \c = \]2F<[2A-]2>C[2F]2A-[2G]2F<[2A-> ]2F<[2A-]2>C[2F]2A-[2G]2F<[2A->\
 4364 DATA \d = \]2F<[2A-]2>D-[2F]2A-[2G]2F[2<A-> ]2E-<[2G]2>C[2E-]2G[2F]2E-[2C\
 4365 DATA --
 4366 DATA #0,T172 dcP64@43O4V10 L8 FCFA-&A-GA-B->C2&CCE-F&  F4E-4<FA->E-C&C2&C<A-B->C
 4367 DATA #1,P104@43V9 O4 L8 C<A->CF&FCFG A-2&A-A->C<A-&A-4G4CF>C<G&G2&G8E-GA-
 4368 DATA #2,P64@44V11L8O3 FFFFF16>F16<FFFE-E-E-E-E-E-E-16>E-16<E->D-D-D-D-D-16D-16D-D-D-<A-A-A-A-A-A-A-16A-16A-
 4369 DATA #3,P104@28V11 L8O5q2 \a\b
 4370 DATA #4,P24@28V10 L8L8O5q2 \c\d
 4371 DATA #6, @116V15L8\A \A \A \A
 4372 DATA --
 4373 DATA #0,D-C<B-G&GGA-B->C<B-A-F&FFA->C F4<F4A-4>E-C&C2.R4<
 4374 DATA #1,B-A-GE&EEFG F4.C&CCFA- A4C4F4FF&F4.E&E4R4
 4375 DATA #2,GGG>C&CCC16<G16B-16>C16 <FFFE-&E-A-16B-16>E-16<B-16>D-16E-16 DDDDD-D-D-D-CCC<CCD16C16E-16C16E16C16
 4376 DATA #3,q1 <B-4.>E&E2 F4.A-&A2 >C2<F2 G4.G&G2
 4377 DATA #4,q1 <G4.>C&C2 C4.F&F2 A2C2 F4.E&E2
 4378 DATA #6, \B \B \A (N46N30)  N46 (N38N51N46) (N30N49) R8 (N30N46) (N38N51) (N38N51)
 4379 DATA --
 4380 DATA #0,FCFA-&A-GA-B- >C2&CCE-F&  F4E-4<FA->E-C& C2&C<A-B->C
 4381 DATA #1,C<A->CF&FCFG A-2&A-A->C<A-&A-4G4CF>C<G&G2&G8E-GA-
 4382 DATA #2,L8O3 FFFFF16>F16<FFF E-E-E-E-E-E-E-16>E-16<E- >D-D-D-D- D-16D-16D-D-D- < A-A-A-A- A-A-A-16A-16A-
 4383 DATA #3,L8O5q2 \a\b
 4384 DATA #4,L8O5q2\c \d
 4385 DATA #6, (N49N30) N46 (N46N38N51) N46 (N30N46) (N30N46) (N38N51N46) N46 \A \A \A
 4386 DATA --
 4387 DATA #0,D-C<B-G&GGA-B- >C<B-A->F4~64;0;<F~64;;A-B-  >C<B-A-B-&B-A-GF& F2.R8R16R32 !1 R32
 4388 DATA #1,B-A-GE&EEFG F4.>  C4~64;0;  <C~64;;FF A-GFG&GFEC&C2.R4
 4389 DATA #2,GGG>C&CCC16<G16B-16>C16 <FFFE-&E-A-16B-16>E-16<B-16>D-16E-16 D-D-D-C&C<CCC FFFF F16F16FFF
 4390 DATA #3,q1 <B-4.>E&E2 F4.E-&E-2 F4.E&E2 F2.R4
 4391 DATA #4,q1 <G4.>C&C2 C4.D-&D-2 D-4.C&C2 C2.R4
 4392 DATA #6, \B \B \A (N30N46) (N30N46) (N38N51N46)  N46 (N30N46) (N30N46) L16 (N38N51) P104 N45 N45 P24 N45  L8@116
 4393 DATA --
 4394 DATA #0,F4>C<B-&B-4>C<A-&A-4GF&F2  E4>C<B-&B-4>CE-&E-4D-C&C2
 4395 DATA #1,D-4A-G&G4A-F&F4E-D-&D2 C4GF&F4EA-&A-4.G&G4G-4
 4396 DATA #2,D-4RD-&D-2 D-4RD-&D-2 C4 RC&C2 F4. E-&E-4 D4
 4397 DATA #3,O7 ]2F1&F1 E4 ]2 E4 ]2E4 ]2E4 [8 R2&R16C16 F16G16 A-16G16A-16B-16 ]2
 4398 DATA #4,O7 ]2F1&F1 E8&E8 ]2E8&E8 ]2E8&E8 ]2E8&E8[8 R2&R16C16F16G16A-16G16A-16B-16
 4399 DATA #6, \E \E \E (N30N46) N46 N46 (N30N46)  N46  L16(N30N46) N30   L8 (N38N51)(N38N51)
 4400 DATA --
 4401 DATA #0,<F4GA-&A-2&A-1 FGA-B-&B-A-GA-&A-B->CD-&D-E-F4
 4402 DATA #1,D-4E-F&F2&F1 DE-FG&GFE-F&FGA-B-&B->CD-4
 4403 DATA #2,D-D-D-D- D-D-D-D- D-D-D-D- D-E-4E- DDDD DDDD D-D-D-D- D-D-D-D-
 4404 DATA #3,>C1&C2&C8< B-8 ]2B-8 ]2B-8[4 >C1F1
 4405 DATA #4,]2>C1&C2&C8<B-8 ]2B-8 ]2B-8[4 >C1F1
 4406 DATA #6, \A \A \A (N30N46) N46 (N38N51N46) N46 (N30N46) (N30N46) L16P104 N45 N45 P24 N45 N45 L8@116
 4407 DATA --
 4408 DATA #0,F1E2&E4&E8&E16&El40 !1 Rl80
 4409 DATA #1,C1 C1
 4410 DATA #2,R4 C2 CF16G16 O4 CCCC CCCC
 4411 DATA #3,G1&G8&G8 ]2G8&G8 ]2G8&G8 ]2G8&G8[8
 4412 DATA #4,G1&G8&G8 ]2G8&G8 ]2G8&G8 ]2G8&G8[8
 4413 DATA #6, \F \G
 4414 DATA --
 4415 DATA #0,FE-CF&FE-CE- FD<B->B-&B-A-E-F FE-CF&FE-CE- FD<B->B-&B-A-B-16>C16<A-16F16
 4416 DATA #1,C<A-F>C&C<A-FA- >D<B-F>D&DD<B->D C<A-F>C&C<A-FA- >D<B-F>F&FE-D4
 4417 DATA #2,< FFFFF16F16FFF FFFFF16B-16>D16F16<FF FFFFF16F16FFF FFFFF16B-16>E-16F16<FF
 4418 DATA #3,O4 A-1B-1>C1<B-1
 4419 DATA #4,O4 F1G1A-1G1
 4420 DATA #6, \D \C \C \C
 4421 DATA --
 4422 DATA #0,FE-CF&FE-CE- FD<B->B-&B-A-E-F GDGB-&B-GB->F&F<G>CE~;;&E2~64;0;
 4423 DATA #1,C<A-F>C&C<A-FA- >D<B-F>D&DD<B->D D<B->DG&GDG>C&C<EG>C~;; & C2~64;0;
 4424 DATA #2,FFFFF16F16FFF FFFF F16B-16>D16F16<FF GGGG G16G16GGG > CCC<C CD-16C16E-16C16E16C16
 4425 DATA #3,A-1B-1>D1F4.E&E2
 4426 DATA #4,F1G1B-1>C4.C&C2
 4427 DATA #6, \C \C \C \H\I
 4428 DATA --
 4429 DATA #0,@44V9O3L8F~64;;FFF F16F16FFF FFFF F16B-16>D16F16<FF FFFF F16F16FFF FFFF F16B-16>E-16F16<FF16&Fl40 !1 Rl80 dc
 4430 DATA #1,R1~64;; R1 R1 R1
 4431 DATA #2,L8 FFFF F16F16FFF FFFF F16B-16>D16F16<FF FFFF F16F16FFF FFFF F16B-16>E-16F16<FF
 4432 DATA #3,<A-1B-1>C2E-2D1
 4433 DATA #4,<F1G1A-2>C2<B-1
 4434 DATA #6, \D \C \C (N30N46) N46 (N38N51N46) N46 (N30N46) N46 L16 (N38N51) (N38N51) (N38N51) (N38N51) L8
 4435 '
 4436 '###############################
 4437 '      STAGE 5 BOSS
 4438 '###############################
 4439 DATA SONG 2
 4440 DATA \A = \DD> q1 D16 q4 C q1 D16 q4 <DD q1 >D16<G16A16>C16<\
 4441 DATA \a = \@116L8N30N30 L16(N38N51) L8(N38N51) L16(N38N51) P104 L16 N45N45 L24N45N45P64N45 L16N45N45P24N45N45L8 @116\
 4442 DATA \b = \@116N30N30 L16(N38N51) L8(N38N51) L16(N38N51) P104 L16 N45N51 N45P64N45  N51N45P24N45N51 L8\
 4443 DATA \c = \@116L4 N30 (N38N51) L8 N30N30 L4(N38N51) L8\
 4444 DATA \d = \@116L4N30 L16 (N38N51) L8(N38N51) L16(N38N51) L8 N30N30 L4(N38N51) L8\
 4445 DATA \e = \@116N30 L16(N38N51)(N38N51) L8 (N38N51) N30 L16 (N38N51)(N38N51) L8 (N38N51) N30 L16 (N38N51)(N38N51) L8\
 4446 DATA \f = \@116(N38N51)(N38N51)N30(N38N51) L16 P104 N45N45N45 P64 N45N45 P24 N45N45N45 L8\
 4447 DATA --
 4448 DATA #0, T172 P64@7O4V10 R1
 4449 DATA #1, P24@7O4V10 R1
 4450 DATA #2, R1
 4451 DATA #3, R1
 4452 DATA #4, R1
 4453 DATA #5, P104@7O4V10 R1
 4454 DATA #6, @116 V15 \a
 4455 DATA --
 4456 DATA #0, dc L8 R q4 A q1 G16A16R>C8.D16&D4<
 4457 DATA #1, L8 R q4 E8 q1 D16E16RG8.A16&A8B-
 4458 DATA #2, P64@44V12O3 L8 q4 AA> q1 A16 q4 A q1 A16 C16R16C16<B16R16B16B-16B-16
 4459 DATA #3, P64@7O3V10 L8 R q4 A8 q1 G16A16R>G8.G-16&G-8F8<
 4460 DATA #4, P64@7O3V10 L8 q4 A8 q1 >A16E16G16A16D16E16E.D16&D8D<
 4461 DATA #5, L8 R~65;65; q4 E8 q1 D16E16RG8.A16&A8B-
 4462 DATA #6, \b
 4463 DATA --
 4464 DATA #0, L8 R q4 A q1 G16A16R>C8.D16&D4<
 4465 DATA #1, L8 R q4 E8 q1 D16E16RG8.A16&A8B-
 4466 DATA #2, L8 q4 AA> q1 A16 q4 A q1 A16 C16R16C16<B16R16B16B-16B-16
 4467 DATA #3, L8 R q4 A8 q1 G16A16R>G8.G-16&G-8F8<
 4468 DATA #4, L8 q4 A8 q1 >A16E16G16A16D16E16E.D16&D8D<
 4469 DATA #5, L8 R q4 E8 q1 D16E16RG8.A16&A8B-
 4470 DATA #6, \b
 4471 DATA --
 4472 DATA #0, L8 R q4 A q1 G16A16R>C8.D16&D4<
 4473 DATA #1, L8 R q4 E8 q1 D16E16RG8.A16&A8B-
 4474 DATA #2, L8 q4 AA> q1 A16 q4 A q1 A16 C16R16C16<B16R16B16B-16B-16
 4475 DATA #3, L8 R q4 A8 q1 G16A16R>G8.G-16&G-8F8<
 4476 DATA #4, L8 q4 A8 q1 >A16E16G16A16D16E16E.D16&D8D<
 4477 DATA #5, L8 R q4 E8 q1 D16E16RG8.A16&A8B-
 4478 DATA #6, \b
 4479 DATA --
 4480 DATA #0, L8 R q4 A q1 G16A16R>C8.D16&D4
 4481 DATA #1, L8 R q4 E8 q1 D16E16RG8.A16&A8B- >
 4482 DATA #2, L8 q4 AA> q1 A16 q4 A q1 A16 C16R16C16<B16R16B16B-16B-16
 4483 DATA #3, L8 R q4 A8 q1 G16A16R>G8.G-16&G-8F8<
 4484 DATA #4, L8 q4 A8 q1 >A16E16G16A16D16E16E.D16&D8D<
 4485 DATA #5, L8 R q4 E8 q1 D16E16RG8.A16&A8B- >
 4486 DATA #6, \a
 4487 DATA --
 4488 DATA #0, E2.&E8G8
 4489 DATA #1, C2.&C8E
 4490 DATA #2, L8 q4 AA> q1 A16 q4 A q1 A16 C16R16C16<B16R16B16B-16B-16
 4491 DATA #3, L8 R q4 A8 q1 G16A16R>G8.G-16&G-8F8<
 4492 DATA #4, L8 q4 A8 q1 >A16E16G16A16D16E16E.D16&D8D<
 4493 DATA #5, C2.&C8E
 4494 DATA #6, \b
 4495 DATA --
 4496 DATA #0, F+2F4F16G16F8
 4497 DATA #1, E-2D4D16E16D8
 4498 DATA #2, L8 q4 AA> q1 A16 q4 A q1 A16 C16R16C16<B16R16B16B-16B-16
 4499 DATA #3, L8 R q4 A8 q1 G16A16R>G8.G-16&G-8F8<
 4500 DATA #4, L8 q4 A8 q1 >A16E16G16A16D16E16E.D16&D8D<
 4501 DATA #5, E-2D4D16E16D8
 4502 DATA #6, \b
 4503 DATA --
 4504 DATA #0, E2.&E8]4G8
 4505 DATA #1, C2.&C8]4E
 4506 DATA #2, L8 q4 AA> q1 A16 q4 A q1 A16 C16R16C16<B16R16B16B-16B-16
 4507 DATA #3, L8 R q4 A8 q1 G16A16R>G8.G-16&G-8F8<
 4508 DATA #4, L8 q4 A8 q1 >A16E16G16A16D16E16E.D16&D8D<
 4509 DATA #5, C2.&C8]4E
 4510 DATA #6, \b
 4511 DATA --
 4512 DATA #0, F+2F4F16G16F8[4
 4513 DATA #1, E-2D4D16E16D8[4
 4514 DATA #2, L8 q4 AA> q1 A16 q4 A q1 A16 C16R16C16<B16R16B16B-16B-16
 4515 DATA #3, L8 R q4 A8 q1 G16A16R>G8.G-16&G-8F8<
 4516 DATA #4, L8 q4 A8 q1 >A16E16G16A16D16E16E.D16&D8D<
 4517 DATA #5, E-2D4D16E16D8[4
 4518 DATA #6, \a
 4519 DATA --
 4520 DATA #0, E2.&E8G8
 4521 DATA #1, C2.&C8E
 4522 DATA #2, L8 q4 AA> q1 A16 q4 A q1 A16 C16R16C16<B16R16B16B-16B-16
 4523 DATA #3, L8 R q4 A8 q1 G16A16R>G8.G-16&G-8F8<
 4524 DATA #4, L8 q4 A8 q1 >A16E16G16A16D16E16E.D16&D8D<
 4525 DATA #5, C2.&C8E
 4526 DATA #6, \b
 4527 DATA --
 4528 DATA #0, F+2F4F16G16F8
 4529 DATA #1, E-2D4D16E16D8
 4530 DATA #2, L8 q4 AA> q1 A16 q4 A q1 A16 C16R16C16<B16R16B16B-16B-16
 4531 DATA #3, L8 R q4 A8 q1 G16A16R>G8.G-16&G-8F8<
 4532 DATA #4, L8 q4 A8 q1 >A16E16G16A16D16E16E.D16&D8D<
 4533 DATA #5, E-2D4D16E16D8
 4534 DATA #6, \b
 4535 DATA --
 4536 DATA #0, E2.&E8]4G8
 4537 DATA #1, C2.&C8]4E
 4538 DATA #2, L8 q4 AA> q1 A16 q4 A q1 A16 C16R16C16<B16R16B16B-16B-16
 4539 DATA #3, L8 R q4 A8 q1 G16A16R>G8.G-16&G-8F8<
 4540 DATA #4, L8 q4 A8 q1 >A16E16G16A16D16E16E.D16&D8D<
 4541 DATA #5, C2.&C8]4E
 4542 DATA #6, \b
 4543 DATA --
 4544 DATA #0, F+2F4F16G16F8[4
 4545 DATA #1, E-2D4D16E16D8[4<
 4546 DATA #2, L8 q4 AA> q1 A16 q4 A q1 A16 C16R16C16<B16R16B16B-16B-16
 4547 DATA #3, L8 R q4 A8 q1 G16A16R>G8.G-16&G-8F8
 4548 DATA #4, L8 q4 A8 q1 >A16E16G16A16D16E16E.D16&D8D
 4549 DATA #5, E-2D4D16E16D8[4<
 4550 DATA #6, \a
 4551 DATA --
 4552 DATA #0, P64@44V9 O3L16 E>E<E>E<G>G<G>G<R2
 4553 DATA #1, R1
 4554 DATA #2, L16E>E<E>E<G>G<G>G<R2
 4555 DATA #3, R2L16EFF+GEFF+G
 4556 DATA #4, R2L16C+DD+EC+DD+E
 4557 DATA #5, R1
 4558 DATA #6, L4N30N30 L16(N38N51) L8(N38N51) L16(N38N51)  L8 P64 N45 P24N45
 4559 DATA --
 4560 DATA #0, L16 B->B-<B->B-D->D-<D->D-<R2
 4561 DATA #1, R1
 4562 DATA #2, L16B->B-<B->B-D->D-<D->D-<R2
 4563 DATA #3, R2L16A+B>CC+<A+B>CC+
 4564 DATA #4, R2L16GG+AA+GG+AA+
 4565 DATA #5, R1
 4566 DATA #6, @116N30N30 L16(N38N51)(N38N51) R8 P104 N45N45N45 P64 N45N45N45 P24 N45N45 L8
 4567 DATA --
 4568 DATA #0, L8P64@7O4V11 RA16>C16E-4&E-8DE-F
 4569 DATA #1, RF+16A16>C4&C8<B>CD
 4570 DATA #2, L8 CCCC CCCC
 4571 DATA #3, <L8 E-2D2
 4572 DATA #4, <L8 A2A-2
 4573 DATA #5, RF+16A16>C4&C8<B>CD
 4574 DATA #6, \c
 4575 DATA --
 4576 DATA #0, F+6G+6A6 G+6F+6F6
 4577 DATA #1, E-6F6G-6F6E-6D6
 4578 DATA #2, L8 CCCC CCCC
 4579 DATA #3, E-2D2
 4580 DATA #4, A2A-2
 4581 DATA #5, E-6F6G-6F6E-6D6
 4582 DATA #6, \c
 4583 DATA --
 4584 DATA #0, F+16F16E-16D16&D4&D8 ]4 C8D8E-8
 4585 DATA #1, E-16D16C16<B16&B4&B8]4AB>C
 4586 DATA #2, L8 CCCC CCCC
 4587 DATA #3, E-2D2
 4588 DATA #4, A2A-2
 4589 DATA #5, E-16D16C16<B16&B4&B8]4AB>C
 4590 DATA #6, \c
 4591 DATA --
 4592 DATA #0, FG-A-AA-G-F4[4
 4593 DATA #1, DE-FG-FE-D4[4
 4594 DATA #2, L8 CCCC CCCC
 4595 DATA #3, E-2D2
 4596 DATA #4, A2A-2
 4597 DATA #5, DE-FG-FE-D4[4
 4598 DATA #6, \c
 4599 DATA --
 4600 DATA #0, <RA16>C16E-4&E-8DE-F
 4601 DATA #1, < RF+16A16>C4&C8<B>CD
 4602 DATA #2, L8 CCCC CCCC
 4603 DATA #3, E-2D2
 4604 DATA #4, A2A-2
 4605 DATA #5, < RF+16A16>C4&C8<B>CD
 4606 DATA #6, \c
 4607 DATA --
 4608 DATA #0, F+6G+6A6 G+6F+6F6
 4609 DATA #1, E-6F6G-6F6E-6D6
 4610 DATA #2, L8 CCCC CCCC
 4611 DATA #3, E-2D2
 4612 DATA #4, A2A-2
 4613 DATA #5, E-6F6G-6F6E-6D6
 4614 DATA #6, \c
 4615 DATA --
 4616 DATA #0, F+4.F+16G+16A2
 4617 DATA #1, E-4.E-16F16G-2
 4618 DATA #2, E-E-E-E- E-E-E-E-
 4619 DATA #3, >C+2<F+4.F+16G+16
 4620 DATA #4, >A2E-4.E-16F16
 4621 DATA #5, E-4.E-16F16G-2
 4622 DATA #6, \c
 4623 DATA --
 4624 DATA #0, C+4.C+16D+16E2
 4625 DATA #1, < A4.A16B16>C+2
 4626 DATA #2, <G-G-G-G- G-G-G-G-
 4627 DATA #3, A2C+4.C+16D+16
 4628 DATA #4, G-2<A4.A16B16
 4629 DATA #5, < A4.A16B16>C+2
 4630 DATA #6, \c
 4631 DATA --
 4632 DATA #0, E4.E16F+16G2
 4633 DATA #1, C4.C16D16E2
 4634 DATA #2, AAAA AAAA
 4635 DATA #3, E2<G4.G16A16
 4636 DATA #4, >C2<E4.E16F+16
 4637 DATA #5, C4.C16D16E2
 4638 DATA #6, \c
 4639 DATA --
 4640 DATA #0, G4.G16A16B-4>C4<
 4641 DATA #1, E-4.E16F16G4A4
 4642 DATA #2, >CCCC CCCC
 4643 DATA #3, B-4>E-4G2
 4644 DATA #4, G4B-4>E-2
 4645 DATA #5, E-4.E16F16G4A4
 4646 DATA #6, @116N30'4 (N38N51)(N38N51)N30 P104 L16N45N45 P64 N45N45 P24 L8N45
 4647 DATA --
 4648 DATA #0, A1&A1&A1&A1
 4649 DATA #1, F+1&F+1&F+1&F+1
 4650 DATA #2, \A\A\A\A
 4651 DATA #3, D1 F+1 A1 >D1
 4652 DATA #4, <A1 >D1 F+1 A1
 4653 DATA #5, F+1&F+1&F+1&F+1
 4654 DATA #6, \d\d\d N30'4 @116L16(N38N51) L8 (N38N51) L16(N38N51) N30'8 L16 (N38N51)(N38N51) P64 N45N45 P24 N45N45 L8
 4655 DATA --
 4656 DATA #0, <RG+16G+16 q4 G+R q1 F+16F+16G+8RA16A16  q4 G+G+F+G+R2 q1 dc
 4657 DATA #1, < RE16E16 q4 ER q1 D16D16ERF+16F+16   q4 EEDER2 q1
 4658 DATA #2, O3E q4 EE q1 E q4 EEEE    EEEER2 q1
 4659 DATA #3, << RB16B16 q4 BR q1 A16A16BR>C+16C+16  < q4 BBAB>[2P24 q1 L16EF+G+AB>C+D+E
 4660 DATA #4, [4q4 A48ER4G+R4BR q4 >EEDE< ]4 P104 q1 L16EF+G+AB>C+D+E
 4661 DATA #5, < RE16E16 q4 ER q1 D16D16ERF+16F+16   q4 EEDER2 q1
 4662 DATA #6, \e\f
 4663 DATA ENDSONG
 4664 '
 4665 '###############################
 4666 '      STAGE 6 SONG DATA
 4667 '###############################
 4668 *MS6
 4669 DATA SONG 1
 4670 DATA #0, T150 P64@59V9  O5L16 F+GF+GG+AG+AA+BA+B>CC+CC+
 4671 DATA #1, P64@49V9 O4 L16 F+GG+AA+B>CC+DD+EFF+GG+A
 4672 DATA #2, P64@49V8 O6 L16 B>CC+DD+EFF+GG+AA+AA+AA+
 4673 DATA #3, P64@54V9 O2A+1
 4674 DATA #4, R1
 4675 DATA #5, R1
 4676 DATA #6, @116V15 L16 P104 N45 P64 N45 N45 P64 B P104 N45 P64 N45 P24 N45 P64 B N38 N38 N38 N38 P64 N45 N45 N45 N45 @116
 4677 DATA --
 4678 DATA #0, dc P64@53V9 O5L16 L16GGGGG8GG8GG8G+AA+8
 4679 DATA #1, @54V7O5D4&D32 L32C+C<BA+AGGL16 @47V9 O3G8>GG@54V7O4R8G16R16
 4680 DATA #2, @54V7O4 L16 A+4&A32A32G+32G32F+32F32E32D+32R4.DR
 4681 DATA #3, @61V10q4L16 G8.A+8.G8>C+8.C8.C+<A+
 4682 DATA #4, P24@60q4V7O3G1
 4683 DATA #5, P104@60V7O3q4 D1
 4684 DATA #6, (N49N30)N30N46N46 (N46N38)(N46N38)N46(N46N30) N46(N46N30)N46N46 (N46N38)N46N46N46
 4685 DATA --
 4686 DATA #0, L16GGGGG8GG8GG8G+AA+8
 4687 DATA #1, A+8&A16AR8@47V9 GGR<G>FG@54V7A+B>CC+
 4688 DATA #2, L16 G8.GR2F+GG+A
 4689 DATA #3, L16 G8.A+8.G8>C+8.C8.C+D+<
 4690 DATA #4, G1
 4691 DATA #5, D1
 4692 DATA #6, (N46N30)(N46N30)N46N46 (N46N38)(N46N38)N46(N46N30) N46(N46N30)N46N46 (N46N38)N46N46(N46N30)
 4693 DATA --
 4694 DATA #0, L16GGGGG8GG8GG8G+AA+8
 4695 DATA #1, @54V7O5D4&D32 L32C+C<BA+AGGL16 @47V9 O3G8>GG@54V7O4R8G16R16
 4696 DATA #2, L16 A+4&A32A32G+32G32F+32F32E32D+32R4.DR
 4697 DATA #3, L16 G8.A+8.G8>C+8.C8.C+<A+
 4698 DATA #4, A+1
 4699 DATA #5, F1
 4700 DATA #6, (N46N30)(N46N30)N46N46 (N46N38)(N46N38)N46(N46N30) N46(N46N30)N46N46 (N46N38)N46N46N46
 4701 DATA --
 4702 DATA #0, L16GGGGG8GG8GG8G+AA+8
 4703 DATA #1, A+8&A16AR8@47V9 GGR<G>FG@60V10O3 A+B>CC+
 4704 DATA #2, L16 G8.GR2@49V9 O5 D+DC+C
 4705 DATA #3, L16 G8.A+8.G8>C+8.C8.C+<A+
 4706 DATA #4, A+1
 4707 DATA #5, F1
 4708 DATA #6, (N46N30)(N46N30)N46N46(N46N38)(N46N38)N46(N46N30)N46(N46N30)(N38N46)(N38N46) P64N45N45 P24N45N45 @116
 4709 DATA --
 4710 DATA #0, G+G+G+G+G+8G+G+8G+G+8AA+B8
 4711 DATA #1, D2F2
 4712 DATA #2, <B2G+2
 4713 DATA #3, L16 G8.B8.G8>D8.C+8.D<B
 4714 DATA #4, G+1
 4715 DATA #5, D1
 4716 DATA #6, (N49N30)N30N46N46 (N46N38)(N46N38)N46(N46N30) N46(N46N30)N46N46 (N46N38)N46N46N46
 4717 DATA --
 4718 DATA #0, G+G+G+G+G+8G+G+8G+G+8AA+B8
 4719 DATA #1, G+2B2
 4720 DATA #2, F6E6D+6D6C+6D6
 4721 DATA #3, L16 G8.B8.G8>D8.C8.<A+8
 4722 DATA #4, B1
 4723 DATA #5, D1
 4724 DATA #6, (N46N30)(N46N30)N46N46 (N46N38)(N46N38)N46(N46N30) N46(N46N30)N46N46 (N46N38)N46N46(N46N30)
 4725 DATA --
 4726 DATA #0, L16GGGGG8GG8GG8G+AA+8
 4727 DATA #1, @54V7O5D4&D32 L32C+C<BA+AGGL16 @47V9 O3G8>GG@54V7O4R8G16R16
 4728 DATA #2, @54V7O4 L16 A+4&A32A32G+32G32F+32F32E32D+32R4.DR
 4729 DATA #3, L16 G8.A+8.G8>C+8.C8.C+<A+
 4730 DATA #4, >D1
 4731 DATA #5, G1
 4732 DATA #6, (N46N30)(N46N30)N46N46 (N46N38)(N46N38)N46(N46N30) N46(N46N30)N46N46 (N46N38)N46N46N46
 4733 DATA --
 4734 DATA #0, L16GGGGG8GG8GG8G+AA+8
 4735 DATA #1, A+8&A16AR8@47V9 GGR<G>FG@54V7A+B>CC+
 4736 DATA #2, L16 G8.GR2F+GG+A
 4737 DATA #3, L16 G8.A+8.G8>C+8.C8.C+D+<
 4738 DATA #4, D1
 4739 DATA #5, G1
 4740 DATA #6, (N46N38)(N46N38)(N46N30)N46 P64 N45 N45 @116 N30 R P104 N45N45 P64 N45N45 P24 N45N45 @116 N38N38
 4741 DATA --
 4742 DATA #0, L16GGGGG8GG8GG8G+AA+8
 4743 DATA #1, @54V7O5D4&D32 L32C+C<BA+AGGL16 @47V9 O3G8>GG@54V7O4R8G16R16
 4744 DATA #2, L16 A+4&A32A32G+32G32F+32F32E32D+32R4.DR
 4745 DATA #3, L16 G8.A+8.G8>C+8.C8.C+<A+
 4746 DATA #4, <G1
 4747 DATA #5, D1
 4748 DATA #6, (N46N38)N46(N38N46)(N38N46)  (N46N30)(N46N30)N46(N46N30)  N46(N46N30)N46(N46N30)  (N46N38)N46N46(N46N30)
 4749 DATA --
 4750 DATA #0, L16GGGGG8GG8GG8G+AA+8
 4751 DATA #1, A+8&A16AR8@47V9 GGR<G>FG@54V7A+B>CC+
 4752 DATA #2, L16 G8.GR2F+GG+A
 4753 DATA #3, L16 G8.A+8.G8>C+8.C8.C+D+<
 4754 DATA #4, G1
 4755 DATA #5, D1
 4756 DATA #6, (N46N38)N46(N38N46)(N38N46)  (N46N30)(N46N30)N46(N46N30)  N46(N46N30)N46(N46N30)  (N46N38)N46N46(N46N30)
 4757 DATA --
 4758 DATA #0, L16GGGGG8GG8GG8G+AA+8
 4759 DATA #1, @54V7O5D4&D32 L32C+C<BA+AGGL16 @47V9 O3G8>GG@54V7O4R8G16R16
 4760 DATA #2, L16 A+4&A32A32G+32G32F+32F32E32D+32R4.DR
 4761 DATA #3, L16 G8.A+8.G8>C+8.C8.C+<A+
 4762 DATA #4, A+1
 4763 DATA #5, F1
 4764 DATA #6, (N46N38)N46(N38N46)(N38N46)  (N46N30)(N46N30)N46(N46N30)  N46(N46N30)N46(N46N30)  (N46N38)N46N46(N46N30)
 4765 DATA --
 4766 DATA #0, L16GGGGG8GG8GG8G+AA+16&A+l40;;2/1 !1 Rl80
 4767 DATA #1, A+8&A16AR8@47V9 GGR<G>FG@60V10O3 B>CC+D
 4768 DATA #2, L16 G8.GR2@49V9 O5C<BA+A
 4769 DATA #3, L16 G8.A+8.G8>C+8.C8.C+<A+
 4770 DATA #4, A+1
 4771 DATA #5, F1
 4772 DATA #6, (N46N38)N46(N38N46)(N38N46)  (N46N30)(N46N30)N46(N46N30)  N46N38N38R  P64N45N45P24N45N45@116
 4773 DATA --
 4774 DATA #0, B>CC+DD+8<B>CC+DD+8CC+DD+<
 4775 DATA #1, D+8.D8.F8D+8.D8.C8
 4776 DATA #2, G+2>C2
 4777 DATA #3, L16 G+8.>C8.<G+8>D+8.D8.C8<
 4778 DATA #4, G+1
 4779 DATA #5, D+1
 4780 DATA #6, (N49N30)N46(N30N46)(N30N46)  (N46N38)(N46N38)N46(N30N46)  N46(N30N46)(N30N46)N46  N38N46N46N46
 4781 DATA --
 4782 DATA #0, B>CC+DD+8<B>CC+DD+8CC+DD+
 4783 DATA #1, D+8.D8.F8D+8.F8.F+8
 4784 DATA #2, D+2<G+2
 4785 DATA #3, L16 G+8.>C8.<G+8>D+8.D8.C8<
 4786 DATA #4, >C1
 4787 DATA #5, G+1
 4788 DATA #6, (N30N46)N46(N30N46)(N30N46)  (N38N46)(N38N46)N46(N30N46)  N46(N30N46) L8N38L16 P64N45N45P24N45N45 @116
 4789 DATA --
 4790 DATA #0, CC+DD+E8CC+DD+E8CC+DE
 4791 DATA #1, G8.F+8.A8G8.F+8.E8
 4792 DATA #2, A6A6A6>C6C6C6
 4793 DATA #3, L16 A8.>C8.<A8>E8.D8.C8<
 4794 DATA #4, <A1
 4795 DATA #5, E1
 4796 DATA #6, (N49N30)N46(N30N46)(N30N46)  (N46N38)(N46N38)N46(N30N46)  N46(N30N46)(N30N46)N46  N38N46N46N46
 4797 DATA --
 4798 DATA #0, CC+DD+E8CC+DD+E8CC+DEl40;;2/1 !1 Rl80
 4799 DATA #1, G8.F+8.A8G8.A8.A+8
 4800 DATA #2, E6D+6D6C+6C6<A+6
 4801 DATA #3, L16 A8.>C8.<A8G8.A8.A+8
 4802 DATA #4, E1
 4803 DATA #5, C1
 4804 DATA #6, (N30N46)N46(N30N46)(N30N46)  (N38N46)(N38N46)N46(N30N46)  N46(N30N46) L8N38L16 P64N45N45P24N45N45 @116
 4805 DATA --
 4806 DATA #0, @54V7O4L16B4&B32L32A+AG+GF+FEL16R4.F+R
 4807 DATA #1, @56V9 O4L16 B2&B4&B8AG
 4808 DATA #2, L16 B8.F+8.A8G8.F+8.E8
 4809 DATA #3, L16 B8.>D8.<B8>F+8.D8.E8<
 4810 DATA #4, @58V7O4L16O3P64B>DF+B< P104B>DF+A< P64B>DF+B< P24B>DF+A<
 4811 DATA #5, @58V7O4 L16O3P64 R32 B>DF+B< P104B>DF+A< P64B>DF+B< P24B>DF+A32<
 4812 DATA #6, (N49N30)N30N46N46 (N38N46)N46(N30N46)(N30N46) N46N46N46N46 (N38N46)N46N46N46
 4813 DATA --
 4814 DATA #0, B8.BR2GG+AA+
 4815 DATA #1, F+2G8.A8.F+8
 4816 DATA #2, L16 B8.F+8.A8G8.F+8.E8
 4817 DATA #3, L16 B8.>D8.<B8>F+8.D8.E8<
 4818 DATA #4, L16O3P64B>DF+B< P104B>DF+A< P64B>DF+B< P24B>DF+A<
 4819 DATA #5, L16O3P64 R32 B>DF+B< P104B>DF+A< P64B>DF+B< P24B>DF+A32<
 4820 DATA #6, (N30N46)(N30N46)N46N46 (N38N46)N46(N30N46)(N30N46) N46N46N46N46 (N38N46)N46N46N46
 4821 DATA --
 4822 DATA #0, L16B4&B32L32A+AG+GF+FEL16R4.F+R
 4823 DATA #1, B2A8.G8.A8
 4824 DATA #2, L16 B8.F+8.A8G8.F+8.E8
 4825 DATA #3, L16 B8.>D8.<B8>F+8.D8.E8<
 4826 DATA #4, L16O3P64B>DF+B< P104B>DF+A< P64B>DF+B< P24B>DF+A<
 4827 DATA #5, L16O3P64 R32 B>DF+B< P104B>DF+A< P64B>DF+B< P24B>DF+A32<
 4828 DATA #6, (N30N46)(N30N46)(N46N38)N46 N46N46(N30N46)(N30N46) N46N46N46N46 (N38N46)N46N46N46
 4829 DATA --
 4830 DATA #0, B8.BR2FF+GG+
 4831 DATA #1, F+2G2
 4832 DATA #2, L16 B8.F+8.A8G8.F+8.E8
 4833 DATA #3, L16 B8.>D8.<B8>F+8.D8.E8<
 4834 DATA #4, L16O3P64B>DF+B< P104B>DF+A< P64B>DF+B< P24B>DF+A<
 4835 DATA #5, L16O3P64 R32 B>DF+B< P104B>DF+A< P64B>DF+B< P24B>DF+A32<
 4836 DATA #6, (N30N46) (N30N46)N46N46 (N38N46)N46(N30N46)N46 N46N46N46R P64N45N45 P24N45N45 @116
 4837 DATA --
 4838 DATA #0, L16A4&A32L32G+GF+FED+DR4.L16ER
 4839 DATA #1, A8.G8.A8F+4.GG+
 4840 DATA #2, L16 A8.E8.G8F+8.E8.D8
 4841 DATA #3, L16 A8.>C8.<A8>E8.A8.D8<
 4842 DATA #4, L16O3 P64A>CEA< P104A>CEG< P64A>CEA< P24A>CEG
 4843 DATA #5, L16O3P64 R32 A>CEA< P104A>CEG< P64A>CEA< P24A>CEG32
 4844 DATA #6, (N49N30)N30N46N46 (N38N46)N46(N30N46)(N30N46) N46N46N46N46 (N38N46)N46N46N46
 4845 DATA --
 4846 DATA #0, A8.AR2GG+AA+
 4847 DATA #1, A8.G8.A8F+8.G8.A8
 4848 DATA #2, L16 A8.E8.G8F+8.E8.D8
 4849 DATA #3, L16 A8.>C8.<A8>E8.A8.D8<
 4850 DATA #4, L16O3 P64A>CEA< P104A>CEG< P64A>CEA< P24A>CEG
 4851 DATA #5, L16O3P64 R32 A>CEA< P104A>CEG< P64A>CEA< P24A>CEG32
 4852 DATA #6, (N30N46)(N30N46)N46N46 (N38N46)N46(N30N46)(N30N46) N46N46N46N46 (N38N46)N46N46N46
 4853 DATA --
 4854 DATA #0, L16B4&B32 L32 A+AG+GF+FE L16 B4&B32 L32 A+AG+GF+FE L16
 4855 DATA #1, B8.>C+8.D8<B8.>C+8.D8<
 4856 DATA #2, L16 B8.F+8.A8G8.F+8.E8
 4857 DATA #3, L16 B8.>D8.<B8>F+8.D8.E8<
 4858 DATA #4, L16O3P64B>DF+B< P104B>DF+A< P64B>DF+B< P24B>DF+A<
 4859 DATA #5, L16O3P64 R32 B>DF+B< P104B>DF+A< P64B>DF+B< P24B>DF+A32<
 4860 DATA #6, (N49N30)N46N46(N46N38)(N46N38)N46P64(N45N46)P104(N45N46)@116L8N49L16N46(N38N46)(N38N46)N46P64N45P24N45@116
 4861 DATA --
 4862 DATA #0, B8.BR8F+RB8&B16BFF+GG+
 4863 DATA #1, B8.>C+8.D8E8.D8.C+8
 4864 DATA #2, B8.>C+8.D8E8.D8.C+8<
 4865 DATA #3, L16 B8RF+8RARG8RF+8RA8
 4866 DATA #4, L16O3P64B>DF+B< P104B>DF+A< P64B>DF+B< P24B>DF+A<
 4867 DATA #5, L16O3P64 R32 B>DF+B< P104B>DF+A< P64B>DF+B< P24B>DF+A32<
 4868 DATA #6, (N30P104N45)N45N45 P64N45  N45N45@116L8N38  L16 N45N45N45P24N45 N45N45L8N45 L16 @116
 4869 DATA --
 4870 DATA #0, L16A4&A32 L32 G+GF+FED+D R4.L16ER
 4871 DATA #1, C8.<B8.>C8<A8.G8.F+8
 4872 DATA #2, L16A8.E8.G8F+8.E8.D8
 4873 DATA #3, L16 A8.>C8.<A8>E8.C8.D8<
 4874 DATA #4, L16O3P64B>DF+B< P104B>DF+A< P64B>DF+B< P24B>DF+A<
 4875 DATA #5, L16O3P64 R32 B>DF+B< P104B>DF+A< P64B>DF+B< P24B>DF+A32<
 4876 DATA #6, (N49N30N46)(N30N46)N46N46 (N38N46)N46(N30N46)(N30N46) N46N46N46N46 N38N46N46N46
 4877 DATA --
 4878 DATA #0, A8.AR2>DD+EF
 4879 DATA #1, E8.D8.E8F+8.G8.A8
 4880 DATA #2, A8.E8.G8F+8.G8.A8
 4881 DATA #3, L16 A8.>C8.<A8>E8.C8.D8<
 4882 DATA #4, L16O3P64B>DF+B< P104B>DF+A< P64B>DF+B< P24B>DF+A<
 4883 DATA #5, L16O3P64 R32 B>DF+B< P104B>DF+A< P64B>DF+B< P24B>DF+A32<
 4884 DATA #6, (N30N46)(N30N46)N46N46 (N38N46)N46(N46N30)(N46N30) N46N46N46N46 N38N38N38N38
 4885 DATA --
 4886 DATA #0, L12 FFF FFF D<BG+ FD<Bl120 !1 Rl80 L16 dc
 4887 DATA #1, @54V5O5B12B12B12B12B12B12B12G+12F12D12<B12G+12
 4888 DATA #2, B12B12B12B12B12B12 G+12F12D12<B12G+12F12
 4889 DATA #3, L16 B12B12B12B12B12B12>F12D12<B12G+12F12G+12
 4890 DATA #4, P104@51V8 O3 B8 L96 B>CC+DD+EFF+GG+AA+ B>CC+DD+EFF+GG+AA+B4.&B4
 4891 DATA #5, P24@51V8  O3 R32 B8 L96 B>CC+DD+EFF+GG+AA+ B>CC+DD+EFF+GG+AA+B4.&B8..
 4892 DATA #6, L12 P104 N45N45N45 P64N45N45N45 P24N45N45N45 @116 N38N45N38 L16
 4893 '
 4894 '###############################
 4895 '      STAGE 6 BOSS
 4896 '###############################
 4897 DATA SONG 2
 4898 DATA \A = \L16(N30C)N46(N30N46)(N38N46) (N30N46)(N30N46)N46(N30N46) (N30N46)(N38N46)N46N46\
 4899 DATA \B = \L16(CN30)N46(N30N46)(N38N46) N46(N30N46)(N30N46)N46 (N30N46)(N38N46)N46 (N30N46)\
 4900 DATA \C = \(N30N46)N46(N30N46)(N38N46)N46(N30N46)(N30N46)N46 P64 (N45N30)N45 P24(N45N30)(N45N30)@116\
 4901 DATA \D = \(N30N46)N46 (N30N46)(N38N46) N46N30 P104 N45N45 P64 N45N45 P24 N45N45 @116\
 4902 DATA \E = \(N30N46)N46(N30N46)(N38N46) N46N30 N38N38 N38N38N38N38\
 4903 DATA --
 4904 DATA #0, T150 dc P64@55V9 O7 L32 G+AG+A G+AG+A G+AG+A AA+AA+ AA+AA+ AA+AA+
 4905 DATA #1, P64@51V8 O3 A4.A+4.
 4906 DATA #2, P64@54V8 O4 L16 D<BG+FDF>EC<AEA>C
 4907 DATA #3, @61V10q2O2 L16 A8A>CEC<A+8A+>FD<A+
 4908 DATA #4, P104@51V6 O3 B8 L96 B>CC+DD+EFF+GG+AA+ B>CC+DD+EFF+GG+AA+ B4.
 4909 DATA #5, P24@51V6O3 B8~65;65; L96 B>CC+DD+EFF+GG+AA+ B>CC+DD+EFF+GG+AA+B4.
 4910 DATA #6, L16@116V14 \A
 4911 DATA --
 4912 DATA #0, A+BA+BA+BA+BA+BA+BB>C<B>C<B>C<B>C<B>C<B>C<
 4913 DATA #1, G+4.A4.
 4914 DATA #2, EC<AE>ECFC+<A+F>FC
 4915 DATA #3, L16 G+8G+>D<BG+A8EA>C<E
 4916 DATA #4, O3 B8 L96 B>CC+DD+EFF+GG+AA+ B>CC+DD+EFF+GG+AA+ B4.
 4917 DATA #5, O3 B8 L96 B>CC+DD+EFF+GG+AA+ B>CC+DD+EFF+GG+AA+B4.
 4918 DATA #6, \D
 4919 DATA --
 4920 DATA #0, G+AG+A G+AG+A G+AG+A AA+AA+ AA+AA+ AA+AA+
 4921 DATA #1, A4.A+4.
 4922 DATA #2, D<BG+FDF>EC<AEA>C
 4923 DATA #3, L16 A8A>CEC<A+8A+>FD<A+
 4924 DATA #4, O3 B8 L96 B>CC+DD+EFF+GG+AA+ B>CC+DD+EFF+GG+AA+ B4.
 4925 DATA #5, O3 B8 L96 B>CC+DD+EFF+GG+AA+ B>CC+DD+EFF+GG+AA+B4.
 4926 DATA #6, \A
 4927 DATA --
 4928 DATA #0, A+BA+BA+BA+BA+BA+BB>C<B>C<B>C<B>C<B>C<B>C<
 4929 DATA #1, >D+4.D4.<
 4930 DATA #2, EC<AE>ECFC+<A+F>FC
 4931 DATA #3, L16 G+8G+>D<BG+A8EA>C<E
 4932 DATA #4, O3 B8 L96 B>CC+DD+EFF+GG+AA+ B>CC+DD+EFF+GG+AA+ B4.
 4933 DATA #5, O3 B8 L96 B>CC+DD+EFF+GG+AA+ B>CC+DD+EFF+GG+AA+B4.
 4934 DATA #6, \E
 4935 DATA --
 4936 DATA #0, G+AG+A G+AG+A G+AG+A AA+AA+ AA+AA+ AA+AA+
 4937 DATA #1, A4.A+4.
 4938 DATA #2, D<BG+FDF>EC<AEA>C
 4939 DATA #3, L16 A8A>CEC<A+8A+>FD<A+
 4940 DATA #4, O3 B8 L96 B>CC+DD+EFF+GG+AA+ B>CC+DD+EFF+GG+AA+ B4.
 4941 DATA #5, O3 B8 L96 B>CC+DD+EFF+GG+AA+ B>CC+DD+EFF+GG+AA+B4.
 4942 DATA #6, \A
 4943 DATA --
 4944 DATA #0, A+BA+BA+BA+BA+BA+BB>C<B>C<B>C<B>C<B>C<B>C<
 4945 DATA #1, G+4.A4.
 4946 DATA #2, EC<AE>ECFC+<A+F>FC
 4947 DATA #3, L16 G+8G+>D<BG+A8EA>C<E
 4948 DATA #4, O3 B8 L96 B>CC+DD+EFF+GG+AA+ B>CC+DD+EFF+GG+AA+ B4.
 4949 DATA #5, O3 B8 L96 B>CC+DD+EFF+GG+AA+ B>CC+DD+EFF+GG+AA+B4.
 4950 DATA #6, (N30N46)N46(N30N46)(N38N46) N46N30N46N46 N46(N46N38)N46N46
 4951 DATA --
 4952 DATA #0, G+AG+A G+AG+A G+AG+A AA+AA+ AA+AA+ AA+AA+
 4953 DATA #1, A4.A+4.
 4954 DATA #2, D<BG+FDF>EC<AEA>C
 4955 DATA #3, L16 A8A>CEC<A+8A+>FD<A+
 4956 DATA #4, O3 B8 L96 B>CC+DD+EFF+GG+AA+ B>CC+DD+EFF+GG+AA+ B4.
 4957 DATA #5, O3 B8 L96 B>CC+DD+EFF+GG+AA+ B>CC+DD+EFF+GG+AA+B4.
 4958 DATA #6, \A
 4959 DATA --
 4960 DATA #0, A+BA+BA+BA+BA+BA+BB>C<B>C<B>C<B>C<B>C<B>C<
 4961 DATA #1, >D+4D16D+16E16F16F+16G16G+16A16<<
 4962 DATA #2, EC<AE>ECFC+<A+F>FC
 4963 DATA #3, L16 G+8G+>D<BG+A8EA>C<B
 4964 DATA #4, O3 B8 L96 B>CC+DD+EFF+GG+AA+ B>CC+DD+EFF+GG+AA+ B4.
 4965 DATA #5, O3 B8 L96 B>CC+DD+EFF+GG+AA+ B>CC+DD+EFF+GG+AA+B4.
 4966 DATA #6, \D
 4967 DATA --
 4968 DATA #0, @50O4V10 L16 A+4>DC+D4FE
 4969 DATA #1, A+4.>D4.
 4970 DATA #2, O3L16 A+8FA+>FD<A+8FA+>FD<
 4971 DATA #3, L16 A+8A+>DFD<A+8A+>DFD<
 4972 DATA #4, P64@60V8 O3 A2.
 4973 DATA #5, P64@50V8 O4L16A+4>DC+D4FE
 4974 DATA #6, \B
 4975 DATA --
 4976 DATA #0, F4G+G G+4F8
 4977 DATA #1, F4.D4.
 4978 DATA #2, L16 A+8FA+>FD<A+8FA+>FD<
 4979 DATA #3, L16 A+8A>DFD<A+8A+>FD<A
 4980 DATA #4, A2.
 4981 DATA #5, F4G+GG+4F8<
 4982 DATA #6, \C
 4983 DATA --
 4984 DATA #0, <G+4BA+B4>DC+
 4985 DATA #1, <G+4.B4.
 4986 DATA #2, L16 B8G+B>FD<B8G+B>FD<
 4987 DATA #3, L16 B8B>DFD<B8B>DFD<
 4988 DATA #4, G+2.
 4989 DATA #5, G+4BA+B4>DC+
 4990 DATA #6, \B
 4991 DATA --
 4992 DATA #0, D4FEF4D8<
 4993 DATA #1, >F4.D4.
 4994 DATA #2, L16 B8G+B>FD<B8G+B>FD<
 4995 DATA #3, L16 B8B>DFD<B8B>FD<B
 4996 DATA #4, G+2.
 4997 DATA #5, D4FEF4D8<
 4998 DATA #6, \C
 4999 DATA --
 5000 DATA #0, A+4>DC+D4FE
 5001 DATA #1, <A+4.>D4.
 5002 DATA #2, L16 A+8FA+>FD<A+8FA+>FD<
 5003 DATA #3, L16 A+8A+>DFD<A+8A+>DFD<
 5004 DATA #4, G2.
 5005 DATA #5, A+4>DC+D4FE
 5006 DATA #6, \B
 5007 DATA --
 5008 DATA #0, F4G+G G+8B8G+8
 5009 DATA #1, F4.A4.
 5010 DATA #2, L16 A+8FA+>FD<A+8FA+>FD<
 5011 DATA #3, L16 A+8A>DFD<A+8A+>FD<A
 5012 DATA #4, G2.
 5013 DATA #5, F4G+GG+8B8G+8
 5014 DATA #6, \E
 5015 DATA --
 5016 DATA #0, @55V9 O7 L32 G+AG+A G+AG+A G+AG+A AA+AA+ AA+AA+ AA+AA+
 5017 DATA #1, A4.A+4.
 5018 DATA #2, O4 L16 D<BG+FDF>EC<AEA>C
 5019 DATA #3, L16 A8A>CEC<A+8A+>FD<A+
 5020 DATA #4, P104V6 A4.A+4.
 5021 DATA #5, P24@60V6O3A4.A+4.
 5022 DATA #6, \A
 5023 DATA --
 5024 DATA #0, A+BA+BA+BA+BA+BA+BB>C<B>C<B>C<B>C<B>C<B>C<
 5025 DATA #1, G+4.A4.
 5026 DATA #2, EC<AE>ECFC+<A+F>FC
 5027 DATA #3, L16 G+8G+>D<BG+A8EA>C<E
 5028 DATA #4, G+4.A4.
 5029 DATA #5, G+4.A4.
 5030 DATA #6, \D
 5031 DATA --
 5032 DATA #0, G+AG+A G+AG+A G+AG+A AA+AA+ AA+AA+ AA+AA+
 5033 DATA #1, A4.A+4.
 5034 DATA #2, L16 D<BG+FDF>EC<AEA>C
 5035 DATA #3, L16 A8A>CEC<A+8A+>FD<A+
 5036 DATA #4, A4.A+4.
 5037 DATA #5, A4.A+4.
 5038 DATA #6, \A
 5039 DATA --
 5040 DATA #0, A+BA+BA+BA+BA+BA+BB>C<B>C<B>C<B>C<B>C<B>C<
 5041 DATA #1, >D+4.D4.
 5042 DATA #2, EC<AE>ECFC+<A+F>FC
 5043 DATA #3, L16 G+8G+>D<BG+A8EA>C<E
 5044 DATA #4, G+4.A4.
 5045 DATA #5, G+4.A4.
 5046 DATA #6, \E
 5047 DATA --
 5048 DATA #0, O6  GG+GG+ GG+GG+ GG+GG+ GG+GG+ GG+GG+ GG+GG+
 5049 DATA #1, L32 FED+DC+C<BA+AG+GF+FED+DC+C<BA+AG+GF+
 5050 DATA #2, O3 C+DEFGG+A+BA+G+GF
 5051 DATA #3, L16F8FFFFF8F8F8
 5052 DATA #4, F2.
 5053 DATA #5, F2.
 5054 DATA #6, \B
 5055 DATA --
 5056 DATA #0, GG+GG+ GG+GG+ GG+GG+ GG+GG+ GG+GG+ GG+GG+
 5057 DATA #1, FF+GG+AA+B>CC+DD+EFF+GG+AA+B>CC+DD+E
 5058 DATA #2, EDC+DEFGG+A+BA+G+
 5059 DATA #3, F8FFFFF8F8F8
 5060 DATA #4, F2.
 5061 DATA #5, F2.
 5062 DATA #6, (N30N46)N46(N30N46)(N46N38) N46N46(N30C)N30  N38N38P64N45N45@116
 5063 DATA --
 5064 DATA #0, L32O5 FF+FF+GG+GG+AA+AA+B>C<B>CDD+DD+EFEF
 5065 DATA #1, @54O3L16 G+B>D<B>DFDFG+FG+B
 5066 DATA #2, FG+BG+B>D<B>DFDFG+
 5067 DATA #3, L16 DFG+FG+BG+B>D<B>DF
 5068 DATA #4, R2.
 5069 DATA #5, R2.
 5070 DATA #6, P24 N45'32N45'32 N45N45N45 N45N45 P64 N45'32N45'32 N45 N45N45N45N45@116
 5071 DATA --
 5072 DATA #0, F+GF+GG+AG+AA+BA+B>CC+CC+DD+DD+EFEF
 5073 DATA #1, O4 G+B>D<B>DFDFG+FD<B
 5074 DATA #2, FG+BO4G+B>D<B>FD<BG+F
 5075 DATA #3, L16 DFG+FG+BG+>D<BG+FD<
 5076 DATA #4, R2.
 5077 DATA #5, R2.
 5078 DATA #6, N38N38N38N38 N38N38 P24N45N45 N45 P64N45N45N45 @116
 5079 DATA --
 5080 DATA #0, L16 R4V5G+ [2 G+ G+ [2 G+ G+ [2 G+ G+ [2 G+ dc
 5081 DATA #1, L16 R4@55V5O7F[2FF[2FF[2FF[2F
 5082 DATA #2, @49V5O7 L16 R4D[2DD[2DD[2DD[2D
 5083 DATA #3, R2.
 5084 DATA #4, R4 @49V5O5L16 F[2FF[2FF[2FF[2F
 5085 DATA #5, R4@49V5O5L16 F[2FF[2FF[2FF[2F
 5086 DATA #6, N38'32N38'32N38N38N38  N38N38P24N45'32N45'32N45  N45N45N45N45
 5087 DATA ENDSONG
 5088 '
 5089 '###############################
 5090 '      STAGE 7 SONG DATA
 5091 '###############################
 5092 *MS7
 5093 DATA SONG 1
 5094 DATA \R=\L8(N30N43)(N30N43)(N38N43)(N30N43)(N30N43)(N30N43N49)L16(N38N45)N45(N30N45)N45\
 5095 DATA --
 5096 DATA #0,T170P64 @8 V7O3G1>D1
 5097 DATA #1,P64 @8 V6O3D1A1>
 5098 DATA #2,P64 @5  O3V3L8GGGGGGGG[4GGGGGGGG[4
 5099 DATA #3,P104@8V5O3D1~65;65;A1>
 5100 DATA #7,@116 L8N43N43N43N43[2N43N43N43N43[2N43N43N43N43[2N43N43N43N43[2
 5101 DATA --
 5102 DATA #0,F1B-1
 5103 DATA #1,C1F1
 5104 DATA #2,GGGGGGGG[4GGGGGGGG
 5105 DATA #3,C1F1
 5106 DATA #7,N43N43N43N43[2N43N43N43N43[2N43N43N43N43[4N43N43L16(N41N38)(N41N38)(N41N38)(N41N38)
 5107 DATA --
 5108 DATA #0,L16>DR]2DR]2DR]2DR]2DR]2DR]2DR]2DRR1
 5109 DATA #1,L16AR]2AR]2AR]2AR]2AR]2AR]2AR]2ARR1
 5110 DATA #2,V10L8O3G>DGC4FE-DL8O3G>DGC4FE-D
 5111 DATA #3,L16AR]2AR]2AR]2AR]2AR]2AR]2AR]2ARR1
 5112 DATA #7,V15\R\R
 5113 DATA --
 5114 DATA #0,R1R1
 5115 DATA #1,R1R2. @15 V11O5L16P24GB->DG
 5116 DATA #2,L8O3G>DGC4FE-DL8O3G>DGC4FE-D
 5117 DATA #3,R1R1
 5118 DATA #7,\R\R
 5119 DATA --
 5120 DATA #0,dc @14 V9 O5L8 A2B-2>C4<B-8>C4<B-8A8G8
 5121 DATA #1,P104<GB->DG  R4R2 R1
 5122 DATA #2,L8O3G>DGC4FE-DL8O3G>DGC4FE-D
 5123 DATA #3,P64 @14 V8 O5L8 D2G2A4G8A4G8F8D8
 5124 DATA #7,\R\R
 5125 DATA #8,@14 V9 O5L8
 5126 DATA #6,@14 V9 O5L8
 5127 DATA --
 5128 'DATA #0,B-8D8R8]2B-8D8R8]2B-8D8R8]2B-8D8R8]2B-8D8R4[8
 5129 DATA #0, P64B-8D2         P104R8]4B-8D2         R8]4B-8D4. [8P64
 5130 DATA #8, P24    R4.]2B-8D2         R8]4B-8D2         R4[6
 5131 DATA #1,R1R2R4<GB->DG
 5132 DATA #2,L8O3G>DGC4FE-DL8O3G>DGC4FE-D
 5133 'DATA #3,D8<B-8>R8]2D8<B-8>R8]2D8<B-8>R8]2D8<B-8>R8]2D8<B-8>R4[8
 5134 DATA #3, P64D8<B-2>           P104R8]4D8<B-2>           R8]4D8<B-4.> [8P64
 5135 DATA #6, P24      R4.]2D8<B-2>           R8]4D8<B-2>           R4[6
 5136 DATA #7,\R\R
 5137 DATA --
 5138 DATA #0,L8 A2B-2>C4<B-8>C4<B-8A8G8
 5139 DATA #1,P24<GB->DG   R4R2 R1
 5140 DATA #2,L8O3G>DGC4FE-DL8O3G>DGC4FE-D
 5141 DATA #3,L8 D2G2A4G8A4G8F8D8
 5142 DATA #7,\R\R
 5143 DATA --
 5144 'DATA #0,B-8D8R8]2B-8D8R8]2B-8D8R8]2B-8D8R8]2B-8D8R4[8
 5145 DATA #0, P64B-8D2   P104    R8]4B-8D2         R8]4B-8D4. [8P64
 5146 DATA #8, P24    R4.]2B-8D2         R8]4B-8D2         R4[6
 5147 DATA #1,R1R2R4<GB->E-G
 5148 DATA #2,L8O3G>DGC4FE-DL8O3G>DGC4FE-D
 5149 'DATA #3,D8<B-8>R8]2D8<B-8>R8]2D8<B-8>R8]2D8<B-8>R8]2D8<B-8>R4[8
 5150 DATA #3, P64D8<B-2>    P104       R8]4D8<B-2>           R8]4D8<B-4.> [8 P64
 5151 DATA #6, P24    R4.]2D8<B-2>           R8]4D8<B-2>           R4[6
 5152 DATA #7,\R\R
 5153 DATA --
 5154 DATA #0,L8E-2G2B-2R8G8A8B-8>
 5155 DATA #1,P104<GB->E-G R4R2 R1
 5156 DATA #2,L8O3E-B->E-<G4>C<B-AL8O3E-B->E-<G4>C<B-A
 5157 DATA #3,L8<B-2>E-2G2R8E-8F8G8
 5158 DATA #7,\R\R
 5159 DATA --
 5160 DATA #0,C8R2..R2R8<B-8A8G8
 5161 DATA #1,R1R2R4<GB->DG
 5162 DATA #2,L8O3E-B->E-<G4>C<B-AL8O3E-B->E-<G4>C<B-A
 5163 DATA #3,E-8R4.R1R8G8F8E-8
 5164 DATA #7,\R\R
 5165 DATA --
 5166 'DATA #0,L8B-8G8R8]2B-8G8R8]2B-8G8R8]2B-8G8R8]2B-8G8R4[8
 5167 DATA #0,L8P64B-8G2  P104 R8]4B-8G2         R8]4B-8G4. [8P64
 5168 DATA #8,P24 R4.  ]2B-8G2         R8]4B-8G2         R4[6
 5169 DATA #1,P24<GB->DG   R4R2 R1
 5170 DATA #2,L8O3G>DGC4FE-DL8O3G>DGC4FE-D
 5171 'DATA #3,L8   G8D8R8]2G8D8R8]2G8D8R8]2G8D8R8]2G8D8R4[8
 5172 DATA #3,L8P64G8D2  P104   R8]4G8D2        R8]4G8D4. [8P64
 5173 DATA #6,P24 R4.    ]2G8D2        R8]4G8D2        R4[6
 5174 DATA #7,\R\R
 5175 DATA --
 5176 'DATA #0,L8B-8G8R8]2B-8G8R8]2B-8G8R8]2B-8G8R8]2B-8G8R4[8
 5177 DATA #0,L8P64B-8G2  P104 R8]4B-8G2         R8]4B-8G4&G16&Gl40 !1 Rl80 [8P64
 5178 DATA #8,P24 R4.  ]2B-8G2         R8]4B-8G2         R4[6
 5179 DATA #1,R1R2R4<GB->DG
 5180 DATA #2,L8O3G>DGC4FE-DL8O3G>DGC4FE-D
 5181 'DATA #3,L8G8D8R8]2G8D8R8]2G8D8R8]2G8D8R8]2G8D8R4[8
 5182 DATA #3,L8P64G8D2  P104   R8]4G8D2        R8]4G8D4. [8P64
 5183 DATA #6,P24 R4.    ]2G8D2        R8]4G8D2        R4[6
 5184 DATA #7,\R\R
 5185 DATA --
 5186 DATA #0,L8 A2B-2>C4<B-8>C4<B-8A8G8
 5187 DATA #1,P104<GB->DG  R4R2 R1
 5188 DATA #2,L8O3G>DGC4FE-DL8O3G>DGC4FE-D
 5189 DATA #3,L8 D2G2A4G8A4G8F8D8
 5190 DATA #7,\R\R
 5191 DATA --
 5192 'DATA #0,B-8D8R8]2B-8D8R8]2B-8D8R8]2B-8D8R8]2B-8D8R4[8
 5193 DATA #0,B-8D2         R8]4B-8D2         R8]4B-8D4. [8
 5194 DATA #8,    R4.]2B-8D2         R8]4B-8D2         R4[6
 5195 DATA #1,R1R2R4<GB->DG
 5196 DATA #2,L8O3G>DGC4FE-DL8O3G>DGC4FE-D
 5197 'DATA #3,D8<B-8>R8]2D8<B-8>R8]2D8<B-8>R8]2D8<B-8>R8]2D8<B-8>R4[8
 5198 DATA #3,D8<B-2>           R8]4D8<B-2>           R8]4D8<B-4.> [8
 5199 DATA #6,      R4.]2D8<B-2>           R8]4D8<B-2>           R4[6
 5200 DATA #7,\R\R
 5201 DATA --
 5202 DATA #0,L8 A2B-2>C4<B-8>C4<B-8A8G8
 5203 DATA #1,P24<GB->DG   R4R2 R1
 5204 DATA #2,L8O3G>DGC4FE-DL8O3G>DGC4FE-D
 5205 DATA #3,L8 D2G2A4G8A4G8F8D8
 5206 DATA #7,\R\R
 5207 DATA --
 5208 'DATA #0,B-8D8R8]2B-8D8R8]2B-8D8R8]2B-8D8R8]2B-8D8R4[8
 5209 DATA #0, B-8D2         R8]4B-8D2         R8]4B-8D4. [8
 5210 DATA #8,    R4.]2B-8D2         R8]4B-8D2         R4[6
 5211 DATA #1,R1R2R4<GB->E-G
 5212 DATA #2,L8O3G>DGC4FE-DL8O3G>DGC4FE-D
 5213 'DATA #3,D8<B-8>R8]2D8<B-8>R8]2D8<B-8>R8]2D8<B-8>R8]2D8<B-8>R4[8
 5214 DATA #3, D8<B-2>           R8]4D8<B-2>           R8]4D8<B-4.> [8
 5215 DATA #6,      R4.]2D8<B-2>           R8]4D8<B-2>           R4[6
 5216 DATA #7,\R\R
 5217 DATA --
 5218 DATA #0,L8E-2G2B-2R8G8A8B-8>
 5219 DATA #1,P104<GB->E-G R4R2 R1
 5220 DATA #2,L8O3E-B->E-<G4>C<B-AL8O3E-B->E-<G4>C<B-A
 5221 DATA #3,L8<B-2>E-2G2R8E-8F8G8
 5222 DATA #7,\R\R
 5223 DATA --
 5224 DATA #0,C8R2..R2R8<B-8A8G8
 5225 DATA #1,R1R2R4<GB->DG
 5226 DATA #2,L8O3E-B->E-<G4>C<B-AL8O3E-B->E-<G4>C<B-A
 5227 DATA #3,E-8R4.R1R8G8F8E-8
 5228 DATA #7,\R\R
 5229 DATA --
 5230 'DATA #0,L8B-8G8R8]2B-8G8R8]2B-8G8R8]2B-8G8R8]2B-8G8R4[8
 5231 DATA #0,L8P64B-8G2  P104 R8]4B-8G2         R8]4B-8G4. [8P64
 5232 DATA #8,P24 R4.  ]2B-8G2         R8]4B-8G2         R4[6
 5233 DATA #1,P24<GB->DG   R4R2 R1
 5234 DATA #2,L8O3G>DGC4FE-DL8     O3G>DGC4FE-D
 5235 'DATA #3,L8G8D8R8]2G8D8R8]2G8D8R8]2G8D8R8]2G8D8R4[8
 5236 DATA #3,L8P64G8D2  P104   R8]4G8D2        R8]4G8D4. [8P64
 5237 DATA #6,P24 R4.    ]2G8D2        R8]4G8D2        R4[6
 5238 DATA #7,\R\R
 5239 DATA --
 5240 'DATA #0,L8B-8G8R8]2B-8G8R8]2B-8G8R8]2B-8G8R8]2B-8G8R4[8
 5241 DATA #0,L8P64B-8G2  P104 R8]4B-8G2         R8]4B-8G4&G16&Gl40 !1 Rl80 [8P64
 5242 DATA #8,P24 R4.  ]2B-8G2         R8]4B-8G2         R4[6
 5243 DATA #1,R1R2R4<GB->D+G
 5244 DATA #2,L8O3G>DGC4FE-DL8     O3G>DGC4FE-D
 5245 'DATA #3,L8G8D8R8]2G8D8R8]2G8D8R8]2G8D8R8]2G8D8R4[8
 5246 DATA #3,L8P64G8D2  P104   R8]4G8D2        R8]4G8D4. [8P64
 5247 DATA #6,P24 R4.    ]2G8D2        R8]4G8D2        R4[6
 5248 DATA #7,\R\R
 5249 DATA --
 5250 DATA #0,E-2G2B-2A8B-8>C8<G8
 5251 DATA #1,P104<GB->D+GR4R2 R1
 5252 DATA #2,L8O4CG>C<E-4G>C<GL8  O4CG>C<E-4G>C<G
 5253 DATA #3,<B-2>E-2G2F8G8A8E-8
 5254 DATA #7,\R\R
 5255 DATA --
 5256 DATA #0,A1R2R8A8G+8G8
 5257 DATA #1,R1R2R4<F+A>DF+
 5258 DATA #2,L8O3F>CF<A4>CE-CL8   O3F>CF<A4>CE-C
 5259 DATA #3,F1R2R8F8E8E-8
 5260 DATA #7,\R\R
 5261 DATA --
 5262 DATA #0,F+1R8D8D+8F+8R8>C8<B-8A8
 5263 DATA #1,P24<FA+>DF+R4R2 R1
 5264 DATA #2,L8O4DA>D<F+4>C<B-AL8 O4DA>D<F+4>C<B-A
 5265 DATA #3,<A1R8A8A8>D8 R8F+8F+8F+8
 5266 DATA #7,\R\R
 5267 DATA --
 5268 DATA #0,A8B-8R8G8&G2D1
 5269 DATA #1,R1R2R4<GB->D+G
 5270 DATA #2,L8O3G>DG<B-4>E-<B-GL8O3G>DG<B-4>E-<B-G
 5271 DATA #3,F+8G8R8D8 R2<B-1
 5272 DATA #7,\R\R
 5273 DATA --
 5274 DATA #0,E-2G2B-2R8G8A8B-8>
 5275 DATA #1,P104<GB->D+GR4R2 R1
 5276 DATA #2,L8O4CG>C<E-4G>C<GL8  O4CG>C<E-4G>C<G
 5277 DATA #3,B-2>E-2G2F8G8A8E-8
 5278 DATA #7,\R\R
 5279 DATA --
 5280 DATA #0,C8R2..R2R8<A8B-8>C8
 5281 DATA #1,R1R2R4<F+A>DF+
 5282 DATA #2,L8O3F>CF<A4>CE-CL8   O3F>CF<A4>CE-C
 5283 DATA #3,F1R2R8F8G8A8
 5284 DATA #7,\R\R
 5285 DATA --
 5286 DATA #0,D1&D1&D1R2R4R8R16Rl40 !1 Rl80 dc
 5287 DATA #1,P24<FA+>DF+R4R2 R1R1R2R4<GB->DG
 5288 DATA #2,L8O4DA>D<F+4>C<B-AL8 O4DA>D<F+4>C<B-AL8O4DA>D<F+4>C<B-AL8O4DA>D<F+4>C<B-A
 5289 DATA #3,F+2 {GAB-}2> {C<B-A}2 {B-AG}2 {AGF+}2 {GF+E-}2D1
 5290 DATA #7,\R\R\R\R
 5291 '
 5292 '###############################
 5293 '      STAGE 7 BOSS
 5294 '###############################
 5295 DATA SONG 2
 5296 DATA #0,T170@18V11O5D1
 5297 DATA #1,@6O4V10C1~0;64;
 5298 DATA #2,@103O3L8V9G>DG<G4GG16>D16G16D16<
 5299 DATA #6,@116V15L8(N43N20)(N43N20)(N38N20)(N43N20)(N43N20)(N43N20N49)L16(N38N45)N45(N20N45)N45
 5300 DATA --
 5301 DATA #0,T175D+1
 5302 DATA #1,C1~0;64;
 5303 DATA #2,G>DG<G4GG16>D16G16D16<
 5304 DATA #6,L8(N43N20)(N43N20)(N38N20)(N43N20)(N43N20)(N43N20N49)L16(N38N45)N45(N20N45)N45
 5305 DATA --
 5306 DATA #0,T180E1
 5307 DATA #1,C1~0;64;
 5308 DATA #2,G>DG<G4GG16>D16G16D16<
 5309 DATA #6,L8(N43N20)(N43N20)(N38N20)(N43N20)(N43N20)(N43N20N49)L16(N38N45)N45(N20N45)N45
 5310 DATA --
 5311 DATA #0,T185F1
 5312 DATA #2,G>DG<G4GG16>D16G16D16<
 5313 DATA #6,L8(N43N20N49)(N43N20)(N38N20N49)(N43N20)N36(N38N40)(N38N40)(N38N40)
 5314 DATA --
 5315 DATA #0,R1R1
 5316 DATA #1,@19P84V11L8O5GB->DG<GB->DG<GB->DG<GB->DG<
 5317 DATA #2,GGAA+GGAA+GGAA+GGAA+
 5318 DATA #3,@19P24V10L8O5G~65;65;B->DG<GB->DG<GB->DG<GB->DG<
 5319 DATA #6,L8(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20
 5320 DATA --
 5321 DATA #0,R1R1
 5322 DATA #1,GB->DG<GB->DG<GB->DG<GB->DG<
 5323 DATA #2,GGAA+GGAA+GGAA+GGAA+
 5324 DATA #3,GB->DG<GB->DG<GB->DG<GB->DG<
 5325 DATA #6,L8(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20
 5326 DATA --
 5327 DATA #0,dc@109P84O5V11L8G2GDGB-AFCF4~64;64;350&F4~64;48;300&F8~48;48;150
 5328 DATA #1,@19P84V11L8O5GB->DG<GB->DG<GB->DG<GB->DG<
 5329 DATA #2,O3GGAA+GGAA+GGAA+GGAA+
 5330 DATA #3,@19P24V10L8O5G~65;65;B->DG<GB->DG<GB->DG<GB->DG<
 5331 DATA #4,@109P44O5V10L8G2~65;65;GDGB-AFCF4~65;65;350&F4~65;49;300&F8~49;49;150
 5332 DATA #6,L8(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20
 5333 DATA --
 5334 DATA #0,C4~64;;<B->CDC<B-AA~64;64;200&A~;70;200&A~;64;200FG2>
 5335 DATA #1,GB->DG<GB->DG<GB->DG<GB->DG<
 5336 DATA #2,GGAA+GGAA+GGAA+GGAA+
 5337 DATA #3,GB->DG<GB->DG<GB->DG<GB->DG<
 5338 DATA #4,C4~65;65;<B->CDC<B-AA~65;65;200&A~;71;200&A~;65;200FG2>
 5339 DATA #6,L8(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20
 5340 DATA --
 5341 DATA #0,G2GDGB-AFCF4~64;64;350&F4~64;48;300&F8~48;48;150
 5342 DATA #1,L8O5GB->DG<GB->DG<GB->DG<GB->DG<
 5343 DATA #2,GGAA+GGAA+GGAA+GGAA+
 5344 DATA #3,L8O5GB->DG<GB->DG<GB->DG<GB->DG<
 5345 DATA #4,G2GDGB-AFCF4~65;65;350&F4~65;49;300&F8~49;49;150
 5346 DATA #6,L8(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20
 5347 DATA --
 5348 DATA #0,C4~64;;<B->CDC<B-AA~64;64;200&A~;82;200&A~;64;200FG2>
 5349 DATA #1,GB->DG<GB->DG<GB->DG<GB->DG<
 5350 DATA #2,GGAA+GGAA+GGAA+GGAA+>
 5351 DATA #3,GB->DG<GB->DG<GB->DG<GB->DG<
 5352 DATA #4,C4~65;65;<B->CDC<B-AA~65;65;200&A~;83;200&A~;65;200FG2>
 5353 DATA #6,L8(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20
 5354 DATA --
 5355 DATA #0,F4E4F16E16DCEDEFGFEDC
 5356 DATA #1,L8DFA>D<DFA>D<DFA>D<DFA>D<
 5357 DATA #2,DDEF DDEF DDEF DDEF
 5358 DATA #3,L8DFA>D<DFA>D<DFA>D<DFA>D<
 5359 DATA #4,F4E4F16E16DCEDEFGFEDC
 5360 DATA #6,L8(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20
 5361 DATA --
 5362 DATA #0,EC<G>EC<G>ECFEFG~64;64;150&G2~64;75;500
 5363 DATA #1,DFA>D<DFA>D<DFA>D<DFA>D<
 5364 DATA #2,DDEF DDEF DDEF DDEF
 5365 DATA #3,DFA>D<DFA>D<DFA>D<DFA>D<
 5366 DATA #4,EC<G>EC<G>ECFEFG~65;65;150&G2~65;76;500
 5367 DATA #6,L8(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20
 5368 DATA --
 5369 DATA #0,F4~64;;E4F16E16DCEDEFGFEDC
 5370 DATA #1,L8DFA>D<DFA>D<DFA>D<DFA>D<
 5371 DATA #2,DDEF DDEF DDEF DDEF
 5372 DATA #3,L8DFA>D<DFA>D<DFA>D<DFA>D<
 5373 DATA #4,F4~65;65;E4F16E16DCEDEFGFEDC
 5374 DATA #6,L8(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20
 5375 DATA --
 5376 DATA #0,L8EC<G>EC<G>ECF16E16DCE<L16A>DFDFDFA
 5377 DATA #1,DFA>D<DFA>D<DFA>D<DFA>D<
 5378 DATA #2,DDEF DDEF DDEF DDEF<
 5379 DATA #3,DFA>D<DFA>D<DFA>D<DFA>D<
 5380 DATA #4,L8EC<G>EC<G>ECF16E16DCE<L16A>DFDFDFA
 5381 DATA #6,L8(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20
 5382 DATA --
 5383 DATA #0,L8G2GDGB-AFCF4~64;64;350&F4~64;48;300&F8~48;48;150
 5384 DATA #1,L8O5GB->DG<GB->DG<GB->DG<GB->DG<
 5385 DATA #2,GGAA+GGAA+GGAA+GGAA+
 5386 DATA #3,L8O5GB->DG<GB->DG<GB->DG<GB->DG<
 5387 DATA #4,L8G2GDGB-AFCF4~65;65;350&F4~65;49;300&F8~49;49;150
 5388 DATA #6,L8(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20
 5389 DATA --
 5390 DATA #0,C4~64;;<B->CDC<B-AA~64;64;200&A~;70;200&A~;64;200FG2>
 5391 DATA #1,GB->DG<GB->DG<GB->DG<GB->DG<
 5392 DATA #2,GGAA+GGAA+GGAA+GGAA+
 5393 DATA #3,GB->DG<GB->DG<GB->DG<GB->DG<
 5394 DATA #4,C4~65;65;<B->CDC<B-AA~65;65;200&A~;71;200&A~;65;200FG2>
 5395 DATA #6,L8(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20
 5396 DATA --
 5397 DATA #0,L8G2GDGB-AFCF4~64;64;350&F4~64;48;300&F8~48;48;150
 5398 DATA #1,L8O5GB->DG<GB->DG<GB->DG<GB->DG<
 5399 DATA #2,GGAA+GGAA+GGAA+GGAA+
 5400 DATA #3,L8O5GB->DG<GB->DG<GB->DG<GB->DG<
 5401 DATA #4,L8G2GDGB-AFCF4~65;65;350&F4~65;49;300&F8~49;49;150
 5402 DATA #6,L8(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20
 5403 DATA --
 5404 DATA #0,C4~64;;<B->CDC<B-AA~64;64;200&A~;82;200&A~;64;200FG2>
 5405 DATA #1,GB->DG<GB->DG<GB->DG<GB->DG<
 5406 DATA #2,GGAA+GGAA+GGAA+GGAA+
 5407 DATA #3,GB->DG<GB->DG<GB->DG<GB->DG<
 5408 DATA #4,C4~65;65;<B->CDC<B-AA~64;64;200&A~;82;200&A~;64;200FG2>
 5409 DATA #6,L8(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20
 5410 DATA --
 5411 DATA #0,F4E4F16E16DCEDEFGFEDC
 5412 DATA #1,L8DFA>D<DFA>D<DFA>D<DFA>D<
 5413 DATA #2,>DDEFDDEFDDEFDDEF
 5414 DATA #3,L8DFA>D<DFA>D<DFA>D<DFA>D<
 5415 DATA #4,F4E4F16E16DCEDEFGFEDC
 5416 DATA #6,L8(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20
 5417 DATA --
 5418 DATA #0,EC<G>EC<G>ECFEFG~64;64;150&G2~64;75;500
 5419 DATA #1,DFA>D<DFA>D<DFA>D<DFA>D<
 5420 DATA #2,DDEFDDEFDDEFDDEF
 5421 DATA #3,DFA>D<DFA>D<DFA>D<DFA>D<
 5422 DATA #4,EC<G>EC<G>ECFEFG~65;65;150&G2~65;76;500
 5423 DATA #6,L8(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20
 5424 DATA --
 5425 DATA #0,F4~64;;E4F16E16DCEDEFGFEDC
 5426 DATA #1,L8DFA>D<DFA>D<DFA>D<DFA>D<
 5427 DATA #2,DDEFDDEFDDEFDDEF
 5428 DATA #3,L8DFA>D<DFA>D<DFA>D<DFA>D<
 5429 DATA #4,F4~65;65;E4F16E16DCEDEFGFEDC
 5430 DATA #6,L8(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20
 5431 DATA --
 5432 DATA #0,L16 EC<G>EC<G>EC<G>EC<G>L8ECF16E16DCE<L16A>DFDFDFA
 5433 DATA #1,DFA>D<DFA>D<DFA>D<DFA>D<
 5434 DATA #2,DDEFDDEFDDEFDDEF
 5435 DATA #3,DFA>D<DFA>D<DFA>D<DFA>D<
 5436 DATA #4,L16 EC<G>EC<G>EC<G>EC<G>L8ECF16E16DCE<L16A>DFDFDFA
 5437 DATA #6,L8(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20
 5438 DATA --
 5439 DATA #0,V9P64 L8<G>CDE<G>CDE<G>CDE<G>CDE
 5440 DATA #1,@18P84V12O6D+16E8.D+16E8.D+16E4..L8R8EC<GL16G>CECEGEC
 5441 DATA #2,CCCC16C16CCCC16C16CCCC16C16CCCC16C16
 5442 DATA #3,@18P24V10O6D+16~65;65;E8.D+16E8.D+16E4..L8R8EC<GL16G>CECEGEC
 5443 DATA #6,(N43N20)(N43N20)N38(N43N20)(N43N20)(N43N20)N38(N43N20)(N43N20)(N43N20)N38(N43N20)(N43N20)(N43N20)N38(N43N20)
 5444 DATA #7,@117V15L8R4N37R8R8N37N37R8R4N37R8R8N37N37R8
 5445 DATA #8,@18V9O5F+16G8.F+16G8.F+16G4..L8R8>C<GEL16EG>C<G>CEC<G
 5446 DATA --
 5447 DATA #0,<FA>CF<FA>CF<FA>CF<FA>CF
 5448 DATA #1,<B-4.A8A1.>
 5449 DATA #2,<FFFF16F16FFFF16F16FFFF16F16FFFF16F16
 5450 DATA #3,<B-4.A8A1.>
 5451 DATA #6,(N43N20)(N43N20)N38(N43N20)(N43N20)(N43N20)N38(N43N20)(N43N20)(N43N20)N38(N43N20)(N43N20)(N43N20)N38(N43N20)
 5452 DATA #7,@117V15L8R4N37R8R8N37N37R8R4N37R8R8N37N37R8
 5453 DATA #8,F4.F8F1.
 5454 DATA --
 5455 DATA #0,<A>DF+A<A>DF+A<A>DF+A<A>DF+A
 5456 DATA #1,L8C+16D8.C+16D8.C+16D4..L8R8D+DCDE-DC
 5457 DATA #2,>DDDD16D16DDDD16D16DDDD16D16DDDD16D16
 5458 DATA #3,L8C+16D8.C+16D8.C+16D4..L8R8D+DCDE-DC
 5459 DATA #6,(N43N20)(N43N20)N38(N43N20)(N43N20)(N43N20)N38(N43N20)(N43N20)(N43N20)N38(N43N20)(N43N20)(N43N20)N38(N43N20)
 5460 DATA #7,@117V15L8R4N37R8R8N37N37R8R4N37R8R8N37N37R8
 5461 DATA #8,F+4F+4F+2R1
 5462 DATA --
 5463 DATA #0,<GB->DG<GB->DG<GB->DG<GB->DG
 5464 DATA #1,<G2A2B-1>
 5465 DATA #2,<GGGG16G16GGGG16G16GGGG16G16GGGG16G16
 5466 DATA #3,<G2A2B-1>
 5467 DATA #6,(N43N20)(N43N20)N38(N43N20)(N43N20)(N43N20)N38(N43N20)(N43N20)(N43N20)N38(N43N20)(N43N20)(N43N20)N38(N43N20)
 5468 DATA #7,@117V15L8R4N37R8R8N37N37R8R4N37R8R8N37N37R8
 5469 DATA #9,@119R4C4R4C4R4C4R8@120C8C8C8
 5470 DATA --
 5471 DATA #0,L8<G>CDE<G>CDE<G>CDE<G>CDE
 5472 DATA #1,D+16E8.D+16E8.D+16E4..L8R8EC<GL16G>CECEGEC
 5473 DATA #2,>CCCC16C16CCCC16C16CCCC16C16CCCC16C16
 5474 DATA #3,D+16E8.D+16E8.D+16E4..L8R8EC<GL16G>CECEGEC
 5475 DATA #6,(N43N20)(N43N20)N38(N43N20)(N43N20)(N43N20)N38(N43N20)(N43N20)(N43N20)N38(N43N20)(N43N20)(N43N20)N38(N43N20)
 5476 DATA #7,@117V15L8R4N37R8R8N37N37R8R4N37R8R8N37N37R8
 5477 DATA #8,F+16G8.F+16G8.F+16G4..L8R8>C<GEL16EG>C<G>CEC<G
 5478 DATA --
 5479 DATA #0,<FA>CF<FA>CF<FA>CF<FA>CF
 5480 DATA #1,<B-4.A8A1.>
 5481 DATA #2,<FFFF16F16FFFF16F16FFFF16F16FFFF16F16
 5482 DATA #3,<B-4.A8A1.>
 5483 DATA #6,(N43N20)(N43N20)N38(N43N20)(N43N20)(N43N20)N38(N43N20)(N43N20)(N43N20)N38(N43N20)(N43N20)(N43N20)N38(N43N20)
 5484 DATA #7,@117V15L8R4N37R8R8N37N37R8R4N37R8R8N37N37R8
 5485 DATA #8,F4.F8F1.
 5486 DATA --
 5487 DATA #0,<A>C+EA<A>C+EA<A>C+EA<A>C+EA
 5488 DATA #1,<L8G+16A8.G+16A8.G+16A4..R8L8B-AGFGAB-
 5489 DATA #2,AAAA16A16AAAA16A16AAAA16A16AAAA16A16
 5490 DATA #3,<L8G+16A8.G+16A8.G+16A4..R8L8B-AGFGAB-
 5491 DATA #6,(N43N20)(N43N20)N38(N43N20)(N43N20)(N43N20)N38(N43N20)(N43N20)(N43N20)N38(N43N20)(N43N20)(N43N20)N38(N43N20)
 5492 DATA #7,@117V15L8R4N37R8R8N37N37R8R4N37R8R8N37N37R8
 5493 DATA #8,C+4C+4C+2R1
 5494 DATA --
 5495 DATA #0,<A>DF+A<A>DF+A<A>DF+A<A>DF+A
 5496 DATA #1,F+4.G4.G4A2L8{AB>C}{DEF}{GAB}{>CDE}
 5497 DATA #2,>DDDD16D16DDDD16D16DDDD16D16DDDD16D16
 5498 DATA #3,F+4.G4.G4A2L8{AB>C}{DEF}{GAB}{>CDE}
 5499 DATA #6,(N43N20)(N43N20)N38(N43N20)(N43N20)(N43N20)N38(N43N20)(N43N20)(N43N20)N38(N43N20)(N43N20)(N43N20)N38(N43N20)
 5500 DATA #7,@117V15L8R4N37R8R8N37N37R8R4N37R8R8N37N37N37
 5501 DATA --
 5502 DATA #0,GAB->C<GAB->C<GAB->C<GAB->C<
 5503 DATA #1,@14P84O5V10L8G2G8D8GB-G2G8D8GB-
 5504 DATA #2,GGGGGGGG16G16FFFFFFFF16F16
 5505 DATA #3,@14O5V9 P24L8G2~65;65;G8D8GB-G2G8D8GB-
 5506 DATA #6,L8(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20
 5507 DATA #7,@117V15L4N40N40N40N40N40N40N40N40
 5508 DATA --
 5509 DATA #0,GAB->C<GAB->C<GAB->C<GAB->C<
 5510 DATA #1,G2G8D8GB-G2G8D8GB-
 5511 DATA #2,EEEEEEEE16E16E-E-E-E-E-E-E-E-16E-16
 5512 DATA #3,G2G8D8GB-G2G8D8GB-
 5513 DATA #6,L8(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20
 5514 DATA #7,L4N40N40N40N40N40N40N40N40
 5515 DATA --
 5516 DATA #0,GAB->C<GAB->C<GAB->C<GAB->C<
 5517 DATA #1,L8G2G8D8GB-G2G8D8GB-
 5518 DATA #2,GGGGGGGG16G16FFFFFFFF16F16
 5519 DATA #3,L8G2G8D8GB-G2G8D8GB-
 5520 DATA #6,L8(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20
 5521 DATA #7,L4N40N40N40N40N40N40N40N40
 5522 DATA --
 5523 DATA #0,GAB->C<GAB->C<GAB->C<GAB->C<
 5524 DATA #1,G2G8D8GB-G2G8D8GB-
 5525 DATA #2,EEEEEEEE16E16E-E-E-E-E-E-E-E-16E-16
 5526 DATA #3,G2G8D8GB-G2G8D8GB-
 5527 DATA #6,L8(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20
 5528 DATA #7,L4N40N40N40N40N40N40N40N40
 5529 DATA --
 5530 DATA #0,G1&G1dc
 5531 DATA #1,G1&G1
 5532 DATA #2,<GGGGGGGG16G16GGGGGGGG16G16
 5533 DATA #3,G1&G1
 5534 DATA #6,L8(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20(N20N51)N20(N38N51)N20
 5535 DATA #7,R1R1
 5536 DATA ENDSONG
 5537 '
 5538 '###############################
 5539 '      STAGE 8 SONG DATA
 5540 '###############################
 5541 *MS8
 5542 DATA SONG 1
 5543 DATA \A = \(N46 N30 )(N46 N30 )(N46 N38 )(N46 N30 )  (N46 N30 )(N46 N30 )(N46 N38 )(N46 N30 )\
 5544 DATA \B = \L1 (N30 N38 N49 ) R8 L8 (N30 P104N45 ) L4 N45\
 5545 DATA \C = \@116 L16 N45  N45  N45   N45  P24 N45  N45   N45  N45  L8 @116\
 5546 DATA --
 5547 DATA #0, T170@1P64V11O5 dc L8 G2D2 A2RB->CD
 5548 DATA #1, @1P84V10O4 L8 B-2B-2> C2&CDE-F
 5549 DATA #2, @5P64V11 L8O3G G >G <G G G >G <G L8O3G G >G <G G G >G <G
 5550 DATA #3, @1P104V11O5 L8 G2~65;65;D2 A2RB->CD
 5551 DATA #4, @1P44V10O4 L8 B-2~65;65;B-2> C2&CDE-F
 5552 DATA #6, @116V15L8 \A\A
 5553 DATA --
 5554 DATA #0, <A4.F4.C4 A2RFGA
 5555 DATA #1, F4.C4.<A4 >F1<
 5556 DATA #2, L8O3F F >F <F F F >F <F  L8O3F F >F <F F F >F <F
 5557 DATA #3, <A4.F4.C4 A2RFGA
 5558 DATA #4, F4.C4.<A4 >F1<
 5559 DATA #6, \A\A
 5560 DATA --
 5561 DATA #0, G2E-2 B-2B-GAB-16&B-l40 !1 Rl80 >
 5562 DATA #1, B-2B-2> G2&GE-FG
 5563 DATA #2, L8O3E-E->E-<E-E-E->E-<E-L8O3E-E->E-<E-E-E->E-<E-
 5564 DATA #3, G2E-2 B-2B-GAB->
 5565 DATA #4, B-2B-2> G2&GE-FG
 5566 DATA #6, \A\A
 5567 DATA --
 5568 DATA #0, L8 C4.<A4.F+4> D2RC<B-A
 5569 DATA #1, D4.D4.<A4> F+2&F+AGF+<
 5570 DATA #2, L8O4D D >D <D D D >D <D L8O4D D >D <D D D >D <D
 5571 DATA #3, L8 C4.<A4.F+4> D2RC<B-A
 5572 DATA #4, D4.D4.<A4> F+2&F+AGF+<
 5573 DATA #6, \A\A
 5574 DATA --
 5575 DATA #0, L8 G2D2 A2RB->CD
 5576 DATA #1, B-2B-2> C2&CDE-F
 5577 DATA #2, L8O3G G >G <G G G >G <G L8O3G G >G <G G G >G <G
 5578 DATA #3, L8 G2D2 A2RB->CD
 5579 DATA #4, B-2B-2> C2&CDE-F
 5580 DATA #6, \A\A
 5581 DATA --
 5582 DATA #0, <A4.F4.C4 A2RFGA
 5583 DATA #1, F4.C4.<A4 >F1<
 5584 DATA #2, L8O3F F >F <F F F >F <F  L8O3F F >F <F F F >F <F
 5585 DATA #3, <A4.F4.C4 A2RFGA
 5586 DATA #4, F4.C4.<A4 >F1<
 5587 DATA #6, \A\A
 5588 DATA --
 5589 DATA #0, G2E-2 B-2B-GAB-16&B-l40 !1 Rl80>
 5590 DATA #1, B-2B-2> G2&GE-FG
 5591 DATA #2, L8O3E-E->E-<E-E-E->E-<E-L8O3E-E->E-<E-E-E->E-<E-
 5592 DATA #3, G2E-2 B-2B-GAB->
 5593 DATA #4, B-2B-2> G2&GE-FG
 5594 DATA #6, \A\A
 5595 DATA --
 5596 DATA #0, L8 C4.<A4.F+4 >D1~21;64;480
 5597 DATA #1, D4.D4.<A4> F+1
 5598 DATA #2, L8O4D D >D <D D D >D <D L8O4D D >D <D D D >D <D
 5599 DATA #3, L8 C4.<A4.F+4 >D1~22;65;480
 5600 DATA #4, D4.D4.<A4> F+1
 5601 DATA #6, \A\A
 5602 DATA --
 5603 DATA #0, P64O6 D2<GB->D<B- >C6]2C6]2C6[4C6]2C6]2C6[4
 5604 DATA #1, @4V11O5 L8 P64RE-P104GB->P64D<B-P24GE- P64RFP104A>CP64FC<P24AF
 5605 DATA #2, L8O3E-E->E-<E-E-E->E-<E- L8O3F F >F <F F F >F <F
 5606 DATA #3, P64O5 L8 G2E-GB-G A6]2A6]2A6[4A6]2A6]2A6[4
 5607 DATA #6, \A\A
 5608 DATA --
 5609 DATA #0, C2<FA>C<A B-6]2B-6]2B-6[4B-6]2B-6]2B-6[4
 5610 DATA #1, P64RDP104FA>P64C<AP24FD  P64RGP104B->DP64FD<P24B-G
 5611 DATA #2, L8O4D D >D <D D D >D <D  L8O3G G >G <G G G >G <G
 5612 DATA #3, F2DFAF D6]2D6]2D6[4D6]2D6]2D6[4
 5613 DATA #6, \A\A
 5614 DATA --
 5615 DATA #0, B-2CE-B-G A6>C6F6G6F6Cl280 !1 Rl80
 5616 DATA #1, P64RCP104E-GP64B-GP24E-G P64RFP104A>CP64FCP24<AF
 5617 DATA #2, L8O4C C >C <C C C >C <C  L8O3F F >F <F F F >F <F
 5618 DATA #3, E-2<G>CCE- F6A6>C6C6C6<A6
 5619 DATA #6, \A\A
 5620 DATA --
 5621 DATA #0, D4.E-4.F4 F+2&F+4&F+8&F+16&F+l40 !1 Rl80
 5622 DATA #1, P64RB->P104DFP64B-FP24D<B- P64RAP104>DF+P64AF+P24DA
 5623 DATA #2, L8O3B-B->B-<B-B-B->B-<B-L8O4D D >D <D D D >D <D
 5624 DATA #3, A4.A4.A4 >D1
 5625 DATA #6, \A\A
 5626 DATA --
 5627 DATA #0, L8 GAB->C4<B-AG ]4GAB->C4<B-AG[4
 5628 DATA #1, O5L16 P64GB->DG]2P104<GB->DG]2<GB->DG]2<GB->DG[6< P64GB->DG]2P24<GB->DG]2<GB->DG]2<GB->DG[6<
 5629 DATA #2, L8O3G1 R8G8G4G16G16G16G16G16G16G16G16
 5630 DATA #3, L8 DFGA4GFD P104]4DFGA4GFD[4P64
 5631 DATA #6, \B\C
 5632 DATA --
 5633 DATA #0, L8 GAB->C4<B-AG ]4GAB->C4<B-AG[4
 5634 DATA #1, P64GB->E-G]2P104<GB->E-G]2<GB->E-G]2<GB->E-G[6< P64GB->E-G]2P24<GB->E-G]2<GB->E-G]2<GB->E-G[6<
 5635 DATA #2, L8O3E-1R8E-8E-4E-16E-16E-16E-16E-16E-16E-16E-16
 5636 DATA #3, E-FGA4GFE- P104]4E-FGA4GFE-[4P64
 5637 DATA #6, \B\C
 5638 DATA --
 5639 DATA #0, GAB->C4<B-AG AB->CD4C<B->C
 5640 DATA #1, P64G>CE-G]2P104<G>CE-G]2<G>CE-G]2<G>CE-G[6< P64G>CE-G]2P24<G>CE-G]2<G>CE-G]2<G>CE-G[6<
 5641 DATA #2, L8O4C1<R8A8A4A16A16A16A16A16A16A16A16
 5642 DATA #3, E-FGA4GFE- E-GAB-4AGA>
 5643 DATA #6, \B\C
 5644 DATA --
 5645 DATA #0, E-1 D2&D4&D8&D16&Dl40 !1 Rl80<
 5646 DATA #1, P64G>CE-G]2P104<G>CE-G]2<G>CE-G]2<G>CE-G[6< P64>CDF+A]2P24CDF+A]2CDF+A]2CDF+A[6
 5647 DATA #2, L8O4D D >D <D D D >D <D L8O4D D >D <D D D >D <D
 5648 DATA #3, C1<A1
 5649 DATA #6, \A\A
 5650 DATA --
 5651 DATA #0, L8 GAB->C4<B-AG ]4GAB->C4<B-AG[4
 5652 DATA #1, O5L16 P64GB->DG]2P104<GB->DG]2<GB->DG]2<GB->DG[6< P64GB->DG]2P24<GB->DG]2<GB->DG]2<GB->DG[6<
 5653 DATA #2, L8O3G1R8G8G4G16G16G16G16G16G16G16G16
 5654 DATA #3, L8 DFGA4GFD P104]4DFGA4GFD[4P64
 5655 DATA #6, \B\C
 5656 DATA --
 5657 DATA #0, L8 GAB->C4<B-AG ]4GAB->C4<B-AG[4
 5658 DATA #1, P64GB->E-G]2P104<GB->E-G]2<GB->E-G]2<GB->E-G[6< P64GB->E-G]2P24<GB->E-G]2<GB->E-G]2<GB->E-G[6<
 5659 DATA #2, L8O3E-1R8E-8E-4E-16E-16E-16E-16E-16E-16E-16E-16
 5660 DATA #3, E-FGA4GFE- P104]4E-FGA4GFE-[4P64
 5661 DATA #6, \B\C
 5662 DATA --
 5663 DATA #0, GAB->C4<B-AG AB->CD4C<B->C
 5664 DATA #1, P64G>CE-G]2P104<G>CE-G]2<G>CE-G]2<G>CE-G[6< P64G>CE-G]2P24<G>CE-G]2<G>CE-G]2<G>CE-G[6<
 5665 DATA #2, L8O4C1<R8A8A4A16A16A16A16A16A16A16A16
 5666 DATA #3, E-FGA4GFE- E-GAB-4AGA>
 5667 DATA #6, \B\C
 5668 DATA --
 5669 DATA #0, E-1 D2RC<B-A16&Al40 !1 Rl80
 5670 DATA #1, P64G>CE-G]2P104<G>CE-G]2<G>CE-G]2<G>CE-G[6< P64>CDF+A]2P24CDF+A]2CDF+A]2CDF+A[6
 5671 DATA #2, L8O4D D >D <D D D >D <D L8O4D D >D <D D D >D <D
 5672 DATA #3, C1< A2R8A8G8F+8
 5673 DATA #6, \A\A
 5674 DATA --
 5675 DATA #0, G1R1
 5676 DATA #1, L16 P64GB->DG]2P104<GB->DG]2<GB->DG]2<GB->DG[6< P64GB->DG]2P24<GB->DG]2<GB->DG]2<GB->DG<
 5677 DATA #2, L8O3G G >G <G G G >G <G L8O3G G >G <G G G >G <G
 5678 DATA #3, D1R1
 5679 DATA #6, \A\A
 5680 DATA --
 5681 DATA #0, R1R2R4R8R16Rl40 !1 Rl80 dc
 5682 DATA #1, R1 R1
 5683 DATA #2, L8O3G G >G <G G G >G <G L8O3G G >G <G G G >G <G
 5684 DATA #3, R1R1
 5685 DATA #6, \A\A
 5686 '
 5687 '###############################
 5688 '      STAGE 8 BOSS
 5689 '###############################
 5690 DATA SONG 2
 5691 DATA \A = \L8 (N46 N30 ) (N46 N30 ) (N46 N38 ) (N46 N30 )\
 5692 DATA \B = \L4(N30  P34 N45 N45) P94 L8  (N48N48) (N48N48)  @116\
 5693 DATA \a = \E-16]4E-16<[4A16]4A16[4A16]4A16>\
 5694 DATA --
 5695 DATA #0, T170 P64@3V10O4 L8 DDE-DFDDADDE-DFD  D4~59;64;
 5696 DATA #1, @6P94V9O5 D3&D3~0;64;1280D3&D3~0;64;1280D3&D3~0;64;1280
 5697 DATA #2, @5P64V11L8O3DD>D<DDD>D<DDD>D<DDD>D<D
 5698 DATA #3, @6P34V9O5 D3&D3~1;65;1280D3&D3~1;65;1280D3&D3~1;65;1280
 5699 DATA #6, @116V15\A\A\A\A
 5700 DATA --
 5701 DATA #0, L8 DDE-DFDDADDE-DFD  D4~59;64;
 5702 DATA #1, D3&D3~0;64;1280D3&D3~0;64;1280D3&D3~0;64;1280
 5703 DATA #2, DD>D<DDD>D<DDD>D<DDD>D<D
 5704 DATA #3, D3&D3~1;65;1280D3&D3~1;65;1280D3&D3~1;65;1280
 5705 DATA #6, \A\A\A\A
 5706 DATA --
 5707 DATA #0, L8 DDE-DFDDADDE-DFD  D4~59;64;
 5708 DATA #1, D3&D3~0;64;1280D3&D3~0;64;1280D3&D3~0;64;1280
 5709 DATA #2, DD>D<DDD>D<DDD>D<DDD>D<D
 5710 DATA #3, D3&D3~1;65;1280D3&D3~1;65;1280D3&D3~1;65;1280
 5711 DATA #6, \A\A\A\A
 5712 DATA --
 5713 DATA #0, L8 DDE-DFDDADDE-DFD  D4~59;64;
 5714 DATA #1, D3&D3~0;64;1280D3&D3~0;64;1280D3&D3~0;64;1280
 5715 DATA #2, DD>D<DDD>D<DDD>D<DDD>D<D
 5716 DATA #3, D3&D3~1;65;1280D3&D3~1;65;1280D3&D3~1;65;1280
 5717 DATA #6, \A\A\A\A
 5718 DATA --
 5719 DATA #0, dc @2V11O5P74L8A>CDE-D16E-16DCD<A16B-16AGAB->CDE-<
 5720 DATA #1, @8 P84 V8O3 A2>E-2<B4>F2<B4>
 5721 DATA #2, L8 O3 AA>E-<A>E-<AA>E-<A>E-<AA>E-<AA>E-
 5722 DATA #3, @8 P44 V8 O3 A2~65;65;>E-2<B4>F2<B4>
 5723 DATA #5, @2V10O5L8P44 R32 A~65;65;>CDE-D16E-16DCD<A16B-16AGAB->CDE-16.<
 5724 DATA #6, \B\B\B\B
 5725 DATA --
 5726 DATA #0, L8A>CDE-D16E-16DCD<A16B-16AGAB->CDE-<
 5727 DATA #1, V8 \a \a V6 \a \a V9 E-16]4E-16<[4A16]4A16> @117P64V14(N50N45N40N41)
 5728 DATA #2, L8 O3 AA>E-<A>E-<AA>E-<A>E-<AA>E-<AA>E-
 5729 DATA #3, V8 \a \a V6 \a \a V9 E-16]4E-16<[4A16]4A16> @117P64V13(N50N45N40N41)
 5730 DATA #5, R32 L8A>CDE-D16E-16DCD<A16B-16AGAB->CDE-16.<
 5731 DATA #6, \B\B\B\B
 5732 DATA --
 5733 DATA #0, L8A>CDE-D16E-16DCD<A16B-16AGAB->CDE-<
 5734 DATA #1, @8 V8O3 A2>E-2<B4>F2<B4>
 5735 DATA #2, L8 O3 AA>E-<A>E-<AA>E-<A>E-<AA>E-<AA>E-
 5736 DATA #3, @8 P44 V8 O3 A2~65;65;>E-2<B4>F2<B4>
 5737 DATA #5, R32 L8A>CDE-D16E-16DCD<A16B-16AGAB->CDE-16.<
 5738 DATA #6, \B\B\B\B
 5739 DATA --
 5740 DATA #0, L8A>CDE-D16E-16DCD<A16B-16AGAB->CDE-<
 5741 DATA #1, V8 \a \a V6 \a \a V9 E-16]4E-16<[4A16]4A16> @117P64V14(N50N45N40N41)
 5742 DATA #2, L8 O3 AA>E-<A>E-<AA>E-<A>E-<AA>E-<AA>E-
 5743 DATA #3, V8 \a \a V6 \a \a V9 E-16]4E-16<[4A16]4A16> @117P64V13(N50N45N40N41)
 5744 DATA #5, R32 L8A>CDE-D16E-16DCD<A16B-16AGAB->CDE-16.<
 5745 DATA #6, \B\B\B\B
 5746 DATA --
 5747 DATA #0, L8B->C+EFE16F16EC+E<B->C+EFE16F16EC+E<
 5748 DATA #1, @8V8 O4 E2<B-2>F8E8<B-8>F8E8<B-8>F8E8
 5749 DATA #2, L8 O3B-B->E<B->E<B-B->E<B->E<B-B->E<B-B->E
 5750 DATA #3, @8V8  P44 O4 E2~65;65;<B-2>F8E8<B-8>F8E8<B-8>F8E8
 5751 DATA #5, R32 L8B->C+EFE16F16EC+E<B->C+EFE16F16EC+E16.<
 5752 DATA #6, \B\B\B\B
 5753 DATA --
 5754 DATA #0, L8B->C+EFE16F16EC+E<B->C+EFE16F16EC+E<
 5755 DATA #1, F16F+16F8A-8F8E8E-8E8F8E2<B-2
 5756 DATA #2, L8 O3B-B->E<B->E<B-B->E<B->E<B-B->E<B-B->E
 5757 DATA #3, F16F+16F8A-8F8E8E-8E8F8E2<B-2
 5758 DATA #5, R32 L8B->C+EFE16F16EC+E<B->C+EFE16F16EC+E16.<
 5759 DATA #6, \B\B\B\B
 5760 DATA --
 5761 DATA #0, L8B->C+EFE16F16EC+E<B->C+EFE16F16EC+E<
 5762 DATA #1, O4 E2<B-2>F8E8<B-8>F8E8<B-8>F8E8
 5763 DATA #2, L8 O3B-B->E<B->E<B-B->E<B->E<B-B->E<B-B->E
 5764 DATA #3, O4 E2<B-2>F8E8<B-8>F8E8<B-8>F8E8
 5765 DATA #5, R32 L8B->C+EFE16F16EC+E<B->C+EFE16F16EC+E16.<
 5766 DATA #6, \B\B\B\B
 5767 DATA --
 5768 DATA #0, L8B->C+EFE16F16EC+E<B->C+EFE16F16EC+E<
 5769 DATA #1, F16F+16F8A-8F8E8E-8E8F8E2<B-2
 5770 DATA #2, L8 O3B-B->E<B->E<B-B->E<B->E<B-B->E<B-B->E
 5771 DATA #3, F16F+16F8A-8F8E8E-8E8F8E2<B-2
 5772 DATA #5, R32 L8B->C+EFE16F16EC+E<B->C+EFE16F16EC+E16.<
 5773 DATA #6, \B\B\B\B
 5774 DATA --
 5775 DATA #0, L8B16>C16<B>E-EE-C<B>CL12<B>C<BAB>C<B16>C16<L8BAB
 5776 DATA #1, @7P70V12O4 G+8R4G+8R4G+8R8R8G+8G+4L12G+ G F+ FE E-
 5777 DATA #2, L8 O3BB>B<BB>B<B>B<BB>B<BB>B<B>B
 5778 DATA #3, @7P58V12O4P64 D8R4D8R4D8R8R8D8D4L12D C+C<BB-A>
 5779 DATA #5, R32 L8B16>C16<B>E-EE-C<B>CL12<B>C<BAB>C<B16>C16<L8BAB16.
 5780 DATA #6, \B\B\B\B
 5781 DATA --
 5782 DATA #0, L8B16>C16<B>E-EE-C<B>CL12<B>C<BAB>C<B16>C16<L8BAB
 5783 DATA #1, G+8R4G+8R4G+8R8R8G+8G+4B2
 5784 DATA #2, L8 O3BB>B<BB>B<B>B<BB>B<BB>B<B>B
 5785 DATA #3, D8R4D8R4D8R8R8D8D4G+2
 5786 DATA #5, R32 L8B16>C16<B>E-EE-C<B>CL12<B>C<BAB>C<B16>C16<L8BAB16.
 5787 DATA #6, \B\B\B\B
 5788 DATA --
 5789 DATA #0, L8B16>C16<B>E-EE-C<B>CL12<B>C<BAB>C<B16>C16<L8BAB
 5790 DATA #1, G+8R4G+8R4G+8R8R8G+8G+4L12G+ G F+ FE E-
 5791 DATA #2, L8 O3BB>B<BB>B<B>B<BB>B<BB>B<B>B
 5792 DATA #3, D8R4D8R4D8R8R8D8D4L12DC+C<BB-A>
 5793 DATA #5, R32 L8B16>C16<B>E-EE-C<B>CL12<B>C<BAB>C<B16>C16<L8BAB16.
 5794 DATA #6, \B\B\B\B
 5795 DATA --
 5796 DATA #0, L8B16>C16<B>E-EE-C<B>CL12<B>C<BAB>C<B16>C16<L8BAB
 5797 DATA #1, G+8R4G+8R4G+8R8R8G+8G+4B2
 5798 DATA #2, L8 O3BB>B<BB>B<B>B<BB>B<BB>B<B>B
 5799 DATA #3, D8R4D8R4D8R8R8D8D4G+2
 5800 DATA #5, R32 L8B16>C16<B>E-EE-C<B>CL12<B>C<BAB>C<B16>C16<L8BAB16.
 5801 DATA #6, \B\B\B\B
 5802 DATA --
 5803 DATA #0, L8A>CDE-D16E-16DCD<A16B-16AGAB->CDE-<
 5804 DATA #1, >C1&C1
 5805 DATA #2, L8 O3 AA>E-<A>E-<AA>E-<A>E-<AA>E-<AA>E-
 5806 DATA #3, A1&A1
 5807 DATA #5, R32 L8A>CDE-D16E-16DCD<A16B-16AGAB->CDE-16.<
 5808 DATA #6, \B\B\B\B
 5809 DATA --
 5810 DATA #0, L8A>CDE-D16E-16DCD<A16B-16AGAB->CDE-<
 5811 DATA #1, R1&R1
 5812 DATA #2, L8 O3 AA>E-<A>E-<AA>E-<A>E-<AA>E-<AA>E-
 5813 DATA #3, R1&R1
 5814 DATA #5, R32 L8A>CDE-D16E-16DCD<A16B-16AGAB->CDE-16.<
 5815 DATA #6, \B\B\B\B
 5816 DATA --
 5817 DATA #0, L8A>CDE-D16E-16DCD<A16B-16AGAB->CDE-<
 5818 DATA #1, @6P94V9O5 D3&D3~0;64;1280D3&D3~0;64;1280D3&D3~0;64;1280
 5819 DATA #2, L8 O3 AA>E-<A>E-<AA>E-<A>E-<AA>E-<AA>E-
 5820 DATA #3, @6P34V9O5 D3&D3~1;65;1280D3&D3~1;65;1280D3&D3~1;65;1280
 5821 DATA #5, R32 L8A>CDE-D16E-16DCD<A16B-16AGAB->CDE-16.<
 5822 DATA #6, \B\B\B\B
 5823 DATA --
 5824 DATA #0, L8A>CDE-D16E-16DCD<A16B-16AGAB->CDE-<dc
 5825 DATA #1, D3&D3~0;64;1280D3&D3~0;64;1280D3&D3~0;64;1280
 5826 DATA #2, L8 O3 AA>E-<A>E-<AA>E-<A>E-<AA>E-<AA>E-
 5827 DATA #3, D3&D3~1;65;1280D3&D3~1;65;1280D3&D3~1;65;1280
 5828 DATA #5, R32 L8A>CDE-D16E-16DCD<A16B-16AGAB->CDE-16.<
 5829 DATA #6, \B\B\B\B
 5830 DATA ENDSONG
 5831 '
 5832 '###############################
 5833 '      STAGE 9 SONG DATA
 5834 '###############################
 5835 *MS9
 5836 DATA SONG 1
 5837 DATA #0, T178 P64@31O4V11 L12 dc ARA>C2<A>CD E-2D4DE-D
 5838 DATA #1, P24@31V10O4L12 E-RE-A2EAB  >C2<A4AB-A
 5839 DATA #2, @34P64O3V12 L12 ARAARAARAARA >CRCCRCDRDDE-D<
 5840 DATA #3, P64@31V7O3 L12 A>C<A>E-DC<A>C<A>E-DC< A>C<A>E-DC<A>D<A>E-DC<
 5841 DATA #4, P64@31V7O6 L12 E-GDG-D-FDG-E-GEA-  E-GDG-D-FDG-E-GEA-
 5842 DATA #6, @116V15L12 N30RN30 N38'4 N30RN30 N38'4 N30RN30 N38'4 N30RN30 N38N38N38
 5843 DATA --
 5844 DATA #0, CR<A&A2]4E-AB >C2<B4B>C<B[4
 5845 DATA #1, ARE-&E-2]4<B>CD E-2D4DE-D[4
 5846 DATA #2, L12 ARAARAARAARA >CRCCRCDRDDE-D<
 5847 DATA #3, L12 A>C<A>E-DC<A>C<A>E-DC< A>C<A>E-DC<A>D<A>E-DC<
 5848 DATA #4, E-GDG-D-FDG-E-GEA-  E-GDG-D-FDG-E-GEA-
 5849 DATA #6, N30RN30 N38'4 N30RN30 N38'4 N30RN30 N38'4 N30RN38 N38N38N38
 5850 DATA --
 5851 DATA #0, L12 ARA>C2<A>CD E-2D4DE-D
 5852 DATA #1, L12 E-RE-A2EAB  >C2<A4AB-A
 5853 DATA #2, L12 ARAARAARAARA >CRCCRCDRDDE-D<
 5854 DATA #3, L12 A>C<A>E-DC<A>C<A>E-DC< A>C<A>E-DC<A>D<A>E-DC<
 5855 DATA #4, E-GDG-D-FDG-E-GEA-  E-GDG-D-FDG-E-GEA-
 5856 DATA #6, N30RN30 N38'4 N30RN30 N38'4 N30RN30 N38'4 N30N38N38 N38N38N38
 5857 DATA --
 5858 DATA #0, CR<A&A2]4E-AB >C2<B4B>C<Bl120 !1 Rl80 [4
 5859 DATA #1, ARE-&E-2]4<B>CD E-2D4DE-D[4
 5860 DATA #2, L12 ARAARAARAARA >CRCCRCDRDDE-D<
 5861 DATA #3, L12 A>C<A>E-DC<A>C<A>E-DC< A>C<A>E-DC<A>D<A>E-DC<
 5862 DATA #4, E-GDG-D-FDG-E-GEA-  E-GDG-D-FDG-E-GEA-
 5863 DATA #6, N30RN30 N38'4 N30RN30 N38'4 N30RN30 N38'4 N30RP104N45'24N45'24 N45P64N45P24N45@116
 5864 DATA --
 5865 DATA #0, L12 >CRCG-2FG-F  E-RE-A2G+AG+
 5866 DATA #1, L12 GRG>E-2DE-D <B-RB->G-2FG-F
 5867 DATA #2, L12 >CGC> C<CG CGC >C<CG E-G-E- AE-G- E->C<E- AE-G-
 5868 DATA #3, V10L12O4 GRGG-4AB->CCR6 <B-RB-A4>CDE-E-R6
 5869 DATA #4, V10L12O4 E-RE-C4G-A-AAR6 G-RG-E-4AB>CCR6
 5870 DATA #6, N30RN30 N38'4 P104N45N45N45 P64 N45N45N45@116 N30RN30 N38'4 P104N45'24N45'24P64N45P24N45 P64N45P24N45N45@116
 5871 DATA --
 5872 DATA #0, G-RG->C2<B->C<B-l120 !1 Rl80 ARA>E-2<<DEF
 5873 DATA #1, D-RD-A2G-AG-  ERE>C2<<<B>CD
 5874 DATA #2, G-A>C< A>CE- G-E-C E-C<G-  A>CE- G-2 G-G-G-<
 5875 DATA #3, D-RD-C4E-FG-G-R6 EREE-4<<G-A-AB>CD
 5876 DATA #4, <ARAG-4>CD-E-E-R6  CRC<A4<E-FF+A-AB
 5877 DATA #6, N30RN30 N38'4 P64N45N45N45 P104 N45N45N45@116 N30RN30 N38'4 P24N45P64N45P104N45'24N45'24 N45P64N45P24N45@116
 5878 DATA --
 5879 DATA #0, E2A-2 B2>D2<
 5880 DATA #1, <B2>E2 A-2B2
 5881 DATA #2, <EEE>E-<B>D<EEE>E-<B>D <EEE>E-<B>D<EEE>E-<B>D
 5882 DATA #3, R4> DEFR4<B>CD R4<A-ABR4B>CD
 5883 DATA #4, R4>B>CDR4<A-AB R4EG-A-R4A-AB
 5884 DATA #6, N30RN30 N38'4 N30RN30 N38'4 N30RN30 N38'4 N30RN30 N38RN38
 5885 DATA --
 5886 DATA #0, E4A-4B4>D4 EFF+ GF+F EF+G G+Rl280 !1 Rl80
 5887 DATA #1, <B4>E4A-4B4 B>CC+DC+C<B>DE-ER6
 5888 DATA #2, <EEE>E-<B>D<EEE>E-<B>D <EFF+GF+FEF+GG+R6
 5889 DATA #3, R4DEF<B>CD<G+AB A-AB-BB-AA-AB-BR6
 5890 DATA #4, R4B>CD<G+ABEF+G+ EFF+GF+FEF+GG+R6
 5891 DATA #6, N30RN30 N38'4 N30RN30 N38'4 N38N38N38 N30N30N30 P104 N45N45 P64 N45'24N45'24  N45 P24 N45N45@116
 5892 DATA --
 5893 DATA #0, @34P64O3V8L12 ARA ARA ARA ARA>CRCCRCDRDDE-D
 5894 DATA #1, R1R1
 5895 DATA #2, L12 ARAARAARAARA> CRCCRCDRDDE-D
 5896 DATA #3, V7O3 L12 A>C<A>E-DC<A>C<A>E-DC< A>C<A>E-DC<A>D<A>E-DC<
 5897 DATA #4, V7O6L12 E-GDG-D-FDG-E-GEA-  E-GDG-D-FDG-E-GEA-
 5898 DATA #6, N30RN30 N38'4 N30RN30 N38'4 N30RN30 N38'4 N30RP104N45'24N45'24 N45P64N45P24N45@116
 5899 DATA --
 5900 DATA #0, <ARAARAARAARA> E-E-E-E-R6DDDCRl280 !1 Rl80  dc
 5901 DATA #1, R1R1
 5902 DATA #2, <ARAARAARAARA> E-E-E-E-R6 DDDCR6
 5903 DATA #3, L12A>C<A>E-DC<A>C<A>E-DC< V10O5 E-E-E-E-R6DDDCR6
 5904 DATA #4, E-GDG-D-FDG-E-GEA-  V10O4 B-B-B-B-RR12AAAGR6
 5905 DATA #6, N30RN30 N38'4 N30RN30 N38'4 N38N38N38 N38RR P64 N45N45N45 P24 N45R6@116
 5906 '
 5907 '###############################
 5908 '      STAGE 9 BOSS
 5909 '###############################
 5910 DATA SONG 2
 5911 DATA \A = \L8 (N46N30)N46(N38N46)N46  (N30N46)(N30N46)(N38N46)N46\
 5912 DATA \B = \L8 (N30N46) N46N46 (N30N46) N46(N30N46)(N38N46)N46\
 5913 DATA \C = \L8 (N30'4N49'4) (N38N30)(N38N30) R4. N48'16 N48'16\
 5914 DATA \D = \L16 R8 N45N45 R8N45N45 R8 N48N48  N45 N45 N45 N45\
 5915 DATA \E = \L8 (N30N49)(N38N30)(N38N30)(N38N30) (N38N30)(N38N30)(N38N30)(N38N30)\
 5916 DATA \F = \(N38N30)(N38N30)(N38N30)(N38N30) L16  N48N48 N45N45N45N45 N41N41\
 5917 DATA --
 5918 DATA #0, T178dc P24@31V11 O4 L8 C2<A->CE-A-&A-2>C2<
 5919 DATA #1, P64@31O4V12 L8 F2CFA->C&C2E-2
 5920 DATA #2, @34P64O3V10 L8 FFFF F16>F16<FFF A-A-A-A- A->G16A-16<A-A-
 5921 DATA #3, P64@35O6V11 L4 F1R4E-A->C<
 5922 DATA #4, P64@35O6V9 L4 C1~64;64;R4P24E-P64A->P104C<
 5923 DATA #5, P104@31V11 O4 L8 C2~65;65;<A->CE-A-&A-2>C2<
 5924 DATA #6, @116V15 \A \A
 5925 DATA --
 5926 DATA #0, B-2D-FB->C&C2C2<
 5927 DATA #1, D2<FB->DF&F2E2<
 5928 DATA #2, B-B-B-B- B-16>F16B-16A-16<B-B- >CCCC C<D-16C16E-16C16E16C16
 5929 DATA #3, B-1>C1<
 5930 DATA #4, P64F1F2E2
 5931 DATA #5, B-2D-FB->C&C2C2<
 5932 DATA #6, \A (N46N30)N46(N38N46)N46 (N46N30)(N46N30) L16 N38N38N38N38 L8
 5933 DATA --
 5934 DATA #0, L8 C2<A->CE-A-&A-2>C2<
 5935 DATA #1, L8 F2CFA->C&C2E-2
 5936 DATA #2, FFFF F>E-16F16<FF A-A-A-A- A-16>G16A-<A-A-
 5937 DATA #3, F1R4E-A->C<
 5938 DATA #4, C1R4P104E-P64A->P24C<P64
 5939 DATA #5, L8 C2<A->CE-A-&A-2>C2<
 5940 DATA #6, \A \A
 5941 DATA --
 5942 DATA #0, B-2D-FB->C&C2C4~64;64; & C4~64;0;
 5943 DATA #1, D2<FB->DF&F2E4~64;64;& E4~64;0;
 5944 DATA #2, B-B-B-B- B-16>B-16<B-16>B-16<B-B- >CCC<C&C8CCC
 5945 DATA #3, B-1>C1
 5946 DATA #4, F1F2E2
 5947 DATA #5, B-2D-FB->C&C2C4~65;65; & C4~65;0;
 5948 DATA #6, \A (N30N46)N46(N38N46)(N38N46) (N30N46) L16 N48 N48 N45N45N45N45 L8
 5949 DATA --
 5950 DATA #0, <D-~64;64;E-FE-FGFG
 5951 DATA #1, <F~64;64;GA-GA-B-A-B-
 5952 DATA #2, D-4D-D-&D-8>D-<D->D-<
 5953 DATA #3, P24@14O5V9 L8 F4>F<FRF>FR<
 5954 DATA #4, P104@14O5V9 L8 F4~65;65;>F<FRF>FR<
 5955 DATA #5, <D-~65;65;E-FE-FGFG
 5956 DATA #6, \B
 5957 DATA --
 5958 DATA #0, A-GA-B-A-B->CD-
 5959 DATA #1, >C<B->CD-CD-E-F
 5960 DATA #2, D-4D-D-&D-8>D-<D->D-<
 5961 DATA #3, L8 F4>F<FRF>FR<
 5962 DATA #4, L8 F4>F<FRF>FR<
 5963 DATA #5, A-GA-B-A-B->CD-
 5964 DATA #6, \B
 5965 DATA --
 5966 DATA #0, C4.<B-&B-4A-4
 5967 DATA #1, E-4.D-&D-4C4
 5968 DATA #2, E-4E-E-&E-8>E-<E->E-<
 5969 DATA #3, L8 F4>F<FRF>FR<
 5970 DATA #4, L8 F4>F<FRF>FR<
 5971 DATA #5, C4.<B-&B-4A-4
 5972 DATA #6, \B
 5973 DATA --
 5974 DATA #0, G4.F&F4E-4
 5975 DATA #1, <B-4.A-&A-4G4
 5976 DATA #2, E-A-B->E-&E-8<A-B-E-
 5977 DATA #3, L8 F4>F<FRF>FR<
 5978 DATA #4, L8 F4>F<FRF>FR<
 5979 DATA #5, G4.F&F4E-4
 5980 DATA #6, (N30N46)N46(N30N46)(N30N46) N46(N30N46)(N38N46)(N30N46)
 5981 DATA --
 5982 DATA #0, FGA-GA-B-A-B-
 5983 DATA #1, A-B->C<B->CD-CD-
 5984 DATA #2, D-4D-D-&D-8>D-<D->D-<
 5985 DATA #3, L8 F4>F<FRF>FR<
 5986 DATA #4, L8 F4>F<FRF>FR<
 5987 DATA #5, FGA-GA-B-A-B-
 5988 DATA #6, \B
 5989 DATA --
 5990 DATA #0, >C<B->CD-CD-E-F
 5991 DATA #1, E-D-E-FE-FGA-
 5992 DATA #2, D-4D-D-&D-8>D-<D->D-<
 5993 DATA #3, L8 F4>F<FRF>FR<
 5994 DATA #4, L8 F4>F<FRF>FR<
 5995 DATA #5, >C<B->CD-CD-E-F
 5996 DATA #6, \B
 5997 DATA --
 5998 DATA #0, GFE-<G&G8>CD-E-
 5999 DATA #1, B-A-G<B-&B-8>E-FG
 6000 DATA #2, E-E-E-E-&E-8>E-<E->E-<
 6001 DATA #3, E-4>E-<E-RE->E-<R
 6002 DATA #4, E-4>E-<E-RE->E-<R
 6003 DATA #5, GFE-<G&G8>CD-E-
 6004 DATA #6, \B
 6005 DATA --
 6006 DATA #0, G~64;64;  FE-G~64;64;  &  G4~64;0; R4
 6007 DATA #1, B-A-G>C& C4~64;0;R4
 6008 DATA #2, EFG>C4~64;0; <C~64;64;E-E
 6009 DATA #3, G4>G<GR2
 6010 DATA #4, G4>G<GR2
 6011 DATA #5, G~65;65;  FE-G~65;65;  &  G4~65;0; R4
 6012 DATA #6, (N30N46)(N46N49)(N30N46)(N30N46) L16 N48N48 N45N45N45N45 N41N41 L8
 6013 DATA --
 6014 DATA #0, C4~64;64; FA-~64;64;&A-2~64;64;&A-2.~64;64;& A-4~64;0;
 6015 DATA #1, <F~64;64;GA->C~64;64;&C2~64;64;&C2.~64;64;& C4~64;0;
 6016 DATA #2, F>C16F16<FFR2R2F4E-4
 6017 DATA #3, P24@28O5V12 F1&F2A-2>
 6018 DATA #4, P104@28O5V12 F1~65;65;&F2A-2>
 6019 DATA #5, C4~65;65; FA-~65;65;&A-2~65;65;&A-2.~65;65;& A-4~65;0;
 6020 DATA #6, (N30'4N49'4) (N38N30)(N38N30) N46'4 N46'4 N46 N48'16N48'16  N46 N45 N46 N45  (N41 N46)N41
 6021 DATA --
 6022 DATA #0, C4~64;64; FA-~64;64;&A-2~64;64;&A-2.~64;64;& A-4~64;0;
 6023 DATA #1, <F~64;64;GA->C~64;64;&C2~64;64;&C2.~64;64;& C4~64;0;
 6024 DATA #2, D-A-16>D-16<D-D-R2R2>D-16>D-16<D-C4
 6025 DATA #3, C1&C2F2
 6026 DATA #4, C1&C2F2
 6027 DATA #5, C4~65;65; FA-~65;65;&A-2~65;65;&A-2.~65;65;& A-4~65;0;
 6028 DATA #6, (N30'4N49'4) (N38N30)(N38N30) N46'4 N46'4 L12 (N46N48)N48N48 (N46N45)N45N45 (N46N48)N48N45 (N45N46)N41N41
 6029 DATA --
 6030 DATA #0, C4~64;64; FA-&A-2&A-1G2.F4E2.R4dc
 6031 DATA #1, <F~64;64;GA->C&C2&C2D-2C1&C2.R4
 6032 DATA #2, <B-4.B-RB-RB- RA-16F16B-R4B-B-B- >CCCCCCC16<G16B-16>C16  <CCCCCCC16C16C
 6033 DATA #3, >C1&C2D-2 C1&C2.R4
 6034 DATA #4, >C1&C2D-2C1&C2.R4
 6035 DATA #5, C4~65;65; FA-&A-2&A-1G2.F4E2.R4
 6036 DATA #6, \C\D\E\F
 6037 DATA ENDSONG
 6038 '
 6039 '###############################
 6040 '      BIG TEXDER
 6041 '###############################
 6042 *MSBIG
 6043 DATA \A = \L16P64N38N38N38N45'8N45 L8. P104(N49N49) P24(N49N49)\
 6044 DATA \B = \L16P64N38N38N38N45'8N45 P24 L32N45N45 L16N45N45 P104 L32N41N41 L16N41N41\
 6045 DATA \C = \L16P64N38N38N38N45'8N45 P24L32N45N45L16N45N45 P104L32N41N41L16N41N41\
 6046 DATA \D = \P104 N49'4 R16 P24N49'4 P64 N49'8.\
 6047 DATA \E = \@116P64 L16  N38 N38 N38 N38 N38 N38 N38 N38 N38 @117P104N35'8N35 @116\
 6048 DATA \F = \P64L16  N38 N38 N38 N38 N38 N38 N38 N38 N38    N49'8 N49\
 6049 DATA --
 6050 DATA #0, T110 P64@85V9 O5A2.
 6051 DATA #1, P64@85V9 O5 D2.
 6052 DATA #2, P64@88V8O3A8.A8.A8.A8.
 6053 DATA #3, P104@85V11O5E2.
 6054 DATA #4, R2.
 6055 DATA #5, R2.
 6056 DATA #7,V15L4.@116P104N49 @118 P24O4(AAO5AA)
 6057 DATA --
 6058 DATA #0, B-2.>
 6059 DATA #1, E-2.
 6060 DATA #2, A8.A8.A8.A8.
 6061 DATA #3, F2.
 6062 DATA #4, R2.
 6063 DATA #5, R2.
 6064 DATA #7,@116P104N49 @118 P24O4(B-B-O5B-B-)
 6065 DATA --
 6066 DATA #0, C2.
 6067 DATA #1, F2.
 6068 DATA #2, A8.A8.A8.A8.
 6069 DATA #3, G2.
 6070 DATA #4, R2.
 6071 DATA #5, R2.
 6072 DATA #7,@116P104N49 @118 P24O5(CCO6CC)
 6073 DATA --
 6074 DATA #0, C+2.
 6075 DATA #1, G2.
 6076 DATA #2, A8.A8.A8.A8.
 6077 DATA #3, A2.
 6078 DATA #4, R2.
 6079 DATA #5, R2.
 6080 DATA #7,L24 @116 N48N48N48 N48N48N48 N45N45N45 N45N45N45 N41N41N41 N41N41N41
 6081 DATA --
 6082 DATA #0, T130 V10O6G16]4G4[4G16]4G8. [4G16]4G4[4G16]4G8.[4G16]4G4&G16[4
 6083 DATA #1, @87V10O6L16P64GAP104B->DP64C<B-P24AB->P64C<B-P104AF P64GAP24B->DP64C<B-P104AB->P64C<B-P24AF
 6084 DATA #2, @89V11L16O3G8GB->DC<G8GB->DC<G8GB->DC<G8GB->DC<
 6085 DATA #3, P24V12 D16]4D4[4D16]4D8.[4D16]4D4[4D16]4D8.[4D16]4D4&D16[4
 6086 DATA #4, @90V9O6 L32    P24 G2.F+F P44 ED+D P64 C+C<B P84 A+AG+ P104 GG4.
 6087 DATA #5, @90V8O6 L32 R16P24 G2.F+F P44 ED+D P64 C+C<B P84 A+AG+ P104 GG4&G16
 6088 DATA #7,\A\B
 6089 DATA --
 6090 DATA #0, G16]4G4[4G16]4G8. [4G16]4G4[4G16]4G8.[4G16]4G4&G16[4
 6091 DATA #1, O6L16P64GAP104B->DP64C<B-P24AB->P64C<B-P104AF P64GAP24B->DP64C<B-P104AB->P64C<B-P24AF
 6092 DATA #2, L16O3G8GB->DC<G8GB->DC<G8GB->DC<G8GB->DC<
 6093 DATA #3, D16]4D4[4D16]4D8.[4D16]4D4[4D16]4D8.[4D16]4D4&D16[4
 6094 DATA #4,    G2. G+ P84 AA+B> P64 CC+D P44 D+EF P24 F+GG4.
 6095 DATA #5, R16G2. G+ P84 AA+B> P64 CC+D P44 D+EF P24 F+GG4&G16
 6096 DATA #7,\A\B
 6097 DATA --
 6098 DATA #0, dc @86V10O5 D4&D16<G4B-8.A4&A16>F4C8.
 6099 DATA #1, O6L16  P64GAP104B->DP64C<B- P24AB->P64C<B-P104AF  P64GAP24B->DP64C<B- P104AB->P64C<B-P24AF
 6100 DATA #2, L16O3G8GB->DC<G8GB->DC<G8GB->DC<G8GB->DC<
 6101 DATA #3, @86P64V9 O5B-4&B-16D4G8.F4&F16F4A8.>
 6102 DATA #4, @91P24 V5O5 G2.A2.
 6103 DATA #5, @91V5O5P104 G2.~65;65;A2.
 6104 DATA #7,\A\B
 6105 DATA --
 6106 DATA #0, E-4&E16D4C8.D2.
 6107 DATA #1, O6L16  P64GAP104B->DP64C<B- P24AB->P64C<B-P104AF  P64GAP24B->DP64C<B- P104AB->P64C<B-P24AF
 6108 DATA #2, L16O3G8GB->DC<G8GB->DC<G8GB->DC<G8GB->DC<
 6109 DATA #3, C4&C16<B-4A8.G2.
 6110 DATA #4, B-4&B-16>C4<A8.G2.
 6111 DATA #5, B-4&B-16>C4<A8.G2.
 6112 DATA #7,\A\B
 6113 DATA --
 6114 DATA #0, D4&D16<G4B-8.A4&A16>F4C8.
 6115 DATA #1, O6L16  P64GAP104B->DP64C<B- P24AB->P64C<B-P104AF  P64GAP24B->DP64C<B- P104AB->P64C<B-P24AF
 6116 DATA #2, L16O3G8GB->DC<G8GB->DC<G8GB->DC<G8GB->DC<
 6117 DATA #3, B-4&B-16D4G8.F4&F16F4A8.>
 6118 DATA #4, G2.A2.
 6119 DATA #5, G2.A2.
 6120 DATA #7,\A\B
 6121 DATA --
 6122 DATA #0, E-4&E16D4C8.L16B-GDAFCGD<B->GAB-<
 6123 DATA #1, O6L16  P64GAP104B->DP64C<B- P24AB->P64C<B-P104AF  P64GAP24B->DP64C<B- P104AB->P64C<B-P24AF
 6124 DATA #2, L16O3G8GB->DC<G8GB->DC<G8GB->DC<G8GB->DC<
 6125 DATA #3, C4&C16<B-4A8.L16>D<B-G>C<AFB-GDGAB-
 6126 DATA #4, B-4&B-16>C4<A8.G2.
 6127 DATA #5, B-4&B-16>C4<A8.G2.
 6128 DATA #7,\A\B
 6129 DATA --
 6130 DATA #0, E-4&E16D4G8.>C4&C16<B-4A8.
 6131 DATA #1, O6L16  P64E-GP104B-AP64FCP24GE-<P64B->GP104AB-    P64E-GP24B-AP64FCP104GE-P64<B->GP24AB-
 6132 DATA #2, L16O3E-8E-GAB-E-8E-GAB-E-8E-GAB-E-8E-GAB-
 6133 DATA #3, C4&C16<B-4>D8.E-4&E-16D4C8.
 6134 DATA #4, E-2.G4.B-4.
 6135 DATA #5, E-2.G4.B-4.
 6136 DATA #7,\A\B
 6137 DATA --
 6138 DATA #0, L16B-AGB-AGB-AGB-AGD2.
 6139 DATA #1, O6L16  P64GAP104B->DP64C<B- P24AB->P64C<B-P104AF  P64GAP24B->DP64C<B- P104AB->P64C<B-P24AF
 6140 DATA #2, L16O3G8GB->DC<G8GB->DC<G8GB->DC<G8GB->DC<
 6141 DATA #3, L16GD<B->GD<B->GD<B->GD<B-G2.>
 6142 DATA #4, G2.L16B-AGB-AGB-AGB-AG
 6143 DATA #5, G2.L16B-AGB-AGB-AGB-AG
 6144 DATA #7,\A\B
 6145 DATA --
 6146 DATA #0, E-4&E16D4G8.>C4&C16<B-4A8.
 6147 DATA #1, O6L16  P64E-GP104B-AP64FCP24GE-<P64B->GP104AB-    P64E-GP24B-AP64FCP104GE-P64<B->GP24AB-
 6148 DATA #2, L16O3E-8E-GAB-E-8E-GAB-E-8E-GAB-E-8E-GAB-
 6149 DATA #3, C4&C16<B-4>D8.E-4&E-16D4C8.
 6150 DATA #4, E-2.G4.B-4.
 6151 DATA #5, E-2.G4.B-4.
 6152 DATA #7,\A\B
 6153 DATA --
 6154 DATA #0, L16>C<AF+>C<AF+>C<AF+>C<AF+>D2.
 6155 DATA #1, O6L16  P64DF+P104ADP64F+AP24>C<AP64F+DP104F+A     P64DF+P24ADP64F+AP104DEP64F+GP24A>D
 6156 DATA #2, L16O3D8DF+AGD8DF+AGD8DF+AGD8DF+AG
 6157 DATA #3, L16F+DCF+DCF+DCF+DCF+2.
 6158 DATA #4, D2.L16>C<AF+>C<AF+>C<AF+>C<AF+
 6159 DATA #5, D2.L16>C<AF+>C<AF+>C<AF+>C<AF+
 6160 DATA #7,\A\B
 6161 DATA --
 6162 DATA #0, @66V7O6 L16 B-DB- DB-D B-DB- DB-D  A]2A4[2 A]2A8.[2 A]2A8[2
 6163 DATA #1, O6L16  P64GAP104B->DP64C<B- P24AB->P64C<B-P104AF  P64GAP24B->DP64C<B- P104AB->P64C<B-P24AF
 6164 DATA #2, L16O3G8GB->DC<G8GB->DC<G8GB->DC<G8GB->DC<
 6165 DATA #3, @66V7 O6L16 G<B->G <B->G<B-> G<B->G <B->G<B->  C]2C4[2 C]2C8.[2 C]2C8[2
 6166 DATA #4, @86V9 O4 G4&G16A4B-8.A4&A16B-4>C8.<
 6167 DATA #5, @86V9 O4 G4&G16A4B-8.A4&A16B-4>C8.<
 6168 DATA #7,\C\D
 6169 DATA --
 6170 DATA #0, B-DB- DB-D B-DB- DB-D >C]2C4[2 C]2C8.[2 C]2C8[2<
 6171 DATA #1, O6L16  P64GAP104B->DP64C<B- P24AB->P64C<B-P104AF  P64GAP24B->DP64C<B- P104AB->P64C<B-P24AF
 6172 DATA #2, L16O3G8GB->DC<G8GB->DC<G8GB->DC<G8GB->DC<
 6173 DATA #3, G<B->G <B->G<B-> G<B->G <B->G<B->  E]2E4[2 E]2E8.[2 E]2E8[2
 6174 DATA #4, B-4&B-16A4F8.L16EG>C<EG>C<EG>C<EG>C<
 6175 DATA #5, B-4&B-16A4F8.L16EG>C<EG>C<EG>C<EG>C<
 6176 DATA #7,\C\D
 6177 DATA --
 6178 DATA #0, B-DB- DB-D B-DB- DB-D  A]2A4[2 A]2A8.[2 A]2A8[2
 6179 DATA #1, O6L16  P64GAP104B->DP64C<B- P24AB->P64C<B-P104AF  P64GAP24B->DP64C<B- P104AB->P64C<B-P24AF
 6180 DATA #2, L16O3G8GB->DC<G8GB->DC<G8GB->DC<G8GB->DC<
 6181 DATA #3, G<B->G <B->G<B-> G<B->G <B->G<B->  C]2C4[2 C]2C8.[2 C]2C8[2
 6182 DATA #4, G4&G16A4B-8.A4&A16B-4>C8.<
 6183 DATA #5, G4&G16A4B-8.A4&A16B-4>C8.<
 6184 DATA #7,\C\D
 6185 DATA --
 6186 DATA #0, B-DB- DB-D B-DB- DB-D  G]2G4[2 G]2G8.[2 G]2G8[2
 6187 DATA #1, O6L16  P64GAP104B->DP64C<B- P24AB->P64C<B-P104AF  P64GAP24B->DP64C<B- P104AB->P64C<B-P24AF
 6188 DATA #2, L16O3G8GB->DC<G8GB->DC<G8GB->DC<G8GB->DC<
 6189 DATA #3, G<B->G <B->G<B-> G<B->G <B->G<B->  D]2D4[2 D]2D8.[2 D]2D8[2 <
 6190 DATA #4, B-4&B-16A4F8.L16B-GDB-GDB-GDB-GD
 6191 DATA #5, B-4&B-16A4F8.L16B-GDB-GDB-GDB-GD
 6192 DATA #7,\C\D
 6193 DATA --
 6194 DATA #0, L16DE-DE-DE-DE-DL48 DEF GAB>CD24<A4&A16G4F+8.
 6195 DATA #1, O6L16  P64F+A>P104DC<P64A>C<P104F+A>P64DC<P24A>C< P64F+A>P24DC<P64A>C<P104F+A>P64DC<P24A>C
 6196 DATA #2, L16O3D8DF+AGD8DF+AGD8DF+AGD8DF+AG
 6197 DATA #3, L16F+AF+AF+AF+AF+L48 F+GA B>CDEF+24<F+4&F+16E-4D8.
 6198 DATA #4, V10 D4&D16E-4F+8.A4&A16G4F+8.
 6199 DATA #5, V10 D4&D16E-4F+8.A4&A16G4F+8.
 6200 DATA #7,\A\B
 6201 DATA --
 6202 DATA #0, L16DE-DE-DE-DE-DL48 DEF GAB>CD24<F+4&F+16G4A8.
 6203 DATA #1, O6L16  P64F+A>P104DC<P64A>C<P104F+A>P64DC<P24A>C< P64F+A>P24DC<P64A>C<P104F+A>P64DC<P24A>C
 6204 DATA #2, L16O3D8DF+AGD8DF+AGD8DF+AGD8DF+AG
 6205 DATA #3, L16F+AF+AF+AF+AF+L48 F+GA B>CDEF+24<D4&D16E-4F+8.
 6206 DATA #4, D4&D16E-4F+8.A4&A16G4F+8.
 6207 DATA #5, D4&D16E-4F+8.A4&A16G4F+8.
 6208 DATA #7,\A\B
 6209 DATA --
 6210 DATA #0, @86V10O5 L16 GD<B->GD<B->GD<B->GAB- GD<B->GD<B->GD<B->GAB-
 6211 DATA #1, O6L16  P64GAP104B->DP64C<B- P24AB->P64C<B-P104AF  P64GAP24B->DP64C<B- P104AB->P64C<B-P24AF
 6212 DATA #2, L16O3GGGGGGGGGGGGFFFFFFFFFFFF
 6213 DATA #3, @86V9 O5 L16 D<B-G>D<B-G>D<B-G>DFG D<B-G>D<B-G>D<B-G>DFG
 6214 DATA #4, @92V5O5L16 L16 \G[4\G[4\G[4\G]12\G[4\G[4\G[4\G]12
 6215 DATA #7,\E\F
 6216 DATA --
 6217 DATA #0, GECGECGECGAB- GE-<B->GE-<B->GE-<B->GAB-
 6218 DATA #1, O6L16  P64GAP104B->DP64C<B- P24AB->P64C<B-P104AF  P64GAP24B->DP64C<B- P104AB->P64C<B-P24AF
 6219 DATA #2, EEEEEEEEEEEEE-E-E-E-E-E-E-E-E-E-E-E-
 6220 DATA #3, C<GE>C<GE>C<GE>CFG E-<B-G>E-<B-G>E-<B-G>E-FG
 6221 DATA #4, L16 \G[4\G[4\G[4\G]12\G[4\G[4\G[4\G]12
 6222 DATA #7,\E\F
 6223 DATA --
 6224 DATA #0, L16 GD<B->GD<B->GD<B->GAB- GD<B->GD<B->GD<B->GAB-
 6225 DATA #1, O6L16  P64GAP104B->DP64C<B- P24AB->P64C<B-P104AF  P64GAP24B->DP64C<B- P104AB->P64C<B-P24AF
 6226 DATA #2, L16O3GGGGGGGGGGGGFFFFFFFFFFFF
 6227 DATA #3, L16 D<B-G>D<B-G>D<B-G>DFG D<B-G>D<B-G>D<B-G>DFG
 6228 DATA #4, L16 \G[4\G[4\G[4\G]12\G[4\G[4\G[4\G]12
 6229 DATA #7,\E\F
 6230 DATA --
 6231 DATA #0, GECGECGECGAB- GE-<B->GE-<B->GE-<B->GAB-
 6232 DATA #1, O6L16  P64GAP104B->DP64C<B- P24AB->P64C<B-P104AF  P64GAP24B->DP64C<B- P104AB->P64C<B-P24AF
 6233 DATA #2, EEEEEEEEEEEEE-E-E-E-E-E-E-E-E-E-E-E-
 6234 DATA #3, C<GE>C<GE>C<GE>CFG E-<B-G>E-<B-G>E-<B-G>E-FG
 6235 DATA #4, L16 \G[4\G[4\G[4\G]12\G[4\G[4\G[4\G]12
 6236 DATA #7,\E\F
 6237 DATA --
 6238 DATA #0, @85V10O5 G16]4G4[4G16]4G8. [4G16]4G4[4G16]4G8.[4G16]4G4&G16[4
 6239 DATA #1, O6L16  P64GAP104B->DP64C<B- P24AB->P64C<B-P104AF  P64GAP24B->DP64C<B- P104AB->P64C<B-P24AF
 6240 DATA #2, L16O3G8GB->DC<G8GB->DC<G8GB->DC<G8GB->DC<
 6241 DATA #3, @85P24V10O5 D16]4D4[4D16]4D8.[4D16]4D4[4D16]4D8.[4D16]4D4&D16[4
 6242 DATA #4, @90V9O6 L32    P24 G2.F+F P44 ED+D P64 C+C<B P84 A+AG+ P104 GG4.
 6243 DATA #5, @90V8O6 L32 R16P24 G2.F+F P44 ED+D P64 C+C<B P84 A+AG+ P104 GG4&G16
 6244 DATA #7,\A\B
 6245 DATA --
 6246 DATA #0, G16]4G4[4G16]4G8. [4G16]4G4[4G16]4G8.[4G16]4G4&G16[4 dc
 6247 DATA #1, O6L16  P64GAP104B->DP64C<B- P24AB->P64C<B-P104AF  P64GAP24B->DP64C<B- P104AB->P64C<B-P24AF
 6248 DATA #2, L16O3G8GB->DC<G8GB->DC<G8GB->DC<G8GB->DC<
 6249 DATA #3, D16]4D4[4D16]4D8.[4D16]4D4[4D16]4D8.[4D16]4D4&D16[4
 6250 DATA #4,    G2. G+ P84 AA+B> P64 CC+D P44 D+EF P24 F+GG4.
 6251 DATA #5, R16G2. G+ P84 AA+B> P64 CC+D P44 D+EF P24 F+GG4&G16
 6252 DATA #7,\A\B
 6253 DATA ENDSONG
 6254 '
 6255 '###############################
 6256 '      ENDING
 6257 '###############################
 6258 *MSEND
 6259 DATA #0,T64
 6260 DATA \a = \ N30'2R4N38'4 \  \b = \ N30'2R4{(N38N42) R N43}4 \
 6261 DATA \c = \ N30'2R4{(N38N43)N43N43}4 \ \d = \ {(N30N43)N43N43}4 {(N38N43)N43N43}4 \
 6262 DATA \e = \ {V15N30 V11N38V12N38 V13N38V14N38V15N38}2\
 6263 DATA \f = \L8(N30N43)N43(N38N43)(N30N43)  R  N43    (N38N43)N43\
 6264 DATA \g = \L8(N30N43)N43(N38N43)(N30N43)  R (N38N43)(N38N43)N43\
 6265 DATA \h = \L8(N30N43)N43(N38N43)(N30N43)  R (N38N43)(N38N43)(N38N43)\
 6266 DATA \i = \L8R(N30N38)(N30N38)(N30N38)\
 6267 DATA \j = \L2(N38N49)L8N43N43N43N43\  \r = \R2R4{RRN40}4\
 6268 DATA ----
 6269 DATA #0,@14P64   V12O6R1R1
 6270 DATA #1,@4 P24   V10O4{EA>C<EA>C<EA>C<EA>C}1<   {EA>C<EA>C<EA>C<EA>C}1<
 6271 DATA #2,@6 P64   V10O3A1G1
 6272 DATA #3,@8 P24   V6O5E1E1
 6273 DATA #4,@8 P104  V6O4A1G1
 6274 DATA #5,@4 P104  V8O4R64~65;65;{EA>C}4<{EA>C}4<{EA>C}4< {EA>C}4<  {EA>C}4< {EA>C}4< {EA>C}4<{EA>C}8...<
 6275 DATA #7,@12R1R1
 6276 DATA ----
 6277 DATA #0,R1R1
 6278 DATA #1,{FA>C<FA>C<FB->D<FB->D}1< {EG+>D<EG+>C<EG+BDG+B}1
 6279 DATA #2,F2D2E2E2
 6280 DATA #3,E2F2E1
 6281 DATA #4,A1G+1
 6282 DATA #5,R64{FA>C}4<{FA>C}4<{FB->D}4<{FB->D}4< {EG+>D}4<{EG+>C}4<{EG+B}4 {DG+B}8...
 6283 DATA #7,R1R1
 6284 DATA ----
 6285 DATA #0,R2R4 El320El160 E2. El320El160
 6286 DATA #1,{CEAEA>C<EA>C<EA>C}1<     {EB>D<EB>D<EB>D<EB>D}1<
 6287 DATA #2,A1G+1
 6288 DATA #3,E1E1
 6289 DATA #4,A1G+1
 6290 DATA #5,R64{CEA}4  {EA>C}4<{EA>C}4< {EA>C}4<  {EB>D}4< {EB>D}4< {EB>D}4<{EB>D}8...<
 6291 DATA #7,R1R1
 6292 DATA ----
 6293 DATA #0,E2F2E2E4{<AB>D}4
 6294 DATA #1,{EA>C<EA>C<FA>D<FA>D}1<   {AB>D<AB>D}2E4<{EB>D}4<
 6295 DATA #2,A2D2E2E2
 6296 DATA #3,E2F2E2E2
 6297 DATA #4,A1A2G+2
 6298 DATA #5,R64{EA>C}4<{EA>C}4<{FA>D}4< {FA>D}4<  {AB>D}4< {AB>D}4   E4<    {EB>D}8...<
 6299 DATA #7,R1R1
 6300 DATA ----
 6301 DATA #0,C2.{<B>C<B}4E2.{EFG}4
 6302 DATA #1,{EA>C<EA>C<EA>C<AB>D}1<   {EB>D<EB>D<EB>D<EB>D}1<
 6303 DATA #2,A1G1
 6304 DATA #3,C1<B1
 6305 DATA #4,E1E1
 6306 DATA #5,R64{EA>C}4<{EA>C}4<{EA>C}4<{AB>D}4<   {EB>D}4<{EB>D}4<{EB>D}4<{EB>D}8...<
 6307 DATA #7,\a \a
 6308 DATA ----
 6309 DATA #0,A2.{A>C<B}4 G4&{GGF}4 E4{B-AG}4
 6310 DATA #1,{FA>C<FA>C<FA>C<FA>C}1<   {EG>C<EG>CC+<EB-AEG}1
 6311 DATA #2,F1C2<A2
 6312 DATA #3,A1>C2<A2
 6313 DATA #4,C1E2C+2
 6314 DATA #5,R64{FA>C}4<{FA>C}4<{FA>C}4<{FA>C}4<   {EG>C}4<{EG>C}4{C+<EB-}4{AEG}8...
 6315 DATA #7,\a \b
 6316 DATA #8,@13R1 \r
 6317 DATA ----
 6318 DATA #0,F2.{DFA}4E2.{EDC}4
 6319 DATA #1,{FA>D<FA>D<FA>D<FA>D}1<   {EA>C<EA>C<EA>C<EA>C}1<
 6320 DATA #2,D1A1
 6321 DATA #3,A1>C1<
 6322 DATA #4,D1E1
 6323 DATA #5,R64{FA>D}4<{FA>D}4<{FA>D}4<{FA>D}4<   {EA>C}4<{EA>C}4<{EA>C}4<{EA>C}8...<
 6324 DATA #7,\b \b
 6325 DATA #8,\r \r
 6326 DATA ----
 6327 DATA #0,E2.<{B>C<G+}4A2.R4
 6328 DATA #1,{AB>D<AB>DED<G+E>C<G+}1   {AE>C<EA>C}2<A2
 6329 DATA #2,E1A1
 6330 DATA #3,A2G+2A1
 6331 DATA #4,E2D2E1
 6332 DATA #5,R64{AB>D}4<{AB>D}4 {ED<G+}4{E>C<G+}4  {AE>C}4<{EA>C}4<  R4R8R16R32R64
 6333 DATA #7,\b \c
 6334 DATA #8,\r R1
 6335 DATA ----
 6336 DATA #0,Fl320Fl320Gl160Al160 Bl320Bl320>Cl160Dl160<Gl320El320Gl160Al160 E4{EEE}4
 6337 DATA #1,@5V8O6{P104RDP64F  A>P24C<A  P64GDP104FGP64BG}1{P24ECP64G  BP104GE   P64AEP24C+  AP64EC+}1
 6338 DATA #2,@7O3V11D4&{DFA}4  G4&{GDG}4  C4&{CEG}4  A4&{AEC+}4
 6339 DATA #3,@9P84V9O5F2B2G2E2
 6340 DATA #4,@9P44V8O5D2G2C2<A2>
 6341 DATA #5,@1V9O5Dl320Dl320El160Fl160 Gl320Gl320Al160Bl160 El320Cl320El160El160 C+4{C+C+C+}4
 6342 DATA #7,\d \d \d \d
 6343 DATA ----
 6344 DATA #0,Fl320Fl320Gl160Dl160 Gl320Gl320Al160Dl160 El320El320Gl160Dl160 E2
 6345 DATA #1,{P104FDP64F  A>P24C<A  P64BGP104D   DP64GB}1     {P24BBP64G EP104CE   P64C+EP24A  GP64EC+}1
 6346 DATA #2,D4&{DAF}4  G4 {BGD}4  C4&{CGC}4  A4&{AEC+}4
 6347 DATA #3,F2B2G2C+2
 6348 DATA #4,D2G2C2<A2>
 6349 DATA #5,Dl320Dl320Dl160<Bl160 Bl320Bl320>Dl160<Bl160 >Cl320Cl320Cl160Cl160 C+2
 6350 DATA #7,\d \d \d \d
 6351 DATA ----
 6352 DATA #0,Fl320Fl320Al160>El160 D4< B12A12G12&Gl320El320Gl160>Dl160  C4{C<B>C}4
 6353 DATA #1,{P104RDP64F  A>P24C<A  P64GDP104F    GP64BG}1     {P24ECP64G  BP104GE   P64AEP24C   AP64EC}1
 6354 DATA #2,D4&{DFA}4  G4&{GDG}4  E4&{EGB}4  A4&{AEC}4
 6355 DATA #3,F2B2G2E2
 6356 DATA #4,D2G2C2<A2>
 6357 DATA #5,Dl320Dl320<Fl160>Cl160<B4{FFF}4El320<Bl320>El160Bl160 E4{EEE}4
 6358 DATA #7,\d \d \d \d
 6359 DATA ----
 6360 DATA #0,{D<A>D<A>D<A>D<A>D<A>DF}1 El640<Bl160>Dl160 E2
 6361 DATA #1,{P104FDP64F  A>P24C<A  P64<B>DP104F  AP64FD}1    {P24EAP64B  AP104BA   P64G+EP24D  EP64G+B}1
 6362 DATA #2,D4&{DAF}4 <{B>DF}4  {AFA}4  E4  {G+B>D}4   E2
 6363 DATA #3,F2F2A2G+2
 6364 DATA #4,D2<B2>E2E2
 6365 DATA #5,{FFF}4{FFF}4{FFF}4{FFA}4 A4&{AAA}4G+2>
 6366 DATA #7,\d \d \d \d
 6367 DATA ----
 6368 DATA #0,El160Fl160Cl320<Al160>Cl160<{B>GD}2Dl320El320<Gl160>Dl160  C4&{C<B>C}4
 6369 DATA #1,{P104RDP64F  A>P24C<A  P64GDP104F    GP64BG}1     {P24ECP64G  BP104GE   P64AEP24C   AP64EC}1
 6370 DATA #2,D4&{DFA}4  G4&{GDG}4  C4&{CEG}4  A4&{AEC}4
 6371 DATA #3,F2B2G2E2
 6372 DATA #4,D2G2C2<A2>
 6373 DATA #5,Cl160Cl160<Al320Fl160Al160{GBB}2Bl320Bl320El160El160 A4&{AGA}4
 6374 DATA #7,\d \d \d \d
 6375 DATA ----
 6376 DATA #0,{C<A>C}2 < Bl320>Gl320Dl160D+l160 El640<Bl160>Dl160 E2
 6377 DATA #1,{P104FDP64F  A>P24C<A  P64GD<P104B>  DP64GD}1     {P24BBP64G  EP104CE   P64C+EP24A  GP64EC+}1
 6378 DATA #2,D4&{DAF}4  G4    {BGD}4   C4&{CGC}4  A4&{AEC+}4
 6379 DATA #3,A2B2G2C+2
 6380 DATA #4,D2G2C2<A2>
 6381 DATA #5,{AFA}2Gl320Bl320Bl160Bl160 >  Cl640Cl160<El160 E2>
 6382 DATA #7,\d \d \d \d
 6383 DATA ----
 6384 DATA #0,El160Fl160Cl320<Al160>Cl160 < {B>GD}2 Dl320El320<Gl160>Dl160 C4&{C<B>C}4
 6385 DATA #1,{P104RDP64F  A>P24C<A  P64GDP104F    GP64BG}1     {P24ECP64G  BP104GE   P64AEP24C   AP64EC}1
 6386 DATA #2,D4&{DFA}4  G4&{GDG}4  C4&{CEG}4  A4&{AEC}4
 6387 DATA #3,F2B2G2E2
 6388 DATA #4,D2G2C2<A2>
 6389 DATA #5,Cl160Cl160<Al320Fl160Al160 {GBB}2 Bl320Bl320El160El160 A4&{AGA}4
 6390 DATA #7,\d \d \d \d
 6391 DATA ----
 6392 DATA #0,{C<A>D}2< Bl320>Cl320<Bl160G+l160 A2.{AEC+}4
 6393 DATA #1,{P104FDP64F  A>P24C<A  P64EG+P104B>  D<P64BG+}1   {P24AEP64C  AP104EC   P64AEP24C   EP64C+A}1
 6394 DATA #2,D4&{DAF}4  E4    {BG+E}4  A4&{AEC}4  A4&{AEC+}4
 6395 DATA #3,F2G+2E2C4C+4
 6396 DATA #4,D2E2<A2A2>
 6397 DATA #5,{AFF}2 Gl640G+l160El160 E2.{EC+<A}4>
 6398 DATA #7,\d \d \d \d
 6399 DATA ----
 6400 DATA #0,El160Fl160Cl320<Al160>Cl160 < {B>GD}2 Dl320El320<Gl160>Dl160 C4&{C<B>C}4
 6401 DATA #1,{P104RDP64F  A>P24C<A  P64GDP104F    GP64BG}1     {P24ECP64G  BP104GE   P64AEP24C   EP64GA}1
 6402 DATA #2,D4&{DDD}4  G4&{GGG}4  C4&{CCC}4  A4&{AAA}4
 6403 DATA #3,F2B2G2E2
 6404 DATA #4,D2G2 C2<A2>
 6405 DATA #5,Cl160Cl160<Al320Fl160Al160 {GBB}2 Bl320Bl320El160El160 A4&{AGA}4
 6406 DATA #7,\d \d \d \d
 6407 DATA ----
 6408 DATA #0,C2.&{C<B>C}4D2.&{D<B>C}4
 6409 DATA #1,{P104RDP64F  A>P24C<A  P64FDP104F    A>P64C<A}1   {P24REP64G  B>P104D<B P64GEP24G   B>P64D<B}1
 6410 DATA #2,D4&{DDD}4  {R]8D[2D[2D[2D[2D}2  E4&{EEE}4  {R]8E[2E[2E[2E[2E}2
 6411 DATA #3,F2F2G2G2
 6412 DATA #4,D2D2 E2E2
 6413 DATA #5,A2&A4&{AAA}4  B2&B4&{BGA}4
 6414 DATA #7,\d \d \d \d
 6415 DATA ----
 6416 DATA #0,C2.&{C<B>C}4D2.&{D<BA-}4
 6417 DATA #1,{P104RDP64F  A>P24C<A  P64FDP104F    A>P64C<A}1   {P24REP64G  B>P104D<B P64GEP24G   B>P64D<B}1
 6418 DATA #2,D4&{DDD}4  {R]8D[2D[2D[2D[2D}2  E4&{EEE}4  {R]8E[2E[2E[2E[2E}2
 6419 DATA #3,F2F2G2G2
 6420 DATA #4,D2D2 E2E2
 6421 DATA #5,A2&A4&{AGA}4  B2&B4&{BEE}4
 6422 DATA #7,\d \d \d \d
 6423 DATA ----
 6424 DATA #0,A4&{AAA}4 T61 A4&{AAA}4 T58 A4&{AAA}4 T55 A4&{AAA}4
 6425 DATA #1,{P104RCP64E  AP24EC    P64RCP104E    AP64EC}1     {P24RCP64E  AP104EC   P64RCP24E AP64EC}1
 6426 DATA #2,{AAAAAAGGGGGG}1 {F+F+F+F+F+F+FFFFFF}1
 6427 DATA #3,E2E2E2E2
 6428 DATA #4,A2A2 A2A2
 6429 DATA #5,E4&{EEE}4 E4&{EEE}4 E4&{EEE}4 E4&{EEE}4
 6430 DATA #7,\e \e \e \e
 6431 DATA ----
 6432 DATA #0,T52 A2T114@2V10O4L8AB>CE
 6433 DATA #1,A2P64@2V9 O4L8 EGAA
 6434 DATA #2,A2O4L8R2
 6435 DATA #3,E2@10V5O4R2
 6436 DATA #4,A2@10V4O4R2
 6437 DATA #5,E2@3O5V13L8R2[2P56
 6438 DATA #7,\j
 6439 DATA ----
 6440 DATA #0,E4.D4.C4D2{DGD}2E2&E8<G4BA4.A>C+GFE
 6441 DATA #1,F4.F4.F4B2 {BBB}2 B2&B8E4EC+4.C+A>C+C+C+
 6442 DATA #2,D4.D4EFA G4.G4.FG C4.C4EGE<A4.A4>C+EC+
 6443 DATA #3,A8R4A2&A8 B8R4B2&B8 B8R4B2&B8 A8R4A2&A8
 6444 DATA #4,F8R4F2&F8 G8R4G2&G8    E8R4E2&E8 C+8R4C+2&C+8
 6445 DATA #5,R4C+D4FA4>   C<B4>D {DC<B>C<BA}2  R4A+32B8..A+32B8..A+32B8..BA4A8&A2
 6446 DATA #7,\f \f \f \f
 6447 DATA ----
 6448 DATA #0,F4.<A4.>C4<B2>GA4D8&D8D+E4&E2&E4&E8C+AB-AG
 6449 DATA #1,D4.<F4.A4G2BB4B4BB4&B2A4&A8A>C+C+C+C+
 6450 DATA #2,D4.D4EFA G4.G4.FG C4.C4DD+E A4.A4EC+<A>
 6451 DATA #3,A8R4A2&A8 B8R4B2&B8 B8R4B2&B8 A8R4A2&A8
 6452 DATA #4,F8R4F2&F8 G8R4G2&G8    E8R4E2&E8 C+8R4C+2&C+8
 6453 DATA #5,RDFA>ED<BA   B>C4D4<B4G   REGB>DC<B>C<  AEC+<A4>C+EA
 6454 DATA #7,\f \f \f \f
 6455 DATA ----
 6456 DATA #0,G4F4FE4D8&D2DG8&G8E8&E2&E8EDC<A2&A8G+A>C
 6457 DATA #1,C4C4CC4<B8&B2BB4B8&B2&B8>C<BEE2^8EEA
 6458 DATA #2,D4.D4EFA G4.G4.FG C4.C4EC<G+ A4.A4.>D+E
 6459 DATA #3,A8R4A2&A8 B8R4B2&B8 B8R4B2&B8 A8R4A2&A8
 6460 DATA #4,F8R4F2&F8 G8R4G2&G8    E8R4E2&E8 C8R4C2&C8
 6461 DATA #5,RD4.DFAF     GABGDG4G     RGBG>DC<BG    AEC+<A4>C+EG
 6462 DATA #7,\f \f \f \f
 6463 DATA ----
 6464 DATA #0,DE4<A4>C4<B4>D4<B4G+4B4.>C<A1&A8A>C+EG
 6465 DATA #1,FF4F4F4G+4B4G+4E4E4.AE1&E8EA>C+C+
 6466 DATA #2,D4.D4D+EFE4.E4E<BG+ A4.A4A>CE A-32_A16.R8 A-32_A16.R8 A-32_A16.EC+E
 6467 DATA #3,A8R4A2&A8 B8R4B2&B8 A8R4A2&A8 A8R8A8R8A8A4.
 6468 DATA #4,F8R4F2&F8 G+8R4G+2&G+8 E8R4E2&E8 E8R8E8R8E8E4.
 6469 DATA #5,RDFA>C<A>C<A G+E4E4>DC<G+ REA>CD<BG>D C<A4BA4A4
 6470 DATA #7,\f \f \f \h
 6471 DATA ----
 6472 DATA #0,F4.EF>C4<B8&B2B>C<BAB4.G4EGEC+2AB-AE
 6473 DATA #1,C4.CCF4D8&D2FFFFE4.E4CCC<A2>C+C+C+C+
 6474 DATA #2,D4.D4.D4 G4.G4.G<G> C4.C4.C4< A4.A4.A4>
 6475 DATA #3,A8R4A2&A8 B8R4B2&B8 B8R4B2&B8 A8R4A2&A8
 6476 DATA #4,F8R4F2&F8 G8R4G2&G8    E8R4E2&E8 C+8R4C+2&C+8
 6477 DATA #5,R4D4DEDC    <B>DFABABA    BAGE8&E2    C+4.C+4EGE
 6478 DATA #6,@11V13O6R1R1R1R2L8AB-AE
 6479 DATA #7,\f \f \f \f
 6480 DATA ----
 6481 DATA #0,F4.EF>E4D4.<B4A4B4B2&B8GEG C+4.C+AGFE
 6482 DATA #1,C4.CCF4B4.F4F4F4E2&E8ECE<A4.A>C+C+C+C+
 6483 DATA #2,D4.D4.D4 G4.G4.G<G> C4.C4.C4< A4.A4.A4>
 6484 DATA #3,A8R4A2&A8 B8R4B2&B8 B8R4B2&B8 A8R4A2&A8
 6485 DATA #4,F8R4F2&F8 G8R4G2&G8    E8R4E2&E8 C+8R4C+2&C+8
 6486 DATA #5,R4D4D4F4     GAB>D4C<B>C< B>CD<B>C16<B8.>C  E< A>C+EA8&A2<
 6487 DATA #6,F4.EF>E4D4.<B4A4B4B2&B8GEG C+4.C+AGFE
 6488 DATA #7,\f \f \f \f
 6489 DATA ----
 6490 DATA #0,E4.F4.A4B4.>D4.<B4>C4.<B4.>C4DE4<A4.L16AB>C<A>
 6491 DATA #1,C4.D4.F4E4.E4.E4A4.E4.A4AA4D4.L16DDDD
 6492 DATA #2,D4.D4.D4<G+4.G+4.G+4 A4.A4.A4 F+4.F+4.F+4>
 6493 DATA #3,A8R4A2&A8 B8R4B2&B8>C8R4C2&C8<A8R4A2&A8
 6494 DATA #4,F8R4F2&F8 G+8R4G+2&G+8 A8R4A2&A8 F+8R4F+2&F+8
 6495 DATA #5,RDEFDEFD     G+E4G+4B>D<B REA>CEC<A>C  R<F+A>EDC<AE
 6496 DATA #6,E4.F4.A4B4.>D4.<B4>C4.<B4.>C4DE4<A4.L16AB>C<A>
 6497 DATA #7,\g \g \g \g
 6498 DATA ----
 6499 DATA #0,L8C4<B4A>C4.<B4.E>DC<G+>C<B4.A2&A8A2<    AB>CE
 6500 DATA #1,L8F4F4FF4.G+4.<B>G+G+EG+E4.E2&E8E2<  EGAA
 6501 DATA #2,D4.D4.DD+ E4.E4.E<BA4.A4.A4 A4.A>C+DD+E
 6502 DATA #3,A8R4A2&A8 B8R4B2&B8 A8R4A2&A8 A8R4A2&A8
 6503 DATA #4,F8R4F2&F8 G+8R4G+2&G+8 E8R4E2&E8 E8R4E8  @15O4V13L8 AB>CE
 6504 DATA #5,RDFA>C<A>C<A G+E4E4>DC<G+ EA>CD<BG>DC<  A4A4AB>CE<
 6505 DATA #6,L8C4<B4A>C4.<B4.E>DC<G+>C<B4.A2&A8A2<    AB>CE
 6506 DATA #7,\f \f \f \f
 6507 DATA ----
 6508 DATA #0,E4.D4.C4D2{DGD}2E2&E8<G4BA4.A>C+GFE
 6509 DATA #1,F4.F4.F4B2{BBB}2 B2&B8E4EC+4.C+A>C+C+C+
 6510 DATA #2,D4.D4EFA G4.G4.FG C4.C4EGE<A4.A4>C+EC+
 6511 DATA #3,A8R4A2&A8 B8R4B2&B8 B8R4B2&B8 A8R4A2&A8
 6512 DATA #4,E4.D4.C4D2{DGD}2 E2&E8<G4BA4.A>C+GFE
 6513 DATA #5,R4C+D4FA4> C<B4>D {DC<B>C<BA}2  R4A+32B8..A+32B8..A+32B8..BA4A8^2
 6514 DATA #6,E4.D4.C4D2{DGD}2E2&E8<G4BA4.A>C+GFE
 6515 DATA #7,\f \f \f \f
 6516 DATA ----
 6517 DATA #0,F4.<A4.>C4<B2>GA4D4D+E4&E2&E4&E8C+ AB-AG
 6518 DATA #1,D4.<F4.A4G2BB4B4BB4&B2A4&A8A>C+C+C+C+
 6519 DATA #2,D4.D4EFA G4.G4.FG C4.C4DD+E A4.A4EC+<A>
 6520 DATA #3,A8R4A2&A8 B8R4B2&B8 B8R4B2&B8 A8R4A2&A8
 6521 DATA #4,F4.<A4.>C4<B2>GA4D4D+E4&E2&E4&E8C+ AB-AG
 6522 DATA #5,RDFA>ED<BA B>C4D4<B4G  REGB>DC<B>C<  AEC+<A4>C+EA
 6523 DATA #6,F4.<A4.>C4<B2>GA4D4D+E4&E2&E4&E8C+ AB-AG
 6524 DATA #7,\f \f \f \f
 6525 DATA ----
 6526 DATA #0,G4F4FE4D8&D2DG4E8&E2&E8EDC<A2&A8G+A>C
 6527 DATA #1,C4C4CC4<B8&B2BB4B8&B2&B8>C<BEE2&E8EEA
 6528 DATA #2,D4.D4EFA G4.G4.FG C4.C4EC<G+ A4.A4.>D+E
 6529 DATA #3,A8R4A2&A8 B8R4B2&B8 B8R4B2&B8 A8R4A2&A8
 6530 DATA #4,G4F4FE4D8&D2DG4E8&E2&E8EDC<A2&A8G+A>C
 6531 DATA #5,RD4.DFAF   GABGDG4G    RGBG>DC<BG    AEC+<A4>C+EG
 6532 DATA #6,G4F4FE4D8&D2DG4E8&E2&E8EDC<A2&A8G+A>C
 6533 DATA #7,\f \f \f \f
 6534 DATA ----
 6535 DATA #0,DE4<A4>C4<B4>D4<B4G+4B4.>C<A1&A8A>C+EG
 6536 DATA #1,FF4F4F4G+4B4G+4E4E4.AE1&E8EA>C+C+
 6537 DATA #2,D4.D4D+EFE4.E4E<BG+ A4.A4A>CE A-32_A16.R8 A-32_A16.R8 A-32_A16.EC+E
 6538 DATA #3,A8R4A2&A8 B8R4B2&B8 A8R4A2&A8 A8R8A8R8A8A4.
 6539 DATA #4,DE4<A4>C4<B4>D4<B4G+4B4.>C<A1&A8A>C+EG
 6540 DATA #5,RDFA>C<A>C<A  G+E4E4>DC<G+  REA>CD<BG>D C<A4BA4A4
 6541 DATA #6,DE4<A4>C4<B4>D4<B4G+4B4.>C<A1&A8A>C+EG
 6542 DATA #7,\f \f \f \h
 6543 DATA #8,@15V12O4R1R1R1R2L8 P72EA>C+C+
 6544 DATA ----
 6545 DATA #0,F4.EF>C4<B8&B2B>C<BAB4.G4EGEC+2AB-AE
 6546 DATA #1,C4.CCF4D8&D2FFFFE4.E4CCC<A2>C+C+C+C+
 6547 DATA #2,D4.D4.D4 G4.G4.G<G> C4.C4.C4< A4.A4.A4>
 6548 DATA #3,A8R4A2&A8 B8R4B2&B8 B8R4B2&B8 A8R4A2&A8
 6549 DATA #4,F4.EF>C4<B8&B2B>C<BAB4.G4EGEC+2AB-AE
 6550 DATA #5,R4D4DEDC   <B>DFABABA BAGE8&E2    C+4.C+4EGE
 6551 DATA #6,F4.EF>C4<B8&B2B>C<BAB4.G4EGEC+2AB-AE
 6552 DATA #7,\f \f \f \f
 6553 DATA #8,C4.CCF4D8&D2FFFFE4.E4CCC<A2>C+C+C+C+
 6554 DATA ----
 6555 DATA #0,F4.EF>E4D4.<B4A4B4B2&B8GEG C+4.C+AGFE
 6556 DATA #1,C4.CCF4B4.F4F4F4E2&E8ECE<A4.A>C+C+C+C+
 6557 DATA #2,D4.D4.D4 G4.G4.G<G> C4.C4.C4< A4.A4.A4>
 6558 DATA #3,A8R4A2&A8 B8R4B2&B8 B8R4B2&B8 A8R4A2&A8
 6559 DATA #4,F4.EF>E4D4.<B4A4B4B2&B8GEG C+4.C+AGFE
 6560 DATA #5,R4D4D4F4   GAB>D4C<B>C<  B>CD<B>C16<B8.>CE< A>C+EA8&A2<
 6561 DATA #6,F4.EF>E4D4.<B4A4B4B2&B8GEG C+4.C+AGFE
 6562 DATA #7,\f \f \f \f
 6563 DATA #8,C4.CCF4B4.F4F4F4E2&E8ECE<A4.A>C+C+C+C+
 6564 DATA ----
 6565 DATA #0,E4.F4.A4B4.>D4.<B4>C4.<B4.>C4DE4<A4.L16AB>C<A>
 6566 DATA #1,C4.D4.F4E4.E4.E4A4.E4.A4AA4D4.L16DDDD
 6567 DATA #2,D4.D4.D4<G+4.G+4.G+4 A4.A4.A4 F+4.F+4.F+4>
 6568 DATA #3,A8R4A2&A8 B8R4B2&B8>C8R4C2&C8<A8R4A2&A8
 6569 DATA #4,E4.F4.A4B4.>D4.<B4>C4.<B4.>C4DE4<A4.L16AB>C<A>
 6570 DATA #5,RDEFDEFD   G+E4G+4B>D<B  REA>CEC<A>C  R<F+A>EDC<AE
 6571 DATA #6,E4.F4.A4B4.>D4.<B4>C4.<B4.>C4DE4<A4.L16AB>C<A>
 6572 DATA #7,\g \g \g \g
 6573 DATA #8,C4.D4.F4E4.E4.E4A4.E4.A4AA4D4.L16DDDD
 6574 DATA ----
 6575 DATA #0,L8C4<B4A>C4.<B4.E>DC<G+>C<B4.A2&A8A2.L16AB>C<A>
 6576 DATA #1,L8F4F4FF4.G+4.<B>G+G+EG+E4.E2&E8E2.D16D16D16D16
 6577 DATA #2,D4.D4.DD+ E4.E4.E<BA4.A4.A4 A4.A4AAA>
 6578 DATA #3,A8R4A2&A8 B8R4B2&B8 A8R4A2&A8 A8R4A2&A8
 6579 DATA #4,L8C4<B4A>C4.<B4.E>DC<G+>C<B4.A2&A8A2.L16AB>C<A>
 6580 DATA #5,RDFA>C<A>C<A G+E4E4>DC<G+  EA>CD<BG>DC<  A4A4 AB>C<A
 6581 DATA #6,L8C4<B4A>C4.<B4.E>DC<G+>C<B4.A2&A8A2.L16AB>C<A>
 6582 DATA #7,\f \f \f \f
 6583 DATA #8,L8F4F4FF4.G+4.<B>G+G+EG+E4.E2&E8E2.D16D16D16D16
 6584 DATA ----
 6585 DATA #0,L8C4<B4A>C4.<B4.E>DC<G+>C<B4.A2&A8A4.A2&A8
 6586 DATA #1,L8F4F4FF4.G+4.<B>G+G+EG+E4.E2&E8E4.E2&E8
 6587 DATA #2,D4.D4.DD+ E4.E4.E<BA4.A4.A4 A4.A4.A4
 6588 DATA #3,A8R4A2&A8 B8R4B2&B8 A8R4A2&A8 A8R4A2&A8
 6589 DATA #4,L8C4<B4A>C4.<B4.E>DC<G+>C<B4.A2&A8A4.A2&A8
 6590 DATA #5,RDFA>C<A>C<A G+E4E4>DC<G+  EA>CD<BG>DC<  A4.A4>CEA<
 6591 DATA #6,L8C4<B4A>C4.<B4.E>DC<G+>C<B4.A2&A8A4.A2&A8
 6592 DATA #7,\g \g \g \g
 6593 DATA #8,L8F4F4FF4.G+4.<B>G+G+EG+E4.E2&E8E4.E2&E8
 6594 DATA ----
 6595 DATA #0,A4.A2&A8A4.A2&A8A4.A2&A8A1
 6596 DATA #1,E4.E2&E8F+4.F+2&F+8F4.F2&F8E1
 6597 DATA #2,G4.G4.G4 F+4.F+4.F+4 F4.F4.F4 A1
 6598 DATA #3,A8R4A2&A8 A8R4A2&A8 A8R4A2&A8 A1
 6599 DATA #4,A4.A2&A8A4.A2&A8A4.A2&A8A1
 6600 DATA #5,A4.A4>CEA<  A4.A4>DF+A<   A4.A4>DFA<  A4.A4>CEA<
 6601 DATA #6,A4.A2&A8A4.A2&A8A4.A2&A8A1
 6602 DATA #7,\f \f \f \f
 6603 DATA #8,E4.E2&E8F+4.F+2&F+8F4.F2&F8E1
 6604 DATA ----
 6605 DATA #0,R8A8A8A8 R4@3O4V10P80        A1&A1R16
 6606 DATA #1,R8E8E8E8 R4@3O4V10P70     R64G1&G1R32R64
 6607 DATA #2,R8A8A8A8 R4@3O5V10P60     R32C1&C1R32
 6608 DATA #3,R8A8A8A8 R4@3O5V10P50  R64R32E1&E1R64
 6609 DATA #4,R8A8A8A8 R4@3O5V10P40     R16B1&B1
 6610 DATA #7,\i R4R1R1R16
 6611 DATA ENDSONG
 6612 '
 6613 '###############################
 6614 '      Prolog
 6615 '###############################
 6616 *MSPRO
 6617 DATA \a = \@67O2V6L24EFF+ [2L96GG+AA+B>CL48C+DD+ [2EFF+GG+A [2B>CC+DD+E L24]2EFF+ L48GG+AA+B&B ]2B>CC+DD+E L24EFF+\
 6618 DATA \b = \L48]2GG+AA+B&B B8 L48]2>CC+DD+E&E L24 EFF+ ]2 GG+A L48 AA+B >C16&C8\
 6619 DATA --
 6620 DATA #0,T60 @66 P64 O4 V6  L4 B>CDE F.E16D16<B2& B1&B2.&B8.>E16
 6621 DATA #1, @66P24O4 L4 V4 A~65;65; ]2 A ]2 A [2 A  A2 [2 A2 A2 [2 A2 A4 [2 A2.
 6622 DATA #2, @66P104O4 L4 V4G~65;65; ]2G ]2G [2G G2 [2 G2 G2 [2 G2 G4 [2G2.
 6623 DATA #3, @66P64O4 L4 V4G ]2G ]2G [2G @67 G2 [2 G2 G2 [2 G2 G4 [2 G2.
 6624 DATA #4, P64@71V6 O7 A1&A1R1@72V3 O8L48E8 ED+DC+C<B[2BBA+AG+G[2GGF+FFE[2ED+DC+C<B[2BBA+AG+G[2GF+FEEE ]10 ED+DDDD
 6625 DATA #5, P64@66O4V5 L4 GAB>C D.C16<B16G2&G1&G2.&G8.>C16
 6626 DATA --
 6627 DATA #0,F8.E16F8.E16F8.E16D12C12<A12
 6628 DATA #1, L4 V4 A ]2 A ]2 A [2 A
 6629 DATA #2, L4 V4G ]2G ]2G [2G
 6630 DATA #3, @66 L4 V4G ]2G ]2G [2G
 6631 DATA #4, EF+AB>C+D+ FGAB>C+D+ FGA A2&A8.
 6632 DATA #5, D8.C16D8.C16D8.C16<B12A12F12
 6633 DATA --
 6634 DATA #0,B2.B12B12B12
 6635 DATA #1, A2 [2 A2
 6636 DATA #2, G2 [2 G2
 6637 DATA #3, @67 G2 [2 G2
 6638 DATA #4, @71V6 O7 L32 FAB>C<]2 FAB>C<]2FAB>C<]2FAB>C<]2FAB>C<]2FAB>C<]2FAB>C<]2FAB>C<]2
 6639 DATA #5, G2.G12G12G12
 6640 DATA --
 6641 DATA #0,A2.A12A12A12
 6642 DATA #1, A2 [2 A2
 6643 DATA #2, G2 [2 G2
 6644 DATA #3, G2 [2 G2
 6645 DATA #4, P24@73O2V2L32DD[2 D[2 D16[2 D16[2 DD[2 DD[2 D16[2 D16]2 D DDD]2 D16D16D]2 DDD]2 D16D16]2 D
 6646 DATA #5, F2.F12F12F12
 6647 DATA --
 6648 DATA #0,B2&B2
 6649 DATA #1, A4 [2 A2.
 6650 DATA #2, G4 [2G2.
 6651 DATA #3, G4 [2 G2.
 6652 DATA #4, P64@72V3 O6 L48E8&ED+DC+C<B[2BBA+AG+G[2GGF+FFE[2ED+DC+C<B[2BBA+AG+G[2GF+FEEE[2ED+DDDD
 6653 DATA #5, P104@73O2V3 L32 D~63;63;D[2 D[2 D16[2 D16[2 DD[2 DD[2 D16[2 D16]2 D DDD]2 D16D16D]2 DDD]2 D16D16]2 D
 6654 DATA --
 6655 DATA #6, P104@67V10 O2 E1~63;63;&E1&E1
 6656 DATA #1, P64@67V9 O2E1&E1&E1
 6657 DATA #2, @69V10O4P104L32 EEF+GA+A+EER2.R1R1
 6658 DATA #3, @69V9 O3P24 L32 EEF+GEEA+A+R2.R1 R1
 6659 DATA #4, @75O2 C1R1R1
 6660 DATA #5, P64@76O2V11 L32 EEF+GEEA+A+R2. R1R1
 6661 DATA #0,T80R64T110R64T130R1
 6662 DATA --
 6663 DATA #0, @67P104O2E1~V111;111;&E1~V111;111;&E1~V111;111;&E1~V111;90;
 6664 DATA #1, @67P64O2E1~V109;109;&E1~V109;109;&E1~V109;109;&E1~V109;80;
 6665 DATA #2, P64@70V8 O6 L8 B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<
 6666 DATA #3, @70V6 O6P64 L8 R16 B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE16<
 6667 DATA #4, R1R1R1R1
 6668 DATA #5, R1R1R1R1
 6669 DATA --
 6670 DATA #0, @79V9 O3C1&C1&C1&C2.&C8<G8>
 6671 DATA #1, P24@79V9 O3C1&C1&C1&C1
 6672 DATA #2, B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<
 6673 DATA #3, R16 B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE16<
 6674 DATA #4, @74V7 O5 L16 B4>C4D4E4 F4.ED<B2&B1&B1
 6675 DATA #5, @74V7 O5L16 G4A4B4>C4 D4.C<BG2&G1&G1
 6676 DATA --
 6677 DATA #0, C1&C1&C1&C1
 6678 DATA #1, C2.&C8<G8>C1&C1&C1
 6679 DATA #2, B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<
 6680 DATA #3, R16 B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE16<
 6681 DATA #4, B4>C4D4E4F4.ED<B2&B1&B2.&B8.>E
 6682 DATA #5, G4A4B4>C4 D4.C<BG2&G1&G2.&G8.>C
 6683 DATA --
 6684 DATA #0, C1&C1&C1&C2.&C8<G8>
 6685 DATA #1, C1&C1&C1&C1
 6686 DATA #2, B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<
 6687 DATA #3, R16 B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE16<
 6688 DATA #4, F8.&F8.E&E16F8.&F8.E&E16 F8.&F8.E&E16D12&D12C12&C12<A12&A12 B1&B1
 6689 DATA #5, D8.&D8.C&C16D8.&D8.C&C16 D8.&D8.C&C16<B12&B12A12&A12F12&F12 G1&G1
 6690 DATA --
 6691 DATA #0, C1&C1&C1&C2.&C8<G8>
 6692 DATA #1, C1&C1&C1&C1
 6693 DATA #2, B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<
 6694 DATA #3, R16 B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE16<
 6695 DATA #4, L16 B4>C4D4E4 F4.ED<B2&B1&B1
 6696 DATA #5, L16 G4A4B4>C4 D4.C<BG2&G1&G1
 6697 DATA --
 6698 DATA #0, C1&C1&C1&C1
 6699 DATA #1, C2.&C8<G8>C1&C1&C1
 6700 DATA #2, B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<
 6701 DATA #3, R16 B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE16<
 6702 DATA #4, B4>C4D4E4 F4.ED<B2&B1&B2.&B8.>E
 6703 DATA #5, G4A4B4>C4 D4.C<BG2&G1&G2.&G8.>C
 6704 DATA --
 6705 DATA #0, C1&C1&C1&C2.&C8<G8>
 6706 DATA #1, C1&C1&C1&C1
 6707 DATA #2, B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<
 6708 DATA #3, R16 B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE16<
 6709 DATA #4, F8.&F8.E&E16F8.&F8.E&E16 F8.&F8.E&E16D12&D12C12&C12<A12&A12 B1&B1
 6710 DATA #5, D8.&D8.C&C16D8.&D8.C&C16 D8.&D8.C&C16<B12&B12A12&A12F12&F12 G1&G1
 6711 DATA --
 6712 DATA #0, C1&C1&C1&C1
 6713 DATA #1, C2.&C8<G8>C1&C1&C1
 6714 DATA #2, B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<
 6715 DATA #3, R16 B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE<B>CDE16<
 6716 DATA #4, @71O7V3  A1&A1A1 @72V6 O8 L48E8ED+DC+C<B[2BBA+AG+G[2GGF+FFE[2ED+DC+C<B[2BBA+AG+G[2GF+FEEE  [2ED+DDDD
 6717 DATA #5, P64@67V2O2 L8 ER4.ER4. ER4.ER4E RERERERE[4EEEEEEE16E16E16E16
 6718 DATA --
 6719 DATA #0, T110 R1 T130 R2 T140 R2 T150 R2R4
 6720 DATA #1, @76P64V11 O2 C4 D4 E4 G4
 6721 DATA #2, \a \b
 6722 DATA #3, P64@72O4V1L48ED+DC+C<B L24[2BA+A L48[2G+GF+FE48 L48[2ED+DC+C<B L48[2BA+AG+16 L24[2GF+F L24[2ED+D&D8
 6723 DATA #4, @82V11O2 L3 E1~64;54;&E1~54;22; &E4~22;22; &E2~22;0;
 6724 DATA #6, @82P64V11O2 C+1~64;80; &C+1~80;96; &C+4~96;106; &C+2~106;127;
 6725 DATA --
 6726 DATA ENDSONG
 6727 '
 6728 '###############################
 6729 '      Moon light sonata
 6730 '###############################
 6731 *MSMOON
 6732 DATA #1,"T72 @1 P64  V11O4    "
 6733 DATA #2,"    @1 P74  V10O3    "
 6734 DATA #3,"    @1 P64  V11O3    "
 6735 DATA #4,"    @1 P64  V11O3    "
 6736 DATA #5,"    @1 P64  V11O3    "
 6737 DATA #6,"    @1 P44  V8 O4    "
 6738 DATA ------------------------------------------
 6739 DATA #1,"R1"
 6740 DATA #2,"{[1G+]1>C+E}{<G+>C+E}{<G+>C+E}{<G+>C+E<}"
 6741 DATA #3,"C+1"
 6742 DATA #4,"C+1"
 6743 DATA #5,"C+1"
 6744 DATA #6,"{[1G+]1>C+E}{<G+>C+E}{<G+>C+E}{<G+>C+E<}"
 6745 DATA ------------------------------------------
 6746 DATA #1,"R1"
 6747 DATA #2,"{[1G+]1>C+E}{<G+>C+E}{<G+>C+E}{<G+>C+E<}"
 6748 DATA #3,"<B1"
 6749 DATA #4,"<B1"
 6750 DATA #5,"<B1"
 6751 DATA #6,"{[1G+]1>C+E}{<G+>C+E}{<G+>C+E}{<G+>C+E<}"
 6752 DATA ------------------------------------------
 6753 DATA #1,"R1"
 6754 DATA #2,"{[1A]1>C+E}{<A>C+E}{<[1A]1>DF+}{<A>DF+<}"
 6755 DATA #3,"A2F+2"
 6756 DATA #4,"A2F+2"
 6757 DATA #5,"A2F+2"
 6758 DATA #6,"{[1A]1>C+E}{<A>C+E<}{[1A]1>DF+}{<A>DF+<}"
 6759 DATA ------------------------------------------
 6760 DATA #1,"R1"
 6761 DATA #2,"{[1G+]1>CF+}{<G+>C+E}{<G+>C+D+}{<F+>CD+<}"
 6762 DATA #3,"G+2G+2"
 6763 DATA #4,"G+2G+2"
 6764 DATA #5,"G+2G+2"
 6765 DATA #6,"{[1G+]1>CF+}{<G+>C+E}{<G+>C+D+}{<F+>CD+<}"
 6766 DATA ------------------------------------------
 6767 DATA #1,"R2.G+8.G+16"
 6768 DATA #2,"{[1E]1G+>C+<}{[1G+]1>C+E<}{[1G+]1>C+E<}{[1G+]1>C+E<}"
 6769 DATA #3,">C+1"
 6770 DATA #4,">G+1"
 6771 DATA #5,">C+1"
 6772 DATA #6,"{[1E]1G+>C+<}{[1G+]1>C+E<}{[1G+]1>C+E<}{[1G+]1>C+E<}"
 6773 DATA ------------------------------------------
 6774 DATA #1,"G+2.G+8.G+16"
 6775 DATA #2,"{[1G+]1>D+F+}{<[1G+]1>D+F+}{<[1G+]1>D+F+}{<[1G+]1>D+F+<}"
 6776 DATA #3,"C1"
 6777 DATA #4,"G+1"
 6778 DATA #5,"C1"
 6779 DATA #6,"{[1G+]1>D+F+}{<[1G+]1>D+F+}{<[1G+]1>D+F+}{<[1G+]1>D+F+<}"
 6780 DATA ------------------------------------------
 6781 DATA #1,"G+2]1A2"
 6782 DATA #2,"{[1G+]1>C+E}{<[1G+]1>C+E}{<[1A]1>C+F+}{<[1A]1>C+F+<}"
 6783 DATA #3,"C+2]1<F+2"
 6784 DATA #4,"C+2]2<F+2"
 6785 DATA #5,"C+2]2<F+2"
 6786 DATA #6,"{[1G+]1>C+E}{<[1G+]1>C+E}{<[1A]1>C+F+}{<[1A]1>C+F+<}"
 6787 DATA ------------------------------------------
 6788 DATA #1,"G+2F+4[1B4]1"
 6789 DATA #2,"{[1G+]1B>E}{<[1G+]1B>E}{<[1A]1B>D+}{<[1A]1B>D+<}"
 6790 DATA #3,"B2[1B2]1>"
 6791 DATA #4,"B2[2B2]2>"
 6792 DATA #5,"B2[2B2]2>"
 6793 DATA #6,"{[1G+]1B>E}{<[1G+]1B>E}{<[1A]1B>D+}{<[1A]1B>D+<}"
 6794 DATA ------------------------------------------
 6795 DATA #1,"E4R2.[1"
 6796 DATA #2,"{[1G+]1B>E}{<[1G+]1B>E}{<[1G+]1B>E}{<[1G+]1B>E<}"
 6797 DATA #3,"E1[1"
 6798 DATA #4,"E1[2"
 6799 DATA #5,"E1[2"
 6800 DATA #6,"{[1G+]1B>E}{<[1G+]1B>E}{<[1G+]1B>E}{<[1G+]1B>E<}"
 6801 DATA ------------------------------------------
 6802 DATA #1,"R2.G8.G16"
 6803 DATA #2,"{[1G]1B>E}{<[1G]1B>E}{<[1G]1B>E}{<[1G]1B>E<}"
 6804 DATA #3,"E1]1"
 6805 DATA #4,"E1]2"
 6806 DATA #5,"E1]2"
 6807 DATA #6,"{[1G]1B>E}{<[1G]1B>E}{<[1G]1B>E}{<[1G]1B>E<}"
 6808 DATA ------------------------------------------
 6809 DATA #1,"G2.G8.G16"
 6810 DATA #2,"{[1G]1B>F}{<[1G]1B>F}{<[1G]1B>F}{<[1G]1B>F<}"
 6811 DATA #3,"D1[1"
 6812 DATA #4,"D1[2"
 6813 DATA #5,"D1[2"
 6814 DATA #6,"{[1G]1B>F}{<[1G]1B>F}{<[1G]1B>F}{<[1G]1B>F<}"
 6815 DATA ------------------------------------------
 6816 DATA #1,"G2.F+4"
 6817 DATA #2,"{[1G]1>CE}{<[1G]1B>E}{<[1G]1>C+E}{<[1F+]1>C+E<}"
 6818 DATA #3,"C4]1<B4A+2[1"
 6819 DATA #4,"C4]2<B4A+2[2"
 6820 DATA #5,"C4]2<B4A+2[2"
 6821 DATA #6,"{[1G]1>CE}{<[1G]1B>E}{<[1G]1>C+E}{<[1F+]1>C+E<}"
 6822 DATA ------------------------------------------
 6823 DATA #1,"F+2]1G4E4"
 6824 DATA #2,"{[1F+]1B>D}{<[1F+]1B>D}{<[1G]1B>C+}{<[1E]1B>C+<}"
 6825 DATA #3,"B2]1E4G4[1"
 6826 DATA #4,"B2R2>"
 6827 DATA #5,"B2R2>"
 6828 DATA #6,"{[1F+]1B>D}{<[1F+]1B>D}{<[1G]1B>C+}{<[1E]1B>C+<}"
 6829 DATA ------------------------------------------
 6830 DATA #1,"F+2[1F+2]1<"
 6831 DATA #2,"{[1F+]1B>D}{<F+B>D}{<[1F+]1A+>C+}{<F+A+>C+<}"
 6832 DATA #3,"F+2F+2"
 6833 DATA #4,"F+2<F+2"
 6834 DATA #5,"F+2<F+2"
 6835 DATA #6,"{[1F+]1B>D}{<F+B>D}{<[1F+]1A+>C+}{<F+A+>C+<}"
 6836 DATA ------------------------------------------
 6837 DATA #1,"B4R2>[1B4]1>C2.<A+4"
 6838 DATA #2,"{[1B]1>DF+}{<B>DF+}{<[1B]1>D+F+}{<B>D+F+}{<[1B]1>EG}{<[1B]1>EG}{<[1B]1>EG}{<[1B]1>EG<}"
 6839 DATA #3,"B1&B4>E4[1G4]1]1E4[1"
 6840 DATA #4,"B1&B4>E4[2G4]2]2E4[2"
 6841 DATA #5,"B1&B4>E4[2G4]2]2E4[2"
 6842 DATA #6,"{[1B]1>DF+}{<B>DF+}{<[1B]1>D+F+}{<B>D+F+}{<[1B]1>EG}{<[1B]1>EG}{<[1B]1>EG}{<[1B]1>EG<}"
 6843 DATA ------------------------------------------
 6844 DATA #1,"B2.[1B4]1>C2.<A+4"
 6845 DATA #2,"{[1B]1>D+F+}{<[1B]1>D+F+}{<[1B]1>D+F+}{<[1B]1>D+F+}{<[1B]1>EG}{<[1B]1>EG}{<[1B]1>EG}{<[1B]1>EG<}"
 6846 DATA #3,"<B1&B4>E4[1G4]1]1E4[1"
 6847 DATA #4,"<B1&B4>E4[2G4]2]2E4[2"
 6848 DATA #5,"<B1&B4>E4[2G4]2]2E4[2"
 6849 DATA #6,"{[1B]1>D+F+}{<[1B]1>D+F+}{<[1B]1>D+F+}{<[1B]1>D+F+}{<[1B]1>EG}{<[1B]1>EG}{<[1B]1>EG}{<[1B]1>EG<}"
 6850 DATA ------------------------------------------
 6851 DATA #1,"B2[1B2"
 6852 DATA #2,"{[1B]1>D+F+}{<[1B]1>D+F+}{<[1B]1>DE+}{<[1B]1>DE+<}"
 6853 DATA #3,"<B2G+2"
 6854 DATA #4,"<B2G+2"
 6855 DATA #5,"<B2G+2"
 6856 DATA #6,"{[1B]1>D+F+}{<[1B]1>D+F+}{<[1B]1>DE+}{<[1B]1>DE+<}"
 6857 DATA ------------------------------------------
 6858 DATA #1,"B2]1A2"
 6859 DATA #2,"{[1B]1>C+G+}{<[1B]1>C+G+}{<[1A]1>C+F+}{<[1A]1>C+F+<}"
 6860 DATA #3,"E+2]1F+2[1"
 6861 DATA #4,"E+2]2F+2[2"
 6862 DATA #5,"E+2]2F+2[2"
 6863 DATA #6,"{[1B]1>C+G+}{<[1B]1>C+G+}{<[1A]1>C+F+}{<[1A]1>C+F+<}"
 6864 DATA ------------------------------------------
 6865 DATA #1,"G2F+2"
 6866 DATA #2,"{[1G]1B>D}{<[1G]1B>D}{<[1F+]1A>D+}{<[1F+]1A>D+<}"
 6867 DATA #3,"B2>[1C2]1"
 6868 DATA #4,"B2[2>C2]2"
 6869 DATA #5,"B2[2>C2]2"
 6870 DATA #6,"{[1G]1B>D}{<[1G]1B>D}{<[1F+]1A>D+}{<[1F+]1A>D+<}"
 6871 DATA ------------------------------------------
 6872 DATA #1,"C+2[1C+4C+4]1<"
 6873 DATA #2,"{[1C+]1F+A}{[1C+]1F+A}{[1C+]1F+G+}{[1C+]1E+G+}"
 6874 DATA #3,"<C+2C+2"
 6875 DATA #4,"C+2C+2"
 6876 DATA #5,"C+2C+2"
 6877 DATA #6,"{[1C+]1F+A}{[1C+]1F+A}{[1C+]1F+G+}{[1C+]1E+G+}"
 6878 DATA ------------------------------------------
 6879 DATA #1,"F+4[1R2>>C+8.C+16"
 6880 DATA #2,"{[1F+]1A>C+}{<A>C+F+}{C+F+A}{C+F+A}"
 6881 DATA #3,"F+1"
 6882 DATA #4,"C+1"
 6883 DATA #5,"<F+1"
 6884 DATA #6,"{[1F+]1A>C+}{<A>C+F+}{C+F+A}{C+F+A}"
 6885 DATA ------------------------------------------
 6886 DATA #1,"C+2.C+8.C+16"
 6887 DATA #2,"{[1C+]1G+B}{[1C+]1G+B}{[1C+]1G+B}{[1C+]1G+B}"
 6888 DATA #3,">E+1"
 6889 DATA #4,">C+1"
 6890 DATA #5,">E+1"
 6891 DATA #6,"{[1C+]1G+B}{[1C+]1G+B}{[1C+]1G+B}{[1C+]1G+B}"
 6892 DATA ------------------------------------------
 6893 DATA #1,"C+2]1C4C+4"
 6894 DATA #2,"{[1C+]1F+A}{[1C+]1F+A}{[1C]1F+A}{[1C+]1F+A}"
 6895 DATA #3,"F+2]1D+4C+4[1"
 6896 DATA #4,"<F+2]2D+4C+4[2"
 6897 DATA #5,"F+2]2D+4C+4[2"
 6898 DATA #6,"{[1C+]1F+A}{[1C+]1F+A}{[1C]1F+A}{[1C+]1F+A}"
 6899 DATA ------------------------------------------
 6900 DATA #1,"D+2.[1D+4]1"
 6901 DATA #2,"{[1D+]1F+G+}{[1D+]1F+G+}{[1D+]1F+G+}{[1D+]1F+G+}"
 6902 DATA #3,"C2.C4"
 6903 DATA #4,"G+2.G+4]2"
 6904 DATA #5,"C2.C4]2"
 6905 DATA #6,"{[1D+]1F+G+}{[1D+]1F+G+}{[1D+]1F+G+}{[1D+]1F+G+}"
 6906 DATA ------------------------------------------
 6907 DATA #1,"E2D+4C+4"
 6908 DATA #2,"{[1E]1G+>C+}{<[1E]1G+>C+}{<[1D+]1F+A}{[1C+]1EA+}"
 6909 DATA #3,"]1C+2[1<F+4]1G4[1"
 6910 DATA #4,"G+2[2<F+4]2G4[2"
 6911 DATA #5,"C+2[2<F+4]2G4[2"
 6912 DATA #6,"{[1E]1G+>C+}{<[1E]1G+>C+}{<[1D+]1F+A}{[1C+]1EA+}"
 6913 DATA ------------------------------------------
 6914 DATA #1,"C4[1<G+4]1A4F+4[1"
 6915 DATA #2,"{>[1C]1<CD+}{[1G+]1CD+}{[1A]1CD+}{[1F+]1CD+}"
 6916 DATA #3,"G+1"
 6917 DATA #4,"G+1"
 6918 DATA #5,"G+1"
 6919 DATA #6,"{>[1C]1<CD+}{[1G+]1CD+}{[1A]1CD+}{[1F+]1CD+}"
 6920 DATA ------------------------------------------
 6921 DATA #1,"R4<G+4A4]1F+4[1"
 6922 DATA #2,"{RCD+}{<[1G+]1>CD+}{<[1A]1>CD+}{<[1F+]1>CD+<}"
 6923 DATA #3,"G+1"
 6924 DATA #4,"G+1"
 6925 DATA #5,"G+1"
 6926 DATA #6,"{RCD+}{<[1G+]1>CD+}{<[1A]1>CD+}{<[1F+]1>CD+<}"
 6927 DATA ------------------------------------------
 6928 DATA #1,"R4>>C+4[1E4]1C+4[1"
 6929 DATA #2,"{[1E]1>EG+}{>[1C+]1<EG+}{>[1E]1<EG+}{>[1C+]1<EG+<}"
 6930 DATA #3,"G+1"
 6931 DATA #4,"G+1"
 6932 DATA #5,"G+1"
 6933 DATA #6,"{[1E]1>EG+}{>[1C+]1<EG+}{>[1E]1<EG+}{>[1C+]1<EG+<}"
 6934 DATA ------------------------------------------
 6935 DATA #1,"R4<C+4[1E4]1C+4<"
 6936 DATA #2,"{R[1E]1G+}{>C+<EG+}{>E<EG+}{>C+<EG+}"
 6937 DATA #3,"G+1"
 6938 DATA #4,"G+1"
 6939 DATA #5,"G+1"
 6940 DATA #6,"{R[1E]1G+}{>C+<EG+}{>E<EG+}{>C+<EG+}"
 6941 DATA ------------------------------------------
 6942 DATA #1,"R1"
 6943 DATA #2,"{[1D+]1AF+}{>C<A>D+}{CF+D+}{AF+>C<<}"
 6944 DATA #3,"G+1"
 6945 DATA #4,"G+1"
 6946 DATA #5,"G+1"
 6947 DATA #6,"{[1D+]1AF+}{>C<A>D+}{CF+D+}{AF+>C<<}"
 6948 DATA ------------------------------------------
 6949 DATA #1,"R1"
 6950 DATA #2,"{[1E]1>C+<G+}{>EC+G+}{E>C+<G+}{>EC+<G+}"
 6951 DATA #3,"G+1"
 6952 DATA #4,"G+1"
 6953 DATA #5,"G+1"
 6954 DATA #6,"{[1E]1>C+<G+}{>EC+G+}{E>C+<G+}{>EC+<G+}"
 6955 DATA ------------------------------------------
 6956 DATA #1,"R1"
 6957 DATA #2,"{[1C+]1GE}{A+G>C+}{<A+>EC+}{GEA+<[1}"
 6958 DATA #3,"G+1"
 6959 DATA #4,"G+1"
 6960 DATA #5,"G+1"
 6961 DATA #6,"{[1C+]1GE}{A+G>C+}{<A+>EC+}{GEA+<[1}"
 6962 DATA ------------------------------------------
 6963 DATA #1,"R1R1R2A12D+6C+4"
 6964 DATA #2,"{F+]1>C<A}{>D+CF+}{D+AF+}{>C<A>D+}{[1C]1<F+A}{D+F+C}{D+<A>C}{<F+AD+}{[1F+]1CD+}{<A>C<F+}{AD+F+}{C+F+A}"
 6965 DATA #3,"G+1&G+1&G+1"
 6966 DATA #4,"G+1&G+1&G+1"
 6967 DATA #5,"G+1&G+1&G+1"
 6968 DATA #6,"{F+]1>C<A}{>D+CF+}{D+AF+}{>C<A>D+}{[1C]1<F+A}{D+F+C}{D+<A>C}{<F+AD+}{[1F+]1CD+}{<A>C<F+}{AD+F+}{C+F+A}"
 6969 DATA ------------------------------------------
 6970 DATA #1,"C2D+4]1C+4[1"
 6971 DATA #2,"{[1C]1F+G+}{AG+F+}{D+F+A}{C+F+A}"
 6972 DATA #3,"G+1"
 6973 DATA #4,"G+1"
 6974 DATA #5,"G+1"
 6975 DATA #6,"{[1C]1F+G+}{AG+F+}{D+F+A}{C+F+A}"
 6976 DATA ------------------------------------------
 6977 DATA #1,"C2D4]1C+4[1"
 6978 DATA #2,"{[1C]1F+G+}{AG+F+}{DF+A}{C+F+A}"
 6979 DATA #3,"G+1"
 6980 DATA #4,"G+1"
 6981 DATA #5,"G+1"
 6982 DATA #6,"{[1C]1F+G+}{AG+F+}{DF+A}{C+F+A}"
 6983 DATA ------------------------------------------
 6984 DATA #1,"C2R2"
 6985 DATA #2,"{[1C]1F+G+}{AG+F+}{[1C+]1E>C+}{<C+E>C+<}"
 6986 DATA #3,"G+2]1A2"
 6987 DATA #4,"G+2]2A2"
 6988 DATA #5,"G+2]2A2"
 6989 DATA #6,"{[1C]1F+G+}{AG+F+}{[1C+]1E>C+}{<C+E>C+<}"
 6990 DATA ------------------------------------------
 6991 DATA #1,"R1"
 6992 DATA #2,"{[1D+]1A>C+}{<D+A>C+}{<[1D+]1G+>C}{<D+F+>C<}"
 6993 DATA #3,"F+2G+2[1"
 6994 DATA #4,"F+2G+2[2"
 6995 DATA #5,"F+2G+2[2"
 6996 DATA #6,"{[1D+]1A>C+}{<D+A>C+}{<[1D+]1G+>C}{<D+F+>C<}"
 6997 DATA ------------------------------------------
 6998 DATA #1,"R2.>G+8.G+16"
 6999 DATA #2,"{[1E]1G+>C+}{<[1G+]1>C+E}{<[1G+]1>C+E}{<[1G+]1>C+E<}"
 7000 DATA #3,">C+1"
 7001 DATA #4,">G+1"
 7002 DATA #5,">C+1"
 7003 DATA #6,"{[1E]1G+>C+}{<[1G+]1>C+E}{<[1G+]1>C+E}{<[1G+]1>C+E<}"
 7004 DATA ------------------------------------------
 7005 DATA #1,"G+2.G+8.G+16"
 7006 DATA #2,"{[1G+]1>D+F+}{<[1G+]1>D+F+}{<[1G+]1>D+F+}{<[1G+]1>D+F+<}"
 7007 DATA #3,"C1"
 7008 DATA #4,"G+1"
 7009 DATA #5,"C1"
 7010 DATA #6,"{[1G+]1>D+F+}{<[1G+]1>D+F+}{<[1G+]1>D+F+}{<[1G+]1>D+F+<}"
 7011 DATA ------------------------------------------
 7012 DATA #1,"G+2]1A2"
 7013 DATA #2,"{[1G+]1>C+E}{<[1G+]1>C+E}{<[1A]1>C+F+}{<[1A]1>C+F+<}"
 7014 DATA #3,"C+2]1<F+2[1"
 7015 DATA #4,"C+2]2<F+2[2"
 7016 DATA #5,"C+2]2<F+2[2"
 7017 DATA #6,"{[1G+]1>C+E}{<[1G+]1>C+E}{<[1A]1>C+F+}{<[1A]1>C+F+<}"
 7018 DATA ------------------------------------------
 7019 DATA #1,"G+2F+4B4"
 7020 DATA #2,"{[1G+]1B>E}{<[1G+]1B>E}{<[1A]1B>D+}{<[1A]1B>D+<}"
 7021 DATA #3,"B2[1B2]1"
 7022 DATA #4,"B2[2B2"
 7023 DATA #5,"B2[2B2"
 7024 DATA #6,"{[1G+]1B>E}{<[1G+]1B>E}{<[1A]1B>D+}{<[1A]1B>D+<}"
 7025 DATA ------------------------------------------
 7026 DATA #1,"E4[1R2B8.B16"
 7027 DATA #2,"{[1G+]1B>E}{<[1B]1>EG+}{<[1B]1>EG+}{<[1B]1>EG+<}"
 7028 DATA #3,">E1[1"
 7029 DATA #4,"]2>E1"
 7030 DATA #5,"]2>E1"
 7031 DATA #6,"{[1G+]1B>E}{<[1B]1>EG+}{<[1B]1>EG+}{<[1B]1>EG+<}"
 7032 DATA ------------------------------------------
 7033 DATA #1,"B2.B8.B16"
 7034 DATA #2,"{[1B]1>F+A}{<B>F+A}{<B>F+A}{<B>F+A<}"
 7035 DATA #3,"D+1"
 7036 DATA #4,"D+1"
 7037 DATA #5,"D+1"
 7038 DATA #6,"{[1B]1>F+A}{<B>F+A}{<B>F+A}{<B>F+A<}"
 7039 DATA ------------------------------------------
 7040 DATA #1,"B2]1>C4C+4"
 7041 DATA #2,"{[1B]1>EG+}{<[1B]1>EG+}{[1C]1F+G+}{[1C+]1EG+}"
 7042 DATA #3,"E2]1D+4C+4"
 7043 DATA #4,"E2]2D+4C+4"
 7044 DATA #5,"E2]2D+4C+4"
 7045 DATA #6,"{[1B]1>EG+}{<[1B]1>EG+}{[1C]1F+G+}{[1C+]1EG+}"
 7046 DATA ------------------------------------------
 7047 DATA #1,"D+2E2"
 7048 DATA #2,"{[1D+]1F+G+}{[1D+]1F+G+}{[1E]1G+>C+}{<[1E]1G+>C+<}"
 7049 DATA #3,"C2C+2[1"
 7050 DATA #4,"G+2G+2[2"
 7051 DATA #5,"C2C+2[2"
 7052 DATA #6,"{[1D+]1F+G+}{[1D+]1F+G+}{[1E]1G+>C+}{<[1E]1G+>C+<}"
 7053 DATA ------------------------------------------
 7054 DATA #1,"D2C2"
 7055 DATA #2,"{[1D]1F+A}{[1D]1F+A}{[1C]1F+G+}{[1C]1F+G+}"
 7056 DATA #3,"<F+2]1G+2[1"
 7057 DATA #4,"<F+2]2G+2[2"
 7058 DATA #5,"<F+2]2G+2[2"
 7059 DATA #6,"{[1D]1F+A}{[1D]1F+A}{[1C]1F+G+}{[1C]1F+G+}"
 7060 DATA ------------------------------------------
 7061 DATA #1,"C+2.[1C+4]1D2.C4"
 7062 DATA #2,"{[1C+]1EG+}{[1C+]1EG+}{[1C+]1E+G+}{[1C+]1E+G+}{[1C+]1F+A}{[1C+]1F+A}{[1C+]1F+A}{[1C+]1F+A}"
 7063 DATA #3,">C+1&C+4F+4[1A4]1]1F+4[1"
 7064 DATA #4,">C+1&C+4F+4[2A4]2]2F+4[2"
 7065 DATA #5,">C+1&C+4F+4[2A4]2]2F+4[2"
 7066 DATA #6,"{[1C+]1EG+}{[1C+]1EG+}{[1C+]1E+G+}{[1C+]1E+G+}{[1C+]1F+A}{[1C+]1F+A}{[1C+]1F+A}{[1C+]1F+A}"
 7067 DATA ------------------------------------------
 7068 DATA #1,"C+2.[1C+4]1D2.C4"
 7069 DATA #2,"{[1C+]1E+G+}{C+E+G+}{C+E+G+}{C+E+G+}{[1C+]1F+A}{[1C+]1F+A}{[1C+]1F+A}{[1C+]1F+A}"
 7070 DATA #3,"C+1&C+4F+4[1A4]1]1F+4[1"
 7071 DATA #4,"C+1&C+4F+4[2A4]2]2F+4[2"
 7072 DATA #5,"C+1&C+4F+4[2A4]2]2F+4[2"
 7073 DATA #6,"{[1C+]1E+G+}{C+E+G+}{C+E+G+}{C+E+G+}{[1C+]1F+A}{[1C+]1F+A}{[1C+]1F+A}{[1C+]1F+A}"
 7074 DATA ------------------------------------------
 7075 DATA #1,"C+2[1C+2]1<"
 7076 DATA #2,"{[1C+]1E+G+}{C+E+G+}{[1C+]1F+A}{C+F+A}"
 7077 DATA #3,"C+2<F+2]1"
 7078 DATA #4,"C+2<F+2]2"
 7079 DATA #5,"C+2<F+2]2"
 7080 DATA #6,"{[1C+]1E+G+}{C+E+G+}{[1C+]1F+A}{C+F+A}"
 7081 DATA ------------------------------------------
 7082 DATA #1,"B2.[1B4]1"
 7083 DATA #2,"{<[1B]1>F+A}{<B>F+A}{<B>F+A}{<[1B>EG+<]1}"
 7084 DATA #3,">D+2.[1E4]1"
 7085 DATA #4,">D+2.[2E4]2"
 7086 DATA #5,">D+2.[2E4]2"
 7087 DATA #6,"{<[1B]1>F+A}{<B>F+A}{<B>F+A}{<[1B>EG+<]1}"
 7088 DATA ------------------------------------------
 7089 DATA #1,"A4A4G+4G+4[1"
 7090 DATA #2,"{[1A]1>EG+}{<[1A]1>D+F+}{<[1G+]1>D+F+}{<[1G+]1>C+E<}"
 7091 DATA #3,"C+4D+4C4C+4[1"
 7092 DATA #4,"C+4D+4C4C+4"
 7093 DATA #5,"C+4D+4C4C+4"
 7094 DATA #6,"{[1A]1>EG+}{<[1A]1>D+F+}{<[1G+]1>D+F+}{<[1G+]1>C+E<}"
 7095 DATA ------------------------------------------
 7096 DATA #1,"F+2]1G+4A4[1"
 7097 DATA #2,"{[1F+]1>C+D+}{<[1F+]1>C+D+}{<[1G+]1>C+D+}{<[1A]1>C+D+<}"
 7098 DATA #3,"<A2]1G+4F+4[1"
 7099 DATA #4,"[2<A2]2G+4F+4[2"
 7100 DATA #5,"[2<A2]2G+4F+4[2"
 7101 DATA #6,"{[1F+]1>C+D+}{<[1F+]1>C+D+}{<[1G+]1>C+D+}{<[1A]1>C+D+<}"
 7102 DATA ------------------------------------------
 7103 DATA #1,"G+2G+2"
 7104 DATA #2,"{[1G+]1>C+E}{<G+>C+E}{<[1F+]1>CD+}{<F+>CD+<}"
 7105 DATA #3,"G+2G+2"
 7106 DATA #4,"G+2G+2"
 7107 DATA #5,"G+2G+2"
 7108 DATA #6,"{[1G+]1>C+E}{<G+>C+E}{<[1F+]1>CD+}{<F+>CD+<}"
 7109 DATA ------------------------------------------
 7110 DATA #1,"C+4R2."
 7111 DATA #2,"{[1E]1G+>C+}{<[1G+]1>C+E}{<[1G+]1>C+E}{<[1G+]1>C+E<}"
 7112 DATA #3,"G+2.G+8.G+16"
 7113 DATA #4,">C+1"
 7114 DATA #5,">C+1"
 7115 DATA #6,"{[1E]1G+>C+}{<[1G+]1>C+E}{<[1G+]1>C+E}{<[1G+]1>C+E<}"
 7116 DATA ------------------------------------------
 7117 DATA #1,"R1"
 7118 DATA #2,"{[1G+]1>D+F+}{<[1G+]1>D+F+}{<[1G+]1>D+F+}{<[1G+]1>D+F+<}"
 7119 DATA #3,"G+2.G+8.G+16"
 7120 DATA #4,"C1"
 7121 DATA #5,"C1"
 7122 DATA #6,"{[1G+]1>D+F+}{<[1G+]1>D+F+}{<[1G+]1>D+F+}{<[1G+]1>D+F+<}"
 7123 DATA ------------------------------------------
 7124 DATA #1,"R1"
 7125 DATA #2,"{[1G+]1>EC+}{[1G+]1E>C+}{<[1G+]1>EC+}{[1G+]1EC+}"
 7126 DATA #3,"G+2.[1G+8.G+16"
 7127 DATA #4,"C+1"
 7128 DATA #5,"C+1"
 7129 DATA #6,"{[1G+]1>EC+}{[1G+]1E>C+}{<[1G+]1>EC+}{[1G+]1EC+}"
 7130 DATA ------------------------------------------
 7131 DATA #1,"R2.C4]1"
 7132 DATA #2,"{[1C]1D+<A}{>[1C]1<F+A}{[1D+]1F+<A}{RG+F+}"
 7133 DATA #3,"G+2.]1G+8.G+16"
 7134 DATA #4,"<G+1"
 7135 DATA #5,"<G+1"
 7136 DATA #6,"{[1C]1D+<A}{>[1C]1<F+A}{[1D+]1F+<A}{RG+F+}"
 7137 DATA ------------------------------------------
 7138 DATA #1,"C+4[1R2."
 7139 DATA #2,"{E>EC+}{G+E>C+}{<G+>EC+}{G+EC+}"
 7140 DATA #3,"G+2.]1G+8.G+16"
 7141 DATA #4,">C+1"
 7142 DATA #5,">C+1"
 7143 DATA #6,"{E>EC+}{G+E>C+}{<G+>EC+}{G+EC+}"
 7144 DATA ------------------------------------------
 7145 DATA #1,"R2.C4]1"
 7146 DATA #2,"{[1C]1D+<A}{>[1C]1<F+A}{[1D+]1F+<A}{RG+F+}"
 7147 DATA #3,"G+2.]1G+8.G+16"
 7148 DATA #4,"<G+1"
 7149 DATA #5,"<G+1"
 7150 DATA #6,"{[1C]1D+<A}{>[1C]1<F+A}{[1D+]1F+<A}{RG+F+}"
 7151 DATA ------------------------------------------
 7152 DATA #1,"C+4[1R4<C+2T70<G+2R2"
 7153 DATA #2,"{[1E]1G+>C+}{EC+G+}{R[1E]1G+}{>C+<G+E}{R[1C+]1E}{G+EC+}{<[1G+]1>C+<G+}{EG+E}"
 7154 DATA #3,"[2G+2R2R1"
 7155 DATA #4,">C+1&C+1"
 7156 DATA #5,">C+1&C+1"
 7157 DATA #6,"{[1E]1G+>C+}{EC+G+}{R[1E]1G+}{>C+<G+E}{R[1C+]1E}{G+EC+}{<[1G+]1>C+<G+}{EG+E}"
 7158 DATA ------------------------------------------
 7159 DATA #1,"T68R2>V10E2"
 7160 DATA #2,"R2>>V10C+2"
 7161 DATA #3,"C+2>V10G+2"
 7162 DATA #4,"R2>>V12C+2"
 7163 DATA #5,"R2V12G+2"
 7164 DATA #6,"R2V12C+2"
 7165 DATA ------------------------------------------
 7166 DATA #1,"T66V12E1"
 7167 DATA #2,"V12C+1"
 7168 DATA #3,"V12G+1"
 7169 DATA #4,"V14C+1"
 7170 DATA #5,"V14G+1"
 7171 DATA #6,"V14C+1"
 7172 DATA ------------------------------------------
 7173 DATA ENDSONG
10000 '---------------- Copyright ﾋｮｳｼﾞ
10010 *DISP_COPYRIGHT
10020   DC_TIME=DC_TIME+1
10030   IF (DC_TIME AND &HF) <> 0 THEN RETURN
10040   LOCATE 0,25:COLOR 4:PRINT MID$(Q$,QCUT,37);
10050   QCUT=QCUT+1:DC_TIME=0
10060   IF (QCUT=(LEN(PROG$)+100)) THEN QCUT=1
10070   RETURN

