 1000 '================================
 1010 ' TEKETEKE
 1020 '                          V1.01
 1025 ' Programed by SCRIPT ARTS
 1030 '              KOBAYASHI KEITA
 1040 '================================
 1050 '1998/3/30
 1060 '
 1070 SCREEN 0:SKCLOSE
 1080 COLOROFS ON
 1090 CLEAR,600
 1100 MOSAIC ON 0
 1110 SPRWINDOW,,,,,0,0
 1120 COLOROFS ON
 1130 COLOROFS (-255,-255,-255)
 1140 GLOAD "CD:TEKST.1"
 1150 COLOROFS ON
 1160 COLOROFS ON 10
 1170 FOR COL=-255 TO 0 STEP 15:COLOROFS (COL,COL,COL):VSYNC :NEXT
 1180 VSYNC 240
 1190 GOSUB *FIRST
 1200 '
 1210 SCREEN 0
 1220 CLEAR,600
 1221 'デバイス判定
 1222 DEV$="CRAM:":GOSUB *DEV_CHECK:IF RET<>0 THEN
 1223  PRINT:PRINT "ｶｰﾄﾘｯｼﾞRAMｶﾞｱﾘﾏｾﾝ"
 1224  PRINT "ｶｰﾄﾘｯｼﾞRAMｶﾞﾅｲﾄｾｰﾌﾞﾃﾞｷﾏｾﾝｶﾞ"
 1225  PRINT "ｱｿﾌﾞ ｺﾄﾊﾃﾞｷﾏｽ"
 1226  PRINT "ｶｰﾄﾘｯｼﾞRAMﾊ982ﾉｱｷﾖｳﾘｮｳｶﾞﾋﾂﾖｳﾃﾞｽ":VSYNC 300:CLS
 1227 ENDIF
 1230 COLOROFS ON
 1240 MOSAIC ON 0
 1250 SPRWINDOW,,,,,0,0
 1260 COLOROFS (-255,-255,-255)
 1280 '*************ﾊｲﾚﾂﾉﾄｳﾛｸ
 1290   DIM CAR(30,30,30)
 1300   DIM OBJX(99)
 1310   DIM OBJY(99)
 1320   DIM OBJH(99)
 1330   DIM KUMOSP(99,10)
 1340   '***ｱｿﾋﾞ
 1350   DIM IF1(30)
 1360   DIM IF2(30):'HOUKOU
 1370   DIM YAMUKI(30)
 1380   DIM DTYAMUKI(30)
 1390   DIM HYAMUKI(30)
 1400   DIM MYAMUKI(30)
 1410   DIM TAMA(30)
 1420   DIM PWIN(30)
 1430   MOUSE=10:PMOUSE=10:'SPEED OF MOUSE
 1440 '*************ﾍﾝｽｳﾄｳﾛｸ
 1450   '
 1460   GOSUB *SUB5:'ﾊﾟｯﾄﾞﾊﾝﾃｲ
 1470   GOSUB *SUB1:'1ｶｲﾒﾉﾐ
 1480   GOSUB *SUB2
 1490   GOSUB *SUB4:'1ｶｲﾒﾉﾐ
 1500   GOSUB *SUB3
 1510   '
 1520 '*************ﾌｪｲﾄﾞｲﾝ
 1530   FOR COL=-255 TO 0 STEP 5:COLOROFS (COL,COL,COL):VSYNC :NEXT
 1540 '
 1550 '
 1560 '
 1570   ON INTERVAL (0) GOSUB *PAD1
 1580   INTERVAL (0) ON,1
 1590 '>>>>>>>>ﾒｲﾝﾙｰﾌﾟ
 1610 *MAIN
 1620   LOCATE 2,19:PRINT DATE$
 1630   GOSUB *PARA:'ｼﾞｶﾝﾅﾄﾞﾉﾍﾝｶ
 1640   GOSUB *CHARA:'ｷｬﾗｸﾀｰﾉｽﾍﾞﾃ
 1650   GOSUB *OBJCT:'ﾓﾉﾉｽﾍﾞﾃ
 1660   GOSUB *JUDGE:'ﾊﾝﾃｲ
 1670   GOTO *MAIN
 1680  END
 1681 'ﾃﾞﾊﾞｲｽﾁｪｯｸ DEV$ﾉﾃﾞﾊﾞｲｽｶﾞｿﾝｻﾞｲｽﾙｶｦﾁｪｯｸｽﾙ
 1682 *DEV_CHECK
 1683 ON ERROR GOTO *DEV_ERR
 1684 RET=0:A$=FILES$(DEV$+"*.*")
 1685 *DEV_CHECK_EXIT:ON ERROR GOTO 0:RETURN
 1686 *DEV_ERR:RET=1:RESUME *DEV_CHECK_EXIT
 1690 '<<<<<<<<<<<<<<
 1700 '
 1710 '
 1720 '
 1730 '==>>>>>>>>>>>ｲｯｿｳﾒ
 1750 *PARA
 1760   FOR K=2 TO 4
 1770    OBJ(44+K,12)=CAR(K,8,2)/2000:'ｲﾉﾁﾉﾊﾟﾗ
 1780    OBJ(41+K,12)=(CAR(K,3,0)+CAR(K,6,0)+CAR(K,5,0))/600:'ﾔﾙｷﾉﾊﾟﾗ
 1790    OBJ(38+K,12)=(CAR(K,4,0)+CAR(K,7,0))/400 :'ｹｲｹﾝﾉﾊﾟﾗ
 1800    GOSUB *WINCOL
 1810   NEXT
 1820    OBJ(49,13)=CAR(5,0,0)/100
 1830    OBJ(50,13)=CAR(6,0,0)/100
 1840    OBJ(51,13)=(3600-TIME)/360
 1850  RETURN
 1860  '
 1880 *CHARA
 1890   FOR K=2 TO 4
 1900     IF CAR(K,7,1)=0 THEN
 1910       GOSUB *CMOVE
 1920       GOSUB *CPARA
 1930       GOSUB *CEVENT
 1940       GOSUB *CANIME
 1950       GOSUB *CBORN
 1960     ENDIF
 1970     IF CAR(K,7,1)=1 THEN GOSUB *DEAD
 1980     IF CAR(K,7,1)=2 THEN GOSUB *DEADANIME
 1990   NEXT
 2000  RETURN
 2010  '
 2030 *OBJCT
 2040   GOSUB *OMOVE
 2050   GOSUB *OANIME
 2060  RETURN
 2070  '
 2090 *JUDGE
 2100    '******ﾒｼﾉｲﾄﾞｳ
 2110    IF MESI=1 OR MESI=2 THEN
 2120      MESI=2
 2130      CAR(5,0,0)=1000
 2140      OBJ(5,20)=0
 2150      OBJ(5,16)=36,36
 2160      OBJ(5,4)=PADX,PADY,5
 2170    ENDIF
 2180    IF MESI=3 THEN
 2190      IF CAR(5,0,0)<5 THEN
 2200        OBJ(5,20)=5
 2210        OBJ(5,4)=0,0,5
 2220        FOR MESIK=2 TO 4
 2230          CAR(K,3,2)=0
 2240          CAR(K,6,6)=2
 2250        NEXT
 2260        CAR(5,0,0)=0
 2270        MESI=0
 2280      ENDIF
 2290    ENDIF
 2300    IF MESI=0 THEN CAR(5,0,0)=0
 2310    '******ﾍﾞﾝｷｮｳﾉｲﾄﾞｳ
 2320    IF BENK=1 OR BENK=2 THEN
 2330      BENK=2
 2340      CAR(6,0,0)=1000
 2350      OBJ(6,20)=0
 2360      OBJ(6,4)=PADX,PADY,5
 2370    ENDIF
 2380    IF BENK=3 THEN
 2390      IF CAR(6,0,0)<5 THEN
 2400        OBJ(6,20)=6
 2410        OBJ(6,4)=0,0,5
 2420        FOR BENKK=2 TO 4
 2430          CAR(K,4,2)=0
 2440          CAR(K,6,6)=2
 2450        NEXT
 2460        CAR(6,0,0)=0
 2470        BENK=0
 2480      ENDIF
 2490    ENDIF
 2500    IF BENK=0 THEN CAR(6,0,0)=0
 2510    '******ｱｿﾋﾞﾉﾄｷ
 2520    IF ASOBI=1 THEN
 2530     FOR K=2 TO 4:ASFG=ASFG+CAR(K,3,2)+CAR(K,4,2)+CAR(K,5,2)+CAR(K,6,2):NEXT
 2540      IF ASFG=0 THEN
 2550        GOSUB *PLAY1
 2560      '*********ｺﾞﾊﾝﾄｶｦｹｽ
 2570       IF MESI=3 THEN
 2580          OBJ(5,20)=5
 2590          OBJ(5,4)=0,0,5
 2600          FOR MESIK=2 TO 4
 2610            CAR(K,3,2)=0
 2620          NEXT
 2630          CAR(5,0,0)=0
 2640          MESI=0
 2650       ENDIF
 2660    '******ﾍﾞﾝｷｮｳﾉｲﾄﾞｳ
 2670       IF BENK=3 THEN
 2680         IF CAR(6,0,0)<5 THEN
 2690           OBJ(6,20)=6
 2700           OBJ(6,4)=0,0,5
 2710           FOR BENKK=2 TO 4
 2720             CAR(K,4,2)=0
 2730           NEXT
 2740           CAR(6,0,0)=0
 2750           BENK=0
 2760          ENDIF
 2770        ENDIF
 2780      ENDIF
 2790      ASOBI=0:ASFG=0
 2800      FOR ASOBIK=2 TO 4
 2810       CAR(K,6,6)=4
 2820      NEXT
 2830    ENDIF
 2840    '******ｾｰﾌﾞﾛｰﾄﾞ
 2850    IF TSAVE=1 THEN
 2860      IF OBJ(5,20)<>0 AND OBJ(6,20)<>0 THEN GOSUB *TKSAVE:OBJ(5,4)=OBJX(5),OBJY(5):OBJ(6,4)=OBJX(6),OBJY(6)
 2870      TSAVE=0
 2900    ENDIF
 2910    IF TLOAD=1 THEN
 2920      GOSUB *TKLOAD
 2930      TLOAD=0
 2940         OBJ(5,4)=OBJX(5),OBJY(5)
 2950         OBJ(6,4)=OBJX(6),OBJY(6)
 2960    ENDIF
 2970    '******ｼﾝﾀﾞﾄｷ
 2980    'FOR K=2 TO 4:IF CAR(K,7,1)=1 THEN GOSUB *DEAD:NEXT
 2990    '******ｼﾞｶﾝｷﾞﾚﾉﾄｷ
 3000    IF TIME>3600 THEN GOSUB *TIMEUP
 3010  RETURN
 3020  '==<<<<<<<<<<<<<<
 3030  '
 3040  '
 3050  '====>>>>>>>>>>ﾆｿｳﾒ
 3070 *CMOVE
 3080  '********ﾒｼﾃﾞﾓﾍﾞﾝｷｮｳﾃﾞﾓﾅｲﾄｷ
 3090  IF CAR(K,3,2)=0 AND CAR(K,4,2)=0 THEN
 3100    '********ﾂｶﾏﾚﾃﾙﾄｷ
 3110    IF CAR(K,9,0)<>0 THEN
 3120      IF CAR(K,1,0)<=0 THEN
 3130        CAR(K,0,0)=PADX-8:CAR(K,0,1)=PADY+8
 3140        CAR(K,0,2)=0
 3150      ELSE
 3160        CAR(K,0,0)=PADX-8-K:CAR(K,0,1)=PADY+8
 3170        CAR(K,0,2)=0
 3180      ENDIF
 3190        IF CAR(K,6,2)<>0 THEN
 3200          CAR(K,6,1)=CAR(K,6,1)-6
 3210        ENDIF
 3220      IF CAR(K,9,0)=2 THEN
 3230        CAR(K,9,0)=0
 3240      ENDIF
 3250      GOTO *CMOVEEND
 3260    ENDIF
 3270    '********ﾈﾃﾅｲﾄｷﾄ ｷｭｳｹｲｼﾞｬﾅｲﾄｷ
 3280    IF CAR(K,3,3)=0 AND CAR(K,5,2)=0 THEN
 3290       '
 3300       '********RND ﾃﾞ ﾎｳｺｳﾃﾝｶﾝ
 3310       IF RND(50)>CAR(K,6,0) OR RND(1000)=1 THEN
 3320         CAR(K,1,0)=(100-RND(201))*(1+K*2.5)/100
 3330         CAR(K,1,1)=(100-RND(201))*(1+K*2.5)/100
 3340         IF CAR(K,0,2)=1 THEN CAR(K,0,2)=2
 3350       ENDIF
 3360       '********RND ﾃﾞ ｶｲﾃﾝｳﾝﾄﾞｳ
 3370       IF RND(10000)<100 AND CAR(K,0,2)=0 THEN
 3380          CAR(K,0,2)=1:CAR(K,1,2)=RND(100)/100:CAR(K,1,3)=10+RND(30):CAR(K,0,5)=(.5-RND(2))*2
 3390          CAR(K,0,3)=CAR(K,0,0)-SIN(CAR(K,1,2)*CAR(K,0,5))*CAR(K,1,3)
 3400          CAR(K,0,4)=CAR(K,0,1)-COS(CAR(K,1,2)*CAR(K,0,5))*CAR(K,1,3)
 3410       ENDIF
 3420       IF CAR(K,0,2)=1 THEN
 3430         CAR(K,1,2)=CAR(K,1,2)+.1
 3440         CAR(K,1,3)=CAR(K,1,3)+RND(11)/10
 3450           CAR(K,1,0)=SIN(CAR(K,1,2)*CAR(K,0,5))
 3460           CAR(K,1,1)=COS(CAR(K,1,2)*CAR(K,0,5))
 3470       ENDIF
 3480       '********ｵｺｯﾃｲﾙﾄｷ ﾉ ﾊﾔｻ
 3490       IF CAR(K,6,2)=1 THEN
 3500         CAR(K,1,0)=CAR(K,1,0)*1.01
 3510         CAR(K,1,1)=CAR(K,1,1)*1.01
 3520       ENDIF
 3530       '********ﾎｳｺｳﾃﾝｶﾝ
 3540       IF CAR(K,0,1)>142 THEN CAR(K,1,1)=-CAR(K,1,1):CAR(K,0,1)=142:IF CAR(K,0,2)=1 THEN CAR(K,0,2)=2
 3550       IF CAR(K,0,1)<20 THEN CAR(K,1,1)=-CAR(K,1,1):CAR(K,0,1)=20:IF CAR(K,0,2)=1 THEN CAR(K,0,2)=2
 3560       IF CAR(K,0,0)>290 THEN CAR(K,1,0)=-CAR(K,1,0):CAR(K,0,0)=290:IF CAR(K,0,2)=1 THEN CAR(K,0,2)=2
 3570       IF CAR(K,0,0)<0 THEN CAR(K,1,0)=-CAR(K,1,0):CAR(K,0,0)=0:IF CAR(K,0,2)=1 THEN CAR(K,0,2)=2
 3580       '********ｶｲﾃﾝﾔﾒ
 3590       IF CAR(K,0,2)=2 THEN
 3600          CAR(K,1,0)=(1-RND(2))*(1+RND(10)/10)
 3610          CAR(K,1,1)=(1-RND(2))*(1+RND(10)/10)
 3620          CAR(K,0,2)=0
 3630       ENDIF
 3650 *CMOVEEND
 3660       '
 3670       '************ｷｬﾗﾉﾑｷ
 3680       IF CAR(K,1,0)<=0 THEN
 3690         OBJ(K,12)=ABS(OBJ(K,12))
 3700       ELSE
 3710         OBJ(K,12)=-ABS(OBJ(K,12))
 3720       ENDIF
 3730       '
 3740       IF CAR(K,0,2)=0 OR CAR(K,9,0)<>0 THEN
 3750          CAR(K,0,0)=CAR(K,0,0)+CAR(K,1,0):CAR(K,0,1)=CAR(K,0,1)+CAR(K,1,1)
 3760         IF CAR(K,1,0)<=0 THEN
 3770           OBJ(K,4)=CAR(K,0,0)-(CAR(K,6,4)-1)*10,CAR(K,0,1)-(CAR(K,6,4)-1)*10,1
 3780         ELSE
 3790           OBJ(K,4)=CAR(K,0,0)+25+K+(CAR(K,6,4)-1)*10,CAR(K,0,1)-(CAR(K,6,4)-1)*10,1
 3800         ENDIF
 3810       ELSE
 3820          CAR(K,0,0)=CAR(K,0,3)+CAR(K,1,0)*CAR(K,1,3):CAR(K,0,1)=CAR(K,0,4)+CAR(K,1,1)*CAR(K,1,3)
 3830         IF CAR(K,1,0)<=O THEN
 3840           OBJ(K,4)=CAR(K,0,0)-(CAR(K,6,4)-1)*10,CAR(K,0,1)-(CAR(K,6,4)-1)*10,1
 3850         ELSE
 3860           OBJ(K,4)=CAR(K,0,0)+25+K+(CAR(K,6,4)-1)*10,CAR(K,0,1)-(CAR(K,6,4)-1)*10,1
 3870         ENDIF
 3880       ENDIF
 3890  '
 3900  '
 3910    ENDIF
 3920  ENDIF
 3930   IF CAR(K,4,2)<>0 AND CAR(K,1,0)>0 THEN OBJ(K,4)=CAR(K,0,0),CAR(K,0,1),4:OBJ(K,12)=ABS(OBJ(K,12))
 3940  RETURN
 3950  '
 3970 *CPARA
 3980     '
 3990     '*********ｹｲｹﾝﾁ
 4000     CAR(K,7,0)=CAR(K,7,0)+ABS(CAR(K,1,0)+CAR(K,1,1))/100
 4010     IF CAR(K,7,0)>1000 THEN CAR(K,7,0)=1000
 4020     '*********ｺﾞﾊﾝ
 4030     IF CAR(K,3,2)=1 THEN
 4040       CAR(5,0,0)=CAR(5,0,0)-CAR(K,3,1)
 4050       CAR(K,3,0)=CAR(K,3,0)+CAR(K,3,1)/10
 4060       CAR(K,6,0)=CAR(K,6,0)+CAR(K,4,1)*.3
 4070       CAR(K,7,0)=CAR(K,7,0)+ABS(CAR(K,3,1)+CAR(K,4,1))/300
 4080       IF CAR(K,6,0)>1000 THEN CAR(K,6,0)=1000
 4090       IF CAR(K,3,0)>1000 OR MESI=0 THEN CAR(K,3,0)=1000:CAR(K,3,2)=0
 4100     ENDIF
 4110     '*********ﾍﾞﾝｷｮｳ
 4120     IF CAR(K,4,2)=1 THEN
 4130       CAR(6,0,0)=CAR(6,0,0)-CAR(K,4,1)
 4140       CAR(K,4,0)=CAR(K,4,0)+CAR(K,4,1)/100
 4150       CAR(K,6,0)=CAR(K,6,0)-CAR(K,3,1)*.3
 4160       CAR(K,7,0)=CAR(K,7,0)+(CAR(K,3,1)+CAR(K,4,1))/300
 4170       IF CAR(K,6,0)<0 THEN CAR(K,6,0)=0
 4180       IF CAR(K,4,0)>1000 THEN CAR(K,4,0)=1000
 4190       IF CAR(K,6,0)<100 OR BENK=0 THEN CAR(K,4,2)=0:CAR(K,6,6)=2
 4200     ENDIF
 4210     '**********ｵﾅｶﾉﾍﾘｸﾞｱｲ
 4220     CAR(K,3,0)=CAR(K,3,0)-ABS(CAR(K,1,0)+CAR(K,1,1))/10
 4230     IF CAR(K,3,0)<=0 THEN CAR(K,3,0)=1
 4240     '**********ﾈﾑｻ
 4250     CAR(K,5,0)=CAR(K,5,0)-ABS(CAR(K,1,0)+CAR(K,1,1))/30
 4260     IF CAR(K,5,2)=1 THEN
 4270        CAR(K,5,1)=CAR(K,5,1)-1
 4280     ENDIF
 4290     '**********ｷｹﾞﾝ
 4300     CAR(K,6,0)=CAR(K,6,0)-.1
 4310     IF CAR(K,6,0)<0 THEN CAR(K,6,0)=0
 4320     '**********LIFE
 4330     CAR(K,8,2)=CAR(K,8,2)-DTIME
 4340      IF CAR(K,3,0)<50 THEN
 4350        CAR(K,8,2)=CAR(K,8,2)-DTIME*10
 4360      ENDIF
 4370      IF CAR(K,3,0)<10 THEN
 4380        CAR(K,8,2)=CAR(K,8,2)-DTIME*30
 4390      ENDIF
 4400      IF CAR(K,6,2)=1 THEN
 4410        CAR(K,8,2)=CAR(K,8,2)-DTIME*10
 4420      ENDIF
 4430     IF CAR(K,8,2)<0 THEN CAR(K,7,1)=1:'**ｼﾆﾏｼﾀ
 4440     '**********ｷｭｳｹｲﾁｭｳ
 4450     IF CAR(K,3,3)=1 THEN
 4460       CAR(K,3,4)=CAR(K,3,4)-1
 4470     ENDIF
 4480     '
 4490     '**********ｵｺﾙｳｪｲﾄ
 4500     IF CAR(K,6,2)=0 THEN
 4510        CAR(K,6,1)=CAR(K,6,1)+1
 4520       IF CAR(K,6,1)>=700 THEN
 4530          CAR(K,6,1)=700
 4540       ENDIF
 4550     ENDIF
 4560     '**********ｵｺｯﾃﾙ
 4570     IF CAR(K,6,2)=1 THEN
 4580       IF CAR(K,1,0)<=0 THEN
 4590         CAR(K,6,4)=ABS(CAR(K,6,4))
 4600       ELSE
 4610         CAR(K,6,4)=-ABS(CAR(K,6,4))
 4620       ENDIF
 4630 '
 4640       OBJ(K,12)=CAR(K,6,4),ABS(CAR(K,6,4))
 4650       CAR(K,6,4)=ABS(CAR(K,6,4))+.001
 4660        IF CAR(K,6,4)>2 THEN CAR(K,6,4)=2
 4670     ENDIF
 4680  RETURN
 4690  '
 4710 *CEVENT
 4720     '**********ﾍﾝｼﾝ
 4730     IF (CAR(K,7,0)+CAR(K,4,0))>1000 THEN CAR(K,2,0)=15+5*(K-2)
 4740     '**********ﾈﾙ
 4750     IF CAR(K,3,2)=0 AND CAR(K,4,2)=0 AND CAR(K,5,2)=0 THEN
 4760        IF CAR(K,5,0)<0 THEN
 4770          CAR(K,6,2)=2
 4780          CAR(K,5,1)=RND(500)+300
 4790          CAR(K,5,2)=1
 4800        ENDIF
 4810     ENDIF
 4820     '*********ｵｷﾙ
 4830     IF CAR(K,5,1)<10 AND CAR(K,5,2)=1 THEN
 4840        CAR(K,5,0)=1000
 4850        CAR(K,5,2)=0
 4860        CAR(K,6,0)=CAR(K,6,0)+100
 4870        CAR(K,6,6)=4
 4880     ENDIF
 4890     '**********ﾒｼﾍﾞﾝｷｮｳ
 4900     IF MESI=3 OR BENK=3 THEN
 4910        IF CAR(K,6,2)=0 AND CAR(K,9,0)=0 AND CAR(K,5,2)=0 THEN
 4920          IF MESI=3 AND CAR(K,4,2)=0 AND CAR(K,3,2)=0 AND CAR(K,3,0)<700 THEN
 4930            IF ABS(OBJX(5)-CAR(K,0,0))<20 AND ABS(OBJY(5)-CAR(K,0,1))<30 THEN
 4940              CAR(K,3,2)=1
 4950            ENDIF
 4960          ENDIF
 4970          IF BENK=3 AND CAR(K,3,2)=0 AND CAR(K,4,2)=0 AND CAR(K,6,0)>200 THEN
 4980            IF ABS(OBJX(6)-CAR(K,0,0))<20 AND ABS(OBJY(6)-CAR(K,0,1))<30 THEN
 4990              CAR(K,4,2)=1
 5000            ENDIF
 5010          ENDIF
 5020        ENDIF
 5030      ENDIF
 5040    '******ﾅﾝｶｼﾃﾀﾗ ｲｶｼｮｳﾘｬｸ
 5050    IF CAR(K,3,2)=0 AND CAR(K,4,2)=0 AND CAR(K,5,2)=0 AND CAR(K,6,2)=0 THEN
 5060      '***********ｷｭｳｹｲｶﾄﾞｳｶT
 5070      IF RND(1000)<10/CAR(K,3,0) THEN
 5080         CAR(K,3,3)=1
 5090         CAR(K,3,4)=RND(200)
 5100      ENDIF
 5110      '**********ｷｭｳｹｲﾔﾒﾙ
 5120      IF CAR(K,3,4)<0 AND CAR(K,3,3)=1 THEN
 5130        CAR(K,3,3)=0
 5140      ENDIF
 5150      '**********ｵｺﾙｶﾄﾞｳｶ
 5160      IF CAR(K,6,1)>500 AND CAR(K,6,2)=0 THEN
 5170        IF (RND(10000)<10/CAR(K,6,3) AND CAR(K,3,0)<50) OR CAR(K,6,0)<=10 THEN
 5180        '   CAR(K,6,1)=0
 5190           CAR(K,6,2)=1
 5200           CAR(K,6,4)=1.1
 5210          FOR CARCOLO=0 TO 100 STEP 2
 5220          CAR(K,6,5)=CARCOLO
 5230            COLOROFS (CAR(2,6,5),CAR(4,6,5),CAR(3,6,5))
 5240            VSYNC
 5250          NEXT
 5260          CAR(K,6,5)=100
 5270        ENDIF
 5280      ENDIF
 5290    ENDIF
 5300     '**********ｵｺﾙﾉﾔﾒﾙ
 5310     IF (CAR(K,6,1)<10 AND CAR(K,6,2)=1) OR CAR(K,6,2)=2 THEN
 5320        CAR(K,6,0)=CAR(K,6,0)+200
 5330        CAR(K,6,2)=0
 5340        CAR(K,6,2)=0
 5350        CAR(K,6,4)=1
 5360        OBJ(K,12)=1,1
 5370      FOR CARCOLO=100 TO 0 STEP -2
 5380      CAR(K,6,5)=CARCOLO
 5390        COLOROFS (CAR(2,6,5),CAR(4,6,5),CAR(3,6,5))
 5400        VSYNC
 5410      NEXT
 5420        CAR(K,6,5)=0
 5430     ENDIF
 5440  RETURN
 5450  '
 5460  '
 5480 *CANIME
 5490    '********ﾋｮｳｼﾞｮｳﾉｹｯﾃｲ
 5500    IF CAR(K,3,2)<>0 THEN CAR(K,2,2)=CAR(K,2,0)+2:CAR(K,2,3)=CAR(K,2,0):GOTO *CANIME1
 5510    IF CAR(K,4,2)<>0 THEN CAR(K,2,2)=CAR(K,2,0)+1:CAR(K,2,3)=CAR(K,2,0):GOTO *CANIME1
 5520    IF CAR(K,5,2)<>0 THEN CAR(K,2,2)=30:CAR(K,2,3)=31:GOTO *CANIME1
 5530    IF CAR(K,6,2)<>0 THEN CAR(K,2,2)=CAR(K,2,0)+3:CAR(K,2,3)=CAR(K,2,0)+2:GOTO *CANIME1
 5540    IF CAR(K,6,6)<>0 THEN CAR(K,2,2)=CAR(K,2,0)+4:CAR(K,2,3)=CAR(K,2,0):GOTO *CANIME1
 5550    '********ｳｪｲﾄ
 5560    IF CAR(K,3,0)<200 AND CAR(K,2,4)=0 THEN CAR(K,2,4)=1
 5570    '********ﾌﾀﾞﾝ
 5580    OBJ(6+K,20)=6+K
 5590    CAR(K,2,2)=CAR(K,2,0):CAR(K,2,3)=CAR(K,2,0)+1
 5600    '
 5610    '
 5630 *CANIME1
 5640    '********ｳｪｲﾄ
 5650    IF CAR(K,3,2)<>0 AND CAR(K,2,4)=0 THEN CAR(K,2,4)=1
 5660    '********ﾒｶﾞﾈｶｹﾙ
 5670    IF CAR(K,4,2)<>0 THEN
 5680      CAR(K,4,3)=1
 5690      OBJ(6+K,20)=0
 5700      OBJ(6+K,4)=CAR(K,0,0),CAR(K,0,1)+7,0
 5710      IF K=4 THEN OBJ(6+K,4)=CAR(K,0,0)-3,CAR(K,0,1)+12,0
 5720    ENDIF
 5730    IF CAR(K,4,3)=1 AND CAR(K,4,2)=0 THEN
 5740      CAR(K,4,3)=0
 5750      OBJ(6+K,20)=6+K
 5760    ENDIF
 5770    '********ﾖﾛｺﾌﾞﾄｷ
 5780    IF CAR(K,6,6)<>0 THEN
 5790      IF ABS(TIME-CAR(K,6,7))>=2 THEN
 5800        CAR(K,6,6)=CAR(K,6,6)-1
 5810        IF CAR(K,6,6)=0 THEN CAR(K,6,7)=0
 5820      ENDIF
 5830    ENDIF
 5840    '********ｳｪｲﾄｹｲｻﾝ
 5850    IF CAR(K,2,4)=2 THEN
 5860      IF ABS(TIME-CAR(K,2,5))>=1 THEN CAR(K,2,4)=0
 5870      GOTO *CANIMEEND
 5880    ENDIF
 5890    '********ｶｵﾋｮｳｼﾞ
 5900    IF INT(TIME)/2=INT(TIME/2) THEN OBJ(K,16)=CAR(K,2,2),CAR(K,2,2)
 5910    IF INT(TIME)/2<>INT(TIME/2) THEN OBJ(K,16)=CAR(K,2,3),CAR(K,2,3)
 5920    '
 5930    IF CAR(K,6,6)<>0 AND CAR(K,6,7)=0 THEN CAR(K,6,7)=TIME
 5940    IF CAR(K,2,4)=1 THEN CAR(K,2,4)=2:CAR(K,2,5)=TIME
 5960 *CANIMEEND
 5970  RETURN
 5980  '
 6000 *DEADANIME
 6010  IF CAR(K,7,1)=2 THEN
 6020    OBJ(K,16)=79,79
 6030    IF K=2 THEN OBJ(K,4)=220,30:OBJ(K,12)=1,1
 6040    IF K=3 THEN OBJ(K,4)=280,110:OBJ(K,12)=1,1
 6050    IF K=4 THEN OBJ(K,4)=20,110:OBJ(K,12)=1,1
 6060    OBJ(K,20)=0
 6070  ENDIF
 6080 RETURN
 6090  '
 6110 *CBORN
 6120    IF CAR(K,7,0)>CAR(K,7,2)*50 AND CAR(K,7,0)>40 THEN
 6130      CAR(K,7,2)=CAR(K,7,2)+1
 6140       IF K=2 AND CAR(K,7,2)>=2 THEN GOSUB *SORA:CAR(K,6,6)=3
 6150       IF K=4 AND CAR(K,7,2)>=2 THEN GOSUB *JIMEN:CAR(K,6,6)=3
 6160     '+++ﾀｲﾖｳ
 6170       IF K=2 AND CAR(K,7,2)>12 AND CAR(K,4,0)>500 THEN
 6180         OBJH(33)=0:OBJ(33,20)=OBJH(33):CAR(K,6,6)=4:GOTO *UMUMONOEND
 6190         FOR CU=0 TO 255 STEP 5:COLOROFS (CU,CU,CU):VSYNC :NEXT
 6200       ENDIF
 6210     '+++ｳﾐ
 6220       IF K=3 AND CAR(K,7,2)>2 AND CAR(K,7,2)<=10 AND UMI<=4 THEN
 6230         OBJH(22+UMI)=0:OBJ(22+UMI,20)=OBJH(22+UMI):UMI=UMI+1:CAR(K,6,6)=4:GOTO *UMUMONOEND
 6240         FOR CU=0 TO 255 STEP 5:COLOROFS (CU,CU,CU):VSYNC :NEXT
 6250       ENDIF
 6260     '+++ｸﾓ
 6270       IF K=3 AND CAR(K,7,2)>=10 AND CAR(K,4,0)>500+(KUMO*200) AND PWIN(1)>10*KUMO THEN
 6280          IF KUMO>=3 THEN
 6290             GOTO *UMUMONOEND
 6300           ELSE
 6310             OBJH(29+KUMO)=0:OBJ(29+KUMO,20)=OBJH(29+KUMO):KUMO=KUMO+1:CAR(K,6,6)=4:GOTO *UMUMONOEND
 6320             FOR CU=0 TO 255 STEP 5:COLOROFS (CU,CU,CU):VSYNC :NEXT
 6330          ENDIF
 6340       ENDIF
 6350     '+++ﾔﾏ
 6360       IF K=4 AND CAR(K,7,2)=12 THEN
 6370          OBJH(32)=0:OBJ(32,20)=OBJH(32):CAR(K,6,6)=4:GOTO *UMUMONOEND
 6380          FOR CU=0 TO 255 STEP 5:COLOROFS (CU,CU,CU):VSYNC :NEXT
 6390       ENDIF
 6400     '+++ﾔﾏ2
 6410       IF SYAMA<>1 AND K=4 AND CAR(K,7,2)>=16 AND CAR(K,4,0)>800 AND PWIN(1)>50 THEN
 6420          OBJH(58)=0:OBJ(58,20)=OBJH(58):CAR(K,6,6)=4:SYAMA=1:GOTO *UMUMONOEND
 6430          FOR CU=0 TO 255 STEP 5:COLOROFS (CU,CU,CU):VSYNC :NEXT
 6440       ENDIF
 6450     '+++ｷ
 6460       IF SKI=0 AND K=4 AND CAR(K,7,2)>18 AND CAR(K,4,0)>900 THEN
 6470          OBJH(26)=0:OBJ(26,20)=OBJH(26):CAR(K,6,6)=4:SKI=1
 6480          FOR CU=0 TO 255 STEP 5:COLOROFS (CU,CU,CU):VSYNC :NEXT
 6490       ENDIF
 6500     '+++ｷ
 6510       IF SKI1<>1 AND K=4 AND CAR(K,7,2)>12 AND CAR(K,4,0)>500 AND PWIN(1)>70 THEN
 6520          OBJH(55)=0:OBJ(55,20)=OBJH(55):CAR(K,6,6)=4:SKI1=1
 6530          FOR CU=0 TO 255 STEP 5:COLOROFS (CU,CU,CU):VSYNC :NEXT
 6540       ENDIF
 6550     '+++ｷ
 6560       IF SKI2<>1 AND K=4 AND CAR(K,7,2)>19 AND CAR(K,4,0)>100 AND PWIN(0)>5 THEN
 6570          OBJH(56)=0:OBJ(56,20)=OBJH(56):CAR(K,6,6)=4:SKI2=1
 6580          FOR CU=0 TO 255 STEP 5:COLOROFS (CU,CU,CU):VSYNC :NEXT
 6590       ENDIF
 6610 *UMUMONOEND
 6620     '+++ｷ
 6630       IF CAR(K,7,2)=4 AND CAR(K,4,0)>100 THEN
 6640          OBJH(25+K)=0:OBJ(25+K,20)=OBJH(25+K):CAR(K,6,6)=4
 6650          FOR CU=0 TO 255 STEP 5:COLOROFS (CU,CU,CU):VSYNC :NEXT
 6660       ENDIF
 6670     '+++ｲｴ
 6680      FOR KIE=2 TO 4:IF CAR(KIE,4,0)<700 THEN GOTO *MADA:NEXT
 6690      IF SIE<>1 AND PWIN(1)>30 THEN
 6700         OBJH(21)=0:OBJ(21,20)=OBJH(21):SIE=1
 6710         FOR KIE=0 TO 2:CAR(K,6,6)=6:NEXT
 6720      ENDIF
 6730     '+++ｲｴ
 6740      IF SIE=1 AND PWIN(0)>10 THEN
 6750        OBJH(57)=0:OBJ(57,20)=OBJH(57):SIE=2
 6760        FOR KIE=0 TO 2:CAR(KIE,6,6)=6:NEXT
 6770      ENDIF
 6790 *MADA
 6800     FOR CU=255 TO 0 STEP -6:COLOROFS (CU,CU,CU):VSYNC :NEXT
 6810    ENDIF
 6820  RETURN
 6830  '
 6850 *OMOVE
 6860    '
 6870    '*********ｸﾓﾉｳｺﾞｷ
 6880    FOR KUMONO=30 TO 31
 6890      IF INT(DKUMO)=1000 THEN
 6900         KUMOSP(KUMONO,0)=.8+RND(80)/1000
 6910         KUMOSP(KUMONO,1)=(.5-RND(2))*(.02+RND(100))/1000
 6920      ENDIF
 6930          '       IF OBJY(KUMONO)<30AND OBJY(KUMONO)>5 THEN OBJX(KUMONO)=OBJX(KUMONO)
 6940      IF OBJY(KUMONO)>30 THEN
 6950          OBJY(KUMONO)=29:KUMOSP(KUMONO,1)=-KUMOSP(KUMONO,1)*(.8+RND(40)/100)
 6960       ELSE
 6970         IF OBJY(KUMONO)<5 THEN
 6980            OBJY(KUMONO)=6:KUMOSP(KUMONO,1)=-KUMOSP(KUMONO,1)*(.8+RND(40)/100)
 6990         ENDIF
 7000      ENDIF
 7010      OBJX(KUMONO)=OBJX(KUMONO)+KUMOSP(KUMONO,0):OBJY(KUMONO)=OBJY(KUMONO)+KUMOSP(KUMONO,1)
 7020     IF OBJX(KUMONO)>325 THEN OBJX(KUMONO)=-64
 7030     OBJ(KUMONO,4)=OBJX(KUMONO),OBJY(KUMONO),8
 7040    NEXT
 7050    DKUMO=DKUMO+RND(1000)/100
 7060    IF DKUMO>1001 THEN DKUMO=0
 7070  RETURN
 7080  '
 7100 *OANIME
 7110  '**** ﾓﾉﾉｱﾆﾒ
 7120    IF INT(TIME)/2=INT(TIME/2) THEN
 7130      FOR HAIKEI=22 TO 25:OBJ(HAIKEI,16)=HAIKEI+24,HAIKEI+24 :NEXT
 7140      FOR HAIKEI=26 TO 29:OBJ(HAIKEI,16)=44,44:NEXT
 7150      FOR HAIKEI=55 TO 56:OBJ(HAIKEI,16)=44,44:NEXT
 7160      OBJ(30,16)=56,56:OBJ(31,16)=55,55
 7170      OBJ(33,16)=57,57
 7180    ENDIF
 7190  '
 7200    IF INT(TIME)/2<>INT(TIME/2) THEN
 7210      FOR HAIKEI=22 TO 25:OBJ(HAIKEI,16)=HAIKEI+28,HAIKEI+28 :NEXT
 7220      FOR HAIKEI=26 TO 29:OBJ(HAIKEI,16)=45,45:NEXT
 7230      FOR HAIKEI=55 TO 56:OBJ(HAIKEI,16)=45,45:NEXT
 7240      OBJ(30,16)=55,55:OBJ(31,16)=56,56
 7250      OBJ(33,16)=58,58
 7260    ENDIF
 7270  RETURN
 7280  '=====<<<<<<<<<<<<<<
 7290  '
 7300 '))))))))))))ｱｿﾋﾞ
 7320 *PLAY1:PLAY1=1
 7330  '*********ｱｲｺﾝﾉﾎｿﾞﾝ
 7340   MASIH=OBJ(5,20)
 7350   BENKH=OBJ(6,20)
 7360  '*********ﾌｪｰﾄﾞｱｳﾄ
 7370   FOR COL=0 TO -255 STEP -5:COLOROFS (COL,COL,COL):VSYNC :NEXT
 7380  '******************ｼﾞﾌﾞﾝﾉｱｲｺﾝﾉﾊｲﾁ
 7390   PLAYRND=RND(9)
 7400   IF PLAYRND>=0 THEN PLAYSET=1:JK=0:PADX=144:PADY=42
 7410   IF PLAYRND>2 THEN PLAYSET=2:JK=0:PADX=144:PADY=190
 7420   IF PLAYRND>4 THEN PLAYSET=3:JK=1:PADX=90:PADY=104
 7430   IF PLAYRND>6 THEN PLAYSET=4:JK=1:PADX=238:PADY=104
 7440   IF JK=0 THEN OBJ(1,16)=65,65
 7450   IF JK=1 THEN OBJ(1,16)=66,66
 7460  '
 7470  '*****************ｵﾌﾞｼﾞｪｸﾄﾉﾊｲﾁ
 7480   FOR K=2 TO 4
 7500 *PLAYSET2
 7510     PLAYRND=RND(9)
 7520     IF PLAYRND>=0 AND PLAYSET<>1 AND IF1(2)<>1 AND IF1(3)<>1 AND IF1(4)<>1 THEN CARX=144:CARY=23:PFLAG=1:IF1(K)=1:IF2(K)=1
 7530     IF PLAYRND>2 AND PLAYSET<>2 AND IF1(2)<>2 AND IF1(3)<>2 AND IF1(4)<>2 THEN CARX=144:CARY=185:PFLAG=2:IF1(K)=2:IF2(K)=1
 7540     IF PLAYRND>4 AND PLAYSET<>3 AND IF1(2)<>3 AND IF1(3)<>3 AND IF1(4)<>3 THEN CARX=70:CARY=104:PFLAG=3:IF1(K)=3:IF2(K)=-1
 7550     IF PLAYRND>6 AND PLAYSET<>4 AND IF1(2)<>4 AND IF1(3)<>4 AND IF1(4)<>4 THEN CARX=234:CARY=104:PFLAG=4:IF1(K)=4:IF2(K)=1
 7560     IF PFLAG<1 THEN GOTO *PLAYSET2
 7570     CAR(K,0,0)=CARX:CAR(K,0,1)=CARY
 7580     CAR(K,10,0)=PFLAG
 7590     CAR(K,1,0)=3:CAR(K,1,1)=3
 7600     PFLAG=0
 7610      IF IF2(K)=-1 THEN
 7620       CAR(K,0,6)=1
 7630      ENDIF
 7640     '
 7650     OBJ(K,12)=IF2(K):OBJ(K,4)=CAR(K,0,0)+CAR(K,0,6)*(25+K),CAR(K,0,1),0
 7660   NEXT
 7670  '
 7680  '*****************ﾎﾞｰﾙ ﾉ ｲﾁ
 7690   CAR(6,1,0)=130+RND(18):CAR(6,1,1)=90+RND(18)
 7700   CAR(5,1,0)=130+RND(18):CAR(5,1,1)=120+RND(18)
 7710  '
 7720  '*****************ｶﾞﾒﾝｦｴｶﾞｸ
 7730   CR=19
 7740   CG=16
 7750   CB=9
 7760   FOR X=0 TO 320 STEP 20
 7770    FOR Y=0 TO 210 STEP 14
 7780     LINE (X,Y)-(X+20,Y+14),RGB(CR,CG,CB),BF
 7790     CB=CB+.05
 7800    NEXT
 7810   NEXT
 7820  '
 7830   FOR X=98 TO 238 STEP 2
 7840    LINE (X,50)-(X,190),RGB(3,6,4)
 7850   NEXT
 7860   FOR Y=50 TO 190 STEP 2
 7870    LINE (98,Y)-(238,Y),RGB(3,6,4)
 7880   NEXT
 7890   CR=10:CG=10:CB=15
 7900   FOR Y=14 TO 25
 7910    LINE (88,Y)-(240,Y),RGB(CR,CG,CG),BF
 7920   CG=CG+1
 7930   NEXT
 7940  '
 7950   FOR LOCA=1 TO 24:LOCATE 0,LOCA:PRINT "                                                                              ":NEXT
 7960  '*****************ｷｬﾗｸﾀｰﾉﾊｲﾁ
 7970    OBJ(21,16)=61,61:OBJ(21,4)=98,50,0:OBJ(21,20)=0
 7980    OBJ(22,16)=62,62:OBJ(22,4)=225,50,0:OBJ(22,20)=0
 7990    OBJ(23,16)=63,63:OBJ(23,4)=225,176,0:OBJ(23,20)=0
 8000    OBJ(24,16)=64,64:OBJ(24,4)=98,176,0:OBJ(24,20)=0
 8010    OBJ(25,16)=59,59:OBJ(25,4)=CAR(6,1,0),CAR(6,1,1),0:OBJ(25,20)=0
 8020    OBJ(26,16)=60,60:OBJ(26,4)=CAR(5,1,0),CAR(5,1,1),0:OBJ(26,20)=0
 8030    '
 8040    '
 8050    FOR OK=27 TO 33
 8060     OBJ(OK,16)=67,67
 8070    NEXT
 8080    FOR OK=5 TO 16
 8090     OBJ(OK,16)=67,67
 8100    NEXT
 8110    FOR OK=40 TO 51
 8120     OBJ(OK,16)=67,67:OBJ(OK,12)=1:OBJ(OK,13)=1
 8130    NEXT
 8140    FOR OK=55 TO 58
 8150     OBJ(OK,16)=67,67:OBJ(OK,12)=1:OBJ(OK,13)=1
 8160    NEXT
 8170  '************YANOMUKI
 8180    OBJ(17,20)=0:OBJ(18,20)=0
 8190    DTYAMUKI(17)=(8000+RND(4000))/100000*(.5-RND(2))
 8200    DTYAMUKI(18)=(8000+RND(4000))/100000*(.5-RND(2))
 8210  '
 8220  '****************ｷｬﾗｸﾀｰﾉｳｺﾞｷﾉﾊﾔｻ !!!!!!!!!!!!!!!!!!
 8230    FOR K=2 TO 4
 8240      CAR(K,1,0)=4+CAR(K,7,2)/10
 8250      CAR(K,1,1)=4+CAR(K,7,2)/10
 8260    NEXT
 8270  '***************TAMANOHAYASA
 8280   PLTIME=0:DPLTIME=2
 8290   CAR(5,1,3)=(-.5+RND(2))*(.8+RND(40)/100)*3:CAR(5,1,2)=(-.5+RND(2))*(.8+RND(40)/100)*3
 8300   CAR(6,1,3)=(-.5+RND(2))*(.8+RND(40)/100)*3:CAR(6,1,2)=(-.5+RND(2))*(.8+RND(40)/100)*3
 8310  '
 8320  '*************ﾃﾝｽｳﾋｮｳ
 8330   LOCATE 0,3:PRINT "ﾎﾟｹﾎﾟｹﾀﾁ"
 8340     FOR LI=6 TO 72: LINE (LI,31)-(LI+1,41),RGB(5+(LI+5)/3,8,9),BF:NEXT
 8350   LOCATE 31,3:PRINT "ｷﾐﾉﾄｸﾃﾝ"
 8360     FOR LI=255 TO 312: LINE (LI,31)-(LI+1,41),RGB(9,8,5+(LI-240)/3),BF:NEXT
 8370   FOR COL=-255 TO 0 STEP 6:COLOROFS (COL,COL,COL):VSYNC :NEXT
 8380  '*************ﾓｼﾞﾋｮｳｼﾞ
 8390   PTIMES=3+RND(3)
 8400   IF PWIN(0)>0 THEN LOCATE 12,7:PRINT PWIN(0);"ｶｲ ﾚﾝｿﾞｸﾃﾞｶｯﾃﾙﾖ!!"
 8410   LOCATE 12,8:PRINT PTIMES;"ｶｲﾃﾞｼｮｳﾌﾞﾀﾞ~!!"
 8420   LOCATE 12,9:PRINT "A ﾎﾞﾀﾝｵｽﾄ ﾊｼﾞﾏﾙﾖ"
 8430   LOCATE 12,10:PRINT "B ﾎﾞﾀﾝｵｽﾄ ﾔﾒﾙﾖ"
 8440     PLAY1=3:'**ｼﾞｭﾝﾋﾞｶﾝﾘｮｳ
 8450   MOS=1:DMYG=0:DOBG=0
 8460   ALLFG=0:MYGOALF=0
 8470   PLTIME=0:DPLTIME=2
 8480   DDTYA=1:DTAMASPEED=1
 8490  '
 8510 *PLAYWAIT
 8520   COLOROFS OFF :COLOROFS ON,4
 8530   COLOROFS (WCOLOR,WCOLOR/2,WCOLOR/1.5):WCOLOR=WCOLOR+1
 8540   IF WCOLOR>=255 THEN WCOLOR=-255
 8550    IF PLAY1=4 THEN
 8560       LOCATE 12,7:PRINT "                        "
 8570       LOCATE 12,8:PRINT "                        "
 8580       LOCATE 12,9:PRINT "                        "
 8590       LOCATE 12,10:PRINT "                       "
 8600       GOTO *PLAYSTART
 8610    ENDIF
 8620    IF PLAYST=1 THEN
 8630       LOCATE 12,7:PRINT "                        "
 8640       LOCATE 12,8:PRINT "                        "
 8650       LOCATE 12,9:PRINT "                        "
 8660       LOCATE 12,10:PRINT "                       "
 8670       GOTO *ASOBIEND2
 8680    ENDIF
 8690    MOS=MOS+RND(100)/100
 8700    IF MOS>3 THEN MOS=1
 8710  GOTO *PLAYWAIT
 8720  '
 8740 *PLAYSTART
 8750  '
 8760  COLOROFS OFF,4
 8770  LOCATE 10,1:PRINT "ｺﾞｳｹｲ";PWIN(1);"ｶｲｶｯﾃﾙﾖ!!"
 8780  '
 8790  '
 8800  '*********ﾀﾏﾉｲﾄﾞｳ
 8810  IF ABS(CAR(6,1,0)-CAR(5,1,0))<10 AND ABS(CAR(6,1,1)-CAR(5,1,1))<10 THEN
 8820     CAR(6,1,2)=-CAR(6,1,2)*(1+RND(101)/1000)
 8830     CAR(6,1,3)=-CAR(6,1,3)*(1+RND(101)/1000)
 8840     CAR(5,1,2)=-CAR(5,1,2)*(1+RND(101)/1000)
 8850     CAR(5,1,3)=-CAR(5,1,3)*(1+RND(101)/1000)
 8860  ENDIF
 8870  '
 8880  '*********ﾔｼﾞﾙｼﾉﾑｷ
 8890          FOR YAMUK=17 TO 18
 8900             IF YAMUKI(YAMUK)>9 OR YAMUKI(YAMUK)<2 THEN DTYAMUKI(YAMUK)=-DTYAMUKI(YAMUK):YAMUKI(YAMUK)=5
 8910             IF RND(100)=5 OR DTYAMUKI(YAMUK)=0 THEN DTYAMUKI(YAMUK)=(8000+RND(4000))/100000*(.5-RND(2)):HYAMUKI(YAMUK)=RND(2)+1
 8920             YAMUKI(YAMUK)=YAMUKI(YAMUK)+DTYAMUKI(YAMUK)
 8930             OBJ(YAMUK,10)=YAMUKI(YAMUK)
 8940             IF HYAMUKI(YAMUK)>=0 THEN OBJ(YAMUK,20)=0 ELSE OBJ(YAMUK,20)=YAMUK
 8950          NEXT
 8960            '
 8970           '**********ﾔｼﾞﾙｼﾆﾀﾏｶﾞｱﾀｯﾀﾄｷ
 8980             FOR YAMUK=17 TO 18
 8990             FOR K=5 TO 6
 9000             IF YAMUK=17 THEN TX=176:TY=81
 9010             IF YAMUK=18 THEN TX=130:TY=126
 9020              IF ABS(CAR(K,1,0)-TX)<17 AND ABS(CAR(K,1,1)-TY)<17 AND HYAMUKI(YAMUK)>0 THEN
 9030                    MYAMUKI(YAMUK)=YAMUKI(YAMUK)-INT(YAMUKI(YAMUK))
 9040                    DTYA=3+DDTYA*CAR(2+RND(3),7,2)/10
 9050                    CAR(K,1,2)=SIN(6.2832*MYAMUKI(YAMUK))*DTYA
 9060                    CAR(K,1,3)=SIN(4.7124+6.2832*MYAMUKI(YAMUK))*DTYA
 9070              ENDIF
 9080             NEXT
 9090             NEXT
 9100             FOR K=2 TO 4
 9110           '*********TAMA1 GA JIBUNNNO TIKAKUNI KITATOKI
 9120                 IF IF1(K)=3 THEN
 9130                   IF (CAR(6,1,0)<CAR(5,1,0) AND TAMA(1)<>1) OR TAMA(2)=1 THEN
 9140                      GOSUB *TAMAIDOU1
 9150                      GOTO *ENDIF1
 9160                   ENDIF
 9170                 ENDIF
 9180                 IF IF1(K)=4 THEN
 9190                   IF (CAR(6,1,0)>CAR(5,1,0) AND TAMA(1)<>1) OR TAMA(2)=1 THEN
 9200                     GOSUB *TAMAIDOU1
 9210                     GOTO *ENDIF1
 9220                   ENDIF
 9230                 ENDIF
 9240                 IF IF1(K)=1 THEN
 9250                   IF (CAR(6,1,1)<CAR(5,1,1) AND TAMA(1)<>1) OR TAMA(2)=1 THEN
 9260                     GOSUB *TAMAIDOU3
 9270                     GOTO *ENDIF1
 9280                   ENDIF
 9290                 ENDIF
 9300                 IF IF1(K)=2 THEN
 9310                   IF (CAR(6,1,1)>CAR(5,1,1) AND TAMA(1)<>1) OR TAMA(2)=1 THEN
 9320                     GOSUB *TAMAIDOU3
 9330                     GOTO *ENDIF1
 9340                   ENDIF
 9350                 ENDIF
 9360           '*********TAMA2 GA JIBUNNNO TIKAKUNI KITATOKI
 9370                 IF IF1(K)=3 THEN
 9380                   IF (CAR(5,1,0)<CAR(6,1,0) AND TAMA(2)<>1) OR TAMA(1)=1 THEN
 9390                     GOSUB *TAMAIDOU2
 9400                     GOTO *ENDIF1
 9410                   ENDIF
 9420                 ENDIF
 9430                 IF IF1(K)=4 THEN
 9440                   IF (CAR(5,1,0)>CAR(6,1,0) AND TAMA(2)<>1) OR TAMA(1)=1 THEN
 9450                     GOSUB *TAMAIDOU2
 9460                     GOTO *ENDIF1
 9470                   ENDIF
 9480                 ENDIF
 9490                 IF IF1(K)=1 THEN
 9500                   IF (CAR(5,1,1)<CAR(6,1,1) AND TAMA(2)<>1) OR TAMA(1)=1 THEN
 9510                     GOSUB *TAMAIDOU4
 9520                     GOTO *ENDIF1
 9530                   ENDIF
 9540                 ENDIF
 9550                 IF IF1(K)=2 THEN
 9560                   IF (CAR(5,1,1)>CAR(6,1,1) AND TAMA(2)<>1) OR TAMA(1)=1 THEN
 9570                     GOSUB *TAMAIDOU4
 9580                     GOTO *ENDIF1
 9590                   ENDIF
 9600                 ENDIF
 9610          '
 9630 *ENDIF1
 9640           '*********ｷｬﾗﾉﾋｮｳｼﾞﾄ ﾋｮｳｼﾞｮｳｳﾄ ｳｺﾞｸﾊﾔｻ
 9650           '[R618D-------------------------------
 9660              IF TOBI=1 THEN TOBI=0:GOTO *TOBI1
 9670                 IF IF1(K)<=2 AND CAR(K,0,0)<=194 AND CAR(K,0,0)>=110 THEN
 9680                     CAR(K,0,0)=CAR(K,0,0)+CAR(K,1,0)
 9690                   IF CAR(K,0,0)>194 THEN CAR(K,0,0)=194
 9700                   IF CAR(K,0,0)<110 THEN CAR(K,0,0)=110
 9710                 ENDIF
 9720                   IF IF1(K)=2 THEN CAR(K,0,1)=185
 9730                   IF IF2<>-1 THEN OBJ(K,4)=CAR(K,0,0)+CAR(K,0,6)*(25+K),CAR(K,0,1),0
 9740         '
 9750                 IF IF1(K)>=3 AND CAR(K,0,1)<=146 AND CAR(K,0,1)>=62 THEN
 9760                     CAR(K,0,1)=CAR(K,0,1)+CAR(K,1,1)
 9770                   IF CAR(K,0,1)>146 THEN CAR(K,0,1)=146
 9780                   IF CAR(K,0,1)<62 THEN CAR(K,0,1)=62
 9790                 ENDIF
 9800                   IF IF1(K)=4 THEN CAR(K,0,0)=234
 9810                    IF IF2(K)<>-1 THEN OBJ(K,4)=CAR(K,0,0)+CAR(K,0,6)*(25+K),CAR(K,0,1)+CAR(K,1,1),0
 9820                    IF IF2(K)=-1 THEN OBJ(K,4)=CAR(K,0,0)+(25+K),CAR(K,0,1)+CAR(K,1,1),0
 9830         '
 9850 *TOBI1
 9860         '
 9870         '619        IF GOKIGEN>=1 THEN OBJ(K+2,16)=4+5*K,4+5*K:DDTIME=DDTIME+1
 9880         '619        IF HUMAN>=1 THEN OBJ(K+2,16)=3+5*K,3+5*K:DDTIME=DDTIME+1
 9890           'R618D]--------------------------------
 9900             NEXT
 9910           '********ｼﾞﾌﾞﾝﾉﾁｶｸﾆ ﾀﾏｶﾞｷﾀﾄｷ
 9920           '[R618B--------------------------------------------------------------
 9930             FOR TAMANO=5 TO 6
 9940          '
 9950              IF TAMA(7-TAMANO)=1 THEN GOTO *ENDIF2
 9960          '
 9970                 IF PLAYSET=1 THEN
 9980                   IF CAR(TAMANO,1,1)<PADY+3 AND TAMA(7-TAMANO)<>1 THEN
 9990                     IF PADX<=CAR(TAMANO,1,0)+16 AND PADX>=CAR(TAMANO,1,0)-16 THEN
