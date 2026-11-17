LOAD"COM:S_G_ARTS.B"
 1000 ' GAME BASIC for SEGASATURN Sound Sample Program Ver 1.1
 1001 ' [ S_G_ARTS.B ]
 1002 ' Programmed by Naozumi Honma (nao)
 1003 '               Kanayama Motoyuki (motos)
 1004 '
 1005 '
 1006   SCREEN 0: SKCLOSE         :'Initialize screen, Close software keyboard
 1007   CLEAR 10,1360:IF PEEK(0,3)<>78 THEN KLOAD ON:CLEAR 10,1360:POKE 0,0,56:POKE 0,1,1:POKE 0,2,1:POKE 0,3,78:POKE 0,4,1
 1008   WIDTH 1,1,38,26:COLOR ,RGB(31,31,31):COLOROFS ON,0:COLOROFS(-255,-255,-255):VSYNC:OFS=255
 1009 '
 1010   NUM_OF_MSTR=17             :'<<< MENU ｺｳﾓｸ ﾉ ｶｽﾞ >>>
 1011   PROG$="***** Sound System Programed by Naozumi Honma (nao) / Bits Laboratory ***** BASIC Main System Programed by Motoyuki Kanayama (motos) / Bits Laboratory *****"
 1012   Q$=SPACE$(40)+PROG$+SPACE$(300):QCUT=1
 1013   GOTO *START_THIS_PROGRAM
 1014 '
 1015 '---------------- MENU DATA
 1016 *MENU_STR
 1017   DATA "GAME ARTS サウンド･サンプル･メニュー "
 1018   DATA " 1:解説                              "
 1019   DATA " 2:シルフィード          (Hi-Speed版)"
 1020   DATA " 3:ゼリアード            (Hi-Speed版)"
 1021   DATA " 4:ヴェイグス            (Hi-Speed版)"
 1022   DATA " 5:ファイヤー ホーク     (Hi-Speed版)"
 1023   DATA " 6:アリシア ドラグーン   (Hi-Speed版)"
 1024   DATA " 7:LUNAR  Version A      (Hi-Speed版)"
 1025   DATA " 8:LUNAR  Version B      (Hi-Speed版)"
 1026   DATA " 9:LUNAR  TSU BA SA      (Hi-Speed版)"
 1027   DATA "10:シルフィード              (TARG版)"
 1028   DATA "11:ゼリアード                (TARG版)"
 1029   DATA "12:ヴェイグス                (TARG版)"
 1030   DATA "13:ファイヤー ホーク         (TARG版)"
 1031   DATA "14:アリシア ドラグーン       (TARG版)"
 1032   DATA "15:LUNAR  Version A          (TARG版)"
 1033   DATA "16:LUNAR  Version B          (TARG版)"
 1034   DATA "17:LUNAR  TSU BA SA          (TARG版)"
 1035 '
 1036 '---------------- Exit Program
 1037 *EXIT_THIS_PROGRAM
 1038   OBJ CLEAR:GOSUB *FADEOUT:INTERVAL (0) OFF:INTERVAL (1) OFF:SCREEN 0:LOCATE 5,0:COLOR 7:PRINT "Loading S_TUTOR.B" :LOAD"CD:S_TUTOR",R
 1039   END
 1040 '
 1041 '---------------- Start Program
 1042 *START_THIS_PROGRAM
 1043   GOSUB *INIT_SYS
 1044 '
 1045 '================ Main Loop
 1046 *PAD_WATCH
 1047   TRIGGA=0
 1048   *PAD_W2:IF TRIGGA THEN KEY$="":KEY=0:GOTO *PAD_TRIGGA
 1049     KEY$=INKEY$:IF KEY$="" THEN *PAD_W2 ELSE KEY=ASC(KEY$)
 1050   *PAD_TRIGGA
 1051     WTIME=0
 1052     IF KEY=KEY_DOWN  OR KEY=KEY_D2 OR (TRIGGA AND @PAD_DOWN) THEN GOSUB *MOVE_DOWN:GOTO *PAD_WATCH
 1053     IF KEY=KEY_UP    OR KEY=KEY_U2 OR (TRIGGA AND @PAD_UP)   THEN GOSUB *MOVE_UP:  GOTO *PAD_WATCH
 1054     IF KEY=KEY_ENTER OR (TRIGGA AND (@PAD_START OR @PAD_C))  THEN *PLAY_GO
 1055     IF KEY=KEY_ESC   OR (TRIGGA AND (@PAD_Y     OR @PAD_B))  THEN *EXIT_THIS_PROGRAM
 1056     GOTO *PAD_WATCH
 1057 '
 1058 '================
 1059 *MOVE_DOWN
 1060   IF CNUM < NUM_OF_MSTR THEN CNUM=CNUM+1
 1061   IF (CNUM > 4) AND (CNUM <= (NUM_OF_MSTR - 3)) THEN MTOP=MTOP+1
 1062   GOSUB *DISPLAY_MENU
 1063   RETURN
 1064 '
 1065 '----------------
 1066 *MOVE_UP
 1067   IF CNUM > 1 THEN CNUM=CNUM-1
 1068   IF (CNUM > 3) AND (CNUM < (NUM_OF_MSTR - 3)) THEN MTOP=MTOP-1
 1069   GOSUB *DISPLAY_MENU
 1070   RETURN
 1071 '
 1072 '----------------
 1073 *DISPLAY_MENU
 1074   KPRINT (10,20),MSTR$(0),,,RGB(20,0,20)    :'ﾀｲﾄﾙﾋｮｳｼﾞ
 1075   LINE(10,164)-(307,164),RGB(31,31,0)
 1076   KPRINT (10,166),"↑↓";,RGB(31,22,22):KPRINT FIX "(ﾎｳｺｳ ﾎﾞﾀﾝ )--- ";,RGB(21,21,10):KPRINT FIX "Move Cursor",RGB(0,31,20)
 1077   KPRINT (10,182-8),FIX "  START / Cﾎﾞﾀﾝ";,RGB(31,22,22):KPRINT FIX " --- ";,RGB(21,21,10):KPRINT FIX "LOAD & EXEC.",RGB(0,31,20)
 1078   KPRINT (10,198-16),FIX "          Bﾎﾞﾀﾝ";,RGB(31,22,22):KPRINT FIX " --- ";,RGB(21,21,10):KPRINT FIX "RETURN Main Menu",RGB(0,31,20)
 1079   MDY=38
 1080   FOR I=MTOP TO MTOP+6
 1081     IF I=CNUM THEN
 1082       KPRINT (10,MDY),MSTR$(I),RGB(31,31,31),,RGB(0,20,20)
 1083     ELSE
 1084       KPRINT (10,MDY),MSTR$(I),RGB(31,31,31)
 1085     ENDIF
 1086     MDY=MDY+18
 1087   NEXT
 1088   RETURN
 1089 '
 1090 '================ Subroutines
 1091 *INIT_SYS
 1092   MTOP=PEEK(0,4):CNUM=PEEK(0,2):EMNUM=-1
 1093   DIM MSTR$(NUM_OF_MSTR)
 1094   RESTORE *MENU_STR:FOR I=0 TO NUM_OF_MSTR:READ MSTR$(I):NEXT
 1095 '
 1096   PAD_ABCXYZSTART = @PAD_A+@PAD_B+@PAD_C+@PAD_START+@PAD_X+@PAD_Y+@PAD_Z
 1097   PAD_UDLR  = @PAD_RIGHT+@PAD_LEFT+@PAD_DOWN+@PAD_UP+@PAD_L+@PAD_R
 1098   KEY_DOWN  = 31:  KEY_D2=ASC("X")-64
 1099   KEY_UP    = 30:  KEY_U2=ASC("E")-64
 1100   KEY_ENTER = 13: KEY_ESC = 27
 1101 '
 1102   SCREEN 0:WIDTH 1,1,38,26
 1103   INITIAL_TOUCH=20:AFTER_TOUCH=3
 1104   ON INTERVAL (0) GOSUB *INT_COUNT: INTERVAL (0) ON,1
 1105   ON INTERVAL (1) GOSUB *DISP_COPYRIGHT: INTERVAL (1) ON,1
 1106 *CLEAR_INKEY: IF INKEY$<>"" THEN *CLEAR_INKEY
 1107   TRIGGA=PAD(0,2) :' Clear trigga
 1108   GOSUB *DISPLAY_MENU:GOSUB *FADEIN
 1109   RETURN
 1110 '
 1111 '----------------
 1112 *INT_COUNT:' Make repeat trigga of PAD ULDR
 1113   IF PAD(0)=52 THEN *INT_COUNT_RET: 'Ignore keyboard pad
 1114   TRIGGA=TRIGGA OR (PAD(0,2) AND PAD_ABCXYZSTART): 'Update A,B,C,START buttons
 1115   TESTBTN=PAD(0,1):IF (TESTBTN AND PAD_UDLR) = 0 THEN REPEAT_COUNT=0: GOTO *INT_COUNT_RET
 1116   IF TESTBTNL<>TESTBTN THEN TESTBTNL=TESTBTN: REPEAT_COUNT=0
 1117   IF REPEAT_COUNT=0 THEN REPEAT_COUNT=INITIAL_TOUCH: TRIGGA=TESTBTN: GOTO *INT_COUNT_RET
 1118   REPEAT_COUNT=REPEAT_COUNT-1: IF REPEAT_COUNT <= 0 THEN REPEAT_COUNT=AFTER_TOUCH: TRIGGA=TESTBTN
 1119 *INT_COUNT_RET
 1120   SKCLOSE
 1121   RETURN
 1122 '
 1123 '---------------- SCREEN Fade Out
 1124 *FADEOUT
 1125   COLOROFS ON,0:IF OFS=255 THEN RETURN
 1126   FOR OFS=0 TO 255 STEP 32
 1127     COLOROFS(-OFS,-OFS,-OFS)
 1128     VSYNC
 1129   NEXT OFS
 1130   OFS=255
 1131   COLOROFS(-255,-255,-255)
 1132   CLS 0
 1133   VSYNC
 1134   RETURN
 1135 '
 1136 '================ Start Sound Sample Program
 1137 *PLAY_GO:INTERVAL (0) OFF:INTERVAL (1) OFF:SCREEN 0:WIDTH 1,1,38,26:POKE 0,2,CNUM:POKE 0,4,MTOP
 1138 IF CNUM=2 THEN POKE 0,5,1:PRINT "Loading S_SILPH.B" :GOSUB *FADEOUT:LOAD"CD:S_SILPH",R
 1139 IF CNUM=3 THEN POKE 0,5,1:PRINT "Loading S_ZELIAR.B":GOSUB *FADEOUT:LOAD"CD:S_ZELIAR",R
 1140 IF CNUM=4 THEN POKE 0,5,1:PRINT "Loading S_VEIGUS.B":GOSUB *FADEOUT:LOAD"CD:S_VEIGUS",R
 1141 IF CNUM=5 THEN POKE 0,5,1:PRINT "Loading S_F_HAWK.B":GOSUB *FADEOUT:LOAD"CD:S_F_HAWK",R
 1142 IF CNUM=6 THEN POKE 0,5,1:PRINT "Loading S_ALISIA.B":GOSUB *FADEOUT:LOAD"CD:S_ALISIA",R
 1143 IF CNUM=7 THEN POKE 0,5,1:PRINT "Loading S_LUNARA.B":GOSUB *FADEOUT:LOAD"CD:S_LUNARA",R
 1144 IF CNUM=8 THEN POKE 0,5,1:PRINT "Loading S_LUNARB.B":GOSUB *FADEOUT:LOAD"CD:S_LUNARB",R
 1145 IF CNUM=9 THEN POKE 0,5,1:PRINT "Loading S_TUBASA.B":GOSUB *FADEOUT:LOAD"CD:S_TUBASA",R
 1146 IF CNUM=10 THEN POKE 0,5,0:PRINT "Loading S_SILPH.B" :GOSUB *FADEOUT:LOAD"CD:S_SILPH",R
 1147 IF CNUM=11 THEN POKE 0,5,0:PRINT "Loading S_ZELIAR.B":GOSUB *FADEOUT:LOAD"CD:S_ZELIAR",R
 1148 IF CNUM=12 THEN POKE 0,5,0:PRINT "Loading S_VEIGUS.B":GOSUB *FADEOUT:LOAD"CD:S_VEIGUS",R
 1149 IF CNUM=13 THEN POKE 0,5,0:PRINT "Loading S_F_HAWK.B":GOSUB *FADEOUT:LOAD"CD:S_F_HAWK",R
 1150 IF CNUM=14 THEN POKE 0,5,0:PRINT "Loading S_ALISIA.B":GOSUB *FADEOUT:LOAD"CD:S_ALISIA",R
 1151 IF CNUM=15 THEN POKE 0,5,0:PRINT "Loading S_LUNARA.B":GOSUB *FADEOUT:LOAD"CD:S_LUNARA",R
 1152 IF CNUM=16 THEN POKE 0,5,0:PRINT "Loading S_LUNARB.B":GOSUB *FADEOUT:LOAD"CD:S_LUNARB",R
 1153 IF CNUM=17 THEN POKE 0,5,0:PRINT "Loading S_TUBASA.B":GOSUB *FADEOUT:LOAD"CD:S_TUBASA",R
 1154 GOSUB *FADEOUT:CLS 0:INTERVAL (0) ON:INTERVAL (1) ON
 1155 '--------------------
 1156 KPRINT (10,20)
 1157 KPRINT "★Hi-Speed版（曲番号2～9）について。 ",RGB(31,31,0)
 1158 KPRINT "                                     "
 1159 KPRINT "･各サンプルの中で『TARG』によって組み"
 1160 KPRINT " 替えられた音源を､予めCD-ROMに用意し､"
 1161 KPRINT " 組み替え時間を省略したバージョンです｡"
 1162 KPRINT "                                     "
 1163 KPRINT "★TARG版（曲番号10～17）について。   ",RGB(31,31,0)
 1164 KPRINT "                                     "
 1165 KPRINT "･TARG命令で毎回組み替え処理を行ない  "
 1166 KPRINT " ます｡                               "
 1167 KPRINT "       Cﾎﾞﾀﾝ / ENTER -> NEXT         ",,,RGB(0,16,16)
 1168 GOSUB *KEYIN
 1169 KPRINT (10,20)
 1170 KPRINT "SUPER DOGFIGHTER ＳＩＬＰＨＥＥＤ    ",RGB(31,31,0)
 1171 KPRINT "･３Ｄシューティング･ゲーム           ",RGB(0,31,0)
 1172 KPRINT "  1986年12月5日発売                  ",RGB(0,31,0)
 1173 KPRINT "  PC-8801mk2SRｼﾘｰｽﾞ/ FM77/AV / IBM-PC",RGB(0,31,0)
 1174 KPRINT "                                     "
 1175 KPRINT "･オリジナルに近いバージョンと、新しい"
 1176 KPRINT " アレンジ･バージョンを収録。         "
 1177 KPRINT "･オリジナルの雰囲気を壊さないメロディ"
 1178 KPRINT " 展開がファンには嬉しい｡             "
 1179 KPRINT "                                     "
 1180 KPRINT "       Cﾎﾞﾀﾝ / ENTER -> NEXT         ",,,RGB(0,16,16)
 1181 GOSUB *KEYIN
 1182 KPRINT (10,20)
 1183 KPRINT "Ｚｅｌｉａｒｄ                       ",RGB(31,31,0)
 1184 KPRINT "･アクションＲＰＧゲーム              ",RGB(0,31,0)
 1185 KPRINT "  1987年12月19日発売                 ",RGB(0,31,0)
 1186 KPRINT "  PC-8801mk2SRｼﾘｰｽﾞ / X1turbo        ",RGB(0,31,0)
 1187 KPRINT "                                     "
 1188 KPRINT "･88版サウンド･ボード2用に書かれたMML "
 1189 KPRINT " をそのまま移植｡                     "
 1190 KPRINT "･FM音源を一切使わず､標準音色セットの "
 1191 KPRINT " 組み替えのみで再現している｡         "
 1192 KPRINT "                                     "
 1193 KPRINT "       Cﾎﾞﾀﾝ / ENTER -> NEXT         ",,,RGB(0,16,16)
 1194 GOSUB *KEYIN
 1195 KPRINT (10,20)
 1196 KPRINT "TACTICAL GLADIATOR ＶＥＩＧＵＥＳ    ",RGB(31,31,0)
 1197 KPRINT "･横スクロール型アクション･ゲーム     ",RGB(0,31,0)
 1198 KPRINT "  1988年12月16日発売                 ",RGB(0,31,0)
 1199 KPRINT "  PC-8801mk2SRｼﾘｰｽﾞ / PC-Engine      ",RGB(0,31,0)
 1200 KPRINT "                                     "
 1201 KPRINT "･リズム主体のサウンドが特徴。        "
 1202 KPRINT "･本サンプルでは、オープニングのみ再現"
 1203 KPRINT " した。                              "
 1204 KPRINT "･ほとんどFM音源を使用している。      "
 1205 KPRINT "                                     "
 1206 KPRINT "       Cﾎﾞﾀﾝ / ENTER -> NEXT         ",,,RGB(0,16,16)
 1207 GOSUB *KEYIN
 1208 KPRINT (10,20)
 1209 KPRINT "ＦＩＲＥ ＨＡＷＫ （THEXDER 2）      ",RGB(31,31,0)
 1210 KPRINT "･テグザーの続編                      ",RGB(0,31,0)
 1211 KPRINT "  1989年11月2日発売                  ",RGB(0,31,0)
 1212 KPRINT "  PC-8801mk2SRｼﾘｰｽﾞ / MSX2           ",RGB(0,31,0)
 1213 KPRINT "･ボスが出現する直前に、違和感なくボス"
 1214 KPRINT " 曲に切り替わる部分が聴き所。        "
 1215 KPRINT "･ﾊﾟｰｶｯｼｮﾝを含み､88版のFM音源とｻｳﾝﾄﾞﾎﾞ"
 1216 KPRINT " ｰﾄﾞ2の音色をほとんど再現している。  "
 1217 KPRINT "･メニューの｢#/P/O/E」は、同じ音色アレ"
 1218 KPRINT " ンジを使っているものどうし。        "
 1219 KPRINT "       Cﾎﾞﾀﾝ / ENTER -> NEXT         ",,,RGB(0,16,16)
 1220 GOSUB *KEYIN
 1221 KPRINT (10,20)
 1222 KPRINT "アリシア ドラグーン                  ",RGB(31,31,0)
 1223 KPRINT "･テグザーの自動照準を継承したシステム",RGB(0,31,0)
 1224 KPRINT "  1992年4月24日発売                  ",RGB(0,31,0)
 1225 KPRINT "  メガドライブ版                     ",RGB(0,31,0)
 1226 KPRINT "                                     "
 1227 KPRINT "･製品版には入っていない曲も収録されて"
 1228 KPRINT " いる｡"
 1229 KPRINT "･FM音源とPCM音源が､絶妙なバランスで絡"
 1230 KPRINT " み合い､美しいメロディを奏でている部 "
 1231 KPRINT " 分が聴き所｡                         "
 1232 KPRINT "       Cﾎﾞﾀﾝ / ENTER -> NEXT         ",,,RGB(0,16,16)
 1233 GOSUB *KEYIN
 1234 KPRINT (10,20)
 1235 KPRINT "ＬＵＮＡＲ THE SILVER STAR           ",RGB(31,31,0)
 1236 KPRINT "･バージョンＡ                        ",RGB(0,31,0)
 1237 KPRINT "                                     "
 1238 KPRINT "  SEGASATURN版                       ",RGB(0,31,0)
 1239 KPRINT "                                     "
 1240 KPRINT "･自作ゲームのBGMとして利用できるよう "
 1241 KPRINT " に全曲同じ音色並びで作成されている。"
 1242 KPRINT "･更に、先頭30音色は、効果音用の音色を"
 1243 KPRINT " 残してある。                        "
 1244 KPRINT "                                     "
 1245 KPRINT "       Cﾎﾞﾀﾝ / ENTER -> NEXT         ",,,RGB(0,16,16)
 1246 GOSUB *KEYIN
 1247 KPRINT (10,20)
 1248 KPRINT "ＬＵＮＡＲ THE SILVER STAR           ",RGB(31,31,0)
 1249 KPRINT "･バージョンＢ                        ",RGB(0,31,0)
 1250 KPRINT "                                     "
 1251 KPRINT "  SEGASATURN版                       ",RGB(0,31,0)
 1252 KPRINT "                                     "
 1253 KPRINT "･バージョンＡを鑑賞用に全曲音色アレン"
 1254 KPRINT " ジしたもの。                        "
 1255 KPRINT "･曲によって､DSPモードを使い分けており､"
 1256 KPRINT " MMLプログラムとしては、かなり上級の "
 1257 KPRINT " テクニックが使われている。          "
 1258 KPRINT "       Cﾎﾞﾀﾝ / ENTER -> NEXT         ",,,RGB(0,16,16)
 1259 GOSUB *KEYIN
 1260 KPRINT (10,20)
 1261 KPRINT "ＬＵＮＡＲ THE SILVER STAR           ",RGB(31,31,0)
 1262 KPRINT "･TSU BA SA                           ",RGB(0,31,0)
 1263 KPRINT "                                     "
 1264 KPRINT "  SEGASATURN版                       ",RGB(0,31,0)
 1265 KPRINT "                                     "
 1266 KPRINT "･オープニング･テーマのみ抜き出したプ "
 1267 KPRINT " ログラム。                          "
 1268 KPRINT "･｢ON MMLSTAT GOSUB｣命令を使った､カラ "
 1269 KPRINT " オケ用のサンプルになっている｡       "
 1270 KPRINT "                                     "
 1271 KPRINT "       Cﾎﾞﾀﾝ / ENTER -> NEXT         ",,,RGB(0,16,16)
 1272 GOSUB *KEYIN
 1273 GOSUB *DISPLAY_MENU:GOSUB *FADEIN:GOTO *PAD_WATCH
 1274 '------------------------------
 1275 *KEYIN
 1276 GOSUB *FADEIN
 1277 *PAD_WATCH2
 1278   TRIGGA=0
 1279   *PAD_W22:IF TRIGGA THEN KEY$="":KEY=0:GOTO *PAD_TRIGGA2
 1280     KEY$=INKEY$:IF KEY$="" THEN *PAD_W22 ELSE KEY=ASC(KEY$)
 1281   *PAD_TRIGGA2
 1282     WTIME=0
 1283     IF KEY=KEY_ENTER OR (TRIGGA AND (@PAD_START OR @PAD_C))  THEN GOSUB *FADEOUT:CLS 0:RETURN
 1284     IF KEY=KEY_ESC   OR (TRIGGA AND (@PAD_Y     OR @PAD_B))  THEN *EXIT_THIS_PROGRAM
 1285     GOTO *PAD_WATCH2
 1286 '
 1287 '------------------------------
 1288 *FADEIN
 1289 FOR OFS=255 TO 0 STEP -32
 1290   COLOROFS(-OFS,-OFS,-OFS)
 1291   VSYNC
 1292 NEXT OFS
 1293 COLOROFS(0,0,0)
 1294 VSYNC
 1295 RETURN
 1296 '---------------- Copyright ﾋｮｳｼﾞ
 1297 *DISP_COPYRIGHT
 1298   DC_TIME=DC_TIME+1
 1299   IF (DC_TIME AND &HF) <> 0 THEN RETURN
 1300   LOCATE 0,25:COLOR 4:PRINT MID$(Q$,QCUT,37);
 1301   QCUT=QCUT+1:DC_TIME=0
 1302   IF (QCUT=(LEN(PROG$)+100)) THEN QCUT=1
 1303   RETURN

