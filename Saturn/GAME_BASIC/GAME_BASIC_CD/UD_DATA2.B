load"com:dummy"
 1000 '===================================
 1001 '<< USERDATA >> Test Program2 by nao
 1002 '===================================
 1003 CLEAR 100   :'User Memory = 100 block
 1004 PLAYINIT "STANDARD",4,0,1~4,50
 1005 '=========================
 1006 'ºº¶×¼ÀÊ DATA¦ LOAD¼Ã ´Ý¿³
 1007 '(DATAÊ <UD_DATA1.B>ÃÞSAVE»ÚÀ File)
 1008 '-------------------------
 1009 BLOAD "BRAM:UD_TEST1",10,0
 1010 USERDATA 10,0:SETSONG
 1011 '
 1012 BLOAD "BRAM:UD_TEST2",10,0
 1013 USERDATA 10,0:SETSONG 2:USERDATA END
 1014 '
 1015 RESTORE *SONG4DT:SETSONG 4       :'ºÚÊ Â³¼Þ®³ DATA¦ Read½Ù¡
 1016 '
 1017 BLOAD "BRAM:UD_TEST3",10,0
 1018 USERDATA 10,0:SETSONG 3
 1019 '
 1020 USERDATA END    :'ºÉ±ÄÃÞ Â³¼Þ®³ DATA¦ Read½Ù Ä·Ê ¶Å×½Þ¼Ã²½ÙºÄ!
 1021 '-------------------------
 1022 BGM:VSYNC 2
 1023 *LP1:IF PLAYSTAT(0)=1 THEN *LP1
 1024 BGM 2:VSYNC 2
 1025 *LP2:IF PLAYSTAT(0)=1 THEN *LP2
 1026 BGM 3:VSYNC 2
 1027 *LP3:IF PLAYSTAT(0)=1 THEN *LP3
 1028 BGM 4:VSYNC 2
 1029 *LP4:IF PLAYSTAT(0)=1 THEN *LP4
 1030 '-------------------------
 1031 EFFECT 1:EFFECT 2:EFFECT 3:EFFECT 4
 1032 END
 1033 '===================================
 1034 *SONG4DT
 1035 DATA "@52 CCDDEED2"
 1036 DATA ENDSONG