10000                       CAR(TAMANO,1,3)=-CAR(TAMANO,1,3)*(1+RND(10)/100)
10010                         IF RND(4)>=1 THEN
10020                            CAR(TAMANO,1,2)=((ABS(CAR(TAMANO,1,2))+ABS(CAR(TAMANO,1,3)))*(.8+RND(40)/100))/2
10030                         ENDIF
10040                       CAR(TAMANO,1,1)=PADY+3
10050                       GOTO *ENDIF2
10060                     ENDIF
10070                   ENDIF
10080                 ENDIF
10090           '
10100                 IF PLAYSET=2 THEN
10110                   IF CAR(TAMANO,1,1)>PADY-22 AND TAMA(7-TAMANO)<>1 THEN
10120                     IF PADX<=CAR(TAMANO,1,0)+16 AND PADX>=CAR(TAMANO,1,0)-16 THEN
10130                       CAR(TAMANO,1,3)=-CAR(TAMANO,1,3)*(1+RND(10)/100)
10140                         IF RND(4)>=1 THEN
10150                            CAR(TAMANO,1,2)=((ABS(CAR(TAMANO,1,2))+ABS(CAR(TAMANO,1,3)))*(.8+RND(40)/100))/2
10160                         ENDIF
10170                       CAR(TAMANO,1,1)=PADY-22
10180                       GOTO *ENDIF2
10190                     ENDIF
10200                   ENDIF
10210                 ENDIF
10220           '
10230                 IF PLAYSET=3 THEN
10240                   IF CAR(TAMANO,1,0)<PADX+3 AND TAMA(7-TAMANO)<>1 THEN
10250                     IF PADY<=CAR(TAMANO,1,1)+16 AND PADY>=CAR(TAMANO,1,1)-16 THEN
10260                       CAR(TAMANO,1,2)=-CAR(TAMANO,1,2)*(1+RND(10)/100)
10270                         IF RND(4)>=1 THEN
10280                            CAR(TAMANO,1,3)=((ABS(CAR(TAMANO,1,2))+ABS(CAR(TAMANO,1,3)))*(.8+RND(40)/100))/2
10290                         ENDIF
10300                       CAR(TAMANO,1,0)=PADX+3
10310                      GOTO *ENDIF2
10320                     ENDIF
10330                   ENDIF
10340                 ENDIF
10350           '
10360                 IF PLAYSET=4 THEN
10370                   IF CAR(TAMANO,1,0)>PADX-27 AND TAMA(7-TAMANO)<>1 THEN
10380                     IF PADY<=CAR(TAMANO,1,1)+16 AND PADY>=CAR(TAMANO,1,1)-16 THEN
10390                       CAR(TAMANO,1,2)=-CAR(TAMANO,1,2)*(1+RND(10)/100)
10400                         IF RND(4)>=1 THEN
10410                            CAR(TAMANO,1,3)=((ABS(CAR(TAMANO,1,2))+ABS(CAR(TAMANO,1,3)))*(.8+RND(40)/100))/2
10420                         ENDIF
10430                       CAR(TAMANO,1,0)=PADX-27
10440                       GOTO *ENDIF2
10450                     ENDIF
10460                   ENDIF
10470                 ENDIF
10480                 '
10490                 IF CAR(TAMANO,1,1)<50 THEN
10500                   IF CAR(TAMANO,1,0)>197 OR CAR(TAMANO,1,0)<105 THEN
10510                     IF TAMA(7-TAMANO)<>1 THEN
10520                       CAR(TAMANO,1,3)=-CAR(TAMANO,1,3)*(1+RND(10)/100)
10530                       CAR(TAMANO,1,2)=CAR(TAMANO,1,2)*(.5-RND(2))*2
10540                       CAR(TAMANO,1,1)=50
10550                       GOTO *ENDIF2
10560                     ENDIF
10570                   ENDIF
10580                 ENDIF
10590                 IF CAR(TAMANO,1,1)>158 THEN
10600                   IF CAR(TAMANO,1,0)>197 OR CAR(TAMANO,1,0)<105 THEN
10610                     IF TAMA(7-TAMANO)<>1 THEN
10620                       CAR(TAMANO,1,3)=-CAR(TAMANO,1,3)*(1+RND(10)/100)
10630                       CAR(TAMANO,1,2)=CAR(TAMANO,1,2)*(.5-RND(2))*2
10640                       CAR(TAMANO,1,1)=158
10650                       GOTO *ENDIF2
10660                     ENDIF
10670                   ENDIF
10680                 ENDIF
10690                 IF CAR(TAMANO,1,0)<98 THEN
10700                   IF CAR(TAMANO,1,1)>151 OR CAR(TAMANO,1,1)<57 THEN
10710                     IF TAMA(7-TAMANO)<>1 THEN
10720                       CAR(TAMANO,1,2)=-CAR(TAMANO,1,2)*(1+RND(10)/100)
10730                       CAR(TAMANO,1,3)=CAR(TAMANO,1,3)*(.5-RND(2))*2
10740                       CAR(TAMANO,1,0)=98
10750                       GOTO *ENDIF2
10760                     ENDIF
10770                   ENDIF
10780                 ENDIF
10790                 IF CAR(TAMANO,1,0)>204 THEN
10800                   IF CAR(TAMANO,1,1)>151 OR CAR(TAMANO,1,1)<57 THEN
10810                     IF TAMA(7-TAMANO)<>1 THEN
10820                       CAR(TAMANO,1,2)=-CAR(TAMANO,1,2)*(1+RND(10)/100)
10830                       CAR(TAMANO,1,3)=CAR(TAMANO,1,3)*(.5-RND(2))*2
10840                       CAR(TAMANO,1,0)=204
10850                       GOTO *ENDIF2
10860                     ENDIF
10870                   ENDIF
10880                 ENDIF
10900 *ENDIF2
10910             NEXT
10920          '
10930          '************ﾎﾞｰﾙｶﾞｿﾄﾆﾃﾞﾀｶﾄﾞｳｶ 1
10940           IF CAR(6,1,1)>168+5 THEN
10950             IF PLAYSET=2 THEN MYGOALF=MYGOALF+1:MYGOAL=1
10960             GOALF1=1
10970           ENDIF
10980           IF CAR(6,1,1)<45-5 THEN
10990             IF PLAYSET=1 THEN MYGOALF=MYGOALF+1:MYGOAL=1
11000             GOALF1=1
11010           ENDIF
11020           IF CAR(5,1,1)>168+5 THEN
11030             IF PLAYSET=2 THEN MYGOALF=MYGOALF+1:MYGOAL=1
11040             GOALF2=1
11050           ENDIF
11060           IF CAR(5,1,1)<45-5 THEN
11070             IF PLAYSET=1 THEN MYGOALF=MYGOALF+1:MYGOAL=1
11080             GOALF2=1
11090           ENDIF
11100           IF CAR(6,1,0)>211+5 THEN
11110             IF PLAYSET=4 THEN MYGOALF=MYGOALF+1:MYGOAL=1
11120             GOALF1=1
11130           ENDIF
11140           IF CAR(6,1,0)<93-5 THEN
11150             IF PLAYSET=3 THEN MYGOALF=MYGOALF+1:MYGOAL=1
11160             GOALF1=1
11170           ENDIF
11180           IF CAR(5,1,0)>211+5 THEN
11190             IF PLAYSET=4 THEN MYGOALF=MYGOALF+1:MYGOAL=1
11200             GOALF2=1
11210           ENDIF
11220           IF CAR(5,1,0)<93-5 THEN
11230             IF PLAYSET=3 THEN MYGOALF=MYGOALF+1:MYGOAL=1
11240             GOALF2=1
11250           ENDIF
11260          '
11270          '************ﾎﾞｰﾙｶﾞｿﾄﾆﾃﾞﾀｶﾄﾞｳｶ 2
11280            FOR TAMANO=5 TO 6
11290          '
11300            IF TAMA(7-TAMANO)=1 THEN GOTO *ENDIF3
11310              IF CAR(TAMANO,1,1)>158+5 OR CAR(TAMANO,1,1)<50-5 THEN
11320                IF CAR(TAMANO,1,0)<105-5 OR CAR(TAMANO,1,0)>197+5 THEN
11330                  IF TAMA=6 THEN GOALF1=1
11340                  IF TAMA=5 THEN GOALF2=1
11350                ENDIF
11360              ENDIF
11370          '
11380              IF CAR(TAMANO,1,0)>204+5 OR CAR(TAMANO,1,0)<98-5 THEN
11390                IF CAR(TAMANO,1,1)<57-5 OR CAR(TAMANO,1,1)>151+5 THEN
11400                  IF TAMA=6 THEN GOALF1=1
11410                  IF TAMA=5 THEN GOALF2=1
11420                ENDIF
11430              ENDIF
11440          '
11460 *ENDIF3
11470            NEXT
11480          'R618B]-----------------------------------
11490          '
11500          IF DDTIME>=500 THEN OBJ(2,16)=KAO(0),KAO(0):OBJ(3,16)=KAO(1),KAO(1):OBJ(4,16)=KAO(2),KAO(2):GOKIGEN=0:HUMAN=0:DDTIME=0
11510           '*********YANO MUKI
11520          '
11530          '
11540            TAMASPEED=1.2+DTAMASPEED*CAR(2+RND(3),7,2)/60
11550                CAR(6,1,0)=CAR(6,1,0)+CAR(6,1,2)*TAMASPEED
11560                CAR(6,1,1)=CAR(6,1,1)+CAR(6,1,3)*TAMASPEED
11570                CAR(5,1,0)=CAR(5,1,0)+CAR(5,1,2)*TAMASPEED
11580                CAR(5,1,1)=CAR(5,1,1)+CAR(5,1,3)*TAMASPEED
11590                IF GOALF1<>1 THEN OBJ(25,4)=CAR(6,1,0),CAR(6,1,1),0
11600                IF GOALF2<>1 THEN OBJ(26,4)=CAR(5,1,0),CAR(5,1,1),0
11610                IF GOALF1=1 THEN OBJ(25,20)=25
11620                IF GOALF2=1 THEN OBJ(26,20)=26
11630 '
11640 '
11650 '
11660            IF MYGOALF=9*(1+DMYG) THEN DMYG=DMYG+1
11670            IF (ALLFG-MYGOALF)=9*(1+DOBG) THEN DOBG=DOBG+1
11680            '
11690                IF GOALF1=1 AND ALLFG<=PTIMES THEN
11700                    IF MYGOAL=1 THEN TAMAZ=4+DMYG*21:MYGOAL=0:ALLFG2=ALLFG2+1:ALLFG3=ALLFG2-DMYG*8 ELSE TAMAZ=288-DOBG*21:ALLFG1=ALLFG1+1:ALLFG3=ALLFG1-DOBG*9
11710                    OBJ(28+ALLFG,20)=0:OBJ(28+ALLFG,16)=59,59:OBJ(28+ALLFG,4)=TAMAZ,16+22*ALLFG3,0:TAMA(1)=1
11720                    ALLFG=ALLFG+1
11730                 IF ALLFG<PTIMES THEN GOALF1=0:TAMA(1)=0:CAR(6,1,0)=130+RND(18):CAR(6,1,1)=90+RND(18):CAR(6,1,3)=(-.5+RND(2))*(.8+RND(40)/100)*3:CAR(6,1,2)=(-.5+RND(2))*(.8+RND(40)/100)*3:OBJ(25,20)=0
11740                ENDIF
11750            '
11760            '
11770                IF GOALF2=1 AND ALLFG<=PTIMES THEN
11780                    IF MYGOAL=1 THEN TAMAZ=4+DMYG*21:MYGOAL=0:ALLFG2=ALLFG2+1:ALLFG3=ALLFG2-DMYG*8 ELSE TAMAZ=288-DOBG*21:ALLFG1=ALLFG1+1:ALLFG3=ALLFG1-DOBG*9
11790                    OBJ(28+ALLFG,20)=0:OBJ(28+ALLFG,16)=60,60:OBJ(28+ALLFG,4)=TAMAZ,16+22*ALLFG3,0:TAMA(2)=1
11800                    ALLFG=ALLFG+1
11810                 IF ALLFG<PTIMES THEN GOALF2=0:TAMA(2)=0:CAR(5,1,0)=130+RND(18):CAR(5,1,1)=90+RND(18):CAR(5,1,3)=(-.5+RND(2))*(.8+RND(40)/100)*3:CAR(5,1,2)=(-.5+RND(2))*(.8+RND(40)/100)*3:OBJ(26,20)=0
11820                ENDIF
11830           '
11840           '
11850           '************ASOBI NO OWARI
11860                IF GOALF1=1 AND GOALF2=1 THEN
11870                   GOKIGEN=4:OWARIF=1:GOTO *ASOBIEND
11880                ENDIF
11890                IF GOALFGST=1 THEN
11900                   GOKIGEN=4:OWARIF=1:GOTO *ASOBIEND
11910                ENDIF
11920                IF ALLFG>=PTIMES THEN
11930                   GOKIGEN=4:OWARIF=1:GOTO *ASOBIEND
11940                ENDIF
11950                '
11960                PLTIME=PLTIME+DPLTIME
11970                IF PLTIME>500 THEN DTAMASPEED=DTAMASPEED*1.1:DDTYA=DDTYA*1.1:PLTIME=0
11980                '
11990                '
12000                '
12010                '
12020            GOTO *PLAYSTART
12030            '
12050 *ASOBIEND:ASHAN=ALLFG
12060            IF MYGOALF<ALLFG-MYGOALF THEN
12070              LOCATE 12,11:PRINT "ｱﾝﾀﾉｶﾁ!!!"
12080              PWIN(0)=PWIN(0)+1
12090              PWIN(1)=PWIN(1)+1
12100            ENDIF
12110            IF MYGOALF=ALLFG-MYGOALF THEN
12120              LOCATE 12,11:PRINT "ﾄﾞｳﾃﾝﾀﾞﾖ!!!"
12130              PWIN(0)=PWIN(0)
12140              PWIN(1)=PWIN(1)
12150            ENDIF
12160            IF MYGOALF>ALLFG-MYGOALF THEN
12170              LOCATE 12,11:PRINT "ﾎﾟｹﾎﾟｹﾀﾁﾉ ｶﾁ!!"
12180               FOR K=2 TO 4
12190                CAR(K,6,0)=CAR(K,6,0)+50
12200               NEXT
12210              PWIN(0)=0
12220              PWIN(1)=PWIN(1)
12230            ENDIF
12240              LOCATE 12,14:PRINT "ﾅﾝｶ ﾎﾞﾀﾝｵｼﾃ ｸﾚ"
12250              OUTOU=2:COLOROFS ON,4
12260         VSYNC 5
12280 *OUTOUMATI
12290         '
12300         LOCATE 10,1:PRINT "                    "
12310         '*********ﾓｼﾞﾉﾃｶﾘ
12320         IF MYGOALF<=ALLFG-MYGOALF THEN
12330            COLOROFS (COL,COL,COL/2):COL=COL+.05
12340          ELSE
12350            COLOROFS (COL,COL,COL/2):COL=COL+.1
12360         ENDIF
12370         IF ABS(COL)>255 THEN COL=0
12380         '
12390         IF (PA+PB+PC+PS)=0 THEN GOTO *OUTOUMATI
12400         '
12410         '
12430 *ASOBIEND2
12440            COLOROFS ON :FOR COL=0 TO -255 STEP -5:COLOROFS (COL,COL,COL):VSYNC :NEXT
12450         '
12460            OUTOU=0:ALLFG=0:PLAYST=0:GOALFGST=0:MYGOAL=0:DMYG=0:DOBG=0
12470              LOCATE 12,11:PRINT "                                 "
12480              LOCATE 12,14:PRINT "                                 "
12490            PLAYSET=0:PFLAG=0:JK=0:PLAY1=0:MYGOALF=0:GOALF1=0:GOALF2=0:TAMA(1)=0:TAMA(2)=0:ALLFG=0:ALLFG1=0:ALLFG2=0:ALLFG3=0
12500            CAR(6,1,3)=(RND(101)/1000+1):CAR(6,1,2)=(RND(100)/1000+1)
12510            CAR(5,1,3)=(RND(101)/1000+1):CAR(5,1,2)=(RND(101)/1000+1)
12520            '
12530            GOSUB *SUB2:GOSUB *SUB3
12540            GOSUB *JIMEN:GOSUB *SORA
12550            FOR K=2 TO 4
12560              OBJ(K,20)=CAR(K,7,1):IF1(K)=0:CAR(K,0,6)=0
12570              CAR(K,0,0)=RND(320):CAR(K,0,1)=20+RND(80)
12580            NEXT
12590         LOCATE 0,3:PRINT "                           "
12600         LOCATE 31,3:PRINT "                      "
12610         '
12620         '
12630           MOSAIC (1,1)
12640         '
12650         '
12660         '
12670         '********ｷｬﾗﾉﾊﾟﾗﾉﾍﾝｶ
12680         '
12690         IF ASHAN>13 THEN
12700            FOR K=0 TO 2
12710              CAR(K,3,0)=CAR(K,3,0)-100:'ONAKA
12720              CAR(K,6,0)=CAR(K,6,0)+100:'GOKIGEN
12730              CAR(K,5,0)=CAR(K,5,0)+50:'NEMUSA
12740            NEXT
12750         ENDIF
12760         '
12770          '*********ｱｲｺﾝﾉﾎｿﾞﾝ
12780         OBJ(5,20)=MASIH
12790         OBJ(6,20)=BENKH
12800         OBJ(5,4)=OBJX(5),OBJY(5)
12810         OBJ(6,4)=OBJX(6),OBJY(6)
12820 '
12830             FOR COL=-255 TO 0 STEP 6:COLOROFS (COL,COL,COL):VSYNC :NEXT
12840     '
12850            '
12860            '
12870            '
12880 '  '*********ｺﾞﾊﾝﾄｶｦｹｽ
12890 '   IF MESI=3 THEN
12900 ''      OBJ(5,20)=5
12910 '      OBJ(5,4)=0,0,5
12920 '      FOR MESIK=2 TO 4
12930 '        CAR(K,3,2)=0
12940 '      NEXT
12950 '      CAR(5,0,0)=0
12960 '      MESI=0
12970 '   ENDIF
12980 '   '******ﾍﾞﾝｷｮｳﾉｲﾄﾞｳ
12990 '   IF BENK=3 THEN
13000 '     IF CAR(6,0,0)<5 THEN
13010 '       OBJ(6,20)=6
13020 '       OBJ(6,4)=0,0,5
13030 '       FOR BENKK=2 TO 4
13040 '         CAR(K,4,2)=0
13050 '       NEXT
13060 '       CAR(6,0,0)=0
13070 '       BENK=0
13080 '     ENDIF
13090 '   ENDIF
13100 '
13110 '
13120 '
13130 RETURN
13140 '
13160 *TAMAIDOU1
13170             IF IF1(K)=3 AND CAR(K,0,0)>CAR(6,1,0)-23 THEN
13180               IF CAR(K,0,1)<=CAR(6,1,1)+21 AND CAR(K,0,1)>=CAR(6,1,1)-21 THEN
13190                  CAR(6,1,2)=-CAR(6,1,2)*(1+RND(6)/100)
13200        '                 IF RND(4)>=1 THEN
13210                            CAR(6,1,3)=((ABS(CAR(6,1,2))+ABS(CAR(6,1,3)))*(1+RND(6)/100))*(-.5+RND(2))
13220        '                 ENDIF
13230                  CAR(6,1,0)=CAR(K,0,0)+23
13240               ENDIF
13250             ENDIF
13260             IF IF1(K)=4 AND CAR(K,0,0)<CAR(6,1,0)+23 THEN
13270               IF CAR(K,0,1)<=CAR(6,1,1)+21 AND CAR(K,0,1)>=CAR(6,1,1)-21 THEN
13280                  CAR(6,1,2)=-CAR(6,1,2)*(1+RND(6)/100)
13290        '                 IF RND(4)>=1 THEN
13300                            CAR(6,1,3)=((ABS(CAR(6,1,2))+ABS(CAR(6,1,3)))*(1+RND(6)/100))*(-.5+RND(2))
13310        '                 ENDIF
13320                  CAR(6,1,0)=CAR(K,0,0)-23
13330               ENDIF
13340             ENDIF
13350             IF CAR(K,0,1)>=CAR(6,1,1) THEN CAR(K,1,1)=-1*ABS(CAR(K,1,1)) ELSE CAR(K,1,1)=ABS(CAR(K,1,1))
13360             IF ABS(CAR(K,0,1)-CAR(6,1,1))<9 THEN TOBI=1
13370           RETURN
13380           '
13400 *TAMAIDOU2
13410             IF IF1(K)=3 AND CAR(K,0,0)>CAR(5,1,0)-23 THEN
13420               IF CAR(K,0,1)<=CAR(5,1,1)+21 AND CAR(K,0,1)>=CAR(5,1,1)-21 THEN
13430                  CAR(5,1,2)=-CAR(5,1,2)*(1+RND(6)/100)
13440        '                 IF RND(4)>=1 THEN
13450                            CAR(5,1,3)=((ABS(CAR(5,1,2))+ABS(CAR(5,1,3)))*(1+RND(6)/100))*(-.5+RND(2))
13460        '                 ENDIF
13470                  CAR(5,1,0)=CAR(K,0,0)+23
13480               ENDIF
13490             ENDIF
13500             IF IF1(K)=4 AND CAR(K,0,0)<CAR(5,1,0)+23 THEN
13510               IF CAR(K,0,1)<=CAR(5,1,1)+21 AND CAR(K,0,1)>=CAR(5,1,1)-21 THEN
13520                  CAR(5,1,2)=-CAR(5,1,2)*(1+RND(6)/100)
13530        '                 IF RND(4)>=1 THEN
13540                            CAR(5,1,3)=((ABS(CAR(5,1,2))+ABS(CAR(5,1,3)))*(1+RND(6)/100))*(-.5+RND(2))
13550        '                 ENDIF
13560                  CAR(5,1,0)=CAR(K,0,0)-23
13570               ENDIF
13580             ENDIF
13590             IF CAR(K,0,1)>=CAR(5,1,1) THEN CAR(K,1,1)=-1*ABS(CAR(K,1,1)) ELSE CAR(K,1,1)=ABS(CAR(K,1,1))
13600             IF ABS(CAR(K,0,1)-CAR(6,1,1))<9 THEN TOBI=1
13610           RETURN
13620           '
13640 *TAMAIDOU3
13650             IF IF1(K)=1 AND CAR(K,0,1)>CAR(6,1,1)-22 THEN
13660               IF CAR(K,0,0)<=CAR(6,1,0)+21 AND CAR(K,0,0)>=CAR(6,1,0)-21 THEN
13670                  CAR(6,1,3)=-CAR(6,1,3)*(1+RND(6)/100)
13680        '                 IF RND(4)>=1 THEN
13690                            CAR(6,1,2)=((ABS(CAR(6,1,2))+ABS(CAR(6,1,3)))*(1+RND(6)/100))*(-.5+RND(2))
13700        '                 ENDIF
13710                  CAR(6,1,1)=CAR(K,0,1)+22
13720               ENDIF
13730             ENDIF
13740             IF IF1(K)=2 AND CAR(K,0,1)<CAR(6,1,1)+17 THEN
13750               IF CAR(K,0,0)<=CAR(6,1,0)+21 AND CAR(K,0,0)>=CAR(6,1,0)-21 THEN
13760                  CAR(6,1,3)=-CAR(6,1,3)*(1+RND(6)/100)
13770        '                 IF RND(4)>=1 THEN
13780                            CAR(6,1,2)=((ABS(CAR(6,1,2))+ABS(CAR(6,1,3)))*(1+RND(6)/100))*(-.5+RND(2))
13790        '                 ENDIF
13800                  CAR(6,1,1)=CAR(K,0,1)-17
13810               ENDIF
13820             ENDIF
13830             IF CAR(K,0,0)>=CAR(6,1,0) THEN CAR(K,1,0)=-1*ABS(CAR(K,1,0)) ELSE CAR(K,1,0)=ABS(CAR(K,1,0))
13840             IF ABS(CAR(K,0,0)-CAR(6,1,0))<14 THEN TOBI=1
13850           RETURN
13860           '
13880 *TAMAIDOU4
13890             IF IF1(K)=1 AND CAR(K,0,1)>CAR(5,1,1)-22 THEN
13900               IF CAR(K,0,0)<=CAR(5,1,0)+21 AND CAR(K,0,0)>=CAR(5,1,0)-21 THEN
13910                  CAR(5,1,3)=-CAR(5,1,3)*(1+RND(6)/100)
13920        '                 IF RND(4)>=1 THEN
13930                            CAR(5,1,2)=((ABS(CAR(5,1,2))+ABS(CAR(5,1,3)))*(1+RND(6)/100))*(-.5+RND(2))
13940        '                 ENDIF
13950                  CAR(5,1,1)=CAR(K,0,1)+22
13960               ENDIF
13970             ENDIF
13980             IF IF1(K)=2 AND CAR(K,0,1)<CAR(5,1,1)+17 THEN
13990               IF CAR(K,0,0)<=CAR(5,1,0)+21 AND CAR(K,0,0)>=CAR(5,1,0)-21 THEN
14000                  CAR(5,1,3)=-CAR(5,1,3)*(1+RND(6)/100)
14010        '                 IF RND(4)>=1 THEN
14020                            CAR(5,1,2)=((ABS(CAR(5,1,2))+ABS(CAR(5,1,3)))*(1+RND(6)/100))*(-.5+RND(2))
14030        '                 ENDIF
14040                  CAR(5,1,1)=CAR(K,0,1)-17
14050               ENDIF
14060             ENDIF
14070             IF CAR(K,0,0)>=CAR(5,1,0) THEN CAR(K,1,0)=-1*ABS(CAR(K,1,0)) ELSE CAR(K,1,0)=ABS(CAR(K,1,0))
14080             IF ABS(CAR(K,0,0)-CAR(5,1,0))<14 THEN TOBI=1
14090           RETURN
14100            '
14110            '
14120 '((((((((((((((((
14130 '))))))))))))ｾｰﾌﾞ
14150 *TKSAVE
14160   '*********ｱｲｺﾝﾉﾎｿﾞﾝ
14170    MASIH=OBJ(5,20)
14180    BENKH=OBJ(6,20)
14190    CLS
14200    COLOROFS ON :FOR COL=0 TO -125 STEP -5:COLOROFS (COL,COL,COL):VSYNC :NEXT
14220 *TKSAVE2
14230    COLOROFS OFF,4
14240    FOR K=1 TO 99
14250     OBJ(K,20)=K
14260    NEXT
14270      LOCATE 10,7:PRINT ""
14280      LOCATE 10,8:PRINT "ﾎﾝﾄｳﾆ ｾｰﾌﾞ ｽﾙﾉ ??   "
14290      LOCATE 10,9:PRINT "ｾｰﾌﾞｽﾙﾅﾗ A ﾎﾞﾀﾝｵｼﾃ!!"
14300      LOCATE 10,10:PRINT ""
14310      IF TSAVE=1 THEN GOTO *TKSAVE2
14320      IF TSAVE=2 THEN GOSUB *SAVE1 ELSE LOCATE 12,12:PRINT "ﾁｭｳｼｼﾀﾖ!!":VSYNC 90
14330      CLS
14340      GOSUB *SUB2:GOSUB *SUB3:GOSUB *SORA:GOSUB *JIMEN
14350     COLOROFS ON :FOR COL=-125 TO 0 STEP 5:COLOROFS (COL,COL,COL):VSYNC :NEXT
14360    '*********ｱｲｺﾝﾉﾎｿﾞﾝ
14370     OBJ(5,20)=MASIH
14380     OBJ(6,20)=BENKH
14390 RETURN
14400 '((((((((((((((((
14410 '))))))))))))ﾛｰﾄﾞ
14430 *TKLOAD
14440   '*********ｱｲｺﾝﾉﾎｿﾞﾝ
14450    MASIH=OBJ(5,20)
14460    BENKH=OBJ(6,20)
14470    CLS
14480    COLOROFS ON :FOR COL=0 TO -125 STEP -5:COLOROFS (COL,COL,COL):VSYNC :NEXT
14500 *TKLOAD2
14510    COLOROFS OFF,4
14520    FOR K=1 TO 99
14530     OBJ(K,20)=K
14540    NEXT
14550      LOCATE 10,7:PRINT ""
14560      LOCATE 10,8:PRINT "ﾎﾝﾄｳﾆ ﾛｰﾄﾞ ｽﾙﾉ ??    "
14570      LOCATE 10,9:PRINT "ﾛｰﾄﾞｽﾙﾅﾗ A ﾎﾞﾀﾝｵｼﾃ!! "
14580      LOCATE 10,10:PRINT ""
14590      IF TLOAD=1 THEN GOTO *TKLOAD2
14600      IF TLOAD=2 THEN GOSUB *LOAD1:MASIH=5:BENKH=6 ELSE LOCATE 12,12:PRINT "ﾁｭｳｼｼﾀﾖ!!":VSYNC 90
14610      CLS
14620      GOSUB *SUB2:GOSUB *SUB3:GOSUB *SORA:GOSUB *JIMEN
14630    COLOROFS ON :FOR COL=-125 TO 0 STEP 5:COLOROFS (COL,COL,COL):VSYNC :NEXT
14640   '*********ｱｲｺﾝﾉﾎｿﾞﾝ
14650    OBJ(5,20)=MASIH
14660    OBJ(6,20)=BENKH
14670 RETURN
14680 '((((((((((((((((
14690 '))))))))))))ｾｰﾌﾞ
14710 *SAVE1
14720 ON ERROR GOTO *SAVE_ERR1
14730   LOCATE 12,12:PRINT "ｾｰﾌﾞ ｼﾃﾏｽ･"
14740   OPEN DEV$+"TEKE" FOR OUTPUT AS #1
14750 ON ERROR GOTO *SAVE_ERR2
14760     FOR S1=0 TO 15
14770      FOR S2=0 TO 15
14780       FOR S3=0 TO 15
14790         A$=RIGHT$("         "+STR$(CAR(S1,S2,S3)),9)
14800         FWRITE #1,A$
14810       NEXT
14820      NEXT
14830   LOCATE 21+INT(S1/10),12:PRINT "･"
14840     NEXT
14850     FOR S1=0 TO 98
14860         A$=RIGHT$("         "+STR$(OBJX(S1)),9)
14870         FWRITE #1,A$
14880         A$=RIGHT$("         "+STR$(OBJY(S1)),9)
14890         FWRITE #1,A$
14900         A$=RIGHT$("         "+STR$(OBJH(S1)),9)
14910         FWRITE #1,A$
14920      FOR S2=0 TO 9
14930         A$=RIGHT$("         "+STR$(KUMOSP(S1,S2)),9)
14940         FWRITE #1,A$
14950      NEXT
14960   LOCATE 23+INT(S1/20),12:PRINT "･"
14970     NEXT
14980     FOR S4=1 TO 99
14990      FOR S5=1 TO 20
15000 '     S5=3,7,11,15
15010      IF S5<>3 AND S5<>7 AND S5<>11 AND S5<>15 THEN
15020         A$=RIGHT$("         "+STR$(OBJ(S4,S5)),9)
15030         FWRITE #1,A$
15040      ENDIF
15050      NEXT
15060   LOCATE 26+INT(S4/10),12:PRINT "･"
15070     NEXT
15080         A$=RIGHT$("         "+STR$(OBJHAITI),9)
15090         FWRITE #1,A$
15100         A$=RIGHT$("         "+STR$(TIME),9)
15110         FWRITE #1,A$
15120         A$=RIGHT$("         "+STR$(DTIME),9)
15130         FWRITE #1,A$
15140         A$=RIGHT$("         "+STR$(SKI),9)
15150         FWRITE #1,A$
15160         A$=RIGHT$("         "+STR$(SKI1),9)
15170         FWRITE #1,A$
15180         A$=RIGHT$("         "+STR$(SKI2),9)
15190         FWRITE #1,A$
15200         A$=RIGHT$("         "+STR$(SYAMA),9)
15210         FWRITE #1,A$
15220         A$=RIGHT$("         "+STR$(SIE),9)
15230         FWRITE #1,A$
15240         A$=RIGHT$("         "+STR$(UMI),9)
15250         FWRITE #1,A$
15260         A$=RIGHT$("         "+STR$(KUMO),9)
15270         FWRITE #1,A$
15280         A$=RIGHT$("         "+STR$(PWIN(0)),9)
15290         FWRITE #1,A$
15300         A$=RIGHT$("         "+STR$(PWIN(1)),9)
15310         FWRITE #1,A$
15320   LOCATE 12,13:PRINT "ｵﾜｯﾀﾖ!":VSYNC 80
15330 *SAVE_RE2
15340 ON ERROR GOTO *SAVE_ERR3
15350   CLOSE #1
15360 *SAVE_RE1
15370 ON ERROR GOTO 0
15380 RETURN
15400 *SAVE_ERR1
15410   LOCATE 1,14:PRINT "ｴﾗｰ ｶﾞ ﾃﾞﾀﾉﾃﾞ ｾｰﾌﾞ ﾃﾞｷﾏｾﾝﾃﾞｼﾀ":VSYNC 120
15420 RESUME *SAVE_RE1
15440 *SAVE_ERR2
15450   LOCATE 1,14:PRINT "ｾｰﾌﾞﾁｭｳ ﾆ ｴﾗｰ ｶﾞ ﾃﾞﾏｼﾀ"
15460   LOCATE 1,15:PRINT "ｾｰﾌﾞ ﾃﾞｷﾏｾﾝﾃﾞｼﾀ":VSYNC 120
15470 RESUME *SAVE_RE2
15490 *SAVE_ERR3
15500   LOCATE 1,14:PRINT "ﾃﾞｰﾀ ﾉ ｶｷｺﾐ ﾆ ｴﾗｰ ｶﾞ ﾃﾞﾏｼﾀ"
15510   LOCATE 1,15:PRINT "ｾｰﾌﾞ ﾃﾞｷﾏｾﾝﾃﾞｼﾀ":VSYNC 120
15520 RESUME *SAVE_RE1
15530 '((((((((((((((((
15540 '))))))))))))ﾛｰﾄﾞ
15560 *LOAD1
15570 ON ERROR GOTO *LOAD_ERR1
15580   LOCATE 12,12:PRINT "ﾛｰﾄﾞ ｼﾃﾏｽ･"
15590 ON ERROR GOTO *LOAD_ERR2
15600   OPEN DEV$+"TEKE" FOR INPUT AS #1
15610     FOR S1=0 TO 15
15620      FOR S2=0 TO 15
15630       FOR S3=0 TO 15
15640         FREAD #1,A$,9
15650         CAR(S1,S2,S3)=VAL(A$)
15660       NEXT
15670      NEXT
15680   LOCATE 21+INT(S1/10),12:PRINT "･"
15690     NEXT
15700     FOR S1=0 TO 98
15710         FREAD #1,A$,9
15720         OBJX(S1)=VAL(A$)
15730         FREAD #1,A$,9
15740         OBJY(S1)=VAL(A$)
15750         FREAD #1,A$,9
15760         OBJH(S1)=VAL(A$)
15770      FOR S2=0 TO 9
15780         FREAD #1,A$,9
15790         KUMOSP(S1,S2)=VAL(A$)
15800      NEXT
15810   LOCATE 23+INT(S1/20),12:PRINT "･"
15820     NEXT
15830     FOR S4=1 TO 99
15840      FOR S5=1 TO 20
15850      IF S5<>3 AND S5<>7 AND S5<>11 AND S5<>15 THEN
15860         FREAD #1,A$,9
15870         OBJ(S4,S5)=VAL(A$)
15880      ENDIF
15890      NEXT
15900   LOCATE 26+INT(S4/10),12:PRINT "･"
15910     NEXT
15920         FREAD #1,A$,9
15930         OBJHAITI=VAL(A$)
15940         FREAD #1,A$,9
15950         TIME=VAL(A$)
15960         FREAD #1,A$,9
15970         DTIME=VAL(A$)
15980         FREAD #1,A$,9
15990         SKI=VAL(A$)
16000         FREAD #1,A$,9
16010         SKI1=VAL(A$)
16020         FREAD #1,A$,9
16030         SKI2=VAL(A$)
16040         FREAD #1,A$,9
16050         SYAMA=VAL(A$)
16060         FREAD #1,A$,9
16070         SIE=VAL(A$)
16080         FREAD #1,A$,9
16090         UMI=VAL(A$)
16100         FREAD #1,A$,9
16110         KUMO=VAL(A$)
16120         FREAD #1,A$,9
16130         PWIN(0)=VAL(A$)
16140         FREAD #1,A$,9
16150         PWIN(1)=VAL(A$)
16160   LOCATE 12,13:PRINT "ｻｧ! ﾊｼﾞﾒﾙｯﾍﾟ!":VSYNC 100
16180 *LOAD_RE2
16190 ON ERROR GOTO *LOAD_ERR3
16200   CLOSE #1
16210 *LOAD_RE1
16230 ON ERROR GOTO 0
16240 RETURN
16260 *LOAD_ERR1
16270   LOCATE 1,14:PRINT "ｴﾗｰ ｶﾞ ﾃﾞﾀﾉﾃﾞ ﾛｰﾄﾞ ﾃﾞｷﾏｾﾝﾃﾞｼﾀ":VSYNC 120
16280 RESUME *LOAD_RE1
16300 *LOAD_ERR2
16310   LOCATE 1,14:PRINT "ﾖﾐｺﾐﾁｭｳ ﾆ ｴﾗｰ ｶﾞ ﾃﾞﾏｼﾀ"
16320   LOCATE 1,15:PRINT "ﾛｰﾄﾞ ﾃﾞｷﾏｾﾝﾃﾞｼﾀ":VSYNC 120
16330 RESUME *LOAD_RE2
16350 *LOAD_ERR3
16360   LOCATE 1,14:PRINT "ﾃﾞｰﾀ ﾉ ﾖﾐｺﾐ ﾆ ｴﾗｰ ｶﾞ ﾃﾞﾏｼﾀ"
16370   LOCATE 1,15:PRINT "ﾛｰﾄﾞ ﾃﾞｷﾏｾﾝﾃﾞｼﾀ":VSYNC 120
16380 RESUME *LOAD_RE1
16390 '((((((((((((((((
16400 '))))))))))))ｼﾇ
16420 *DEAD
16430  '
16440  FOR ENOF=0 TO 255 STEP 51:COLOROFS (ENOF,ENOF,ENOF):VSYNC :NEXT
16450  FOR ENOF=255 TO 0 STEP -51:COLOROFS (ENOF,ENOF,ENOF):VSYNC :NEXT
16460   CAR(K,7,1)=1:RDE=0:GDE=0:BDE=0:DRDE=0:DGDE=0:DBDE=0
16470   CAR(7,7,7)=CAR(7,7,7)+1
16480    IF K=2 THEN DRDE=2
16490    IF K=3 THEN DBDE=2
16500    IF K=4 THEN DGDE=2
16510   CLS
16520   COLOROFS OFF,4
16530   DFG=0:DDFG=0:DEAD1=1
16540   RDE=0
16550   GDE=0
16560   BDE=0
16570   DROT1=1:D2ROT=(.5-RND(2))*RND(100)/800:D3ROT=(.5-RND(2))*D2ROT/10:'*****ｷｬﾗﾉｶｲﾃﾝ
16580  '
16590    FOR KD=1 TO 0 STEP -.01
16600  '   OBJ(K,12)=KD,KD
16610      COLOROFS (RDE,GDE,BDE)
16620      RDE=RDE+DRDE
16630      GDE=GDE+DGDE
16640      BDE=BDE+DBDE
16650  '    LOCATE 10,12:PRINT "A ﾎﾞﾀﾝ ﾀﾀｲﾃ!!!"
16660       FOR KDD=2 TO 4
16670         IF CAR(KDD,7,1)<>1 AND CAR(K,7,1)<>2 THEN
16680            OBJ(KDD,12)=1,1
16690            OBJ(KDD,20)=0
16700            OBJ(KDD,4)=160+SIN(D1ROT*KDD)*70,112+COS(D1ROT*KDD)*(40+10*KDD),7
16710         ELSE
16720          IF CAR(KDD,7,1)=1 THEN OBJ(KDD,12)=KD,KD:OBJ(KDD,4)=160,112,0
16730            IF CAR(KDD,7,1)=2 THEN
16740                OBJ(KDD,16)=79,79
16750               IF KDD=2 THEN OBJ(KDD,4)=220,30:OBJ(KDD,12)=1,1
16760               IF KDD=3 THEN OBJ(KDD,4)=280,110:OBJ(KDD,12)=1,1
16770               IF KDD=4 THEN OBJ(KDD,4)=20,110:OBJ(KDD,12)=1,1
16780            ENDIF
16790         ENDIF
16800       NEXT
16810       D2ROT=D2ROT+D3ROT
16820       D1ROT=D1ROT+D2ROT
16830       IF ABS(D2ROT)>=.1 THEN D3ROT=-D3ROT
16840      VSYNC 5
16850    NEXT
16860   '
16870 IF CAR(K,7,1)=1 THEN CAR(K,7,1)=2
16880   '
16890      FOR KD=2 TO 70:OBJH(KD)=OBJ(KD,20):NEXT
16900      FOR KD=2 TO 70:OBJ(KD,20)=KD:NEXT
16910   IF CAR(7,7,7)<>3 THEN
16920    IF K=2 THEN
16930      LOCATE 10,10:PRINT "ﾎﾟｹﾎﾟｹﾊ ﾋｶﾘﾆﾅｯﾀﾖ･･･!!"
16940    ENDIF
16950    IF K=3 THEN
16960      LOCATE 10,10:PRINT "ﾋﾟｹﾋﾟｹﾊ ｸｳｷﾆﾅｯﾀﾖ･･･!!"
16970    ENDIF
16980    IF K=4 THEN
16990      LOCATE 10,10:PRINT "ﾍﾟｹﾍﾟｹﾊ ﾀﾞｲﾁﾆﾅｯﾀﾖ･･･!!!"
17000    ENDIF
17010   ENDIF
17020   '
17030   LOCATE 10,12:PRINT "          "
17040   IF DFG>10 THEN
17050       CAR(K,8,2)=5000:CAR(K,7,1)=0:CAR(7,7,7)=CAR(7,7,7)-1:=4
17060       IF K=2 THEN LOCATE 10,10:PRINT "ﾎﾟｹﾎﾟｹｶﾞ ﾓﾄﾞｯﾃｷﾀﾖ !!!!!!!!!!"
17070       IF K=3 THEN LOCATE 10,10:PRINT "ﾋﾟｹﾋﾟｹｶﾞ ﾓﾄﾞｯﾃｷﾀﾖ !!!!!!!!!!"
17080       IF K=4 THEN LOCATE 10,10:PRINT "ﾍﾟｹﾍﾟｹｶﾞ ﾓﾄﾞｯﾃｷﾀﾖ !!!!!!!!!!"
17090   ENDIF
17100   IF CAR(7,7,7)=3 THEN END1=1:GOSUB *DEADEND
17110    VSYNC 360
17120   FOR KD=0 TO 1 STEP .01
17130     IF CAR(K,7,1)=1 THEN OBJ(K+2,12)=KD,KD
17140     COLOROFS (RDE,GDE,BDE)
17150     RDE=RDE-DRDE
17160     GDE=GDE-DGDE
17170     BDE=BDE-DBDE
17180     VSYNC
17190   NEXT
17200   COLOROFS (0,0,0)
17210   CLS :COLOROFS ON
17220   KBAFF=K
17230   FOR ENOF=0 TO -255 STEP -6:COLOROFS (ENOF,ENOF,ENOF):VSYNC :NEXT
17240      GOSUB *SUB2
17250      GOSUB *SUB3
17260   FOR KD=2 TO 70:OBJ(KD,20)=OBJH(KD):NEXT
17270   FOR ENOF=-255 TO 0 STEP 6:COLOROFS (ENOF,ENOF,ENOF):VSYNC :NEXT
17280   K=KBAFF
17290   '
17300 RETURN
17310 '((((((((((((((((
17320 '))))))))))))ﾐﾝﾅｼﾝﾀﾞﾄｷ
17340 *DEADEND
17350    CLS
17360    COLOROFS (0,0,0)
17370    '
17380    IF TIME>3599 THEN LOCATE 10,19:PRINT "TIME OVER ﾀﾞﾖ!":VSYNC 100
17390    IF CAR(7,7,7)>=3 THEN LOCATE 10,19:PRINT "ﾐﾝﾅ ｲﾅｸﾅｯﾁｬｯﾀ.....":VSYNC 100
17400    '
17410    FOR TEK=2 TO 4:OBJH(TEK)=OBJ(TEK,20):NEXT
17420    FOR TEK=5 TO 70:OBJ(TEK,20)=TEK:NEXT
17430    '
17440    OBJ(2,4)=120,70,0:OBJ(3,4)=160,70,0:OBJ(4,4)=200,70,0
17450 '
17460    IF OBJH(21)=0 THEN
17470       OBJ(59,20)=0
17480       OBJ(59,4)=160,35
17490       FOR TEK=0 TO 1 STEP .01:OBJ(59,12)=TEK,TEK:VSYNC :NEXT
17500    ENDIF
17510 '
17520    LOCATE 10,20:PRINT "ｵﾂｶﾚｻﾏ ｷﾐﾉｿﾀﾞﾃﾀ ﾘｿｳﾉﾀﾞｲﾁﾊ ｺﾝﾅｶﾝｼﾞﾀﾞﾖ !       "
17530    VSYNC 600
17540    LOCATE 10,19:PRINT "                                         "
17550    LOCATE 10,20:PRINT "ﾎﾞｸｶﾞﾐｴﾙ? ﾓｼﾐｴﾀﾗ ｲｲｶﾝｼﾞﾀﾞﾖ!            "
17560    VSYNC 600
17570    LOCATE 10,20:PRINT "ｼﾞｬ､ﾏﾀﾈ!                                        "
17580    VSYNC 600
17590    '******GLOAD ｽﾙ?
17600    FOR ENOF=0 TO -255 STEP -3:COLOROFS (ENOF,ENOF,ENOF):VSYNC :NEXT
17610   GLOAD "CD:TEKEND.1"
17620   COLOROFS ON
17630   CLS
17640    FOR ENOF=-255 TO 0 STEP 6:COLOROFS (ENOF,ENOF,ENOF):VSYNC :NEXT
17650 '
17660 '*****ﾐﾝﾅｼﾝﾀﾞｶﾗ
17680 *DEADLOOP
17690   GOTO *DEADLOOP
17700  'VSYNC 600
17710  '
17720  '
17730    FOR ENOF=0 TO -255 STEP -6:COLOROFS (ENOF,ENOF,ENOF):VSYNC :NEXT
17740  '
17750  '
17760    GOSUB *SUB2
17770    GOSUB *SUB3
17780    END1=0:DTIME=0:TIME=0
17790    TEKE=1
17800    FOR K=2 TO 4:CAR(K,8,2)=9999:NEXT
17810    FOR K=2 TO 4:OBJ(K,4)=OBJH(K):NEXT
17820    CAR(7,7,7)=2
17830    GOSUB *TKSAVE
17840  '
17850    FOR ENOF=-255 TO 0 STEP 3:COLOROFS (ENOF,ENOF,ENOF):VSYNC :NEXT
17860  '
17870  '
17880  '
17890  '
17900  '
17910  '
17920  '
17930  '
17940  '
17950 RETURN
17960 '((((((((((((((((((
17970 '))))))))))))ｼﾞｶﾝｷﾞﾚ
17990 *TIMEUP
18000  GOSUB *DEADEND
18010 RETURN
18020 '((((((((((((((((((
18030 '))))))))))))ｵｰﾌﾟﾆﾝｸﾞ
18050 *FIRST
18060  GOSUB *SUB5
18070  ON INTERVAL (1) GOSUB *STPAD
18080  INTERVAL (1) ON,1
18090 ' COLOROFS ON
18100 'LOCATE 10,10:PRINT "ﾃｹﾃｹ?"
18110 ' FOR L=0 TO 10000
18120 '   RN1=RND(320):RN2=RND(224)
18130 '   LINE (0,0)-(RN1,RN2)
18140 '   IF STENDFG=1 THEN GOTO *ENDFIRST
18150 ' NEXT
18170 *ENDFIRST
18180  FOR L=0 TO 255 STEP 1:COLOROFS (L,L,L):VSYNC :NEXT
18190  FOR L=255 TO -255 STEP -10:COLOROFS (L,L,L):VSYNC :NEXT
18200 ' VSYNC 30
18210  CLS
18220  INTERVAL (1) OFF
18230 RETURN
18240 '((((((((((((((((((((
18250 '
18260 '??????????PAD
18280 *STPAD
18290    P=PAD(PN1,1)
18300   PX1=PAD(PN1,3)
18310   PY1=PAD(PN1,4)
18320    PA=P AND &H400
18330    PB=P AND &H100
18340    PC=P AND &H200
18350    PS=P AND &H800
18360   IF PN2=2 THEN
18370    PR=P AND &H8000
18380    PL=P AND &H4000
18390    PD=P AND &H2000
18400    PU=P AND &H1000
18410   ENDIF
18420   '
18430   TIME=TIME+DTIME
18440   IF (PS+PB+PC+PA)<>0 OR TIME>10 THEN STENDFG=1
18450 RETURN
18470 *PAD1
18480   '
18490   IF ASOBI=1 THEN
18500    IF PLAY1=1 THEN GOTO *PAD1END
18510   ENDIF
18520   '
18530   '
18540   P=PAD(PN1,1)
18550   PX1=PAD(PN1,3)
18560   PY1=PAD(PN1,4)
18570    PA=P AND &H400
18580    PB=P AND &H100
18590    PC=P AND &H200
18600    PS=P AND &H800
18610   IF PN2=2 THEN
18620    PR=P AND &H8000
18630    PL=P AND &H4000
18640    PD=P AND &H2000
18650    PU=P AND &H1000
18660   ENDIF
18670   '
18680   TIME=TIME+DTIME
18690   '********ｱｿﾝﾃﾞﾙﾄｷ
18700   IF PLAY1>=3 THEN
18710     GOSUB *PAD2
18720     GOTO *PAD1END
18730   ENDIF
18740   '********ｷｬﾗｶﾞ ｼﾝﾀﾞﾄｷ
18750   IF DEAD=1 THEN
18760     IF PA<>0 AND PP=0 THEN
18770       DFG=DFG+1
18780     ENDIF
18790     GOTO *PAD1END
18800   ENDIF
18810   '********R ﾎﾞﾀﾝｦｵｼﾅｶﾞﾗﾉﾄｷ
18820   IF PB<>0 THEN
18830     PADD=7:MOUSE=1
18840   ELSE
18850     PADD=3:MOUSE=3
18860   ENDIF
18870 IF PN2=2 THEN
18880   '
18890   '
18900   '
18910   '********CONTRO
18920   '********ﾎｳｺｳﾃﾝｶﾝ
18930   IF PR<>0 AND PADX<304 THEN
18940     PADX=PADX+PADD
18950   ENDIF
18960   IF PL<>0 AND PADX>0 THEN
18970     PADX=PADX-PADD
18980   ENDIF
18990   IF PD<>0 AND PADY<208 THEN
19000     PADY=PADY+PADD
19010   ENDIF
19020   IF PU<>0 AND PADY>0 THEN
19030     PADY=PADY-PADD
19040   ENDIF
19050   'GOTO *PAD1END
19060 ENDIF
19070 '
19080 '*********MOUSE
19090 IF PN2=1 THEN
19100 IF ABS(PX1-PX2)>1000 THEN PX2=PX1
19110 IF ABS(PY1-PY2)>1000 THEN PY2=PY1
19120   IF PADX>=0 AND PADX<310 THEN PADX=PADX+(PX1-PX2)/MOUSE
19130   IF PADY>=0 AND PADY<210 THEN PADY=PADY+(PY1-PY2)/MOUSE
19140   IF PADX<0 OR PADX>310 THEN PADX=PADX+1.001*(PX2-PX1)/MOUSE
19150   IF PADY<0 OR PADY>210 THEN PADY=PADY+1.001*(PY2-PY1)/MOUSE
19160 ENDIF
19170 '
19180  PX2=PX1
19190  PY2=PY1
19200 '
19210 '
19220   IF TSAVE=1 OR TLOAD=1 THEN GOSUB *PADSL:GOTO *PAD1END
19230   '
19240   '*******ﾎﾞﾀﾝｵｼﾀﾄｷ
19250   IF PA<>0 AND PP=0 THEN GOSUB *PA1:GOTO *PAD1END
19260   IF PC<>0 AND PP=0 THEN GOSUB *PC1:GOTO *PAD1END
19270   IF PS<>0 AND PA<>0 AND PB<>0 AND PP=0 THEN GOSUB *PS1:GOTO *PAD1END
19280   '
19290   '*******ﾎﾞﾀﾝﾉｴ
19300   IF PADAFG<>0 OR PADCFG<>0 THEN GOTO *PAD1END
19310   IF PADY<20 THEN PADH=34:GOTO *PAD1END
19320   IF PADY>155 THEN PADH=35:GOTO *PAD1END
19330   PADH=33
19340   '
19360 *PAD1END
19370   '
19380   '*******ﾎﾟｲﾝﾄﾋｮｳｼﾞ
19390   OBJ(1,16)=PADH,PADH
19400   OBJ(1,4)=PADX,PADY,0
19410   '
19420   PP=P
19430 RETURN
19440 '
19450 '*******ﾎﾞﾀﾝｦｵｼﾀﾄｷ
19470 *PA1
19480   LOCK
19490   IF PADY<142 AND PADY>20 THEN
19500     FOR PADK=2 TO 4
19510       IF CAR(PADK,3,2)<>0 OR CAR(PADK,4,2)<>0 THEN GOTO *PA1END
19520       IF CAR(PADK,9,0)=1 THEN CAR(PADK,9,0)=2:PADAFG=0:GOTO *PA1END
19530       IF ABS(CAR(PADK,0,0)-PADX)<30 AND ABS(CAR(PADK,0,1)-PADY)<30 THEN CAR(PADK,9,0)=1:PADAFG=1:PADH=32
19550 *PA1END
19560     NEXT
19570   ENDIF
19580   UNLOCK
19590 RETURN
19610 *PC1
19620   LOCK
19630    IF MESI=2 THEN MESI=3:PADCFG=0:GOSUB *PCM:GOTO *PC1END
19640    IF BENK=2 THEN BENK=3:PADCFG=0:GOSUB *PCB:GOTO *PC1END
19650   IF PADY<20 THEN
19660     IF PADCFG=0 THEN
19670       IF PADX>25 AND PADX<45 THEN
19680        IF MESI=0 THEN MESI=1:PADCFG=1:GOTO *PC1END
19690       ENDIF
19700       IF PADX>65 AND PADX<85 THEN
19710        IF BENK=0 THEN BENK=1:PADCFG=1:GOTO *PC1END
19720       ENDIF
19730       IF PADX>105 AND PADX<125 THEN ASOBI=1:GOTO *PC1END
19740       IF PADX>145 AND PADX<165 THEN TSAVE=1:GOTO *PC1END
19750       IF PADX>185 AND PADX<205 THEN TLOAD=1:GOTO *PC1END
19760     ENDIF
19770   ENDIF
19790 *PC1END
19800   UNLOCK
19810 RETURN
19830 *PCM
19840  OBJX(5)=PADX:OBJY(5)=PADY
19850 RETURN
19870 *PCB
19880  OBJX(6)=PADX:OBJY(6)=PADY
19890 RETURN
19910 *PS1
19920   LOCK
19930   END
19940   UNLOCK
19950 RETURN
19960 '
19970 '*******ｱｿﾋﾞﾉﾄｷ
19990 *PAD2
20000 '*******CONTORO
20010   IF PN2=2 THEN
20020    IF JK=0 THEN
20030      IF PR<>0 AND PADX<=190 THEN PADX=PADX+5
20040      IF PL<>0 AND PADX>=114 THEN PADX=PADX-5
20050      PADH=65
20060    ELSE
20070      IF PD<>0 AND PADY<=142 THEN PADY=PADY+5
20080      IF PU<>0 AND PADY>=66 THEN PADY=PADY-5
20090      PADH=66
20100    ENDIF
20110   ENDIF
20120 '*******MOUSE
20130   IF PN2=1 THEN
20140     IF ABS(PX1-PX2)>1000 THEN PX2=PX1
20150     IF ABS(PY1-PY2)>1000 THEN PY2=PY1
20160    IF JK=0 THEN
20170       IF PADX<=190 AND PADX>=114 THEN PADX=PADX+(PX1-PX2)/PMOUSE
20180       IF PADX>190 OR PADX<114 THEN PADX=PADX+(PX2-PX1)/PMOUSE
20190       PADH=65
20200    ELSE
20210      IF JK=1 THEN
20220       IF PADY<=142 AND PADY>=66 THEN PADY=PADY+(PY1-PY2)/PMOUSE
20230       IF PADY>142 OR PADY<66 THEN PADY=PADY+(PY2-PY1)/PMOUSE
20240       PADH=66
20250      ENDIF
20260    ENDIF
20270   PX2=PX1
20280   PY2=PY1
20290   ENDIF
20300 '
20310    IF PA<>0 AND PP=0 AND PLAY1=3 THEN KAISI=1:PLAY1=4
20320    IF PS<>0 AND PB<>0 AND PP=0 AND PLAY1=4 THEN GOALFGST=1
20330    IF PB<>0 AND PP=0 AND PLAY1=3 THEN PLAYST=1
20340    IF P<>0 AND PP=0 AND OUTOU=2 THEN OUTOU=1
20350 RETURN
20360 '
20370 '*******ｾｰﾌﾞﾛｰﾄﾞﾉﾄｷ
20390 *PADSL
20400    IF TSAVE=1 AND PA<>0 AND PP=0 THEN TSAVE=2
20410    IF TLOAD=1 AND PA<>0 AND PP=0 THEN TLOAD=2
20420    IF TSAVE=1 AND PC<>0 AND PP=0 THEN TSAVE=3
20430    IF TLOAD=1 AND PC<>0 AND PP=0 THEN TLOAD=3
20440 RETURN
20450 '?????????????
20460 '
20470 '^^^^^^^^^^^^^^^^^^^ｿﾗﾄｼﾞﾒﾝｦｴｶﾞｸ
20490 *SORA
20500 IF CAR(2,7,2)>0 THEN
20510   SR=6
20520   SG=4
20530   SB=10
20540   YSORA=20+5*CAR(2,7,2)
20550   IF YSORA>88 THEN YSORA=88
20560   FOR Y=20 TO YSORA STEP 1
20570     LINE (0,Y)-(320,Y+2),RGB(SR,SG,SB),BF
20580     SB=SB+.7:SR=SR+.28:SG=SG+.27
20590     IF SB>31 THEN SB=SB-.7
20600   NEXT
20620 *SORAEND
20630 ENDIF
20640 RETURN
20650 '
20660 '
20680 *JIMEN
20690 IF CAR(4,7,2)>0 THEN
20700   JR=10
20710   JG=12
20720   JB=8
20730   YJIMEN=100+5*CAR(4,7,2)
20740   IF YJIMEN>158 THEN YJIMEN=158
20750   FOR Y=90 TO YJIMEN STEP 1
20760     LINE (0,Y)-(320,Y+2),RGB(JR,JG,JB),BF
20770     JG=JG+.25
20780     IF JG>31 THEN JG=31
20790   NEXT
20800  '
20810  '
20830 *JIMENEND
20840 ENDIF
20850 RETURN
20860 '^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
20870 '
20880  '<><><><><><><><><>SUB
20890   '*********ｱｲｺﾝﾉﾄｳﾛｸ**********
20910 *SUB1
20920   '
20930   DIM SNAME$(255),SX(255),SY(255),SC(255)
20940   '*LOOP:READ TEXNAME$:PRINT TEXNAME$:SNAME$(I)=TEXNAME$
20960 *LOOP:READ TEXNAME$:SNAME$(I)=TEXNAME$
20970   IF TEXNAME$="@ENDDATA" THEN GOTO *ZAP1
20980   READ TEX_X,TEX_Y,TEX_COL:SX(I)=TEX_X:SY(I)=TEX_Y:SC(I)=TEX_COL
20990   ' PRINT TEX_X,TEX_Y,TEX_COL:SETTEX,TEX_X,TEX_Y,TEX_COL,READ
21000   SETTEX,TEX_X,TEX_Y,TEX_COL,READ
21010   SETVERTEX,4,(0,0,0),(TEX_X,0,0),(TEX_X,TEX_Y,0),(0,TEX_Y,0)
21020   SETPOLYGON,1,I,,(0,1,2,3)
21030   SETATR,1,(0,1,3,I,0,0)
21040   I=I+1:READ A$
21060 *ZAP
21070   GOTO *LOOP
21080   '
21090   '
21110 *ZAP1
21120   FOR J=0 TO 15:READ R,G,B:PALETTE 10,J,RGB(R*31/255,G*31/255,B*31/255):NEXT
21130  RETURN
21140  '============================
21150  '
21160  '
21170  '
21180  '
21190    '*********ｶﾞﾒﾝﾉｾｯﾃｲ
21210 *SUB2
21220 '********ﾅﾝｼﾞ?
21230 '**********ﾊﾟﾗﾒｰﾀｰﾉｳｲﾝﾄﾞｳ
21240   CR=1
21250   CG=2
21260   CB=3
21270   FOR Y=160 TO 222 STEP 2
21280     LINE (0,Y)-(320,Y+2),RGB(CR,CG,CB),BF
21290     CR=CR+.5:CG=CG+.5:CB=CB+.5
21300  IF DB>31 THEN DB=31
21310   NEXT
21320 '
21330 '*********ﾊﾟﾗﾒｰﾀｰｶﾞｶｶﾚﾙｳｲﾝﾄﾞｳﾉｲﾛﾉｾｯﾃｲ
21340   LINE (5,165)-(80,219),RGB(6,2,2),BF
21350   LINE (85,165)-(160,219),RGB(2,2,6),BF
21360   LINE (165,165)-(240,219),RGB(2,6,2),BF
21370 '*********ﾒｲﾝﾉｾｯﾃｲ
21380   CR=19
21390   CG=16
21400   CB=9
21410   FOR X=0 TO 320 STEP 20
21420    FOR Y=0 TO 140 STEP 20
21430     LINE (X,Y)-(X+20,Y+20),RGB(CR,CG,CB),BF
21440     CB=CB+.15
21450    NEXT
21460   NEXT
21470 '
21480 '**********ﾂｰﾙﾊﾞｰﾉｾｯﾃｲ
21490   CR=9
21500   CG=9
21510   CB=9
21520   FOR X=0 TO 19
21530     LINE (0,X)-(320,X+1),RGB(CR,CG,CB),BF
21540     CB=CB+3:CG=CG+3:CR=CR+3
21550   NEXT
21560 '
21570 RETURN
21580 '===========================
21590 '
21600 '
21610 '
21630 *SUB3
21640  '
21650  IF OBJHAITI<>1 THEN
21660   '********OBJ(K,0) ﾄ PARAMETER ﾉｾｯﾃｲ
21670    FOR K=1 TO 100:OBJ(K,0)=7:OBJ(K,20)=K:NEXT
21680   '********WIN TIMES
21690   ' PWIN(0)=0
21700   '
21710   '*********ｵﾌﾞｼﾞｪﾉﾊｲﾁ
21720   '
21730    OBJX(33)=220+RND(40):OBJY(13)=25+RND(20):OBJH(33)=33
21740   '
21750    FOR UMI0=22 TO 25:OBJH(UMI0)=UMI0:NEXT
21760    FOR KISAN=26 TO 29:OBJX(KISAN)=RND(200):OBJY(KISAN)=100+RND(20):OBJH(KISAN)=KISAN:NEXT
21770   '
21780    OBJX(30)=RND(320):OBJY(30)=5+RND(30):OBJH(30)=30
21790    OBJX(31)=RND(320):OBJY(31)=5+RND(30):OBJH(31)=31
21800    OBJX(32)=10-RND(20):OBJY(32)=35:OBJH(32)=32
21810    OBJX(21)=160+RND(40):OBJY(21)=50+RND(35):OBJH(21)=21
21820    OBJX(55)=RND(40):OBJY(55)=90+RND(30):OBJH(55)=55
21830    OBJX(56)=140+RND(40):OBJY(56)=90+RND(30):OBJH(56)=56
21840    OBJX(57)=40+RND(40):OBJY(57)=75+RND(20):OBJH(57)=57
21850    OBJX(58)=80+RND(40):OBJY(58)=35:OBJH(58)=58
21860    OBJX(59)=140+RND(40):OBJY(59)=112:OBJH(59)=59
21870   '
21880    OBJHAITI=1
21890  ENDIF
21900  '
21910    FOR KISAN=26 TO 29:OBJ(KISAN,4)=OBJX(KISAN),OBJY(KISAN),6:OBJ(KISAN,16)=44,44:OBJ(KISAN,20)=OBJH(KISAN):NEXT
21920    FOR UMI0=22 TO 25:OBJX(UMI0)=240:OBJY(UMI0)=80+20*(UMI0-22):OBJ(UMI0,4)=OBJX(UMI0),OBJY(UMI0),8:OBJ(UMI0,16)=24+UMI0,24+UMI0:OBJ(UMI0,20)=OBJH(UMI0):NEXT
21930    FOR K=2 TO 4:OBJ(K,4)=CAR(K,0,0),CAR(K,0,1),1:OBJ(K,16)=CAR(K,2,0),CAR(K,2,0):OBJ(K,20)=OBJH(K):NEXT
21940    OBJ(33,4)=OBJX(33),OBJY(33),9:OBJ(33,16)=57,57:OBJ(33,20)=OBJH(33)
21950    OBJ(30,4)=OBJX(30),OBJY(30),8:OBJ(30,16)=55,55:OBJ(30,20)=OBJH(30)
21960    OBJ(31,4)=OBJX(31),OBJY(31),8:OBJ(31,16)=56,56:OBJ(31,20)=OBJH(30)
21970    OBJ(32,4)=OBJX(32),OBJY(32),9:OBJ(32,16)=54,54:OBJ(32,20)=OBJH(32)
21980    OBJ(21,4)=OBJX(21),OBJY(21),7:OBJ(21,16)=43,43:OBJ(21,20)=OBJH(21)
21990    OBJ(55,4)=OBJX(55),OBJY(55),7:OBJ(55,16)=44,44:OBJ(55,20)=OBJH(55)
22000    OBJ(56,4)=OBJX(56),OBJY(56),7:OBJ(56,16)=44,44:OBJ(56,20)=OBJH(56)
22010    OBJ(57,4)=OBJX(57),OBJY(57),7:OBJ(57,16)=43,43:OBJ(57,20)=OBJH(57)
22020    OBJ(58,4)=OBJX(58),OBJY(58),7:OBJ(58,16)=54,54:OBJ(58,20)=OBJH(58)
22030    OBJ(59,4)=OBJX(59),OBJY(59),9:OBJ(59,16)=78,78:OBJ(59,20)=OBJH(59)
22040  '
22050  '
22060  '
22070    OBJ(5,4)=0,0,5:OBJ(5,16)=36,36:OBJ(5,20)=5
22080    OBJ(6,4)=0,0,5:OBJ(6,16)=39,39:OBJ(6,20)=6
22090    OBJ(8,16)=42,42:OBJ(8,20)=8
22100    OBJ(9,16)=42,42:OBJ(9,20)=9
22110    OBJ(10,16)=42,42:OBJ(10,20)=10
22120  '
22130    OBJ(12,4)=30,0,1:OBJ(12,16)=41,41:OBJ(12,20)=0
22140    OBJ(13,4)=70,0,1:OBJ(13,16)=40,40:OBJ(13,20)=0
22150    OBJ(14,4)=110,0,1:OBJ(14,16)=68,68:OBJ(14,20)=0
22160    OBJ(15,4)=150,0,1:OBJ(15,16)=69,69:OBJ(15,20)=0
22170    OBJ(16,4)=190,0,1:OBJ(16,16)=70,70:OBJ(16,20)=0
22180    OBJ(17,4)=192,97,9:OBJ(17,16)=71,71:OBJ(17,20)=17
22190    OBJ(18,4)=145,142,9:OBJ(18,16)=71,71:OBJ(18,20)=17
22200    OBJ(40,4)=10,177,9:OBJ(40,16)=73,73:OBJ(40,20)=0
22210    OBJ(41,4)=90,177,9:OBJ(41,16)=73,73:OBJ(41,20)=0
22220    OBJ(42,4)=170,177,9:OBJ(42,16)=73,73:OBJ(42,20)=0
22230    OBJ(43,4)=10,193,9:OBJ(43,16)=72,72:OBJ(43,20)=0
22240    OBJ(44,4)=90,193,9:OBJ(44,16)=72,72:OBJ(44,20)=0
22250    OBJ(45,4)=170,193,9:OBJ(45,16)=72,72:OBJ(45,20)=0
22260    OBJ(46,4)=10,209,9:OBJ(46,16)=74,74:OBJ(46,20)=0
22270    OBJ(47,4)=90,209,9:OBJ(47,16)=74,74:OBJ(47,20)=0
22280    OBJ(48,4)=170,209,9:OBJ(48,16)=74,74:OBJ(48,20)=0
22290    OBJ(49,4)=260,161,9:OBJ(49,16)=75,75:OBJ(49,20)=0
22300    OBJ(50,4)=284,161,9:OBJ(50,16)=76,76:OBJ(50,20)=0
22310    OBJ(51,4)=308,161,9:OBJ(51,16)=77,77:OBJ(51,20)=0
22320    OBJ(34,16)=67,67
22330    OBJ(35,16)=67,67
22340    OBJ(36,16)=67,67
22350    OBJ(37,16)=67,67
22360    OBJ(38,16)=67,67
22370    OBJ(39,16)=67,67
22380    OBJ(1,20)=0
22390    '*********ｵﾌﾞｼﾞｪﾉﾊｲﾁ
22400   FOR K=0 TO 2:LOCATE 10*K,20:PRINT "ﾓﾉｼﾘ":NEXT
22410   FOR K=0 TO 2:LOCATE 10*K,22:PRINT "ﾔﾙｷ":NEXT
22420   FOR K=0 TO 2:LOCATE 10*K,24:PRINT "ｲﾉﾁ":NEXT
22430   A$=CHR$(31)+CHR$(29)
22440   LOCATE 30,20:PRINT "ｺﾞ";A$+CHR$(29);"ﾊ";A$;"ﾝ"
22450   A$=CHR$(31)+CHR$(29)
22460   LOCATE 33,20:PRINT "ﾍﾞ";A$+CHR$(29);"ﾝ";A$;"ｷ";"";A$;"ｮ";A$;"ｳ"
22470   A$=CHR$(31)+CHR$(29)
22480   LOCATE 36,20:PRINT "T";A$ "I";A$;"M";A$;"E"
22490    OBJHAITI=1
22500          '
22510   RETURN
22520   '=========ｶﾞﾒﾝﾉｾｯﾃｲ=================
22530   '
22540   '*********ﾊﾟﾗｼｮｷｶ
22560 *SUB4
22570   TIME=0
22580   DTIME=1/60
22590   OBJHAITI=0
22600   DOUSA=0
22610   FOR K=2 TO 4
22620    CAR(K,0,0)=30+RND(200)
22630    CAR(K,0,1)=30+RND(100)
22640    CAR(K,0,2)=0:'ｶｲﾃﾝｼﾃﾙｶﾄﾞｳｶ
22650    CAR(K,0,3)=160
22660    CAR(K,0,4)=112
22670    CAR(K,0,5)=1:'ﾄﾞｯﾁﾆｶｲﾃﾝｼﾃﾙｶ
22680    CAR(K,0,6)=0:'SAKASA
22690      CAR(K,1,0)=(100-RND(201))*(1+K*2.5)/100
22700      CAR(K,1,1)=(100-RND(201))*(1+K*2.5)/100
22710      CAR(K,1,2)=0:'ROT1
22720      CAR(K,1,3)=0:'ROT2
22730    CAR(K,2,0)=5*(K-2):'ｶｵ
22740    CAR(K,2,1)=15+5*K
22750    CAR(K,2,2)=0
22760    CAR(K,2,3)=0
22770    CAR(K,2,4)=0
22780    CAR(K,2,5)=0
22790      CAR(K,3,0)=300:'ｵﾅｶ
22800      CAR(K,3,1)=K
22810      CAR(K,3,2)=0
22820      CAR(K,3,3)=0:'ｷｭｳｹｲｶﾄﾞｳｶ
22830      CAR(K,3,4)=RND(1000):'ｷｭｳｹｲﾘｮｳ
22840    CAR(K,4,0)=50*(K-1):'ｶｼｺｻ
22850    CAR(K,4,1)=K
22860    CAR(K,4,2)=0
22870    CAR(K,4,3)=0:'ﾒｶﾞﾈｦｶｹﾙｶ
22880      CAR(K,5,0)=1000:'ﾈﾑｻ
22890      CAR(K,5,1)=0
22900      CAR(K,5,2)=0
22910    CAR(K,6,0)=500:'ｷｹﾞﾝ
22920    CAR(K,6,1)=500:'ｵｺﾙﾘｮｳ
22930    CAR(K,6,2)=0
22940    CAR(K,6,3)=.01:'ｼﾂｹ
22950    CAR(K,6,4)=1:'ｵｺｯﾀﾄｷﾉﾊﾞｲﾘﾂ
22960    CAR(K,6,5)=0:'ｵｺｯﾀﾄｷﾉｲﾛ
22970    CAR(K,6,6)=0:'ﾜﾗｳﾄｷ
22980    CAR(K,6,7)=0
22990      CAR(K,7,0)=0:'ｹｲｹﾝ
23000      CAR(K,7,1)=0:'ｼﾝﾀﾞｶﾄﾞｳｶ
23010      CAR(K,7,2)=0:'ｳﾑｶｲｽｳ
23020    CAR(K,8,0)=CAR(K,3,0)+CAR(K,5,0)+CAR(K,6,0):'ﾊﾟﾗ
23030    CAR(K,8,1)=CAR(K,7,0)+CAR(K,4,0)
23040    CAR(K,8,2)=10000
23050      CAR(K,9,0)=0:'ﾓﾀﾚﾃﾙｶﾄﾞｳｶ
23060    CAR(K,10,0)=0:'ｱｿﾌﾞﾊﾞｼｮ
23070   NEXT
23080   CAR(7,7,7)=0:'ﾅﾝﾋﾞｷｼﾝﾀﾞｶ
23090   CAR(5,0,0)=1000:'ﾒｼ
23100   CAR(6,0,0)=1000:'ﾍﾞﾝｷｮｳ
23110   CAR(5,1,0)=0:'ﾎﾞｰﾙ
23120   CAR(5,1,1)=0
23130   CAR(5,1,2)=0
23140   CAR(5,1,3)=0
23150   CAR(6,1,0)=0
23160   CAR(6,1,1)=0
23170   CAR(6,1,2)=0
23180   CAR(6,1,3)=0
23190   '
23200   '*******WIN TIMES?
23210   PWIN(0)=0
23220   PWIN(1)=0
23230   '*******KUMO SPEED
23240   KUMOSP(30,0)=1
23250   KUMOSP(30,1)=1
23260   KUMOSP(31,0)=1
23270   KUMOSP(31,1)=1
23280   '
23290  RETURN
23300 '
23320 *SUB5
23325   DIM HP(30)
23340 *SUB5A
23350 '
23370   HP1=PAD(-1):'ｺﾝﾄﾛｰﾙﾀﾝｼ 1 ﾊ?
23380   HP2=PAD(-2):'ｺﾝﾄﾛｰﾙﾀﾝｼ 2 ﾊ?
23390   IF HP1+HP2=0 THEN LOCATE 0,10:PRINT "ｺﾝﾄﾛｰﾙﾊﾟｯﾄﾞ ｦ ｺﾝﾄﾛｰﾙﾀﾝｼ ﾆ ｻｼﾃ!!    ":END
23410 '
23420   FOR HPN=0 TO 29:HP(HPN)=PAD(HPN,0):NEXT
23430 '
23440   PN1=-99
23450   FOR HPN=0 TO 29
23460     IF HP(HPN)>=&HE0 AND HP(HPN)<&HFF THEN HP(HPN)=-1:PN1=HPN:PN2=1:HPN=99
23480   NEXT
23485   IF PN1<>-99 GOTO *SUB5E
23490 '
23500   FOR HPN=0 TO 29
23510     IF HP(HPN)<&H10 THEN HP(HPN)=-1:PN1=HPN:PN2=2:HPN=99
23530   NEXT
23535   IF PN1<>-99 GOTO *SUB5E
23540 '
23550   LOCATE 0,10:PRINT "ｼｬﾄﾙﾏｳｽ ｶ ｺﾝﾄﾛｰﾙﾊﾟｯﾄﾞ
23555               PRINT "   ｦ ｺﾝﾄﾛｰﾙﾀﾝｼ ﾆ ｻｼﾃ!!":END
23560 '
23580 *SUB5E
23590 'PN1 ﾊ ﾄﾞｺﾆｻｻｯﾃｲﾙｶ
23600 'PN2 ﾊ 1ｼｬﾄﾙﾏｳｽ 2ｺﾝﾄﾛｰﾙﾊﾟｯﾄﾞ
23610 '
23620 '
23630 '
23640 RETURN
23650 '
23660 '
23680 *WINCOL
23690 '**********OKOTTATOKI
23700  IF RGBFG=0 THEN DR=.5:DG=.5:DB=.5:R=9:G=9:B=9
23710 '*********ﾊﾟﾗﾒｰﾀｰｶﾞｶｶﾚﾙｳｲﾝﾄﾞｳﾉｲﾛﾉｾｯﾃｲ
23720   IF CAR(2,6,2)<>0 AND CAR(2,7,1)=0 THEN R=R+DR:LINE (5,165)-(80,219),RGB(R,2,2),BF ELSE LINE (5,165)-(80,219),RGB(9,2,2),BF
23730   IF CAR(3,6,2)<>0 AND CAR(3,7,1)=0 THEN G=G+DG:LINE (85,165)-(160,219),RGB(2,2,G),BF ELSE LINE (85,165)-(160,219),RGB(2,2,9),BF
23740   IF CAR(4,6,2)<>0 AND CAR(4,7,1)=0 THEN B=B+DB:LINE (165,165)-(240,219),RGB(2,B,2),BF ELSE LINE (165,165)-(240,219),RGB(2,9,2),BF
23750     IF R>31 THEN DR=-ABS(DR):R=30
23760     IF R<1 THEN DR=ABS(DR):R=2
23770     IF G>31 THEN DG=-ABS(DG):G=30
23780     IF G<1 THEN DG=ABS(DG):G=2
23790     IF B>31 THEN DB=-ABS(DB):B=30
23800     IF B<1 THEN DB=ABS(DB):B=2
23810   RGBFG=1
23820 RETURN
23830 '<><><><><><><><><><><><><><><><><><><>
23840   '***********ﾋﾞｯﾄﾏｯﾌﾟ
23850   '
23860   DATA "A:\GYAKU\hi11.bmp",32,27,16
23870   DATA 0000000000000000000000CCCC000000
23880   DATA 0000000000000000000CCCCCCCCC0000
23890   DATA 00000000000000000CCCCCCCC0000000
23900   DATA 000000000000000CCCCCCCC000CCC000
23910   DATA 0000000000000CCCEECCCC000000CC00
23920   DATA 000000000000CCEEECCCC0000000CC00
23930   DATA 00000000000CCEEEECCCC00C00000C00
23940   DATA 0000000000CCEEEEEECCCC0CCC000000
23950   DATA 000000000CCEEEEEEEECCC00CC000000
23960   DATA 000000000CEEEEEEEEEEECC0CC000000
23970   DATA 00000000CCEEEEEEEEEEECCC0CC00000
23980   DATA 00000000CEE11EE11EEEEECC00000000
23990   DATA 00000000CEE11EE11EEEEECC00000000
24000   DATA 00000000CEEEEEEEEEEEEECCC0000000
24010   DATA 000000011111111EEEEEEEECC0000000
24020   DATA 000000001111111EEEEEEEECC0000000
24030   DATA 00000000C11EEEEEEEEEEEECC0000000
24040   DATA 00000000CE11EEEEEEEEEEECC0000000
24050   DATA 00000000CE11EEEEEEEEEEECC0000000
24060   DATA 00000000C111111EEEEEEEECC0000000
24070   DATA 000000001111111EEEEEEEECC0000000
24080   DATA 000000000CEEEEFFFFEEEEECC0000000
24090   DATA 000000000CCEEFFFFFFEECCCC0000000
24100   DATA 0000000000CEEFFFFFFECCCC00000000
24110   DATA 0000000000CCCCCFFFECCCC000000000
24120   DATA 00000000000CCCCCCCCCCC0000000000
24130   DATA 00000000000000CCCCCCC00000000000
24140   DATA "@TEXEND"
24150   DATA "A:\GYAKU\hi12.bmp",32,27,16
24160   DATA 0000000000000000000000CCCC0000CC
24170   DATA 0000000000000000000CCCCCCCCC00C0
24180   DATA 00000000000000000CCCCCCCC0000000
24190   DATA 000000000000000CCCCCCCC000000000
24200   DATA 0000000000000CCCEECCCC00CC000000
24210   DATA 000000000000CCEEECCCC000CC000000
24220   DATA 00000000000CCEEEECCCC00CC0000000
24230   DATA 0000000000CCEEEEEECCCC0CCC000C00
24240   DATA 000000000CCEEEEEEEECCC00CC000CC0
24250   DATA 000000000CEEEEEEEEEEECC0CC000CC0
24260   DATA 00000000CCEEEEEEEEEEECCC0CC00C00
24270   DATA 00000000CE111EE111EEEECC00000000
24280   DATA 00000000CE111EE111EEEECC00000000
24290   DATA 00000000CEEEEEEEEEEEEECCC0000000
24300   DATA 0000000011111111EEEEEEECC0000000
24310   DATA 00000000C1111111EEEEEEECC0000000
24320   DATA 00000000CE11EEEEEEEEEEECC0000000
24330   DATA 00000000CEE11EEEEEEEEEECC0000000
24340   DATA 00000000CEE11EEEEEEEEEECC0000000
24350   DATA 00000000CE111111EEEEEEECC0000000
24360   DATA 00000000C1111111EEEEEEECC0000000
24370   DATA 000000000CEEEEFFFFEEEEECC0000000
24380   DATA 000000000CCEEFFFFFFEECCCC0000000
24390   DATA 0000000000CEEFFFFFFECCCC00000000
24400   DATA 0000000000CCCCCFFFECCCC000000000
24410   DATA 00000000000CCCCCCCCCCC0000000000
24420   DATA 00000000000000CCCCCCC00000000000
24430   DATA "@TEXEND"
24440   DATA "A:\GYAKU\hi13.bmp",32,27,16
24450   DATA 0000000000000000000000CCCC000000
24460   DATA 0000000000000000000CCCCCCCCC0000
24470   DATA 00000000000000000CCCCEEEC0000000
24480   DATA 000000000000000CCCCCCCC000CCC000
24490   DATA 0000000000000CCCEECCCC000000CC00
24500   DATA 000000000000CCEEECCCC0000000CC00
24510   DATA 00000000000CCEEEECCCC00C00000C00
24520   DATA 0000000000CCEEEEEECCCC0CCC000000
24530   DATA 000000000CCEEEEEEEECCC00CC000000
24540   DATA 000000000CEEEEEEEEEEECC0CC000000
24550   DATA 00000000CCEEEEEEEEEEECCC0CC00000
24560   DATA 00000000CEE11EE11EEEEECC00000000
24570   DATA 00000000CE11EEEE11EEEECC00000000
24580   DATA 00000000CEEEEEEEEEEEEECCC0000000
24590   DATA 00000000CEE1111EEE111EECC0000000
24600   DATA 00000000CE11111EEEEE11ECC0000000
24610   DATA 00000000C111EEEEEEEEE1ECC0000000
24620   DATA 00000000111EEEEEEEEE11ECC0000000
24630   DATA 00000000C111EEEEEEEE11ECC0000000
24640   DATA 00000000CE11111EEE111EECC0000000
24650   DATA 00000000CEE1111EEEEEEEECC0000000
24660   DATA 000000000CEEEEFFFFEEEEECC0000000
24670   DATA 000000000CCEEFFFFFFEECCCC0000000
24680   DATA 0000000000CEEFFFFFFECCCC00000000
24690   DATA 0000000000CCCCCFFFECCCC000000000
24700   DATA 00000000000CCCCCCCCCCC0000000000
24710   DATA 00000000000000CCCCCCC00000000000
24720   DATA "@TEXEND"
24730   DATA "A:\GYAKU\hi14.bmp",32,27,16
24740   DATA 0000000000000000000000CCCCCCCCCC
24750   DATA 0000000000000000000CCCCCCCCC0000
24760   DATA 00000000000000000CCCCCCCC0000000
24770   DATA 000000000000000CCCCCCCC000CCC000
24780   DATA 0000000000000CCCEECCCC00C000CC00
24790   DATA 000000000000CCEEECCCC000C000CC00
24800   DATA 00000000000CCEEEECCCC00CC0000CC0
24810   DATA 0000000000CCEEEEEECCCC0CCC0000C0
24820   DATA 000000000CCEEEEEEEECCC00CC000000
24830   DATA 000000000CEEE1EEEEEEECC0CC000000
24840   DATA 00000000CCEEE1EEEEEEECCC0CC00000
24850   DATA 00000000CE11EEE111EEEECC00000000
24860   DATA 00000000CEE11E111EEEEECC00000000
24870   DATA 0CC00000CEEEEEEEEEEEEECCC0000000
24880   DATA 0CCC00011111111EEEEEEEECC0000000
24890   DATA CCCCC0001111111EEEEEEEECC0000000
24900   DATA CCCC0000C11EEEEEEEEEEEECC0000000
24910   DATA 0CC00CCCCE11EEEEEEEEEEECC0000000
24920   DATA 000000CCCE11EEEEEEEEEEECC0000000
24930   DATA 00000000C111111EEEEEEEECC0000000
24940   DATA 000000001111111EEEEEEEECC0000000
24950   DATA 000000000CEEEEFFFFEEEEECC0000000
24960   DATA 000000000CCEEFFFFFFEECCCC0000000
24970   DATA 0000000000CEEFFFFFFECCCC00000000
24980   DATA 0000000000CCCCCFFFECCCC000000000
24990   DATA 00000000000CCCCCCCCCCC0000000000
25000   DATA 00000000000000CCCCCCC00000000000
25010   DATA "@TEXEND"
25020   DATA "A:\GYAKU\hi15.bmp",32,27,16
25030   DATA 000E000000000000000000CCCC0000CC
25040   DATA 000000000E000000000CCCCCCCCC0000
25050   DATA E00EEEE0000000000CCCCCCCC0000000
25060   DATA 000EEEE00000000CCCCCCCC000000000
25070   DATA 00EEEEEE00000CCCEECCCC00C0000000
25080   DATA 00EEEEEE0E00CCEEECCCC000C0000000
25090   DATA 00EEEEEE000CCEEEECCCC00CC0000000
25100   DATA E00EEEE000CCEEEEEECCCC0CC0000000
25110   DATA 000EEEE00CCEEEEEEEECCC00CC000000
25120   DATA 000000000CEEEEEEEEEEECC0CC000000
25130   DATA 00E0000ECCEEEEEEEEEEECCC0CC00C00
25140   DATA 00000000CE111EE111EEEECC00000000
25150   DATA 00000000CE1EEEEEE1EEEECC00000000
25160   DATA 00000000CEEEEEEEEEEEEECCC0000000
25170   DATA 0000000011111111EEEEEEECC0000000
25180   DATA 00000000C1111111EEEEEEECC0000000
25190   DATA 00000000CE11EEEEEEEEEEECC0000000
25200   DATA 00000000CEE11EEEEEEEEEECC0000000
25210   DATA 00000000CEE11EEEEEEEEEECC0000000
25220   DATA 00000000CE111111EEEEEEECC0000000
25230   DATA 00000000C1111111EEEEEEECC0000000
25240   DATA 000000000CEEEEFFFFEEEEECC0000000
25250   DATA 000000000CCEEFFFFFFEECCCC0000000
25260   DATA 0000000000CEEFFFFFFECCCC00000000
25270   DATA 0000000000CCCCCFFFECCCC000000000
25280   DATA 00000000000CCCCCCCCCCC0000000000
25290   DATA 00000000000000CCCCCCC00000000000
25300   DATA "@TEXEND"
25310   DATA "A:\GYAKU\mizu11.bmp",32,27,16
25320   DATA 00000000000000000009999999990000
25330   DATA 00000000000000000999999900000000
25340   DATA 00000000000000099999990000000000
25350   DATA 000000000000099999BB990000000000
25360   DATA 000000000000999BBBBB990000000000
25370   DATA 0000000000099BBBBBBB990000000000
25380   DATA 000000000009BBBBBBBB990000000000
25390   DATA 000000000099BBBBBBBBB99000000000
25400   DATA 00000000009BBBBBBBBBB99000000000
25410   DATA 0000000009BBBBBBBBBBB99000000000
25420   DATA 0000000099BBBBBBBBBBB99900000000
25430   DATA 000000009BB11BB11BBBBB9900000000
25440   DATA 000000009BB11BB11BBBBB9900000000
25450   DATA 000000009BBBBBBBBBBBBB9990000000
25460   DATA 000000011111111BBBBBBBB990000000
25470   DATA 000000001111111BBBBBBBB990000000
25480   DATA 00000000911BBBBBBBBBBBB990000000
25490   DATA 000000009B11BBBBBBBBBBB990000000
25500   DATA 000000009B11BBBBBBBBBBB990000000
25510   DATA 000000009111111BBBBBBBB990000000
25520   DATA 000000001111111BBBBBBBB990000000
25530   DATA 0000000009BBBBBBBBBBBBB990000000
25540   DATA 00000000099BBBBBBBBBB99990000000
25550   DATA 00000000009BBBBBBBBB999900000000
25560   DATA 000000000099999BBBB9999000000000
25570   DATA 00000000000999999999990000000000
25580   DATA 00000000000000999999900000000000
25590   DATA "@TEXEND"
25600   DATA "A:\GYAKU\mizu12.bmp",32,27,16
25610   DATA 00000000000000000009999999990000
25620   DATA 00000000000000000999999900000000
25630   DATA 00000000000000099999990000000000
25640   DATA 000000000000099999BB990000000000
25650   DATA 000000000000999BBBBB990000000000
25660   DATA 0000000000099BBBBBBB990000000000
25670   DATA 000000000009BBBBBBBB990000000000
25680   DATA 000000000099BBBBBBBBB99000000000
25690   DATA 00000000009BBBBBBBBBB99000000000
25700   DATA 0000000009BBBBBBBBBBB99000000000
25710   DATA 0000000099BBBBBBBBBBB99900000000
25720   DATA 000000009BB111B111BBBB9900000000
25730   DATA 000000009BB111B111BBBB9900000000
25740   DATA 000000009BBBBBBBBBBBBB9990000000
25750   DATA 0000000011111111BBBBBBB990000000
25760   DATA 0000000011111111BBBBBBB990000000
25770   DATA 000000009B11BBBBBBBBBBB990000000
25780   DATA 000000009BB11BBBBBBBBBB990000000
25790   DATA 000000009BB11BBBBBBBBBB990000000
25800   DATA 000000009B111111BBBBBBB990000000
25810   DATA 0000000091111111BBBBBBB990000000
25820   DATA 0000000009BBBBBBBBBBBBB990000000
25830   DATA 00000000099BBBBBBBBBB99990000000
25840   DATA 00000000009BBBBBBBBB999900000000
25850   DATA 000000000099999BBBB9999000000000
25860   DATA 00000000000999999999990000000000
25870   DATA 00000000000000999999900000000000
25880   DATA "@TEXEND"
25890   DATA "A:\GYAKU\mizu13.bmp",32,27,16
25900   DATA 00000000000000000009999999990000
25910   DATA 00000000000000000999999900000000
25920   DATA 00000000000000099999990000000000
25930   DATA 000000000000099999BB990000000000
25940   DATA 000000000000999BBBBB990000000000
25950   DATA 0000000000099BBBBBBB990000000000
25960   DATA 000000000009BBBBBBBB990000000000
25970   DATA 000000000099BBBBBBBBB99000000000
25980   DATA 00000000009BBBBBBBBBB99000000000
25990   DATA 0000000009BBBBBBBBBBB99000000000
26000   DATA 0000000099BBBBBBBBBBB99900000000
26010   DATA 000000009BB11BB11BBBBB9900000000
26020   DATA 000000009BB11BB11BBBBB9900000000
26030   DATA 000000009BBBBBBBBBBBBB9990000000
26040   DATA 000000009BB1111BBB1BBBB990000000
26050   DATA 000000009B11111BBB11BBB990000000
26060   DATA 000000009111BBBBBBB11BB990000000
26070   DATA 00000000111BBBBBBBB11BB990000000
26080   DATA 000000009111BBBBBB111BB990000000
26090   DATA 000000009B11111BBB11BBB990000000
26100   DATA 0000000099B1111BBBBBBBB990000000
26110   DATA 0000000009BBBBBBBBBBBBB990000000
26120   DATA 00000000099BBBBBBBBBB99990000000
26130   DATA 00000000009BBBBBBBBB999900000000
26140   DATA 000000000099999BBBB9999000000000
26150   DATA 00000000000999999999990000000000
26160   DATA 00000000000000999999900000000000
26170   DATA "@TEXEND"
26180   DATA "A:\GYAKU\mizu14.bmp",32,27,16
26190   DATA 00000000000000000009999999990000
26200   DATA 00000000000000000999999900000000
26210   DATA 00000000000000099999990000000000
26220   DATA 000000000000099999BB990000000000
26230   DATA 000000000000999BBBBB990000000000
26240   DATA 0000000000099BBBBBBB990000000000
26250   DATA 000000000009BBBBBBBB990000000000
26260   DATA 0000000000911BB11BBBB99000000000
26270   DATA 0000000000911BB11BBBB99000000000
26280   DATA 0000000009B11BB11BBBB99000000000
26290   DATA 0000000099B11BB11BBBB99900000000
26300   DATA 000000009BBBBBBBBBBBBB9900000000
26310   DATA 000000009BB11BB11BBBBB9900000000
26320   DATA 000000009BBBBBBBBBBBBB9990000000
26330   DATA 000000011111111BBBBBBBB990000000
26340   DATA 000000001111111BBBBBBBB990000000
26350   DATA 00000000911BBBBBBB111BB990000000
26360   DATA 000000009B11BBBBBBBBB1B990000000
26370   DATA 000000009B11BBBBB111B1B990000000
26380   DATA 000000009111111BB1BB11B990000000
26390   DATA 000000001111111BB1111BB990000000
26400   DATA 0000000009BBBBBBBBBBBBB990000000
26410   DATA 00000000099BBBBBBBBBB99990000000
26420   DATA 00000000009BBBBBBBBB999900000000
26430   DATA 000000000099999BBBB9999000000000
26440   DATA 00000000000999999999990000000000
26450   DATA 00000000000000999999900000000000
26460   DATA "@TEXEND"
26470   DATA "A:\GYAKU\mizu15.bmp",32,27,16
26480   DATA 0000E00E000000000009999999990000
26490   DATA E0000000000000000999999900000000
26500   DATA 000EE000000000099999990000000000
26510   DATA 00EEEE000000099999BB990000000000
26520   DATA 0EEEEEE00EE0999BBBBB990000000000
26530   DATA 0EEEEEE000099BBBBBBB990000000000
26540   DATA 00EEEE000009BBBBBBBB990000000000
26550   DATA E00EE0000099BBBBBBBBB99000000000
26560   DATA 0000000E009BBBBBBBBBB99000000000
26570   DATA 000E000009BBBBBBBBBBB99000000000
26580   DATA 0000000099BBBBBBBBBBB99900000000
26590   DATA 000000009BB111B111BBBB9900000000
26600   DATA 000000009BB1BBBBB1BBBB9900000000
26610   DATA 000000009BBBBBBBBBBBBB9990000000
26620   DATA 0000000011111111BBBBBBB990000000
26630   DATA 0000000011111111BBBBBBB990000000
26640   DATA 000000009B11BBBBBBBBBBB990000000
26650   DATA 000000009BB11BBBBBBBBBB990000000
26660   DATA 000000009BB11BBBBBBBBBB990000000
26670   DATA 000000009B111111BBBBBBB990000000
26680   DATA 0000000091111111BBBBBBB990000000
26690   DATA 0000000009BBBBBBBBBBBBB990000000
26700   DATA 00000000099BBBBBBBBBB99990000000
26710   DATA 00000000009BBBBBBBBB999900000000
26720   DATA 000000000099999BBBB9999000000000
26730   DATA 00000000000999999999990000000000
26740   DATA 00000000000000999999900000000000
26750   DATA "@TEXEND"
26760   DATA "A:\GYAKU\tuti11.bmp",32,29,16
26770   DATA 00000000000000000000000000000000
26780   DATA 00000000000000000000000000000000
26790   DATA 00000000000000000000000000000000
26800   DATA 00000000000000000000000000000000
26810   DATA 00000000000000000000000000000000
26820   DATA 00000000000000000000000000000000
26830   DATA 00000000000000000000000000000000
26840   DATA 00000000000000000000000000000000
26850   DATA 00000000000000000006666000000000
26860   DATA 00000066666660000066666660000000
26870   DATA 00000666666666666668866666000000
26880   DATA 00000668888888888888886666600000
26890   DATA 00000688888888888888888666660000
26900   DATA 00000688888888888888888866660000
26910   DATA 00006688888888888888888866660000
26920   DATA 00006688222882228888888886660000
26930   DATA 00006888222882228888888886660000
26940   DATA 00006888222882228888888886660000
26950   DATA 00006888888888888888888886660000
26960   DATA 00022222222222888888888886660000
26970   DATA 00002222222222888888888886666000
26980   DATA 00006222888888888888888886666000
26990   DATA 00006682228888888888888888666000
27000   DATA 00000688228888888888888888666000
27010   DATA 00000682288888888888888886666000
27020   DATA 00000622222222888888888866666000
27030   DATA 00000022222222888888888666660000
27040   DATA 00000006688888888888886666000000
27050   DATA 00000006666666666666666600000000
27060   DATA "@TEXEND"
27070   DATA "A:\GYAKU\tuti12.bmp",32,29,16
27080   DATA 00000000000000000000000000000000
27090   DATA 00000000000000000000000000000000
27100   DATA 00000000000000000000000000000000
27110   DATA 00000000000000000000000000000000
27120   DATA 00000000000000000000000000000000
27130   DATA 00000000000000000000000000000000
27140   DATA 00000000000000000000000000000000
27150   DATA 00000000000000000000000000000000
27160   DATA 00000000000000000006666000000000
27170   DATA 00000066666660000066666660000000
27180   DATA 00000666666666666668866666000000
27190   DATA 00000668888888888888886666600000
27200   DATA 00000688888888888888888666660000
27210   DATA 00000688888888888888888866660000
27220   DATA 00006688888888888888888866660000
27230   DATA 00006682222882222288888886660000
27240   DATA 00006882222882222288888886660000
27250   DATA 00006888888888888888888886660000
27260   DATA 00006888888888888888888886660000
27270   DATA 00022222222222888888888886660000
27280   DATA 00002222222222888888888886666000
27290   DATA 00006222888888888888888886666000
27300   DATA 00006682228888888888888888666000
27310   DATA 00000688228888888888888888666000
27320   DATA 00000682288888888888888886666000
27330   DATA 00000622222222888888888866666000
27340   DATA 00000022222222888888888666660000
27350   DATA 00000006688888888888886666000000
27360   DATA 00000006666666666666666600000000
27370   DATA "@TEXEND"
27380   DATA "A:\GYAKU\tuti13.bmp",32,29,16
27390   DATA 00000000000000000000000000000000
27400   DATA 00000000000000000000000000000000
27410   DATA 00000000000000000000000000000000
27420   DATA 00000000000000000000000000000000
27430   DATA 00000000000000000000000000000000
27440   DATA 00000000000000000000000000000000
27450   DATA 00000000000000000000000000000000
27460   DATA 00000000000000000000000000000000
27470   DATA 00000000000000000006666000000000
27480   DATA 00000066666660000066666660000000
27490   DATA 00000666666666666668866666000000
27500   DATA 00000668888888888888886666600000
27510   DATA 00000688888888888888888666660000
27520   DATA 00000688888888888888888866660000
27530   DATA 00006688888888888888888866660000
27540   DATA 00006688222882228888888886660000
27550   DATA 00006888222882228888888886660000
27560   DATA 00006888222882228882222286660000
27570   DATA 00006888888888888888882226660000
27580   DATA 00006888222222888888888226660000
27590   DATA 00006882222222888888888226666000
27600   DATA 00006822288888888888888226666000
27610   DATA 00006222228888888888888228666000
27620   DATA 00000222228888888888888228666000
27630   DATA 00000622288888888888882286666000
27640   DATA 00000682222222888888222866666000
27650   DATA 00000068222222888888888666660000
27660   DATA 00000006688888888888886666000000
27670   DATA 00000006666666666666666600000000
27680   DATA "@TEXEND"
27690   DATA "A:\GYAKU\tuti14.bmp",32,29,16
27700   DATA 00000000000000000000000000000000
27710   DATA 00000000000000000000000000000000
27720   DATA 00000000000000000000000000000000
27730   DATA 00000000000000000000000000000000
27740   DATA 00000000000000000000000000000000
27750   DATA 00000000000000000000000000000000
27760   DATA 00000000000000000000000000000000
27770   DATA 00000000000000000000000000000000
27780   DATA 00000000000000000006666000000000
27790   DATA 00000066666660000066666660000000
27800   DATA 00000666666666666668866666000000
27810   DATA 00000668888888888888886666600000
27820   DATA 00000688888888888888888666660000
27830   DATA 00000628888888882888888866660000
27840   DATA 00006688288888288888282866660000
27850   DATA 00006688828828888888282886660000
27860   DATA 00006888888888888822282226660000
27870   DATA 00006888222882228888888886660000
27880   DATA 00006888888888888822282226660000
27890   DATA 00022222222222888888282886660000
27900   DATA 00002222222222888888282886666000
27910   DATA 00006222888888888888888886666000
27920   DATA 00006682228888888888888888666000
27930   DATA 00000688228888888888888888666000
27940   DATA 00000682288888888888888886666000
27950   DATA 00000622222222888888888866666000
27960   DATA 00000022222222888888888666660000
27970   DATA 00000006688888888888886666000000
27980   DATA 00000006666666666666666600000000
27990   DATA "@TEXEND"
28000   DATA "A:\GYAKU\tuti15.bmp",32,29,16
28010   DATA 00E00000000000000000000000000000
28020   DATA 000EEE00E00000000000000000000000
28030   DATA E0EEEEE0000000000000000000000000
28040   DATA 00EEEEE0000000000000000000000000
28050   DATA 00EEEEE0000000000000000000000000
28060   DATA 000EEE000E0000000000000000000000
28070   DATA 00000000000000000000000000000000
28080   DATA E0000000000000000000000000000000
28090   DATA 0000E000000000000006666000000000
28100   DATA 00000066666660000066666660000000
28110   DATA 00000666666666666668866666000000
28120   DATA 00000668888888888888886666600000
28130   DATA 00000688888888888888888666660000
28140   DATA 00000688888888888888888866660000
28150   DATA 00006688888888888888888866660000
28160   DATA 00006682222882222288888886660000
28170   DATA 00006882888888888288888886660000
28180   DATA 00006888888888888888888886660000
28190   DATA 00006888888888888888888886660000
28200   DATA 00022222222222888888888886660000
28210   DATA 00002222222222888888888886666000
28220   DATA 00006222888888888888888886666000
28230   DATA 00006682228888888888888888666000
28240   DATA 00000688228888888888888888666000
28250   DATA 00000682288888888888888886666000
28260   DATA 00000622222222888888888866666000
28270   DATA 00000022222222888888888666660000
28280   DATA 00000006688888888888886666000000
28290   DATA 00000006666666666666666600000000
28300   DATA "@TEXEND"
28310   DATA "A:\GYAKU\hi21.bmp",32,32,16
28320   DATA 0000000000000000000000CCCC000000
28330   DATA 0000000000000000000CCCCCCCCC0000
28340   DATA 00000000000000000CCCCCCCC0000000
28350   DATA 000000000000000CCCCCCCC000CCC000
28360   DATA 0000000000000CCCEECCCC000000CC00
28370   DATA 000000000000CCEEECCCC0000000CC00
28380   DATA 00000000000CCEEEECCCC00C00000C00
28390   DATA 0000000000CCEEEEEECCCC0CCC000000
28400   DATA 000000000CCEEEEEEEECCC00CC000000
28410   DATA 000000000CEEEEEEEEEEECC0CC000000
28420   DATA 00000000CCEEEEEEEEEEECCC0CC00000
28430   DATA 00000000CEE11EE11EEEEECC00000000
28440   DATA 00000000CEE11EE11EEEEECC00000000
28450   DATA 00000000CEEEEEEEEEEEEECCC0000000
28460   DATA 000000011111111EEEEEEEECC0000000
28470   DATA 000000001111111EEEEEEEECC0000000
28480   DATA 00000000C11EEEEEEEEEE11CC0000000
28490   DATA 00000000CE11EEEEEEEEEE11C0000000
28500   DATA 00000000CE11EEEEEEEEEEE110000000
28510   DATA 00000001C111111EEEEEEEEC10000000
28520   DATA 000000111111111EEEEEEEEC11000000
28530   DATA 000000100CEEEEFFFFEEEEECC1000000
28540   DATA 000001100CCEEFFFFFFEECCCC1000000
28550   DATA 0000011000CEEFFFFFFECCCC11100000
28560   DATA 0000011000CCCCCFFFECCCC011100000
28570   DATA 00000000000CCCCCCCCCCC0011100000
28580   DATA 00000000000001CCCCCCC00000000000
28590   DATA 00000000000001100110000000000000
28600   DATA 00000000000001100110000000000000
28610   DATA 00000000000011100110000000000000
28620   DATA 00000000000111100111000000000000
28630   DATA 00000000011110000011100000000000
28640   DATA "@TEXEND"
28650   DATA "A:\GYAKU\hi22.bmp",32,32,16
28660   DATA 0000000000000000000000CCCC0000CC
28670   DATA 0000000000000000000CCCCCCCCC00C0
28680   DATA 00000000000000000CCCCCCCC0000000
28690   DATA 000000000000000CCCCCCCC000000000
28700   DATA 0000000000000CCCEECCCC00CC000000
28710   DATA 000000000000CCEEECCCC000CC000000
28720   DATA 00000000000CCEEEECCCC00CC0000000
28730   DATA 0000000000CCEEEEEECCCC0CCC000C00
28740   DATA 000000000CCEEEEEEEECCC00CC000CC0
28750   DATA 000000000CEEEEEEEEEEECC0CC000CC0
28760   DATA 00000000CCEEEEEEEEEEECCC0CC00C00
28770   DATA 00000000CE111EE111EEEECC00000000
28780   DATA 00000000CE111EE111EEEECC00000000
28790   DATA 00000000CEEEEEEEEEEEEECCC0000000
28800   DATA 0000000011111111EEEEEEECC0000000
28810   DATA 00000000C1111111EEEEEEECC0000000
28820   DATA 00000000CE11EEEEEEEEE111C0000000
28830   DATA 00110000CEE11EEEEEEEEEE110000000
28840   DATA 00110001CEE11EEEEEEEEEEC11011000
28850   DATA 00110001CE111111EEEEEEECC1111000
28860   DATA 00011011C1111111EEEEEEECC0011000
28870   DATA 000011100CEEEEFFFFEEEEECC0000000
28880   DATA 000000000CCEEFFFFFFEECCCC0000000
28890   DATA 0000000000CEEFFFFFFECCCC00000000
28900   DATA 0000000000CCCCCFFFECCCC000000000
28910   DATA 00000000000CCCCCCCCCCC0000000000
28920   DATA 00000000000001CCCCCCC00000000000
28930   DATA 00000000110011101100000000000000
28940   DATA 00000000011111001100000000000000
28950   DATA 00000000001111001100000000000000
28960   DATA 00000000000110001111000000000000
28970   DATA 00000000000000011111100000000000
28980   DATA "@TEXEND"
28990   DATA "A:\GYAKU\hi23.bmp",32,32,16
29000   DATA 0000000000000000000000CCCC000000
29010   DATA 0000000000000000000CCCCCCCCC0000
29020   DATA 00000000000000000CCCCEEEC0000000
29030   DATA 000000000000000CCCCCCCC000CCC000
29040   DATA 0000000000000CCCEECCCC000000CC00
29050   DATA 000000000000CCEEECCCC0000000CC00
29060   DATA 00000000000CCEEEECCCC00C00000C00
29070   DATA 0000000000CCEEEEEECCCC0CCC000000
29080   DATA 000000000CCEEEEEEEECCC00CC000000
29090   DATA 000000000CEEEEEEEEEEECC0CC000000
29100   DATA 00000000CCEEEEEEEEEEECCC0CC00000
29110   DATA 00000000CEE11EE11EEEEECC00000000
29120   DATA 00000000CE11EEEE11EEEECC00000000
29130   DATA 00000000CEEEEEEEEEEEEECCC0000000
29140   DATA 00000000CEE1111EEE111EECC0000000
29150   DATA 00000000CE11111EEEEE11ECC0000000
29160   DATA 00000000C111EEEEEEEEE1ECC0000000
29170   DATA 00001100111EEEEEEEEE111110000000
29180   DATA 00001100C111EEEEEEEE11EC11000000
29190   DATA 00001101CE11111EEE111EECC1100000
29200   DATA 00001001CEE1111EEEEEEEECC1110000
29210   DATA 000010010CEEEEFFFFEEEEECC0110000
29220   DATA 000011110CCEEFFFFFFEECCCC0010000
29230   DATA 0000000000CEEFFFFFFECCCC01110000
29240   DATA 0000000000CCCCCFFFECCCC001100000
29250   DATA 00000000000CCCCCCCCCCC0001100000
29260   DATA 00000000000001CCCCCCC00000000000
29270   DATA 00000000000001100110011110000000
29280   DATA 00000000000001100110111110000000
29290   DATA 00000000000011100111111000000000
29300   DATA 00000000000111000111100000000000
29310   DATA 00000000011111000000000000000000
29320   DATA "@TEXEND"
29330   DATA "A:\GYAKU\hi24.bmp",32,32,16
29340   DATA 0000000000000000000000CCCCCCCCCC
29350   DATA 0000110000000000000CCCCCCCCC0000
29360   DATA 00011110000000000CCCCCCCC0000000
29370   DATA 000111100000000CCCCCCCC000CCC000
29380   DATA 0000111000000CCCEECCCC00C000CC00
29390   DATA 000000100000CCEEECCCC000C000CC00
29400   DATA 00000010000CCEEEECCCC00CC0000CC0
29410   DATA 0000001100CCEEEEEECCCC0CCC0000C0
29420   DATA 000000010CCEEEEEEEECCC00CC000000
29430   DATA 000000010CEEE1EEEEEEECC0CC000000
29440   DATA 00000001CCEEE1EEEEEEECCC0CC00000
29450   DATA 00000001CE11EEE111EEEECC00000000
29460   DATA 00000000CEE11E111EEEEECC00000000
29470   DATA 0CC00000CEEEEEEEEEEEEECCC0000000
29480   DATA 0CCC00011111111EEEEEEEECC0000000
29490   DATA CCCCC0001111111EEEEEEEECC0111000
29500   DATA CCCC0000C11EEEEEEEEEE11CC0111000
29510   DATA 0CC00CCCCE11EEEEEEEEEE1CC0111000
29520   DATA 000000CCCE11EEEEEEEEEE11C1111000
29530   DATA 00000000C111111EEEEEEEE111000000
29540   DATA 000000001111111EEEEEEEECC0000000
29550   DATA 000000000CEEEEFFFFEEEEECC0000000
29560   DATA 000000000CCEEFFFFFFEECCCC0000000
29570   DATA 0000000000CEEFFFFFFECCCC00000000
29580   DATA 0000000000CCCCCFFFECCCC000000000
29590   DATA 00000000000CCCCCCCCCCC0000000000
29600   DATA 00000000000111CCCCCCC00000000000
29610   DATA 00000000001110001110001111100000
29620   DATA 00000000000110000111001111000000
29630   DATA 00000000000011000111111100000000
29640   DATA 00000000000011100011110000000000
29650   DATA 00000000001111100000000000000000
29660   DATA "@TEXEND"
29670   DATA "A:\GYAKU\hi25.bmp",32,32,16
29680   DATA 0E00000E00000000000000CCCC000000
29690   DATA 0000000000000000000CCCCCCCCC0000
29700   DATA 0000EEE0000000000CCCCCCCC0000000
29710   DATA 0E0EEEEE0000000CCCCCCCC000CCC000
29720   DATA 000EEEEE0E000CCCEECCCC000000CC00
29730   DATA 000EEEEE0000CCEEECCCC0000000CC00
29740   DATA 0E00EEE0000CCEEEECCCC00C00000C00
29750   DATA 0000000000CCEEEEEECCCC0CCC000000
29760   DATA 0000EE000CCEEEEEEEECCC00CC000000
29770   DATA 000000000CEEEEEEEEEEECC0CC000000
29780   DATA 00000000CCEEEEEEEEEEECCC0CC00000
29790   DATA 00000000CEE11EE11EEEEECC00000000
29800   DATA 00000000CE111EE111EEEECC00000000
29810   DATA 00000000CEEEEEEEE1EEEECCC0000000
29820   DATA 000000011111111EEEEEEEECC0000000
29830   DATA 000000001111111EEEEEEEECC0000000
29840   DATA 00010000C11EEEEEEEEEE11CC0000000
29850   DATA 00111000CE11EEEEEEEEEE11C0000000
29860   DATA 00111000CE11EEEEEEEEEEE110001100
29870   DATA 00011001C111111EEEEEEEEC10011100
29880   DATA 000011111111111EEEEEEEEC11111100
29890   DATA 000000000CEEEEFFFFEEEEECC0001000
29900   DATA 000000000CCEEFFFFFFEECCCC0000000
29910   DATA 0000000000CEEFFFFFFECCCC00000000
29920   DATA 0000000000CCCCCFFFECCCC000000000
29930   DATA 00000000000CCCCCCCCCCC0000000000
29940   DATA 00000000000001CCCCCCC00000000000
29950   DATA 00000001100011100110000000000000
29960   DATA 00000000111111000110000000000000
29970   DATA 00000000011110000110000000000000
29980   DATA 00000000001100000111000000000000
29990   DATA 00000000000000000011100000000000
30000   DATA "@TEXEND"
30010   DATA "A:\GYAKU\mizu21.bmp",32,32,16
30020   DATA 00000000000000000000000000000000
30030   DATA 00000099000000000000000009990000
30040   DATA 00000009900000000000000099000000
30050   DATA 000000009BB000000000000B90000000
30060   DATA 0000000099BBBBBBBBBBBBB990000000
30070   DATA 0000000009BBBBBBBBBBBB9900000000
30080   DATA 0000000009BBBBBBBBBBBF9900000000
30090   DATA 0000000009BBBBBBBBBBBF9900000000
30100   DATA 0000000009BBBBBBBBBBFF9900000000
30110   DATA 0000000009B11BB11BBBFF9900000000
30120   DATA 0000000009B11BB11BBBFF9900000000
30130   DATA 0000000009B11BB11BBBFF9900000000
30140   DATA 0000000009BBBBBBBBBBFF9900000000
30150   DATA 0000000111111111BBBBFF9900000000
30160   DATA 0000000011111111BBBBBB9900000000
30170   DATA 00000000011BBBBBBBBBBB9900000000
30180   DATA 0000000009111BBBBBBBFF9900000000
30190   DATA 0000000009111BBBBBBBFF9900000000
30200   DATA 00000000011BBBBBBBBBBB9900000000
30210   DATA 0000000011111111BBBBBB9900000000
30220   DATA 0000000011111111BBBBB99000000000
30230   DATA 000000000099BBBBBBBBB99000000000
30240   DATA 000000000009BBBBBBB9999000000000
30250   DATA 00000000000999BBBB99990000000000
30260   DATA 000000000000099BB999900000000000
30270   DATA 00000000000000999990000000000000
30280   DATA 00000000000000999900000000000000
30290   DATA 00000000000000099900000000000000
30300   DATA 00000000000000099900000000000000
30310   DATA 0000000000000099F990000000000000
30320   DATA 000000000000999FFF99900000000000
30330   DATA 00000000009999999999990000000000
30340   DATA "@TEXEND"
30350   DATA "A:\GYAKU\mizu22.bmp",32,32,16
30360   DATA 00000000000000000000000000000000
30370   DATA 00000099000000000000000009990000
30380   DATA 00000009900000000000000099000000
30390   DATA 000000009BB000000000000B90000000
30400   DATA 0000000099BBBBBBBBBBBBB990000000
30410   DATA 0000000009BBBBBBBBBBBB9900000000
30420   DATA 0000000009BBBBBBBBBBBF9900000000
30430   DATA 0000000009BBBBBBBBBBBF9900000000
30440   DATA 0000000009BBBBBBBBBBFF9900000000
30450   DATA 0000000009BBBBBBBBBBFF9900000000
30460   DATA 0000000009111BB1111BFF9900000000
30470   DATA 0000000009111BB1111BFF9900000000
30480   DATA 0000000009BBBBBBBBBBFF9900000000
30490   DATA 00000000111111111BBBFF9900000000
30500   DATA 00000000011111111BBBBB9900000000
30510   DATA 000000000911BBBBBBBBBB9900000000
30520   DATA 0000000009B111BBBBBBFF9900000000
30530   DATA 0000000009B111BBBBBBFF9900000000
30540   DATA 000000000911BBBBBBBBBB9900000000
30550   DATA 00000000011111111BBBBB9900000000
30560   DATA 00000000011111111BBBB99000000000
30570   DATA 000000000099BBBBBBBBB99000000000
30580   DATA 000000000009BBBBBBB9999000000000
30590   DATA 00000000000999BBBB99990000000000
30600   DATA 000000000000099BB999900000000000
30610   DATA 00000000000000999990000000000000
30620   DATA 00000000000000999900000000000000
30630   DATA 00000000000000099999900000000000
30640   DATA 0000000000000009FFFF999900000000
30650   DATA 0000000000000009FFF9990000000000
30660   DATA 0000000000000099FF99000000000000
30670   DATA 00000000000009999900000000000000
30680   DATA "@TEXEND"
30690   DATA "A:\GYAKU\mizu23.bmp",32,32,16
30700   DATA 00000000000000000000000000000000
30710   DATA 00000000000000000000000000000000
30720   DATA 00000099000000000000000009990000
30730   DATA 00000009900000000000000099000000
30740   DATA 000000009BB000000000000B90000000
30750   DATA 0000000099BBBBBBBBBBBBB990000000
30760   DATA 0000000009BBBBBBBBBBBB9900000000
30770   DATA 0000000009BBBBBBBBBBBF9900000000
30780   DATA 0000000009BBBBBBBBBBBF9900000000
30790   DATA 0000000009BBBBBBBBBBFF9900000000
30800   DATA 0000000009B11BB11BBBFF9900000000
30810   DATA 0000000009B11BB11BBBFF9900000000
30820   DATA 0000000009B11BB11BBBFF9900000000
30830   DATA 0000000009BBBBBBBBBBFF9900000000
30840   DATA 0000000009111111BBBBFF9900000000
30850   DATA 0000000011111111BB111B9900000000
30860   DATA 00000001111BBBBBBBBB119900000000
30870   DATA 00000001111111BBBBBBF19900000000
30880   DATA 00000000111111BBBBBB119900000000
30890   DATA 000000000111BBBBBB111B9900000000
30900   DATA 0000000009111111BB111B9900000000
30910   DATA 0000000009911111BBBBB99000000000
30920   DATA 000000000099BBBBBBBBB99000000000
30930   DATA 000000000009BBBBBBB9999000000000
30940   DATA 00000000000999BBBB99990000000000
30950   DATA 000000000000099BB999900000000000
30960   DATA 00000000000000999990000000000000
30970   DATA 00000000000000999900000000000000
30980   DATA 00000000000000099900000000000000
30990   DATA 00000000000000099900000000000000
31000   DATA 0000000000000099F990000000000000
31010   DATA 00000000000099999999990000000000
31020   DATA "@TEXEND"
31030   DATA "A:\GYAKU\mizu24.bmp",32,32,16
31040   DATA 0000000000BBBBBBB000000000000000
31050   DATA 0BBBB099BBBBBBBBBBBBBBB009990000
31060   DATA B9BB00099BBBBBBBBBBBBBBB99000000
31070   DATA B99000009BB11BB11BBBBBBB90000000
31080   DATA BBB0B00099B11BB11BBBBBB990000000
31090   DATA 0000B00009B11BB11BBBBB9900000000
31100   DATA 0000BB0009B11BB11BBBBF9900000000
31110   DATA 0000BB0009B11BB11BBBBF9900000000
31120   DATA 0000000009B11BB11BBBFF9900000000
31130   DATA 0000000009BBBBBBBBBBFF9900000000
31140   DATA 0000000009B11BB11BBBFF9900000000
31150   DATA 0000000009B11BB11BBBFF9900000000
31160   DATA 0000000009BBBBBBBBBBFF9900000000
31170   DATA 0000000111111111BBBBFF9900000000
31180   DATA 0000000011111111BBBBBB9900000000
31190   DATA 00000000011BBBBBBBBBBB9900000000
31200   DATA 0000000009111BBBBBBBFF9900000000
31210   DATA 0000000009111BBBBBBBFF9900000000
31220   DATA 00000000011BBBBBBBBBBB9900000000
31230   DATA 0000000011111111BBBBBB9900000000
31240   DATA 0000000011111111BBBBB99000000000
31250   DATA 000000000099BBBBBBBBB99000000000
31260   DATA 000000000009BBBBBBB9999000000000
31270   DATA 00000000000999BBBB99990000000000
31280   DATA 000000000000099BB999900000000000
31290   DATA 00000000000000999990000000000000
31300   DATA 00000000000000999900000000000000
31310   DATA 00000000000000099900000000000000
31320   DATA 00000000000000099900000000000000
31330   DATA 0000000000999099F990099000000000
31340   DATA 000000000009999FFF99990000000000
31350   DATA 00000000000099999999000000000000
31360   DATA "@TEXEND"
31370   DATA "A:\GYAKU\mizu25.bmp",32,32,16
31380   DATA 00000000000000000000000000000000
31390   DATA 00000099000000000000000009990000
31400   DATA 0E00E009900000000000000099000000
31410   DATA 000000009BB000000000000B90000000
31420   DATA E0EEE00099BBBBBBBBBBBBB990000000
31430   DATA 0EEEEE0009BBBBBBBBBBBB9900000000
31440   DATA 0EEEEE0E09BBBBBBBBBBBF9900000000
31450   DATA 0EEEEE0009BBBBBBBBBBBF9900000000
31460   DATA 00EEE00009BBBBBBBBBBFF9900000000
31470   DATA 0000000009BBBBBBBBBBFF9900000000
31480   DATA 00E00E0009111BB1111BFF9900000000
31490   DATA 00000000091BBBBBBB1BFF9900000000
31500   DATA 0000000009BBBBBBBBBBFF9900000000
31510   DATA 00000000111111111BBBFF9900000000
31520   DATA 00000000011111111BBBBB9900000000
31530   DATA 000000000911BBBBBBBBBB9900000000
31540   DATA 0000000009B111BBBBBBFF9900000000
31550   DATA 0000000009B111BBBBBBFF9900000000
31560   DATA 000000000911BBBBBBBBBB9900000000
31570   DATA 00000000011111111BBBBB9900000000
31580   DATA 00000000011111111BBBB99000000000
31590   DATA 000000000099BBBBBBBBB99000000000
31600   DATA 000000000009BBBBBBB9999000000000
31610   DATA 00000000000999BBBB99990000000000
31620   DATA 000000000000099BB999900000000000
31630   DATA 00000000000000999990000000000000
31640   DATA 00000000000000999900000000000000
31650   DATA 00000000000000099999900000000000
31660   DATA 0000000000000009FFFF999900000000
31670   DATA 0000000000000009FFF9990000000000
31680   DATA 0000000000000099FF99000000000000
31690   DATA 00000000000009999900000000000000
31700   DATA "@TEXEND"
31710   DATA "A:\GYAKU\tuti21.bmp",32,32,16
31720   DATA 00000000000000022220000000000000
31730   DATA 00000000000000222220000000000000
31740   DATA 000000000000022AA222200000000000
31750   DATA 00000000000022AAAA22220000000000
31760   DATA 0000000000022AAAAAA2222000000000
31770   DATA 000000000222AAAAAAAA222200000000
31780   DATA 00000000222222AAAAAAAA2220000000
31790   DATA 00000000000022AAAA22222220000000
31800   DATA 0000000000022AAAAA22220000000000
31810   DATA 000000000022AAAAAAA2222000000000
31820   DATA 0000000002AAA11A11AAA22200000000
31830   DATA 000000000222211A11AAA22220000000
31840   DATA 000000000002211A11A2222222000000
31850   DATA 000000000002AAAAAAAA222022000000
31860   DATA 00000000011111111AAA222200000000
31870   DATA 00000000021111111AAAA22200000000
31880   DATA 0000000022A11AAAAAAAAA2220000000
31890   DATA 00000002222A11AAAAAA222222000000
31900   DATA 00000000002111AAAAAA222000000000
31910   DATA 00000000001111111AAAA22200000000
31920   DATA 00000000022111111AAAAA2220000000
31930   DATA 0000000022AAAAAAAAAAAA2222000000
31940   DATA 000000000222AAAAAAAAAAA222000000
31950   DATA 00000000000222222222222200000000
31960   DATA 00000006606622222222226660000000
31970   DATA 00000006666002222222200060000000
31980   DATA 00000006660000066600000060000000
31990   DATA 00000000000000066600000666000000
32000   DATA 00000000000000066600000666000000
32010   DATA 00000000000000066600000000000000
32020   DATA 00000000000000666660000000000000
32030   DATA 00000000000066666666600000000000
32040   DATA "@TEXEND"
32050   DATA "A:\GYAKU\tuti22.bmp",32,32,16
32060   DATA 00000000000000022220000000000000
32070   DATA 00000000000000222220000000000000
32080   DATA 000000000000022AA222200000000000
32090   DATA 00000000000022AAAA22220000000000
32100   DATA 0000000000022AAAAAA2222000000000
32110   DATA 000000000222AAAAAAAA222200220000
32120   DATA 00000000222222AAAAAAAA2220020000
32130   DATA 00000000000022AAAA22222220020000
32140   DATA 0000000000022AAAAA22220000000000
32150   DATA 000000000022AAAAAAA2222000000000
32160   DATA 0000000002AAAAAAAAAAA22200000000
32170   DATA 00000000022111A11111222220000000
32180   DATA 00000000000111A11111222222022000
32190   DATA 000000000002AAAAAAAA222022002200
32200   DATA 00000000011111111AAA222200000000
32210   DATA 00000000021111111AAAA22200000000
32220   DATA 0000000022A11AAAAAAAAA2220000000
32230   DATA 00000002222A11AAAAAA222222002000
32240   DATA 00000000002111AAAAAA222000002000
32250   DATA 00000000001111111AAAA22200002200
32260   DATA 00000000022111111AAAAA2220000000
32270   DATA 0000000022AAAAAAAAAAAA2222000000
32280   DATA 000000000222AAAAAAAAAAA222000000
32290   DATA 00000000000222222222222200000000
32300   DATA 00000000000622222222220600000000
32310   DATA 00000000000602222222200666600000
32320   DATA 00000000066600066600000066660000
32330   DATA 00000000066600066600000000000000
32340   DATA 00000000000000006660000000000000
32350   DATA 00000000000000006660000000000000
32360   DATA 00000000000000006666600000000000
32370   DATA 00000000000000666666666000000000
32380   DATA "@TEXEND"
32390   DATA "A:\GYAKU\tuti23.bmp",32,32,16
32400   DATA 00000000000000022220000000000000
32410   DATA 00000000000000222220000000000000
32420   DATA 000000000000022AA222200022220000
32430   DATA 00000000000022AAAA22220000020000
32440   DATA 0000000000022AAAAAA2222000000000
32450   DATA 000000000222AAAAAAAA222200022000
32460   DATA 00000000222222AAAAAAAA2220002000
32470   DATA 00000000000022AAAA22222220000000
32480   DATA 0000000000022AAAAA22220000000020
32490   DATA 000000000022AAAAAAA2222000000000
32500   DATA 0000000002AAAAAAAAAAA22200000000
32510   DATA 00000000022211A11AAA222220000000
32520   DATA 00000000000211A11AAA222222000000
32530   DATA 000000000002AAAAAAAA222022000000
32540   DATA 000000000022A1111AAA222200000000
32550   DATA 00000000021111111AAAA22200000000
32560   DATA 00000000111111AAAAAAAA2220000000
32570   DATA 000000022111AAAAAAAA222222000000
32580   DATA 00000000001111AAAAAA222000000000
32590   DATA 00000000002111111AAAA22200000000
32600   DATA 00066600022211111AAAAA2220000000
32610   DATA 0006660022AAAAAAAAAAAA2222000000
32620   DATA 000066000222AAAAAAAAAAA222000000
32630   DATA 00000666666222222222222266000000
32640   DATA 00000006666022222222220006600000
32650   DATA 00000000000002222222200006600000
32660   DATA 00000000000000066600066066000000
32670   DATA 00000000000000066600066660000000
32680   DATA 00000000000000066600066600000000
32690   DATA 00000000000000066600000000000000
32700   DATA 00000000000000666660000000000000
32710   DATA 00000000000006666666600000000000
32720   DATA "@TEXEND"
32730   DATA "A:\GYAKU\tuti24.bmp",32,32,16
32740   DATA 00000000000000022220000000000020
32750   DATA 00000000000000222220000000000022
32760   DATA 00000000220002222222200000000020
32770   DATA 00000000222222222222220002200020
32780   DATA 000000000222222AAAA2222222000000
32790   DATA 000000000222AAAAAAAA222220002000
32800   DATA 00000000222222AAAAAAAA2220222000
32810   DATA 00000000000112AAAA11222220000000
32820   DATA 00000002201111AAA111120000000000
32830   DATA 000000002222A11A11A2222000000000
32840   DATA 0000000002AAA11A1AAAA22220020022
32850   DATA 0000000002222AAAAAAAA22222220020
32860   DATA 000000000002211A11A2112222000220
32870   DATA 000000000002AAAAAAA1112022000000
32880   DATA 00000000011111111AA1111200000000
32890   DATA 00000020021111111AAA122202200000
32900   DATA 0000002222A11AAAAAAAAA2222000022
32910   DATA 00000002222A11AAAAAA222222000020
32920   DATA 00000000002111AAAAAA222000000220
32930   DATA 00000002001111111AAAA22200000200
32940   DATA 00000002222111111AAAAA2220000000
32950   DATA 0000000222AAAAAAAAAAAA2222000000
32960   DATA 000000000222AAAAAAAAAAA222000000
32970   DATA 00000006666222222222222200000000
32980   DATA 00000066000022222222220660000000
32990   DATA 00000060000002222222200060000000
33000   DATA 00000060066000066600000060000000
33010   DATA 00000066066000066660006660000000
33020   DATA 00000006666000006660006660000000
33030   DATA 00000000666000006660006660000000
33040   DATA 00000000000000066666000000000000
33050   DATA 00000000000000666666660000000000
33060   DATA "@TEXEND"
33070   DATA "A:\GYAKU\tuti25.bmp",32,32,16
33080   DATA 00000E00000000022220000000000000
33090   DATA 0E000000000000222220000000000000
33100   DATA 000EEE00E000022AA222200000000000
33110   DATA 00EEEEE0000022AAAA22220000000000
33120   DATA 00EEEEE000022AAAAAA2222000000000
33130   DATA 00EEEEE00222AAAAAAAA222200220000
33140   DATA 0E0EEE00222222AAAAAAAA2220020000
33150   DATA 000000E0000022AAAA22222220020000
33160   DATA 0000E00000022AAAAA22220000000000
33170   DATA 000000000022AAAAAAA2222000000000
33180   DATA 0000000002AAAAAAAAAAA22200000000
33190   DATA 00000000022111A111AA222220000000
33200   DATA 000000000001AAAAA111222222022000
33210   DATA 000000000002AAAAAAAA222022002200
33220   DATA 00000000011111111AAA222200000000
33230   DATA 00000000021111111AAAA22200000000
33240   DATA 0000000022A11AAAAAAAAA2220000000
33250   DATA 00000002222A11AAAAAA222222002000
33260   DATA 00000000002111AAAAAA222000002000
33270   DATA 00000000001111111AAAA22200002200
33280   DATA 00000000022111111AAAAA2220000000
33290   DATA 0000000022AAAAAAAAAAAA2222000000
33300   DATA 000000000222AAAAAAAAAAA222000000
33310   DATA 00000000000222222222222200000000
33320   DATA 00000000000622222222220600000000
33330   DATA 00000000000602222222200666600000
33340   DATA 00000000066600066600000066660000
33350   DATA 00000000066600066600000000000000
33360   DATA 00000000000000006660000000000000
33370   DATA 00000000000000006660000000000000
33380   DATA 00000000000000006666600000000000
33390   DATA 00000000000000666666666000000000
33400   DATA "@TEXEND"
33410   DATA "A:\GYAKU\neru1.bmp",32,32,16
33420   DATA 00000000000000000000088888008880
33430   DATA 00000000000000000000000080000080
33440   DATA 00000000000000000000000880000800
33450   DATA 00000000000007770000000800008880
33460   DATA 00000000000777777770008888800000
33470   DATA 00000000007777777777700000000000
33480   DATA 00000000777111111111111000000000
33490   DATA 000000777111FFFFFFFFFF1100000000
33500   DATA 0000007111FFFFFFFFFFFFF110000000
33510   DATA 00000111FFFFFFFFFFFFFFFF10000000
33520   DATA 000011FFFFFFFFFFFFFFFFFF10000000
33530   DATA 00001FFFFFFFF111111111FF10000000
33540   DATA 00001FFFFF1111999999911F10000000
33550   DATA 00001FFF111999999999991110000000
33560   DATA 00001111199999999999999110000000
33570   DATA 00001199999999EEEEE9999910000000
33580   DATA 00001999999E99E99999EE9910000000
33590   DATA 00001999999E99E99999EEE910000000
33600   DATA 000019E9999E99EEEE99E99910000000
33610   DATA 000019E9999E99EE9999EE9910000000
33620   DATA 000019E9999E99E99999EEE910000000
33630   DATA 000019E9999E99E99999E9E910000000
33640   DATA 000019E99E9E99E99999E99910000000
33650   DATA 000019EEEE9E99999999EE9910000000
33660   DATA 000019EE9999999999999EE910000000
33670   DATA 00001999999999999999999910000000
33680   DATA 00001999999999999999999910000000
33690   DATA 00001999999999999999999910000000
33700   DATA 00001999999911111119999910000000
33710   DATA 00001999911117707711199910000000
33720   DATA 00001191117777000777119910000000
33730   DATA 00000111077770000777011110000000
33740   DATA "@TEXEND"
33750   DATA "A:\GYAKU\neru2.bmp",32,32,16
33760   DATA 00000000000000000000000888880888
33770   DATA 00000000000000000000000000800080
33780   DATA 00000000000000000000000008000088
33790   DATA 00000000000007770000000080000000
33800   DATA 00000000000777777770000088880000
33810   DATA 00000000007777777777700000000000
33820   DATA 00000000777111111111111000000000
33830   DATA 000000777111FFFFFFFFFF1100000000
33840   DATA 0000077711FFFFFFFFFFFFF110000000
33850   DATA 00000777FFFFFFFFFFFFFFFF10000000
33860   DATA 00001777FFFFFFFFFFFFFFFF10000000
33870   DATA 00001777FFFFF111111111FF10000000
33880   DATA 00001777FF1111999999911F10000000
33890   DATA 00001FFF111999999999991110000000
33900   DATA 00001111199999999999999110000000
33910   DATA 00001199999999AAAAA9999910000000
33920   DATA 00001999999A99A99999AA9910000000
33930   DATA 00001999999A99A99999AAA910000000
33940   DATA 000019A9999A99AAAA99A99910000000
33950   DATA 000019A9999A99AA9999AA9910000000
33960   DATA 000019A9999A99A99999AAA910000000
33970   DATA 000019A9999A99A99999A9A910000000
33980   DATA 000019A99A9A99A99999A99910000000
33990   DATA 000019AAAA9A99999999AA9910000000
34000   DATA 000019AA9999999999999AA910000000
34010   DATA 00001999999999999999999910000000
34020   DATA 00001999999999999999999910000000
34030   DATA 00001999999999999999999910000000
34040   DATA 00001999999911111119999910000000
34050   DATA 00001999911117707711199910000000
34060   DATA 00001191117777000777119910000000
34070   DATA 00000111077770000777011110000000
34080   DATA "@TEXEND"
34090   DATA "A:\GYAKU\icon.bmp",16,14,16
34100   DATA 0000000000000000
34110   DATA 0000000000000000
34120   DATA 0000000000000000
34130   DATA 0000000000000000
34140   DATA 0000000000FFFFF0
34150   DATA 00000000FF88F8F0
34160   DATA 00000FFFF888F8F0
34170   DATA 000FFF888888F8F0
34180   DATA 00FF88888888F8F0
34190   DATA 0F8888FFFFFFFFF0
34200   DATA 0F8FFFF777888800
34210   DATA 0FFF777888000000
34220   DATA 0FF8888000000000
34230   DATA 0088000000000000
34240   DATA "@TEXEND"
34250   DATA "A:\GYAKU\icon2.bmp",16,15,16
34260   DATA 0000000000000000
34270   DATA 0000000000000000
34280   DATA 0000000000000000
34290   DATA 0000000000000000
34300   DATA 0000000000FFFFF0
34310   DATA 00000000FF88F8F0
34320   DATA 00000FFFF888F8F0
34330   DATA 000FFF888888F8F0
34340   DATA 00FF88888888F8F0
34350   DATA 0F8888FFFFFFFFF0
34360   DATA 0F8FFFF087777780
34370   DATA 0FFF000887788800
34380   DATA 0FF0008878880000
34390   DATA 0000088888000000
34400   DATA 0000088800000000
34410   DATA "@TEXEND"
34420   DATA "A:\GYAKU\icon3.bmp",16,14,16
34430   DATA 000000C400000000
34440   DATA 00000CCC40000000
34450   DATA 00EEC4CCC4000000
34460   DATA 00ECCC4CCC400000
34470   DATA 00CC4CC4CCC00000
34480   DATA 0C4CC4CC4C000000
34490   DATA CCC4CC4CC0000000
34500   DATA 4CCC4CCCE0000000
34510   DATA 04CCC4CEEE000000
34520   DATA 004CCC00EEE00000
34530   DATA 0004C0000EEE0000
34540   DATA 0000000000EEE000
34550   DATA 00000000000EEE00
34560   DATA 000000000000E000
34570   DATA "@TEXEND"
34580   DATA "A:\GYAKU\icon4.bmp",16,15,16
34590   DATA 0000000007770000
34600   DATA 0000000078888000
34610   DATA 0000000788888000
34620   DATA 000000788FFFFF00
34630   DATA 00000788FFFFFF00
34640   DATA 0000078FFFFFFFF0
34650   DATA 0000788FFFFFFFF0
34660   DATA 000078FFFFFFFFF0
34670   DATA 00078FFFFFFF0000
34680   DATA 00078FFFFF000000
34690   DATA 00078FFF00000000
34700   DATA 0098FF0000000000
34710   DATA 0099F00000000000
34720   DATA 0091000000000000
34730   DATA 0090000000000000
34740   DATA "@TEXEND"
34750   DATA "A:\GYAKU\mesi.bmp",32,32,16
34760   DATA 00000000000000000000000000000000
34770   DATA 00000000000000000000000000000000
34780   DATA 00000000000000000000000000000000
34790   DATA 00000000F00000000000000000000000
34800   DATA 00000000F000000000000000FF000000
34810   DATA 00000000F00000000FF0000FF0000000
34820   DATA 00000000F0000000FF0000FF00000000
34830   DATA 00000000FF000000F00000F000000000
34840   DATA 000000000F00000000000F0000000000
34850   DATA 000000000F000000000000000FF00000
34860   DATA 000000000000000F000000000F000000
34870   DATA 00000000000F0000F00000000F000000
34880   DATA 00000000000F0000FF000F00F0000000
34890   DATA 00000000000F00000F000F0000000000
34900   DATA 00000000000F00000F000F0000000000
34910   DATA 00000000000F0000FF000F0F00000000
34920   DATA 0000000000FF000FF000FF0F00000000
34930   DATA 000000000FF000FF000FF00F00000000
34940   DATA 00000000200000000000000F00000000
34950   DATA 00000002200000004444444444000000
34960   DATA 0000002222AEEEE44444444444440000
34970   DATA 0000002222AEEE444444444444444000
34980   DATA 000FFA22A2AEEEEE4444444444444F00
34990   DATA 00FFFAA222AAEEEEE44444444444EFF0
35000   DATA 088FFAAA2AAAEEEEE4444444EEEEEFFF
35010   DATA 078FFFAAAAEAAEEEEEEEEEEEEEEEFFFF
35020   DATA 078FFFFEEAEAAEEEEEEEEEEEEEEFFFFF
35030   DATA 078888FFAFFAAEEEEEEEEEEFFFFFFFF8
35040   DATA 077778FFFFFFFFFFFFFFFFFFFFFFF888
35050   DATA 000778888FFFFFFFFFFFFFFFFFF88800
35060   DATA 00000077788FFFFFFFFFFFF888880000
35070   DATA 00000000008888888888888800000000
35080   DATA "@TEXEND"
35090   DATA "A:\GYAKU\mesi2.bmp",32,32,16
35100   DATA 00000000000000000000000000000000
35110   DATA 00000000000000000000000000000000
35120   DATA 00000000000000000000000000000000
35130   DATA 00000000F00000000000000000000000
35140   DATA 00000000F000000000000000FF000000
35150   DATA 00000000F00000000FF0000FF0000000
35160   DATA 00000000F0000000FF0000F000000000
35170   DATA 00000000FF000000F000000000000000
35180   DATA 000000000F0000000000000000000000
35190   DATA 000000000F0000000000000000000000
35200   DATA 000000000000000F0000000000000000
35210   DATA 00000000000F0000F000000000000000
35220   DATA 00000000000F00000000000000000000
35230   DATA 00000000000F00000000000000000000
35240   DATA 00000000000F00000000000000000000
35250   DATA 00000000000F00000000000000000000
35260   DATA 0000000000FF00000000000000000000
35270   DATA 000000000FF000000000000000000000
35280   DATA 00000000200000000000000000000000
35290   DATA 00000002200000000000000000000000
35300   DATA 0000002222AEEEE00000000000040000
35310   DATA 0000002222AEEE4FFFFFFFFFF4F44000
35320   DATA 000FFA22A2AEEEEEFFFFF4444FF44F00
35330   DATA 00FFFAA222AAEEEEFF44FFF444F4EFF0
35340   DATA 088FFAAA2AAAEEEEFF4FFFF44FFEEFFF
35350   DATA 078FFFAAAAEAAEEEEF4FFF4F4EEEFFFF
35360   DATA 078FFFFEEAEAAEEEEEEEEE4EEEEFFFFF
35370   DATA 078888FFAFFAAEEEEEEEEEEFFFFFFFF8
35380   DATA 077778FFFFFFFFFFFFFFFFFFFFFFF888
35390   DATA 000778888FFFFFFFFFFFFFFFFFF88800
35400   DATA 00000077788FFFFFFFFFFFF888880000
35410   DATA 00000000008888888888888800000000
35420   DATA "@TEXEND"
35430   DATA "A:\GYAKU\mesi3.bmp",32,32,16
35440   DATA 00000000000000000000000000000000
35450   DATA 00000000000000000000000000000000
35460   DATA 00000000000000000000000000000000
35470   DATA 00000000F00000000000000000000000
35480   DATA 00000000F00000000000000000000000
35490   DATA 00000000F00000000F00000000000000
35500   DATA 0000000000000000F000000000000000
35510   DATA 000000000F000000F000000000000000
35520   DATA 00000000000000000000000000000000
35530   DATA 000000000F0000000000000000000000
35540   DATA 000000000000000F0000000000000000
35550   DATA 0000000000000000F000000000000000
35560   DATA 00000000000000000000000000000000
35570   DATA 00000000000000000000000000000000
35580   DATA 00000000000000000000000000000000
35590   DATA 00000000000000000000000000000000
35600   DATA 00000000000F00000000000000000000
35610   DATA 00000000000000000000000000000000
35620   DATA 00000000000000000000000000000000
35630   DATA 00000000000000000000000000000000
35640   DATA 00000000000000000000000000000000
35650   DATA 0000000000FFFFFFFFFF44F000000000
35660   DATA 000FFFFFFFFFFFFFFFFF44FFFFFFFF00
35670   DATA 00FFFFFFFFFFFFFFFFF44FF4444FFFF0
35680   DATA 088FFFFFFFFFFFFFFFF4FF44F44FFFFF
35690   DATA 078FFFFFAAFFFFFFFFFFFFFFFFFFFFFF
35700   DATA 078FFFFFFAAFFFFFFFFFFFFFFFFFFFFF
35710   DATA 078888FFFFAFFFFFFFFFF44FFFFFFFF8
35720   DATA 077778FFFFFFFFFFFFFFFFFFFFFFF888
35730   DATA 000778888FFFFFFFFFFFFFFFFFF88800
35740   DATA 00000077788FFFFFFFFFFFF888880000
35750   DATA 00000000008888888888888800000000
35760   DATA "@TEXEND"
35770   DATA "A:\GYAKU\benkyou.bmp",32,32,16
35780   DATA 00000000000000000000000000000000
35790   DATA 00000000000000000000000000000000
35800   DATA 00000000111111110011111111110000
35810   DATA 000000111FFFFFF1011FFFFFFFF10000
35820   DATA 0000111FFFFFFFF111FFFF9FFFF11000
35830   DATA 00011FFFFFFFFFFF1FFFFF9FFFFF1000
35840   DATA 0011FFFFFFFFF99F1FFFF9999FFF1100
35850   DATA 001FFFF99FF99F9F1FFF9999FFFFF100
35860   DATA 001FFFF999FF9FFF1FFFFFF999FFF100
35870   DATA 001FFF99F99FFFFF1FFFFF9999FFF100
35880   DATA 001FFF9FFF99FFFF1FF99FFFF9FFF100
35890   DATA 001FF99FFFF99FFF1FF9FFFF99FFF100
35900   DATA 001FFFFFFFFF99FF1FF99FFFFFFFF100
35910   DATA 001FFFFFFFFFF9FF1FF9999FFF9FF100
35920   DATA 001FFFFFFFFFFFFF1FFFF99FFF9FF100
35930   DATA 001FFFFF9FFFFFFF1FFFFFFFFF99F100
35940   DATA 001FFFF99FFFFFFF1FFFFFFF999FF100
35950   DATA 001FFFF9FFFFFFFF1FFFFFFF999FF100
35960   DATA 001FFF9FFFFFF9FF1FFFFFFF9999F100
35970   DATA 001FFF9F9FFFF9FF1FFFFFFFFFFFF100
35980   DATA 001FFF999FFFF9FF1FFFFF99FFFFF100
35990   DATA 001FFF9999FF99FF1FFFFF99FFFFF100
36000   DATA 001FF99FF9999FFF1FFFFF99FFFFF100
36010   DATA 001FF9FFF999FFFF1FFFFF99FFFFF100
36020   DATA 001FF9FFFFFFFFFF1FFFFFFFFFFFF100
36030   DATA 001FFFFFFF11111F1FF1111111FFF100
36040   DATA 001FFFFF111777111F117777711FF100
36050   DATA 001FFF1117700771111770007711F100
36060   DATA 001FF117770000777777000007711100
36070   DATA 001F1177000000077770000000777100
36080   DATA 001F1770000000000000000000077000
36090   DATA 00111700000000000000000000000000
36100   DATA "@TEXEND"
36110   DATA "A:\BITMAP\Enpitu.bmp",24,20,16
36120   DATA 000000011111100000000000
36130   DATA 0000011E9999E11000000000
36140   DATA 0001199EEEEEE99110000000
36150   DATA 001F9EEEE11EEEE9F1000000
36160   DATA 0019EEEEE11EEEEE91000000
36170   DATA 019EEEEE1881EEEEE9100000
36180   DATA 019EEEE188881EEEE9100000
36190   DATA 1F9EEEE118811EEEE9F10000
36200   DATA 19EEEEE191191EEEEE910000
36210   DATA 19EEEEE199991EEEEE910000
36220   DATA 19EEEEE199991EEEEE910000
36230   DATA 19EEEEE199991EEEEE910000
36240   DATA 1F9EEEE199991EEEE9F10000
36250   DATA 019EEEE199991EEEE9100000
36260   DATA 019EEEE199991EEEE9100000
36270   DATA 0019EEE199991EEE91000000
36280   DATA 001F9EEE1111EEE9F1000000
36290   DATA 0001199EEEEEE99110000000
36300   DATA 0000011E9999E11000000000
36310   DATA 000000011111100000000000
36320   DATA "@TEXEND"
36330   DATA "A:\BITMAP\Gohan.BMP",24,20,16
36340   DATA 000000011111100000000000
36350   DATA 0000011E9999E11000000000
36360   DATA 0001199EE888E99110000000
36370   DATA 001F9EEE8FFFEEE9F1000000
36380   DATA 0019EEEE8FFF8EEE91000000
36390   DATA 019EEEE8FFFF8EEEE9100000
36400   DATA 019EEE8FFFFFF8EEE9100000
36410   DATA 1F9EEE8FFFFFF8EEE9F10000
36420   DATA 19EE11FFFFFFFF8EEE910000
36430   DATA 19EE1111FFFFFF11EE910000
36440   DATA 19EE119111F11111EE910000
36450   DATA 19EEE1999111991EEE910000
36460   DATA 1F9EE1199999991EE9F10000
36470   DATA 019EEE119999911EE9100000
36480   DATA 019EEEE1999911EEE9100000
36490   DATA 0019EEE111111EEE91000000
36500   DATA 001F9EEE1111EEE9F1000000
36510   DATA 0001199EEEEEE99110000000
36520   DATA 0000011E9999E11000000000
36530   DATA 000000011111100000000000
36540   DATA "@TEXEND"
36550   DATA "A:\GYAKU\megane.bmp",32,10,16
36560   DATA 00000000777770000077770000000000
36570   DATA 00000007777777000777777000000000
36580   DATA 00000007700007007000007700000000
36590   DATA 00000077000000770000000777000000
36600   DATA 00000077000000770000000777000000
36610   DATA 00000077000000770000000777000000
36620   DATA 00000077000000770000000777000000
36630   DATA 00000007700007007000007700000000
36640   DATA 00000007777777000777777000000000
36650   DATA 00000000777770000077770000000000
36660   DATA "@TEXEND"
36670   DATA "A:\GYAKU\ie.bmp",64,64,16
36680   DATA 0000000000000000000000000000000440000000000000000000000000000000
36690   DATA 0000000000000000000000000000004440000000000000000000000000000000
36700   DATA 0000000000000000000000000000444440000000000000000000000000000000
36710   DATA 0000000000000000000000000004444444000000000000000000000000000000
36720   DATA 0000000000000000000000000444444444000000000000000000000000000000
36730   DATA 0000000000000000000000004444444444000000000000000000000000000000
36740   DATA 0000000000000000000000444444444444400000000000000000000000000000
36750   DATA 0000000000000000000004444444444444400000000000000000000000000000
36760   DATA 0000000000000000000444444444444444400000000000000000000000000000
36770   DATA 0000000000000000004444444444444444440000000000000000000000000000
36780   DATA 0000000000000000444444444444444444440000000000000000000000000000
36790   DATA 0000000000000004444444444444444444440000000000000000000000000000
36800   DATA 0000000000000044444444444444444444444000000000000000000000000000
36810   DATA 0000000000000444444444444444444444444000000000000000000000000000
36820   DATA 00000000000044444444444444444CCCCCCCCC00000000000000000000000000
36830   DATA 0000000000044444444444444444CCCCCCCCCCC0000000000000000000000000
36840   DATA 000000000004444444444444444CCCCCCCCCCCC0000000000000000000000000
36850   DATA 00000000000444444444444444CCCCCCCCCCCCC0000000000000000000000000
36860   DATA 00000000004444444444444444CCCCCCCCCCCCC0000000000000000000000000
36870   DATA 00000000004444444444444444CCCCCCCCCC77C0000000000000000000000000
36880   DATA 00000000004444444444444444CCCCCCCCCCB7C0000000000000000000000000
36890   DATA 00000000044444444444444444CCCCCCCCCBB774000000000000000000000000
36900   DATA 0000000004444F444444444444CCCCCCCCCB7B74000000000000000000000000
36910   DATA 0000000004444F444444444444CCCCCCCCC7BB77444444444444444440000000
36920   DATA 0000000004444FF44444444444447BBBBB77BBB7444444444444444440000000
36930   DATA 000000004444FFF444444444444447BBB7B77B77444444444444444400000000
36940   DATA 000000004444FFFF44444444444444777BBB7774444444444444444000000000
36950   DATA 000000004444FFFF444444444444444BBBBB7744444444444444448000000000
36960   DATA 00000004444FFFFFF444444444444447BBB77444444444444444488000000000
36970   DATA 00000004444FFFFFF444444444444444BB774444444444444444888000000000
36980   DATA 00000004444FFFFFFF4444444444444477444444444444444448888000000000
36990   DATA 00000044444FFFFFFF4444444444444444444444444444444488888000000000
37000   DATA 0000004444FFFFFFFFF444444444444444444444444444444888788000000000
37010   DATA 0000004444FFFFFFFFF444444444444444444444444444448887788000000000
37020   DATA 0000004444FFFFFFFFFF4444444444444444444444444448887B788000000000
37030   DATA 000004444FFFFFFFFFFF444444444444444444444444448887BB788000000000
37040   DATA 000004444FFF111111FFF4444444444444444444444448887BBB788000000000
37050   DATA 000004444FF11111111FF4444444444444444444444488877BBB788000000000
37060   DATA 000044444F1111111111FF4444444444444444444448887B7BBB788000000000
37070   DATA 000044444F1111111111FF444444444444444444448887BB7BB7788000000000
37080   DATA 000044444F1111111111FFF4444444444444444448887BBB7B7B788000000000
37090   DATA 000444444F1111111111FFFFFFFFFFFFFFFFFFFF8887BBBB77BB788000000000
37100   DATA 000444440F1111111111FFFFFFFF7777FFFFFFFF887BBBBB7BBB788000000000
37110   DATA 000044400F1111111111FFFFFF77B7BB77FFFFFF887BBBB77BBB788000000000
37120   DATA 000000000F1111111111FFFFFF7BB7BBB7FFFFFF887BBB7B7BBB788000000000
37130   DATA 000000000F1111111111FFFFF7BBB7BBBB7FFFFF887BB7BB7BB7888000000000
37140   DATA 000000000F1111111111FFFFF7BBB7BBBB7FFFFF887B7BBB7B78888000000000
37150   DATA 000000000F1111111111FFFFF7BBB7BBBB7FFFFF8877BBBB7788888000000000
37160   DATA 000000000F1111111111FFFF7BBBB7BBBBB7FFFF887BBBBB7888888000000000
37170   DATA 000000000F1111111111FFFF7BBBB7BBBBB7FFFF887BBBB78888888000000000
37180   DATA 000000000F1111117781FFFF7BBBB7BBBBB7FFFF887BBB788888888000000000
37190   DATA 000000000F1111117781FFFF777777777777FFFF887BB7888888880000000000
37200   DATA 000000000F1111117781FFFF7BBBB7BBBBB7FFFF887B78888888800000000000
37210   DATA 000000000F1111117781FFFF7BBBB7BBBBB7FFFF887788888888000000000000
37220   DATA 000000000F1111111111FFFF7BBBB7BBBBB7FFFF887888888880000000000000
37230   DATA 000000000F1111111111FFFF7BBBB7BBBBB7FFFF888888888800000000000000
37240   DATA 000000000F1111111111FFFF7BBBB7BBBBB7FFFF888888888000000000000000
37250   DATA 000000000F1111111111FFFF7BBBB7BBBBB7FFFF888888880000000000000000
37260   DATA 000000000F1111111111FFFF7BBBB7BBBBB7FFFF888888800000000000000000
37270   DATA 000000000F1111111111FFFF777777777777FFFF888888000000000000000000
37280   DATA 000000000F1111111111FFFFFFFFFFFFFFFFFFFF888880000000000000000000
37290   DATA 000000000F1111111111FFFFFFFFFFFFFFFFFFFF888800000000000000000000
37300   DATA 000000000F1111111111FFFFFFFFFFFFFFFFFFFF888000000000000000000000
37310   DATA 000000000F1111111111FFFFFFFFFFFFFFFFFFFFF80000000000000000000000
37320   DATA "@TEXEND"
37330   DATA "A:\GYAKU\ki.bmp",32,48,16
37340   DATA 0000000000002222AA00000000000000
37350   DATA 00000000002222AAAAAA000000000000
37360   DATA 0000000002222AAAAAAAA00000000000
37370   DATA 00000002222AAAAAAAAAAAA000000000
37380   DATA 0000002222AAAAAAAAAAAAAA00000000
37390   DATA 000000222AAAAAAAAAAAAAAA00000000
37400   DATA 000002222AAAAAAAAA44AAAAA0000000
37410   DATA 00000222AAAAAAAAAAA4AAAAA0000000
37420   DATA 0000222AAAAAAAAAAAA4AAAAAA000000
37430   DATA 0002222AAAAAAAAA44C4CAAAAAA00000
37440   DATA 000222AAAAAAAAA44444CCAAAAA00000
37450   DATA 000222AAAAAAAAA4CC4CCCCAAAA00000
37460   DATA 002222AAAAAAAAA4CC444CCAAAAA0000
37470   DATA 00222AAAAAAAAAA4CCCCCCCAAAAA0000
37480   DATA 00222AAAAAAAAAA4CCCCCCCAAAAA0000
37490   DATA 00222AAAAAAAAAA4CCCCCCCAAAAA0000
37500   DATA 00222AAAAAAAAAA44CCCCCAAAAAA0000
37510   DATA 0222AAAAAAAAAAAA44CCCAAAAAAAA000
37520   DATA 0222AAAAAAAAAAAAAAAAAAAAAAAAA000
37530   DATA 0222AAAAAAAAAAAAAAAAAAAAAAAAA000
37540   DATA 0222AAAAAA44AAAAAAAAAAAAAAAAA000
37550   DATA 0222AAAAAAA44AAAAAAAAAAAAAAAA000
37560   DATA 0222AAAAAAAA4AAAAAAAAAAAAAAAA000
37570   DATA 0222AAAAA4CC4CAAAAAAAAAAAAAAA000
37580   DATA 0222AAAA44C44CCAAAAAAAAAA44AA000
37590   DATA 0222AAAA4CC4CCCAAAAAAAAAAA4AA000
37600   DATA 0222AAA44CC444CCAAAAAAAAAA4AA000
37610   DATA 0222AAA4CCCCCCCCAAAAAAAAAA4AA000
37620   DATA 0222AAA4CCCCCCCCAAAAAAA44C4CA000
37630   DATA 0222AAA44CCCCCCCAAAAAA44CC4CC000
37640   DATA 0222AAAA4CCCCCCAAAAAAA4CC4CCC000
37650   DATA 0222AAAA44CCCCCAAAAAA44CC444CC00
37660   DATA 0222AAAAA4CCCCAAAAAAA44CCCCCCC00
37670   DATA 0222AAAAAAAAAAAAAAAAA44CCCCCCC00
37680   DATA 0222AAAAAAAAAAAAAAAAA44CCCCCCC00
37690   DATA 0022AAAAAAAAAAAAAAAAAA44CCCCC000
37700   DATA 0022AAAAAAAAAAAAAAAAAAA4CCCCC000
37710   DATA 0022AAAAAAAAAAAAAAAAAAA4CCCCA000
37720   DATA 00022AAAAAAAAAAAAAAAAAAAAAAAA000
37730   DATA 00022AAAAAAAAAAAAAAAAAAAAAAA0000
37740   DATA 000000AAAAAAAAAAAAAAAAAAAAA00000
37750   DATA 000000000AAAAAAAAAAAA00000000000
37760   DATA 0000000000AAAAAAAAAA000000000000
37770   DATA 000000000066AAAAAA40000000000000
37780   DATA 00000000006644444440000000000000
37790   DATA 00000000006644444444000000000000
37800   DATA 00000000066644444444000000000000
37810   DATA 00000000066444444444000000000000
37820   DATA "@TEXEND"
37830   DATA "A:\GYAKU\ki2.bmp",32,48,16
37840   DATA 0000000000002222AA00000000000000
37850   DATA 00000000002222AAAAAA000000000000
37860   DATA 0000000002222AAAAAAAA00000000000
37870   DATA 00000002222AAAAAAAAAAAA000000000
37880   DATA 0000002222AAAAAAAAAAAAAA00000000
37890   DATA 000000222AAAAAAAAAAAAAAA00000000
37900   DATA 000002222AAAAAAA44AAAAAAA0000000
37910   DATA 00000222AAAAAAAAA4AAAAAAA0000000
37920   DATA 0000222AAAAAAAAAA4AAAAAAAA000000
37930   DATA 0002222AAAAAAA44C4CAAAAAAAA00000
37940   DATA 000222AAAAAAA44444CCAAAAAAA00000
37950   DATA 000222AAAAAAA4CC4CCCCAAAAAA00000
37960   DATA 002222AAAAAAA4CC444CCAAAAAAA0000
37970   DATA 00222AAAAAAAA4CCCCCCCAAAAAAA0000
37980   DATA 00222AAAAAAAA4CCCCCCCAAAAAAA0000
37990   DATA 00222AAAAAAAA4CCCCCCCAAAAAAA0000
38000   DATA 00222AAAAAAAA44CCCCCAAAAAAAA0000
38010   DATA 0222AAAAAAAAAA44CCCAAAAAAAAAA000
38020   DATA 0222AAAAAAAAAAAAAAAAAAAAAAAAA000
38030   DATA 0222AAAAAAAAAAAAAAAAAAAAAAAAA000
38040   DATA 0222AAAAAAA44AAAAAAAAAAAAAAAA000
38050   DATA 0222AAAAAAAA44AAAAAAAAAAAAAAA000
38060   DATA 0222AAAAAAAAA4AAAAAAAAAAAAAAA000
38070   DATA 0222AAAAAA4CC4CAAAAAAAAAAA44A000
38080   DATA 0222AAAAA44C44CCAAAAAAAAAAA4A000
38090   DATA 0222AAAAA4CC4CCCAAAAAAAAAAA4A000
38100   DATA 0222AAAA44CC444CCAAAAAAAAAA4A000
38110   DATA 0222AAAA4CCCCCCCCAAAAAAA44C4C000
38120   DATA 0222AAAA4CCCCCCCCAAAAAA44CC4CC00
38130   DATA 0222AAAA44CCCCCCCAAAAAA4CC4CCC00
38140   DATA 0222AAAAA4CCCCCCAAAAAA44CC444CC0
38150   DATA 0222AAAAA44CCCCCAAAAAA44CCCCCCC0
38160   DATA 0222AAAAAA4CCCCAAAAAAA44CCCCCCC0
38170   DATA 0222AAAAAAAAAAAAAAAAAA44CCCCCCC0
38180   DATA 0222AAAAAAAAAAAAAAAAAAA44CCCCC00
38190   DATA 0022AAAAAAAAAAAAAAAAAAAA4CCCCC00
38200   DATA 0022AAAAAAAAAAAAAAAAAAAA4CCCC000
38210   DATA 0022AAAAAAAAAAAAAAAAAAAAAAAAA000
38220   DATA 00022AAAAAAAAAAAAAAAAAAAAAAAA000
38230   DATA 00022AAAAAAAAAAAAAAAAAAAAAAA0000
38240   DATA 000000AAAAAAAAAAAAAAAAAAAAA00000
38250   DATA 000000000AAAAAAAAAAAA00000000000
38260   DATA 0000000000AAAAAAAAAA000000000000
38270   DATA 000000000066AAAAAA40000000000000
38280   DATA 00000000006644444440000000000000
38290   DATA 00000000006644444444000000000000
38300   DATA 00000000066644444444000000000000
38310   DATA 00000000066444444444000000000000
38320   DATA "@TEXEND"
38330   DATA "A:\GYAKU\umi1.bmp",80,20,16
38340   DATA 00000000000000000000000000000000000000000000000000000000000000000000000000000000
38350   DATA 00000000000000000000000000000000000000000000000000000000000000000000000000000000
38360   DATA 00000000000000000000000000000000000000000000000000000000000000000000000000000000
38370   DATA 00000000000000000000000000000000000000000000000000000000000000000000000000000000
38380   DATA 00000000000000000000000000000000000000000000000000000000000000000000000000000000
38390   DATA 00000000000000000000000000000000000000000000000000000000000000000000000000000000
38400   DATA 00000000000000000000000000000000000000000000000000000000000000000000000000000000
38410   DATA 00000000000000000000000000000000000000000000000000000000000000000000000000000000
38420   DATA 0000000000000000000000000000000000000000000000000000000000000000000BBBBBBBBBBBBB
38430   DATA 0000000000000000000000000000000000000000000000000000000000000000BBBBBBBBBBB99999
38440   DATA 00000000000000000000000000000000000000000000000000000000000000BBBBBB9999999999F9
38450   DATA 000000000000000000000000000000000000000000000000000000000000000BBBBB999999999999
38460   DATA 0000000000000000000000000000000000000000000000000000000000000BBBBBBB999999999F99
38470   DATA 0000000000000000000000000000000000000000000000000000000000BBBBBBBB9999999F999999
38480   DATA 0000000000000000000000000000000000000000000000000000BBBBBBBBBBB99999999F99999991
38490   DATA 0000000000000000000000000000000000000000000000000000BBBBBBB99999999999999999F991
38500   DATA 00000000000000000000000000000000000000000000000000000BBBBB9999999999F99999999F11
38510   DATA 000000000000000000000000000000000000000000000000000BBBBBBB999999999999F999999111
38520   DATA 0000000000000000000000000000000000000000000000000BBBBBBBBBB999999FF99999FF99F1F1
38530   DATA 00000000000000000000000000000000000000000000000BBBBBBBBBB99999999999999999991111
38540   DATA "@TEXEND"
38550   DATA "A:\GYAKU\umi2.bmp",80,20,16
38560   DATA 00000000000000000000000000000000000000000000000BBBBBBBBBB99999999999999999991111
38570   DATA 0000000000000000000000000000000000000000000000BBBBBBBBBBB9999999999999999F911111
38580   DATA 00000000000000000000000000000000000000000BBBBBBBBBBBBBB999999999F99F99991F911111
38590   DATA 00000000000000000000000000000000000000000BBBBBBBBBBB999999999999999999991F111F11
38600   DATA 00000000000000000000000000000000000000000BBBBBBBBBB9999999F999999999999919111111
38610   DATA 0000000000000000000000000000000000000000BBBBBBBBBBB9999F9999999999F999911911F111
38620   DATA 000000000000000000000000000000000000000BBBBBBBBBBBB9999999999999999999F99911F111
38630   DATA 00000000000000000000000000000000000000BBBBBBBBBBB99999999999F9999999999991111111
38640   DATA 00000000000000000000000000000000000000BBBBBBBBB9999999999999F9999999999191111111
38650   DATA 0000000000000000000000000000000000000BBBBBBBB999999999999999999999F9999911111111
38660   DATA 000000000000000000000000000000000000BBBBBBBBB999999F99999999999999999991111111F1
38670   DATA 00000000000000000000000000000000000BBBBBBBBBB99999999F9999999F99999F99911F111111
38680   DATA 000000000000000000000000000000000BBBBBBBBBBBBBB999999999999999999999991111111F11
38690   DATA 00000000000000000000000000000000BBBBBBBBBBBBBBB99999999999999999999999191F111111
38700   DATA 000000000000000000000000000000BBBBBBBBBBBBB99999F99999999999F9999999999F11111111
38710   DATA 00000000000000000000000000000BBBBBBBBBBBB9999999999999999999F999999991911111F111
38720   DATA 00000000000000000000000000000BBBBBBBBBBB999999999999FF99999999999999F99111111F11
38730   DATA 0000000000000000000000000000BBBBBBBBBBB9999999999F99999999999999999991F111111111
38740   DATA 00000000000000000000000000000BBBBBBBBBBBBBB999999999999F999999999FF91111FF11F1F1
38750   DATA 00000000000000000000000000000BBBBBBBBBBBBBBB999999999999999999999999111111111111
38760   DATA "@TEXEND"
38770   DATA "A:\GYAKU\umi3.bmp",80,20,16
38780   DATA 0000000000000000000000000000BBBBBBBBBBBBBBBB999999999999999999999999111111111111
38790   DATA 000000000000000000000000000BBBBBBBBBBBBBBBB999F99999999999F99999991111111F111111
38800   DATA 000000000000000000000000000BBBBBBBBBBBBBBB99999999F9999999999999F11F11111F111111
38810   DATA 00000000000000000000000000BBBBBBBBBBBBBB9F9999999FF9999999999999911111111F111F11
38820   DATA 000000000000000000000000BBBBBBBBBBBBB99999999999F999999999F999999111111111111111
38830   DATA 0000000000000000000000BBBBBBBBBBBBBB999999999F999999999F9999999911F111111111F111
38840   DATA 00000000000000000000BBBBBBBBBBBBB99999999999F9999999F99999999999111111F11111F111
38850   DATA 000000000000000000BBBBBBBBBBBBBB9999999999999999999F99999999F9111111111111111111
38860   DATA 0000000000000000BBBBBBBBBBBBBBB99999999999999F99999999999999F1111111111111111111
38870   DATA 000000000000000BBBBBBBBBBBBBBBB999999F9999F99999999999999999911111F1111111111111
38880   DATA 000000000000000BBBBBBBBBBBBBBBBBB999999999F99999999F99999999111111111111111111F1
38890   DATA 000000000000000BBBBBBBBBBBBBBBBBBBB999999F99999999999F9999999F11111F11111F111111
38900   DATA 0000000000000000BBBBBBBBBBBBBBBBB99999999999999999999999999999111111111111111F11
38910   DATA 00000000000000000BBBBBBBBBBBBBBB99999999999999999999999999999111111111111F111111
38920   DATA 00000000000000000BBBBBBBBBBBBB999999F99999999999F99999999999F1111111111F11111111
38930   DATA 00000000000000000BBBBBBBBBBBB99999999999999FF999999999999999F911111111111111F111
38940   DATA 000000000000000BBBBBBBBBBBBBB99999999999999999999999FF99999991111111F11111111F11
38950   DATA 00000000000000BBBBBBBBBBBBBB9999999999999F99F9999F99999999991111111111F111111111
38960   DATA 0000000000000BBBBBBBBBBBBBBBB999999F9999999999999999999F999111111FF11111FF11F1F1
38970   DATA 000000000000BBBBBBBBBBBBBBBBB999999999999999999999999999999111111111111111111111
38980   DATA "@TEXEND"
38990   DATA "A:\GYAKU\umi4.bmp",80,20,16
39000   DATA 0000000000BBBBBBBBBBBBBBBBBBBBB999999999999999999999999991919F11111111111111F111
39010   DATA 000000000BBBBBBBBBBBBBBBBBB999999999999999F999F99999999911F11111111111111F1111F1
39020   DATA 0000000BBBBBBBBBBBBBBBBBB9999999999999999999999999F9999911991111FF1F11111F111111
39030   DATA 00000BBBBBBBBBBBBBBBBBBB99999999999F99999F9999999FF9999911991111111111111F111F11
39040   DATA 0000BBBBBBBBBBBBBBBBBBB9999999999999999999999999F999999111F111111111111111111111
39050   DATA 0000BBBBBBBBBBBBBBBBBB99999999999999999999999F99999999919111111111F11111F111F111
39060   DATA 00000BBBBBBBBBBBBBBBB99999999999999F99999999F9999999F99991111111111111F1F111F111
39070   DATA 00000BBBBBBBBBBBBBBBB999999999999999999999999999999F99991111F1111111111FF1111111
39080   DATA 00000BBBBBBBBBBBBBBBBBBB999999999999999999999F99999999911111F1111111111111111111
39090   DATA 0000BBBBBBBBBBBBBBBBBBB9999999999999FF9999F99999999999911111111111F1111111111111
39100   DATA 000BBBBBBBBBBBBBBBBBBB99999999999999999999F99999999F999911111111F1111111111111F1
39110   DATA 00BBBBBBBBBBBBBBBBBBBBB999999999999999999F9999999999919111111F11111F11111F111111
39120   DATA 00BBBBBBBBBBBBBBBBBBBB9999999999999999999999999999999991911111111111111111111F11
39130   DATA 00BBBBBBBBBBBBBBBBBBB99999999FF99999999999999999999999911111111111F111111F111111
39140   DATA 0BBBBBBBBBBBBBBBBBBB9999999999999999F99999999999F99919111111F1111111111F11111111
39150   DATA 0BBBBBBBBBBBBBBBBBB999999999999999999999999FF999999999191111F111111111111111F111
39160   DATA BBBBBBBBBBBBBBBBBB9999999999999999999999999999999991FF19111111111111F11111111F11
39170   DATA BBBBBBBBBBBBBBBBB999999999999999999999999F99F9999F91911911111111111111F111111111
39180   DATA BBBBBBBBBBBBBBBBB999999F99999999999F9999999999999991919F111111111FF11111FF11F1F1
39190   DATA BBBBBBBBBBBBBBBBBB99999999999999999999999999F99999999191111111111111111111111111
39200   DATA "@TEXEND"
39210   DATA "A:\GYAKU\umi5.bmp",80,20,16
39220   DATA 00000000000000000000000000000000000000000000000000000000000000000000000000000000
39230   DATA 00000000000000000000000000000000000000000000000000000000000000000000000000000000
39240   DATA 00000000000000000000000000000000000000000000000000000000000000000000000000000000
39250   DATA 00000000000000000000000000000000000000000000000000000000000000000000000000000000
39260   DATA 00000000000000000000000000000000000000000000000000000000000000000000000000000000
39270   DATA 00000000000000000000000000000000000000000000000000000000000000000000000000000000
39280   DATA 00000000000000000000000000000000000000000000000000000000000000000000000000000000
39290   DATA 00000000000000000000000000000000000000000000000000000000000000000000000000000000
39300   DATA 000000000000000000000000000000000000000000000000000000000000000000BBBBBBBBBBBBBB
39310   DATA 00000000000000000000000000000000000000000000000000000000000000BBBBBBBBBBBBB99999
39320   DATA 00000000000000000000000000000000000000000000000000000000000000BBBB99999999999999
39330   DATA 000000000000000000000000000000000000000000000000000000000000000BBB999F9999999999
39340   DATA 00000000000000000000000000000000000000000000000000000000000BBBBBBBB99999999999F9
39350   DATA 0000000000000000000000000000000000000000000000000000000000BBBBBBBB9999F99F999999
39360   DATA 00000000000000000000000000000000000000000000000000000000BBBBBBB999999999999999F1
39370   DATA 000000000000000000000000000000000000000000000000000000BBBBB999999F99999999F9F991
39380   DATA 000000000000000000000000000000000000000000000000000BBBBBBB999999999999999999991F
39390   DATA 0000000000000000000000000000000000000000000000000BBBBBBBBB99999F999999F999999111
39400   DATA 0000000000000000000000000000000000000000000000000BBBBBBB99999999999F9999F999F111
39410   DATA 00000000000000000000000000000000000000000000000BBBBBBBBBB9999F9999999F9999911111
39420   DATA "@TEXEND"
39430   DATA "A:\GYAKU\umi6.bmp",80,20,16
39440   DATA 00000000000000000000000000000000000000000000000BBBBBBBBBB99999999F99999999991111
39450   DATA 0000000000000000000000000000000000000000000000BBBBBBBBBBB9999999999999999F911111
39460   DATA 000000000000000000000000000000000000000000000BBBBBBBBBB999999F99F99F9999919111F1
39470   DATA 0000000000000000000000000000000000000000000BBBBBBBBB999999999999999999991F111111
39480   DATA 000000000000000000000000000000000000000000BBBBBBBBBBB99999F9999999999999F9111111
39490   DATA 00000000000000000000000000000000000000000BBBBBBBBBB9999F9999999999F999911111F111
39500   DATA 000000000000000000000000000000000000000BBBBBBBBBBBB999999999999F999999F991111111
39510   DATA 0000000000000000000000000000000000000BBBBBBBBBBBB99999999999F9999999999991111111
39520   DATA 000000000000000000000000000000000000BBBBBBBBBB99999999999999F9999999999191111F11
39530   DATA 000000000000000000000000000000000000BBBBBBB999999999999F999999999999999911111111
39540   DATA 000000000000000000000000000000000000BBBBBBBBB999999F99999999999999999991111111F1
39550   DATA 00000000000000000000000000000000000BBBBBBBBBB99999999F99F9999F99999F99911F111111
39560   DATA 0000000000000000000000000000000000BBBBBBBBBBBBB9999999999F9999999999991111111F11
39570   DATA 000000000000000000000000000000000BBBBBBBBBBBBBB99999F9999999999F999999191F111111
39580   DATA 00000000000000000000000000000000BBBBBBBBBBB99999F999F9999999F9999999999F11111111
39590   DATA 0000000000000000000000000000000BBBBBBBBBBBB999999999999999999999999991911111F111
39600   DATA 0000000000000000000000000000000BBBBBBBBBBBB9B99F9999F999999999999999F99111111111
39610   DATA 000000000000000000000000000000BBBBBBBBBBBBB999B99999999999999999999991F111F1F111
39620   DATA 000000000000000000000000000000BBBBBBBBBBBBB9B9999999999F999F99999FF91111F11111F1
39630   DATA 00000000000000000000000000000BBBBBBBBBBBB999999999999999999999999999111111111111
39640   DATA "@TEXEND"
39650   DATA "A:\GYAKU\umi7.bmp",80,20,16
39660   DATA 0000000000000000000000000000BBBBBBBBBBBBBBBB999999999999999999999991911111111111
39670   DATA 000000000000000000000000000BBBBBBBBBBBBBBBB999F99999999999999999999191111F111111
39680   DATA 000000000000000000000000000BBBBBBBBBBBBBBB99999999F99999F9999999F99F91111F111111
39690   DATA 00000000000000000000000000BBBBBBBBBBBBBB9F99999999F9999F9999999999999F1111111F11
39700   DATA 000000000000000000000000BBBBBBBBBBBBB99999999999F999999999F99999F99111F111111111
39710   DATA 00000000000000000000000BBBBBBBBBBBBBB99999999F999999999F9999999999F111111111F111
39720   DATA 00000000000000000000000BBBBBBBBBBBBB99999999F9999999999999999999999111F111111111
39730   DATA 00000000000000000000000BBBBBBBBBBBBB999999999999F99F99999999F999999111111111F111
39740   DATA 000000000000000000000BBBBBBBBBBBBBB9999999999F99999999999999F9999111111111111111
39750   DATA 000000000000000000BBBBBBBBBBBBBBBBB99F9999F999999999999F9999999991F1111F1111F111
39760   DATA 0000000000000000BBBBBBBBBBBBBBBBBB99999999999999999F999F9999999999911111111111F1
39770   DATA 000000000000000BBBBBBBBBBBBBBBBB999999999999999999999F999999999991911111F1111111
39780   DATA 00000000000000BBBBBBBBBBBBBB999FF99F9F9999F9999999999999999999911111111111F11F11
39790   DATA 0000000000000BBBBBBBBBBBBBB9999999999999999999999999999F99999991911111111F111111
39800   DATA 0000000000000BBBBBBBBBBBBBB9B9FF9999F99999999999F9999999999999119111111F11111111
39810   DATA 0000000000000BBBBBBBBBBBBBB9999999999999999FF99999999999999999191111111111111111
39820   DATA 00000000000000BBBBBBBBBBBBBBB99FF9999999999999999999F999999F99111111F11111111F11
39830   DATA 00000000000000BBBBBBBBBBBBBB9999999999999F9999999F99999999999111111111F111111111
39840   DATA 00000000000000BBBBBBBBBBBBBBBBBB999F999999999FF999999999999911911FF11111F111F1F1
39850   DATA 000000000000BBBBBBBBBBBBBBBBB9999999999999999999F9999999999999111111111111111111
39860   DATA "@TEXEND"
39870   DATA "A:\GYAKU\umi8.bmp",80,20,16
39880   DATA 0000000000BBBBBBBBBBBBBBBBBBBBB999999999999999999999999199199F11111111111111F111
39890   DATA 000000000BBBBBBBBBBBBBBBBBB999999999999999F999F99999999999111111111111111F1111F1
39900   DATA 0000000BBBBBBBBBBBBBBBBBB9999999999999999999999999F9999191111111F1FF111111111111
39910   DATA 0000000BBBBBBBBBBBBBBBBB99999999999F99999F99999999F99999911911111111111111111F11
39920   DATA 0000000BBBBBBBBBBBBBBBB999999999999999999999999999999999919111111111111111111111
39930   DATA 000000BBBBBBBBBBBBBBBBB999999999F999999999999F999999999F9111111111F1111111111111
39940   DATA 00000BBBBBBBBBBBBBBBBBB999999999999F9999999999999999F999991111111F1111F111111111
39950   DATA 00000BBBBBBBBBBBBBBBBBB9999F9999999999999999999999999999999191111111111F11111111
39960   DATA 0000BBBBBBBBBBBBBBBBBBBB999999999F99999999999F9999999991F991F1111111111111111111
39970   DATA 000BBBBBBBBBBBBBBBBBBBB9999999999999FF9999F9999999999F91991191111111111111111111
39980   DATA 00BBBBBBBBBBBBBBBBBBBB999999999999999999999999999F99999999111111F1111111111111F1
39990   DATA 00BBBBBBBBBBBBBBBBBBBBB999999999999999999999999999999F9991111F11111F11111F111111
40000   DATA 00BBBBBBBBBBBBBBBBBBBB99999999999999999999999999F99F9911111111111111111111111F11
40010   DATA 000BBBBBBBBBBBBBBBBBB99999999FF99999999999999999999999199111111111F111111F111111
40020   DATA 00BBBBBBBBBBBBBBBBBB9999999999999999F99999999999F999991F9111FFF11111111F11111111
40030   DATA 00BBBBBBBBBBBBBBBBB999999999999999F99999999F9999999999999111F1111111111111111111
40040   DATA 00BBBBBBBBBBBBBBBBB999999999999999999999999999999999FF99111111111111F11111111F11
40050   DATA 00BBBBBBBBBBBBBBBBB99999999F999999999999999999999F999199111111111111111111111111
40060   DATA 00BBBBBBBBBBBBBBBBB9999F99999999999F99999999999999999119111111111FF111111111F1F1
40070   DATA 00BBBBBBBBBBBBBBBBB9999999999999999999999999999999999999191111111111111111111111
40080   DATA "@TEXEND"
40090   DATA "A:\GYAKU\yama2.bmp",128,75,16
40100   DATA 00000000000000000000000000000000000000000000FFFFFFFFF000000000000000000000000000000000000000000000000000000000000000000000000000
40110   DATA 0000000000000000000000000000000000000000F8FFFFFFFFFFFFFFF00000000000000000000000000000000000000000000000000000000000000000000000
40120   DATA 000000000000000000000000000000000000008888FFFFFFFFFFFFFFFFFF00000000000000000000000000000000000000000000000000000000000000000000
40130   DATA 00000000000000000000000000000000000888888FFFFFFFFFFFFFFFFFFFFF000000000000000000000000000000000000000000000000000000000000000000
40140   DATA 0000000000000000000000000000000000888888FFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000000000000000000000000000000000000
40150   DATA 0000000000000000000000000000000008888888FFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000000000000000000000000000000000000000
40160   DATA 00000000000000000000000000000000888888FFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000000000000000000000000000000000
40170   DATA 0000000000000000000000000000000888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000000000000000000000000000000000000
40180   DATA 0000000000000000000000000000008888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000000000000000000000000000000000000000
40190   DATA 000000000000000000000000000000888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000000000000000000000000000000
40200   DATA 00000000000000000000000000000888888FFFFFFFFF4444444444FFFFFFFFFFFFFFFF0000000000000000000000000000000000000000000000000000000000
40210   DATA 0000000000000000000000000000888888FFFFFFF44444444444444444FFFFFFFFFFFF0000000000000000000000000000000000000000000000000000000000
40220   DATA 000000000000000000000000000888888FFFFF444444444444444444444444FFFFFFFFFF00000000000000000000000000000000000000000000000000000000
40230   DATA 000000000000000000000000000888888FFF44444444444444444444444444444444444400000000000000000000000000000000000000000000000000000000
40240   DATA 000000000000000000000000008888888F4444444444444444444444444444444444444440000000000000000000000000000000000000000000000000000000
40250   DATA 00000000000000000000000008888886644444444444444444444444444444444444444444000000000000000000000000000000000000000000000000000000
40260   DATA 00000000000000000000000008888666644444444444444444444444444444444444444444400000000000000000000000000000000000000000000000000000
40270   DATA 0000000000000000000000008886666644444444444444444444444444444444444444444444000000000000000000088FFFFFFFF00000000000000000000000
40280   DATA 0000000000000000000000006666666444444444444444444444444444444444444444444444440000000000000008888FFFFFFFFF0000000000000000000000
40290   DATA 000000000000000000000006666666444444444444444444444444444444444444444444444444400000000000008888FFFFFFFFFFFF00000000000000000000
40300   DATA 00000000000000000000000666666644444444444444444444444444444444444444444444444444000000000088888FFFFFFFFFFFFFF0000000000000000000
40310   DATA 000000000000000000000066666664444444444444444444444444444444444444444444444444440000000088888FFFF444444444FFFF000000000000000000
40320   DATA 00000000000000000000066666664444444444444444444444444444444444444444444444444444440000088888444444444444444444000000000000000000
40330   DATA 00000000000000000000066666664444444444444444444444444444444444444444444444444444444440666666444444444444444444400000000000000000
40340   DATA 00000000000000000000066666664444444444444444444444444444444444444444444444444444444446666664444444444444444444444000000000000000
40350   DATA 00000000000000000000666666644444444444444444444444444444444444444444444444444AAAAA2446666664444444444444444444444000000000000000
40360   DATA 000000000000000000006666666444444444444444444444444444444444444444444444444AAAAAAA2222266664444444444444444444444400000000000000
40370   DATA 0000000000000000000666666664444444444444444444444444444444444444444444444AAAAAAAAAA222266664444444444444444444444444000000000000
40380   DATA 0000000000000000000666666644444444444444444444444444444444444444444444AAAAAAAAAAAAA2222222A44444444444444AAAAAAAA444400000000000
40390   DATA 00000000000000000006666664444444AAAAAA444444444444444444444444444444AAAAAAAAAAAAAAA222222AAAAAAAAAAAAAAAAAAAAAAAAAA4400000000000
40400   DATA 0000000000000000006666666444AAAAAAAAAAAA4444444444444444444444444AAAAAAAAAAAAAAAAAAA22222AAAAAAAAAAAAAAAAAAAAAAAAAAAAA0000000000
40410   DATA 00000000000000000066666644AAAAAAAAAAAAAAAA44444444444444444444AAAAAAAAAAAAAAAAAAAAAAA222AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA000000000
40420   DATA 0000000000000000066666664AAAAAAAAAAAAAAAAAAA44444444444444AAAAAAAAAAAAAAAAAAAAAAAAAAA22AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA00000000
40430   DATA 00000000000000006666666AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA22AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0000000
40440   DATA 00000000000000006666622AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA2AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0000000
40450   DATA 0000000000000006666222AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA000000
40460   DATA 0000000000000006662222AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA00000
40470   DATA 000000000000006622222AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA00000
40480   DATA 00000000000000622222AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0000
40490   DATA 0000000000000222222AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA000
40500   DATA 0000000000000222222AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA000
40510   DATA 000000000000222222AAAAAAFFFEEEEAAFFEEEEEEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA00
40520   DATA 000000000002222222AAAAAAFFFEEEEAAFFEEEEEEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA00
40530   DATA 00000000000222222AAAAAAAFFFEEEEAAFFEEEEEEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0
40540   DATA 0000000000222222AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0
40550   DATA 0000000002222222AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0
40560   DATA 000000000222222AAAEEEEEEEEEEEEEEEEEEEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0
40570   DATA 000000002222222AAAAEEEEEEEEEEEEEEEEEEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
40580   DATA 00000002222222AAAAAAEEEEEEEEEEEEEEEEEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
40590   DATA 0000000222222AAAAAAAAEEEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
40600   DATA 000000222222AAAAAAAAAAEEEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
40610   DATA 000002222222AAAAAAAAAAAEEEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
40620   DATA 00000222222AAAAAAAAAAAAAEEEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
40630   DATA 00002222222AAAAAAAAAAAAAAEEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
40640   DATA 0002222222AAAAAAAAAAAAAAEEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
40650   DATA 0022222222AAAAAAAAAAAAAEEEEEEEEEEEEEEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
40660   DATA 002222222AAAAAAAAAAAAAEEEEEEEEEEEEEEEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
40670   DATA 002222222AAAAAAAAAAAAEEEEEEEEEEEEEEEEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
40680   DATA 022222222AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
40690   DATA 02222222AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
40700   DATA 22222222AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
40710   DATA 22222222AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
40720   DATA 22222222AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
40730   DATA 22222222AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
40740   DATA 22222222AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
40750   DATA 2222222AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
40760   DATA 2222222AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
40770   DATA 2222222AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0
40780   DATA 0022222AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA00
40790   DATA 0000222AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0000000
40800   DATA 0000022AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA00000000000
40810   DATA 00000000AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA000000000000000
40820   DATA 00000000000AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0000000000000000000000000
40830   DATA 000000000000000000000000000000AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA000000000000000000000000000000000
40840   DATA 000000000000000000000000000000000000000AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA000000000000000000000000000000000000000000000000000
40850   DATA "@TEXEND"
40860   DATA "A:\GYAKU\kumo.bmp",80,36,16
40870   DATA 00000000000000000000000000000000008888888800000000000000000888888880000000000000
40880   DATA 00000000000000000000000000000000888888888888000000000000888888888888880000000000
40890   DATA 00000000000000000000888888800008888888888888800000000088888888888888888800000000
40900   DATA 00000000000000000088888888888088888888888888880088888888888888888888888880000000
40910   DATA 00000000000000000888888888888888888888888888888888888888888888888888888888000000
40920   DATA 000000000000000088888888888888888888888888888888888888888FFFFFFFFFFFFF8888800000
40930   DATA 0000000000088888888888888888888888FFFFFFFF8888888888888FFFFFFFFFFFFFFFF888880000
40940   DATA 000000000888888888888FFFF888888FFFFFFFFFFFFFFFFFFFFFF8FFFFFFFFFFFFFFFFFF88880000
40950   DATA 00000008888888888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8888000
40960   DATA 000000888888888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8888000
40970   DATA 000008888888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8888800
40980   DATA 0000088888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEFFEEFFFFFFFF8888800
40990   DATA 000088888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEFFEEFFFFFFFF8888800
41000   DATA 00088888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEFFEEFFFFFFFF8888800
41010   DATA 0008888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEFFEEFFFFFFFF8888800
41020   DATA 000888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEFFEEFFFFFFFF8888800
41030   DATA 000888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8888800
41040   DATA 000888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF88888000
41050   DATA 000888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEEEEEEEEEEF88888000
41060   DATA 000888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEEEEEEEEEFFF8880000
41070   DATA 00008888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEEEEEEEFFFFF8880000
41080   DATA 00000888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEFFFFF8800000
41090   DATA 00000888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEFFFFFF8880000
41100   DATA 0000008888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEFFFF888880000
41110   DATA 000000088888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEFFF888800000
41120   DATA 000000000888888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEEEEEEEFF8888800000
41130   DATA 0000000000088888888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEEEEEEEEF8888800000
41140   DATA 0000000000000008888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8FFFFFFFFFFFFFF88888000000
41150   DATA 00000000000000088888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFF88888FFFFFFFFFF8888880000000
41160   DATA 0000000000000000888888888FFFFFFFFFFFFFFFFFFFFFFFFF888888888888888888888000000000
41170   DATA 000000000000000000888888888888FFFFFFFFFFFFFFF88888888888888888888800000000000000
41180   DATA 00000000000000000000888888888888888888888888888880088888888888800000000000000000
41190   DATA 00000000000000000000000000888888888888888888888800000000000000000000000000000000
41200   DATA 00000000000000000000000000088888888888888888888000000000000000000000000000000000
41210   DATA 00000000000000000000000000000888888888888888800000000000000000000000000000000000
41220   DATA 00000000000000000000000000000000088888888000000000000000000000000000000000000000
41230   DATA "@TEXEND"
41240   DATA "A:\GYAKU\kumo2.bmp",80,36,16
41250   DATA 00000000000000000000000000000000008888888800000000000000000888888880000000000000
41260   DATA 00000000000000000000000000000000888888888888000000000000888888888888880000000000
41270   DATA 00000000000000000000888888800008888888888888800000000088888888888888888800000000
41280   DATA 00000000000000000088888888888088888888888888880088888888888888888888888880000000
41290   DATA 00000000000000000888888888888888888888888888888888888888888888888888888888000000
41300   DATA 000000000000000088888888888888888888888888888888888888888FFFFFFFFFFFFF8888800000
41310   DATA 0000000000088888888888888888888888FFFFFFFF8888888888888FFFFFFFFFFFFFFFF888880000
41320   DATA 000000000888888888888FFFF888888FFFFFFFFFFFFFFFFFFFFFF8FFFFFFFFFFFFFFFFFF88880000
41330   DATA 00000008888888888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8888000
41340   DATA 000000888888888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8888000
41350   DATA 000008888888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8888800
41360   DATA 0000088888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8888800
41370   DATA 000088888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8888800
41380   DATA 00088888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8888800
41390   DATA 0008888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEEEEEFFEEEEFFFFFF8888800
41400   DATA 000888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEEEEEFFEEEEFFFFFF8888800
41410   DATA 000888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8888800
41420   DATA 000888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF88888000
41430   DATA 000888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEEEEEEEEEEFFF88888000
41440   DATA 000888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEEEEEEEEEFFFFF8880000
41450   DATA 00008888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEEEEEEEFFFFFFF8880000
41460   DATA 00000888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEFFFFFFF8800000
41470   DATA 00000888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEFFFFFFFF8880000
41480   DATA 0000008888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEFFFFFF888880000
41490   DATA 000000088888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEFFFFF888800000
41500   DATA 000000000888888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEEEEEEEFFFF8888800000
41510   DATA 0000000000088888888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEEEEEEEEFFF8888800000
41520   DATA 0000000000000008888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8FFFFFFFFFFFFFF88888000000
41530   DATA 00000000000000088888888FFFFFFFFFFFFFFFFFFFFFFFFFFFFF88888FFFFFFFFFF8888880000000
41540   DATA 0000000000000000888888888FFFFFFFFFFFFFFFFFFFFFFFFF888888888888888888888000000000
41550   DATA 000000000000000000888888888888FFFFFFFFFFFFFFF88888888888888888888800000000000000
41560   DATA 00000000000000000000888888888888888888888888888880088888888888800000000000000000
41570   DATA 00000000000000000000000000888888888888888888888800000000000000000000000000000000
41580   DATA 00000000000000000000000000088888888888888888888000000000000000000000000000000000
41590   DATA 00000000000000000000000000000888888888888888800000000000000000000000000000000000
41600   DATA 00000000000000000000000000000000088888888000000000000000000000000000000000000000
41610   DATA "@TEXEND"
41620   DATA "A:\GYAKU\taiyo.bmp",64,63,16
41630   DATA 0000000000000000000000000000000000000000000000000000000000000000
41640   DATA 0000000000000000000000000000000000000000000000000000000000000000
41650   DATA 0000000000000000000000000000000000000000000000000000000CCCCC0000
41660   DATA 00000000000000000000000000000000000000000000000000000CCCCCCC0000
41670   DATA 0000000000000000000000000000000000000000000000000000CCCCCCC00000
41680   DATA 0000000000000000000000000000000000000000000000000000000000000000
41690   DATA 000CCCCCC0000000000000000000000000000000000000000000000000000000
41700   DATA 000CCCCCCCC00000000000000000044444444400000000000000000000000000
41710   DATA 0000CCCCCCC00000000000000044444444444444400000000000000000000000
41720   DATA 00000CCCCCCC0000000000044444444444444444444400000000000000000000
41730   DATA 0000000CCCCCC00000000444444CCCCCCCC44444444444000000000000000000
41740   DATA 00000000CCCCC000000044444CCCCCCCCCCCCC44444444400000000000000000
41750   DATA 0000000000000000000444CCCCCCCCCCCCCCCCCCC44444440000000000000000
41760   DATA 000000000000000000444CCCCCCCCCCCCCCCCCCCCCC444444000000000000000
41770   DATA 00000000000000000444CCCCCCCCCCCCCCCCCCCCCCCC44444400000000000000
41780   DATA 0000000000000000444CCCCCCCCCCCCCCCCCCCCCCCCCC4444440000000000000
41790   DATA 000000000000000444CCCCCCCCCCCCCCCCCCCCCCCCCCCCC44444000000000000
41800   DATA 00000000000000444CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC4444400000000000
41810   DATA 00000000000000444CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC4444400000000000
41820   DATA 0000000000000444CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC444440000000000
41830   DATA 000000000000044CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC44444000000000
41840   DATA 000000000000044CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC44444000000000
41850   DATA 000000000000444CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC4444000000000
41860   DATA 00000000000044CCCCCCCCCCEEECCCCEEECCCCCCCCCCCCCCCCC4444400000000
41870   DATA 00000000000044CCCCCCCCCCEEECCCCEEECCCCCCCCCCCCCCCCCC444400000000
41880   DATA 00000000000444CCCCCCCCCCEEECCCCEEECCCCCCCCCCCCCCCCCC444400000000
41890   DATA 0000000000044CCCCCCCCCCCFFECCCCFFECCCCCCCCCCCCCCCCCC444440000000
41900   DATA 0000000000044CCCCCCCCCCCFFECCCCFFECCCCCCCCCCCCCCCCCC444440000000
41910   DATA 0000000000044CCCCCCCCCCCFFECCCCFFECCCCCCCCCCCCCCCCCCC44440000000
41920   DATA 0000000000044CCCCCCCCCCCFFECCCCFFECCCCCCCCCCCCCCCCCCC44440000000
41930   DATA 0000000000044CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC44440000000
41940   DATA 0000000000044CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC44440000000
41950   DATA 0000000000044CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC44440000000
41960   DATA 0000000000044CEEEEEEEEEEEEEEEEEEECCCCCCCCCCCCCCCCCCCC44440000000
41970   DATA 0000000000044CCCEEEEEEEEEEEEEEEEECCCCCCCCCCCCCCCCCCCC44440000000
41980   DATA 0000000000044CCCCEEEEEEEEEEEEEEEECCCCCCCCCCCCCCCCCCCC44440000000
41990   DATA 0000000000044CCCCCCEEEECCCCCCCCCCCCCCCCCCCCCCCCCCCCC444440000000
42000   DATA 00000000000444CCCCCCEEEECCCCCCCCCCCCCCCCCCCCCCCCCCCC444400000000
42010   DATA 00000000000444CCCCCCCCEEECCCCCCCCCCCCCCCCCCCCCCCCCCC444400000000
42020   DATA 00000000000044CCCCCCCCCEECCCCCCCCCCCCCCCCCCCCCCCCCCC444400000000
42030   DATA 000000000000444CCCCCCCCEECCCCCCCCCCCCCCCCCCCCCCCCCC4444000000000
42040   DATA 000000000000044CCCCCCCEEEEEEEEEEECCCCCCCCCCCCCCCCCC4444000000000
42050   DATA 000000000000044CCCCCCEEEEEEEEEEEECCCCCCCCCCCCCCCCC44444000000000
42060   DATA 0000000000000444CCCCEEEEEEEEEEEEECCCCCCCCCCCCCCCCC44440000000000
42070   DATA 00000000000000444CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC444400000000000
42080   DATA 00000000000000444CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC4444400000000000
42090   DATA 000000000000000444CCCCCCCCCCCCCCCCCCCCCCCCCCCCCC4444000000000000
42100   DATA 0000000000000000444CCCCCCCCCCCCCCCCCCCCCCCCCCCC44440000000000000
42110   DATA 00000000000000000444CCCCCCCCCCCCCCCCCCCCCCCCC4444400000000000000
42120   DATA 000000000000000000444CCCCCCCCCCCCCCCCCCCCCCC44444000000000000000
42130   DATA 0000000000000000000444CCCCCCCCCCCCCCCCCCCCC444440000000000000000
42140   DATA 0000000000000000000044444CCCCCCCCCCCCCCCC44444400000000000000000
42150   DATA 000000000000000000000444444CCCCCCCCCCC44444444000000000000000000
42160   DATA 0000000CCCCC0000000000044444444444444444444400000000000000000000
42170   DATA 000000CCCCCC0000000000000044444444444444400000000000000000000000
42180   DATA 00000CCCCCCC0000000000000000044444444400000000000000000000000000
42190   DATA 00000CCCCCCC00000000000000000000000000000000000000000C0000000000
42200   DATA 0000CCCCCC0000000000000000000000000000000000000000000CCCCCC00000
42210   DATA 0000CCCCC00000000000000000000000000000000000000000000CCCCCCC0000
42220   DATA 0000CCCC0000000000000000000000000000000000000000000000CCCCCC0000
42230   DATA 0000000000000000000000000000000000000000000000000000000CCCCC0000
42240   DATA 0000000000000000000000000000000000000000000000000000000CCCCC0000
42250   DATA 00000000000000000000000000000000000000000000000000000000CCC00000
42260   DATA "@TEXEND"
42270   DATA "A:\GYAKU\taiyo2.bmp",64,64,16
42280   DATA 00000000000000000000000000000000000000000000000000000000CCCCC000
42290   DATA 000000000000000000000000000000000000000000000000000000CCCCCCC000
42300   DATA CCCCCC00000000000000000000000000000000000000000000000CCCCCCC0000
42310   DATA CCCCCCCC00000000000000000000000000000000000000000000000000000000
42320   DATA 0CCCCCCC00000000000000000000000000000000000000000000000000000000
42330   DATA 00CCCCCCC0000000000000000000000000000000000000000000CCC000000000
42340   DATA 0000CCCCCC00000000000000000000000000000000000000000CC00000000000
42350   DATA 00000CCCCC000000000000000000044444444400000000000000000000000000
42360   DATA 0000000000000000000000000044444444444444400000000000000000000000
42370   DATA 0000000000CCCCC0000000044444444444444444444400000000000000000000
42380   DATA 000000000000CCC000000444444CCCCCCCC44444444444000000000000000000
42390   DATA 0000000000000000000044444CCCCCCCCCCCCC44444444400000000000000000
42400   DATA 0000000000000000000444CCCCCCCCCCCCCCCCCCC44444440000000000000000
42410   DATA 000000000000000000444CCCCCCCCCCCCCCCCCCCCCC444444000000000000000
42420   DATA 00000000000000000444CCCCCCCCCCCCCCCCCCCCCCCC44444400000000000000
42430   DATA 0000000000000000444CCCCCCCCCCCCCCCCCCCCCCCCCC4444440000000000000
42440   DATA 000000000000000444CCCCCCCCCCCCCCCCCCCCCCCCCCCCC44444000000000000
42450   DATA 00000000000000444CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC4444400000000000
42460   DATA 00000000000000444CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC4444400000000000
42470   DATA 0000000000000444CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC444440000000000
42480   DATA 000000000000044CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC44444000000000
42490   DATA 000000000000044CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC44444000000000
42500   DATA 000000000000444CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC4444000000000
42510   DATA 00000000000044CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC4444400000000
42520   DATA 00000000000044CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC444400000000
42530   DATA 00000000000444CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC444400000000
42540   DATA 0000000000044CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC444440000000
42550   DATA 0000000000044CCCCCCCFFEEEEECCCCFFEEEEEECCCCCCCCCCCCC444440000000
42560   DATA 0000000000044CCCCCCCFFEEEEECCCCFFEEEEEECCCCCCCCCCCCCC44440000000
42570   DATA 0000000000044CCCCCCCFFEEEEECCCCFFEEEEEECCCCCCCCCCCCCC44440000000
42580   DATA 0000000000044CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC44440000000
42590   DATA 0000000000044CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC44440000000
42600   DATA 0000000000044CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC44440000000
42610   DATA 00000000000EEEEEEEEEEEEEEEEEEEEEECCCCCCCCCCCCCCCCCCCC44440000000
42620   DATA 0000000000044EEEEEEEEEEEEEEEEEEEECCCCCCCCCCCCCCCCCCCC44440000000
42630   DATA 0000000000044CEEEEEEEEEEEEEEEEEEECCCCCCCCCCCCCCCCCCCC44440000000
42640   DATA 0000000000044CCCEEEECCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC444440000000
42650   DATA 0000000000044CCCCEEEECCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC444400000000
42660   DATA 0000000000044CCCCCCEEECCCCCCCCCCCCCCCCCCCCCCCCCCCCCC444400000000
42670   DATA 00000000000444CCCCCCEECCCCCCCCCCCCCCCCCCCCCCCCCCCCCC444400000000
42680   DATA 00000000000044CCCCCCEECCCCCCCCCCCCCCCCCCCCCCCCCCCCC4444000000000
42690   DATA 00000000000044CCCCCEEEEEEEEEEEEEECCCCCCCCCCCCCCCCCC4444000000000
42700   DATA 000000000000444CCCEEEEEEEEEEEEEEECCCCCCCCCCCCCCCCC44444000000000
42710   DATA 000000000000044CCEEEEEEEEEEEEEEEECCCCCCCCCCCCCCCCC44440000000000
42720   DATA 00000000000000444CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC444400000000000
42730   DATA 00000000000000444CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC4444400000000000
42740   DATA 000000000000000444CCCCCCCCCCCCCCCCCCCCCCCCCCCCCC4444000000000000
42750   DATA 0000000000000000444CCCCCCCCCCCCCCCCCCCCCCCCCCCC44440000000000000
42760   DATA 00000000000000000444CCCCCCCCCCCCCCCCCCCCCCCCC4444400000000000000
42770   DATA 000000000000000000444CCCCCCCCCCCCCCCCCCCCCCC44444000000000000000
42780   DATA 0000000000000000000444CCCCCCCCCCCCCCCCCCCCC444440000000000000000
42790   DATA 0000000000000000000044444CCCCCCCCCCCCCCCC44444400000000000000000
42800   DATA 000000000000CC0000000444444CCCCCCCCCCC4444444400000CC00000000000
42810   DATA 00000000CCCCCC00000000044444444444444444444400000000CCC000000000
42820   DATA 0000000000CCC00000000000004444444444444440000000000000C000000000
42830   DATA 0000000000000000000000000000044444444400000000000000000000000000
42840   DATA 0000000000000000000000000000000000000000000000000000000000000000
42850   DATA 00000CCCCC00000000000000000000000000000000000000000000C000000000
42860   DATA 0000CCCCCC00000000000000000000000000000000000000000000CCCCCC0000
42870   DATA 000CCCCCCC00000000000000000000000000000000000000000000CCCCCCC000
42880   DATA 000CCCCCCC000000000000000000000000000000000000000000000CCCCCC000
42890   DATA 00CCCCCC000000000000000000000000000000000000000000000000CCCCC000
42900   DATA 00CCCCC0000000000000000000000000000000000000000000000000CCCCC000
42910   DATA 00CCCC000000000000000000000000000000000000000000000000000CCC0000
42920   DATA "@TEXEND"
42930   DATA "A:\tama.bmp",32,32,16
42940   DATA 00000000000000000000000000000000
42950   DATA 00000000000000000000000000000000
42960   DATA 00000000000000000000000000000000
42970   DATA 00000000000000000000000000000000
42980   DATA 00000000000000000000000000000000
42990   DATA 00000000000007888FFF000000000000
43000   DATA 000000000007888FFFFFFF0000000000
43010   DATA 0000000007788FFFFFFFFFFF00000000
43020   DATA 000000007788FFFFFFFFFFFFF0000000
43030   DATA 00000007788FFFFFFFFFFFFFFF000000
43040   DATA 000000078FFFFFFFFFFFFFFFFF000000
43050   DATA 000000788FFFFFFFFFFFFFFFFFF00000
43060   DATA 000000788FFFFF77777FF7777FF00000
43070   DATA 000007888FFFFF77777FF7777FFF0000
43080   DATA 00000788FFFFFFFFFFFFFFFFFFFF0000
43090   DATA 00000788FFFFFFFFFFFFFFFFFFFF0000
43100   DATA 00000788FFFFFFFFFFF7777777FF0000
43110   DATA 00000788FFFFFFFFFFF7777777FF0000
43120   DATA 000007888FFFFFFFFFFFFF77FFFF0000
43130   DATA 000000788FFFFFFFFFFFFF7FFFF00000
43140   DATA 000000788FFFFFFFFFFFFF77FFF00000
43150   DATA 0000000788FFFFFFFFF777777F000000
43160   DATA 00000007888FFFFFFFF777777F000000
43170   DATA 00000000778FFFFFFFFFFFFFF0000000
43180   DATA 0000000007888FFFFFFFFFFF00000000
43190   DATA 00000000000788FFFFFFFF0000000000
43200   DATA 00000000000008888FFF000000000000
43210   DATA 00000000000000000000000000000000
43220   DATA 00000000000000000000000000000000
43230   DATA 00000000000000000000000000000000
43240   DATA 00000000000000000000000000000000
43250   DATA 00000000000000000000000000000000
43260   DATA "@TEXEND"
43270   DATA "A:\tama2.bmp",32,32,16
43280   DATA 00000000000000000000000000000000
43290   DATA 00000000000000000000000000000000
43300   DATA 00000000000000000000000000000000
43310   DATA 00000000000000000000000000000000
43320   DATA 00000000000000000000000000000000
43330   DATA 000000000000FFF88870000000000000
43340   DATA 0000000000FFFFFFF888700000000000
43350   DATA 00000000FFFFFFFFFFF8877000000000
43360   DATA 0000000FFFFFFFFFFFFF887700000000
43370   DATA 000000FFFFFFFFFFFFFFF88770000000
43380   DATA 000000FFFFFFFFFFFFFFFFF870000000
43390   DATA 00000FFFFFFFFFFFFFFFFFF887000000
43400   DATA 00000FF3333FF33333FFFFF887000000
43410   DATA 0000FFF3333FF33333FFFFF888700000
43420   DATA 0000FFFFFFFFFFFFFFFFFFFF88700000
43430   DATA 0000FFFFFFFFFFFFFFFFFFFF88700000
43440   DATA 0000FF3333333FFFFFFFFFFF88700000
43450   DATA 0000FF3333333FFFFFFFFFFF88700000
43460   DATA 0000FFFF33FFFFFFFFFFFFF888700000
43470   DATA 00000FFFF3FFFFFFFFFFFFF887000000
43480   DATA 00000FFF33FFFFFFFFFFFFF887000000
43490   DATA 000000F333333FFFFFFFFF8870000000
43500   DATA 000000F333333FFFFFFFF88870000000
43510   DATA 0000000FFFFFFFFFFFFFF87700000000
43520   DATA 00000000FFFFFFFFFFF8887000000000
43530   DATA 0000000000FFFFFFFF88700000000000
43540   DATA 000000000000FFF88880000000000000
43550   DATA 00000000000000000000000000000000
43560   DATA 00000000000000000000000000000000
43570   DATA 00000000000000000000000000000000
43580   DATA 00000000000000000000000000000000
43590   DATA 00000000000000000000000000000000
43600   DATA "@TEXEND"
43610   DATA "A:\Kabe1.bmp",16,16,16
43620   DATA FFFFFFFFFFFFFFFF
43630   DATA FFFFFFFFFFFFFFFF
43640   DATA FF88888888888888
43650   DATA FF88888888888888
43660   DATA FF88888888888888
43670   DATA FF88888888888888
43680   DATA FF88888888888888
43690   DATA FF88888777777777
43700   DATA FF88888777777777
43710   DATA FF88888770000000
43720   DATA FF88888770000000
43730   DATA FF88888770000000
43740   DATA FF88888770000000
43750   DATA FF88888770000000
43760   DATA FF88888770000000
43770   DATA FF88888770000000
43780   DATA "@TEXEND"
43790   DATA "A:\Kabe2.bmp",16,16,16
43800   DATA FFFFFFFFFFFFFFFF
43810   DATA FFFFFFFFFFFFFFF7
43820   DATA 8888888888888877
43830   DATA 8888888888888877
43840   DATA 8888888888888877
43850   DATA 8888888888888877
43860   DATA 7777777778888877
43870   DATA 77777777F8888877
43880   DATA 0000000FF8888877
43890   DATA 0000000FF8888877
43900   DATA 0000000FF8888877
43910   DATA 0000000FF8888877
43920   DATA 0000000FF8888877
43930   DATA 0000000FF8888877
43940   DATA 0000000FF8888877
43950   DATA 0000000FF8888877
43960   DATA "@TEXEND"
43970   DATA "A:\Kabe3.bmp",16,16,16
43980   DATA 0000000FF8888877
43990   DATA 0000000FF8888877
44000   DATA 0000000FF8888877
44010   DATA 0000000FF8888877
44020   DATA 0000000FF8888877
44030   DATA 0000000FF8888877
44040   DATA 0000000FF8888877
44050   DATA FFFFFFFFF8888877
44060   DATA FFFFFFFFF8888877
44070   DATA 8888888888888877
44080   DATA 8888888888888877
44090   DATA 8888888888888877
44100   DATA 8888888888888877
44110   DATA 8888888888888877
44120   DATA 7777777777777777
44130   DATA 7777777777777777
44140   DATA "@TEXEND"
44150   DATA "A:\Kabe4.bmp",16,16,16
44160   DATA FF88888770000000
44170   DATA FF88888770000000
44180   DATA FF88888770000000
44190   DATA FF88888770000000
44200   DATA FF88888770000000
44210   DATA FF88888770000000
44220   DATA FF88888770000000
44230   DATA FF8888877FFFFFFF
44240   DATA FF888887FFFFFFFF
44250   DATA FF88888888888888
44260   DATA FF88888888888888
44270   DATA FF88888888888888
44280   DATA FF88888888888888
44290   DATA FF88888888888888
44300   DATA FF77777777777777
44310   DATA F777777777777777
44320   DATA "@TEXEND"
44330   DATA "A:\Kabe01.bmp",32,8,16
44340   DATA 00000000FFFFFFFFFFFFFFFF00000000
44350   DATA 000FFFFF8888888888888888FFFFF000
44360   DATA 0FFF888888888888888888888888FFF0
44370   DATA FF888888888888888888888888888877
44380   DATA FF888888888888888888888888888877
44390   DATA 07778888888888888888888888887770
44400   DATA 00077777888888888888888877777000
44410   DATA 00000000777777777777777700000000
44420   DATA "@TEXEND"
44430   DATA "A:\Kabe02.bmp",8,32,16
44440   DATA 000FF000
44450   DATA 00FFF700
44460   DATA 00F88700
44470   DATA 0FF88770
44480   DATA 0F888870
44490   DATA 0F888870
44500   DATA 0F888870
44510   DATA 0F888870
44520   DATA F8888887
44530   DATA F8888887
44540   DATA F8888887
44550   DATA F8888887
44560   DATA F8888887
44570   DATA F8888887
44580   DATA F8888887
44590   DATA F8888887
44600   DATA F8888887
44610   DATA F8888887
44620   DATA F8888887
44630   DATA F8888887
44640   DATA F8888887
44650   DATA F8888887
44660   DATA F8888887
44670   DATA F8888887
44680   DATA 0F888870
44690   DATA 0F888870
44700   DATA 0F888870
44710   DATA 0F888870
44720   DATA 0FF88770
44730   DATA 00F88700
44740   DATA 00F77700
44750   DATA 00077000
44760   DATA "@TEXEND"
44770   DATA "A:\TOUMEI.bmp",8,1,16
44780   DATA 00000000
44790   DATA "@TEXEND"
44800   DATA "A:\BITMAP\Batto.bmp",24,20,16
44810   DATA 000000011111100000000000
44820   DATA 0000011E9999E11000000000
44830   DATA 0001199EEEEEE99110000000
44840   DATA 001F9EEEEEEEEEE9F1000000
44850   DATA 0019EEEEEEEEEEEE91000000
44860   DATA 019EEE777EEEEEEEE9100000
44870   DATA 019EE7FFF7EEE777E9100000
44880   DATA 1F9EE7FFF7EE778879F10000
44890   DATA 19EEE7FFF7E778887E910000
44900   DATA 19EEEE777EE788887E910000
44910   DATA 19EEEEEEEE778887EE910000
44920   DATA 19EEEEEEE7788877EE910000
44930   DATA 1F9EEEEEE788777EE9F10000
44940   DATA 019EEEEE78877EEEE9100000
44950   DATA 019EE777777EEEEEE9100000
44960   DATA 0019E7887EEEEEEE91000000
44970   DATA 001F9E77EEEEEEE9F1000000
44980   DATA 0001199EEEEEE99110000000
44990   DATA 0000011E9999E11000000000
45000   DATA 000000011111100000000000
45010   DATA "@TEXEND"
45020   DATA "A:\BITMAP\Fd1.bmp",24,20,16
45030   DATA 000000011111100000000000
45040   DATA 0000011E9999E11000000000
45050   DATA 0001199EEEEEE99110000000
45060   DATA 001F9EEEEEEEEEE9F1000000
45070   DATA 0019E1111111111E91000000
45080   DATA 019E17FFFFFFFF71E9100000
45090   DATA 019E17FFFFFFFF71E9100000
45100   DATA 1F9E17FFFFFFFF71E9F10000
45110   DATA 19EE17FFFFFFFF71EE910000
45120   DATA 19EE17FFFFFFFF71EE910000
45130   DATA 19EE17FFFFFFFF71EE910000
45140   DATA 19EE17FFFFFFFF71EE910000
45150   DATA 1F9E177777777771E9F10000
45160   DATA 019E177888899971E9100000
45170   DATA 019E177888899971E9100000
45180   DATA 0019E1788889997191000000
45190   DATA 001F9E1111111119F1000000
45200   DATA 0001199EEEEEE99110000000
45210   DATA 0000011E9999E11000000000
45220   DATA 000000011111100000000000
45230   DATA "@TEXEND"
45240   DATA "A:\BITMAP\Fd2.bmp",24,20,16
45250   DATA 000000011111100000000000
45260   DATA 0000011E9999E11000000000
45270   DATA 0001199EEEEEE99110000000
45280   DATA 001F9EEEEEEEEEE9F1000000
45290   DATA 0019E1111111111E91000000
45300   DATA 019E17FFFFFFFF71E9100000
45310   DATA 019E17FFFFFFFF71E9100000
45320   DATA 1F9E17FFFFFFFF71E9F10000
45330   DATA 19EE17FFFFFFFF71EE910000
45340   DATA 19EE17FFFFFFFF71EE910000
45350   DATA 19EE17FFFFFFFF71EE910000
45360   DATA 19EE17FFFFFFFF71EE910000
45370   DATA 1F9E177777777771E9F10000
45380   DATA 019E1778888CCC71E9100000
45390   DATA 019E1778888CCC71E9100000
45400   DATA 0019E178888CCC7191000000
45410   DATA 001F9E1111111119F1000000
45420   DATA 0001199EEEEEE99110000000
45430   DATA 0000011E9999E11000000000
45440   DATA 000000011111100000000000
45450   DATA "@TEXEND"
45460   DATA "A:\Yajirusi.bmp",16,12,16
45470   DATA CC00000000000000
45480   DATA CCCC000000000000
45490   DATA 0CFFF00000000000
45500   DATA 0CFFFFF000000000
45510   DATA 00FFCCCCC0000000
45520   DATA 000FCCCCCCC00000
45530   DATA 000FCCFFFFFF0000
45540   DATA 0000CCFFFFFF0000
45550   DATA 0000CCFFCCCC0000
45560   DATA 00000CFFCCCC0000
45570   DATA 00000CFFCCFF0000
45580   DATA 000000FFCCFF0000
45590   DATA "@TEXEND"
45600   '
45610   DATA "BOU",8,4,16
45620   DATA 44CCCCEE
45630   DATA 44CCCCEE
45640   DATA 44CCCCEE
45650   DATA 44CCCCEE
45660   DATA "@TEXEND"
45670   DATA "BOU1",8,4,16
45680   DATA 119999BB
45690   DATA 119999BB
45700   DATA 119999BB
45710   DATA 119999BB
45720   DATA "@TEXEND"
45730   DATA "BOU2",8,4,16
45740   DATA 22AAAAFF
45750   DATA 22AAAAFF
45760   DATA 22AAAAFF
45770   DATA 22AAAAFF
45780   DATA "@TEXEND"
45790 '
45800   DATA "WINDOW75",8,4,16
45810   DATA FFFFFFFF
45820   DATA FFFFFFFF
45830   DATA FFFFFFFF
45840   DATA FFFFFFFF
45850   DATA "@TEXEND"
45860   DATA "WINDOW76",8,4,16
45870   DATA 88888888
45880   DATA 88888888
45890   DATA 88888888
45900   DATA 88888888
45910   DATA "@TEXEND"
45920   DATA "WINDOW77",8,4,16
45930   DATA 77777777
45940   DATA 77777777
45950   DATA 77777777
45960   DATA 77777777
45970   DATA "@TEXEND"
45980   DATA "A:\TIKYUU1.bmp",24,30,16
45990   DATA 000000099999900000000000
46000   DATA 0000099FFFFFF99000000000
46010   DATA 00009AFFFFFFFFF900000000
46020   DATA 0009AAAFFFFFFFFA90000000
46030   DATA 009AAFAAAAAFAABAF9000000
46040   DATA 09AAAAAAAAAAAABAAA900000
46050   DATA 09AAAAAAAAAAAABAAA900000
46060   DATA 9EEAAAAAA11AA11BAAA90000
46070   DATA 9EEEAAAAA11AA11BABA90000
46080   DATA 9EEE6AAAA11AA11BABA90000
46090   DATA 9EEE66AAAAAAAABBABA90000
46100   DATA 9EEE6AAAAAA1111111110000
46110   DATA 9EEE6AAAAAA1111111190000
46120   DATA 9AAEAAAAAAABBBB11BB90000
46130   DATA 09AAAAAAAABBBBB1BB900000
46140   DATA 09AAAAAABBBBBBB11B900000
46150   DATA 0096666BBBB1111111000000
46160   DATA 0009B6BBBBB1111111000000
46170   DATA 00009BBBBBBBBBB900000000
46180   DATA 0000099BBBBBB99000000000
46190   DATA 000000011111100000000000
46200   DATA 000000011FF1000000000000
46210   DATA 00001111FFFF111000000000
46220   DATA 00000001F99F100000000000
46230   DATA 00000001F99F100000000000
46240   DATA 000000011FFF100000000000
46250   DATA 000000001111100000000000
46260   DATA 000000011101000000000000
46270   DATA 000000110001000000000000
46280   DATA 000001000001110000000000
46290   DATA "@TEXEND"
46300   DATA "HAKA79",16,14,16
46310   DATA 000008FFFF000000
46320   DATA 000008FFFF000000
46330   DATA 0000008FF0000000
46340   DATA 0000008FF0000000
46350   DATA 088FFFFFFFFFFFF0
46360   DATA 88FFFFFFFFFFFFFF
46370   DATA 0000008FF0000000
46380   DATA 0000008FF0000000
46390   DATA 0000008FF0000000
46400   DATA 0000008FF0000000
46410   DATA 0000008FF0000000
46420   DATA 0000008FF0000000
46430   DATA 0000008FFF000000
46440   DATA 000008FFFFF00000
46450   DATA "@TEXEND"
46460   '
46470   '
46480   '
46490   DATA "@ENDDATA"
46500   DATA   0,  0,  0,   0,  0,128
46510   DATA   0,128,  0,   0,128,128
46520   DATA 128,  0,  0, 128,  0,128
46530   DATA 128,128,  0, 128,128,128
46540   DATA 192,192,192,   0,  0,255
46550   DATA   0,255,  0,   0,255,255
46560   DATA 255,  0,  0, 255,  0,255
46570   DATA 255,255,  0, 255,255,255
46580   '
46590   '
