LOAD"COM:DUMMY"
 1000 ' GAME BASIC for SEGASATURN Sound Sample Program Ver 1.1
 1001 ' [ S_TUTOR.B ] ｻｳﾝﾄﾞｷﾉｳﾉ ｻﾝﾌﾟﾙ ﾌﾟﾛｸﾞﾗﾑ
 1002 ' Programmed by Naozumi Honma (nao)
 1003 '
 1004 '
 1005 SCREEN 0:SKCLOSE:CLEAR 10,1360
 1006 IF PEEK(0,3)<>78 THEN KLOAD ON:CLEAR 10,1360:POKE 0,0,0:POKE 0,1,1:POKE 0,2,1:POKE 0,3,78:POKE 0,4,1
 1007 NUM_OF_MSTR=2:WIDTH 1,1,38,26:PLAYINIT
 1008 DIM MSTR$(NUM_OF_MSTR):DIM NAME$(128)
 1009 COLOR ,RGB(31,31,31):COLOROFS ON,0:COLOROFS(-255,-255,-255):VSYNC:OFS=255
 1010 IF PEEK(0,0)=56 THEN *S_MENU_1  :'ｻｳﾝﾄﾞｻﾝﾌﾟﾙｦ ｷｲﾀｱﾄﾊ ﾒﾆｭｰ4ﾆ ﾓﾄﾞﾙ
 1011 '----------------------------
 1012 '●メイン･メニュー
 1013 '----------------------------
 1014 *MAIN_MENU
 1015 KPRINT (10,20,0,1,0)
 1016 KPRINT "  サウンド機能のサンプル･プログラム  ",RGB(31,31,0)
 1017 KPRINT "=====================================",RGB(0,11,22)
 1018 KPRINT "1:用語説明                           "
 1019 KPRINT "2:サウンド･システムのスペック        "
 1020 KPRINT "3:音色データについて                 "
 1021 KPRINT "4:MMLとサウンド命令の使い方          "
 1022 KPRINT "5:サウンド･サンプルを聞いてみよう！  "
 1023 KPRINT "0:終了";:KPRINT "     【 重 要 】               ",RGB(31,22,22)
 1024 KPRINT "･セガサターンの音声出力設定がモノラル",RGB(31,22,22)
 1025 KPRINT " の場合､パン関連のコマンドは無効です｡",RGB(31,22,22)
 1026 KPRINT (10,190),"       番号を選択して下さい。        ",,,RGB(0,16,16)
 1027 GOSUB *FADEIN
 1028 *MMLP
 1029 A$=INPUT$(1):IF A$=" " OR A$=CHR$(13) THEN *MMLP
 1030 IF A$="1" THEN GOSUB *FADEOUT:GOTO *YOUGO_1
 1031 IF A$="2" THEN GOSUB *FADEOUT:GOTO *SPEC_1
 1032 IF A$="3" THEN GOSUB *FADEOUT:OFS=255:GOTO *TONE_1
 1033 IF A$="4" THEN GOSUB *FADEOUT:GOTO *HOW_TO
 1034 IF A$="5" THEN GOSUB *FADEOUT:GOTO *S_MENU_1
 1035 IF A$="0" THEN SCREEN 0:PRINT "Loading LAUNCH.B":GOSUB *FADEOUT:LOAD"CD:LAUNCH",R
 1036 GOTO *MMLP
 1037 '
 1038 '----------------------------
 1039 '●音色をスタンダードに戻す
 1040 '----------------------------
 1041 *TONE_RESET
 1042 CLS:PRINT "Loading STANDARD Set...":PLAYINIT "STANDARD":CLS:TR_FLAG=1
 1043 RETURN
 1044 '
 1045 '------------------------------
 1046 *KEYIN
 1047 GOSUB *FADEIN
 1048 A$=INPUT$(1)
 1049 IF A$="0" OR A$=CHR$(13) OR A$=" " THEN GOSUB *FADEOUT
 1050 RETURN
 1051 '------------------------------
 1052 *FADEIN
 1053 IF OFS=0 THEN RETURN
 1054 FOR OFS=255 TO 0 STEP -32
 1055   COLOROFS(-OFS,-OFS,-OFS)
 1056   VSYNC
 1057 NEXT OFS
 1058 OFS=0
 1059 COLOROFS(0,0,0)
 1060 VSYNC
 1061 RETURN
 1062 '------------------------------
 1063 *FADEOUT
 1064 IF OFS=255 THEN RETURN
 1065 FOR OFS=0 TO 255 STEP 32
 1066   COLOROFS(-OFS,-OFS,-OFS)
 1067   VSYNC
 1068 NEXT OFS
 1069 OFS=255
 1070 COLOROFS(-255,-255,-255)
 1071 CLS 0
 1072 VSYNC
 1073 RETURN
 1074 '
 1075 '----------------------------
 1076 '●用語説明
 1077 '----------------------------
 1078 *YOUGO_1
 1079 KPRINT (10,20,0,1,0)
 1080 KPRINT "用語説明                         1/20",,,RGB(20,0,20)
 1081 KPRINT "MML",RGB(31,31,0)
 1082 KPRINT "･";:KPRINT "Music Macro Language";,RGB(31,22,22):KPRINT "の略で､楽譜を"
 1083 KPRINT " ｢";:KPRINT FIX "C4D8E8…";,RGB(31,31,20):KPRINT "｣などの文字列を使って表現す"
 1084 KPRINT " る､";:KPRINT "音楽専用の簡易言語";,RGB(31,22,22):KPRINT "です｡"
 1085 KPRINT "･多くの基本コマンドに関しては､なるべ"
 1086 KPRINT " く";:KPRINT "MSX";,RGB(31,22,22):KPRINT "など従来のパソコンに搭載されて"
 1087 KPRINT " いたMMLの仕様に合わせてあります｡":KPRINT "･本MML特有のオプションを指定しない場"
 1088 KPRINT " 合は､ほぼ互換性があります｡"
 1089 KPRINT (10,190),"次へ→Space　  戻る→Enter    TOP→0 ",,,RGB(0,16,16)
 1090 GOSUB *KEYIN
 1091 IF A$="0"      THEN *MAIN_MENU
 1092 IF A$=CHR$(13) THEN *MAIN_MENU
 1093 IF A$<>" "     THEN *YOUGO_1
 1094 '-------------
 1095 *YOUGO_2
 1096 KPRINT (10,20,0,1,0)
 1097 KPRINT "用語説明                         2/20",,,RGB(20,0,20)
 1098 KPRINT "ノート(Note)",RGB(31,31,0):KPRINT "･";:KPRINT "音符";,RGB(31,22,22):KPRINT "のことをノートと呼びます｡"
 1099 KPRINT "･1オクターブは､";:KPRINT "12";,RGB(22,22,0):KPRINT "のノートにわかれてい"
 1100 KPRINT " ます(";:KPRINT FIX "C C# D D# E F F# G G# A A# B";,RGB(31,31,20):KPRINT ")｡ "
 1101 KPRINT "･MMLの｢";:KPRINT FIX "N";,RGB(31,31,20):KPRINT "｣コマンドを使って､オクターブ "
 1102 KPRINT " 情報を含んだ音名をダイレクトに指定す":KPRINT " ることができます｡"
 1103 KPRINT "(ｵｸﾀｰﾌﾞ";:KPRINT "0";,RGB(22,22,0):KPRINT "のC = ";:KPRINT FIX "N12";,RGB(31,31,20)
 1104 KPRINT "､ｵｸﾀｰﾌﾞ";:KPRINT "1";,RGB(22,22,0):KPRINT "のC = ";:KPRINT FIX "N24";,RGB(31,31,20):KPRINT "…)"
 1105 KPRINT "･ノート番号は､MIDIに合わせています｡"
 1106 KPRINT (10,190),"次へ→Space　  戻る→Enter    TOP→0 ",,,RGB(0,16,16)
 1107 GOSUB *KEYIN
 1108 IF A$="0"      THEN *MAIN_MENU
 1109 IF A$=CHR$(13) THEN *YOUGO_1
 1110 IF A$<>" "     THEN *YOUGO_2
 1111 '-------------
 1112 *YOUGO_3
 1113 KPRINT (10,20,0,1,0)
 1114 KPRINT "用語説明                         3/20",,,RGB(20,0,20)
 1115 KPRINT "トラック(Track)",RGB(31,31,0):KPRINT "･メロディ､ベース､リズムなど､楽器や特"
 1116 KPRINT " 殊効果別にMML文字列をわけたものの1つ":KPRINT " です｡"
 1117 KPRINT "･本MMLでは､";:KPRINT "16";,RGB(22,22,0):KPRINT "トラックまで独立して制御":KPRINT " できます｡"
 1118 KPRINT "･連続したMML文字列1つが､1トラックに相":KPRINT " 当します｡"
 1119 KPRINT "★1ﾄﾗｯｸに1音という制限はありません｡",RGB(31,22,22)
 1120 KPRINT (10,190),"次へ→Space　  戻る→Enter    TOP→0 ",,,RGB(0,16,16)
 1121 GOSUB *KEYIN
 1122 IF A$="0"      THEN *MAIN_MENU
 1123 IF A$=CHR$(13) THEN *YOUGO_2
 1124 IF A$<>" "     THEN *YOUGO_3
 1125 '-------------
 1126 *YOUGO_4
 1127 KPRINT (10,20,0,1,0)
 1128 KPRINT "用語説明                         4/20",,,RGB(20,0,20)
 1129 KPRINT "ベース･トラック(Base track)",RGB(31,31,0)
 1130 KPRINT "･MMLで";:KPRINT "複数のトラック";,RGB(31,22,22):KPRINT "を記述している時､"
 1131 KPRINT " 一番若いトラック";,RGB(31,22,22):KPRINT "をベース･トラックと":KPRINT " 呼びます(トラック0とは限らない)｡"
 1132 KPRINT "･MMLコマンドの中には､ベース･トラック":KPRINT " にしか記述できないものがあります｡"
 1133 KPRINT " (ループ指定､テンポ設定など)":KPRINT "･トラック番号を省略して記述している"
 1134 KPRINT " 時は､トラック0がベースになります｡"
 1135 KPRINT (10,190),"次へ→Space　  戻る→Enter    TOP→0 ",,,RGB(0,16,16)
 1136 GOSUB *KEYIN
 1137 IF A$="0"      THEN *MAIN_MENU
 1138 IF A$=CHR$(13) THEN *YOUGO_3
 1139 IF A$<>" "     THEN *YOUGO_4
 1140 '-------------
 1141 *YOUGO_5
 1142 KPRINT (10,20,0,1,0)
 1143 KPRINT "用語説明                         5/20",,,RGB(20,0,20)
 1144 KPRINT "ピッチ･ベンド(Pitch bend)",RGB(31,31,0)
 1145 KPRINT "･直訳は｢";:KPRINT "音の高さを曲げる";,RGB(31,22,22):KPRINT "｣ことです｡"
 1146 KPRINT "･本MMLでは､";:KPRINT "16トラック独立";,RGB(31,22,22):KPRINT "してベンド操":KPRINT " 作することができます｡"
 1147 KPRINT "･逆に､トラック単位で制御するため､同一":KPRINT " トラックで鳴っているすべての音が影響"
 1148 KPRINT " を受けてしまいます｡":KPRINT "":KPRINT ""
 1149 KPRINT (10,190),"次へ→Space　  戻る→Enter    TOP→0 ",,,RGB(0,16,16)
 1150 GOSUB *KEYIN
 1151 IF A$="0"      THEN *MAIN_MENU
 1152 IF A$=CHR$(13) THEN *YOUGO_4
 1153 IF A$<>" "     THEN *YOUGO_5
 1154 '-------------
 1155 *YOUGO_6
 1156 KPRINT (10,20,0,1,0)
 1157 KPRINT "用語説明                         6/20",,,RGB(20,0,20)
 1158 KPRINT "ソング･データ(譜面データ／音符データ)",RGB(31,31,0)
 1159 KPRINT "･MMLで記述された音符を､セガサターンが":KPRINT " 演奏できる形式に変換したものです｡"
 1160 KPRINT " (";:KPRINT "PLAY";,RGB(22,22,31):KPRINT "､";:KPRINT "EFFECT";,RGB(22,22,31):KPRINT "､";
 1161 KPRINT "SETSONG";,RGB(22,22,31):KPRINT "命令で登録する)"
 1162 KPRINT "･最大";:KPRINT "16";,RGB(22,22,0):KPRINT "トラック分のMMLを一括変換しま":KPRINT " す｡"
 1163 KPRINT "･登録されたソング･データは､ソング番号":KPRINT " を指定して演奏､ポーズ､フェード､停止"
 1164 KPRINT " などの処理を行ないます｡"
 1165 KPRINT (10,190),"次へ→Space　  戻る→Enter    TOP→0 ",,,RGB(0,16,16)
 1166 GOSUB *KEYIN
 1167 IF A$="0"      THEN *MAIN_MENU
 1168 IF A$=CHR$(13) THEN *YOUGO_5
 1169 IF A$<>" "     THEN *YOUGO_6
 1170 '-------------
 1171 *YOUGO_7
 1172 KPRINT (10,20,0,1,0)
 1173 KPRINT "用語説明                         7/20",,,RGB(20,0,20)
 1174 KPRINT "シーケンス番号",RGB(31,31,0)
 1175 KPRINT "･登録されたソング･データを一度に複数":KPRINT " 鳴らす場合に必要になる管理番号です｡"
 1176 KPRINT "･BASICでは､";:KPRINT "8";,RGB(22,22,0):KPRINT "つのソング･データを同時に"
 1177 KPRINT " 演奏可能です(";:KPRINT "0～7";,RGB(22,22,0):KPRINT ":0番は";:KPRINT "BGM";,RGB(22,22,31):KPRINT "専用)｡"
 1178 KPRINT " 例えば､BGMを鳴らしながら､7つの効果音":KPRINT " を同時に発音できるということです｡"
 1179 KPRINT " (BGMは";:KPRINT "BGM";,RGB(22,22,31):KPRINT "命令､効果音は";:KPRINT "EFFECT";,RGB(22,22,31):KPRINT "命令)"
 1180 KPRINT "★サウンド命令は､シーケンス番号で管理",RGB(22,22,0)
 1181 KPRINT (10,190),"次へ→Space　  戻る→Enter    TOP→0 ",,,RGB(0,16,16)
 1182 GOSUB *KEYIN
 1183 IF A$="0"      THEN *MAIN_MENU
 1184 IF A$=CHR$(13) THEN *YOUGO_6
 1185 IF A$<>" "     THEN *YOUGO_7
 1186 '-------------
 1187 *YOUGO_8
 1188 KPRINT (10,20,0,1,0)
 1189 KPRINT "用語説明                         8/20",,,RGB(20,0,20)
 1190 KPRINT "スロット(Slot)",RGB(31,31,0):KPRINT "･セガサターンの音源ハードウェアで､１":KPRINT " 音を発生させるための機構です｡"
 1191 KPRINT "･本MMLでは､セガサターンに搭載されてい":KPRINT " る";:KPRINT "32";,RGB(22,22,0):KPRINT "個のスロットを別々に制御すること"
 1192 KPRINT " ができますが､スロット番号を意識する ":KPRINT " 必要はありません｡":KPRINT "":KPRINT ""
 1193 KPRINT (10,190),"次へ→Space　  戻る→Enter    TOP→0 ",,,RGB(0,16,16)
 1194 GOSUB *KEYIN
 1195 IF A$="0"      THEN *MAIN_MENU
 1196 IF A$=CHR$(13) THEN *YOUGO_7
 1197 IF A$<>" "     THEN *YOUGO_8
 1198 '-------------
 1199 *YOUGO_9
 1200 KPRINT (10,20,0,1,0)
 1201 KPRINT "用語説明                         9/20",,,RGB(20,0,20)
 1202 KPRINT "レイヤー(Layer)",RGB(31,31,0):KPRINT "･音色データの1音色を構成するための､更"
 1203 KPRINT " に細かい音のデータの単位のことです｡ ":KPRINT "･レイヤーは､以下のような情報を持って"
 1204 KPRINT " いますが､同時に複数は持てません｡":KPRINT " (1)PCMサンプリング･データ(波形データ)",RGB(31,31,20)
 1205 KPRINT "    1つをどのように鳴らすかという情報｡",RGB(31,31,20):KPRINT " (2)FM音源のオペレータ1つを制御｡",RGB(31,31,20)
 1206 KPRINT "★1つのﾚｲﾔｰは､1つのｽﾛｯﾄを動的に制御｡",RGB(31,22,22)
 1207 KPRINT (10,190),"次へ→Space　  戻る→Enter    TOP→0 ",,,RGB(0,16,16)
 1208 GOSUB *KEYIN
 1209 IF A$="0"      THEN *MAIN_MENU
 1210 IF A$=CHR$(13) THEN *YOUGO_8
 1211 IF A$<>" "     THEN *YOUGO_9
 1212 '-------------
 1213 *YOUGO_10
 1214 KPRINT (10,20,0,1,0)
 1215 KPRINT "用語説明                        10/20",,,RGB(20,0,20)
 1216 KPRINT "エンベロープ･ジェネレータ(EG)",RGB(31,31,0):KPRINT "･音の立ち上がりからキー･オフ後の余韻"
 1217 KPRINT " までを､";:KPRINT "4つのカーブ";,RGB(31,22,22):KPRINT "､";:KPRINT "1つのレベル";,RGB(31,22,22):KPRINT "で設定"
 1218 KPRINT " する機構です｡":KPRINT "･本サウンド･システムでは､レイヤー単位":KPRINT " に設定変更できます｡"
 1219 KPRINT " → MMLﾁｭｰﾄﾘｱﾙ ﾒﾆｭｰ4 参照",RGB(31,22,22):KPRINT "":KPRINT ""
 1220 KPRINT (10,190),"次へ→Space　  戻る→Enter    TOP→0 ",,,RGB(0,16,16)
 1221 GOSUB *KEYIN
 1222 IF A$="0"      THEN *MAIN_MENU
 1223 IF A$=CHR$(13) THEN *YOUGO_9
 1224 IF A$<>" "     THEN *YOUGO_10
 1225 '-------------
 1226 *YOUGO_11
 1227 KPRINT (10,20,0,1,0)
 1228 KPRINT "用語説明                        11/20",,,RGB(20,0,20)
 1229 KPRINT "LFO(Low Frequency Oscillator)        ",RGB(31,31,0)
 1230 KPRINT "･人間の耳に聞こえる範囲よりも低い周波":KPRINT " 数の波形を発生する関数発生器のことを":KPRINT " 指します｡"
 1231 KPRINT "･LFOの波形出力は､振幅変調(";:KPRINT "トレモロ";,RGB(31,22,22):KPRINT ")や"
 1232 KPRINT " 周波数変調(";:KPRINT "ビブラート";,RGB(31,22,22):KPRINT ")として使用され":KPRINT " ます｡"
 1233 KPRINT "･PCM波形の場合､";:KPRINT "LFO";,RGB(22,22,31):KPRINT "命令で設定します｡"
 1234 KPRINT " (FM音源の場合は､";:KPRINT "TARG";,RGB(22,22,31):KPRINT "命令の";:KPRINT "FM";,RGB(31,22,22):KPRINT "コマンド)"
 1235 KPRINT (10,190),"次へ→Space　  戻る→Enter    TOP→0 ",,,RGB(0,16,16)
 1236 GOSUB *KEYIN
 1237 IF A$="0"      THEN *MAIN_MENU
 1238 IF A$=CHR$(13) THEN *YOUGO_10
 1239 IF A$<>" "     THEN *YOUGO_11
 1240 '-------------
 1241 *YOUGO_12
 1242 KPRINT (10,20,0,1,0)
 1243 KPRINT "用語説明                        12/20",,,RGB(20,0,20)
 1244 KPRINT "DSP(Digital Signal Processor)",RGB(31,31,0)
 1245 KPRINT "･主に演算(乗算/加算)を高速に行う､高速":KPRINT " 演算専用回路のことです｡"
 1246 KPRINT "･BASICのサウンド機能では､リバーブなど"
 1247 KPRINT " の";:KPRINT "音響エフェクト";,RGB(31,22,22):KPRINT "と呼ばれる効果を演出":KPRINT " する手段として使用されます｡"
 1248 KPRINT "    ステレオ･リバーブ(2種)",RGB(31,31,20):KPRINT "    ステレオ･ディレイ",RGB(31,31,20)
 1249 KPRINT "    モノラル･ディストーション",RGB(31,31,20)
 1250 KPRINT (10,190),"次へ→Space　  戻る→Enter    TOP→0 ",,,RGB(0,16,16)
 1251 GOSUB *KEYIN
 1252 IF A$="0"      THEN *MAIN_MENU
 1253 IF A$=CHR$(13) THEN *YOUGO_11
 1254 IF A$<>" "     THEN *YOUGO_12
 1255 '-------------
 1256 *YOUGO_13
 1257 KPRINT (10,20,0,1,0)
 1258 KPRINT "用語説明                        13/20",,,RGB(20,0,20)
 1259 KPRINT "ダイレクト･データ",RGB(31,31,0)
 1260 KPRINT "･";:KPRINT "DSP";,RGB(31,22,22):KPRINT "を通さず､または通したとしても何の"
 1261 KPRINT " エフェクトもかけなかった音の呼び方で":KPRINT " す｡":KPRINT "":KPRINT "エフェクト･データ",RGB(31,31,0)
 1262 KPRINT "･";:KPRINT "DSP";,RGB(31,22,22):KPRINT "を通して何らかのエフェクトをかけ":KPRINT " た音の呼び方です｡":KPRINT ""
 1263 KPRINT (10,190),"次へ→Space　  戻る→Enter    TOP→0 ",,,RGB(0,16,16)
 1264 GOSUB *KEYIN
 1265 IF A$="0"      THEN *MAIN_MENU
 1266 IF A$=CHR$(13) THEN *YOUGO_12
 1267 IF A$<>" "     THEN *YOUGO_13
 1268 '-------------
 1269 *YOUGO_14
 1270 KPRINT (10,20,0,1,0)
 1271 KPRINT "用語説明                        14/20",,,RGB(20,0,20)
 1272 KPRINT "パンポット",RGB(31,31,0)
 1273 KPRINT "･";:KPRINT "定位";,RGB(31,22,22):KPRINT "(音が聴こえてくる方向)を定める機":KPRINT " 能のことです｡"
 1274 KPRINT "･";:KPRINT "ダイレクト･パン";,RGB(31,22,22):KPRINT "(ダイレクト･データの"
 1275 KPRINT " 定位)と､";:KPRINT "エフェクト･パン";,RGB(31,22,22):KPRINT "(エフェクト･"
 1276 KPRINT " データの定位)の";:KPRINT "2";,RGB(22,22,0):KPRINT "種類があります｡":KPRINT "":KPRINT "":KPRINT ""
 1277 KPRINT (10,190),"次へ→Space　  戻る→Enter    TOP→0 ",,,RGB(0,16,16)
 1278 GOSUB *KEYIN
 1279 IF A$="0"      THEN *MAIN_MENU
 1280 IF A$=CHR$(13) THEN *YOUGO_13
 1281 IF A$<>" "     THEN *YOUGO_14
 1282 '-------------
 1283 *YOUGO_15
 1284 KPRINT (10,20,0,1,0)
 1285 KPRINT "用語説明                        15/20",,,RGB(20,0,20)
 1286 KPRINT "モジュレータ／キャリア",RGB(31,31,0)
 1287 KPRINT "･スロットをFM音源で使用する場合､変調 "
 1288 KPRINT " を";:KPRINT "かける側";,RGB(31,22,22):KPRINT "のスロットを";:KPRINT "モジュレータ";,RGB(31,22,22):KPRINT "､"
 1289 KPRINT " 変調を";:KPRINT "受ける側";,RGB(31,22,22):KPRINT "のスロットを";:KPRINT "キャリア";,RGB(31,22,22):KPRINT "と"
 1290 KPRINT " いいます｡":KPRINT "":KPRINT "":KPRINT "":KPRINT ""
 1291 KPRINT (10,190),"次へ→Space　  戻る→Enter    TOP→0 ",,,RGB(0,16,16)
 1292 GOSUB *KEYIN
 1293 IF A$="0"      THEN *MAIN_MENU
 1294 IF A$=CHR$(13) THEN *YOUGO_14
 1295 IF A$<>" "     THEN *YOUGO_15
 1296 '-------------
 1297 *YOUGO_16
 1298 KPRINT (10,20,0,1,0)
 1299 KPRINT "用語説明                        16/20",,,RGB(20,0,20)
 1300 KPRINT "デルタ･タイム",RGB(31,31,0)
 1301 KPRINT "･広義には､";:KPRINT "曲全体のタイミング";,RGB(31,22,22):KPRINT "を管理す "
 1302 KPRINT " るための";:KPRINT "内部タイム･コード";,RGB(31,22,22):KPRINT "の意味です｡"
 1303 KPRINT "･本MMLでは､";:KPRINT "ダイレクト･レングス";,RGB(31,22,22):KPRINT "に反映 "
 1304 KPRINT " されています｡"
 1305 KPRINT "  → ｢音を鳴らしてみよう！(23/47)";,RGB(31,22,22):KPRINT "参照"
 1306 KPRINT "･ここでは､1つの音符を鳴らした後､次の "
 1307 KPRINT " 音符に移行するまでの時間ということを"
 1308 KPRINT " 認識しておいて下さい｡               "
 1309 KPRINT (10,190),"次へ→Space　  戻る→Enter    TOP→0 ",,,RGB(0,16,16)
 1310 GOSUB *KEYIN
 1311 IF A$="0"      THEN *MAIN_MENU
 1312 IF A$=CHR$(13) THEN *YOUGO_15
 1313 IF A$<>" "     THEN *YOUGO_16
 1314 '-------------
 1315 *YOUGO_17
 1316 KPRINT (10,20,0,1,0)
 1317 KPRINT "用語説明                        17/20",,,RGB(20,0,20)
 1318 KPRINT "ゲート･タイム",RGB(31,31,0)
 1319 KPRINT "･実際にキー･オンしている時間のことで "
 1320 KPRINT " す";:KPRINT "(鍵盤楽器なら鍵盤を押している時間)";,RGB(22,22,31):KPRINT "｡"
 1321 KPRINT "･通常､4分音符ならば4分音符の長さぶん "
 1322 KPRINT " だけキー･オンされますが､次の項目で説"
 1323 KPRINT " 明する ";:KPRINT "Gate / Delta";,RGB(31,22,22):KPRINT " を変えることによ"
 1324 KPRINT " り､ゲート･タイムとデルタ･タイムの比 "
 1325 KPRINT " 率を自由に設定することができます｡"
 1326 KPRINT (10,190),"次へ→Space　  戻る→Enter    TOP→0 ",,,RGB(0,16,16)
 1327 GOSUB *KEYIN
 1328 IF A$="0"      THEN *MAIN_MENU
 1329 IF A$=CHR$(13) THEN *YOUGO_16
 1330 IF A$<>" "     THEN *YOUGO_17
 1331 '-------------
 1332 *YOUGO_18
 1333 KPRINT (10,20,0,1,0)
 1334 KPRINT "用語説明                        18/20",,,RGB(20,0,20)
 1335 KPRINT "Gate / Delta",RGB(31,31,0)
 1336 KPRINT "･";:KPRINT "デルタ･タイム";,RGB(31,22,22):KPRINT "分の";:KPRINT "ゲート･タイム";,RGB(31,22,22):KPRINT "という"
 1337 KPRINT " 意味です｡"
 1338 KPRINT "･2つの時間の比率を変えることによって､"
 1339 KPRINT " 発音している時間を､実際のキー･オン時"
 1340 KPRINT " 間よりも短くしたり長くすることができ"
 1341 KPRINT " ます｡";:KPRINT "→ MMLの「";,RGB(31,22,22):KPRINT FIX "q";,RGB(31,31,20):KPRINT "」コマンド",RGB(31,22,22)
 1342 KPRINT "･次の項目で(例)を挙げます｡"
 1343 KPRINT (10,190),"次へ→Space　  戻る→Enter    TOP→0 ",,,RGB(0,16,16)
 1344 GOSUB *KEYIN
 1345 IF A$="0"      THEN *MAIN_MENU
 1346 IF A$=CHR$(13) THEN *YOUGO_17
 1347 IF A$<>" "     THEN *YOUGO_18
 1348 '-------------
 1349 *YOUGO_19
 1350 KPRINT (10,20,0,1,0)
 1351 KPRINT "用語説明                        19/20",,,RGB(20,0,20)
 1352 KPRINT "Gate / Delta の例 (1)",RGB(31,31,0)
 1353 KPRINT "･Gate / Delta を「";:KPRINT "1/2";,RGB(31,22,22):KPRINT "」に設定して4分"
 1354 KPRINT " 音符を鳴らした場合は､半分の8分音符の"
 1355 KPRINT " の長さしか発音しませんが､次の音符に"
 1356 KPRINT " は4分音符ぶんの長さが経過した後に移"
 1357 KPRINT " 行しますので､スタッカートで演奏する"
 1358 KPRINT " 効果が得られます｡":KPRINT "（詳細は､MMLチュートリアルを参照）"
 1359 KPRINT (10,190),"次へ→Space　  戻る→Enter    TOP→0 ",,,RGB(0,16,16)
 1360 GOSUB *KEYIN
 1361 IF A$="0"      THEN *MAIN_MENU
 1362 IF A$=CHR$(13) THEN *YOUGO_18
 1363 IF A$<>" "     THEN *YOUGO_19
 1364 '-------------
 1365 *YOUGO_20
 1366 KPRINT (10,20,0,1,0)
 1367 KPRINT "用語説明                        20/20",,,RGB(20,0,20)
 1368 KPRINT "Gate / Delta の例 (2)",RGB(31,31,0)
 1369 KPRINT "･Gate / Delta を「";:KPRINT "2/1";,RGB(31,22,22):KPRINT "」に設定して4分"
 1370 KPRINT " 音符を鳴らした場合は､2倍の2分音符の"
 1371 KPRINT " の長さを発音しますが､次の音符には､"
 1372 KPRINT " あくまでも4分音符ぶんの長さ";,RGB(31,22,22):KPRINT "が経過し"
 1373 KPRINT " た後に移行しますので､次の音に重なっ"
 1374 KPRINT " て同時に発音されます｡":KPRINT "（詳細は､MMLチュートリアルを参照）"
 1375 KPRINT (10,190),"次へ→Space　  戻る→Enter    TOP→0 ",,,RGB(0,16,16)
 1376 GOSUB *KEYIN
 1377 IF A$="0"      THEN *MAIN_MENU
 1378 IF A$=CHR$(13) THEN *YOUGO_19
 1379 IF A$<>" "     THEN *YOUGO_20
 1380 GOTO *MAIN_MENU
 1381 '
 1382 '----------------------------
 1383 '●サウンド･システムのスペック
 1384 '----------------------------
 1385 *SPEC_1
 1386 KPRINT (10,20,0,1,0)
 1387 KPRINT "サウンド･システムのスペック       1/9",,,RGB(20,0,20)
 1388 KPRINT "32スロット／16トラック               ",RGB(31,31,0)
 1389 KPRINT "･";:KPRINT "FM";,RGB(31,22,22):KPRINT "/";:KPRINT "PCM";,RGB(31,22,22):KPRINT "兼用のスロット";
 1390 KPRINT "32個";,RGB(31,22,22):KPRINT "が使えます｡ ":KPRINT " (最大同時発音数=32)"
 1391 KPRINT "･";:KPRINT "PCM";,RGB(31,22,22):KPRINT "の場合は､";:KPRINT "1音色1スロット";,RGB(31,22,22):KPRINT "｡"
 1392 KPRINT "･";:KPRINT "FM";,RGB(31,22,22):KPRINT "の場合は､";:KPRINT "1オペレータ1スロット";,RGB(31,22,22):KPRINT "｡"
 1393 KPRINT " (キャリア､モジュレータは任意に選択) ":KPRINT "･すべて4オペレータ･アルゴリズムでFMを"
 1394 KPRINT " 鳴らす場合､32÷4＝";:KPRINT "8音";,RGB(22,22,0):KPRINT "になります｡"
 1395 KPRINT "･";:KPRINT "FM1音";,RGB(31,22,22):KPRINT "に使うスロット数は";:KPRINT "1～32まで任意";,RGB(31,22,22):KPRINT "｡"
 1396 KPRINT (10,190),"次へ→Space　  戻る→Enter    TOP→0 ",,,RGB(0,16,16)
 1397 GOSUB *KEYIN
 1398 IF A$="0"      THEN *MAIN_MENU
 1399 IF A$=CHR$(13) THEN *MAIN_MENU
 1400 IF A$<>" "     THEN *SPEC_1
 1401 '-------------
 1402 *SPEC_2
 1403 KPRINT (10,20,0,1,0)
 1404 KPRINT "サウンド･システムのスペック       2/9",,,RGB(20,0,20)
 1405 KPRINT "最大251ソング(登録可能曲数)",RGB(31,31,0)
 1406 KPRINT "･サウンド･メモリには､";:KPRINT "効果音を含み";,RGB(31,22,22):KPRINT "､"
 1407 KPRINT " 最大";:KPRINT "251";,RGB(22,22,0):KPRINT "曲まで登録可能です｡"
 1408 KPRINT " (";:KPRINT "BEEP";,RGB(22,22,31):KPRINT "命令と";:KPRINT "PLAY";,RGB(22,22,31):KPRINT "命令用を合わせて253)"
 1409 KPRINT "･";:KPRINT "DSPエフェクター";,RGB(31,22,22):KPRINT "を使用したり､音色デー"
 1410 KPRINT " タ領域を";:KPRINT "拡張";,RGB(31,22,22):KPRINT "した場合は､少なくなりま":KPRINT " す｡"
 1411 KPRINT "･通常､ソング番号";:KPRINT "1";,RGB(22,22,0):KPRINT "番を";:KPRINT "BGM";,RGB(22,22,31):KPRINT "用に使います｡"
 1412 KPRINT " (";:KPRINT "0";,RGB(22,22,0):KPRINT "番は";:KPRINT "BEEP";,RGB(22,22,31):KPRINT "/";
 1413 KPRINT "ERROR音";,RGB(31,22,22):KPRINT "用に固定)"
 1414 KPRINT (10,190),"次へ→Space　  戻る→Enter    TOP→0 ",,,RGB(0,16,16)
 1415 GOSUB *KEYIN
 1416 IF A$="0"      THEN *MAIN_MENU
 1417 IF A$=CHR$(13) THEN *SPEC_1
 1418 IF A$<>" "     THEN *SPEC_2
 1419 '-------------
 1420 *SPEC_3
 1421 KPRINT (10,20,0,1,0)
 1422 KPRINT "サウンド･システムのスペック       3/9",,,RGB(20,0,20)
 1423 KPRINT "最大26,000ノート(登録可能な音符の数)",RGB(31,31,0)
 1424 KPRINT "･";:KPRINT "ピッチ･ベンド";,RGB(31,22,22):KPRINT "などの特殊効果を指定し"
 1425 KPRINT " た場合は､";:KPRINT "メモリを多く使用する";,RGB(31,22,22):KPRINT "ため､":KPRINT " 少なくなります｡"
 1426 KPRINT "･";:KPRINT "DSPエフェクター";,RGB(31,22,22):KPRINT "を使用したり､音色デー"
 1427 KPRINT " タ領域を";:KPRINT "拡張";,RGB(31,22,22):KPRINT "した場合は､少なくなりま":KPRINT " す｡"
 1428 KPRINT "･曲単位にメモリ割り当てを自由に変更":KPRINT " できます｡"
 1429 KPRINT (10,190),"次へ→Space　  戻る→Enter    TOP→0 ",,,RGB(0,16,16)
 1430 GOSUB *KEYIN
 1431 IF A$="0"      THEN *MAIN_MENU
 1432 IF A$=CHR$(13) THEN *SPEC_2
 1433 IF A$<>" "     THEN *SPEC_3
 1434 '-------------
 1435 *SPEC_4
 1436 KPRINT (10,20,0,1,0)
 1437 KPRINT "サウンド･システムのスペック       4/9",,,RGB(20,0,20)
 1438 KPRINT "波形メモリ:標準340Kbyte､最大461Kbyte",RGB(31,31,0)
 1439 KPRINT "･差し替えをしないで";:KPRINT "オン･メモリ";,RGB(31,22,22):KPRINT "で同時":KPRINT " に扱える容量です｡"
 1440 KPRINT "･";:KPRINT "波形データ";,RGB(31,22,22):KPRINT "は､";:KPRINT "PLAYINIT";,RGB(22,22,31)
 1441 KPRINT "､";:KPRINT "TARG";,RGB(22,22,31):KPRINT "命令で ";:KPRINT "CD-",RGB(31,22,22)
 1442 KPRINT " ROM";,RGB(31,22,22):KPRINT "からロードして使います｡"
 1443 KPRINT " (";:KPRINT "PCM";,RGB(31,22,22):KPRINT "波形/";:KPRINT "FM変調用";,RGB(31,22,22):KPRINT "波形)"
 1444 KPRINT "･ソング･データ領域､DSPプログラム領域":KPRINT " とのトレード･オフです｡"
 1445 KPRINT "★詳細→『";:KPRINT "4:音色データについて";,RGB(31,22,22):KPRINT "』"
 1446 KPRINT (10,190),"次へ→Space　  戻る→Enter    TOP→0 ",,,RGB(0,16,16)
 1447 GOSUB *KEYIN
 1448 IF A$="0"      THEN *MAIN_MENU
 1449 IF A$=CHR$(13) THEN *SPEC_3
 1450 IF A$<>" "     THEN *SPEC_4
 1451 '-------------
 1452 *SPEC_5
 1453 KPRINT (10,20,0,1,0)
 1454 KPRINT "サウンド･システムのスペック       5/9",,,RGB(20,0,20)
 1455 KPRINT "最大128音色(1音色:最大128レイヤー)",RGB(31,31,0)
 1456 KPRINT "(シンセ用語ではパッチ/パフォーマンス)",RGB(31,31,0)
 1457 KPRINT "･";:KPRINT "レイヤー";,RGB(31,22,22):KPRINT "は､";:KPRINT "音の1波形を制御";,RGB(31,22,22):KPRINT "するデータ｡"
 1458 KPRINT " (FMの場合は､オペレータの1つを制御)"
 1459 KPRINT "･1つの音色は､必ず";:KPRINT "1つ以上";,RGB(31,22,22):KPRINT "のレイヤーか":KPRINT " ら構成されています｡"
 1460 KPRINT "･音色の細かい修正は､";:KPRINT "TPROP";,RGB(22,22,31):KPRINT "命令を使って"
 1461 KPRINT " レイヤー･データを直接操作します｡"
 1462 KPRINT "･";:KPRINT "TARG";,RGB(22,22,31):KPRINT "命令で､自由に組み替え可能です｡"
 1463 KPRINT (10,190),"次へ→Space　  戻る→Enter    TOP→0 ",,,RGB(0,16,16)
 1464 GOSUB *KEYIN
 1465 IF A$="0"      THEN *MAIN_MENU
 1466 IF A$=CHR$(13) THEN *SPEC_4
 1467 IF A$<>" "     THEN *SPEC_5
 1468 '-------------
 1469 *SPEC_6
 1470 KPRINT (10,20,0,1,0)
 1471 KPRINT "サウンド･システムのスペック       6/9",,,RGB(20,0,20)
 1472 KPRINT "エフェクト用DSP制御",RGB(31,31,0)
 1473 KPRINT "･";:KPRINT "PLAYINIT";,RGB(22,22,31):KPRINT "命令でDSPモードの切り替えが"
 1474 KPRINT " 可能です(";:KPRINT "DSP";,RGB(31,22,22):KPRINT "/";:KPRINT "DSPEXT";,RGB(31,22,22):KPRINT "/OFF)｡"
 1475 KPRINT "･リバーブ､ディレイ､ディストーション":KPRINT " をMMLによって切り替えられます｡"
 1476 KPRINT "･";:KPRINT "DSPEXT";,RGB(31,22,22):KPRINT "モードでは､音色単位にエフェク":KPRINT " ターの選択が可能です｡"
 1477 KPRINT "･DSPを使用する場合は､";:KPRINT "DSP";,RGB(22,22,31):KPRINT "命令でミキサ":KPRINT " ーを設定します｡"
 1478 KPRINT (10,190),"次へ→Space　  戻る→Enter    TOP→0 ",,,RGB(0,16,16)
 1479 GOSUB *KEYIN
 1480 IF A$="0"      THEN *MAIN_MENU
 1481 IF A$=CHR$(13) THEN *SPEC_5
 1482 IF A$<>" "     THEN *SPEC_6
 1483 '-------------
 1484 *SPEC_7
 1485 KPRINT (10,20,0,1,0)
 1486 KPRINT "サウンド･システムのスペック       7/9",,,RGB(20,0,20)
 1487 KPRINT "PCM音源200種以上､FM音源512種",RGB(31,31,0)
 1488 KPRINT "･";:KPRINT "CD-ROM";,RGB(31,22,22):KPRINT "から選択できる標準音色数です｡"
 1489 KPRINT " (";:KPRINT "16";,RGB(22,22,0):KPRINT "種のファイルから任意に選択可能)"
 1490 KPRINT "":KPRINT "FM音源編集コマンド装備",RGB(31,31,0)
 1491 KPRINT "･";:KPRINT "32";,RGB(22,22,0):KPRINT "オペレータを自由に結線できます｡"
 1492 KPRINT "･変調用波形は､標準で";:KPRINT "47種";,RGB(22,22,0):KPRINT "あります｡"
 1493 KPRINT " (";:KPRINT "オリジナルPCM波形";,RGB(31,22,22):KPRINT "を変調用に使用可)"
 1494 KPRINT " (過去のFM音源パラメータと互換性あり)"
 1495 KPRINT (10,190),"次へ→Space　  戻る→Enter    TOP→0 ",,,RGB(0,16,16)
 1496 GOSUB *KEYIN
 1497 IF A$="0"      THEN *MAIN_MENU
 1498 IF A$=CHR$(13) THEN *SPEC_6
 1499 IF A$<>" "     THEN *SPEC_7
 1500 '-------------
 1501 *SPEC_8
 1502 KPRINT (10,20,0,1,0)
 1503 KPRINT "サウンド･システムのスペック       8/9",,,RGB(20,0,20)
 1504 KPRINT "スペック詳細",RGB(31,31,0)
 1505 KPRINT "･波形リサンプリング周波数44.1KHz固定｡"
 1506 KPRINT "･";:KPRINT "16";,RGB(22,22,0):KPRINT "bit/";:KPRINT "8";,RGB(22,22,0):KPRINT "bit､波形データ符号反転あり｡"
 1507 KPRINT " (";:KPRINT "AIFF";,RGB(31,22,22):KPRINT "､";:KPRINT "WAVE";,RGB(31,22,22):KPRINT "フォーマット対応)"
 1508 KPRINT "･";:KPRINT "4";,RGB(22,22,0):KPRINT "セグメント";:KPRINT "Amplitude-EG";,RGB(31,22,22):KPRINT "対応｡"
 1509 KPRINT "･";:KPRINT "ALFO";,RGB(31,22,22):KPRINT "/";:KPRINT "PLFO";,RGB(31,22,22):KPRINT "独立指定可能｡"
 1510 KPRINT "･FM音源ファイルは､";:KPRINT "GM配列準拠";,RGB(31,22,22):KPRINT "(";:KPRINT "4";,RGB(22,22,0):KPRINT "セット)｡"
 1511 KPRINT "":KPRINT ""
 1512 KPRINT (10,190),"次へ→Space　  戻る→Enter    TOP→0 ",,,RGB(0,16,16)
 1513 GOSUB *KEYIN
 1514 IF A$="0"      THEN *MAIN_MENU
 1515 IF A$=CHR$(13) THEN *SPEC_7
 1516 IF A$<>" "     THEN *SPEC_8
 1517 '-------------
 1518 *SPEC_9
 1519 KPRINT (10,20,0,1,0)
 1520 KPRINT "サウンド･システムのスペック       9/9",,,RGB(20,0,20)
 1521 KPRINT "MMLの特徴",RGB(31,31,0)
 1522 KPRINT "･";:KPRINT "MSX";,RGB(31,22,22):KPRINT "版のMMLと､";:KPRINT "ほぼ上位コンパチブル";,RGB(31,22,22):KPRINT "｡"
 1523 KPRINT "･調号指定可能(小節､臨時変化記号)｡":KPRINT "･ベロシティ､Gate / Delta､ピッチ･ベンド"
 1524 KPRINT " オート･ボリューム､オート･パン指定可｡":KPRINT "･DSP､ミキサー制御コマンドあり｡"
 1525 KPRINT "･";:KPRINT "128";,RGB(22,22,0):KPRINT "文字×";:KPRINT "52";,RGB(22,22,0):KPRINT "個のフリー定義マクロあり｡"
 1526 KPRINT "･楽典仕様のループ構造｡":KPRINT "･メイン･システムから割り込み監視可能｡"
 1527 KPRINT (10,190),"次へ→Space　  戻る→Enter    TOP→0 ",,,RGB(0,16,16)
 1528 GOSUB *KEYIN
 1529 IF A$="0"      THEN *MAIN_MENU
 1530 IF A$=CHR$(13) THEN *SPEC_8
 1531 IF A$<>" "     THEN *SPEC_9
 1532 GOTO *MAIN_MENU
 1533 '
 1534 '----------------------------
 1535 '●音色データについて
 1536 '----------------------------
 1537 *TONE_1
 1538 KPRINT (10,20,0,1,0)
 1539 KPRINT "音色データについて                1/6",,,RGB(20,0,20)
 1540 KPRINT "基本仕様",RGB(31,31,0)
 1541 KPRINT "･メモリ容量は､";:KPRINT "ソング･データ領域";,RGB(31,22,22):KPRINT "､";:KPRINT "DSPプ",RGB(31,22,22)
 1542 KPRINT " ログラム領域";,RGB(31,22,22):KPRINT "との";:KPRINT "トレード･オフ";,RGB(31,22,22):KPRINT "｡"
 1543 KPRINT "･";:KPRINT "340K";,RGB(22,22,0):KPRINT "byte×";:KPRINT "12";,RGB(22,22,0)
 1544 KPRINT "=約";:KPRINT "4M";,RGB(22,22,0):KPRINT "byte＋";:KPRINT "GM配列";,RGB(31,22,22):KPRINT "の";
 1545 KPRINT "FM";,RGB(31,22,22):KPRINT "音":KPRINT " 源ファイルの中から自由に組み替え可能｡"
 1546 KPRINT "･";:KPRINT "オリジナルPCMサンプリング･データ";,RGB(31,22,22):KPRINT "の登"
 1547 KPRINT " 録､およびピッチを変えての再生が可能｡"
 1548 KPRINT "･";:KPRINT "AIFF";,RGB(31,22,22):KPRINT "形式､";:KPRINT "WAVE";,RGB(31,22,22):KPRINT "形式､";
 1549 KPRINT "バイナリ文字列";,RGB(31,22,22):KPRINT "形式":KPRINT " のPCMデータを音色データにリンク可能｡"
 1550 KPRINT (10,190),"次へ→Space　  戻る→Enter    TOP→0 ",,,RGB(0,16,16)
 1551 GOSUB *KEYIN
 1552 IF A$="0"      THEN *MAIN_MENU
 1553 IF A$=CHR$(13) THEN *MAIN_MENU
 1554 IF A$<>" "     THEN *TONE_1
 1555 '-------------
 1556 *TONE_2
 1557 KPRINT (10,20,0,1,0)
 1558 KPRINT "音色データについて                2/6",,,RGB(20,0,20)
 1559 KPRINT "音色ファイルの種類 1/4               ",RGB(31,31,0)
 1560 KPRINT "1:STANDARD:Standard Set              ",RGB(22,31,22)
 1561 KPRINT "2:ORCHEST :Orchestra Set             ",RGB(22,31,22)
 1562 KPRINT "3:ROCK    :Rock Set                  ",RGB(22,31,22)
 1563 KPRINT "4:DANCE   :Dance Set                 ",RGB(22,31,22)
 1564 KPRINT "･特別な登録作業をしなくても簡単に利用"
 1565 KPRINT " できるように､効果音データを含んだ音 "
 1566 KPRINT " 色データ･ファイルが用意されています｡"
 1567 KPRINT "聞いてみる→1～4                     ",RGB(31,20,20)
 1568 KPRINT (10,190),"次へ→Space　  戻る→Enter    TOP→0 ",,,RGB(0,16,16)
 1569 GOSUB *KEYIN
 1570 IF A$="1" THEN PRINT "Loading Standard Set" :P$="STANDARD":RESTORE *STANDARD_NAME:GOSUB *KIKU_MAIN:GOTO *TONE_2
 1571 IF A$="2" THEN PRINT "Loading Orchestra Set":P$="ORCHEST" :RESTORE *ORCHEST_NAME: GOSUB *KIKU_MAIN:GOTO *TONE_2
 1572 IF A$="3" THEN PRINT "Loading Rock Set"     :P$="ROCK"    :RESTORE *ROCK_NAME:    GOSUB *KIKU_MAIN:GOTO *TONE_2
 1573 IF A$="4" THEN PRINT "Loading Dance Set"    :P$="DANCE"   :RESTORE *DANCE_NAME:   GOSUB *KIKU_MAIN:GOTO *TONE_2
 1574 IF A$="0"      THEN *MAIN_MENU
 1575 IF A$=CHR$(13) THEN *TONE_1
 1576 IF A$<>" "     THEN *TONE_2
 1577 '-------------
 1578 *TONE_3
 1579 KPRINT (10,20,0,1,0)
 1580 KPRINT "音色データについて                3/6",,,RGB(20,0,20)
 1581 KPRINT "音色ファイルの種類 2/4               ",RGB(31,31,0)
 1582 KPRINT "1:PIANO   :Piano Solo Set            ",RGB(22,31,22)
 1583 KPRINT "2:METAL   :Heavy Metal Set           ",RGB(22,31,22)
 1584 KPRINT "3:ETHNIC  :Ethnic(民族楽器) Set      ",RGB(22,31,22)
 1585 KPRINT "4:MBOXPO  :MUSIC BOX & Pipe Organ Set",RGB(22,31,22)
 1586 KPRINT "･特定の音楽ジャンルに特化したハイ･ク "
 1587 KPRINT " オリティ･セットです｡楽器数よりも音質"
 1588 KPRINT " を重視した配置になっています｡       "
 1589 KPRINT "聞いてみる→1～4                     ",RGB(31,20,20)
 1590 KPRINT (10,190),"次へ→Space　  戻る→Enter    TOP→0 ",,,RGB(0,16,16)
 1591 GOSUB *KEYIN
 1592 IF A$="1" THEN PRINT "Loading Piano Solo Set"       :P$="PIANO" :RESTORE *PIANO_NAME: GOSUB *KIKU_MAIN:GOTO *TONE_3
 1593 IF A$="2" THEN PRINT "Loading Heavy Metal Set"      :P$="METAL" :RESTORE *METAL_NAME: GOSUB *KIKU_MAIN:GOTO *TONE_3
 1594 IF A$="3" THEN PRINT "Loading Ethnic Set"           :P$="ETHNIC":RESTORE *ETHNIC_NAME:GOSUB *KIKU_MAIN:GOTO *TONE_3
 1595 IF A$="4" THEN PRINT "Loading MBOX & Pipe Organ Set":P$="MBOXPO":RESTORE *MBOXPO_NAME:GOSUB *KIKU_MAIN:GOTO *TONE_3
 1596 IF A$="0"      THEN *MAIN_MENU
 1597 IF A$=CHR$(13) THEN *TONE_2
 1598 IF A$<>" "     THEN *TONE_3
 1599 '-------------
 1600 *TONE_4
 1601 KPRINT (10,20,0,1,0)
 1602 KPRINT "音色データについて                4/6",,,RGB(20,0,20)
 1603 KPRINT "音色ファイルの種類 3/4               ",RGB(31,31,0)
 1604 KPRINT "1:EXTRA1  :Extra Set 1               ",RGB(22,31,22)
 1605 KPRINT "2:EXTRA2  :Extra Set 2               ",RGB(22,31,22)
 1606 KPRINT "3:EXTRA3  :Extra Set 3               ",RGB(22,31,22)
 1607 KPRINT "4:EXTRA4  :Extra Set 4               ",RGB(22,31,22)
 1608 KPRINT "･用途や音楽ジャンルに関係ない､良質の "
 1609 KPRINT " 波形が用意されています｡必要に応じて "
 1610 KPRINT " TARG";,RGB(22,22,31):KPRINT "命令で組み替えて使用して下さい｡"
 1611 KPRINT "聞いてみる→1～4                     ",RGB(31,20,20)
 1612 KPRINT (10,190),"次へ→Space　  戻る→Enter    TOP→0 ",,,RGB(0,16,16)
 1613 GOSUB *KEYIN
 1614 IF A$="1" THEN PRINT "Loading Extra Set 1":P$="EXTRA1":RESTORE *EXTRA1_NAME:GOSUB *KIKU_MAIN:GOTO *TONE_4
 1615 IF A$="2" THEN PRINT "Loading Extra Set 2":P$="EXTRA2":RESTORE *EXTRA2_NAME:GOSUB *KIKU_MAIN:GOTO *TONE_4
 1616 IF A$="3" THEN PRINT "Loading Extra Set 3":P$="EXTRA3":RESTORE *EXTRA3_NAME:GOSUB *KIKU_MAIN:GOTO *TONE_4
 1617 IF A$="4" THEN PRINT "Loading Extra Set 4":P$="EXTRA4":RESTORE *EXTRA4_NAME:GOSUB *KIKU_MAIN:GOTO *TONE_4
 1618 IF A$="0"      THEN *MAIN_MENU
 1619 IF A$=CHR$(13) THEN *TONE_3
 1620 IF A$<>" "     THEN *TONE_4
 1621 '-------------
 1622 *TONE_5
 1623 KPRINT (10,20,0,1,0)
 1624 KPRINT "音色データについて                5/6",,,RGB(20,0,20)
 1625 KPRINT "音色ファイルの種類 4/4               ",RGB(31,31,0)
 1626 KPRINT "1:GM_FM1  :GM配列FM音源セット1       ",RGB(22,31,22)
 1627 KPRINT "2:GM_FM2  :GM配列FM音源セット2       ",RGB(22,31,22)
 1628 KPRINT "3:GM_FM3  :GM配列FM音源セット3       ",RGB(22,31,22)
 1629 KPRINT "4:GM_FM4  :GM配列FM音源セット4       ",RGB(22,31,22)
 1630 KPRINT "･FM音源によるGM(General MIDI)配列SET "
 1631 KPRINT " です｡音色番号";:KPRINT "0～127";,RGB(22,22,0):KPRINT "全域を使っている"
 1632 KPRINT " ため､他のセットとBEEP音が異なります｡"
 1633 KPRINT "聞いてみる→1～4                     ",RGB(31,20,20)
 1634 KPRINT (10,190),"次へ→Space　  戻る→Enter    TOP→0 ",,,RGB(0,16,16)
 1635 GOSUB *KEYIN
 1636 IF A$="1" THEN PRINT "Loading GM FM Set 1":P$="GM_FM1":RESTORE *GM_FM_NAME:GOSUB *KIKU_MAIN:GOTO *TONE_5
 1637 IF A$="2" THEN PRINT "Loading GM FM Set 2":P$="GM_FM2":RESTORE *GM_FM_NAME:GOSUB *KIKU_MAIN:GOTO *TONE_5
 1638 IF A$="3" THEN PRINT "Loading GM FM Set 3":P$="GM_FM3":RESTORE *GM_FM_NAME:GOSUB *KIKU_MAIN:GOTO *TONE_5
 1639 IF A$="4" THEN PRINT "Loading GM FM Set 4":P$="GM_FM4":RESTORE *GM_FM_NAME:GOSUB *KIKU_MAIN:GOTO *TONE_5
 1640 IF A$="0"      THEN *MAIN_MENU
 1641 IF A$=CHR$(13) THEN *TONE_4
 1642 IF A$<>" "     THEN *TONE_5
 1643 '-------------
 1644 *TONE_6
 1645 KPRINT (10,20,0,1,0)
 1646 KPRINT "音色データについて                6/6",,,RGB(20,0,20)
 1647 KPRINT "組み替えについて",RGB(31,31,0)
 1648 KPRINT "･";:KPRINT "16";,RGB(22,22,0):KPRINT "種の音色ファイルから､任意に選んで"
 1649 KPRINT " 再配置できます｡→ ";:KPRINT "TARG";,RGB(22,22,31):KPRINT "命令"
 1650 KPRINT " (レイヤー単位に組み替え可能)":KPRINT "･エンベロープをはじめ､各種パラメータ"
 1651 KPRINT " の再設定が可能です｡→ ";:KPRINT "TPROP/EG";,RGB(22,22,31):KPRINT "命令"
 1652 KPRINT "･FM音源は､組み替え命令(";:KPRINT "TARG";,RGB(22,22,31):KPRINT ")で登録し"
 1653 KPRINT " ます(PCMとの混在使用も可能です)｡"
 1654 KPRINT "･波形領域の拡張は";:KPRINT "PLAYINIT";,RGB(22,22,31):KPRINT "で行ないます｡"
 1655 KPRINT (10,190),"次へ→Space　  戻る→Enter    TOP→0 ",,,RGB(0,16,16)
 1656 GOSUB *KEYIN
 1657 IF A$="0"      THEN *MAIN_MENU
 1658 IF A$=CHR$(13) THEN *TONE_5
 1659 IF A$<>" "     THEN *TONE_6
 1660 GOTO *MAIN_MENU
 1661 '-------------
 1662 *KIKU_MAIN
 1663 GOSUB *FADEOUT
 1664 I=0
 1665 *KM_LOOP
 1666 READ A$
 1667 IF A$<>"***" THEN NAME$(I)=A$:I=I+1:GOTO *KM_LOOP
 1668 PLAYINIT P$:CLS:CLS 0:COLOROFS ON:COLOROFS(-255,-255,-255)
 1669 A$="":NOTE=60:TONE=1:OCTAVE=4
 1670 KPRINT (10,20,0,1,0)
 1671 KPRINT "   音を鳴らしてみよう！(         )   ",RGB(31,31,0)
 1672 KPRINT "-------------------------------------",RGB(0,11,22)
 1673 KPRINT "":KPRINT "":KPRINT "":KPRINT "":KPRINT "":KPRINT ""
 1674 KPRINT "音色=    (最大    )   オクターブ=    ",RGB(22,31,22)
 1675 KPRINT "“↑↓”or“8 2”   “←→”or“4 6”",RGB(10,27,27)
 1676 KPRINT (10,190),"             戻る→Enter             ",,,RGB(0,16,16)
 1677 LINE(35,52)-(35+32*8,52+16*5),RGB(31,31,31),BF:LINE(0,136)-(319,152),RGB(11,11,11),BF
 1678 XX=0:FOR I=1 TO 7:LINE(35+32+XX,52)-(35+32+XX,52+16*5),RGB(0,0,0):XX=XX+32:NEXT
 1679 LINE(35+32*0+20,52)-(35+32*0+44,52+16*3),RGB(0,0,0),BF
 1680 LINE(35+32*1+20,52)-(35+32*1+44,52+16*3),RGB(0,0,0),BF
 1681 LINE(35+32*3+20,52)-(35+32*3+44,52+16*3),RGB(0,0,0),BF
 1682 LINE(35+32*4+20,52)-(35+32*4+44,52+16*3),RGB(0,0,0),BF
 1683 LINE(35+32*5+20,52)-(35+32*5+44,52+16*3),RGB(0,0,0),BF
 1684 LINE(35+32*7+20,52)-(35+32*7+44,52+16*3),RGB(0,0,0),BF
 1685 LOCATE 7,9 :COLOR 7:PRINT "S   D       G   H   J"
 1686 LOCATE 5,14:COLOR 1:PRINT "Z   X   C   V   B   N   M   ,":COLOR 7
 1687 LOCATE 25,2:COLOR 7:PRINT P$
 1688 GOSUB *FADEIN
 1689 *KIKU_LOOP_1
 1690 COLOR 5:LOCATE 2,16
 1691 PRINT USING "N=### ### ### ### ### ### ### ###";NOTE;NOTE+2;NOTE+4;NOTE+5;NOTE+7;NOTE+9;NOTE+11;NOTE+12
 1692 COLOR 6:LOCATE 6,19:PRINT USING "###";TONE:LOCATE 15,19:PRINT USING "###";TPROP(0,0,@TONE):LOCATE 34,19:PRINT OCTAVE
 1693 COLOR 7:LOCATE 2,17:PRINT NAME$(TONE)
 1694 *KIKU_LOOP_2
 1695 A$=INPUT$(1)
 1696 IF A$="Z" OR A$="z" THEN EFFECT "@"+STR$(TONE)+"O"+STR$(OCTAVE)+"C" :GOTO *KIKU_LOOP_2
 1697 IF A$="X" OR A$="x" THEN EFFECT "@"+STR$(TONE)+"O"+STR$(OCTAVE)+"D" :GOTO *KIKU_LOOP_2
 1698 IF A$="C" OR A$="c" THEN EFFECT "@"+STR$(TONE)+"O"+STR$(OCTAVE)+"E" :GOTO *KIKU_LOOP_2
 1699 IF A$="V" OR A$="v" THEN EFFECT "@"+STR$(TONE)+"O"+STR$(OCTAVE)+"F" :GOTO *KIKU_LOOP_2
 1700 IF A$="B" OR A$="b" THEN EFFECT "@"+STR$(TONE)+"O"+STR$(OCTAVE)+"G" :GOTO *KIKU_LOOP_2
 1701 IF A$="N" OR A$="n" THEN EFFECT "@"+STR$(TONE)+"O"+STR$(OCTAVE)+"A" :GOTO *KIKU_LOOP_2
 1702 IF A$="M" OR A$="m" THEN EFFECT "@"+STR$(TONE)+"O"+STR$(OCTAVE)+"B" :GOTO *KIKU_LOOP_2
 1703 IF A$=","           THEN EFFECT "@"+STR$(TONE)+"O"+STR$(OCTAVE)+">C":GOTO *KIKU_LOOP_2
 1704 IF A$="S" OR A$="s" THEN EFFECT "@"+STR$(TONE)+"O"+STR$(OCTAVE)+"C+":GOTO *KIKU_LOOP_2
 1705 IF A$="D" OR A$="d" THEN EFFECT "@"+STR$(TONE)+"O"+STR$(OCTAVE)+"D+":GOTO *KIKU_LOOP_2
 1706 IF A$="G" OR A$="g" THEN EFFECT "@"+STR$(TONE)+"O"+STR$(OCTAVE)+"F+":GOTO *KIKU_LOOP_2
 1707 IF A$="H" OR A$="h" THEN EFFECT "@"+STR$(TONE)+"O"+STR$(OCTAVE)+"G+":GOTO *KIKU_LOOP_2
 1708 IF A$="J" OR A$="j" THEN EFFECT "@"+STR$(TONE)+"O"+STR$(OCTAVE)+"A+":GOTO *KIKU_LOOP_2
 1709 IF A$="8" OR A$=CHR$(30) THEN TONE=TONE-1:IF TONE=-1 THEN TONE=TPROP(0,0,@TONE)
 1710 IF A$="2" OR A$=CHR$(31) THEN TONE=TONE+1:IF TONE=TPROP(0,0,@TONE)+1 THEN TONE=0
 1711 IF A$="4" OR A$=CHR$(29) THEN OCTAVE=OCTAVE-1:NOTE=NOTE-12:IF OCTAVE=-1 THEN OCTAVE=8:NOTE=108
 1712 IF A$="6" OR A$=CHR$(28) THEN OCTAVE=OCTAVE+1:NOTE=NOTE+12:IF OCTAVE=9  THEN OCTAVE=0:NOTE=12
 1713 IF A$=CHR$(13) THEN GOSUB *FADEOUT:CLS:GOSUB *FADEIN:COLOROFS OFF:COLOROFS ON,0:COLOR 7:OFS=255:COLOROFS(-255,-255,-255):CLS 0:VSYNC:RETURN
 1714 GOTO *KIKU_LOOP_1
 1715 '
 1716 '----------------------------
 1717 '●MMLとサウンド命令の使い方
 1718 '----------------------------
 1719 *HOW_TO
 1720 KPRINT (10,20,0,1,0)
 1721 KPRINT "      MMLとサウンド命令の使い方      ",RGB(31,31,0)
 1722 KPRINT "-------------------------------------",RGB(0,11,22)
 1723 KPRINT "1:MSX版MMLとの互換性について         "
 1724 KPRINT "2:MMLチュートリアル                  "
 1725 KPRINT "                                     "
 1726 KPRINT "                                     "
 1727 KPRINT "                                     "
 1728 KPRINT "           【 重 要 】               ",RGB(31,22,22)
 1729 KPRINT "･チュートリアルは､実際に音が鳴ります ",RGB(31,22,22)
 1730 KPRINT " ので､音量にご注意下さい｡        ",RGB(31,22,22)
 1731 KPRINT (10,190),"番号を選択して下さい。   戻る→Enter ",,,RGB(0,16,16)
 1732 GOSUB *FADEIN
 1733 *HTLP
 1734 A$=INPUT$(1)
 1735 IF A$=" " THEN *HTLP
 1736 IF A$="1" THEN GOSUB *FADEOUT:GOTO *GOKAN_1
 1737 IF A$="2" THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL
 1738 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 1739 GOTO *HTLP
 1740 '-------------
 1741 *GOKAN_1
 1742 KPRINT (10,20,0,1,0)
 1743 KPRINT "MSX版MMLとの互換性について        1/2",,,RGB(20,0,20)
 1744 KPRINT "･以下のコマンドは､MSX版MMLと互換性が":KPRINT " あります｡"
 1745 COLOR ,RGB(26,26,26)
 1746 KPRINT " 音名コマンド｢";:KPRINT FIX "CDEFGAB";,RGB(31,31,20):KPRINT "｣､半音上下｢";:KPRINT FIX "#+-";,RGB(31,31,20)
 1747 KPRINT "｣､":KPRINT " 音量｢";:KPRINT FIX "V";,RGB(31,31,20):KPRINT "｣､オクターブ｢";:KPRINT FIX "<>O";,RGB(31,31,20)
 1748 KPRINT "｣､音長｢";:KPRINT FIX "L";,RGB(31,31,20):KPRINT "｣､"
 1749 KPRINT " 音色切り替え｢";:KPRINT FIX "@";,RGB(31,31,20):KPRINT "｣､休符｢";:KPRINT FIX "R";,RGB(31,31,20)
 1750 KPRINT "｣､連符｢";:KPRINT FIX "{}";,RGB(31,31,20):KPRINT "｣､"
 1751 KPRINT " タイ｢";:KPRINT FIX "&";,RGB(31,31,20):KPRINT "｣､テンポ｢";:KPRINT FIX "T";,RGB(31,31,20):KPRINT "｣"
 1752 COLOR ,RGB(31,31,31)
 1753 KPRINT "･半音上下｢";:KPRINT FIX "#+-";,RGB(31,31,20):KPRINT "｣コマンドは､調号コマンド"
 1754 KPRINT " ｢";:KPRINT FIX "S";,RGB(31,31,20):KPRINT "｣を指定すると意味が変わります｡"
 1755 KPRINT " (ナチュラル｢";:KPRINT FIX "n";,RGB(31,31,20):KPRINT "｣が意味を持つようになる)"
 1756 KPRINT (10,190),"次へ→Space　  戻る→Enter    TOP→0 ",,,RGB(0,16,16)
 1757 GOSUB *KEYIN
 1758 IF A$="0"      THEN *MAIN_MENU
 1759 IF A$=CHR$(13) THEN *HOW_TO
 1760 IF A$<>" "     THEN *GOKAN_1
 1761 '-------------
 1762 *GOKAN_2
 1763 KPRINT (10,20,0,1,0)
 1764 KPRINT "MSX版MMLとの互換性について        2/2",,,RGB(20,0,20)
 1765 KPRINT "･以下のコマンドは､本BASICで新設された":KPRINT " コマンドです｡"
 1766 COLOR ,RGB(26,26,26)
 1767 KPRINT " ループ制御｢";:KPRINT FIX "dc";,RGB(31,31,20):KPRINT "､";:KPRINT FIX "$";,RGB(31,31,20):KPRINT "､";
 1768 KPRINT FIX "ds";,RGB(31,31,20):KPRINT "､";:KPRINT FIX "*";,RGB(31,31,20):KPRINT "､";:KPRINT FIX "|:";,RGB(31,31,20)
 1769 KPRINT "､";:KPRINT FIX ":|";,RGB(31,31,20):KPRINT "､";:KPRINT FIX "|1";,RGB(31,31,20):KPRINT "､";
 1770 KPRINT FIX ":|2";,RGB(31,31,20):KPRINT "｣等"
 1771 KPRINT " マクロ｢";:KPRINT FIX "\";,RGB(31,31,20):KPRINT "､";:KPRINT FIX "p";,RGB(31,31,20):KPRINT "､";
 1772 KPRINT FIX "pp";,RGB(31,31,20):KPRINT "､";:KPRINT FIX "ppp";,RGB(31,31,20):KPRINT "､";:KPRINT FIX "f";,RGB(31,31,20)
 1773 KPRINT "､";:KPRINT FIX "ff";,RGB(31,31,20):KPRINT "､";:KPRINT FIX "fff";,RGB(31,31,20):KPRINT "､";
 1774 KPRINT FIX "mp";,RGB(31,31,20):KPRINT "､";:KPRINT FIX "mf";,RGB(31,31,20):KPRINT "｣"
 1775 KPRINT " DSP制御｢";:KPRINT FIX "ep";,RGB(31,31,20):KPRINT "､";:KPRINT FIX "el";,RGB(31,31,20):KPRINT "､";
 1776 KPRINT FIX "ep";,RGB(31,31,20):KPRINT "｣､トラック内和音｢";:KPRINT FIX "()";,RGB(31,31,20):KPRINT "｣､"
 1777 KPRINT " 調号｢";:KPRINT FIX "S";,RGB(31,31,20):KPRINT "｣､キー･トランスポーズ｢";:KPRINT FIX "K";,RGB(31,31,20)
 1778 KPRINT "｣､"
 1779 KPRINT " ダンパー制御｢";:KPRINT FIX "%";,RGB(31,31,20):KPRINT "｣､ステータス制御｢";:KPRINT FIX "!";,RGB(31,31,20)
 1780 KPRINT "｣､"
 1781 KPRINT " ベロシティ「";:KPRINT FIX "v";,RGB(31,31,20):KPRINT "｣､ピッチ･ベンド｢";:KPRINT FIX "~";,RGB(31,31,20)
 1782 KPRINT "｣等の":KPRINT " 音名コマンドのサブ･オプション｡"
 1783 COLOR ,RGB(31,31,31)
 1784 KPRINT (10,190),"次へ→Space　  戻る→Enter    TOP→0 ",,,RGB(0,16,16)
 1785 GOSUB *KEYIN
 1786 IF A$="0"      THEN *MAIN_MENU
 1787 IF A$=CHR$(13) THEN *GOKAN_1
 1788 IF A$<>" "     THEN *GOKAN_2
 1789 GOTO *HOW_TO
 1790 '
 1791 '-------------
 1792 *M_TUTORIAL
 1793 KPRINT (10,20,0,1,0)
 1794 KPRINT "         MMLチュートリアル           ",RGB(31,31,0),,RGB(10,10,10)
 1795 KPRINT "1:音を鳴らしてみよう！               "
 1796 KPRINT "2:楽譜通りに打ち込んでみよう！       "
 1797 KPRINT "3:音色を組み替えてみよう！           "
 1798 KPRINT "4:音色を加工してみよう！             "
 1799 KPRINT "5:DSPエフェクターを使ってみよう！    "
 1800 KPRINT "6:FM音源で音を作ろう！               "
 1801 KPRINT "7:様々な表現をするためのテクニック   "
 1802 KPRINT "★Space､Enter､0 以外を押してから､もう",RGB(31,20,20)
 1803 KPRINT "  一度Spaceを押すと､リプレイできます｡",RGB(31,20,20)
 1804 KPRINT (10,190),"番号を選択して下さい。   戻る→Enter ",,,RGB(0,16,16)
 1805 GOSUB *FADEIN
 1806 *TLP
 1807 A$=INPUT$(1)
 1808 IF A$=" " THEN *TLP
 1809 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *HOW_TO
 1810 CLS:PRINT "Loading STANDARD Set...":PLAYINIT:CLS
 1811 IF A$="1" THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_1_1
 1812 IF A$="2" THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_2_1
 1813 IF A$="3" THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_3_1
 1814 IF A$="4" THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_4_1
 1815 IF A$="5" THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_5_1
 1816 IF A$="6" THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_6_1
 1817 IF A$="7" THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_7_1
 1818 GOTO *TLP
 1819 '-------------
 1820 *M_TUTORIAL_1_1
 1821 KPRINT (10,20,0,1,0)
 1822 KPRINT "音を鳴らしてみよう！             1/47",,,RGB(20,0,20)
 1823 KPRINT "･";:KPRINT "ドレミﾌｧソラシ";,RGB(31,22,22):KPRINT "を鳴らしてみましょう｡"
 1824 KPRINT "･";:KPRINT "ド";,RGB(31,22,22):KPRINT "は｢";:KPRINT FIX "C";,RGB(31,31,20):KPRINT "｣､";
 1825 KPRINT "レ";,RGB(31,22,22):KPRINT "は｢";:KPRINT FIX "D";,RGB(31,31,20)
 1826 KPRINT "｣､";:KPRINT "ミ";,RGB(31,22,22):KPRINT "は｢";:KPRINT FIX "E";,RGB(31,31,20):KPRINT "｣に対応します｡"
 1827 KPRINT FIX "       PLAY "+CHR$(&H22)+"CDEFGAB"+CHR$(&H22),RGB(31,31,0)
 1828 KPRINT "        または"
 1829 KPRINT FIX "     EFFECT "+CHR$(&H22)+"CDEFGAB"+CHR$(&H22),RGB(31,31,0)
 1830 KPRINT ""
 1831 KPRINT "★本サンプルでは､";:KPRINT "EFFECT";,RGB(22,22,31):KPRINT "命令を使います｡"
 1832 KPRINT "  以後､文字列の内容のみ表記します｡"
 1833 KPRINT "★";:KPRINT "音名コマンド";,RGB(31,22,22):KPRINT "は､";
 1834 KPRINT "大文字";,RGB(31,22,22):KPRINT "で指定します｡"
 1835 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 1836 GOSUB *FADEIN
 1837 A$=INPUT$(1)
 1838 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 1839 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL
 1840 IF A$<>" "     THEN *M_TUTORIAL_1_1
 1841 EFFECT(ST),"CDEFGAB"
 1842 GOSUB *KEYIN
 1843 VSYNC 2:PLAYSTOP ST
 1844 IF A$="0"      THEN *MAIN_MENU
 1845 IF A$=CHR$(13) THEN *M_TUTORIAL
 1846 IF A$<>" "     THEN *M_TUTORIAL_1_1
 1847 '-------------
 1848 *M_TUTORIAL_1_2
 1849 KPRINT (10,20,0,1,0)
 1850 KPRINT "音を鳴らしてみよう！             2/47",,,RGB(20,0,20)
 1851 KPRINT "･いま鳴らした音色は､";:KPRINT "デフォルト";,RGB(31,22,22):KPRINT "音色";:KPRINT "0";,RGB(22,22,0):KPRINT "番"
 1852 KPRINT " です(";:KPRINT "BEEP";,RGB(22,22,31):KPRINT "命令用の音色)｡"
 1853 KPRINT "･何も指定しない場合は､デフォルト値を":KPRINT " 使って演奏します｡"
 1854 KPRINT "･現在､";:KPRINT "STANDARD";,RGB(31,22,22):KPRINT "セットがロードされてい"
 1855 KPRINT " ますので､今度は";:KPRINT "Strings";,RGB(31,22,22):KPRINT "の音色を使って"
 1856 KPRINT " 演奏してみましょう｡"
 1857 KPRINT FIX " @44 CDEFGAB",RGB(31,31,0)
 1858 KPRINT " ~~~ STANDARD 44番が､Stringsです｡"
 1859 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 1860 GOSUB *FADEIN
 1861 A$=INPUT$(1)
 1862 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 1863 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_1_1
 1864 IF A$<>" "     THEN *M_TUTORIAL_1_2
 1865 EFFECT(ST),"@44CDEFGAB"
 1866 GOSUB *KEYIN
 1867 VSYNC 2:PLAYSTOP ST
 1868 IF A$="0"      THEN *MAIN_MENU
 1869 IF A$=CHR$(13) THEN *M_TUTORIAL_1_1
 1870 IF A$<>" "     THEN *M_TUTORIAL_1_2
 1871 '-------------
 1872 *M_TUTORIAL_1_3
 1873 KPRINT (10,20,0,1,0)
 1874 KPRINT "音を鳴らしてみよう！             3/47",,,RGB(20,0,20)
 1875 KPRINT "･このように､｢";:KPRINT FIX "@";,RGB(31,31,20):KPRINT "｣コマンドを使って好きな"
 1876 KPRINT " 音色を選択することができます｡"
 1877 KPRINT "･下の例は､";:KPRINT "35";,RGB(31,22,22):KPRINT "番の";:KPRINT "Synth Bass";,RGB(31,22,22):KPRINT "から､";
 1878 KPRINT "36";,RGB(31,22,22):KPRINT "番の"
 1879 KPRINT " A.Piano";,RGB(31,22,22):KPRINT "に音色を切り替えて演奏します｡"
 1880 KPRINT FIX " @35 CDEF @36 GAB",RGB(31,31,0)
 1881 KPRINT "":KPRINT "":KPRINT "":KPRINT ""
 1882 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 1883 GOSUB *FADEIN
 1884 A$=INPUT$(1)
 1885 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 1886 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_1_2
 1887 IF A$<>" "     THEN *M_TUTORIAL_1_3
 1888 EFFECT(ST),"@35 CDEF @36 GAB"
 1889 GOSUB *KEYIN
 1890 VSYNC 2:PLAYSTOP ST
 1891 IF A$="0"      THEN *MAIN_MENU
 1892 IF A$=CHR$(13) THEN *M_TUTORIAL_1_2
 1893 IF A$<>" "     THEN *M_TUTORIAL_1_3
 1894 '-------------
 1895 *M_TUTORIAL_1_4
 1896 KPRINT (10,20,0,1,0)
 1897 KPRINT "音を鳴らしてみよう！             4/47",,,RGB(20,0,20)
 1898 KPRINT "･";:KPRINT "空白";,RGB(31,22,22):KPRINT "は､何も実行しません｡"
 1899 KPRINT "･どこに挿入されていてもよく､また､いく":KPRINT " つあっても無視されます｡"
 1900 KPRINT "･プログラムリストを見易く整えるときに":KPRINT " 使って下さい｡"
 1901 KPRINT "･下の例は､どれも同じように演奏します｡"
 1902 KPRINT FIX " @35CDEF@36GAB",RGB(31,31,20)
 1903 KPRINT FIX " @35 CDEF @36 GAB",RGB(31,31,20)
 1904 KPRINT FIX " @ 3  5 C    D E F @   3  6 G A   B",RGB(31,31,20)
 1905 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 1906 GOSUB *KEYIN
 1907 IF A$="0"      THEN *MAIN_MENU
 1908 IF A$=CHR$(13) THEN *M_TUTORIAL_1_3
 1909 IF A$<>" "     THEN *M_TUTORIAL_1_4
 1910 '-------------
 1911 *M_TUTORIAL_1_5
 1912 KPRINT (10,20,0,1,0)
 1913 KPRINT "音を鳴らしてみよう！             5/47",,,RGB(20,0,20)
 1914 KPRINT "･";:KPRINT "オクターブ";,RGB(31,22,22):KPRINT "を直接変更するときは､｢";:KPRINT FIX "O";,RGB(31,31,20)
 1915 KPRINT "｣コ"
 1916 KPRINT " マンドを使います (｢";:KPRINT FIX "O0";,RGB(31,31,20):KPRINT "｣～｢";:KPRINT FIX "O8";,RGB(31,31,20):KPRINT "｣)｡"
 1917 KPRINT "･現在のオクターブを上げ下げする場合は､":KPRINT " 以下のように指定します｡"
 1918 KPRINT "    オクターブを下げる｢";:KPRINT FIX "<";,RGB(31,31,20):KPRINT "｣"
 1919 KPRINT "    オクターブを上げる｢";:KPRINT FIX ">";,RGB(31,31,20):KPRINT "｣"
 1920 KPRINT FIX "@35 O2 C O3 C O4 C O5 C O4 C O3 C O2 C",RGB(31,31,20)
 1921 KPRINT FIX "@35 O2 C >  C >  C >  C <  C <  C <  C",RGB(31,31,0)
 1922 KPRINT "    (上の2行は､同じ演奏をします)"
 1923 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 1924 GOSUB *FADEIN
 1925 A$=INPUT$(1)
 1926 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 1927 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_1_4
 1928 IF A$<>" "     THEN *M_TUTORIAL_1_5
 1929 EFFECT(ST),"@35 O2 C >  C >  C >  C <  C <  C <  C"
 1930 GOSUB *KEYIN
 1931 VSYNC 2:PLAYSTOP ST
 1932 IF A$="0"      THEN *MAIN_MENU
 1933 IF A$=CHR$(13) THEN *M_TUTORIAL_1_4
 1934 IF A$<>" "     THEN *M_TUTORIAL_1_5
 1935 '-------------
 1936 *M_TUTORIAL_1_6
 1937 KPRINT (10,20,0,1,0)
 1938 KPRINT "音を鳴らしてみよう！             6/47",,,RGB(20,0,20)
 1939 KPRINT "･";:KPRINT "休符";,RGB(31,22,22):KPRINT "は休符コマンド｢";:KPRINT FIX "R";,RGB(31,31,20):KPRINT "｣を使います｡"
 1940 KPRINT FIX " @35 CD R EF R GA R B",RGB(31,31,0)
 1941 KPRINT "        ~    ~    ~"
 1942 KPRINT "":KPRINT "":KPRINT "":KPRINT "":KPRINT "":KPRINT ""
 1943 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 1944 GOSUB *FADEIN
 1945 A$=INPUT$(1)
 1946 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 1947 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_1_5
 1948 IF A$<>" "     THEN *M_TUTORIAL_1_6
 1949 EFFECT(ST),"@35 CD R EF R GA R B"
 1950 GOSUB *KEYIN
 1951 VSYNC 2:PLAYSTOP ST
 1952 IF A$="0"      THEN *MAIN_MENU
 1953 IF A$=CHR$(13) THEN *M_TUTORIAL_1_5
 1954 IF A$<>" "     THEN *M_TUTORIAL_1_6
 1955 '-------------
 1956 *M_TUTORIAL_1_7
 1957 KPRINT (10,20,0,1,0)
 1958 KPRINT "音を鳴らしてみよう！             7/47",,,RGB(20,0,20)
 1959 KPRINT "･音名コマンド｢";:KPRINT FIX "CDEFGAB";,RGB(31,31,20):KPRINT "｣や､休符コマンド"
 1960 KPRINT " ｢";:KPRINT FIX "R";,RGB(31,31,20):KPRINT "｣の後ろには､様々な";
 1961 KPRINT "オプション";,RGB(31,22,22):KPRINT "を指定":KPRINT " することができます｡"
 1962 KPRINT "音名指定コマンドのオプション一覧",RGB(31,31,0)
 1963 KPRINT FIX " A";,RGB(31,31,20):KPRINT "～";:KPRINT FIX "G";,RGB(31,31,20):KPRINT " or ";:KPRINT FIX "R",RGB(31,31,20)
 1964 KPRINT " [";:KPRINT FIX "+";,RGB(31,31,20):KPRINT "|";:KPRINT FIX "#";,RGB(31,31,20):KPRINT "|";
 1965 KPRINT FIX "-";,RGB(31,31,20):KPRINT "|";:KPRINT FIX "n";,RGB(31,31,20):KPRINT "][音長][";
 1966 KPRINT FIX ".";,RGB(31,31,20):KPRINT "][";:KPRINT FIX ".";,RGB(31,31,20):KPRINT "][";
 1967 KPRINT FIX ".";,RGB(31,31,20):KPRINT "]"
 1968 KPRINT " [";:KPRINT FIX ";";,RGB(31,31,20):KPRINT "ベロシティ [";:KPRINT FIX ";";,RGB(31,31,20)
 1969 KPRINT "Gate / Delta]]"
 1970 KPRINT " [";:KPRINT FIX "~";,RGB(31,31,20):KPRINT "[";:KPRINT FIX "V";,RGB(31,31,20):KPRINT "|";
 1971 KPRINT FIX "P";,RGB(31,31,20):KPRINT "][初期値]";:KPRINT FIX ";";,RGB(31,31,20):KPRINT "[目標値]";
 1972 KPRINT FIX ";";,RGB(31,31,20):KPRINT "[ベンド長]]":KPRINT " [";:KPRINT FIX "?";,RGB(31,31,20):KPRINT "[コード･ネーム][;転回数]]"
 1973 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 1974 GOSUB *KEYIN
 1975 IF A$="0"      THEN *MAIN_MENU
 1976 IF A$=CHR$(13) THEN *M_TUTORIAL_1_6
 1977 IF A$<>" "     THEN *M_TUTORIAL_1_7
 1978 '-------------
 1979 *M_TUTORIAL_1_8
 1980 KPRINT (10,20,0,1,0)
 1981 KPRINT "音を鳴らしてみよう！             8/47",,,RGB(20,0,20)
 1982 KPRINT "･｢";:KPRINT FIX "+";,RGB(31,31,20):KPRINT "｣または｢";:KPRINT FIX "#";,RGB(31,31,20)
 1983 KPRINT "｣を指定すると､半音上がり":KPRINT " ます(";:KPRINT "ｼｬｰﾌﾟ";,RGB(31,22,22):KPRINT ")｡"
 1984 KPRINT "･｢";:KPRINT FIX "-";,RGB(31,31,20):KPRINT "｣を指定すると､半音下がります(";
 1985 KPRINT "ﾌﾗｯﾄ";,RGB(31,22,22):KPRINT ")｡"
 1986 KPRINT "･調指定コマンド｢";:KPRINT FIX "S";,RGB(31,31,20):KPRINT "｣を使っているときは､"
 1987 KPRINT " 音名コマンド｢";:KPRINT FIX "CDEFGAB";,RGB(31,31,20):KPRINT "｣を";:KPRINT "幹音名";,RGB(31,22,22)
 1988 KPRINT "と見な":KPRINT " し､｢";:KPRINT FIX "+";,RGB(31,31,20):KPRINT "｣｢";:KPRINT FIX "-";,RGB(31,31,20)
 1989 KPRINT "｣は";:KPRINT "臨時記号";,RGB(31,22,22):KPRINT "として働きます｡":KPRINT " さらに､半音シフトされた音を幹音に戻"
 1990 KPRINT " す｢";:KPRINT FIX "n";,RGB(31,31,20):KPRINT "｣が有効になります(";:KPRINT "ﾅﾁｭﾗﾙ";,RGB(31,22,22):KPRINT ")｡"
 1991 KPRINT "★調についての詳細は｢";,RGB(22,22,0):KPRINT "ﾁｭｰﾄﾘｱﾙ ﾒﾆｭｰ2";,RGB(31,22,22):KPRINT "｣",RGB(22,22,0)
 1992 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 1993 GOSUB *KEYIN
 1994 IF A$="0"      THEN *MAIN_MENU
 1995 IF A$=CHR$(13) THEN *M_TUTORIAL_1_7
 1996 IF A$<>" "     THEN *M_TUTORIAL_1_8
 1997 '-------------
 1998 *M_TUTORIAL_1_9
 1999 KPRINT (10,20,0,1,0)
 2000 KPRINT "音を鳴らしてみよう！             9/47",,,RGB(20,0,20)
 2001 KPRINT "･では､実際に音を出してみましょう｡":KPRINT FIX " @44 C C# D D# E E- D D- C",RGB(31,31,0):KPRINT "":KPRINT ""
 2002 KPRINT FIX " C- E# E+ F- B# B+",RGB(31,31,20)
 2003 KPRINT "  を指定しても､エラーにはなりません｡",RGB(22,22,0):KPRINT "":KPRINT "･ダブル♯､ダブル♭は対応していません｡"
 2004 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 2005 GOSUB *FADEIN
 2006 A$=INPUT$(1)
 2007 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 2008 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_1_8
 2009 IF A$<>" "     THEN *M_TUTORIAL_1_9
 2010 EFFECT(ST),"@44 C C# D D# E E- D D- C"
 2011 GOSUB *KEYIN
 2012 VSYNC 2:PLAYSTOP ST
 2013 IF A$="0"      THEN *MAIN_MENU
 2014 IF A$=CHR$(13) THEN *M_TUTORIAL_1_8
 2015 IF A$<>" "     THEN *M_TUTORIAL_1_9
 2016 '-------------
 2017 *M_TUTORIAL_1_10
 2018 KPRINT (10,20,0,1,0)
 2019 KPRINT "音を鳴らしてみよう！            10/47",,,RGB(20,0,20)
 2020 KPRINT "･音名の後ろに数字を付けると､";:KPRINT "臨時";,RGB(31,22,22):KPRINT "に音"
 2021 KPRINT " の";:KPRINT "長さ";,RGB(31,22,22):KPRINT "を指定することができます｡"
 2022 KPRINT "･指定できる音の長さは､以下の通りです｡"
 2023 KPRINT FIX " 1,2,3,4,6,8,12,16,24,32,48,64,96,128",RGB(31,31,20)
 2024 KPRINT "･それぞれ､全音符｢";:KPRINT FIX "1";,RGB(31,31,20):KPRINT "｣を基準に､その長さ "
 2025 KPRINT " を";:KPRINT "何等分した長さであるか";,RGB(31,22,22):KPRINT "を意味します｡"
 2026 KPRINT "･すべての長さを順番に鳴らしてみます｡"
 2027 KPRINT " (";:KPRINT "35";,RGB(31,22,22):KPRINT "番の";:KPRINT "Synth Bass";,RGB(31,22,22):KPRINT "を使い､休符を挿入)"
 2028 KPRINT FIX "@35 C1 R C2 R C3 ･･･ C64 R C96 R C128",RGB(31,31,0)
 2029 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 2030 GOSUB *FADEIN
 2031 A$=INPUT$(1)
 2032 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 2033 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_1_9
 2034 IF A$<>" "     THEN *M_TUTORIAL_1_10
 2035 EFFECT(ST),"@35 C1 R C2 R C3 R C4 R C6 R C8 R C12 R C16 R C24 R C32 R C48 R C64 R C96 R C128"
 2036 GOSUB *KEYIN
 2037 VSYNC 2:PLAYSTOP ST
 2038 IF A$="0"      THEN *MAIN_MENU
 2039 IF A$=CHR$(13) THEN *M_TUTORIAL_1_9
 2040 IF A$<>" "     THEN *M_TUTORIAL_1_10
 2041 '-------------
 2042 *M_TUTORIAL_1_11
 2043 KPRINT (10,20,0,1,0)
 2044 KPRINT "音を鳴らしてみよう！            11/47",,,RGB(20,0,20)
 2045 KPRINT "･さらに､数字の後ろに";:KPRINT "3";,RGB(22,22,0):KPRINT "つまで";:KPRINT "付点";,RGB(31,22,22)
 2046 KPRINT "記号｢";:KPRINT FIX ".";,RGB(31,31,20):KPRINT "｣":KPRINT " を付けることができます｡"
 2047 KPRINT "･付点記号は､直前に指定した音長の";:KPRINT "半分",RGB(31,22,22)
 2048 KPRINT " の長さ";,RGB(31,22,22):KPRINT "を";:KPRINT "付け加える";,RGB(31,22,22):KPRINT "働きがあります｡"
 2049 KPRINT "･なお､これらのオプションは､休符にも同":KPRINT " じように指定することができます｡"
 2050 KPRINT FIX " @35 C4 R4 C4. R4. C4.. R4.. C4...",RGB(31,31,0):KPRINT "  4分音符､4分休符､付点4分音符…"
 2051 KPRINT "(｢";:KPRINT FIX "C4...";,RGB(31,31,20):KPRINT "｣は｢";:KPRINT FIX "C4 C8 C16 C32";,RGB(31,31,20)
 2052 KPRINT "｣の長さの合計)"
 2053 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 2054 GOSUB *FADEIN
 2055 A$=INPUT$(1)
 2056 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 2057 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_1_10
 2058 IF A$<>" "     THEN *M_TUTORIAL_1_11
 2059 EFFECT(ST),"@35 C4 R4 C4. R4. C4.. R4.. C4..."
 2060 GOSUB *KEYIN
 2061 VSYNC 2:PLAYSTOP ST
 2062 IF A$="0"      THEN *MAIN_MENU
 2063 IF A$=CHR$(13) THEN *M_TUTORIAL_1_10
 2064 IF A$<>" "     THEN *M_TUTORIAL_1_11
 2065 '-------------
 2066 *M_TUTORIAL_1_12
 2067 KPRINT (10,20,0,1,0)
 2068 KPRINT "音を鳴らしてみよう！            12/47",,,RGB(20,0,20)
 2069 KPRINT "･ここから先の音名コマンド用オプション":KPRINT " は､本MMLで新しく付け加わったものです｡"
 2070 KPRINT "･とにかく音楽演奏をさせてみたい方はス":KPRINT " キップして､慣れた後でもう一度戻って "
 2071 KPRINT " 見て下さい｡":KPRINT ""
 2072 KPRINT " [";:KPRINT FIX ";";,RGB(31,31,20):KPRINT "ベロシティ [";:KPRINT FIX ";";,RGB(31,31,20)
 2073 KPRINT "Gate / Delta]]":KPRINT " [";:KPRINT FIX "~";,RGB(31,31,20):KPRINT "[";:KPRINT FIX "V";,RGB(31,31,20):KPRINT "|";
 2074 KPRINT FIX "P";,RGB(31,31,20):KPRINT "][初期値]";:KPRINT FIX ";";,RGB(31,31,20):KPRINT "[目標値]";
 2075 KPRINT FIX ";";,RGB(31,31,20):KPRINT "[ベンド長]]":KPRINT " [";:KPRINT FIX "?";,RGB(31,31,20):KPRINT "[コード･ネーム][;転回数]]"
 2076 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 2077 GOSUB *KEYIN
 2078 IF A$="0"      THEN *MAIN_MENU
 2079 IF A$=CHR$(13) THEN *M_TUTORIAL_1_11
 2080 IF A$<>" "     THEN *M_TUTORIAL_1_12
 2081 '-------------
 2082 *M_TUTORIAL_1_13
 2083 KPRINT (10,20,0,1,0)
 2084 KPRINT "音を鳴らしてみよう！            13/47",,,RGB(20,0,20)
 2085 KPRINT "･音名の後の｢";:KPRINT FIX ";";,RGB(31,31,20):KPRINT "｣に続き､";:KPRINT "臨時ベロシティ値",RGB(31,22,22)
 2086 KPRINT " と";:KPRINT "臨時Gate / Delta";,RGB(31,22,22):KPRINT "指定ができます｡"
 2087 KPRINT "･ベロシティは､鍵盤などをたたく速さを":KPRINT " 指定するもので､数値が大きいほど強く"
 2088 KPRINT " 速くなります(";:KPRINT "0";,RGB(22,22,0):KPRINT "～";:KPRINT "127";,RGB(22,22,0):KPRINT ")｡"
 2089 KPRINT "(デフォルトは｢";:KPRINT FIX "v";,RGB(31,31,20):KPRINT "｣コマンドで設定した値)"
 2090 KPRINT FIX " @36 C;20 C;40 C;60 C;80 C;100 C;120 ",RGB(31,31,0)
 2091 KPRINT "･演奏ボリュームを指定するものではあり":KPRINT " ませんので注意して下さい｡"
 2092 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 2093 GOSUB *FADEIN
 2094 A$=INPUT$(1)
 2095 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 2096 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_1_12
 2097 IF A$<>" "     THEN *M_TUTORIAL_1_13
 2098 EFFECT(ST),"@36 C;20 C;40 C;60 C;80 C;100 C;120"
 2099 GOSUB *KEYIN
 2100 VSYNC 2:PLAYSTOP ST
 2101 IF A$="0"      THEN *MAIN_MENU
 2102 IF A$=CHR$(13) THEN *M_TUTORIAL_1_12
 2103 IF A$<>" "     THEN *M_TUTORIAL_1_13
 2104 '-------------
 2105 *M_TUTORIAL_1_14
 2106 KPRINT (10,20,0,1,0)
 2107 KPRINT "音を鳴らしてみよう！            14/47",,,RGB(20,0,20)
 2108 KPRINT "･ベロシティのさらに後ろに｢";:KPRINT FIX ";";,RGB(31,31,20):KPRINT "｣を付けて､"
 2109 KPRINT " 臨時Gate / Delta指定ができます｡"
 2110 KPRINT "･これは､指定音長に対する実際の";:KPRINT "Key ON",RGB(31,22,22)
 2111 KPRINT " 時間";,RGB(31,22,22):KPRINT "の比を分数で指定するもので､";:KPRINT "スタ",RGB(31,22,22)
 2112 KPRINT " ッカート";,RGB(31,22,22):KPRINT "を表現するときに使用します｡ "
 2113 KPRINT FIX " @35 C;;1   C;;2   C;;3   C;;4",RGB(31,31,0)
 2114 KPRINT FIX " @35 C;;1/1 C;;1/2 C;;1/3 C;;1/4",RGB(31,31,20)
 2115 KPRINT "･上の例のように";:KPRINT "分子を省略";,RGB(31,22,22):KPRINT "することが"
 2116 KPRINT " できます(上の2行の意味は同じです)｡"
 2117 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 2118 GOSUB *FADEIN
 2119 A$=INPUT$(1)
 2120 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 2121 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_1_13
 2122 IF A$<>" "     THEN *M_TUTORIAL_1_14
 2123 EFFECT(ST),"@35 C;;1   C;;2   C;;3   C;;4"
 2124 GOSUB *KEYIN
 2125 VSYNC 2:PLAYSTOP ST
 2126 IF A$="0"      THEN *MAIN_MENU
 2127 IF A$=CHR$(13) THEN *M_TUTORIAL_1_13
 2128 IF A$<>" "     THEN *M_TUTORIAL_1_14
 2129 '-------------
 2130 *M_TUTORIAL_1_15
 2131 KPRINT (10,20,0,1,0)
 2132 KPRINT "音を鳴らしてみよう！            15/47",,,RGB(20,0,20)
 2133 KPRINT "･Gate / Delta指定の分子を大きくして､"
 2134 KPRINT " 指定音長より長く鳴らす";,RGB(31,22,22):KPRINT "ことも可能です｡"
 2135 KPRINT "･この場合にも､指定音長分演奏したら次":KPRINT " の音符に移るので､前の音を引きずりな"
 2136 KPRINT " がら､音を重ねて演奏することができま":KPRINT " す(";:KPRINT "分散和音表現";,RGB(31,22,22):KPRINT ")｡"
 2137 KPRINT FIX " @35 C2;;3/1   E2;;2/1   G2",RGB(31,31,0)
 2138 KPRINT "(｢";:KPRINT FIX "C";,RGB(31,31,20):KPRINT "｣を指定音長の";:KPRINT "3倍";,RGB(22,22,0)
 2139 KPRINT "､｢";:KPRINT FIX "E";,RGB(31,31,20):KPRINT "｣を";:KPRINT "2倍";,RGB(22,22,0):KPRINT "にしてい "
 2140 KPRINT " るので､｢";:KPRINT FIX "G";,RGB(31,31,20):KPRINT "｣が鳴り終わるまで鳴り続ける)"
 2141 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 2142 GOSUB *FADEIN
 2143 A$=INPUT$(1)
 2144 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 2145 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_1_14
 2146 IF A$<>" "     THEN *M_TUTORIAL_1_15
 2147 EFFECT(ST),"@35 C2;;3/1   E2;;2/1   G2"
 2148 GOSUB *KEYIN
 2149 VSYNC 2:PLAYSTOP ST
 2150 IF A$="0"      THEN *MAIN_MENU
 2151 IF A$=CHR$(13) THEN *M_TUTORIAL_1_14
 2152 IF A$<>" "     THEN *M_TUTORIAL_1_15
 2153 '-------------
 2154 *M_TUTORIAL_1_16
 2155 KPRINT (10,20,0,1,0)
 2156 KPRINT "音を鳴らしてみよう！            16/47",,,RGB(20,0,20)
 2157 KPRINT "･同じ臨時指定が続く場合､それをデフォ":KPRINT " ルトとして登録しておくことができます｡"
 2158 KPRINT "   音長指定コマンド    ：｢";,RGB(31,31,20):KPRINT FIX "L";,RGB(31,31,20):KPRINT "｣",RGB(31,31,20)
 2159 KPRINT "   ベロシティコマンド  ：｢";,RGB(31,31,20):KPRINT FIX "v";,RGB(31,31,20):KPRINT "｣",RGB(31,31,20)
 2160 KPRINT "   Gate / Deltaコマンド：｢";,RGB(31,31,20):KPRINT FIX "q";,RGB(31,31,20):KPRINT "｣",RGB(31,31,20)
 2161 KPRINT FIX " C2;100;2/1  E2;100;2/1  G2;100;2/1",RGB(31,31,0)
 2162 KPRINT FIX " L2 v100 q2/1  C E G",RGB(31,31,20)
 2163 KPRINT " (上の2行の意味は同じです)":KPRINT ""
 2164 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 2165 GOSUB *FADEIN
 2166 A$=INPUT$(1)
 2167 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 2168 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_1_15
 2169 IF A$<>" "     THEN *M_TUTORIAL_1_16
 2170 EFFECT(ST),"C2;100;2/1  E2;100;2/1  G2;100;2/1"
 2171 GOSUB *KEYIN
 2172 VSYNC 2:PLAYSTOP ST
 2173 IF A$="0"      THEN *MAIN_MENU
 2174 IF A$=CHR$(13) THEN *M_TUTORIAL_1_15
 2175 IF A$<>" "     THEN *M_TUTORIAL_1_16
 2176 '-------------
 2177 *M_TUTORIAL_1_17
 2178 KPRINT (10,20,0,1,0)
 2179 KPRINT "音を鳴らしてみよう！            17/47",,,RGB(20,0,20)
 2180 KPRINT "･次に､";:KPRINT "ベンド･ホイール";,RGB(31,22,22):KPRINT "を紹介します｡"
 2181 KPRINT "･これは､キーボード楽器などの鍵盤の横 ":KPRINT " に付いている､円盤状のローラーをシミ "
 2182 KPRINT " ュレートする機能です｡":KPRINT "★ｺｰﾄﾞ入力はﾁｭｰﾄﾘｱﾙ7で紹介します｡",RGB(31,31,0):KPRINT ""
 2183 KPRINT " [";:KPRINT FIX "~";,RGB(31,31,20):KPRINT "[";:KPRINT FIX "V";,RGB(31,31,20):KPRINT "|";
 2184 KPRINT FIX "P";,RGB(31,31,20):KPRINT "][初期値]";:KPRINT FIX ";";,RGB(31,31,20):KPRINT "[目標値]";
 2185 KPRINT FIX ";";,RGB(31,31,20):KPRINT "[ベンド長]]":KPRINT "":KPRINT ""
 2186 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 2187 GOSUB *KEYIN
 2188 IF A$="0"      THEN *MAIN_MENU
 2189 IF A$=CHR$(13) THEN *M_TUTORIAL_1_16
 2190 IF A$<>" "     THEN *M_TUTORIAL_1_17
 2191 '-------------
 2192 *M_TUTORIAL_1_18
 2193 KPRINT (10,20,0,1,0)
 2194 KPRINT "音を鳴らしてみよう！            18/47",,,RGB(20,0,20)
 2195 KPRINT "･音名の後ろにベンド･ホイール記号｢";:KPRINT FIX "~";,RGB(31,31,20):KPRINT "｣を"
 2196 KPRINT " 付け､｢";:KPRINT "初期値";,RGB(31,22,22):KPRINT "｣､｢";:KPRINT "目標値";,RGB(31,22,22)
 2197 KPRINT "｣､｢";:KPRINT "ベンド長";,RGB(31,22,22):KPRINT "｣を ":KPRINT " 指定します｡"
 2198 KPRINT "･各パラメータの値は省略することができ"
 2199 KPRINT " ますが､区切り記号｢";:KPRINT FIX ";";,RGB(31,31,20):KPRINT "｣は省略できません｡"
 2200 KPRINT "･｢";:KPRINT "初期値";,RGB(31,22,22):KPRINT "｣｢";:KPRINT "目標値";,RGB(31,22,22)
 2201 KPRINT "｣の指定範囲は｢";:KPRINT "0";,RGB(22,22,0):KPRINT "～";:KPRINT "127";,RGB(22,22,0):KPRINT "｣"
 2202 KPRINT " で､｢";:KPRINT "初期値";,RGB(31,22,22):KPRINT "｣を省略した場合は､前回の  "
 2203 KPRINT " ｢";:KPRINT "目標値";,RGB(31,22,22):KPRINT "｣が設定されます｡｢";
 2204 KPRINT "目標値";,RGB(31,22,22):KPRINT "｣を省 "
 2205 KPRINT " 略した場合は､中間の｢";:KPRINT "64";,RGB(22,22,0):KPRINT "｣になります｡  "
 2206 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 2207 GOSUB *KEYIN
 2208 IF A$="0"      THEN *MAIN_MENU
 2209 IF A$=CHR$(13) THEN *M_TUTORIAL_1_17
 2210 IF A$<>" "     THEN *M_TUTORIAL_1_18
 2211 '-------------
 2212 *M_TUTORIAL_1_19
 2213 KPRINT (10,20,0,1,0)
 2214 KPRINT "音を鳴らしてみよう！            19/47",,,RGB(20,0,20)
 2215 KPRINT "･｢";:KPRINT "ベンド長";,RGB(31,22,22):KPRINT "｣は､ベンド･ホイールを動かす"
 2216 KPRINT " 時間を指定するもので､省略した場合は "
 2217 KPRINT " 音符の長さと同じ時間をかけて｢";:KPRINT "初期値";,RGB(31,22,22):KPRINT "｣"
 2218 KPRINT " から｢";:KPRINT "目標値";,RGB(31,22,22):KPRINT "｣までベンディングします｡ "
 2219 KPRINT " つまり､小さな値を指定する程､速く動か":KPRINT " している状態が表現できるわけです｡"
 2220 KPRINT FIX " @44 C1~0;127;",RGB(31,31,0)
 2221 KPRINT "(全音符の長さをかけて｢";:KPRINT "0";,RGB(22,22,0):KPRINT ":";:KPRINT "1ｵｸﾀｰﾌﾞ下";,RGB(31,22,22):KPRINT "｣か"
 2222 KPRINT " ら｢";:KPRINT "127";,RGB(22,22,0):KPRINT ":";:KPRINT "1ｵｸﾀｰﾌﾞ上";,RGB(31,22,22):KPRINT "｣までピッチ･ベンド)"
 2223 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 2224 GOSUB *FADEIN
 2225 A$=INPUT$(1)
 2226 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 2227 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_1_18
 2228 IF A$<>" "     THEN *M_TUTORIAL_1_19
 2229 EFFECT(ST),"@44 C1~0;127;"
 2230 GOSUB *KEYIN
 2231 VSYNC 2:PLAYSTOP ST
 2232 IF A$="0"      THEN *MAIN_MENU
 2233 IF A$=CHR$(13) THEN *M_TUTORIAL_1_18
 2234 IF A$<>" "     THEN *M_TUTORIAL_1_19
 2235 '-------------
 2236 *M_TUTORIAL_1_20
 2237 KPRINT (10,20,0,1,0)
 2238 KPRINT "音を鳴らしてみよう！            20/47",,,RGB(20,0,20)
 2239 KPRINT "･下の例は､3つの｢";:KPRINT FIX "C1";,RGB(31,31,20):KPRINT "｣(全音符)を連続して"
 2240 KPRINT " 鳴らしますが､最初の｢";:KPRINT FIX "C1";,RGB(31,31,20):KPRINT "｣で1オクターブ"
 2241 KPRINT " 上までピッチを変え､2番目の｢";:KPRINT FIX "C1";,RGB(31,31,20):KPRINT "｣では  "
 2242 KPRINT " ｢";:KPRINT "初期値";,RGB(31,22,22):KPRINT "｣が省略されているので1オクタ "
 2243 KPRINT " ーブ上がった位置から都合2オクターブ "
 2244 KPRINT " 下がり､3番目の｢";:KPRINT FIX "C1";,RGB(31,31,20):KPRINT "｣では両方のパラメー"
 2245 KPRINT " タが省略されているので､センター(";:KPRINT "64";,RGB(22,22,0):KPRINT ") ":KPRINT " に向けて戻って行きます｡"
 2246 KPRINT FIX "EFFECT 1,"+CHR$(&H22)+"@44 C1~0;127; C1~;0; C1~;;"+CHR$(&H22),RGB(31,31,0)
 2247 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 2248 GOSUB *FADEIN
 2249 A$=INPUT$(1)
 2250 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 2251 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_1_19
 2252 IF A$<>" "     THEN *M_TUTORIAL_1_20
 2253 EFFECT(ST),1,"@44 C1~0;127;  C1~;0;  C1~;;"
 2254 GOSUB *KEYIN
 2255 VSYNC 2:PLAYSTOP ST
 2256 IF A$="0"      THEN *MAIN_MENU
 2257 IF A$=CHR$(13) THEN *M_TUTORIAL_1_19
 2258 IF A$<>" "     THEN *M_TUTORIAL_1_20
 2259 '-------------
 2260 *M_TUTORIAL_1_21
 2261 KPRINT (10,20,0,1,0)
 2262 KPRINT "音を鳴らしてみよう！            21/47",,,RGB(20,0,20)
 2263 KPRINT "･ベンド･ホイールは､";:KPRINT "オート･ボリューム";,RGB(31,22,22):KPRINT "､"
 2264 KPRINT " または";:KPRINT "オート･パン";,RGB(31,22,22):KPRINT "に";:KPRINT "切り替える";,RGB(31,22,22)
 2265 KPRINT "ことが "
 2266 KPRINT " できます(同時には指定できません)｡"
 2267 KPRINT "･｢";:KPRINT FIX "~";,RGB(31,31,20):KPRINT "｣の直後に｢";:KPRINT FIX "V";,RGB(31,31,20)
 2268 KPRINT "｣または｢";:KPRINT FIX "P";,RGB(31,31,20):KPRINT "｣を指定します｡"
 2269 KPRINT "･下の例は､数値を同じくして3種類の指定":KPRINT " を順番に鳴らすものです｡"
 2270 KPRINT FIX " EFFECT 1,"+CHR$(&H22)+"@44 C1~  0;127;  C1~ ; 0;"+CHR$(&H22),RGB(31,31,0)
 2271 KPRINT FIX " EFFECT 1,"+CHR$(&H22)+"@44 C1~V80;127;  C1~V;80;"+CHR$(&H22),RGB(31,31,0)
 2272 KPRINT FIX " EFFECT 1,"+CHR$(&H22)+"@44 C1~P 0;127;  C1~P; 0;"+CHR$(&H22),RGB(31,31,0)
 2273 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 2274 GOSUB *FADEIN
 2275 A$=INPUT$(1)
 2276 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 2277 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_1_20
 2278 IF A$<>" "     THEN *M_TUTORIAL_1_21
 2279 EFFECT(ST),1,"@44 C1~ 0;127;  C1~ ;0; R~;; C1~V80;127;  C1~V;80; R~V;127; C1~P0;127;  C1~P;0;"
 2280 GOSUB *KEYIN
 2281 VSYNC 2:PLAYSTOP ST
 2282 IF A$="0"      THEN *MAIN_MENU
 2283 IF A$=CHR$(13) THEN *M_TUTORIAL_1_20
 2284 IF A$<>" "     THEN *M_TUTORIAL_1_21
 2285 '-------------
 2286 *M_TUTORIAL_1_22
 2287 KPRINT (10,20,0,1,0)
 2288 KPRINT "音を鳴らしてみよう！            22/47",,,RGB(20,0,20)
 2289 KPRINT "･いま鳴らした例は､文字列だけではなく､"
 2290 KPRINT " ｢";:KPRINT FIX "EFFECT 1,";,RGB(31,31,20):KPRINT "｣のように､ソング番号";:KPRINT "1";,RGB(22,22,0)
 2291 KPRINT "番を ":KPRINT " 使うように明記してありました｡":KPRINT "･ピッチ･ベンド処理はメモリを多く消費 "
 2292 KPRINT " するため､デフォルト状態で一番多くメ ":KPRINT " モリが確保されているソング番号1番を "
 2293 KPRINT " 使っています｡":KPRINT "･オート･ボリュームやオート･パンは､更":KPRINT " にメモリを消費します｡"
 2294 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 2295 GOSUB *KEYIN
 2296 IF A$="0"      THEN *MAIN_MENU
 2297 IF A$=CHR$(13) THEN *M_TUTORIAL_1_21
 2298 IF A$<>" "     THEN *M_TUTORIAL_1_22
 2299 '-------------
 2300 *M_TUTORIAL_1_23
 2301 KPRINT (10,20,0,1,0)
 2302 KPRINT "音を鳴らしてみよう！            23/47",,,RGB(20,0,20)
 2303 KPRINT "･";:KPRINT "音長指定コマンド";,RGB(31,22,22):KPRINT "｢";:KPRINT FIX "L";,RGB(31,31,20)
 2304 KPRINT "｣や､音名コマンドの"
 2305 KPRINT " 臨時音長指定";,RGB(31,22,22):KPRINT "には､";:KPRINT "ダイレクト･レングス",RGB(31,22,22)
 2306 KPRINT " という";:KPRINT "内部タイム･コード";,RGB(31,22,22):KPRINT "を記述するこ "
 2307 KPRINT " とができます(小文字の｢";:KPRINT FIX "l";,RGB(31,31,20):KPRINT "｣を付ける)｡  "
 2308 KPRINT "･また､ベンド･ホイールの｢";:KPRINT "ベンド長";,RGB(31,22,22):KPRINT "｣には"
 2309 KPRINT " ダイレクト･レングス指定のみ";,RGB(31,22,22):KPRINT "許されて":KPRINT " います｡"
 2310 KPRINT FIX "@44 C1  R Cl1920 R Ll240 C R C",RGB(31,31,0)
 2311 KPRINT "     ~ 同じ~~~~~    ^^^^8分音符に設定"
 2312 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 2313 GOSUB *FADEIN
 2314 A$=INPUT$(1)
 2315 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 2316 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_1_22
 2317 IF A$<>" "     THEN *M_TUTORIAL_1_23
 2318 EFFECT(ST),1,"@44 C1  R Cl1920 R Ll240 C R C"
 2319 GOSUB *KEYIN
 2320 VSYNC 2:PLAYSTOP ST
 2321 IF A$="0"      THEN *MAIN_MENU
 2322 IF A$=CHR$(13) THEN *M_TUTORIAL_1_22
 2323 IF A$<>" "     THEN *M_TUTORIAL_1_23
 2324 '-------------
 2325 *M_TUTORIAL_1_24
 2326 KPRINT (10,20,0,1,0)
 2327 KPRINT "音を鳴らしてみよう！            24/47",,,RGB(20,0,20)
 2328 KPRINT "･ダイレクト･レングスは､";:KPRINT "4分音符の分解",RGB(31,22,22)
 2329 KPRINT " 能を480";,RGB(31,22,22):KPRINT "として処理しています｡"
 2330 KPRINT "(半分の8分音符なら240､2分音符なら960)":KPRINT "･先のベンド･ホイールのサンプルで､"
 2331 KPRINT FIX " @44 C1~0;127;",RGB(31,31,20):KPRINT " と､ベンド長を省略したときは､"
 2332 KPRINT FIX " @44 C1~0;127;1920",RGB(31,31,20):KPRINT " のように､内部的には指定音長に相当す "
 2333 KPRINT " るダイレクト･レングスが設定されます｡"
 2334 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 2335 GOSUB *KEYIN
 2336 IF A$="0"      THEN *MAIN_MENU
 2337 IF A$=CHR$(13) THEN *M_TUTORIAL_1_23
 2338 IF A$<>" "     THEN *M_TUTORIAL_1_24
 2339 '-------------
 2340 *M_TUTORIAL_1_25
 2341 KPRINT (10,20,0,1,0)
 2342 KPRINT "音を鳴らしてみよう！            25/47",,,RGB(20,0,20)
 2343 KPRINT "･前後の音を繋げて長く演奏させるときは"
 2344 KPRINT " タイ記号";,RGB(31,22,22):KPRINT "｢";:KPRINT FIX "&";,RGB(31,31,20):KPRINT "｣を使います｡"
 2345 KPRINT "･タイで音を繋いだ場合､一番先頭の音名 ":KPRINT " だけが有効になります｡"
 2346 KPRINT FIX " @44 C1 & C1 & C1",RGB(31,31,0):KPRINT "･下のように指定しても上と同じです｡"
 2347 KPRINT FIX " @44 C1 & D1 & E1",RGB(31,31,20):KPRINT "        ~~~~~~~~~"
 2348 KPRINT "★注意事項詳細はマニュアルを参照｡    ",RGB(22,22,0)
 2349 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 2350 GOSUB *FADEIN
 2351 A$=INPUT$(1)
 2352 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 2353 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_1_24
 2354 IF A$<>" "     THEN *M_TUTORIAL_1_25
 2355 EFFECT(ST),1,"@44 C1 & C1 & C1"
 2356 GOSUB *KEYIN
 2357 VSYNC 2:PLAYSTOP ST
 2358 IF A$="0"      THEN *MAIN_MENU
 2359 IF A$=CHR$(13) THEN *M_TUTORIAL_1_24
 2360 IF A$<>" "     THEN *M_TUTORIAL_1_25
 2361 '-------------
 2362 *M_TUTORIAL_1_26
 2363 KPRINT (10,20,0,1,0)
 2364 KPRINT "音を鳴らしてみよう！            26/47",,,RGB(20,0,20)
 2365 KPRINT "･タイを使ってベンド･ホイールを指定す ":KPRINT " ると､長く鳴らしながら音符単位に変化 "
 2366 KPRINT " の割合を変えることができます｡       ":KPRINT FIX "@44 C1~64;70;&C2~;127;&C1~;80;&C2~;30;",RGB(31,31,0)
 2367 KPRINT "･長さ的には｢";:KPRINT FIX "C1";,RGB(31,31,20):KPRINT FIX "+";:KPRINT FIX "C2";,RGB(31,31,20)
 2368 KPRINT FIX "+";:KPRINT FIX "C1";,RGB(31,31,20):KPRINT FIX "+";:KPRINT FIX "C2";,RGB(31,31,20):KPRINT "｣なので､全音符"
 2369 KPRINT " 3つ分になりますが､ピッチ･ベンドの制 ":KPRINT " 御を音符の長さ単位に制御するため､細 "
 2370 KPRINT " かくわけて記述しています(ダイレクト":KPRINT " レングスで更に細かく指定することも可)"
 2371 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 2372 GOSUB *FADEIN
 2373 A$=INPUT$(1)
 2374 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 2375 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_1_25
 2376 IF A$<>" "     THEN *M_TUTORIAL_1_26
 2377 EFFECT(ST),1,"@44 C1~64;70;&C2~;127;&C1~;80;&C2~;30;"
 2378 GOSUB *KEYIN
 2379 VSYNC 2:PLAYSTOP ST
 2380 IF A$="0"      THEN *MAIN_MENU
 2381 IF A$=CHR$(13) THEN *M_TUTORIAL_1_25
 2382 IF A$<>" "     THEN *M_TUTORIAL_1_26
 2383 '-------------
 2384 *M_TUTORIAL_1_27
 2385 KPRINT (10,20,0,1,0)
 2386 KPRINT "音を鳴らしてみよう！            27/47",,,RGB(20,0,20)
 2387 KPRINT "･｢";:KPRINT FIX "C";,RGB(31,31,20):KPRINT "｣の音だけを使い､ピッチ･ベンドで音 ":KPRINT " 階を作ってみましょう｡"
 2388 KPRINT "･この例のように､擬似的に";:KPRINT "ポルタメント",RGB(31,22,22):KPRINT " を表現することも可能です｡"
 2389 KPRINT (10,105,0,-7,0),FIX "@44 L2 C4~;;  &C~;;  &C4~;75;&C~;75;&",RGB(31,31,0)
 2390 KPRINT FIX "       C4~;85;&C~;85;&C4~;91;&C~;91;&",RGB(31,31,0)
 2391 KPRINT FIX "   C4~;101;&C~;101;&C4~;112;&C~;112;&",RGB(31,31,0)
 2392 KPRINT FIX "   C4~;123;&C~;123;&C4~;127;&C~;127;",RGB(31,31,0)
 2393 KPRINT "":KPRINT "★ベンド･レンジ=12の場合､半音は｢5.33｣",RGB(31,22,22)
 2394 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 2395 GOSUB *FADEIN
 2396 A$=INPUT$(1)
 2397 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 2398 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_1_26
 2399 IF A$<>" "     THEN *M_TUTORIAL_1_27
 2400 EFFECT(ST),1,"@44 L2 C4~;; & C~;; & C4~;75; & C~;75; & C4~;85; & C~;85; & C4~;91; & C~;91; & C4~;101; & C~;101; & C4~;112; & C~;112; & C4~;123; & C~;123; & C4~;127; & C~;127;"
 2401 GOSUB *KEYIN
 2402 VSYNC 2:PLAYSTOP ST
 2403 IF A$="0"      THEN *MAIN_MENU
 2404 IF A$=CHR$(13) THEN *M_TUTORIAL_1_26
 2405 IF A$<>" "     THEN *M_TUTORIAL_1_27
 2406 '-------------
 2407 *M_TUTORIAL_1_28
 2408 KPRINT (10,20,0,1,0)
 2409 KPRINT "音を鳴らしてみよう！            28/47",,,RGB(20,0,20)
 2410 KPRINT "･擬似ポルタメントで､曲を演奏してみま ":KPRINT " しょう｡"
 2411 KPRINT (10,71,0,-7,0),FIX "@44 C16~;75;&C8.~;75;&C8~;91;&C4.~;91;",RGB(31,31,0)
 2412 KPRINT FIX "&C16~;101;&C8.~;101;&C8~;112;&C4~;112;",RGB(31,31,0)
 2413 KPRINT FIX "&C32~;123;&C16.~;123;",RGB(31,31,0):KPRINT FIX "&C16~;112;&C8.~;112;",RGB(31,31,0)
 2414 KPRINT FIX "&C8~;101;&C4.~;101;&C16~;85;&C8.~;85;",RGB(31,31,0):KPRINT FIX "&C8~;64;&C4~;64;",RGB(31,31,0)
 2415 KPRINT "":KPRINT "｢@44 D F2 G A4.B8 A G2 E C4.｣を演奏",RGB(31,22,22)
 2416 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 2417 GOSUB *FADEIN
 2418 A$=INPUT$(1)
 2419 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 2420 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_1_27
 2421 IF A$<>" "     THEN *M_TUTORIAL_1_28
 2422 EFFECT(ST),1,"@44 C16~;75; & C8.~;75; & C8~;91; & C4.~;91; & C16~;101; & C8.~;101; & C8~;112; & C4~;112; & C32~;123; & C16.~;123; & C16~;112; & C8.~;112; & C8~;101; & C4.~;101; & C16~;85; & C8.~;85; & C8~;64; & C4~;64;"
 2423 GOSUB *KEYIN
 2424 VSYNC 2:PLAYSTOP ST
 2425 IF A$="0"      THEN *MAIN_MENU
 2426 IF A$=CHR$(13) THEN *M_TUTORIAL_1_27
 2427 IF A$<>" "     THEN *M_TUTORIAL_1_28
 2428 '-------------
 2429 *M_TUTORIAL_1_29
 2430 KPRINT (10,20,0,1,0)
 2431 KPRINT "音を鳴らしてみよう！            29/47",,,RGB(20,0,20)
 2432 KPRINT "･切れ目無く演奏させるには";:KPRINT "スラー記号";,RGB(31,22,22):KPRINT "｢";
 2433 KPRINT FIX "_";,RGB(31,31,20):KPRINT "｣":KPRINT " を使います｡":KPRINT "･Gate / Delta指定は臨時で無視され､指"
 2434 KPRINT " 定された音長分 Key ON されます｡":KPRINT "･下の例は､Gate / Delta指定で8分の1に"
 2435 KPRINT " 設定し､スタッカートを表現しています":KPRINT " が､スラーで繋がれた音符は切れ目無く":KPRINT " 演奏します｡"
 2436 KPRINT FIX " @44 q8 C C D E F  R  C C_D E_F",RGB(31,31,0)
 2437 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 2438 GOSUB *FADEIN
 2439 A$=INPUT$(1)
 2440 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 2441 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_1_28
 2442 IF A$<>" "     THEN *M_TUTORIAL_1_29
 2443 EFFECT(ST),1,"@44 q8 C C D E F  R  C C_D E_F"
 2444 GOSUB *KEYIN
 2445 VSYNC 2:PLAYSTOP ST
 2446 IF A$="0"      THEN *MAIN_MENU
 2447 IF A$=CHR$(13) THEN *M_TUTORIAL_1_28
 2448 IF A$<>" "     THEN *M_TUTORIAL_1_29
 2449 '-------------
 2450 *M_TUTORIAL_1_30
 2451 KPRINT (10,20,0,1,0)
 2452 KPRINT "音を鳴らしてみよう！            30/47",,,RGB(20,0,20)
 2453 KPRINT "･次に､";:KPRINT "和音";,RGB(31,22,22):KPRINT "を演奏してみましょう｡"
 2454 KPRINT "･MSX版MMLでドミソを和音で鳴らすときは"
 2455 KPRINT FIX " PLAY "+CHR$(&H22)+"C"+CHR$(&H22)+", "+CHR$(&H22)+"E"+CHR$(&H22)+", "+CHR$(&H22)+"G"+CHR$(&H22),RGB(31,31,20)
 2456 KPRINT " のように､トラック(チャンネル)をわけ ":KPRINT " なければなりませんでした｡"
 2457 KPRINT "･本MMLでは､";:KPRINT "同一トラック内での和音";,RGB(31,22,22):KPRINT "を"
 2458 KPRINT " ｢";:KPRINT FIX "()";,RGB(31,31,20):KPRINT "｣で括って指定できます｡"
 2459 KPRINT FIX " @44 C E G (CEG)",RGB(31,31,0):KPRINT "           ~~~~~この部分は同時に鳴る｡"
 2460 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 2461 GOSUB *FADEIN
 2462 A$=INPUT$(1)
 2463 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 2464 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_1_29
 2465 IF A$<>" "     THEN *M_TUTORIAL_1_30
 2466 EFFECT(ST),1,"@44 C E G (CEG)"
 2467 GOSUB *KEYIN
 2468 VSYNC 2:PLAYSTOP ST
 2469 IF A$="0"      THEN *MAIN_MENU
 2470 IF A$=CHR$(13) THEN *M_TUTORIAL_1_29
 2471 IF A$<>" "     THEN *M_TUTORIAL_1_30
 2472 '-------------
 2473 *M_TUTORIAL_1_31
 2474 KPRINT (10,20,0,1,0)
 2475 KPRINT "音を鳴らしてみよう！            31/47",,,RGB(20,0,20)
 2476 KPRINT "･和音記号｢";:KPRINT FIX "()";,RGB(31,31,20):KPRINT "｣を使って､最大32和音まで ":KPRINT " 指定できます｡"
 2477 KPRINT "･音の長さや強さは､音符ごとに独立して":KPRINT " 指定できますが､次の音符へ移行するま"
 2478 KPRINT " での長さは､｢";:KPRINT FIX "()";,RGB(31,31,20):KPRINT "｣内の一番最後に指定し "
 2479 KPRINT " た音符の長さが有効になります｡":KPRINT FIX " @44 (C1 E2 G4) @35 CDEF",RGB(31,31,0)
 2480 KPRINT "            ~~この和音は4分音符の長さ"
 2481 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 2482 GOSUB *FADEIN
 2483 A$=INPUT$(1)
 2484 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 2485 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_1_30
 2486 IF A$<>" "     THEN *M_TUTORIAL_1_31
 2487 EFFECT(ST),1,"@44 (C1 E2 G4) @35 CDEF"
 2488 GOSUB *KEYIN
 2489 VSYNC 2:PLAYSTOP ST
 2490 IF A$="0"      THEN *MAIN_MENU
 2491 IF A$=CHR$(13) THEN *M_TUTORIAL_1_30
 2492 IF A$<>" "     THEN *M_TUTORIAL_1_31
 2493 '-------------
 2494 *M_TUTORIAL_1_32
 2495 KPRINT (10,20,0,1,0)
 2496 KPRINT "音を鳴らしてみよう！            32/47",,,RGB(20,0,20)
 2497 KPRINT "･異なる音色を和音で演奏することも可能":KPRINT " です｡":KPRINT "･この場合､和音の次の音符は､最後に指定"
 2498 KPRINT " した音色になります｡":KPRINT FIX " (@44C@35C)(@44D@35D)(@44E@35E)FGAB  ",RGB(31,31,0)
 2499 KPRINT "                          ~~~"
 2500 KPRINT "･上の例の場合､｢";:KPRINT FIX "FGAB";,RGB(31,31,20):KPRINT "｣は35番の音色で演 "
 2501 KPRINT " 奏されます｡":KPRINT ""
 2502 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 2503 GOSUB *FADEIN
 2504 A$=INPUT$(1)
 2505 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 2506 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_1_31
 2507 IF A$<>" "     THEN *M_TUTORIAL_1_32
 2508 EFFECT(ST),1,"(@44C@35C)(@44D@35D)(@44E@35E)FGAB"
 2509 GOSUB *KEYIN
 2510 VSYNC 2:PLAYSTOP ST
 2511 IF A$="0"      THEN *MAIN_MENU
 2512 IF A$=CHR$(13) THEN *M_TUTORIAL_1_31
 2513 IF A$<>" "     THEN *M_TUTORIAL_1_32
 2514 '-------------
 2515 *M_TUTORIAL_1_33
 2516 KPRINT (10,20,0,1,0)
 2517 KPRINT "音を鳴らしてみよう！            33/47",,,RGB(20,0,20)
 2518 KPRINT "･";:KPRINT "連符";,RGB(31,22,22):KPRINT "は連符記号｢";:KPRINT FIX "{}";,RGB(31,31,20)
 2519 KPRINT "｣で括って記述します｡":KPRINT "･連符数は､音長のダイレクト･レングスを"
 2520 KPRINT " 連符数で割ったとき､1未満にならなけら":KPRINT " ばいくつでも可能です｡"
 2521 KPRINT "･割り切れない数の連符でも､他のトラｯク":KPRINT " とタイミングがずれることはありません｡"
 2522 KPRINT "･下の例は､通常の4分音符の後､3つの3連 ":KPRINT " 符を4分音符の長さ演奏します｡"
 2523 KPRINT FIX " @44 C D E {CDE}4 {DEF}4 {EFG}4      ",RGB(31,31,0)
 2524 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 2525 GOSUB *FADEIN
 2526 A$=INPUT$(1)
 2527 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 2528 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_1_32
 2529 IF A$<>" "     THEN *M_TUTORIAL_1_33
 2530 EFFECT(ST),1,"@44 C D E {CDE}4 {DEF}4 {EFG}4"
 2531 GOSUB *KEYIN
 2532 VSYNC 2:PLAYSTOP ST
 2533 IF A$="0"      THEN *MAIN_MENU
 2534 IF A$=CHR$(13) THEN *M_TUTORIAL_1_32
 2535 IF A$<>" "     THEN *M_TUTORIAL_1_33
 2536 '-------------
 2537 *M_TUTORIAL_1_34
 2538 KPRINT (10,20,0,1,0)
 2539 KPRINT "音を鳴らしてみよう！            34/47",,,RGB(20,0,20)
 2540 KPRINT "･連符記号の中に和音記号を使ったり､ボ":KPRINT " リュームや音色変更など､トラック単位"
 2541 KPRINT " に有効なコマンドを記述することもでき":KPRINT " ます｡"
 2542 KPRINT "･下の例は､音色切り替えを含む｢和音の5":KPRINT " 連符｣を2分音符1つ分の長さで演奏しま":KPRINT " す｡"
 2543 KPRINT FIX " { @36(CE)(CG)(CE) @40(C>E)(C>G) }2",RGB(31,31,0)
 2544 KPRINT "★和音記号の中に連符は指定できません｡",RGB(31,22,22)
 2545 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 2546 GOSUB *FADEIN
 2547 A$=INPUT$(1)
 2548 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 2549 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_1_33
 2550 IF A$<>" "     THEN *M_TUTORIAL_1_34
 2551 EFFECT(ST),1,"{@36(CE)(CG)(CE) @40(C>E)(C>G)}2"
 2552 GOSUB *KEYIN
 2553 VSYNC 2:PLAYSTOP ST
 2554 IF A$="0"      THEN *MAIN_MENU
 2555 IF A$=CHR$(13) THEN *M_TUTORIAL_1_33
 2556 IF A$<>" "     THEN *M_TUTORIAL_1_34
 2557 '-------------
 2558 *M_TUTORIAL_1_35
 2559 KPRINT (10,20,0,1,0)
 2560 KPRINT "音を鳴らしてみよう！            35/47",,,RGB(20,0,20)
 2561 KPRINT "･";:KPRINT "トラック単位に音量を設定";,RGB(31,22,22):KPRINT "するには｢";
 2562 KPRINT FIX "V";,RGB(31,31,20):KPRINT "｣ "
 2563 KPRINT " または｢";:KPRINT FIX "@V";,RGB(31,31,20):KPRINT "｣コマンドを使います｡"
 2564 KPRINT "･｢";:KPRINT FIX "V";,RGB(31,31,20):KPRINT "｣コマンドは";:KPRINT "0";,RGB(22,22,0)
 2565 KPRINT "～";:KPRINT "15";,RGB(22,22,0):KPRINT "の";:KPRINT "16段階";,RGB(31,22,22):KPRINT "で､数値に "
 2566 KPRINT " よってほぼ同じ割合で変化します｡"
 2567 KPRINT "･｢";:KPRINT FIX "@V";,RGB(31,31,20):KPRINT "｣コマンドは";:KPRINT "0";,RGB(22,22,0)
 2568 KPRINT "～";:KPRINT "127";,RGB(22,22,0):KPRINT "の";:KPRINT "128段階";,RGB(31,22,22):KPRINT "で､変化"
 2569 KPRINT " の度合は";:KPRINT "デシベル";,RGB(31,22,22):KPRINT "です｡127の半分の音量"
 2570 KPRINT " にする場合は64ではありません｡       "
 2571 KPRINT "･｢";:KPRINT FIX "V";,RGB(31,31,20):KPRINT "｣と｢";:KPRINT FIX "@V";,RGB(31,31,20)
 2572 KPRINT "｣は､";:KPRINT "相互に影響";,RGB(31,22,22):KPRINT "を与えます｡   "
 2573 KPRINT FIX " @44 V15 C V10 C V5 C @V127 C @V90 C ",RGB(31,31,0)
 2574 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 2575 GOSUB *FADEIN
 2576 A$=INPUT$(1)
 2577 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 2578 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_1_34
 2579 IF A$<>" "     THEN *M_TUTORIAL_1_35
 2580 EFFECT(ST),1,"@44 V15 C V10 C V5 C @V127 C @V90 C"
 2581 GOSUB *KEYIN
 2582 VSYNC 2:PLAYSTOP ST
 2583 IF A$="0"      THEN *MAIN_MENU
 2584 IF A$=CHR$(13) THEN *M_TUTORIAL_1_34
 2585 IF A$<>" "     THEN *M_TUTORIAL_1_35
 2586 '-------------
 2587 *M_TUTORIAL_1_36
 2588 KPRINT (10,20,0,1,0)
 2589 KPRINT "音を鳴らしてみよう！            36/47",,,RGB(20,0,20)
 2590 KPRINT "･｢";:KPRINT FIX "V";,RGB(31,31,20):KPRINT "｣や｢";
 2591 KPRINT FIX "@V";,RGB(31,31,20):KPRINT "｣コマンドによって設定されて "
 2592 KPRINT " いる音量を､";:KPRINT "相対的に上げ下げ";,RGB(31,22,22):KPRINT "するには "
 2593 KPRINT " ｢";:KPRINT FIX "[";,RGB(31,31,20):KPRINT "｣､｢";
 2594 KPRINT FIX "]";,RGB(31,31,20):KPRINT "｣記号を使います(トラック単位)｡"
 2595 KPRINT "･指定する数値は｢";:KPRINT FIX "@V";,RGB(31,31,20):KPRINT "｣コマンドに対する相"
 2596 KPRINT " 対値ですが､実際には1を指定した場合は"
 2597 KPRINT " 2レベル変化します(";:KPRINT "指定した数値の2倍";,RGB(31,22,22):KPRINT ")｡"
 2598 KPRINT "･例えば｢";:KPRINT FIX "@V127 ]1";,RGB(31,31,20):KPRINT "｣を実行すると､音量は "
 2599 KPRINT " 125になります｡"
 2600 KPRINT FIX " @44 @V127 C ] C ] C ] C ] C ] C ] C ",RGB(31,31,0)
 2601 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 2602 GOSUB *FADEIN
 2603 A$=INPUT$(1)
 2604 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 2605 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_1_35
 2606 IF A$<>" "     THEN *M_TUTORIAL_1_36
 2607 EFFECT(ST),1,"@44 @V127 C ] C ] C ] C ] C ] C ] C"
 2608 GOSUB *KEYIN
 2609 VSYNC 2:PLAYSTOP ST
 2610 IF A$="0"      THEN *MAIN_MENU
 2611 IF A$=CHR$(13) THEN *M_TUTORIAL_1_35
 2612 IF A$<>" "     THEN *M_TUTORIAL_1_36
 2613 '-------------
 2614 *M_TUTORIAL_1_37
 2615 KPRINT (10,20,0,1,0)
 2616 KPRINT "音を鳴らしてみよう！            37/47",,,RGB(20,0,20)
 2617 KPRINT "･トラック単位に音の定位(";:KPRINT "パンポット";,RGB(31,22,22):KPRINT ")を"
 2618 KPRINT " 指定するときは｢";:KPRINT FIX "P";,RGB(31,31,20):KPRINT "｣コマンドを使います｡"
 2619 KPRINT "･";:KPRINT "0";,RGB(22,22,0):KPRINT "(左)～";:KPRINT "64";,RGB(22,22,0)
 2620 KPRINT "(センター)～";:KPRINT "127";,RGB(22,22,0):KPRINT "(右)の128段 ":KPRINT " 階で指定します｡"
 2621 KPRINT "･特に指定しない場合は､音色データに予 ":KPRINT " め設定されている定位情報(";:KPRINT "レイヤー･パ",RGB(31,22,22)
 2622 KPRINT " ン";,RGB(31,22,22):KPRINT ")に従います｡"
 2623 KPRINT "･";:KPRINT "再び音色設定すると元に戻ります";,RGB(31,22,22):KPRINT "｡"
 2624 KPRINT FIX " @31<C<AF P0>C<AF P127>C<AF @31>C<AF ",RGB(31,31,0)
 2625 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 2626 GOSUB *FADEIN
 2627 A$=INPUT$(1)
 2628 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 2629 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_1_36
 2630 IF A$<>" "     THEN *M_TUTORIAL_1_37
 2631 EFFECT(ST),1,"@31 V12 <C<AF P0>C<AF P127>C<AF @31>C<AF"
 2632 GOSUB *KEYIN
 2633 VSYNC 2:PLAYSTOP ST
 2634 IF A$="0"      THEN *MAIN_MENU
 2635 IF A$=CHR$(13) THEN *M_TUTORIAL_1_36
 2636 IF A$<>" "     THEN *M_TUTORIAL_1_37
 2637 '-------------
 2638 *M_TUTORIAL_1_38
 2639 KPRINT (10,20,0,1,0)
 2640 KPRINT "音を鳴らしてみよう！            38/47",,,RGB(20,0,20)
 2641 KPRINT "･今の例のように､音色の中には音名｢";:KPRINT FIX "CDE";,RGB(31,31,20):KPRINT "｣"
 2642 KPRINT " が変わると楽器やサンプリング音域が切":KPRINT " り替わるものがあります｡これを､本サウ"
 2643 KPRINT " ンドシステムでは";:KPRINT "レイヤー";,RGB(31,22,22):KPRINT "と呼びます｡ "
 2644 KPRINT "･例えば､STANDARDセットの31番(ドラム) ":KPRINT " に音色設定した場合は､音名によって､ま"
 2645 KPRINT " ったく異なる楽器の音が演奏されます｡ ":KPRINT FIX "@31 O2 C(CD)C(CD)>L16 CCCC<AAAAFFFF>>C",RGB(31,31,0)
 2646 KPRINT "~~~ドラム音色しか設定していない｡"
 2647 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 2648 GOSUB *FADEIN
 2649 A$=INPUT$(1)
 2650 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 2651 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_1_37
 2652 IF A$<>" "     THEN *M_TUTORIAL_1_38
 2653 EFFECT(ST),1,"@31 V12 O2 C(CD)C(CD)>L16 CCCC<AAAAFFFF>>C"
 2654 GOSUB *KEYIN
 2655 VSYNC 2:PLAYSTOP ST
 2656 IF A$="0"      THEN *MAIN_MENU
 2657 IF A$=CHR$(13) THEN *M_TUTORIAL_1_37
 2658 IF A$<>" "     THEN *M_TUTORIAL_1_38
 2659 '-------------
 2660 *M_TUTORIAL_1_39
 2661 KPRINT (10,20,0,1,0)
 2662 KPRINT "音を鳴らしてみよう！            39/47",,,RGB(20,0,20)
 2663 KPRINT "･";:KPRINT "調号コマンド";,RGB(31,22,22):KPRINT "｢";:KPRINT FIX "S";,RGB(31,31,20)
 2664 KPRINT "｣(";:KPRINT "ﾁｭｰﾄﾘｱﾙ ﾒﾆｭｰ2";,RGB(31,22,22):KPRINT ")を使う"
 2665 KPRINT " と､記述した音階から半音単位にずれる ":KPRINT " ため､ドラムのように音名が変わると楽 "
 2666 KPRINT " 器自体が変わってしまう音色では不都合":KPRINT " があります｡"
 2667 KPRINT "･｢";:KPRINT FIX "S";,RGB(31,31,20):KPRINT "｣コマンドの設定はトラック単位に変 "
 2668 KPRINT " えられますが､打楽器系の音色はノート "
 2669 KPRINT " 番号で音を指定できる｢";:KPRINT FIX "N";,RGB(31,31,20):KPRINT "｣コマンドを使 ":KPRINT " った方が便利です｡"
 2670 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 2671 GOSUB *KEYIN
 2672 IF A$="0"      THEN *MAIN_MENU
 2673 IF A$=CHR$(13) THEN *M_TUTORIAL_1_38
 2674 IF A$<>" "     THEN *M_TUTORIAL_1_39
 2675 '-------------
 2676 *M_TUTORIAL_1_40
 2677 KPRINT (10,20,0,1,0)
 2678 KPRINT "音を鳴らしてみよう！            40/47",,,RGB(20,0,20)
 2679 KPRINT "･先の例を｢";:KPRINT FIX "N";,RGB(31,31,20):KPRINT "｣コマンドで記述すると､下の"
 2680 KPRINT " 4行のようになります｡                "
 2681 KPRINT (10,71,0,-7,0),FIX " @31 N36 (N36 N38) N36 (N36 N38)",RGB(31,31,0):KPRINT FIX " L16 N48 N48 N48 N48",RGB(31,31,0)
 2682 KPRINT FIX "     N45 N45 N45 N45",RGB(31,31,0):KPRINT FIX "     N41 N41 N41 N41 N60",RGB(31,31,0)
 2683 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 2684 GOSUB *FADEIN
 2685 A$=INPUT$(1)
 2686 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 2687 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_1_39
 2688 IF A$<>" "     THEN *M_TUTORIAL_1_40
 2689 EFFECT(ST),1,"@31 V12 N36 (N36 N38) N36 (N36 N38) L16 N48 N48 N48 N48 N45 N45 N45 N45 N41 N41 N41 N41 N60"
 2690 GOSUB *KEYIN
 2691 VSYNC 2:PLAYSTOP ST
 2692 IF A$="0"      THEN *MAIN_MENU
 2693 IF A$=CHR$(13) THEN *M_TUTORIAL_1_39
 2694 IF A$<>" "     THEN *M_TUTORIAL_1_40
 2695 '-------------
 2696 *M_TUTORIAL_1_41
 2697 KPRINT (10,20,0,1,0)
 2698 KPRINT "音を鳴らしてみよう！            41/47",,,RGB(20,0,20)
 2699 KPRINT "･いくつかのドラム･セクションのサンプ":KPRINT " ルを聞いてみましょう｡":KPRINT ""
 2700 KPRINT "･";:KPRINT "STANDARDセット";,RGB(31,22,22):KPRINT "のドラム音色を使用｡":KPRINT ""
 2701 KPRINT "･このサンプルは､'";:KPRINT FIX "*DR1";,RGB(31,31,20):KPRINT "'というラベルで "
 2702 KPRINT " 本サンプル･プログラムに組み込まれて ":KPRINT " います｡":KPRINT "★演奏を止める場合は Space key",RGB(22,22,0)
 2703 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 2704 GOSUB *FADEIN
 2705 A$=INPUT$(1)
 2706 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 2707 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_1_40
 2708 IF A$<>" "     THEN *M_TUTORIAL_1_41
 2709 RESTORE *DR1
 2710 SETSONG
 2711 BGM
 2712 GOSUB *KEYIN
 2713 VSYNC 2:PLAYSTOP
 2714 IF A$="0"      THEN *MAIN_MENU
 2715 IF A$=CHR$(13) THEN *M_TUTORIAL_1_40
 2716 IF A$<>" "     THEN *M_TUTORIAL_1_41
 2717 '
 2718 *DR1 :'MML Programed by Naotsugu Honma
 2719 DATA SONG1
 2720 DATA #1,"@31        V12 R N38 R N38"
 2721 DATA #2,"@31        V12 N36 N36 N36 N36"
 2722 DATA #3,"@31 L8     V12 N46 N46 N46 N46 N46  N46 N46 N46"
 2723 DATA --------
 2724 DATA #1,"@31        R N38 R N38"
 2725 DATA #3,"@31 L8     N46 N46 N46 N46 N46 N46 N46 N46"
 2726 DATA #2,"@31        N36 N36 N36 N36"
 2727 DATA --------
 2728 DATA #1,"@31        R N38 R N38"
 2729 DATA #2,"@31        N36 N36 N36 N36"
 2730 DATA #3,"@31 L8     N46 N46 N46 N46 N46 N46 N46 N46"
 2731 DATA --------
 2732 DATA #1,"@31        R N38 R N38"
 2733 DATA #2,"@31        N36 N36 N36 N36"
 2734 DATA #3,"@31 L8     N46 N46 N46 N46 N46 N46 N46 N46"
 2735 DATA --------
 2736 DATA #1,"@31 L16    N38 N38 N38 N38N48 N48 N48 N48 N45 N45 N45 N45 N41 N41 N41 N41"
 2737 DATA #2,"@31        N36 N36 N36 N36"
 2738 DATA --------
 2739 DATA #1,"@31 L4 P64 N53 N53 N53 N53"
 2740 DATA #2,"@31        R N38 R N38"
 2741 DATA #3,"@31 L16 P0 N36 N36 N36 N36 N36 N36 N36 N36 N36 N36 N36 N36 N36 N36 N36 N36"
 2742 DATA ---------
 2743 DATA #1,"@31 L4 P64 N53 N53 N53 N53"
 2744 DATA #3,"@31 L16    N36 N36 N36 N36 N36 N36 N36 N36 N36 N36 N36 N36 N36 N36 N36 N36"
 2745 DATA #2,"@31        R N38 R N38"
 2746 DATA ---------
 2747 DATA #1,"@31 L4 P64 N53 N53 N53 N53"
 2748 DATA #2,"@31 L16    R R R R N38 R R R R N38 R R N38 R R R"
 2749 DATA #3,"@31 L16    N36 N36 N36 N36 N36 N36 N36 N36 N36 N36 N36 N36 N36 N36 N36 N36"
 2750 DATA ----------
 2751 DATA #1,"@31 L8 P64 N53 R N53 R N46 N46 R R"
 2752 DATA #2,"@31 L16    R N38 R R N38 R R R N38 R N38 R N38 N38 N38 N38"
 2753 DATA #3,"@31 L16    N36 N36 N36 N36 N36 N36 N36 N36 N36 N36 N36 N36 N36 N36 N36 N36"
 2754 DATA ENDSONG
 2755 '-------------
 2756 *M_TUTORIAL_1_42
 2757 KPRINT (10,20,0,1,0)
 2758 KPRINT "音を鳴らしてみよう！            42/47",,,RGB(20,0,20)
 2760 KPRINT "･";:KPRINT "ETHNICセット";,RGB(31,22,22):KPRINT "の音色を使用｡":KPRINT ""
 2761 KPRINT "･このサンプルは､'";:KPRINT FIX "*DR2";,RGB(31,31,20):KPRINT "'というラベルで "
 2762 KPRINT " 本サンプル･プログラムに組み込まれて ":KPRINT " います｡":KPRINT "★演奏を止める場合は Space key",RGB(22,22,0)
 2763 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 2764 GOSUB *FADEIN
 2765 A$=INPUT$(1)
 2766 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 2767 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOSUB *TONE_RESET:GOTO *M_TUTORIAL_1_41
 2768 IF A$<>" "     THEN *M_TUTORIAL_1_42
 2769 CLS:PRINT "Loading ETHNIC Set...":PLAYINIT "ETHNIC":CLS
 2770 RESTORE *DR2
 2771 SETSONG
 2772 BGM
 2773 GOSUB *KEYIN
 2774 VSYNC 2:PLAYSTOP
 2775 IF A$="0"      THEN *MAIN_MENU
 2776 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_1_41
 2777 IF A$<>" "     THEN *M_TUTORIAL_1_42
 2778 '
 2779 *DR2 :'MML Programed by Naotsugu Honma
 2780 DATA #1,"@10 V12 L32 RRN67N67N67"
 2781 DATA ----------
 2782 DATA #1,"@10 V12 L16    N69RRRN69RRRRN69RN67RN67RR"
 2783 DATA #2,"@10 V12        N98 N98 N98 N98"
 2784 DATA #3,"@10 V12 L12 P0 N47N47N47RN87"
 2785 DATA --------
 2786 DATA #1,"@10 L32    N67RRRRRN67RRRRRN67RRRRRN69RRRRRRRRRN67N67N67"
 2787 DATA #2,"@10        N98N98N98N98"
 2788 DATA #3,"@10 L8     RRRRRRN43R"
 2789 DATA ---------
 2790 DATA #1,"@10 L16    N69RRRN69RRRRN69RN67RN67RR"
 2791 DATA #2,"@10        N98 N98 N98 N98"
 2792 DATA #3,"@10 P127   N87N87 P0 N88N88"
 2793 DATA ---------
 2794 DATA #1,"@10 L16    N67N69N67N67N69N67N67N69RRRRN36RRR"
 2795 DATA #2,"@10        N98N98N98N98"
 2796 DATA #3,"@10 L16    N47RN47N47RN47N47RRRRRRRR"
 2797 DATA ENDSONG
 2798 '-------------
 2799 *M_TUTORIAL_1_43
 2800 KPRINT (10,20,0,1,0)
 2801 KPRINT "音を鳴らしてみよう！            43/47",,,RGB(20,0,20)
 2802 KPRINT "･";:KPRINT "METALセット";,RGB(31,22,22):KPRINT "の音色を使用｡"
 2803 KPRINT "":KPRINT "･このサンプルは､'";:KPRINT FIX "*DR3";,RGB(31,31,20):KPRINT "'というラベルで "
 2804 KPRINT " 本サンプル･プログラムに組み込まれて ":KPRINT " います｡":KPRINT "★演奏を止める場合は Space key",RGB(22,22,0)
 2805 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 2806 GOSUB *FADEIN
 2807 A$=INPUT$(1)
 2808 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 2809 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_1_42
 2810 IF A$<>" "     THEN *M_TUTORIAL_1_43
 2811 CLS:PRINT "Loading METAL Set...":PLAYINIT "METAL":CLS
 2812 RESTORE *DR3
 2813 SETSONG
 2814 BGM
 2815 GOSUB *KEYIN
 2816 VSYNC 2:PLAYSTOP
 2817 IF A$="0"      THEN *MAIN_MENU
 2818 IF A$=CHR$(13) THEN *M_TUTORIAL_1_42
 2819 IF A$<>" "     THEN *M_TUTORIAL_1_43
 2820 '
 2821 *DR3 :'MML Programed by Naotsugu Honma
 2822 DATA #1,"@5 L16 V12 N41N41N41N41N41N41N41N41N41N41N41N41N41N41N41N41"
 2823 DATA #2,"@5 L16 V12 N45N45N45N45N45N45N45N45N45N45N45N45N45N45N45N45"
 2824 DATA ----------
 2825 DATA #1,"   L16 V12 N36RRN36RN36RRN36N36RN36RN36RR"
 2826 DATA #2,"   L8  V12 N49N46N46N46N46N46N46N46"
 2827 DATA #3,"@5 L8  V12 N57N37RN37RN37RN37"
 2828 DATA ---------
 2829 DATA #1,"   L32 N36RN36RRRN36RRRN36RRRRRN36N36N36RN36RN36RN36RN36RN36RN36R"
 2830 DATA #2,"   L8  N46N46N46N46N46N46N46N46"
 2831 DATA #3,"   L8  RN37RN37RN37RN37"
 2832 DATA ---------
 2833 DATA #1,"   L16 N36RRN36RN36RRN36N36RN36RN36RR"
 2834 DATA #2,"   L8  N49N46N46N46N46N46N46N46"
 2835 DATA #3,"   L8  RN37RN37RN37RN37"
 2836 DATA ---------
 2837 DATA #1,"   L16 N36RRN36RN36RRN36N36RN36RN36RR"
 2838 DATA #2,"   L8  N46N46N46N46N46N46N46N46"
 2839 DATA #3,"   L8  RN37RN37RN37RN37"
 2840 DATA ----------
 2841 DATA #1,"   L32 N36RN36RRRN36RRRN36RRRRRN36N36N36RN36RN36RN36N36N36N36RRRR"
 2842 DATA #2,"   L8  N46N46N46N46N46N46N46N57"
 2843 DATA #3,"   L8  RN37RN37RN37RN37"
 2844 DATA ENDSONG
 2845 '-------------
 2846 *M_TUTORIAL_1_44
 2847 KPRINT (10,20,0,1,0)
 2848 KPRINT "音を鳴らしてみよう！            44/47",,,RGB(20,0,20)
 2849 KPRINT "･";:KPRINT "METALセット";,RGB(31,22,22):KPRINT "の音色を使用｡"
 2850 KPRINT " (";:KPRINT "Long Version";,RGB(22,22,0):KPRINT ")":KPRINT ""
 2851 KPRINT "･このサンプルは､'";:KPRINT FIX "*DR4";,RGB(31,31,20):KPRINT "'というラベルで "
 2852 KPRINT " 本サンプル･プログラムに組み込まれて ":KPRINT " います｡":KPRINT "★演奏を止める場合は Space key",RGB(22,22,0)
 2853 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 2854 GOSUB *FADEIN
 2855 A$=INPUT$(1)
 2856 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 2857 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_1_43
 2858 IF A$<>" "     THEN *M_TUTORIAL_1_44
 2859 CLS:PRINT "Loading METAL Set...":PLAYINIT "METAL":CLS
 2860 RESTORE *DR4:SETSONG
 2861 BGM
 2862 GOSUB *KEYIN
 2863 VSYNC 2:PLAYSTOP
 2864 IF A$="0"      THEN *MAIN_MENU
 2865 IF A$=CHR$(13) THEN *M_TUTORIAL_1_43
 2866 IF A$<>" "     THEN *M_TUTORIAL_1_44
 2868 '
 2869 *DR4 :'MML Programed by Naotsugu Honma
 2870 DATA #1,"@5 L16 V12 RN36RRN36RRN36RRN36RRRR"
 2871 DATA #2,"@5 L16 V12 N37RRN37RRN37RRN37RRN37N37N41N41"
 2872 DATA #3,"@5 L16 V12 RN57RRN49RRN57RRN49RRR"
 2873 DATA --------
 2874 DATA #1,"   L16 RN36RRN36RRN36RRN36RRRRR"
 2875 DATA #2,"   L16 N37RRN37RRN37RRN37RRN45N45N41N41"
 2876 DATA #3,"   L16 RN57RRN49RRN57RRN49RRRRR"
 2877 DATA ---------
 2878 DATA #1,"   L32 RRN36N36N36N36RRN36N36N36N36RRN36N36N36N36RRN36N36N36N36RRN36N36RRN36N36"
 2879 DATA #2,"   L16 N49RRN57RRN49RRN57RRN49RN57R"
 2880 DATA #3,"   L16 N37RRN37RRN37RRN37RRN37RN37R"
 2881 DATA --------
 2882 DATA #1,"   L32 RRN36N36N36N36RRN36N36N36N36RRN36N36N36N36RRN36N36N36N36RRN36N36RRN36N36"
 2883 DATA #2,"   L16 N52RRN53RRN52RRN53RRN52RN53R"
 2884 DATA #3,"   L16 N37RRN37RRN37RRN37RRN37RN37R"
 2885 DATA --------
 2886 DATA #2,"   L1  N37"
 2887 DATA #3,"   L4  N49 N46 N46 N46"
 2888 DATA --------
 2889 DATA #1,"   L8  RN36N36N36N36N36N36N36"
 2890 DATA #2,"   L8  N57N46N46N46N46N46N46N46"
 2891 DATA #3,"   L16 N37RRN37RN37RN37RN37RN37RN37RN37"
 2892 DATA --------
 2893 DATA #1,"   L8  N36N36N36N36N36N36N36N36"
 2894 DATA #2,"   L8  N46N46N46N46N46N46N46N46"
 2895 DATA #3,"   L16 RN37RN37RN37RN37RN37RN37RN37RN37"
 2896 DATA ---------
 2897 DATA #1,"   L8  N36N36N36N36N36N36N36N36"
 2898 DATA #2,"   L8  N46N46N46N46N46N46N46N46"
 2899 DATA #3,"   L16 RN37RN37RN37RN37RN37RN37RN37RN37"
 2900 DATA --------
 2901 DATA #1,"   L32 N36RRRN36RRRN36RRRN36RRRN36RRRN36RRRN36N36N36N53RRR"
 2902 DATA #2,"   L8  N46N46N46N46N46N4"
 2903 DATA #3,"   L16 RN37RN37RN37RN37RN37RN37RN37N37R"
 2904 DATA --------
 2905 DATA #1,"   L16 N36RRN36RRN36RRN36RRRRN36R"
 2906 DATA #2,"   L8  N45N41N38N45N41N38N45N46"
 2907 DATA #3,"   L16 RN37RRN37RRN37RRN37RN37N37RR"
 2908 DATA --------
 2909 DATA #1,"   L16 N36RRN36RRN36RRN36RRRRN36R"
 2910 DATA #2,"   L8  N45N41N38N45N41N38RR"
 2911 DATA #3,"   L16 RN37RRN37RRN37RRN37RN37N37N48N48"
 2912 DATA --------
 2913 DATA #1,"   L16 N36RRN36RRN36RRN36RRRRN36R"
 2914 DATA #2,"   L8  N45N41N38N45N41N38N45N46"
 2915 DATA #3,"   L16 RN37RRN37RRN37RRN37RN37N37RR"
 2916 DATA -------
 2917 DATA #1,"   L16 N36RN36N36RRN36N36N41RRN41RRRR"
 2918 DATA #2,"   L8  N45N41N37N45RRRR"
 2919 DATA #3,"   L16 RN48RRN48RRRN45RRN45RRRR"
 2920 DATA ---------
 2921 DATA #1,"   L16 N36RRN36RRN36RRN36RRRRN36R"
 2922 DATA #2,"   L8  N45N41N38N45N41N38N45N46"
 2923 DATA #3,"   L16 RN37RRN37RRN37RRN37RN37N37RR"
 2924 DATA ---------
 2925 DATA #1,"   L16 N36RRN36RRN36RRN36RRRRN36R"
 2926 DATA #2,"   L8  N45N41N38N45N41N38RR"
 2927 DATA #3,"   L16 RN37RRN37RRN37RRN37RN37N37N41N41"
 2928 DATA ---------
 2929 DATA #1,"   L16 N36RRN36RRN36RRN36RRRRN36R"
 2930 DATA #2,"   L8  N45N41N38N45N41N38RR"
 2931 DATA #3,"   L16 RN37RRN37RRN37RRN37RN37N37RR"
 2932 DATA ---------
 2933 DATA #1,"   L16 N36RN36N36RRN36N36N41RRN41RRRR"
 2934 DATA #2,"   L8  N45N41N37N45RRRR"
 2935 DATA #3,"   L16 RN36RRN36RRRN45RRN45RRRR"
 2936 DATA ------
 2937 DATA #1,"   L16 N36N36N36N36N36N36N36N36N36N36N36N36N36N36N36N36"
 2938 DATA #2,"   L8  N49N59N49N59N49N59N49R"
 2939 DATA #3,"   L16 N37RRRN37RRRN37RRRN37RN48N48"
 2940 DATA --------
 2941 DATA #1,"   L16 N36N36N36N36N36N36N36N36N36N36N36N36N36N36N36N36"
 2942 DATA #2,"   L8  N52N59N53N59N52N59N53R"
 2943 DATA #3,"   L16 N37RRRN37RRRN37RRRN37RN48N48"
 2944 DATA --------
 2945 DATA #1,"   L16 N36N36N36N36N36N36N36N36N36N36N36N36N36N36N36N36"
 2946 DATA #2,"   L8  N52N53N52N53N52N53N52R"
 2947 DATA #3,"   L16 N37RRRN37RRRN37RRRN37RN48N48"
 2948 DATA --------
 2949 DATA #1,"   L32 N37N37N36N36N48N48N36N36N45N45N36N36N41N41N36N36N41N41N36N36N36N36N36N36N38RRRRRRR"
 2950 DATA ENDSONG
 2951 '-------------
 2952 *M_TUTORIAL_1_45
 2953 KPRINT (10,20,0,1,0)
 2954 KPRINT "音を鳴らしてみよう！            45/47",,,RGB(20,0,20)
 2955 KPRINT "･";:KPRINT "ROCKセット";,RGB(31,22,22):KPRINT "の音色を使用｡":KPRINT ""
 2957 KPRINT "･このサンプルは､'";:KPRINT FIX "*DOGGY";,RGB(31,31,20):KPRINT "'というラベル "
 2958 KPRINT " で本サンプル･プログラムに組み込まれ ":KPRINT " ています｡":KPRINT "★演奏を止める場合は Space key",RGB(22,22,0)
 2959 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 2960 GOSUB *FADEIN
 2961 A$=INPUT$(1)
 2962 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 2963 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_1_44
 2964 IF A$<>" "     THEN *M_TUTORIAL_1_45
 2965 '
 2966 CLS:PRINT "Loading DSP / ROCK Set...":PLAYINIT "DSP","ROCK":CLS
 2967 RESTORE *DOGGY:SETSONG
 2968 DSP ON 18,ALL,0,4
 2969 VSYNC 60:BGM
 2970 GOSUB *KEYIN
 2971 VSYNC 2:PLAYSTOP
 2972 IF A$="0"      THEN *MAIN_MENU
 2973 IF A$=CHR$(13) THEN *M_TUTORIAL_1_44
 2974 IF A$<>" "     THEN *M_TUTORIAL_1_45
 2976 '
 2977 *DOGGY :'MML Programed by Kouji Yamada
 2978 DATA SONG1
 2979 DATA #0,T104 @18 V10
 2980 DATA #1,@18 V15 L8
 2981 DATA #2,@24 V13
 2982 DATA #3,@16 V11 L16 P50
 2983 DATA #6,@31 V13 L8 O2
 2984 DATA #7,@31 V14 L8 O2
 2985 DATA ---------
 2986 DATA #0,"O4q2 L16  AA    AR   $0  RRAA ARRR L4 R L16[5 AAAR RRAA AARR L4 RO4"
 2987 DATA #1,"O1   L8   A     R        AAq1G&Gq2/3GGFFRq1FL4EG"
 2988 DATA #2,O4    L8   R     R        L4 RRR L8RRR P10ARP90A
 2989 DATA #3,O4    L16  AA    AA       AAAA AAAA AAAA AAAA AAAA AAAA AAAA
 2990 DATA #6,"     L8   C     C        DCRCDL16D;60CL8CCDCRCDL16D;60(CD;50)"
 2991 DATA #7,"     L8   F+    A+       F+F+F+F+F+A+ F+A+F+F+F+A+F+L16F+A+"
 2992 DATA ---------
 2993 DATA #0,"$1L16  AA AR ds0 >RRA]10A AARR [6L4 R L16 AAAR RRAA AAAR L4 R ds1"
 2994 DATA #1,"O1L8 A  R   >   C<AG&Gq3/5GGFFq1L16FGFRL4E"
 2995 DATA #2,O4 L8 R  R       L4RRR L8RRR P10ARP90A
 2996 DATA #3,O4    AA AA      AAAA AAAAAAAA AAAAAAAA AAAAAAAA
 2997 DATA #6,"L8   C  C;65    DCRCDL16D;62CL8CCDCRCDL16D;60D;50"
 2998 DATA #7,"L8   F+ A+      F+F+F+F+F+A+ F+A+F+F+F+A+F+L16F+A+"
 2999 DATA ENDSONG
 3000 '-------------
 3001 *M_TUTORIAL_1_46
 3002 KPRINT (10,20,0,1,0)
 3003 KPRINT "音を鳴らしてみよう！            46/47",,,RGB(20,0,20)
 3004 KPRINT "･";:KPRINT "DANCEセット";,RGB(31,22,22):KPRINT "の音色を使用｡":KPRINT ""
 3006 KPRINT "･このサンプルは､'";:KPRINT FIX "*TECHY";,RGB(31,31,20):KPRINT "'というラベル "
 3007 KPRINT " で本サンプル･プログラムに組み込まれ ":KPRINT " ています｡":KPRINT "★演奏を止める場合は Space key",RGB(22,22,0)
 3008 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 3009 GOSUB *FADEIN
 3010 A$=INPUT$(1)
 3011 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 3012 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_1_45
 3013 IF A$<>" "     THEN *M_TUTORIAL_1_46
 3014 '
 3015 CLS:PRINT "Loading DSPEXT / DANCE Set...":PLAYINIT "DSPEXT","DANCE":CLS
 3016 RESTORE *TECHY:SETSONG
 3017 DSP ON 31,ALL,2,4
 3018 'DSP ON 31,1,2,2
 3019 DSP ON 1,ALL,0,6
 3020 'DSP OFF 1, ALL
 3021 DSP ON 16,ALL,0,4
 3022 DSP ON 20,ALL,0,7
 3023 DSP ON 2,ALL,1,7
 3024 DSP ON 19,ALL, 2,2
 3025 TPROP(19,ALL,0) = 3
 3026 EG 19,ALL,22,18,13,30,3
 3027 TPROP(5,ALL,33) = 2
 3028 DSP ON 5,ALL,0,7
 3029 EG 5,ALL,14,,,30
 3030 VSYNC 60:VOLUME 112:BGM
 3031 GOSUB *KEYIN
 3032 VSYNC 2:PLAYSTOP
 3033 IF A$="0"      THEN VOLUME 127:GOTO *MAIN_MENU
 3034 IF A$=CHR$(13) THEN VOLUME 127:GOTO *M_TUTORIAL_1_45
 3035 IF A$<>" "     THEN *M_TUTORIAL_1_46
 3037 VOLUME 127
 3038 *TECHY :'MML Programed by Kouji Yamada
 3039 DATA SONG1
 3040 DATA #0, "T140 el 4;5"
 3041 DATA #1, \C=\F#A#F#A#F#A#F#A#\ @31 V1 O2 L8
 3042 DATA #2, "O4@1%1L32V1CV2CV3CV4CV5CV6CV7CV8CV9CV10CV11CV12CV13CV14CV15C"
 3043 DATA #3, \A=\%0V14L16CRC;50RRRRRCRR%1RL32V1CV3CV5CV7CV9CV11CV10CV9C\
 3044 DATA #5, \B=\L8 A.AR16>Gl100~64;64;&Gl140~64;127;20 Rl0~64;64; <A.AR16>A<\
 3045 DATA #6, @20 V10 P60 
 3046 DATA #7, @16 V10 P70 %1 K2
 3047 DATA #8, @5 V15 L8 O3 RRRA
 3048 DATA -
 3049 DATA #0, "|: V2 @31 O2 L4 CCCL8CC |1 Rl0"
 3050 'DATA "O4L4V15q1/1P64@31O2RDRD"
 3051 'DATA #1, "L8 \C"
 3052 DATA #2, O4V14P64@1 \A
 3053 DATA #3, O3L4V15P64@2 RRAR
 3054 DATA #5, @19 V12 O1 
 3055 DATA #7, L8 CCR16C16C
 3056 DATA #8, L8 R4 RA 
 3057 DATA -
 3058 DATA #0, "L4 CCCL8CC  :|2 Rl0"
 3059 'DATA "O4L4V15q1/1P64@31O2RDRD"
 3060 'DATA #1, "L8 \C"
 3061 DATA #2, V14 \A
 3062 DATA #3, RRAR
 3063 DATA #7, CCR16C16C
 3064 DATA #8, L4 RRR L8RA
 3065 DATA -
 3066 DATA #0, "O2L4 RRRR "
 3067 'DATA #1, \C
 3068 DATA #2, V14 L4 CRR %1 L32V1CV3CV5CV7CV9CV11CV12CV11CV10CV9C
 3069 DATA #4, V4@31 O2 %1 ^L4 R Rl470 D32;70 L16 D32;80D32;90DRD DRDD
 3070 DATA #7, L8 CCR16C16C
 3071 DATA #8, L8 R4 R4Al300
 3072 DATA -
 3073 DATA #0, " dc $0 |: L4CCCL8CC "
 3074 DATA #1, "\C"
 3075 DATA #2, \A
 3076 'DATA #3, "RRAR"
 3077 DATA #4, "V2L4 RRDR"
 3078 DATA #5, \B
 3079 DATA #7, L8 V15 CCR16C16C
 3080 DATA #8, L8 R4 RA
 3081 DATA -
 3082 DATA #0, " L4CCCL8CC :| ds0 $3 |: L4CCCL8CC "
 3083 DATA #1, \C \C
 3084 DATA #2, \A ^\A
 3085 'DATA #3, "RRAR"
 3086 DATA #4, "V2L4 RRDR RRDR"
 3087 DATA #5, \B \B
 3088 DATA #6, L4 RRRR L16 O4 G?7 RR D? RR <G?7;3 R G?7 
 3089 DATA #7, L8 CCR16C16CRRC.C16 L8 V15 CCR16C16C
 3090 DATA #8, L8 R4 RA
 3091 DATA -
 3092 DATA #0, "L4CCCL8CC :| ds3 Rl0 dc"
 3093 DATA #1, \C
 3094 'DATA #2, \A
 3095 'DATA #3, "RRAR"
 3096 DATA #4, "V2L4 RRDR"
 3097 DATA #5, \B
 3098 DATA #6, L16 O4 G?7 RR D? RR <G?7;3 R G?7
 3099 DATA #7, L8 CCR16C16CRRL32 CV8CV9CV10CV11CV12CV13CV14C 
 3100 DATA #8, L8 R4 RA
 3101 DATA ENDSONG
 3102 '-------------
 3103 *M_TUTORIAL_1_47
 3104 KPRINT (10,20,0,1,0)
 3105 KPRINT "音を鳴らしてみよう！            47/47",,,RGB(20,0,20)
 3106 KPRINT "･";:KPRINT "TARG命令";,RGB(31,22,22):KPRINT "による組み替え音色｡":KPRINT ""
 3108 KPRINT "･このサンプルは､'";:KPRINT FIX "*BIGGY";,RGB(31,31,20):KPRINT "'というラベル "
 3109 KPRINT " で本サンプル･プログラムに組み込まれ ":KPRINT " ています｡":KPRINT "★演奏を止める場合は Space key",RGB(22,22,0)
 3110 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 3111 GOSUB *FADEIN
 3112 A$=INPUT$(1)
 3113 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 3114 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_1_46
 3115 IF A$<>" "     THEN *M_TUTORIAL_1_47
 3116 '
 3117 VOLUME 127
 3118 CLS:PRINT "Loading DSP...":PLAYINIT "DSP":CLS
 3119 RESTORE *BIGGY:SETSONG
 3120 CLS:PRINT "Loading ETHNIC/ROCK/DANCE/STANDARD Set":RESTORE *BIGGY_TONE:TARG READ:CLS
 3121 TPROP(1,ALL,23) = 15
 3122 'OPEN HH
 3123 TPROP(1,6,23) = 30
 3124 '
 3125 DSP OFF 2,ALL
 3126 DSP OFF 1,2
 3127 DSP ON 1,0,0,3
 3128 DSP ON 3,ALL,0,5
 3129 DSP ON 1,1,0,5
 3130 DSP ON 1,4,0,6
 3131 DSP ON 1,6,0,6
 3132 DSP ON 4,ALL,0,6
 3133 TPROP(2,ALL,0) = 24
 3134 '
 3135 VSYNC 60:BGM
 3136 GOSUB *KEYIN
 3137 VSYNC 2:PLAYSTOP
 3138 IF A$="0"      THEN *MAIN_MENU
 3139 IF A$=CHR$(13) THEN *M_TUTORIAL_1_46
 3140 IF A$<>" "     THEN *M_TUTORIAL_1_47
 3141 GOTO *M_TUTORIAL
 3142 '
 3143 *BIGGY :'MML Programed by Kouji Yamada
 3144  DATA SONG1
 3145  DATA #0, @1 V11 T96 
 3146  DATA #1, @2 V15 K-3
 3147  DATA #2, @1 V15 K1 L8 \C=\fC;127CCC;110 C;127CC;110C\ P50 %1
 3148  DATA #3, @1  V8 K1 P48 %1 \D=\R16 L8 CCCC CCCC16\
 3149  DATA #4, @1 V12 O2 K1 L8 \B=\FAFFFAFF16F16\
 3150  DATA #5, @3 V10 \A=\O4 L16 D;80 E;100 (CF#) (D<B)\ K-3
 3151  DATA #6, @4 V10 P20 K-3
 3152  DATA #7, @1 V10 L32 %1 P70
 3153  DATA -
 3154  DATA #5, \A
 3155  DATA #7, pppCppCpCmpCmfCfCffCfffC
 3156  DATA -
 3157  DATA #0, "dc |: O2 L8 CCD;;2RCCD"
 3158  DATA #1, O2 L8 >D<D L16 DD RR L8DR C L16 Bl110~64;64;&Bl130~64;98;10
 3159  DATA #2, \C
 3160  DATA #3, \D
 3161  DATA #4, \B
 3162  DATA #5, O4 L16 (DA) 
 3163  DATA #6, L16 O4 D? RR D;;2?sus4 RRR O3 D?;3
 3164  DATA #7, L8 C.C16;90 CC;80 R16 C16;80 CR C;80
 3165  DATA -
 3166  DATA #0, CCD.;;3C16;80CC;50D.C16 
 3167  DATA #1, L8 >D~64;64;<D L16 DDRRD8
 3168  DATA #2, \C
 3169  DATA #3, \D
 3170  DATA #4, \B
 3171  DATA #5, O4 L4 RRR \A
 3172  DATA #7, L8 C.C16;80 CC;80 R C16C16;70 R C
 3173  DATA -
 3174  DATA #0, "(CD#)CD;;3RCCD |1 Rl0 R Rl0"
 3175  DATA #1, O2 L8 >D<D L16 DD RR L8DR C L16 Bl110~64;64;&Bl130~64;98;10
 3176  DATA #2, \C
 3177  DATA #3, R16 L8 CCCC CCC16 R16 C16
 3178  DATA #4, \B
 3179  DATA #5, O4 L16 (DA) 
 3180  DATA #6, L16 O4 D? RR D;;2?sus4 RRR O3 D?;3
 3181  DATA #7, L8 C.C16;90 CC;80 R16 C16;80 CR C;80
 3182  DATA -
 3183  DATA #0, "CC(D.D#.)C16(CD#)C;50D.C16 :|2 Rl0"
 3184  DATA #1, L8 >D~64;64;<D L16 DDRD D8
 3185  DATA #2, \C
 3186  DATA #3, \D
 3187  DATA #4, \B
 3188  DATA #5, O4 L4 RRR \A
 3189  DATA #7, L8 C.C16;90 CC;80 R16 C16;80 CR C;80
 3190  DATA -
 3191  DATA #0, R8 
 3192  DATA #1, L16 Bl110~64;64;&Bl130~64;98;10
 3193  DATA #2, L16 Cl180Cl60 L8
 3194  DATA #3, R16 C16 L8
 3195  DATA #4, L16 Fl180Fl60
 3196  DATA #5, L16 Rl150 (Al90Cl90) q4 L8
 3197  DATA #6, L16 Rl150 Dl90?;3  q4 L8
 3198  DATA #7, L16 C
 3199  DATA -
 3200  DATA #0, (CD;;3)ff=110(CD;;3)f=100(CD;;3D#)(CD;;3)ff(CD;;3)(CD;;3)fff(CD;;3D#)(CD;;3) dc
 3201  DATA #1, L8 >D~64;64;<D L16 DDRD L8 >D~64;64;<q1D L16 DDRD 
 3202  DATA #2, Cff=110C f=100 CC ff CC fff CC
 3203  DATA #3, \D
 3204  DATA #4, \B
 3205  DATA #5, O4 (A>C)ff=110(A>C)f=100(A>C)(A>C)ff(A>C)(A>C)fff(A>C)q1(A>C) 
 3206  DATA #6, D?;3 ff=110D?;3 f=100D?;3 D?;3 ff D?;3 D?;3 fff D?;3 q1 D?;3
 3207  DATA #7, L8 C.C16;80 C.C16;80 C.C16;80 C.C16;80
 3208  DATA ENDSONG
 3209 '
 3210 *BIGGY_TONE
 3211  DATA BUILDLAYER
 3212   DATA "ETHNIC", 10,10,60,60,80
 3213   DATA "ROCK",   31,1,-1,-1,-1
 3214   DATA           31,0,-1,-1,-1
 3215   DATA           31,3,42,42,51
 3216   DATA           31,5,46,46,56
 3217   DATA "DANCE",  31,9,-1,-1,-1
 3218   DATA           31,10,61,61,76
 3219  DATA ENDLAYER
 3220 '
 3221  DATA "DANCE",   32
 3222  DATA "STANDARD",47
 3223  DATA            39
 3224  DATA ENDARRANGE
 3225 '--------------------------------------------------------------------------------------------------------
 3226 *M_TUTORIAL_2_1
 3227 KPRINT (10,20,0,1,0)
 3228 KPRINT "楽譜通りに打ち込んでみよう！     1/13",,,RGB(20,0,20)
 3229 KPRINT "･楽譜を見ると､";:KPRINT "ト音記号";,RGB(31,22,22):KPRINT "や";
 3230 KPRINT "ヘ音記号";,RGB(31,22,22):KPRINT "に続 "
 3231 KPRINT " き､";:KPRINT "シャープ";,RGB(31,22,22):KPRINT "｢";:KPRINT "♯";,RGB(22,22,0)
 3232 KPRINT "｣や";:KPRINT "フラット";,RGB(31,22,22):KPRINT "｢";:KPRINT "♭";,RGB(22,22,0):KPRINT "｣が1個～"
 3233 KPRINT " 7個の範囲で並んでいる曲があります｡  ":KPRINT "･このような楽譜を従来のMMLで入力する "
 3234 KPRINT " 時は､どの音が半音上がる(下がる)のか ":KPRINT " ということを気にしながら打ち込まなけ"
 3235 KPRINT " ればなりませんでした｡":KPRINT "":KPRINT ""
 3236 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 3237 GOSUB *KEYIN
 3238 IF A$="0"      THEN *MAIN_MENU
 3239 IF A$=CHR$(13) THEN *M_TUTORIAL
 3240 IF A$<>" "     THEN *M_TUTORIAL_2_1
 3241 '-------------
 3242 *M_TUTORIAL_2_2
 3243 KPRINT (10,20,0,1,0)
 3244 KPRINT "楽譜通りに打ち込んでみよう！     2/13",,,RGB(20,0,20)
 3245 KPRINT "･そうでなくても､シャープやフラットが "
 3246 KPRINT " 現れると､その";:KPRINT "有効範囲";,RGB(31,22,22):KPRINT "(小節内および､ "
 3247 KPRINT " 1オクターブ内という規則)があるために":KPRINT " きちんと打ち込んだつもりでも､音程が "
 3248 KPRINT " ずれてしまうことがありました｡":KPRINT "":KPRINT "":KPRINT "":KPRINT ""
 3249 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 3250 GOSUB *KEYIN
 3251 IF A$="0"      THEN *MAIN_MENU
 3252 IF A$=CHR$(13) THEN *M_TUTORIAL_2_1
 3253 IF A$<>" "     THEN *M_TUTORIAL_2_2
 3254 '-------------
 3255 *M_TUTORIAL_2_3
 3256 KPRINT (10,20,0,1,0)
 3257 KPRINT "楽譜通りに打ち込んでみよう！     3/13",,,RGB(20,0,20)
 3258 KPRINT "･以下のコマンドを使うことにより､楽譜 ":KPRINT " 通りに打ち込むことができます｡"
 3259 KPRINT "  調号コマンド";,RGB(31,22,22):KPRINT "｢";:KPRINT FIX "S";,RGB(31,31,20):KPRINT "｣､";:KPRINT "小節コマンド";,RGB(31,22,22):KPRINT "｢";:KPRINT FIX "|";,RGB(31,31,20):KPRINT "｣":KPRINT "  ループ(繰り返し)制御コマンド",RGB(31,22,22)
 3260 KPRINT "        ｢";:KPRINT FIX "dc";,RGB(31,31,20):KPRINT "､";:KPRINT FIX "$";,RGB(31,31,20)
 3261 KPRINT "､";:KPRINT FIX "ds";,RGB(31,31,20):KPRINT "､";:KPRINT FIX "*";,RGB(31,31,20):KPRINT "､";
 3262 KPRINT FIX "|:";,RGB(31,31,20):KPRINT "､";:KPRINT FIX ":|";,RGB(31,31,20):KPRINT "､";
 3263 KPRINT FIX ":|:";,RGB(31,31,20):KPRINT "､";:KPRINT FIX "|1";,RGB(31,31,20):KPRINT "､";
 3264 KPRINT FIX ":|2";,RGB(31,31,20):KPRINT "｣"
 3265 KPRINT "･ここで言う｢";:KPRINT "楽譜通り";,RGB(31,22,22):KPRINT "｣とは､調を意識し "
 3266 KPRINT " たり､臨時記号の有効範囲を気にしなく "
 3267 KPRINT " とも､";:KPRINT "見たままの譜面の形";,RGB(31,22,22):KPRINT "で入力できる ":KPRINT " ということです｡"
 3268 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 3269 GOSUB *KEYIN
 3270 IF A$="0"      THEN *MAIN_MENU
 3271 IF A$=CHR$(13) THEN *M_TUTORIAL_2_2
 3272 IF A$<>" "     THEN *M_TUTORIAL_2_3
 3273 '-------------
 3274 *M_TUTORIAL_2_4
 3275 KPRINT (10,20,0,1,0)
 3276 KPRINT "楽譜通りに打ち込んでみよう！     4/13",,,RGB(20,0,20)
 3277 KPRINT "･｢";:KPRINT FIX "S";,RGB(31,31,20):KPRINT "｣コマンドのパラメータには､楽譜の左"
 3278 KPRINT " 端に並んだシャープやフラットの数を与"
 3279 KPRINT " えます(";:KPRINT "-7";,RGB(22,22,0):KPRINT "～";:KPRINT "7";,RGB(22,22,0):KPRINT ")｡"
 3280 KPRINT "･例えば､";:KPRINT "シャープが2つ";,RGB(31,22,22):KPRINT "並んでいるときは"
 3281 KPRINT " ｢";:KPRINT FIX "S2";,RGB(31,31,20):KPRINT "｣､";:KPRINT "フラットが4つ";,RGB(31,22,22)
 3282 KPRINT "の場合は｢";:KPRINT FIX "S-4";,RGB(31,31,20):KPRINT "｣とい ":KPRINT " う具合になります｡"
 3283 KPRINT "･通常はMMLの先頭に記述しますが､途中で"
 3284 KPRINT " 転調";,RGB(31,22,22):KPRINT "している曲にも､もちろん対応して ":KPRINT " います｡"
 3285 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 3286 GOSUB *KEYIN
 3287 IF A$="0"      THEN *MAIN_MENU
 3288 IF A$=CHR$(13) THEN *M_TUTORIAL_2_3
 3289 IF A$<>" "     THEN *M_TUTORIAL_2_4
 3290 '-------------
 3291 *M_TUTORIAL_2_5
 3292 KPRINT (10,20,0,1,0)
 3293 KPRINT "楽譜通りに打ち込んでみよう！     5/13",,,RGB(20,0,20)
 3294 KPRINT "･｢";:KPRINT FIX "S";,RGB(31,31,20):KPRINT "｣を含んだ音を聞いてみましょう｡    "
 3295 KPRINT (10,54,0,-7,0),FIX " @44 L8 S0  CDEFGAB>C< S1  CDEFGAB>C<",RGB(31,31,0)
 3296 KPRINT FIX "        S2  CDEFGAB>C< S3  CDEFGAB>C<",RGB(31,31,0)
 3297 KPRINT FIX "        S4  CDEFGAB>C< S5  CDEFGAB>C<",RGB(31,31,0)
 3298 KPRINT FIX "        S6  CDEFGAB>C< S7  CDEFGAB>C<",RGB(31,31,0)
 3299 KPRINT FIX "        S0  CDEFGAB>C< S-1 CDEFGAB>C<",RGB(31,31,0)
 3300 KPRINT FIX "        S-2 CDEFGAB>C< S-3 CDEFGAB>C<",RGB(31,31,0)
 3301 KPRINT FIX "        S-4 CDEFGAB>C< S-5 CDEFGAB>C<",RGB(31,31,0)
 3302 KPRINT FIX "        S-6 CDEFGAB>C< S-7 CDEFGAB>C ",RGB(31,31,0)
 3303 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 3304 GOSUB *FADEIN
 3305 A$=INPUT$(1)
 3306 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 3307 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_2_4
 3308 IF A$<>" "     THEN *M_TUTORIAL_2_5
 3309 EFFECT(ST),1,"@44L8S0CDEFGAB>C<S1CDEFGAB>C<S2CDEFGAB>C<S3CDEFGAB>C<S4CDEFGAB>C<S5CDEFGAB>C<S6CDEFGAB>C<S7CDEFGAB>C<S0CDEFGAB>C<S-1CDEFGAB>C<S-2CDEFGAB>C<S-3CDEFGAB>C<S-4CDEFGAB>C<S-5CDEFGAB>C<S-6CDEFGAB>C<S-7CDEFGAB>C"
 3310 GOSUB *KEYIN
 3311 VSYNC 2:PLAYSTOP ST
 3312 IF A$="0"      THEN *MAIN_MENU
 3313 IF A$=CHR$(13) THEN *M_TUTORIAL_2_4
 3314 IF A$<>" "     THEN *M_TUTORIAL_2_5
 3315 '-------------
 3316 *M_TUTORIAL_2_6
 3317 KPRINT (10,20,0,1,0)
 3318 KPRINT "楽譜通りに打ち込んでみよう！     6/13",,,RGB(20,0,20)
 3319 KPRINT "･｢";:KPRINT FIX "S";,RGB(31,31,20):KPRINT "｣コマンドを使わない場合の｢";
 3320 KPRINT FIX "#+-";,RGB(31,31,20):KPRINT "｣は､ ":
 3321 KPRINT " その音符にだけ作用し､";:KPRINT "小節コマンド";,RGB(31,22,22):KPRINT "｢";
 3322 KPRINT FIX "|";,RGB(31,31,20):KPRINT "｣"
 3323 KPRINT " や､｢";:KPRINT FIX "n";,RGB(31,31,20):KPRINT "｣(";:KPRINT "ﾅﾁｭﾗﾙ";,RGB(31,22,22)
 3324 KPRINT ")は意味を持ちません｡":KPRINT FIX " @35 CCCC|CCnCC|CCCC|D#DDD&|DDDD",RGB(31,31,0)
 3325 KPRINT "           ~~        ~~":KPRINT "           ↑        ↑":KPRINT "   意味を持たない｡  この音符のみ有効｡"
 3326 KPRINT "":KPRINT ""
 3327 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 3328 GOSUB *FADEIN
 3329 A$=INPUT$(1)
 3330 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 3331 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_2_5
 3332 IF A$<>" "     THEN *M_TUTORIAL_2_6
 3333 EFFECT(ST),1,"@35 CCCC|CCnCC|CCCC|D#DDD&|DDDD"
 3334 GOSUB *KEYIN
 3335 VSYNC 2:PLAYSTOP ST
 3336 IF A$="0"      THEN *MAIN_MENU
 3337 IF A$=CHR$(13) THEN *M_TUTORIAL_2_5
 3338 IF A$<>" "     THEN *M_TUTORIAL_2_6
 3339 '-------------
 3340 *M_TUTORIAL_2_7
 3341 KPRINT (10,20,0,1,0)
 3342 KPRINT "楽譜通りに打ち込んでみよう！     7/13",,,RGB(20,0,20)
 3343 KPRINT "･｢";:KPRINT FIX "S";,RGB(31,31,20):KPRINT "｣コマンドを使った場合は";:KPRINT "楽典モード",RGB(31,22,22)
 3344 KPRINT " に切り替わり､｢";:KPRINT FIX "#+-";,RGB(31,31,20):KPRINT "｣は本来の";
 3345 KPRINT "臨時記号";,RGB(31,22,22):KPRINT "と":KPRINT " して働きます｡"
 3346 KPRINT "･";:KPRINT "小節コマンド";,RGB(31,22,22):KPRINT "｢";:KPRINT FIX "|";,RGB(31,31,20)
 3347 KPRINT "｣は､";:KPRINT "臨時記号の有効範囲",RGB(31,22,22):KPRINT " を明確にするために用います｡"
 3348 KPRINT "･｢";:KPRINT FIX "n";,RGB(31,31,20):KPRINT "｣(";:KPRINT "ﾅﾁｭﾗﾙ";,RGB(31,22,22):KPRINT ")も有効になります｡"
 3349 KPRINT FIX " S2 @35 CCCC|CCnCC|CCCC|D#DDD&|DDDD  ",RGB(31,31,0):KPRINT "              ~~~~      ~~~~~~~~"
 3350 KPRINT "(臨時記号は下線部分の範囲が有効になる)"
 3351 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 3352 GOSUB *FADEIN
 3353 A$=INPUT$(1)
 3354 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 3355 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_2_6
 3356 IF A$<>" "     THEN *M_TUTORIAL_2_7
 3357 EFFECT(ST),1,"S2 @35 CCCC|CCnCC|CCCC|D#DDD&|DDDD"
 3358 GOSUB *KEYIN
 3359 VSYNC 2:PLAYSTOP ST
 3360 IF A$="0"      THEN *MAIN_MENU
 3361 IF A$=CHR$(13) THEN *M_TUTORIAL_2_6
 3362 IF A$<>" "     THEN *M_TUTORIAL_2_7
 3363 '-------------
 3364 *M_TUTORIAL_2_8
 3365 KPRINT (10,20,0,1,0)
 3366 KPRINT "楽譜通りに打ち込んでみよう！     8/13",,,RGB(20,0,20)
 3367 KPRINT "･";:KPRINT "ダカーポ";,RGB(31,22,22):KPRINT "｢";:KPRINT FIX "dc";,RGB(31,31,20)
 3368 KPRINT "｣は､本来曲の先頭に戻って "
 3369 KPRINT " 繰り返す記号ですが､本MMLでは2つの｢";:KPRINT FIX "dc";,RGB(31,31,20):KPRINT "｣"
 3370 KPRINT " で囲まれた部分を";:KPRINT "無限に繰り返す";,RGB(31,22,22):KPRINT "ように":KPRINT " なっています(ゲームのBGM用)｡"
 3371 KPRINT FIX " @44 C D E F dc G A B dc",RGB(31,31,0):KPRINT "     ~~~~~~~A   ~~~~~B":KPRINT " 演奏順序 → A B B B B B…"
 3372 KPRINT "":KPRINT "★演奏を止める場合は Space key",RGB(22,22,0)
 3373 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 3374 GOSUB *FADEIN
 3375 A$=INPUT$(1)
 3376 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 3377 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_2_7
 3378 IF A$<>" "     THEN *M_TUTORIAL_2_8
 3379 EFFECT(ST),1,"@44 C D E F dc G A B dc"
 3380 GOSUB *KEYIN
 3381 VSYNC 2:PLAYSTOP ST
 3382 IF A$="0"      THEN *MAIN_MENU
 3383 IF A$=CHR$(13) THEN *M_TUTORIAL_2_7
 3384 IF A$<>" "     THEN *M_TUTORIAL_2_8
 3385 '-------------
 3386 *M_TUTORIAL_2_9
 3387 KPRINT (10,20,0,1,0)
 3388 KPRINT "楽譜通りに打ち込んでみよう！     9/13",,,RGB(20,0,20)
 3389 KPRINT "･";:KPRINT "セーニョ";,RGB(31,22,22):KPRINT "｢";:KPRINT FIX "$";,RGB(31,31,20)
 3390 KPRINT "｣は､";:KPRINT "ダルセーニョ";,RGB(31,22,22):KPRINT "｢";:KPRINT FIX "ds";,RGB(31,31,20):KPRINT "｣からの"
 3391 KPRINT " 戻り先を指定するものです(対で使用)｡":KPRINT FIX " @44 C D E $ F G A B ds >C",RGB(31,31,0)
 3392 KPRINT "     ~~~~~A  ~~~~~~~B   ~~C":KPRINT " 演奏順序 → A B B C":KPRINT ""
 3393 KPRINT "★反復記号はベース･トラック(用語説明 ",RGB(22,22,0):KPRINT "  参照)以外には 記述できません｡",RGB(22,22,0)
 3394 KPRINT ""
 3395 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 3396 GOSUB *FADEIN
 3397 A$=INPUT$(1)
 3398 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 3399 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_2_8
 3400 IF A$<>" "     THEN *M_TUTORIAL_2_9
 3401 EFFECT(ST),1,"@44 C D E $ F G A B ds >C"
 3402 GOSUB *KEYIN
 3403 VSYNC 2:PLAYSTOP ST
 3404 IF A$="0"      THEN *MAIN_MENU
 3405 IF A$=CHR$(13) THEN *M_TUTORIAL_2_8
 3406 IF A$<>" "     THEN *M_TUTORIAL_2_9
 3407 '-------------
 3408 *M_TUTORIAL_2_10
 3409 KPRINT (10,20,0,1,0)
 3410 KPRINT "楽譜通りに打ち込んでみよう！    10/13",,,RGB(20,0,20)
 3411 KPRINT "･通常は､";:KPRINT "コーダ記号";,RGB(31,22,22):KPRINT "｢";:KPRINT FIX "*";,RGB(31,31,20)
 3412 KPRINT "｣も含めて､";:KPRINT "記譜上",RGB(31,22,22)
 3413 KPRINT " の問題から省略されている楽譜";,RGB(31,22,22):KPRINT "を入力す":KPRINT " るために用います｡"
 3414 KPRINT FIX " @44 C D E $ F G * A B ds >C",RGB(31,31,0):KPRINT "     ~~~~~A  ~~~B  ~~~C   ~~D"
 3415 KPRINT " 演奏順序 → A B C B D":KPRINT "･";:KPRINT "コーダ記号";,RGB(31,22,22):KPRINT "｢";:KPRINT FIX "*";,RGB(31,31,20)
 3416 KPRINT "｣は､反復している場所から":KPRINT " 抜け出し､｢";:KPRINT FIX "ds";,RGB(31,31,20):KPRINT "｣の次のMMLまでスキップし"
 3417 KPRINT " ます｡"
 3418 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 3419 GOSUB *FADEIN
 3420 A$=INPUT$(1)
 3421 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 3422 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_2_9
 3423 IF A$<>" "     THEN *M_TUTORIAL_2_10
 3424 EFFECT(ST),1,"@44 C D E $ F G * A B ds >C"
 3425 GOSUB *KEYIN
 3426 VSYNC 2:PLAYSTOP ST
 3427 IF A$="0"      THEN *MAIN_MENU
 3428 IF A$=CHR$(13) THEN *M_TUTORIAL_2_9
 3429 IF A$<>" "     THEN *M_TUTORIAL_2_10
 3430 '-------------
 3431 *M_TUTORIAL_2_11
 3432 KPRINT (10,20,0,1,0)
 3433 KPRINT "楽譜通りに打ち込んでみよう！    11/13",,,RGB(20,0,20)
 3434 KPRINT "･";:KPRINT "反復記号";,RGB(31,22,22):KPRINT "が複数存在する場合は";
 3435 KPRINT "ラベル";,RGB(31,22,22):KPRINT "を":KPRINT " つけて､対になっているコマンドを明確 ":KPRINT " にします｡"
 3436 KPRINT FIX " @44 C $1;2 D *2 E ds1 F G A ds2 B>C",RGB(31,31,0):KPRINT "     ~A     ~B   ~C    ~~~~~D    ~~~E"
 3437 KPRINT " 演奏順序 → A B C B C D B E":KPRINT ""
 3438 KPRINT "･ラベルは";:KPRINT "0";,RGB(22,22,0):KPRINT "～";:KPRINT "7";,RGB(22,22,0):KPRINT "の整数です｡(同一箇所に複"
 3439 KPRINT " 数存在する場合は｢";:KPRINT FIX "$1 $2";,RGB(31,31,20):KPRINT "｣または｢";
 3440 KPRINT FIX "$1;2";,RGB(31,31,20):KPRINT "｣)"
 3441 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 3442 GOSUB *FADEIN
 3443 A$=INPUT$(1)
 3444 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 3445 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_2_10
 3446 IF A$<>" "     THEN *M_TUTORIAL_2_11
 3447 EFFECT(ST),1,"@44 C $1;2 D *2 E ds1 F G A ds2 B>C"
 3448 GOSUB *KEYIN
 3449 VSYNC 2:PLAYSTOP ST
 3450 IF A$="0"      THEN *MAIN_MENU
 3451 IF A$=CHR$(13) THEN *M_TUTORIAL_2_10
 3452 IF A$<>" "     THEN *M_TUTORIAL_2_11
 3453 '-------------
 3454 *M_TUTORIAL_2_12
 3455 KPRINT (10,20,0,1,0)
 3456 KPRINT "楽譜通りに打ち込んでみよう！    12/13",,,RGB(20,0,20)
 3457 KPRINT "･";:KPRINT "反復記号";,RGB(31,22,22):KPRINT "｢";:KPRINT FIX "|:";,RGB(31,31,20)
 3458 KPRINT "､";:KPRINT FIX ":|";,RGB(31,31,20):KPRINT "｣は､";:KPRINT "一度だけ反復";,RGB(31,22,22):KPRINT "してい"
 3459 KPRINT " ることを表わしています｡":KPRINT FIX " @44 CDE |: FGA :| B>C",RGB(31,31,0):KPRINT "     ~~~A   ~~~B   ~~~C"
 3460 KPRINT " 演奏順序 → A B B C":KPRINT "":KPRINT "":KPRINT "":KPRINT ""
 3461 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 3462 GOSUB *FADEIN
 3463 A$=INPUT$(1)
 3464 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 3465 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_2_11
 3466 IF A$<>" "     THEN *M_TUTORIAL_2_12
 3467 EFFECT(ST),1,"@44 CDE |: FGA :| B>C"
 3468 GOSUB *KEYIN
 3469 VSYNC 2:PLAYSTOP ST
 3470 IF A$="0"      THEN *MAIN_MENU
 3471 IF A$=CHR$(13) THEN *M_TUTORIAL_2_11
 3472 IF A$<>" "     THEN *M_TUTORIAL_2_12
 3473 '-------------
 3474 *M_TUTORIAL_2_13
 3475 KPRINT (10,20,0,1,0)
 3476 KPRINT "楽譜通りに打ち込んでみよう！    13/13",,,RGB(20,0,20)
 3477 KPRINT "･他にも様々な反復記号が用意されていま":KPRINT " す｡"
 3478 KPRINT FIX "@44 CD:|:EF:|:GA |1 GFEDC :|2 B>C",RGB(31,31,0):KPRINT "    ~~A  ~~B  ~~C   ~~~~~D    ~~~E"
 3479 KPRINT " 演奏順序 → A A B B C D C E":KPRINT "":KPRINT "":KPRINT "":KPRINT ""
 3480 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 3481 GOSUB *FADEIN
 3482 A$=INPUT$(1)
 3483 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 3484 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_2_12
 3485 IF A$<>" "     THEN *M_TUTORIAL_2_13
 3486 EFFECT(ST),1,"@44 CD:|:EF:|:GA |1 GFEDC :|2 B>C"
 3487 GOSUB *KEYIN
 3488 VSYNC 2:PLAYSTOP ST
 3489 IF A$="0"      THEN *MAIN_MENU
 3490 IF A$=CHR$(13) THEN *M_TUTORIAL_2_12
 3491 IF A$<>" "     THEN *M_TUTORIAL_2_13
 3492 '-------------
 3493 GOTO *M_TUTORIAL
 3494 '--------------------------------------------------------------------------------------------------------
 3495 *M_TUTORIAL_3_1
 3496 KPRINT (10,20,0,1,0)
 3497 KPRINT "音色を組み替えてみよう！         1/17",,,RGB(20,0,20)
 3498 KPRINT "･音色アレンジ命令｢";:KPRINT "TARG";,RGB(22,22,31):KPRINT "｣を使って､";:KPRINT "16種",RGB(31,22,22)
 3499 KPRINT " の音色データ･ファイルの中から､必要な"
 3500 KPRINT " 音色を取り出して";:KPRINT "再構築";,RGB(31,22,22):KPRINT "することができ":KPRINT " ます｡"
 3501 KPRINT "･";:KPRINT "TARG";,RGB(22,22,31):KPRINT "命令は";:KPRINT "ファイル･バッファ";,RGB(31,22,22):KPRINT "を使うた "
 3502 KPRINT " め､予め";:KPRINT "CLEAR";,RGB(22,22,31):KPRINT "命令でブロックを確保しな"
 3503 KPRINT " ければなりません(";:KPRINT "1360ブロック必要";,RGB(31,22,22):KPRINT ")｡ "
 3504 KPRINT FIX " CLEAR ,1360",RGB(31,31,20):KPRINT "        ~~~~1360ブロックを確保"
 3505 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 3506 GOSUB *KEYIN
 3507 IF A$="0"      THEN *MAIN_MENU
 3508 IF A$=CHR$(13) THEN *M_TUTORIAL
 3509 IF A$<>" "     THEN *M_TUTORIAL_3_1
 3510 '-------------
 3511 *M_TUTORIAL_3_2
 3512 KPRINT (10,20,0,1,0)
 3513 KPRINT "音色を組み替えてみよう！         2/17",,,RGB(20,0,20)
 3514 KPRINT "･";:KPRINT "TARG";,RGB(22,22,31):KPRINT "命令は､";:KPRINT "コマンド･ライン";,RGB(31,22,22):KPRINT "にパラメー"
 3515 KPRINT " タを記述する方法と､";:KPRINT "DATA";,RGB(22,22,31):KPRINT "文から読み込 "
 3516 KPRINT " む方法の二種類の使い方があります｡":KPRINT ""
 3517 KPRINT "･まず､";:KPRINT "コマンド･ライン";,RGB(31,22,22):KPRINT "に記述する方法を":KPRINT " テストしてみましょう｡"
 3518 KPRINT "":KPRINT "":KPRINT ""
 3519 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 3520 GOSUB *KEYIN
 3521 IF A$="0"      THEN *MAIN_MENU
 3522 IF A$=CHR$(13) THEN *M_TUTORIAL_3_1
 3523 IF A$<>" "     THEN *M_TUTORIAL_3_2
 3524 '-------------
 3525 *M_TUTORIAL_3_3
 3526 KPRINT (10,20,0,1,0)
 3527 KPRINT "音色を組み替えてみよう！         3/17",,,RGB(20,0,20)
 3528 KPRINT "･";:KPRINT "STANDARD";,RGB(31,22,22):KPRINT "のストリングスと､";
 3529 KPRINT "PIANO";,RGB(31,22,22):KPRINT "､";:KPRINT "ETHNIC",RGB(31,22,22)
 3530 KPRINT " の尺八を同時に鳴らします｡":KPRINT (10,71,0,-7,0),FIX "CLEAR ,1360",RGB(31,31,0)
 3531 KPRINT FIX "PLAYINIT"+CHR$(&H22)+"STANDARD"+CHR$(&H22)+",,487",RGB(31,31,0)
 3532 KPRINT FIX "TARG"+CHR$(&H22)+"STANDARD"+CHR$(&H22)+",44,"+CHR$(&H22)+"PIANO"+CHR$(&H22)+",1,"+CHR$(&H22)+"ETHNIC"+CHR$(&H22)+",4",RGB(31,31,0)
 3533 KPRINT FIX "EFFECT "+CHR$(&H22)+"L1@1CDE"+CHR$(&H22)+","+CHR$(&H22)+"L1@2CDE"+CHR$(&H22)+","+CHR$(&H22)+"L1@3<CDE"+CHR$(&H22),RGB(31,31,0)
 3534 KPRINT (10,122,0,1,0),"･";:KPRINT "PLAYINIT";,RGB(22,22,31):KPRINT "命令の｢";:KPRINT "487";,RGB(31,22,22)
 3535 KPRINT "｣で､音色データ領域":KPRINT " を拡張し､";:KPRINT "TARG";,RGB(22,22,31):KPRINT "で音色を選択しています｡"
 3536 KPRINT "★番号は1番から順番に割り当てられます｡",RGB(22,22,0)
 3537 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 3538 GOSUB *FADEIN
 3539 A$=INPUT$(1)
 3540 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 3541 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_3_2
 3542 IF A$<>" "     THEN *M_TUTORIAL_3_3
 3543 CLS:PRINT "Loading STANDARD,PIANO,ETHNIC Set..."
 3544 PLAYINIT "STANDARD",,487
 3545 TARG "STANDARD",44,"PIANO",1,"ETHNIC",4:CLS
 3546 EFFECT(ST),"L1@1CDE","L1@2CDE","L1@3<CDE"
 3547 GOSUB *KEYIN
 3548 VSYNC 2:PLAYSTOP ST
 3549 IF A$="0"      THEN *MAIN_MENU
 3550 IF A$=CHR$(13) THEN *M_TUTORIAL_3_2
 3551 IF A$<>" "     THEN *M_TUTORIAL_3_3
 3552 '-------------
 3553 *M_TUTORIAL_3_4
 3554 KPRINT (10,20,0,1,0)
 3555 KPRINT "音色を組み替えてみよう！         4/17",,,RGB(20,0,20)
 3556 KPRINT "･同じ動作を";:KPRINT "DATA";,RGB(22,22,31):KPRINT "文から読む方法で行なう"
 3557 KPRINT " ときは下のようになります｡":KPRINT " (前の例の";:KPRINT "TARG";,RGB(22,22,31):KPRINT "部分のみ書き換えます)"
 3558 KPRINT (10,88,0,-7,0),FIX " TARG READ",RGB(31,31,20):KPRINT FIX " DATA STANDARD,44",RGB(31,31,20)
 3559 KPRINT FIX " DATA PIANO   ,1",RGB(31,31,20):KPRINT FIX " DATA ETHNIC  ,4",RGB(31,31,20)
 3560 KPRINT FIX " DATA ENDARRANGE",RGB(31,31,20):KPRINT ""
 3561 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 3562 GOSUB *KEYIN
 3563 IF A$="0"      THEN *MAIN_MENU
 3564 IF A$=CHR$(13) THEN *M_TUTORIAL_3_3
 3565 IF A$<>" "     THEN *M_TUTORIAL_3_4
 3566 '-------------
 3567 *M_TUTORIAL_3_5
 3568 KPRINT (10,20,0,1,0)
 3569 KPRINT "音色を組み替えてみよう！         5/17",,,RGB(20,0,20)
 3570 KPRINT "･";:KPRINT "DATA";,RGB(22,22,31):KPRINT "文で記述する場合は､";:KPRINT "レイヤー単位",RGB(31,22,22)
 3571 KPRINT " の組み替えが可能です｡":KPRINT "･例えば､";:KPRINT "STANDARD";,RGB(31,22,22):KPRINT "セットのドラム(31番) "
 3572 KPRINT " をコピーするとき､通常の音色単位のコ":KPRINT " ピーを行なうと､すべてのドラム音色が"
 3573 KPRINT " コピーされます｡":KPRINT (10,139,0,-7,0),FIX " DATA STANDARD,31",RGB(31,31,20):KPRINT FIX " DATA ENDARRANGE",RGB(31,31,20)
 3574 KPRINT FIX " EFFECT "+CHR$(&H22)+"@1 N36 N38 N48 N45 N41",RGB(31,31,0)
 3575 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 3576 GOSUB *FADEIN
 3577 A$=INPUT$(1)
 3578 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 3579 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_3_4
 3580 IF A$<>" "     THEN *M_TUTORIAL_3_5
 3581 CLS:PRINT "Loading STANDARD Set...":PLAYINIT:'ﾈｲﾛﾘｮｳｲｷﾉ ｶｸﾁｮｳﾊﾊﾞｦ ﾓﾄﾆﾓﾄﾞｼﾃｲﾙ｡
 3582 RESTORE *HTT35:TARG READ:CLS
 3583 *HTT35
 3584 DATA "STANDARD",31
 3585 DATA ENDARRANGE
 3586 EFFECT(ST),1,"@1 V12 N36 N38 N48 N45 N41"
 3587 GOSUB *KEYIN
 3588 VSYNC 2:PLAYSTOP ST
 3589 IF A$="0"      THEN *MAIN_MENU
 3590 IF A$=CHR$(13) THEN *M_TUTORIAL_3_4
 3591 IF A$<>" "     THEN *M_TUTORIAL_3_5
 3592 '-------------
 3593 *M_TUTORIAL_3_6
 3594 KPRINT (10,20,0,1,0)
 3595 KPRINT "音色を組み替えてみよう！         6/17",,,RGB(20,0,20)
 3596 KPRINT "･｢";:KPRINT "BUILDLAYER";,RGB(31,22,22):KPRINT "～";:KPRINT "ENDLAYER";,RGB(31,22,22)
 3597 KPRINT "｣を使い､特定の ":KPRINT " レイヤーのみ取り出します｡"
 3598 KPRINT "･下の例は､";:KPRINT "レイヤー1";,RGB(31,22,22):KPRINT "(Snare)の波形のみ "
 3599 KPRINT " コピーしています(他の音は鳴らない)｡ ":KPRINT (10,105,0,-7,0),FIX " DATA BUILDLAYER",RGB(31,31,20)
 3600 KPRINT FIX " DATA STANDARD,31,1, -1,-1,-1",RGB(31,31,20):KPRINT FIX " DATA ENDLAYER",RGB(31,31,20)
 3601 KPRINT FIX " DATA ENDARRANGE",RGB(31,31,20):KPRINT FIX " EFFECT "+CHR$(&H22)+"@1 N36 N38 N48 N45 N41",RGB(31,31,0)
 3602 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 3603 GOSUB *FADEIN
 3604 A$=INPUT$(1)
 3605 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 3606 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_3_5
 3607 IF A$<>" "     THEN *M_TUTORIAL_3_6
 3608 CLS:PRINT "Loading STANDARD Set..."
 3609 RESTORE *HTT36:TARG READ:CLS
 3610 *HTT36
 3611 DATA BUILDLAYER
 3612 DATA STANDARD,31,1, -1,-1,-1
 3613 DATA ENDLAYER
 3614 DATA ENDARRANGE
 3615 EFFECT(ST),1,"@1 V12 N36 N38 N48 N45 N41"
 3616 GOSUB *KEYIN
 3617 VSYNC 2:PLAYSTOP ST
 3618 IF A$="0"      THEN *MAIN_MENU
 3619 IF A$=CHR$(13) THEN *M_TUTORIAL_3_5
 3620 IF A$<>" "     THEN *M_TUTORIAL_3_6
 3621 '-------------
 3622 *M_TUTORIAL_3_7
 3623 KPRINT (10,20,0,1,0)
 3624 KPRINT "音色を組み替えてみよう！         7/17",,,RGB(20,0,20)
 3625 KPRINT FIX " DATA STANDARD,31,1, -1,-1,-1",RGB(31,31,20):KPRINT "                  ~Snareのレイヤー"
 3626 KPRINT "･3つの｢";:KPRINT FIX "-1";,RGB(31,31,20):KPRINT "｣指定は､";
 3627 KPRINT "Start note";,RGB(31,22,22):KPRINT "､";:KPRINT "End note";,RGB(31,22,22):KPRINT "､"
 3628 KPRINT " Base note";,RGB(31,22,22):KPRINT "です｡"
 3629 KPRINT "･すべて｢";:KPRINT FIX "-1";,RGB(31,31,20):KPRINT "｣を指定した場合は､元の情報 "
 3630 KPRINT " がコピーされます｡したがって､Snareの "
 3631 KPRINT " 音はnote番号が｢";:KPRINT FIX "38";,RGB(31,31,20):KPRINT "｣のときのみ発音され"
 3632 KPRINT " るため､MMLの｢";:KPRINT FIX "N";,RGB(31,31,20):KPRINT "｣コマンドで｢";
 3633 KPRINT FIX "N38";,RGB(31,31,20):KPRINT "｣以外で":KPRINT " は音が鳴りません｡"
 3634 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 3635 GOSUB *KEYIN
 3636 IF A$="0"      THEN *MAIN_MENU
 3637 IF A$=CHR$(13) THEN *M_TUTORIAL_3_6
 3638 IF A$<>" "     THEN *M_TUTORIAL_3_7
 3639 '-------------
 3640 *M_TUTORIAL_3_8
 3641 KPRINT (10,20,0,1,0)
 3642 KPRINT "音色を組み替えてみよう！         8/17",,,RGB(20,0,20)
 3643 KPRINT "･";:KPRINT "Start note";,RGB(31,22,22):KPRINT "と";:KPRINT "End note";,RGB(31,22,22)
 3644 KPRINT "を書き換えて､";:KPRINT "0";,RGB(22,22,0):KPRINT "～"
 3645 KPRINT " 127";,RGB(22,22,0):KPRINT "の";:KPRINT "全域";,RGB(31,22,22):KPRINT "を発音範囲にしてみましょう｡"
 3646 KPRINT FIX " DATA STANDARD,31,1, 0,127,-1",RGB(31,31,20):KPRINT "                     ~ ~~~"
 3647 KPRINT "･このようにして先のMMLを実行すると､す":KPRINT " べてのノート番号でSnareの音が鳴るよ"
 3648 KPRINT " うになります｡":KPRINT FIX " @1 N36 N38 N48 N45 N41",RGB(31,31,0):KPRINT "        ~~~本来のSnareの音"
 3649 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 3650 GOSUB *FADEIN
 3651 A$=INPUT$(1)
 3652 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 3653 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_3_7
 3654 IF A$<>" "     THEN *M_TUTORIAL_3_8
 3655 CLS:PRINT "Loading STANDARD Set..."
 3656 RESTORE *HTT38:TARG READ:CLS
 3657 *HTT38
 3658 DATA BUILDLAYER
 3659 DATA STANDARD,31,1, 0,127,-1
 3660 DATA ENDLAYER
 3661 DATA ENDARRANGE
 3662 EFFECT(ST),1,"@1 V12 N36 N38 N48 N45 N41"
 3663 GOSUB *KEYIN
 3664 VSYNC 2:PLAYSTOP ST
 3665 IF A$="0"      THEN *MAIN_MENU
 3666 IF A$=CHR$(13) THEN *M_TUTORIAL_3_7
 3667 IF A$<>" "     THEN *M_TUTORIAL_3_8
 3668 '-------------
 3669 *M_TUTORIAL_3_9
 3670 KPRINT (10,20,0,1,0)
 3671 KPRINT "音色を組み替えてみよう！         9/17",,,RGB(20,0,20)
 3672 KPRINT "･他の音色セットのドラムと組み合わせて":KPRINT " 鳴らす場合､ノート番号が重複してしま "
 3673 KPRINT " う場合があります｡"
 3674 KPRINT "･この場合は";:KPRINT "Base note";,RGB(31,22,22):KPRINT "を書き換えて､発音"
 3675 KPRINT " させる";:KPRINT "ノート番号をシフト";,RGB(31,22,22):KPRINT "することで対"
 3676 KPRINT " 処できます(";:KPRINT "38→0";,RGB(22,22,0):KPRINT "／";:KPRINT "37～38→47～48";,RGB(22,22,0):KPRINT ")｡"
 3677 KPRINT (10,139,0,-7,0),FIX " DATA STANDARD,31,1, 0,0,-38",RGB(31,31,20)
 3678 KPRINT FIX " DATA METAL,    5,1, 0,0,+10",RGB(31,31,20):KPRINT FIX " DATA ENDARRANGE",RGB(31,31,20)
 3679 KPRINT FIX " EFFECT"+CHR$(&H22)+"@1 N0N0N0 N47N47N47 N48N48N48",RGB(31,31,0)
 3680 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 3681 GOSUB *FADEIN
 3682 A$=INPUT$(1)
 3683 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 3684 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_3_8
 3685 IF A$<>" "     THEN *M_TUTORIAL_3_9
 3686 CLS:PRINT "Loading STANDARD,METAL Set..."
 3687 RESTORE *HTT39:TARG READ:CLS
 3688 *HTT39
 3689 DATA BUILDLAYER
 3690 DATA STANDARD,31,1, 0,0,-38
 3691 DATA METAL,    5,1, 0,0,+10
 3692 DATA ENDLAYER
 3693 DATA ENDARRANGE
 3694 EFFECT(ST),1,"@1 V12 N0 N0 N0 N47 N47 N47 N48 N48 N48"
 3695 GOSUB *KEYIN
 3696 VSYNC 2:PLAYSTOP ST
 3697 IF A$="0"      THEN *MAIN_MENU
 3698 IF A$=CHR$(13) THEN *M_TUTORIAL_3_8
 3699 IF A$<>" "     THEN *M_TUTORIAL_3_9
 3700 '-------------
 3701 *M_TUTORIAL_3_10
 3702 KPRINT (10,20,0,1,0)
 3703 KPRINT "音色を組み替えてみよう！        10/17",,,RGB(20,0,20)
 3704 KPRINT "･ノート番号を意図的に同じにして､同時":KPRINT " に鳴らすことができます｡"
 3705 KPRINT (10,71,0,-7,0),FIX " DATA BUILDLAYER",RGB(31,31,20):KPRINT FIX " DATA STANDARD,31,1, 0,0,-28",RGB(31,31,20)
 3706 KPRINT FIX " DATA METAL,    5,1, 0,0,-28",RGB(31,31,20):KPRINT FIX " DATA ENDLAYER",RGB(31,31,20):KPRINT FIX " DATA ENDARRANGE",RGB(31,31,20)
 3707 KPRINT FIX " EFFECT "+CHR$(&H22)+"@1 N10 N10 N10",RGB(31,31,0):KPRINT (10,139,0,1,0),"･本来｢";:KPRINT FIX "N38";,RGB(31,31,20):KPRINT "｣のものを｢";
 3708 KPRINT FIX "-28";,RGB(31,31,20):KPRINT "｣にして､｢";:KPRINT FIX "N10";,RGB(31,31,20):KPRINT "｣で"
 3709 KPRINT " 鳴るように設定しています｡"
 3710 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 3711 GOSUB *FADEIN
 3712 A$=INPUT$(1)
 3713 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 3714 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_3_9
 3715 IF A$<>" "     THEN *M_TUTORIAL_3_10
 3716 CLS:PRINT "Loading STANDARD,METAL Set..."
 3717 RESTORE *HTT310:TARG READ:CLS
 3718 *HTT310
 3719 DATA BUILDLAYER
 3720 DATA STANDARD,31,1, 0,0,-28
 3721 DATA METAL,    5,1, 0,0,-28
 3722 DATA ENDLAYER
 3723 DATA ENDARRANGE
 3724 EFFECT(ST),1,"@1 V12 N10 N10 N10"
 3725 GOSUB *KEYIN
 3726 VSYNC 2:PLAYSTOP ST
 3727 IF A$="0"      THEN *MAIN_MENU
 3728 IF A$=CHR$(13) THEN *M_TUTORIAL_3_9
 3729 IF A$<>" "     THEN *M_TUTORIAL_3_10
 3730 '-------------
 3731 *M_TUTORIAL_3_11
 3732 KPRINT (10,20,0,1,0)
 3733 KPRINT "音色を組み替えてみよう！        11/17",,,RGB(20,0,20)
 3734 KPRINT "･音色によっては､";:KPRINT "音域別";,RGB(31,22,22):KPRINT "に複数のサンプ "
 3735 KPRINT " リング波形を使い､";:KPRINT "ノート番号で切り替",RGB(31,22,22)
 3736 KPRINT " えている";,RGB(31,22,22):KPRINT "ものがあります｡"
 3737 KPRINT "･";:KPRINT "PIANO";,RGB(31,22,22):KPRINT "セットは｢";:KPRINT "0-33";,RGB(22,22,0)
 3738 KPRINT "｣､｢";:KPRINT "34-40";,RGB(22,22,0):KPRINT "｣､｢";:KPRINT "41-48";,RGB(22,22,0):KPRINT "｣､"
 3739 KPRINT " ｢";:KPRINT "49-55";,RGB(22,22,0):KPRINT "｣､｢";:KPRINT "56-62";,RGB(22,22,0)
 3740 KPRINT "｣､｢";:KPRINT "63-69";,RGB(22,22,0):KPRINT "｣､｢";:KPRINT "70-75";,RGB(22,22,0):KPRINT "｣､"
 3741 KPRINT " ｢";:KPRINT "76-81";,RGB(22,22,0):KPRINT "｣､｢";:KPRINT "82-89";,RGB(22,22,0):KPRINT "｣｢";
 3742 KPRINT "90-120";,RGB(22,22,0):KPRINT "｣の";:KPRINT "10レイヤー",RGB(31,22,22)
 3743 KPRINT " にわかれています｡":KPRINT "･PIANOセットを普通に聞いてみましょう｡"
 3744 KPRINT FIX " @1 O1 L8 CDEFGAB>CDEFGAB>CDEFGAB>C…",RGB(31,31,0)
 3745 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 3746 GOSUB *FADEIN
 3747 A$=INPUT$(1)
 3748 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 3749 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_3_10
 3750 IF A$<>" "     THEN *M_TUTORIAL_3_11
 3751 CLS:PRINT "Loading PIANO Set..."
 3752 PLAYINIT "PIANO":CLS
 3753 EFFECT(ST),1,"@1 O1 L8 CDEFGAB>CDEFGAB>CDEFGAB>CDEFGAB>CDEFGAB>CDEFGAB>CDEFGAB>C"
 3754 GOSUB *KEYIN
 3755 VSYNC 2:PLAYSTOP ST
 3756 IF A$="0"      THEN *MAIN_MENU
 3757 IF A$=CHR$(13) THEN *M_TUTORIAL_3_10
 3758 IF A$<>" "     THEN *M_TUTORIAL_3_11
 3759 '-------------
 3760 *M_TUTORIAL_3_12
 3761 KPRINT (10,20,0,1,0)
 3762 KPRINT "音色を組み替えてみよう！        12/17",,,RGB(20,0,20)
 3763 KPRINT "･";:KPRINT "PIANO";,RGB(31,22,22):KPRINT "セットは､";:KPRINT "ピアノだけ";,RGB(31,22,22):KPRINT "で大量の波形"
 3764 KPRINT " メモリを占有していますので､組み替え":KPRINT " を行なったとしても､他の楽器の音が入"
 3765 KPRINT " らなくなってしまいます｡":KPRINT "･このような場合は､";:KPRINT "実際に使用する音域",RGB(31,22,22)
 3766 KPRINT " の波形データだけをコピーすれば､メモ ":KPRINT " リを";:KPRINT "節約";,RGB(31,22,22):KPRINT "することができます｡"
 3767 KPRINT "(";:KPRINT "PLAYINIT";,RGB(22,22,31):KPRINT "で音色データ領域を拡張すれば､"
 3768 KPRINT " 更に他の音色を組み込むことができます)"
 3769 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 3770 GOSUB *KEYIN
 3771 IF A$="0"      THEN *MAIN_MENU
 3772 IF A$=CHR$(13) THEN *M_TUTORIAL_3_11
 3773 IF A$<>" "     THEN *M_TUTORIAL_3_12
 3774 '-------------
 3775 *M_TUTORIAL_3_13
 3776 KPRINT (10,20,0,1,0)
 3777 KPRINT "音色を組み替えてみよう！        13/17",,,RGB(20,0,20)
 3778 KPRINT "･ノート番号｢";:KPRINT "56-62";,RGB(22,22,0):KPRINT "｣(";:KPRINT "レイヤー4";,RGB(31,22,22):KPRINT ")の波形の"
 3779 KPRINT " みコピーし､それを";:KPRINT "全域";,RGB(31,22,22):KPRINT "で鳴らせるよう "
 3780 KPRINT " にします(";:KPRINT "中音域";,RGB(31,22,22):KPRINT "のみ使う場合に有効)｡"
 3781 KPRINT (10,88,0,-7,0),FIX " DATA BUILDLAYER",RGB(31,31,20):KPRINT FIX " DATA PIANO,1,4, 0,127,-1",RGB(31,31,20)
 3782 KPRINT FIX " DATA ENDLAYER",RGB(31,31,20):KPRINT FIX " DATA ENDARRANGE",RGB(31,31,20)
 3783 KPRINT (10,139,0,1,0),"･｢";:KPRINT "56-62";,RGB(22,22,0):KPRINT "｣の範囲は､";:KPRINT "本来の取り込み音域";,RGB(31,22,22):KPRINT "で"
 3784 KPRINT " 鳴ります｡範囲外の音質は劣化します｡":KPRINT FIX " @1 O1 L8 CDEFGAB>CDEFGAB>CDEFGAB>C…",RGB(31,31,0)
 3785 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 3786 GOSUB *FADEIN
 3787 A$=INPUT$(1)
 3788 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 3789 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_3_12
 3790 IF A$<>" "     THEN *M_TUTORIAL_3_13
 3791 CLS:PRINT "Loading PIANO Set..."
 3792 RESTORE *HTT313:TARG READ:CLS
 3793 *HTT313
 3794 DATA BUILDLAYER
 3795 DATA PIANO,1,4, 0,127,-1
 3796 DATA ENDLAYER
 3797 DATA ENDARRANGE
 3798 EFFECT(ST),1,"@1 O1 L8 CDEFGAB>CDEFGAB>CDEFGAB>CDEFGAB>CDEFGAB>CDEFGAB>CDEFGAB>C"
 3799 GOSUB *KEYIN
 3800 VSYNC 2:PLAYSTOP ST
 3801 IF A$="0"      THEN *MAIN_MENU
 3802 IF A$=CHR$(13) THEN *M_TUTORIAL_3_12
 3803 IF A$<>" "     THEN *M_TUTORIAL_3_13
 3804 '-------------
 3805 *M_TUTORIAL_3_14
 3806 KPRINT (10,20,0,1,0)
 3807 KPRINT "音色を組み替えてみよう！        14/17",,,RGB(20,0,20)
 3808 KPRINT "･";:KPRINT "レイヤー編集";,RGB(31,22,22):KPRINT "は｢";
 3809 KPRINT FIX "BUILDLAYER";,RGB(31,31,20):KPRINT "～";:KPRINT FIX "ENDLAYER";,RGB(31,31,20):KPRINT "｣"
 3810 KPRINT " で挟まれた部分が､1つの音色になります｡"
 3811 KPRINT "･下の例は､";:KPRINT "PIANO";,RGB(31,22,22):KPRINT "の";:KPRINT "低音域";,RGB(31,22,22)
 3812 KPRINT "と";:KPRINT "高音域";,RGB(31,22,22):KPRINT "を別々"
 3813 KPRINT " の音色に登録しています(｢";:KPRINT FIX "@1";,RGB(31,31,20):KPRINT "｣と｢";
 3814 KPRINT FIX "@2";,RGB(31,31,20):KPRINT "｣)｡"
 3815 KPRINT (10,105,0,-7,0),FIX " DATA BUILDLAYER",RGB(31,31,20):KPRINT FIX " DATA PIANO,1,1, 0,127,-1",RGB(31,31,20):KPRINT FIX " DATA ENDLAYER",RGB(31,31,20)
 3816 KPRINT FIX " DATA BUILDLAYER",RGB(31,31,20):KPRINT FIX " DATA PIANO,1,8, 0,127,-1",RGB(31,31,20):KPRINT FIX " DATA ENDLAYER",RGB(31,31,20):KPRINT FIX " DATA ENDARRANGE",RGB(31,31,20)
 3817 KPRINT FIX " EFFECT "+CHR$(&H22)+"@1 O1 L8 CDEF… @2 O1 CDEF…",RGB(31,31,0)
 3818 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 3819 GOSUB *FADEIN
 3820 A$=INPUT$(1)
 3821 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 3822 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_3_13
 3823 IF A$<>" "     THEN *M_TUTORIAL_3_14
 3824 CLS:PRINT "Loading PIANO Set..."
 3825 RESTORE *HTT314:TARG READ:CLS
 3826 *HTT314
 3827 DATA BUILDLAYER,PIANO,1,1, 0,127,-1,ENDLAYER :'@1
 3828 DATA BUILDLAYER,PIANO,1,8, 0,127,-1,ENDLAYER :'@2
 3829 DATA ENDARRANGE
 3830 EFFECT(ST),1,"@1 O1 L8 CDEFGAB>CDEFGAB>CDEFGAB>CDEFGAB>CDEFGAB>CDEFGAB>CDEFGAB>C R @2 O1 CDEFGAB>CDEFGAB>CDEFGAB>CDEFGAB>CDEFGAB>CDEFGAB>CDEFGAB>C"
 3831 GOSUB *KEYIN
 3832 VSYNC 2:PLAYSTOP ST
 3833 IF A$="0"      THEN *MAIN_MENU
 3834 IF A$=CHR$(13) THEN *M_TUTORIAL_3_13
 3835 IF A$<>" "     THEN *M_TUTORIAL_3_14
 3836 '-------------
 3837 *M_TUTORIAL_3_15
 3838 KPRINT (10,20,0,1,0)
 3839 KPRINT "音色を組み替えてみよう！        15/17",,,RGB(20,0,20)
 3840 KPRINT "･";:KPRINT "ノート番号別";,RGB(31,22,22):KPRINT "に";
 3841 KPRINT "異なる楽器";,RGB(31,22,22):KPRINT "を登録するこ"
 3842 KPRINT " ともできます(";:KPRINT "Key split";,RGB(31,22,22):KPRINT "機能)｡"
 3843 KPRINT (10,71,0,-7,0),FIX " DATA BUILDLAYER",RGB(31,31,20):KPRINT FIX " DATA STANDARD,35,0,60,63,-1:'Syn.Bass",RGB(31,31,20)
 3844 KPRINT FIX " DATA          44,0,64,66,-1:'Strings",RGB(31,31,20)
 3845 KPRINT FIX " DATA          41,0,67,70,-1:'O.D.ｷﾞﾀｰ",RGB(31,31,20)
 3846 KPRINT FIX " DATA          49,0,71,73,-1:'Oboe",RGB(31,31,20):KPRINT FIX " DATA ENDLAYER",RGB(31,31,20):KPRINT FIX " DATA ENDARRANGE",RGB(31,31,20)
 3847 KPRINT FIX " EFFECT "+CHR$(&H22)+"@1 O4 CDEFGAB>C",RGB(31,31,0)
 3848 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 3849 GOSUB *FADEIN
 3850 A$=INPUT$(1)
 3851 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 3852 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_3_14
 3853 IF A$<>" "     THEN *M_TUTORIAL_3_15
 3854 CLS:PRINT "Loading STANDARD Set..."
 3855 RESTORE *HTT315:TARG READ:CLS
 3856 *HTT315
 3857 DATA BUILDLAYER
 3858 DATA STANDARD,35,0,60,63,-1 :'Synth Bass
 3859 DATA          44,0,64,66,-1 :'Strings
 3860 DATA          41,0,67,70,-1 :'Over Drive Guitar
 3861 DATA          49,0,71,73,-1 :'Oboe
 3862 DATA ENDLAYER
 3863 DATA ENDARRANGE
 3864 EFFECT(ST),1,"@1 O4 CDEFGAB>C"
 3865 GOSUB *KEYIN
 3866 VSYNC 2:PLAYSTOP ST
 3867 IF A$="0"      THEN *MAIN_MENU
 3868 IF A$=CHR$(13) THEN *M_TUTORIAL_3_14
 3869 IF A$<>" "     THEN *M_TUTORIAL_3_15
 3870 '-------------
 3871 *M_TUTORIAL_3_16
 3872 KPRINT (10,20,0,1,0)
 3873 KPRINT "音色を組み替えてみよう！        16/17",,,RGB(20,0,20)
 3874 KPRINT "･組み替え時はCDアクセスを伴いますので､"
 3875 KPRINT " 同じ音色ファイルの音色は､まとめて並 "
 3876 KPRINT " べた方が速くなります｡"
 3877 KPRINT " (2つ目以降のファイル名も省略します) "
 3878 KPRINT "●遅い ↓(4回LOAD)  ●速い ↓(2回LOAD)",RGB(31,31,0)
 3879 KPRINT (10,122,0,-7,0),FIX " DATA STANDARD,44    DATA STANDARD,44",RGB(31,31,20)
 3880 KPRINT FIX " DATA ORCHEST ,35    DATA          31",RGB(31,31,20)
 3881 KPRINT FIX " DATA STANDARD,31    DATA ORCHEST ,35",RGB(31,31,20)
 3882 KPRINT FIX " DATA ORCHEST ,36    DATA          36",RGB(31,31,20)
 3883 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 3884 GOSUB *KEYIN
 3885 IF A$="0"      THEN *MAIN_MENU
 3886 IF A$=CHR$(13) THEN *M_TUTORIAL_3_15
 3887 IF A$<>" "     THEN *M_TUTORIAL_3_16
 3888 '-------------
 3889 *M_TUTORIAL_3_17
 3890 KPRINT (10,20,0,1,0)
 3891 KPRINT "音色を組み替えてみよう！        17/17",,,RGB(20,0,20)
 3892 KPRINT FIX " CLEAR,1360,1360",RGB(31,31,20)
 3893 KPRINT " のように､2つのファイル領域を1360ブロ"
 3894 KPRINT " ックずつ確保することにより､高速に音色"
 3895 KPRINT " 切り替えを行なうことができます｡"
 3896 KPRINT "･これは､異なる音色をロードするときに､"
 3897 KPRINT " ファイル領域が空いていれば自動的に前"
 3898 KPRINT " のファイルを待避させるからです｡"
 3899 KPRINT " (キャッシュ･メモリの働きがあります)"
 3900 KPRINT "★ファイル領域1つだけでも効果あります｡",RGB(31,22,22)
 3901 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 3902 GOSUB *KEYIN
 3903 IF A$="0"      THEN *MAIN_MENU
 3904 IF A$=CHR$(13) THEN *M_TUTORIAL_3_16
 3905 IF A$<>" "     THEN *M_TUTORIAL_3_17
 3906 '-------------
 3907 GOTO *M_TUTORIAL
 3908 '--------------------------------------------------------------------------------------------------------
 3909 *M_TUTORIAL_4_1
 3910 KPRINT (10,20,0,1,0)
 3911 KPRINT "音色を加工してみよう！           1/18",,,RGB(20,0,20)
 3912 KPRINT "･";:KPRINT "TPROP";,RGB(22,22,31):KPRINT "命令を使って､音色(FM音源含む)を"
 3913 KPRINT " 自由に加工";,RGB(31,22,22):KPRINT "することができます｡"
 3914 KPRINT "･｢";:KPRINT FIX "TPROP(";,RGB(31,31,20):KPRINT "音色#";
 3915 KPRINT FIX ",";,RGB(31,31,20):KPRINT "レイヤー#";:KPRINT FIX ",";,RGB(31,31,20):KPRINT "項目#";
 3916 KPRINT FIX ")";,RGB(31,31,20):KPRINT "｣のよう"
 3917 KPRINT " に";:KPRINT "3";,RGB(22,22,0):KPRINT "つのパラメータを指定し､該当する音"
 3918 KPRINT " 色の項目を";:KPRINT "読み書き";,RGB(31,22,22):KPRINT "できます｡         "
 3919 KPRINT "(例1) ";,RGB(31,31,20):KPRINT FIX "A=TPROP(44,0,10)",RGB(31,31,20)
 3920 KPRINT " 音色";:KPRINT "44";,RGB(22,22,0):KPRINT "ﾚｲﾔｰ";:KPRINT "0";,RGB(22,22,0)
 3921 KPRINT "項目";:KPRINT "10";,RGB(22,22,0):KPRINT "の内容を";:KPRINT "変数A";,RGB(31,22,22):KPRINT "に代入｡"
 3922 KPRINT "(例2) ";,RGB(31,31,20):KPRINT FIX "TPROP(51,1,20)=31",RGB(31,31,20)
 3923 KPRINT " 音色";:KPRINT "51";,RGB(22,22,0):KPRINT "ﾚｲﾔｰ";:KPRINT "1";,RGB(22,22,0)
 3924 KPRINT "項目";:KPRINT "20";,RGB(22,22,0):KPRINT "の内容を";:KPRINT "31に変更";,RGB(31,22,22):KPRINT "｡"
 3925 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 3926 GOSUB *KEYIN
 3927 IF A$="0"      THEN *MAIN_MENU
 3928 IF A$=CHR$(13) THEN *M_TUTORIAL
 3929 IF A$<>" "     THEN *M_TUTORIAL_4_1
 3930 '-------------
 3931 *M_TUTORIAL_4_2
 3932 KPRINT (10,20,0,1,0)
 3933 KPRINT "音色を加工してみよう！           2/18",,,RGB(20,0,20)
 3934 KPRINT "項目番号は､以下のようにわかれています｡"
 3935 KPRINT "●Voice部 ( 0～)●Note ON制御   (10～)",RGB(31,31,20)
 3936 KPRINT "●EG制御  (20～)●波形データ制御(30～)",RGB(31,31,20)
 3937 KPRINT "●LFO制御 (50～)●FM結線        (60～)",RGB(31,31,20)
 3938 KPRINT "●ﾐｷｻｰ制御(70～)",RGB(31,31,20)
 3939 KPRINT "･加工した音色は";:KPRINT "Note ONのタイミング";,RGB(31,22,22):KPRINT "で "
 3940 KPRINT " 実際の";:KPRINT "発音スロット･レジスタ";,RGB(31,22,22):KPRINT "に書き込 ":KPRINT " まれます｡"
 3941 KPRINT "★パラメータの標準設定値はﾏﾆｭｱﾙ参照｡ ",RGB(22,22,0)
 3942 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 3943 GOSUB *KEYIN
 3944 IF A$="0"      THEN *MAIN_MENU
 3945 IF A$=CHR$(13) THEN *M_TUTORIAL_4_1
 3946 IF A$<>" "     THEN *M_TUTORIAL_4_2
 3947 '-------------
 3948 *M_TUTORIAL_4_3
 3949 KPRINT (10,20,0,1,0)
 3950 KPRINT "音色を加工してみよう！           3/18",,,RGB(20,0,20)
 3951 KPRINT "･項目番号";:KPRINT "1桁";,RGB(31,22,22):KPRINT "番台(";:KPRINT "Voice";,RGB(31,22,22):KPRINT "部)は､";
 3952 KPRINT "音色全体",RGB(31,22,22):KPRINT " に関わるため､レイヤー番号は無効です｡"
 3953 KPRINT "･項目番号";:KPRINT "2";,RGB(31,22,22):KPRINT "(";:KPRINT "音色数-1";,RGB(31,22,22):KPRINT ")だけは音色セット "
 3954 KPRINT " 全体に関わるため､音色番号も無効です｡"
 3955 KPRINT "(例) ";,RGB(31,31,20):KPRINT (50,105,0,-7,0),FIX "FOR T=0 TO TPROP(0,0,2) :'ﾈｲﾛ -1",RGB(31,31,20)
 3956 KPRINT FIX " FOR L=0 TO TPROP(T,0,1):'ﾚｲﾔｰ-1",RGB(31,31,20)
 3957 KPRINT (10,139,0,1,0),"(音色数､レイヤー数でループを作る場合)"
 3958 KPRINT "･項目番号には､｢";:KPRINT FIX "@";,RGB(31,31,20):KPRINT "｣に続く";:KPRINT "定数シンボル";,RGB(31,22,22)
 3959 KPRINT "が":KPRINT " 使えます(";:KPRINT "次のページ参照";,RGB(31,31,20):KPRINT ")｡"
 3960 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 3961 GOSUB *KEYIN
 3962 IF A$="0"      THEN *MAIN_MENU
 3963 IF A$=CHR$(13) THEN *M_TUTORIAL_4_2
 3964 IF A$<>" "     THEN *M_TUTORIAL_4_3
 3965 '-------------
 3966 *M_TUTORIAL_4_4_0
 3967 KPRINT (10,20,0,1,0)
 3968 KPRINT "音色を加工してみよう！           4/18",,,RGB(20,0,20)
 3969 KPRINT " 0";,RGB(31,22,22):KPRINT FIX " BEND   ";:KPRINT " 1";,RGB(31,22,22):KPRINT FIX " LAYER  ";
 3970 KPRINT " 2";,RGB(31,22,22):KPRINT FIX " TONE   ";:KPRINT "10";,RGB(31,22,22):KPRINT FIX " SN  "
 3971 KPRINT "11";,RGB(31,22,22):KPRINT FIX " EN     ";:KPRINT "12";,RGB(31,22,22):KPRINT FIX " BN     ";
 3972 KPRINT "13";,RGB(31,22,22):KPRINT FIX " FT     ";:KPRINT "20";,RGB(31,22,22):KPRINT FIX " AR  "
 3973 KPRINT "21";,RGB(31,22,22):KPRINT FIX " DR     ";:KPRINT "22";,RGB(31,22,22):KPRINT FIX " SR     ";
 3974 KPRINT "23";,RGB(31,22,22):KPRINT FIX " RR     ";:KPRINT "24";,RGB(31,22,22):KPRINT FIX " SL  "
 3975 KPRINT "25";,RGB(31,22,22):KPRINT FIX " EGHOLD ";:KPRINT "26";,RGB(31,22,22):KPRINT FIX " LSLINK ";
 3976 KPRINT "27";,RGB(31,22,22):KPRINT FIX " KS     ";:KPRINT "30";,RGB(31,22,22):KPRINT FIX " SDIR"
 3977 KPRINT "31";,RGB(31,22,22):KPRINT FIX " SB     ";:KPRINT "32";,RGB(31,22,22):KPRINT FIX " SS     ";
 3978 KPRINT "33";,RGB(31,22,22):KPRINT FIX " LOOP   ";:KPRINT "34";,RGB(31,22,22):KPRINT FIX " PCM8B"
 3979 KPRINT "35";,RGB(31,22,22):KPRINT FIX " LSA    ";:KPRINT "36";,RGB(31,22,22):KPRINT FIX " LEA    ";
 3980 KPRINT "50";,RGB(31,22,22):KPRINT FIX " RE     ";:KPRINT "51";,RGB(31,22,22):KPRINT FIX " LFOF"
 3981 KPRINT "52";,RGB(31,22,22):KPRINT FIX " ALFOWS ";:KPRINT "53";,RGB(31,22,22):KPRINT FIX " ALFOS  ";
 3982 KPRINT "54";,RGB(31,22,22):KPRINT FIX " PLFOWS ";:KPRINT "55";,RGB(31,22,22):KPRINT FIX " PLFOS"
 3983 KPRINT "60";,RGB(31,22,22):KPRINT FIX " MDX    ";:KPRINT "61";,RGB(31,22,22):KPRINT FIX " MDY    ";
 3984 KPRINT "62";,RGB(31,22,22):KPRINT FIX " MDL    ";:KPRINT "70";,RGB(31,22,22):KPRINT FIX " ISEL"
 3985 KPRINT "71";,RGB(31,22,22):KPRINT FIX " IMIX   ";:KPRINT "72";,RGB(31,22,22):KPRINT FIX " DSEND  ";
 3986 KPRINT "73";,RGB(31,22,22):KPRINT FIX " DPAN"
 3987 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 3988 GOSUB *KEYIN
 3989 IF A$="0"      THEN *MAIN_MENU
 3990 IF A$=CHR$(13) THEN *M_TUTORIAL_4_3
 3991 IF A$<>" "     THEN *M_TUTORIAL_4_4_0
 3992 '-------------
 3993 *M_TUTORIAL_4_4_1
 3994 KPRINT (10,20,0,1,0)
 3995 KPRINT "音色を加工してみよう！           5/18",,,RGB(20,0,20)
 3996 KPRINT "･では､これから";:KPRINT "STANDARD";,RGB(31,22,22):KPRINT "セットの音色番 "
 3997 KPRINT " 号";:KPRINT "44";,RGB(22,22,0):KPRINT "(";:KPRINT "Strings";,RGB(31,22,22):KPRINT ")を使って､色々と加工して"
 3998 KPRINT " みましょう｡":KPRINT "･まず､";:KPRINT "Strings";,RGB(31,22,22):KPRINT "音色がいくつのレイヤーで"
 3999 KPRINT " 構成されているかを調べてみます｡":KPRINT (10,122,0,-7,0),FIX " PRINT TPROP(44,0,@LAYER)",RGB(31,31,0)
 4000 KPRINT FIX "  1",RGB(31,31,20):KPRINT FIX " Ready.",RGB(31,31,20)
 4001 KPRINT (10,156,0,1,0)," と表示されるはずです(項目";:KPRINT "1";,RGB(22,22,0):KPRINT "は";:KPRINT "ﾚｲﾔｰ数-1";,RGB(31,22,22):KPRINT ")"
 4002 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4003 GOSUB *KEYIN
 4004 IF A$="0"      THEN *MAIN_MENU
 4005 IF A$=CHR$(13) THEN *M_TUTORIAL_4_4_0
 4006 IF A$<>" "     THEN *M_TUTORIAL_4_4_1
 4007 '-------------
 4008 *M_TUTORIAL_4_5
 4009 KPRINT (10,20,0,1,0)
 4010 KPRINT "音色を加工してみよう！           6/18",,,RGB(20,0,20)
 4011 KPRINT "･｢";:KPRINT "ﾚｲﾔｰ数-1";,RGB(31,22,22):KPRINT "｣が｢";:KPRINT "1";,RGB(22,22,0)
 4012 KPRINT "｣なので､ﾚｲﾔｰ";:KPRINT "0";,RGB(22,22,0):KPRINT "とﾚｲﾔｰ";:KPRINT "1";,RGB(22,22,0):KPRINT "が"
 4013 KPRINT " 存在することがわかりました｡"
 4014 KPRINT "･次に､ﾚｲﾔｰ";:KPRINT "0";,RGB(22,22,0):KPRINT "の";:KPRINT "Start note";,RGB(31,22,22)
 4015 KPRINT "と";:KPRINT "End note";,RGB(31,22,22):KPRINT "を調"
 4016 KPRINT " べてみます(";:KPRINT "項目番号10";,RGB(31,22,22):KPRINT "と";
 4017 KPRINT "項目番号11";,RGB(31,22,22):KPRINT ")｡ ":KPRINT (10,105,0,-7,0),FIX " PRINT TPROP(44,0,10),TPROP(44,0,11)",RGB(31,31,0)
 4018 KPRINT FIX "  0       67",RGB(31,31,20)
 4019 KPRINT FIX " Ready.       ";,RGB(31,31,20):KPRINT " (";:KPRINT FIX "@SN";,RGB(31,31,20):KPRINT " と ";:KPRINT FIX "@EN";,RGB(31,31,20):KPRINT " でも可)"
 4020 KPRINT (10,156,0,1,0),"･｢";:KPRINT FIX "N0";,RGB(31,31,20):KPRINT "～";:KPRINT FIX "N67";,RGB(31,31,20)
 4021 KPRINT "｣なので､ﾚｲﾔｰ";:KPRINT "0";,RGB(22,22,0):KPRINT "が";:KPRINT "低音域用";,RGB(31,22,22):KPRINT "の波 "
 4022 KPRINT " 形を管理していることがわかりました｡ "
 4023 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4024 GOSUB *KEYIN
 4025 IF A$="0"      THEN *MAIN_MENU
 4026 IF A$=CHR$(13) THEN *M_TUTORIAL_4_4_1
 4027 IF A$<>" "     THEN *M_TUTORIAL_4_5
 4028 '-------------
 4029 *M_TUTORIAL_4_6
 4030 KPRINT (10,20,0,1,0)
 4031 KPRINT "音色を加工してみよう！           7/18",,,RGB(20,0,20)
 4032 KPRINT "･ここから先は､説明を簡単にするために､"
 4033 KPRINT " 低音域レイヤー";,RGB(31,22,22):KPRINT "(";:KPRINT FIX "N0";,RGB(31,31,20)
 4034 KPRINT "～";:KPRINT FIX "N67";,RGB(31,31,20):KPRINT ")だけを操作し "
 4035 KPRINT " ます｡":KPRINT "･";:KPRINT "レイヤー境界";,RGB(31,22,22):KPRINT "にまたがらない音域はオク"
 4036 KPRINT " ターブ";:KPRINT "3";,RGB(22,22,0):KPRINT "(";:KPRINT FIX "N48";,RGB(31,31,20)
 4037 KPRINT "～";:KPRINT FIX "N59";,RGB(31,31,20):KPRINT ")ですので､以下のサン"
 4038 KPRINT " プルは､すべて｢";:KPRINT FIX "O3";,RGB(31,31,20):KPRINT "｣指定します｡"
 4039 KPRINT "･では､加工する前の";:KPRINT "Strings";,RGB(31,22,22):KPRINT "音色を聞いて"
 4040 KPRINT " みましょう｡":KPRINT FIX " EFFECT "+CHR$(&H22)+"@44 O3 L2 CDEFGAB>C"+CHR$(&H22),RGB(31,31,0)
 4041 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4042 GOSUB *FADEIN
 4043 A$=INPUT$(1)
 4044 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 4045 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_4_5
 4046 IF A$<>" "     THEN *M_TUTORIAL_4_6
 4047 EFFECT(ST),1,"@44 O3 L2 CDEFGAB>C"
 4048 GOSUB *KEYIN
 4049 VSYNC 2:PLAYSTOP ST
 4050 IF A$="0"      THEN *MAIN_MENU
 4051 IF A$=CHR$(13) THEN *M_TUTORIAL_4_5
 4052 IF A$<>" "     THEN *M_TUTORIAL_4_6
 4053 '-------------
 4054 *M_TUTORIAL_4_7
 4055 KPRINT (10,20,0,1,0)
 4056 KPRINT "音色を加工してみよう！           8/18",,,RGB(20,0,20)
 4057 KPRINT "･ここで､";:KPRINT "エンベロープ";,RGB(31,22,22):KPRINT "(EG)を書き換えて "
 4058 KPRINT " みましょう(項目番号は";:KPRINT "20番台";,RGB(22,22,0):KPRINT "です)｡"
 4059 KPRINT "･";:KPRINT "アタック･レート";,RGB(31,22,22):KPRINT "を変えて､";
 4060 KPRINT "Key ON";,RGB(31,22,22):KPRINT "時の音"
 4061 KPRINT " の";:KPRINT "立ち上がり";,RGB(31,22,22):KPRINT "を遅くしてみます｡       "
 4062 KPRINT FIX " PRINT TPROP(44,0,@AR)";,RGB(31,31,0):KPRINT " ←ｱﾀｯｸ･ﾚｰﾄ(AR)",RGB(0,31,0)
 4063 KPRINT FIX "  20                 ";,RGB(31,31,20):KPRINT "  ←ARの初期値  ",RGB(0,31,0)
 4064 KPRINT FIX " Ready.  ↓ EG 44,0,8 ";,RGB(31,31,20):KPRINT "でも同じ動作です｡"
 4065 KPRINT FIX " TPROP(44,0,@AR)=8   ";,RGB(31,31,0):KPRINT "  ←小さい程遅い",RGB(0,31,0)
 4066 KPRINT FIX " EFFECT "+CHR$(&H22)+"@44 O3 L2 CDEFGAB>C"+CHR$(&H22),RGB(31,31,0)
 4067 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4068 GOSUB *FADEIN
 4069 A$=INPUT$(1)
 4070 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 4071 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOSUB *TONE_RESET:GOTO *M_TUTORIAL_4_6
 4072 IF A$<>" "     THEN *M_TUTORIAL_4_7
 4073 TPROP(44,0,@AR)=8
 4074 EFFECT(ST),1,"@44 O3 L2 CDEFGAB>C"
 4075 GOSUB *KEYIN
 4076 VSYNC 2:PLAYSTOP ST
 4077 IF A$="0"      THEN *MAIN_MENU
 4078 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_4_6
 4079 IF A$<>" "     THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_4_7
 4080 '-------------
 4081 *M_TUTORIAL_4_8
 4082 KPRINT (10,20,0,1,0)
 4083 KPRINT "音色を加工してみよう！           9/18",,,RGB(20,0,20)
 4084 KPRINT "･";:KPRINT "TPROP";,RGB(22,22,31):KPRINT "で書き換え操作を行なうとき､";:KPRINT "連続",RGB(31,22,22)
 4085 KPRINT " している項目番号";,RGB(31,22,22):KPRINT "に対しては｢";:KPRINT FIX ",";,RGB(31,31,20):KPRINT "｣で区切 "
 4086 KPRINT " って一度に設定することができます｡   "
 4087 KPRINT "･";:KPRINT "ｱﾀｯｸ･ﾚｰﾄ";,RGB(31,22,22):KPRINT "と";:KPRINT "ﾘﾘｰｽ･ﾚｰﾄ";,RGB(31,22,22)
 4088 KPRINT "を書き換えてみます｡":KPRINT (10,105,0,-7,0),FIX " TPROP(44,0,@AR)=,,,5 (EG 44,0,,,,5)",RGB(31,31,0)
 4089 KPRINT FIX " EFFECT "+CHR$(&H22)+"@44 O3 L2 CDEFGAB>C"+CHR$(&H22),RGB(31,31,0)
 4090 KPRINT (10,139,0,1,0),"･書き換え後は､音色ファイルを読み直さ ":KPRINT " ない限り､設定値が保持されます｡"
 4091 KPRINT "(";:KPRINT "TPROP";,RGB(22,22,31):KPRINT "中､";:KPRINT "エラーが起きた場合は初期化";,RGB(31,22,22):KPRINT ")"
 4092 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4093 GOSUB *FADEIN
 4094 A$=INPUT$(1)
 4095 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 4096 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOSUB *TONE_RESET:GOTO *M_TUTORIAL_4_7
 4097 IF A$<>" "     THEN *M_TUTORIAL_4_8
 4098 TPROP(44,0,@AR)=8,,,5
 4099 EFFECT(ST),1,"@44 O3 L2 CDEFGAB>C"
 4100 GOSUB *KEYIN
 4101 VSYNC 2:PLAYSTOP ST
 4102 IF A$="0"      THEN *MAIN_MENU
 4103 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_4_7
 4104 IF A$<>" "     THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_4_8
 4105 '-------------
 4106 *M_TUTORIAL_4_9
 4107 KPRINT (10,20,0,1,0)
 4108 KPRINT "音色を加工してみよう！          10/18",,,RGB(20,0,20)
 4109 KPRINT "･";:KPRINT "ベンド･レンジ";,RGB(31,22,22):KPRINT "を変えてみます(";
 4110 KPRINT "項目0";,RGB(31,22,22):KPRINT ")｡ ":KPRINT "･これは､MMLのピッチ･ベンド･コマンドを"
 4111 KPRINT " 最大値で指定";,RGB(31,22,22):KPRINT "したときの";:KPRINT "ピッチ変化分";,RGB(31,22,22):KPRINT "を"
 4112 KPRINT " MIDIノート";,RGB(31,22,22):KPRINT "で表わしています｡"
 4113 KPRINT "･｢";:KPRINT "0";,RGB(22,22,0):KPRINT "～";:KPRINT "12";,RGB(22,22,0)
 4114 KPRINT "｣､および｢";:KPRINT "24";,RGB(22,22,0):KPRINT "｣が設定できます｡"
 4115 KPRINT "･｢";:KPRINT "12";,RGB(22,22,0):KPRINT "｣を設定したときは";:KPRINT "±1オクターブ";,RGB(31,22,22):KPRINT "､"
 4116 KPRINT " ｢";:KPRINT "24";,RGB(22,22,0):KPRINT "｣で最大";:KPRINT "±2オクターブ";,RGB(31,22,22):KPRINT "になります｡"
 4117 KPRINT "･まず";:KPRINT "初期値";,RGB(31,22,22):KPRINT "(";:KPRINT "12";,RGB(22,22,0)
 4118 KPRINT ":";:KPRINT "±1ｵｸﾀｰﾌﾞ";,RGB(31,22,22):KPRINT ")で鳴らします｡"
 4119 KPRINT FIX " EFFECT 1,"+CHR$(&H22)+"@44 C1~0;127;"+CHR$(&H22),RGB(31,31,0)
 4120 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4121 GOSUB *FADEIN
 4122 A$=INPUT$(1)
 4123 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 4124 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOSUB *TONE_RESET:GOTO *M_TUTORIAL_4_8
 4125 IF A$<>" "     THEN *M_TUTORIAL_4_9
 4126 TPROP(44,0,@AR)=20,0,0,15   :'ｴﾝﾍﾞﾛｰﾌﾟｦ ﾓﾄﾉｼﾞｮｳﾀｲﾆ ﾓﾄﾞｼﾃｲﾙ
 4127 EFFECT(ST),1,"@44 C1~0;127;"
 4128 GOSUB *KEYIN
 4129 VSYNC 2:PLAYSTOP ST
 4130 IF A$="0"      THEN *MAIN_MENU
 4131 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_4_8
 4132 IF A$<>" "     THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_4_9
 4133 '-------------
 4134 *M_TUTORIAL_4_10
 4135 KPRINT (10,20,0,1,0)
 4136 KPRINT "音色を加工してみよう！          11/18",,,RGB(20,0,20)
 4137 KPRINT "･次に";:KPRINT "±2オクターブ";,RGB(31,22,22):KPRINT "に設定して､";:KPRINT "同じMML",RGB(31,22,22)
 4138 KPRINT " を実行してみます｡":KPRINT (10,71,0,-7,0),FIX " TPROP(44,0,@BEND)=24",RGB(31,31,0)
 4139 KPRINT FIX " EFFECT 1,"+CHR$(&H22)+"@44 C1~0;127;"+CHR$(&H22),RGB(31,31,0):KPRINT ""
 4140 KPRINT (10,105,0,1,0),"★ベンド･レンジの初期値は音色によって",RGB(22,22,0):KPRINT "  異なりますので注意して下さい｡",RGB(22,22,0)
 4141 KPRINT "":KPRINT ""
 4142 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4143 GOSUB *FADEIN
 4144 A$=INPUT$(1)
 4145 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 4146 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOSUB *TONE_RESET:GOTO *M_TUTORIAL_4_9
 4147 IF A$<>" "     THEN *M_TUTORIAL_4_10
 4148 TPROP(44,0,@BEND)=24
 4149 EFFECT(ST),1,"@44 C1~0;127;"
 4150 GOSUB *KEYIN
 4151 VSYNC 2:PLAYSTOP ST
 4152 IF A$="0"      THEN *MAIN_MENU
 4153 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_4_9
 4154 IF A$<>" "     THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_4_10
 4155 '-------------
 4156 *M_TUTORIAL_4_11
 4157 KPRINT (10,20,0,1,0)
 4158 KPRINT "音色を加工してみよう！          12/18",,,RGB(20,0,20)
 4159 KPRINT "･次に";:KPRINT "±半音";,RGB(31,22,22):KPRINT "に設定して､";
 4160 KPRINT "同じMML";,RGB(31,22,22):KPRINT "を実行し"
 4161 KPRINT " てみます｡":KPRINT (10,71,0,-7,0),FIX " TPROP(44,0,@BEND)=1",RGB(31,31,0)
 4162 KPRINT FIX " EFFECT 1,"+CHR$(&H22)+"@44 C1~0;127;"+CHR$(&H22),RGB(31,31,0)
 4163 KPRINT "":KPRINT (10,105,0,1,0),"･このように､ピッチ･ベンドを最大幅で指":KPRINT " 定しても､レンジが狭い場合は効果が小"
 4164 KPRINT " さくなります｡":KPRINT " (0を指定した場合はピッチが変わらない)"
 4165 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4166 GOSUB *FADEIN
 4167 A$=INPUT$(1)
 4168 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 4169 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOSUB *TONE_RESET:GOTO *M_TUTORIAL_4_10
 4170 IF A$<>" "     THEN *M_TUTORIAL_4_11
 4171 TPROP(44,0,@BEND)=1
 4172 EFFECT(ST),1,"@44 C1~0;127;"
 4173 GOSUB *KEYIN
 4174 VSYNC 2:PLAYSTOP ST
 4175 IF A$="0"      THEN *MAIN_MENU
 4176 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_4_10
 4177 IF A$<>" "     THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_4_11
 4178 '-------------
 4179 *M_TUTORIAL_4_12
 4180 KPRINT (10,20,0,1,0)
 4181 KPRINT "音色を加工してみよう！          13/18",,,RGB(20,0,20)
 4182 KPRINT "･";:KPRINT "LFO";,RGB(31,22,22):KPRINT "(ロー･フリケンシー･オシレータ)を "
 4183 KPRINT " 使ってみましょう｡これは､";:KPRINT "音声信号の変",RGB(31,22,22)
 4184 KPRINT " 調用";,RGB(31,22,22):KPRINT "として使用されます｡"
 4185 KPRINT "･";:KPRINT "音色単位";,RGB(31,22,22):KPRINT "に､";:KPRINT "ALFO";,RGB(31,22,22)
 4186 KPRINT "(振幅変調)と";:KPRINT "PLFO";,RGB(31,22,22):KPRINT "(周波"
 4187 KPRINT " 数変調)の";:KPRINT "波形";,RGB(31,22,22):KPRINT "と";
 4188 KPRINT "変調度";,RGB(31,22,22):KPRINT "を";:KPRINT "独立して制御",RGB(31,22,22):KPRINT " することができます｡"
 4189 KPRINT " (発振周波数だけはALFO/PLFO共通です)":KPRINT "･出力波形は､";:KPRINT "のこぎり波";,RGB(31,22,22):KPRINT "､";
 4190 KPRINT "矩形波";,RGB(31,22,22):KPRINT "､";:KPRINT "三角波";,RGB(31,22,22):KPRINT "､"
 4191 KPRINT " ホワイト･ノイズ";,RGB(31,22,22):KPRINT "の";:KPRINT "4種類";,RGB(22,22,0):KPRINT "から選べます｡"
 4192 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4193 GOSUB *KEYIN
 4194 IF A$="0"      THEN *MAIN_MENU
 4195 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_4_11
 4196 IF A$<>" "     THEN *M_TUTORIAL_4_12
 4197 '-------------
 4198 *M_TUTORIAL_4_13
 4199 KPRINT (10,20,0,1,0)
 4200 KPRINT "音色を加工してみよう！          14/18",,,RGB(20,0,20)
 4201 KPRINT "･まず､";:KPRINT "ALFO";,RGB(31,22,22):KPRINT "(振幅変調)をかけてみます｡  "
 4202 KPRINT "･この振幅変調により､";:KPRINT "トレモロ効果";,RGB(31,22,22):KPRINT "(音量"
 4203 KPRINT " を周期的に変動)を表現することができ":KPRINT " ます｡"
 4204 KPRINT "･項目番号｢";:KPRINT "52";,RGB(22,22,0):KPRINT "｣で､";
 4205 KPRINT "ALFO波形";,RGB(31,22,22):KPRINT "を三角波(";:KPRINT "2";,RGB(22,22,0):KPRINT ")に"
 4206 KPRINT " 設定し､項目番号｢";:KPRINT "53";,RGB(22,22,0):KPRINT "｣で､";:KPRINT "振幅変調度";,RGB(31,22,22):KPRINT "を最"
 4207 KPRINT " 大(";:KPRINT "7";,RGB(22,22,0):KPRINT ")にしてみます(同時指定できます)｡"
 4208 KPRINT (10,156,0,-7,0),FIX " TPROP(44,0,@ALFOWS)=2,7",RGB(31,31,0)
 4209 KPRINT FIX " EFFECT "+CHR$(&H22)+"@44 O3 L2 CDEFGAB>C"+CHR$(&H22),RGB(31,31,0)
 4210 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4211 GOSUB *FADEIN
 4212 A$=INPUT$(1)
 4213 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 4214 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOSUB *TONE_RESET:GOTO *M_TUTORIAL_4_12
 4215 IF A$<>" "     THEN *M_TUTORIAL_4_13
 4216 TPROP(44,0,@ALFOWS)=2,7:TPROP(44,0,@LFOF)=10
 4217 EFFECT(ST),1,"@44 O3 L2 CDEFGAB>C"
 4218 GOSUB *KEYIN
 4219 VSYNC 2:PLAYSTOP ST
 4220 IF A$="0"      THEN *MAIN_MENU
 4221 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_4_12
 4222 IF A$<>" "     THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_4_13
 4223 '-------------
 4224 *M_TUTORIAL_4_14
 4225 KPRINT (10,20,0,1,0)
 4226 KPRINT "音色を加工してみよう！          15/18",,,RGB(20,0,20)
 4227 KPRINT "･項目番号｢";:KPRINT "51";,RGB(22,22,0):KPRINT "｣で､";:KPRINT "LFO周波数";,RGB(31,22,22):KPRINT "を上げてみま"
 4228 KPRINT " しょう｡"
 4229 KPRINT "･";:KPRINT "0";,RGB(22,22,0):KPRINT "～";:KPRINT "31";,RGB(22,22,0):KPRINT "まで指定できます｡実際の周波数と"
 4230 KPRINT " の対応はマニュアルを参照して下さい｡ ":KPRINT "･ここでは｢";:KPRINT "21";,RGB(22,22,0):KPRINT "｣を設定し､";
 4231 KPRINT "7.18";,RGB(22,22,0):KPRINT "Hz";,RGB(31,22,22):KPRINT "を与えて ":KPRINT " います｡"
 4232 KPRINT (10,139,0,-7,0),FIX " TPROP(44,0,@LFOF)=21",RGB(31,31,0)
 4233 KPRINT FIX " EFFECT "+CHR$(&H22)+"@44 O3 L2 CDEFGAB>C"+CHR$(&H22),RGB(31,31,0):KPRINT (10,173,0,1,0),"･";:KPRINT "LFO";,RGB(22,22,31):KPRINT "命令を使っても動作は同じです｡"
 4234 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4235 GOSUB *FADEIN
 4236 A$=INPUT$(1)
 4237 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 4238 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOSUB *TONE_RESET:GOTO *M_TUTORIAL_4_13
 4239 IF A$<>" "     THEN *M_TUTORIAL_4_14
 4240 TPROP(44,0,@ALFOWS)=2,7
 4241 TPROP(44,0,@LFOF)=21
 4242 EFFECT(ST),1,"@44 O3 L2 CDEFGAB>C"
 4243 GOSUB *KEYIN
 4244 VSYNC 2:PLAYSTOP ST
 4245 IF A$="0"      THEN *MAIN_MENU
 4246 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_4_13
 4247 IF A$<>" "     THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_4_14
 4248 '-------------
 4249 *M_TUTORIAL_4_15
 4250 KPRINT (10,20,0,1,0)
 4251 KPRINT "音色を加工してみよう！          16/18",,,RGB(20,0,20)
 4252 KPRINT "･次に､";:KPRINT "PLFO";,RGB(31,22,22):KPRINT "(周波数変調)をかけてみます｡"
 4253 KPRINT "･この周波数変調により､";:KPRINT "ビブラート効果",RGB(31,22,22)
 4254 KPRINT " (音の発振周波数を周期的に変動)を表現":KPRINT " することができます｡"
 4255 KPRINT "･ALFOを初期化し､項目番号｢";:KPRINT "54";,RGB(22,22,0):KPRINT "｣で､";:KPRINT "PLFO波",RGB(31,22,22)
 4256 KPRINT " 形";,RGB(31,22,22):KPRINT "を三角波(";:KPRINT "2";,RGB(22,22,0)
 4257 KPRINT ")に設定し､項目番号｢";:KPRINT "55";,RGB(22,22,0):KPRINT "｣で"
 4258 KPRINT " 周波数変調度";,RGB(31,22,22):KPRINT "を最大(";:KPRINT "7";,RGB(22,22,0):KPRINT ")にしてみます｡"
 4259 KPRINT (10,156,0,-7,0),FIX " TPROP(44,0,@ALFOS)=0,2,7 ",RGB(31,31,0)
 4260 KPRINT FIX " EFFECT "+CHR$(&H22)+"@44 O3 L2 CDEFGAB>C"+CHR$(&H22),RGB(31,31,0)
 4261 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4262 GOSUB *FADEIN
 4263 A$=INPUT$(1)
 4264 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 4265 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOSUB *TONE_RESET:GOTO *M_TUTORIAL_4_14
 4266 IF A$<>" "     THEN *M_TUTORIAL_4_15
 4267 TPROP(44,0,@LFOF)=21,,0,2,7
 4268 EFFECT(ST),1,"@44 O3 L2 CDEFGAB>C"
 4269 GOSUB *KEYIN
 4270 VSYNC 2:PLAYSTOP ST
 4271 IF A$="0"      THEN *MAIN_MENU
 4272 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_4_14
 4273 IF A$<>" "     THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_4_15
 4274 '-------------
 4275 *M_TUTORIAL_4_16
 4276 KPRINT (10,20,0,1,0)
 4277 KPRINT "音色を加工してみよう！          17/18",,,RGB(20,0,20)
 4278 KPRINT "･";:KPRINT "TARG";,RGB(22,22,31):KPRINT "命令を使って同じ音色を複数コピー"
 4279 KPRINT " し､それぞれ異なった音色加工をするこ":KPRINT " とによって､表現の幅が広がります｡"
 4280 KPRINT "★";:KPRINT "同じ音色を複数コピー";,RGB(31,22,22):KPRINT "しても､波形デー"
 4281 KPRINT "  タは";:KPRINT "1つ分の領域";,RGB(31,22,22):KPRINT "しか占有しません｡   "
 4282 KPRINT "  オリジナルの波形データを";:KPRINT "どのように",RGB(31,22,22)
 4283 KPRINT "  鳴らすか";,RGB(31,22,22):KPRINT "というデータが別に存在し､音":KPRINT "  色の加工はそのデータに対して操作さ"
 4284 KPRINT "  れます｡"
 4285 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4286 GOSUB *KEYIN
 4287 IF A$="0"      THEN *MAIN_MENU
 4288 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_4_15
 4289 IF A$<>" "     THEN *M_TUTORIAL_4_16
 4290 '-------------
 4291 *M_TUTORIAL_4_17
 4292 KPRINT (10,20,0,1,0)
 4293 KPRINT "音色を加工してみよう！          18/18",,,RGB(20,0,20)
 4294 KPRINT "･";:KPRINT "Strings";,RGB(31,22,22):KPRINT "の波形を";:KPRINT "4";,RGB(22,22,0):KPRINT "つコピーし､それぞれ "
 4295 KPRINT " 別の音色加工を施します｡":KPRINT " (";:KPRINT "1";,RGB(22,22,0):KPRINT "番目の音色だけオリジナルのまま)"
 4296 KPRINT (10,88,0,-7,0),FIX " CLEAR ,1360",RGB(31,31,0):KPRINT FIX " TARG "+CHR$(&H22)+"STANDARD"+CHR$(&H22)+",44,44,44,44",RGB(31,31,0)
 4297 KPRINT FIX " TPROP(2,0,@AR)=8",RGB(31,31,0):KPRINT FIX " TPROP(3,0,@LFOF)=21,2,7",RGB(31,31,0)
 4298 KPRINT FIX " TPROP(4,0,@LFOF)=19,,,2,6",RGB(31,31,0)
 4299 KPRINT FIX " EFFECT"+CHR$(&H22)+"O3L2 @1CDE @2FGA @3B>CD @4EFG"+CHR$(&H22),RGB(31,31,0)
 4300 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4301 GOSUB *FADEIN
 4302 A$=INPUT$(1)
 4303 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 4304 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOSUB *TONE_RESET:GOTO *M_TUTORIAL_4_16
 4305 IF A$<>" "     THEN *M_TUTORIAL_4_17
 4306 CLS:PRINT "Loading STANDARD Set..."
 4307 TARG "STANDARD",44,44,44,44:CLS              :'@1 ｵﾘｼﾞﾅﾙﾉﾏﾏ
 4308 TPROP(2,0,@AR)=8                             :'@2 ｱﾀｯｸ･ﾚｰﾄｦ ﾍﾝｺｳ
 4309 TPROP(3,0,@LFOF)=21,2,7                      :'@3 ALFO
 4310 TPROP(4,0,@LFOF)=19,,,2,6                    :'@4 PLFO
 4311 EFFECT(ST),1,"O3L2 O3L2 @1CDE @2FGA @3B>CD @4EFG"
 4312 GOSUB *KEYIN
 4313 VSYNC 2:PLAYSTOP ST
 4314 IF A$="0"      THEN *MAIN_MENU
 4315 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_4_16
 4316 IF A$<>" "     THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_4_17
 4317 '-------------
 4318 GOTO *M_TUTORIAL
 4319 '--------------------------------------------------------------------------------------------------------
 4320 *M_TUTORIAL_5_1
 4321 TR_FLAG=1
 4322 KPRINT (10,20,0,1,0)
 4323 KPRINT "DSPエフェクターを使ってみよう！  1/11",,,RGB(20,0,20)
 4324 KPRINT "･";:KPRINT "DSPエフェクター";,RGB(31,22,22):KPRINT "は､通常の音声信号線と"
 4325 KPRINT " は";:KPRINT "独立したモジュール";,RGB(31,22,22):KPRINT "になっています｡ "
 4326 KPRINT "･使用するにあたって､";:KPRINT "結線作業";,RGB(31,22,22):KPRINT "､";:KPRINT "入力混合",RGB(31,22,22)
 4327 KPRINT " レベル";,RGB(31,22,22):KPRINT "､";:KPRINT "出力レベル";,RGB(31,22,22):KPRINT "の調整を行なわなけ "
 4328 KPRINT " ればなりません(ミキサー制御)｡":KPRINT "･音色によっては予め設定されているもの"
 4329 KPRINT " がありますので､入力混合レベルが｢";:KPRINT "0";,RGB(22,22,0):KPRINT "｣";:KPRINT "以",RGB(31,22,22)
 4330 KPRINT " 外";,RGB(31,22,22):KPRINT "になっていれば､DSPモードに切り替え":KPRINT " るだけでエフェクトがかかります｡"
 4331 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4332 GOSUB *KEYIN
 4333 IF A$="0"      THEN *MAIN_MENU
 4334 IF A$=CHR$(13) THEN *M_TUTORIAL
 4335 IF A$<>" "     THEN *M_TUTORIAL_5_1
 4336 '-------------
 4337 *M_TUTORIAL_5_2
 4338 KPRINT (10,20,0,1,0)
 4339 KPRINT "DSPエフェクターを使ってみよう！  2/11",,,RGB(20,0,20)
 4340 KPRINT "･";:KPRINT "2";,RGB(22,22,0):KPRINT "種類のDSPモードが用意されています｡ "
 4341 KPRINT "【シングル･エフェクター･モード】",RGB(31,31,0):KPRINT FIX " PLAYINIT "+CHR$(&H22)+"DSP"+CHR$(&H22),RGB(31,31,20)
 4342 KPRINT "･複数のエフェクター･モジュールをMMLの":KPRINT " ｢";:KPRINT FIX "ec";,RGB(31,31,20):KPRINT "｣コマンドで";
 4343 KPRINT "切り替えて";,RGB(31,22,22):KPRINT "使います｡   ":KPRINT "【マルチ･エフェクター･モード】",RGB(31,31,0)
 4344 KPRINT FIX " PLAYINIT "+CHR$(&H22)+"DSPEXT"+CHR$(&H22),RGB(31,31,20):KPRINT "･複数のエフェクター･モジュールを音色 "
 4345 KPRINT " データ側で";:KPRINT "振り分け";,RGB(31,22,22):KPRINT "､";:KPRINT "同時に";,RGB(31,22,22):KPRINT "使います｡"
 4346 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4347 GOSUB *KEYIN
 4348 IF A$="0"      THEN *MAIN_MENU
 4349 IF A$=CHR$(13) THEN *M_TUTORIAL_5_1
 4350 IF A$<>" "     THEN *M_TUTORIAL_5_2
 4351 '-------------
 4352 *M_TUTORIAL_5_3
 4353 KPRINT (10,20,0,1,0)
 4354 KPRINT "DSPエフェクターを使ってみよう！  3/11",,,RGB(20,0,20)
 4355 KPRINT "･";:KPRINT "シングル･エフェクター･モード";,RGB(31,22,22):KPRINT "を使って":KPRINT " みましょう｡"
 4356 KPRINT FIX " PLAYINIT "+CHR$(&H22)+"DSP"+CHR$(&H22),RGB(31,31,20):KPRINT "･これで､DSPが使える状態になります｡"
 4357 KPRINT "･同時に";:KPRINT "1";,RGB(22,22,0):KPRINT "種類しかエフェクターが使えな "
 4358 KPRINT " いので､";:KPRINT "入力選択";,RGB(31,22,22):KPRINT "(項目70)は｢";
 4359 KPRINT "0";,RGB(22,22,0):KPRINT "｣";:KPRINT "固定";,RGB(31,22,22):KPRINT "です｡"
 4360 KPRINT "･初期状態では､";:KPRINT "すべての音色";,RGB(31,22,22):KPRINT "が｢";:KPRINT "0";,RGB(22,22,0):KPRINT "｣に設定"
 4361 KPRINT " されていますので､書き換える必要はあ ":KPRINT " りません｡"
 4362 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4363 GOSUB *KEYIN
 4364 IF A$="0"      THEN *MAIN_MENU
 4365 IF A$=CHR$(13) THEN *M_TUTORIAL_5_2
 4366 IF A$<>" "     THEN *M_TUTORIAL_5_3
 4367 '-------------
 4368 *M_TUTORIAL_5_4
 4369 KPRINT (10,20,0,1,0)
 4370 KPRINT "DSPエフェクターを使ってみよう！  4/11",,,RGB(20,0,20)
 4371 KPRINT "･";:KPRINT "Strings";,RGB(31,22,22):KPRINT "の音色を使って､";:KPRINT "通常モード";,RGB(31,22,22):KPRINT "と"
 4372 KPRINT " DSPモード";,RGB(31,22,22):KPRINT "を聞き比べてみましょう｡"
 4373 KPRINT "･初期状態の";:KPRINT "Strings";,RGB(31,22,22):KPRINT "は､";
 4374 KPRINT "入力選択";,RGB(31,22,22):KPRINT "が｢";:KPRINT "0";,RGB(22,22,0):KPRINT "｣､";:KPRINT "混",RGB(31,22,22)
 4375 KPRINT " 合レベル";,RGB(31,22,22):KPRINT "が｢";:KPRINT "6";,RGB(22,22,0)
 4376 KPRINT "｣になっているため､";:KPRINT "リバー",RGB(31,22,22):KPRINT " ブ";,RGB(31,22,22):KPRINT "がかかります｡"
 4377 KPRINT FIX " EFFECT "+CHR$(&H22)+"@44 O3 CDEFGAB"+CHR$(&H22);,RGB(31,31,0):KPRINT " ←通常モード",RGB(0,31,0)
 4378 KPRINT (10,139,0,-7,0),FIX " PLAYINIT "+CHR$(&H22)+"DSP"+CHR$(&H22);,RGB(31,31,0):KPRINT "          ←DSPモード ",RGB(0,31,0)
 4379 KPRINT FIX " EFFECT "+CHR$(&H22)+"@44 O3 CDEFGAB"+CHR$(&H22),RGB(31,31,0):KPRINT ""
 4380 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4381 GOSUB *FADEIN
 4382 A$=INPUT$(1)
 4383 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 4384 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOSUB *TONE_RESET:GOTO *M_TUTORIAL_5_3
 4385 IF A$<>" "     THEN *M_TUTORIAL_5_4
 4386 PLAY "@44 O3 CDEFGABR"
 4387 IF TR_FLAG=1 THEN CLS:PRINT "Init.DSP Program...":PLAYINIT "DSP","STANDARD":CLS:TR_FLAG=0
 4388 EFFECT(ST),1,"@44 O3 CDEFGAB"
 4389 GOSUB *KEYIN
 4390 VSYNC 2:PLAYSTOP ST
 4391 IF A$="0"      THEN *MAIN_MENU
 4392 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_5_3
 4393 IF A$<>" "     THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_5_4
 4394 '-------------
 4395 *M_TUTORIAL_5_5
 4396 KPRINT (10,20,0,1,0)
 4397 KPRINT "DSPエフェクターを使ってみよう！  5/11",,,RGB(20,0,20)
 4398 KPRINT "･";:KPRINT "入力混合レベル";,RGB(31,22,22):KPRINT "は､";:KPRINT "TPROP";,RGB(22,22,31):KPRINT "命令の項目番号"
 4399 KPRINT " ｢";:KPRINT "71";,RGB(22,22,0):KPRINT "｣で設定します(DSP命令の[レベル])｡":KPRINT "･入力混合レベルを最大にして､エフェク "
 4400 KPRINT " ターに送る信号量を増やしてみます｡   "
 4401 KPRINT (10,105,0,-7,0),FIX " TPROP(44,0,@IMIX)=7";,RGB(31,31,0):KPRINT "     ←最大レベル",RGB(0,31,0)
 4402 KPRINT FIX " EFFECT "+CHR$(&H22)+"@44 O3 CDEFGAB"+CHR$(&H22),RGB(31,31,0)
 4403 KPRINT (10,139,0,1,0),"★音色別初期値はﾏﾆｭｱﾙで確認して下さい｡",RGB(22,22,0):KPRINT "★出力レベルを設定するものではありま ",RGB(22,22,0)
 4404 KPRINT "  せん(出力レベルはMMLの｢";,RGB(22,22,0):KPRINT FIX "el";,RGB(31,31,20):KPRINT "｣コマンド)｡",RGB(22,22,0)
 4405 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4406 GOSUB *FADEIN
 4407 A$=INPUT$(1)
 4408 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 4409 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOSUB *TONE_RESET:GOTO *M_TUTORIAL_5_4
 4410 IF A$<>" "     THEN *M_TUTORIAL_5_5
 4411 IF TR_FLAG=1 THEN CLS:PRINT "Init.DSP Program...":PLAYINIT "DSP","STANDARD":CLS:TR_FLAG=0
 4412 TPROP(44,0,@IMIX)=7
 4413 EFFECT(ST),1,"@44 O3 CDEFGAB"
 4414 GOSUB *KEYIN
 4415 VSYNC 2:PLAYSTOP ST
 4416 IF A$="0"      THEN *MAIN_MENU
 4417 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_5_4
 4418 IF A$<>" "     THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_5_5
 4419 '-------------
 4420 *M_TUTORIAL_5_6
 4421 KPRINT (10,20,0,1,0)
 4422 KPRINT "DSPエフェクターを使ってみよう！  6/11",,,RGB(20,0,20)
 4423 KPRINT "･";:KPRINT "入力混合レベル";,RGB(31,22,22):KPRINT "は､";
 4424 KPRINT "0";,RGB(22,22,0):KPRINT "～";:KPRINT "7";,RGB(22,22,0):KPRINT "まで設定できま "
 4425 KPRINT " すが､設定値によって";:KPRINT "入力可能な音数";,RGB(31,22,22):KPRINT "が "
 4426 KPRINT " 変わってきますので注意して下さい｡":KPRINT " (音の歪みの原因になります)"
 4427 KPRINT "･入力混合レベルを小さくして､エフェク":KPRINT " ターに送る信号量を減らしてみます｡"
 4428 KPRINT (10,139,0,-7,0),FIX " TPROP(44,0,@IMIX)=4";,RGB(31,31,0):KPRINT "     ←弱くした",RGB(0,31,0)
 4429 KPRINT FIX " EFFECT "+CHR$(&H22)+"@44 O3 CDEFGAB"+CHR$(&H22),RGB(31,31,0):KPRINT (10,173,0,1,0),FIX " DSP ON 44,0,0,4 ";,RGB(31,31,20):KPRINT "でも設定できます｡"
 4430 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4431 GOSUB *FADEIN
 4432 A$=INPUT$(1)
 4433 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 4434 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOSUB *TONE_RESET:GOTO *M_TUTORIAL_5_5
 4435 IF A$<>" "     THEN *M_TUTORIAL_5_6
 4436 IF TR_FLAG=1 THEN CLS:PRINT "Init.DSP Program...":PLAYINIT "DSP","STANDARD":CLS:TR_FLAG=0
 4437 TPROP(44,0,@IMIX)=4
 4438 EFFECT(ST),1,"@44 O3 CDEFGAB"
 4439 GOSUB *KEYIN
 4440 VSYNC 2:PLAYSTOP ST
 4441 IF A$="0"      THEN *MAIN_MENU
 4442 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_5_5
 4443 IF A$<>" "     THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_5_6
 4444 '-------------
 4445 *M_TUTORIAL_5_7
 4446 KPRINT (10,20,0,1,0)
 4447 KPRINT "DSPエフェクターを使ってみよう！  7/11",,,RGB(20,0,20)
 4448 KPRINT "･";:KPRINT "シングル･エフェクター･モード";,RGB(31,22,22):KPRINT "では､MML"
 4449 KPRINT " の｢";:KPRINT FIX "ec";,RGB(31,31,20):KPRINT "｣(";
 4450 KPRINT "エフェクト･チェンジ";,RGB(31,22,22):KPRINT ")コマンド ":KPRINT " を使って以下のエフェクターに切り替え"
 4451 KPRINT " ることができます｡"
 4452 KPRINT "  ｢";:KPRINT FIX "ec0";,RGB(31,31,20):KPRINT "｣… ";:KPRINT "リバーブ1";,RGB(31,22,22):KPRINT "(ステレオ)"
 4453 KPRINT "  ｢";:KPRINT FIX "ec1";,RGB(31,31,20):KPRINT "｣… ";:KPRINT "リバーブ2";,RGB(31,22,22):KPRINT "(ステレオ)"
 4454 KPRINT "  ｢";:KPRINT FIX "ec2";,RGB(31,31,20):KPRINT "｣… ";:KPRINT "ディレイ";,RGB(31,22,22):KPRINT " (ステレオ)"
 4455 KPRINT "  ｢";:KPRINT FIX "ec3";,RGB(31,31,20):KPRINT "｣… ";:KPRINT "ディストーション";,RGB(31,22,22)
 4456 KPRINT "(モノラル) ":KPRINT "★初期状態は｢";,RGB(22,22,0):KPRINT FIX "ec0";,RGB(31,31,20):KPRINT "｣です｡",RGB(22,22,0)
 4457 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4458 GOSUB *KEYIN
 4459 IF A$="0"      THEN *MAIN_MENU
 4460 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_5_6
 4461 IF A$<>" "     THEN *M_TUTORIAL_5_7
 4462 '-------------
 4463 *M_TUTORIAL_5_8
 4464 KPRINT (10,20,0,1,0)
 4465 KPRINT "DSPエフェクターを使ってみよう！  8/11",,,RGB(20,0,20)
 4466 KPRINT "･エフェクターを切り替えながら､順番に":KPRINT " 鳴らしてみましょう｡"
 4467 KPRINT "･｢";:KPRINT FIX "ec";,RGB(31,31,20):KPRINT "｣コマンドは､実行してから切り替わ "
 4468 KPRINT " るまでに";:KPRINT "若干時間がかかります";,RGB(31,22,22):KPRINT "ので､最 "
 4469 KPRINT " 初に休符コマンド｢";:KPRINT FIX "R";,RGB(31,31,20):KPRINT "｣を挿入しています｡"
 4470 KPRINT (10,122,0,-7,0),FIX " TPROP(44,0,@IMIX)=7";,RGB(31,31,0):KPRINT "     ←最大レベル",RGB(0,31,0)
 4471 KPRINT FIX " EFFECT "+CHR$(&H22)+"@44 O3 ec1 R2 CDEFGAB"+CHR$(&H22),RGB(31,31,0)
 4472 KPRINT FIX " EFFECT "+CHR$(&H22)+"@44 O3 ec2 R2 CDEFGAB"+CHR$(&H22),RGB(31,31,0)
 4473 KPRINT FIX " EFFECT "+CHR$(&H22)+"@44 O3 ec3 R2 CDEFGAB"+CHR$(&H22),RGB(31,31,0)
 4474 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4475 GOSUB *FADEIN
 4476 A$=INPUT$(1)
 4477 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 4478 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOSUB *TONE_RESET:GOTO *M_TUTORIAL_5_7
 4479 IF A$<>" "     THEN *M_TUTORIAL_5_8
 4480 IF TR_FLAG=1 THEN CLS:PRINT "Init.DSP Program...":PLAYINIT "DSP","STANDARD":CLS:TR_FLAG=0
 4481 TPROP(44,0,@IMIX)=7
 4482 EFFECT(ST),1,"@44 O3 ec1 R2 CDEFGAB R2 @44 O3 ec2 R CDEFGAB R2 @44 O3 ec3 R CDEFGAB"
 4483 GOSUB *KEYIN
 4484 VSYNC 2:PLAYSTOP ST
 4485 IF A$="0"      THEN *MAIN_MENU
 4486 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_5_7
 4487 IF A$<>" "     THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_5_8
 4488 '-------------
 4489 *M_TUTORIAL_5_9
 4490 KPRINT (10,20,0,1,0)
 4491 KPRINT "DSPエフェクターを使ってみよう！  9/11",,,RGB(20,0,20)
 4492 KPRINT "･エフェクト･データの";:KPRINT "出力レベル";,RGB(31,22,22)
 4493 KPRINT "は､｢";:KPRINT FIX "el";,RGB(31,31,20):KPRINT "｣"
 4494 KPRINT " (";:KPRINT "エフェクト･レベル";,RGB(31,22,22):KPRINT ")コマンドで変えら ":KPRINT " れます｡"
 4495 KPRINT "･エフェクト･データの";:KPRINT "定位";,RGB(31,22,22):KPRINT "は､｢";
 4496 KPRINT FIX "ep";,RGB(31,31,20):KPRINT "｣(";:KPRINT "エフ",RGB(31,22,22)
 4497 KPRINT " ェクト･パン";,RGB(31,22,22):KPRINT ")コマンドで変えられます｡ "
 4498 KPRINT "":KPRINT "･これらのMMLコマンドは､";:KPRINT "ミキサー設定";,RGB(31,22,22):KPRINT "に"
 4499 KPRINT " 関するものなので､どのトラックに記述 ":KPRINT " しても効果は同じです｡"
 4500 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4501 GOSUB *KEYIN
 4502 IF A$="0"      THEN *MAIN_MENU
 4503 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_5_8
 4504 IF A$<>" "     THEN *M_TUTORIAL_5_9
 4505 '-------------
 4506 *M_TUTORIAL_5_10
 4507 KPRINT (10,20,0,1,0)
 4508 KPRINT "DSPエフェクターを使ってみよう！ 10/11",,,RGB(20,0,20)
 4509 KPRINT "･次に､";:KPRINT "マルチ･エフェクター･モード";,RGB(31,22,22):KPRINT "を使 ":KPRINT " ってみましょう｡"
 4510 KPRINT FIX " PLAYINIT "+CHR$(&H22)+"DSPEXT"+CHR$(&H22),RGB(31,31,20)
 4511 KPRINT "･これで､";:KPRINT "3";,RGB(22,22,0):KPRINT "種類のエフェクターを";:KPRINT "音色単位",RGB(31,22,22)
 4512 KPRINT " に使い分けられるようになります｡"
 4513 KPRINT "･";:KPRINT "入力選択に設定する値";,RGB(31,22,22):KPRINT "は以下の通りです｡"
 4514 KPRINT FIX "TPROP(*,*,@ISEL)=0";,RGB(31,31,20):KPRINT "ﾘﾊﾞｰﾌﾞ";,RGB(31,22,22):KPRINT "(出力ﾐｷｻ 0､1)"
 4515 KPRINT FIX "TPROP(*,*,@ISEL)=1";,RGB(31,31,20):KPRINT "ﾃﾞｨﾚｲ ";,RGB(31,22,22):KPRINT "(出力ﾐｷｻ 2､3)"
 4516 KPRINT FIX "TPROP(*,*,@ISEL)=2";,RGB(31,31,20):KPRINT "ﾃﾞｨｽﾄｰｼｮﾝ";,RGB(31,22,22):KPRINT "（出力 4) "
 4517 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4518 GOSUB *KEYIN
 4519 IF A$="0"      THEN *MAIN_MENU
 4520 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_5_9
 4521 IF A$<>" "     THEN *M_TUTORIAL_5_10
 4522 '-------------
 4523 *M_TUTORIAL_5_11
 4524 KPRINT (10,20,0,1,0)
 4525 KPRINT "DSPエフェクターを使ってみよう！ 11/11",,,RGB(20,0,20)
 4526 KPRINT "･";:KPRINT "Strings";,RGB(31,22,22):KPRINT "(";:KPRINT FIX "@44";,RGB(31,31,20)
 4527 KPRINT ")に";:KPRINT "ﾘﾊﾞｰﾌﾞ";,RGB(31,22,22):KPRINT "､";:KPRINT "A.Piano";,RGB(31,22,22)
 4528 KPRINT "(";:KPRINT FIX "@36";,RGB(31,31,20):KPRINT ")に "
 4529 KPRINT " ﾃﾞｨﾚｲ";,RGB(31,22,22):KPRINT "､";:KPRINT "O.D.Guitar";,RGB(31,22,22)
 4530 KPRINT "(";:KPRINT FIX "@41";,RGB(31,31,20):KPRINT ")に";:KPRINT "ﾃﾞｨｽﾄｰｼｮﾝ";,RGB(31,22,22):KPRINT "をか"
 4531 KPRINT " けて､通常モードと比較してみましょう｡"
 4532 KPRINT "(出力ﾚﾍﾞﾙの高いﾃﾞｨｽﾄｰｼｮﾝを｢el｣で調整)"
 4533 KPRINT (10,105,0,-7,0),FIX " EFFECT "+CHR$(&H22)+"@36CDE @44CDE @41<B1~;0;",RGB(31,31,0)
 4534 KPRINT FIX " TPROP(44,0,@ISEL)=0,7",RGB(31,31,0):KPRINT FIX " TPROP(36,0,@ISEL)=1,7",RGB(31,31,0)
 4535 KPRINT FIX " TPROP(41,0,@ISEL)=2,7",RGB(31,31,0)
 4536 KPRINT FIX " EFFECT "+CHR$(&H22)+"@36CDE @44CDE @41el4;4<B1~;0;",RGB(31,31,0)
 4537 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4538 GOSUB *FADEIN
 4539 A$=INPUT$(1)
 4540 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 4541 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOSUB *TONE_RESET:GOTO *M_TUTORIAL_5_10
 4542 IF A$<>" "     THEN *M_TUTORIAL_5_11
 4543 GOSUB *TONE_RESET
 4544 PLAY "@36 CDE @44 CDE @41 <B1~;0;R"
 4545 CLS:PRINT "Init.DSPEXT Program...":PLAYINIT "DSPEXT","STANDARD":CLS:TR_FLAG=0
 4546 TPROP(44,0,@ISEL)=0,7
 4547 TPROP(36,0,@ISEL)=1,7
 4548 TPROP(41,0,@ISEL)=2,7
 4549 EFFECT(ST),1,"@36 R2 CDE @44 CDE @41 el4;4 <B1~;0;"
 4550 GOSUB *KEYIN
 4551 VSYNC 2:PLAYSTOP ST
 4552 IF A$="0"      THEN *MAIN_MENU
 4553 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_5_10
 4554 IF A$<>" "     THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_5_11
 4555 '-------------
 4556 GOTO *M_TUTORIAL
 4557 '--------------------------------------------------------------------------------------------------------
 4558 *M_TUTORIAL_6_1
 4559 KPRINT (10,20,0,1,0)
 4560 KPRINT "FM音源で音を作ろう！             1/17",,,RGB(20,0,20)
 4561 KPRINT "･";:KPRINT "TARG";,RGB(22,22,31):KPRINT "命令のレイヤー編集(";:KPRINT "BUILDLAYER";,RGB(31,22,22):KPRINT "～"
 4562 KPRINT " ENDLAYER";,RGB(31,22,22):KPRINT ")を使って､FM音源の音色を作成":KPRINT " することができます｡"
 4563 KPRINT "･FM音源は､サンプリング･データを使うPCM":KPRINT " 音源に比べて波形メモリを少なく抑える"
 4564 KPRINT " ことができます｡":KPRINT "･更に､";:KPRINT "取り込み音域に左右されない";,RGB(31,22,22):KPRINT "ので､"
 4565 KPRINT " 全域に渡って同レベルの音質";,RGB(31,22,22):KPRINT "で鳴らすこ":KPRINT " とができます｡"
 4566 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4567 GOSUB *KEYIN
 4568 IF A$="0"      THEN *MAIN_MENU
 4569 IF A$=CHR$(13) THEN *M_TUTORIAL
 4570 IF A$<>" "     THEN *M_TUTORIAL_6_1
 4571 '-------------
 4572 *M_TUTORIAL_6_2
 4573 KPRINT (10,20,0,1,0)
 4574 KPRINT "FM音源で音を作ろう！             2/17",,,RGB(20,0,20)
 4575 KPRINT "･従来のFM音源のスロット(オペレータ)結":KPRINT " 線をシミュレートできるので､過去の資 "
 4576 KPRINT " 産を移植して､BASICテキストの形で保存":KPRINT " しておくことができます｡"
 4577 KPRINT "･また､セガサターンのハードウェアは､";:KPRINT "32",RGB(22,22,0)
 4578 KPRINT " 個の発音スロットを";:KPRINT "自由に結線";,RGB(31,22,22):KPRINT "すること"
 4579 KPRINT " ができるので､幅広い音作りが可能です｡":KPRINT "★ｻﾝﾌﾟﾙ曲のｳﾞｪｲｸﾞｽやﾌｧｲﾔｰﾎｰｸは､当時の",RGB(22,22,0)
 4580 KPRINT "  FM音源の音色を再現しています｡",RGB(22,22,0)
 4581 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4582 GOSUB *KEYIN
 4583 IF A$="0"      THEN *MAIN_MENU
 4584 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_6_1
 4585 IF A$<>" "     THEN *M_TUTORIAL_6_2
 4586 '-------------
 4587 *M_TUTORIAL_6_3
 4588 KPRINT (10,20,0,1,0)
 4589 KPRINT "FM音源で音を作ろう！             3/17",,,RGB(20,0,20)
 4590 KPRINT "･まず､";:KPRINT "変調波形をそのままの形";,RGB(31,22,22):KPRINT "で鳴らし "
 4591 KPRINT " てみましょう(";:KPRINT FIX "W=9";,RGB(31,31,20):KPRINT "→のこぎり波)｡"
 4592 KPRINT "･パラメータが多いので2行にわけていま ":KPRINT " す(緑色の行はコメントです)｡"
 4593 KPRINT (10,105,0,-7,0),FIX "DATA BUILDLAYER",RGB(31,31,0):KPRINT FIX "REM   OP#,W,X,Y,  M,S, AR,DR,SR,RR,SL",RGB(0,31,0)
 4594 KPRINT FIX "DATA FM,1,";,RGB(31,31,0):KPRINT FIX "9";,RGB(31,31,20):KPRINT FIX ",1,1,  0,7, 31, 0, 0,31, 0",RGB(31,31,0)
 4595 KPRINT FIX "REM    TL, ml1,ml2, dt,KS",RGB(0,31,0):KPRINT FIX "DATA    0,  24,  0,  0, 0",RGB(31,31,0):KPRINT FIX "DATA ENDLAYER",RGB(31,31,0)
 4596 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4597 GOSUB *FADEIN
 4598 A$=INPUT$(1)
 4599 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 4600 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOSUB *TONE_RESET:GOTO *M_TUTORIAL_6_2
 4601 IF A$<>" "     THEN *M_TUTORIAL_6_3
 4602 CLS:PRINT "Init.FM..."
 4603 RESTORE *T63:TARG READ:CLS
 4604 *T63
 4605 DATA BUILDLAYER
 4606      'OP#,W,X,Y,  M,S, AR,DR,SR,RR,SL, TL, ml1,ml2, dt,KS
 4607 DATA FM,1,9,1,1,  0,7, 31, 0, 0,31, 0,  0,  24,  0,  0, 0
 4608 DATA ENDLAYER
 4609 DATA ENDARRANGE
 4610 EFFECT(ST),1,"@1 O3 V10 CDEFGAB>CDEFGAB>CDEFGAB>C"
 4611 GOSUB *KEYIN
 4612 VSYNC 2:PLAYSTOP ST
 4613 IF A$="0"      THEN *MAIN_MENU
 4614 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_6_2
 4615 IF A$<>" "     THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_6_3
 4616 '-------------
 4617 *M_TUTORIAL_6_4
 4618 KPRINT (10,20,0,1,0)
 4619 KPRINT "FM音源で音を作ろう！             4/17",,,RGB(20,0,20)
 4620 KPRINT "･｢";:KPRINT FIX "AR";,RGB(31,31,20):KPRINT "｣以降のパラメータは､";:KPRINT "エンベロープ",RGB(31,22,22)
 4621 KPRINT " 情報";,RGB(31,22,22):KPRINT "と";:KPRINT "トータル･レベル";,RGB(31,22,22)
 4622 KPRINT "､";:KPRINT "マルチプル";,RGB(31,22,22):KPRINT "に関":KPRINT " する設定ですので､ひとまず省略します｡"
 4623 KPRINT (10,88,0,-7,0),FIX "REM   OP#,W,X,Y,  M,S,...",RGB(0,31,0):KPRINT FIX "DATA FM,*,*,*,*,  *,*,...",RGB(31,31,0)
 4624 KPRINT (10,122,0,1,0),"･｢";:KPRINT FIX "FM";,RGB(31,31,20):KPRINT "｣に続き､";
 4625 KPRINT "ｵﾍﾟﾚｰﾀ番号";,RGB(31,22,22):KPRINT "｢";:KPRINT FIX "OP#";,RGB(31,31,20)
 4626 KPRINT "｣､";:KPRINT "変調波形",RGB(31,22,22)
 4627 KPRINT " ｢";:KPRINT FIX "W";,RGB(31,31,20):KPRINT "｣､";:KPRINT "変調入力";,RGB(31,22,22)
 4628 KPRINT "｢";:KPRINT FIX "X";,RGB(31,31,20):KPRINT "｣､";:KPRINT "変調入力";,RGB(31,22,22)
 4629 KPRINT "｢";:KPRINT FIX "Y";,RGB(31,31,20):KPRINT "｣､";:KPRINT "変調度";,RGB(31,22,22)
 4630 KPRINT "｢";:KPRINT FIX "M";,RGB(31,31,20):KPRINT "｣"
 4631 KPRINT " ﾀﾞｲﾚｸﾄﾃﾞｰﾀ送出ﾚﾍﾞﾙ";,RGB(31,22,22):KPRINT "｢";:KPRINT FIX "S";,RGB(31,31,20):KPRINT "｣を設定します｡"
 4632 KPRINT "･4ｵﾍﾟﾚｰﾀ結線を例に､音色を作ってみます｡",RGB(31,31,0)
 4633 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4634 GOSUB *KEYIN
 4635 IF A$="0"      THEN *MAIN_MENU
 4636 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_6_3
 4637 IF A$<>" "     THEN *M_TUTORIAL_6_4
 4638 '-------------
 4639 *M_TUTORIAL_6_5
 4640 KPRINT (10,20,0,1,0)
 4641 KPRINT "FM音源で音を作ろう！             5/17",,,RGB(20,0,20)
 4642 KPRINT "･";:KPRINT "ｵﾍﾟﾚｰﾀ番号";,RGB(31,22,22):KPRINT "｢";:KPRINT FIX "OP#";,RGB(31,31,20)
 4643 KPRINT "｣は､FM結線をするときの":KPRINT " 接続情報";,RGB(31,22,22):KPRINT "を明確にするための識別番号で"
 4644 KPRINT " す｡以降のパラメータを設定するｵﾍﾟﾚｰﾀ ":KPRINT " の番号(自分の番号)を記述します｡"
 4645 KPRINT (10,105,0,-7,0),FIX "REM   OP#,W,X,Y,  M,S,...",RGB(0,31,0)
 4646 KPRINT FIX "DATA FM,";,RGB(31,31,0):KPRINT FIX "1";,RGB(31,31,20):KPRINT FIX ",*,*,*,  *,*,...",RGB(31,31,0)
 4647 KPRINT FIX "DATA FM,";,RGB(31,31,0):KPRINT FIX "2";,RGB(31,31,20):KPRINT FIX ",*,*,*,  *,*,...",RGB(31,31,0)
 4648 KPRINT FIX "DATA FM,";,RGB(31,31,0):KPRINT FIX "3";,RGB(31,31,20):KPRINT FIX ",*,*,*,  *,*,...",RGB(31,31,0)
 4649 KPRINT FIX "DATA FM,";,RGB(31,31,0):KPRINT FIX "4";,RGB(31,31,20):KPRINT FIX ",*,*,*,  *,*,...",RGB(31,31,0)
 4650 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4651 GOSUB *KEYIN
 4652 IF A$="0"      THEN *MAIN_MENU
 4653 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_6_4
 4654 IF A$<>" "     THEN *M_TUTORIAL_6_5
 4655 '-------------
 4656 *M_TUTORIAL_6_6
 4657 KPRINT (10,20,0,1,0)
 4658 KPRINT "FM音源で音を作ろう！             6/17",,,RGB(20,0,20)
 4659 KPRINT "･";:KPRINT "変調波形";,RGB(31,22,22):KPRINT "｢";:KPRINT FIX "W";,RGB(31,31,20):KPRINT "｣には";
 4660 KPRINT "1";,RGB(22,22,0):KPRINT "～";:KPRINT "47";,RGB(22,22,0)
 4661 KPRINT "､および｢";:KPRINT FIX "-";,RGB(31,31,20):KPRINT "｣記号に"
 4662 KPRINT " 続く";:KPRINT "レイヤー番号";,RGB(31,22,22):KPRINT "を指定できますが､こ "
 4663 KPRINT " こでは､すべてのｵﾍﾟﾚｰﾀの変調波形を普 "
 4664 KPRINT " 通の";:KPRINT "サイン波";,RGB(31,22,22):KPRINT "｢";:KPRINT "1";,RGB(22,22,0):KPRINT "｣に設定しておきます｡"
 4665 KPRINT (10,105,0,-7,0),FIX "REM   OP#,W,X,Y,  M,S,...",RGB(0,31,0)
 4666 KPRINT FIX "DATA FM,1,";,RGB(31,31,0):KPRINT FIX "1";,RGB(31,31,20):KPRINT FIX ",*,*,  *,*,...",RGB(31,31,0)
 4667 KPRINT FIX "DATA FM,2,";,RGB(31,31,0):KPRINT FIX "1";,RGB(31,31,20):KPRINT FIX ",*,*,  *,*,...",RGB(31,31,0)
 4668 KPRINT FIX "DATA FM,3,";,RGB(31,31,0):KPRINT FIX "1";,RGB(31,31,20):KPRINT FIX ",*,*,  *,*,...",RGB(31,31,0)
 4669 KPRINT FIX "DATA FM,4,";,RGB(31,31,0):KPRINT FIX "1";,RGB(31,31,20):KPRINT FIX ",*,*,  *,*,...",RGB(31,31,0)
 4670 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4671 GOSUB *KEYIN
 4672 IF A$="0"      THEN *MAIN_MENU
 4673 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_6_5
 4674 IF A$<>" "     THEN *M_TUTORIAL_6_6
 4675 '-------------
 4676 *M_TUTORIAL_6_7
 4677 KPRINT (10,20,0,1,0)
 4678 KPRINT "FM音源で音を作ろう！             7/17",,,RGB(20,0,20)
 4679 KPRINT "･";:KPRINT "変調入力";,RGB(31,22,22):KPRINT "｢";:KPRINT FIX "X";,RGB(31,31,20)
 4680 KPRINT "｣と";:KPRINT "変調入力";,RGB(31,22,22):KPRINT "｢";:KPRINT FIX "Y";,RGB(31,31,20):KPRINT "｣には､具体的 "
 4681 KPRINT " な結線情報を記述します(1～32)｡":KPRINT "･まず､";:KPRINT "ｵﾍﾟﾚｰﾀ1";,RGB(31,22,22):KPRINT "を";
 4682 KPRINT "ｾﾙﾌ･ﾌｨｰﾄﾞﾊﾞｯｸ";,RGB(31,22,22):KPRINT "に設定し ":KPRINT " てみます｡"
 4683 KPRINT "･これは､自分(ｵﾍﾟﾚｰﾀ1)の出力を自分に戻"
 4684 KPRINT " すという意味で､";:KPRINT FIX "X";,RGB(31,31,20):KPRINT "と";:KPRINT FIX "Y";,RGB(31,31,20)
 4685 KPRINT "に両方とも｢";:KPRINT "1";,RGB(22,22,0):KPRINT "｣を設":KPRINT " 定しています｡"
 4686 KPRINT (10,156,0,-7,0),FIX "REM   OP#,W,X,Y,  M,S,...",RGB(0,31,0)
 4687 KPRINT FIX "DATA FM,1,1,";,RGB(31,31,0):KPRINT FIX "1,1";,RGB(31,31,20):KPRINT FIX ",  *,*,...",RGB(31,31,0)
 4688 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4689 GOSUB *KEYIN
 4690 IF A$="0"      THEN *MAIN_MENU
 4691 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_6_6
 4692 IF A$<>" "     THEN *M_TUTORIAL_6_7
 4693 '-------------
 4694 *M_TUTORIAL_6_8
 4695 KPRINT (10,20,0,1,0)
 4696 KPRINT "FM音源で音を作ろう！             8/17",,,RGB(20,0,20)
 4697 KPRINT "･";:KPRINT "ﾀﾞｲﾚｸﾄﾃﾞｰﾀ送出ﾚﾍﾞﾙ";,RGB(31,22,22):KPRINT "｢";
 4698 KPRINT FIX "S";,RGB(31,31,20):KPRINT "｣は､自分の出力を"
 4699 KPRINT " ﾀﾞｲﾚｸﾄに取り出す際の";:KPRINT "ﾐｷｻｰ･ﾚﾍﾞﾙ";,RGB(31,22,22):KPRINT "を設定 "
 4700 KPRINT " します(";:KPRINT "0";,RGB(22,22,0):KPRINT "～";:KPRINT "7";,RGB(22,22,0):KPRINT ")｡"
 4701 KPRINT "･｢";:KPRINT "0";,RGB(22,22,0):KPRINT "｣以外を設定した場合は､実際の音とし"
 4702 KPRINT " てｵﾍﾟﾚｰﾀの出力が取り出せます｡"
 4703 KPRINT "･｢";:KPRINT "7";,RGB(22,22,0):KPRINT "｣を設定し､実際に鳴らしてみましょう｡"
 4704 KPRINT " (変調度｢";:KPRINT FIX "M";,RGB(31,31,20):KPRINT "｣はひとまず";
 4705 KPRINT "0";,RGB(22,22,0):KPRINT "にしておきます)"
 4706 KPRINT (10,156,0,-7,0),FIX "REM   OP#,W,X,Y,  M,S,...",RGB(0,31,0)
 4707 KPRINT FIX "DATA FM,1,1,1,1, *0,";,RGB(31,31,0):KPRINT FIX "7";,RGB(31,31,20):KPRINT FIX ",...",RGB(31,31,0)
 4708 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4709 GOSUB *FADEIN
 4710 A$=INPUT$(1)
 4711 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 4712 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOSUB *TONE_RESET:GOTO *M_TUTORIAL_6_7
 4713 IF A$<>" "     THEN *M_TUTORIAL_6_8
 4714 CLS:PRINT "Init.FM..."
 4715 RESTORE *T68:TARG READ:CLS
 4716 *T68
 4717 DATA BUILDLAYER
 4718      'OP#,W,X,Y,  M,S, AR,DR,SR,RR,SL, TL, ml1,ml2, dt,KS
 4719 DATA FM,1,1,1,1,  0,7, 31, 0, 0,31, 0,  0,  24,  0,  0, 0
 4720 DATA ENDLAYER
 4721 DATA ENDARRANGE
 4722 EFFECT(ST),1,"@1 O3 CDEFGAB>CDEFGAB>CDEFGAB>C"
 4723 GOSUB *KEYIN
 4724 VSYNC 2:PLAYSTOP ST
 4725 IF A$="0"      THEN *MAIN_MENU
 4726 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_6_7
 4727 IF A$<>" "     THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_6_8
 4728 '-------------
 4729 *M_TUTORIAL_6_9
 4730 KPRINT (10,20,0,1,0)
 4731 KPRINT "FM音源で音を作ろう！             9/17",,,RGB(20,0,20)
 4732 KPRINT "･";:KPRINT "変調度";,RGB(31,22,22):KPRINT "｢";:KPRINT FIX "M";,RGB(31,31,20)
 4733 KPRINT "｣は､";:KPRINT FIX "X";,RGB(31,31,20):KPRINT "と";:KPRINT FIX "Y";,RGB(31,31,20):KPRINT "に接続した入力信号か"
 4734 KPRINT " ら､";:KPRINT "どれだけ変調を受けるか";,RGB(31,22,22):KPRINT "を設定しま "
 4735 KPRINT " す(";:KPRINT "0";,RGB(22,22,0):KPRINT "～";:KPRINT "15";,RGB(22,22,0):KPRINT ":ただし､0～4は無変調)｡"
 4736 KPRINT "･｢";:KPRINT "4";,RGB(22,22,0):KPRINT "｣(無変調)から｢";:KPRINT "10";,RGB(22,22,0):KPRINT "｣(±2π)まで変化さ"
 4737 KPRINT " せながら聞いてみましょう｡":KPRINT "･演奏中に変化させるため､";:KPRINT "TPROP";,RGB(22,22,31):KPRINT "命令を使"
 4738 KPRINT " っています(項目";:KPRINT "62";,RGB(22,22,0):KPRINT ":変調ﾚﾍﾞﾙ｢";:KPRINT FIX "@MDL";,RGB(31,31,20):KPRINT "｣)｡"
 4739 KPRINT (10,156,0,-7,0),FIX "REM   OP#,W,X,Y,     M,S,...",RGB(0,31,0)
 4740 KPRINT FIX "DATA FM,1,1,1,1, ";,RGB(31,31,0):KPRINT FIX "4～10";,RGB(31,31,20):KPRINT FIX ",*,...",RGB(31,31,0)
 4741 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4742 GOSUB *FADEIN
 4743 A$=INPUT$(1)
 4744 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 4745 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOSUB *TONE_RESET:GOTO *M_TUTORIAL_6_8
 4746 IF A$<>" "     THEN *M_TUTORIAL_6_9
 4747 CLS:PRINT "Init.FM..."
 4748 RESTORE *T69:TARG READ:CLS
 4749 *T69
 4750 DATA BUILDLAYER
 4751      'OP#,W,X,Y,  M,S, AR,DR,SR,RR,SL, TL, ml1,ml2, dt,KS
 4752 DATA FM,1,1,1,1,  4,7, 31, 0, 0,31, 0,  0,  24,  0,  0, 0
 4753 DATA ENDLAYER
 4754 DATA ENDARRANGE
 4755 TPROP(1,0,@MDL)= 4:PLAY "@1 O3 R C2"
 4756 TPROP(1,0,@MDL)= 5:PLAY "@1 O3 R C2"
 4757 TPROP(1,0,@MDL)= 6:PLAY "@1 O3 R C2"
 4758 TPROP(1,0,@MDL)= 7:PLAY "@1 O3 R C2"
 4759 TPROP(1,0,@MDL)= 8:PLAY "@1 O3 R C2"
 4760 TPROP(1,0,@MDL)= 9:PLAY "@1 O3 R C2"
 4761 TPROP(1,0,@MDL)=10:PLAY "@1 O3 R C2"
 4762 GOSUB *KEYIN
 4763 VSYNC 2:PLAYSTOP ST
 4764 IF A$="0"      THEN *MAIN_MENU
 4765 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_6_8
 4766 IF A$<>" "     THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_6_9
 4767 '-------------
 4768 *M_TUTORIAL_6_10
 4769 KPRINT (10,20,0,1,0)
 4770 KPRINT "FM音源で音を作ろう！            10/17",,,RGB(20,0,20)
 4771 KPRINT "･他のｵﾍﾟﾚｰﾀについても同様に結線をして"
 4772 KPRINT " みます｡";:KPRINT "ｵﾍﾟﾚｰﾀ2";,RGB(31,22,22):KPRINT "は";:KPRINT "ﾌｨｰﾄﾞﾊﾞｯｸ=0";,RGB(31,22,22)
 4773 KPRINT "｡";:KPRINT "ｵﾍﾟﾚｰﾀ3",RGB(31,22,22)
 4774 KPRINT " は､ｵﾍﾟﾚｰﾀ2の出力を入力｡";:KPRINT "ｵﾍﾟﾚｰﾀ4";,RGB(31,22,22):KPRINT "には､ｵ"
 4775 KPRINT " ﾍﾟﾚｰﾀ1と3の出力を入力しています｡":KPRINT (10,105,0,-7,0),FIX "REM   OP#,W,X,Y,  M,S,...",RGB(0,31,0)
 4776 KPRINT FIX "DATA FM,1,1,1,1, 10,7,...",RGB(31,31,0)
 4777 KPRINT FIX "DATA FM,2,1,";,RGB(31,31,0):KPRINT FIX "2,2";,RGB(31,31,20):KPRINT FIX ",  *,*,...",RGB(31,31,0)
 4778 KPRINT FIX "DATA FM,3,1,";,RGB(31,31,0):KPRINT FIX "2,2";,RGB(31,31,20):KPRINT FIX ",  *,*,...",RGB(31,31,0)
 4779 KPRINT FIX "DATA FM,4,1,";,RGB(31,31,0):KPRINT FIX "3,1";,RGB(31,31,20):KPRINT FIX ",  *,*,...",RGB(31,31,0)
 4780 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4781 GOSUB *KEYIN
 4782 IF A$="0"      THEN *MAIN_MENU
 4783 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_6_9
 4784 IF A$<>" "     THEN *M_TUTORIAL_6_10
 4785 '-------------
 4786 *M_TUTORIAL_6_11
 4787 KPRINT (10,20,0,1,0)
 4788 KPRINT "FM音源で音を作ろう！            11/17",,,RGB(20,0,20)
 4789 KPRINT "･ここで､先程";:KPRINT "実験的に鳴らしたｵﾍﾟﾚｰﾀ1";,RGB(31,22,22):KPRINT "の"
 4790 KPRINT " 出力をﾐｷｻｰに通さないよう｢";:KPRINT "0";,RGB(22,22,0):KPRINT "｣を設定し "
 4791 KPRINT " ておきます｡結線情報を見ると､";:KPRINT "最終的な",RGB(31,22,22)
 4792 KPRINT " 出力はｵﾍﾟﾚｰﾀ4だけ";,RGB(31,22,22):KPRINT "なのがわかります｡"
 4793 KPRINT (10,105,0,-7,0),FIX "REM   OP#,W,X,Y,  M,S,...",RGB(0,31,0)
 4794 KPRINT FIX "DATA FM,1,1,1,1, 10,";,RGB(31,31,0):KPRINT FIX "0";,RGB(31,31,20):KPRINT FIX ",...",RGB(31,31,0)
 4795 KPRINT FIX "DATA FM,2,1,2,2,  *,*,...",RGB(31,31,0)
 4796 KPRINT FIX "DATA FM,3,1,2,2,  *,*,...",RGB(31,31,0)
 4797 KPRINT FIX "DATA FM,4,1,3,1,  *,*,...",RGB(31,31,0)
 4798 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4799 GOSUB *KEYIN
 4800 IF A$="0"      THEN *MAIN_MENU
 4801 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_6_10
 4802 IF A$<>" "     THEN *M_TUTORIAL_6_11
 4803 '-------------
 4804 *M_TUTORIAL_6_12
 4805 KPRINT (10,20,0,1,0)
 4806 KPRINT "FM音源で音を作ろう！            12/17",,,RGB(20,0,20)
 4807 KPRINT "･ｵﾍﾟﾚｰﾀ4以外のﾀﾞｲﾚｸﾄ成分を､音として取"
 4808 KPRINT " り出さないように､｢";:KPRINT FIX "S";,RGB(31,31,20):KPRINT "｣を";:KPRINT "0";,RGB(22,22,0):KPRINT "にします｡"
 4809 KPRINT "･他のｵﾍﾟﾚｰﾀに対する変調度は､目的の音 ":KPRINT " をｲﾒｰｼﾞしながら適当な値を設定します｡"
 4810 KPRINT (10,105,0,-7,0),FIX "     'OP#,W,X,Y,  M,S,...",RGB(0,31,0):KPRINT FIX "DATA FM,1,1,1,1, 10,0,...",RGB(31,31,0)
 4811 KPRINT FIX "DATA FM,2,1,2,2, ";,RGB(31,31,0):KPRINT FIX " 0,0";,RGB(31,31,20):KPRINT FIX ",...",RGB(31,31,0)
 4812 KPRINT FIX "DATA FM,3,1,2,2, ";,RGB(31,31,0):KPRINT FIX "12,0";,RGB(31,31,20):KPRINT FIX ",...",RGB(31,31,0)
 4813 KPRINT FIX "DATA FM,4,1,3,1, ";,RGB(31,31,0):KPRINT FIX "12,6";,RGB(31,31,20):KPRINT FIX ",...",RGB(31,31,0)
 4814 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4815 GOSUB *KEYIN
 4816 IF A$="0"      THEN *MAIN_MENU
 4817 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_6_11
 4818 IF A$<>" "     THEN *M_TUTORIAL_6_12
 4819 '-------------
 4820 *M_TUTORIAL_6_13
 4821 KPRINT (10,20,0,1,0)
 4822 KPRINT "FM音源で音を作ろう！            13/17",,,RGB(20,0,20)
 4823 KPRINT "･";:KPRINT "エンベロープ情報";,RGB(31,22,22):KPRINT "は､オペレータがキャ "
 4824 KPRINT " リアの役割なのかモジュレータの役割な"
 4825 KPRINT " のかの違いによって､";:KPRINT "音色にも影響";,RGB(31,22,22):KPRINT "を及 "
 4826 KPRINT " ぼします(設定値はPCMの場合と同じ)｡  "
 4827 KPRINT (10,105,0,-7,0),FIX "...,AR,DR,SR,RR,SL,...",RGB(0,31,0)
 4828 KPRINT FIX "...,31,23,12,14,28,...",RGB(31,31,0)
 4829 KPRINT FIX "...,31,13,23,14,24,...",RGB(31,31,0)
 4830 KPRINT FIX "...,31,11,23,14,26,...",RGB(31,31,0)
 4831 KPRINT FIX "...,31, 9,26,18,26,...",RGB(31,31,0)
 4832 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4833 GOSUB *FADEIN
 4834 A$=INPUT$(1)
 4835 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 4836 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOSUB *TONE_RESET:GOTO *M_TUTORIAL_6_12
 4837 IF A$<>" "     THEN *M_TUTORIAL_6_13
 4838 CLS:PRINT "Init.FM..."
 4839 RESTORE *T613:TARG READ:CLS
 4840 *T613
 4841 DATA BUILDLAYER
 4842      'OP#,W,X,Y,  M,S, AR,DR,SR,RR,SL, TL, ml1,ml2, dt,KS
 4843 DATA FM,1,1,1,1, 10,0, 31,23,12,14,28,  0,  24,  0,  0, 0
 4844 DATA FM,2,1,2,2,  0,0, 31,13,23,14,24,  0,  24,  0,  0, 0
 4845 DATA FM,3,1,2,2, 12,0, 31,11,23,14,26,  0,  24,  0,  0, 0
 4846 DATA FM,4,1,3,1, 12,6, 31, 9,26,18,26,  0,  24,  0,  0, 0
 4847 DATA ENDLAYER
 4848 DATA ENDARRANGE
 4849 EFFECT(ST),1,"@1 O3 CDEFGAB>CDEFGAB>CDEFGAB>C"
 4850 GOSUB *KEYIN
 4851 VSYNC 2:PLAYSTOP ST
 4852 IF A$="0"      THEN *MAIN_MENU
 4853 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_6_12
 4854 IF A$<>" "     THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_6_13
 4855 '-------------
 4856 *M_TUTORIAL_6_14
 4857 KPRINT (10,20,0,1,0)
 4858 KPRINT "FM音源で音を作ろう！            14/17",,,RGB(20,0,20)
 4859 KPRINT "･";:KPRINT "ﾄｰﾀﾙ･ﾚﾍﾞﾙ";,RGB(31,22,22):KPRINT "は､ｵﾍﾟﾚｰﾀの出力ﾚﾍﾞﾙを";:KPRINT "減衰量",RGB(31,22,22)
 4860 KPRINT " で表わしています(";:KPRINT "0";,RGB(22,22,0):KPRINT "で減衰無し)｡"
 4861 KPRINT "･これも､エンベロープと同様に音色にも":KPRINT " 影響を与えます｡"
 4862 KPRINT (10,105,0,-7,0),FIX "...,TL,...",RGB(0,31,0)
 4863 KPRINT FIX "..., 6,...",RGB(31,31,0)
 4864 KPRINT FIX "...,74,...",RGB(31,31,0)
 4865 KPRINT FIX "...,40,...",RGB(31,31,0)
 4866 KPRINT FIX "..., 0,...",RGB(31,31,0)
 4867 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4868 GOSUB *FADEIN
 4869 A$=INPUT$(1)
 4870 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 4871 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOSUB *TONE_RESET:GOTO *M_TUTORIAL_6_13
 4872 IF A$<>" "     THEN *M_TUTORIAL_6_14
 4873 CLS:PRINT "Init.FM..."
 4874 RESTORE *T614:TARG READ:CLS
 4875 *T614
 4876 DATA BUILDLAYER
 4877      'OP#,W,X,Y,  M,S, AR,DR,SR,RR,SL, TL, ml1,ml2, dt,KS
 4878 DATA FM,1,1,1,1, 10,0, 31,23,12,14,28,  6,  24,  0,  0, 0
 4879 DATA FM,2,1,2,2,  0,0, 31,13,23,14,24, 74,  24,  0,  0, 0
 4880 DATA FM,3,1,2,2, 12,0, 31,11,23,14,26, 40,  24,  0,  0, 0
 4881 DATA FM,4,1,3,1, 12,6, 31, 9,26,18,26,  0,  24,  0,  0, 0
 4882 DATA ENDLAYER
 4883 DATA ENDARRANGE
 4884 EFFECT(ST),1,"@1 O3 CDEFGAB>CDEFGAB>CDEFGAB>C"
 4885 GOSUB *KEYIN
 4886 VSYNC 2:PLAYSTOP ST
 4887 IF A$="0"      THEN *MAIN_MENU
 4888 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_6_13
 4889 IF A$<>" "     THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_6_14
 4890 '-------------
 4891 *M_TUTORIAL_6_15
 4892 KPRINT (10,20,0,1,0)
 4893 KPRINT "FM音源で音を作ろう！            15/17",,,RGB(20,0,20)
 4894 KPRINT "･";:KPRINT "ﾏﾙﾁﾌﾟﾙ";,RGB(31,22,22):KPRINT "｢";:KPRINT FIX "ml1";,RGB(31,31,20)
 4895 KPRINT "｣と｢";:KPRINT FIX "ml2";,RGB(31,31,20):KPRINT "｣で変調波形の";:KPRINT "周波数",RGB(31,22,22)
 4896 KPRINT " 比";,RGB(31,22,22):KPRINT "を設定し､";:KPRINT "ﾃﾞﾁｭｰﾝ";,RGB(31,22,22)
 4897 KPRINT "｢";:KPRINT FIX "dt";,RGB(31,31,20):KPRINT "｣で微調整します｡"
 4898 KPRINT "･";:KPRINT "ｷｰ･ﾚｰﾄ･ｽｹｰﾘﾝｸﾞ";,RGB(31,22,22):KPRINT "｢";
 4899 KPRINT FIX "KS";,RGB(31,31,20):KPRINT "｣は､";:KPRINT "音程に対するエ",RGB(31,22,22)
 4900 KPRINT " ンベロープの変化の割合";,RGB(31,22,22):KPRINT "です｡"
 4901 KPRINT (10,105,0,-7,0),FIX "...,ml1,ml2,dt,KS",RGB(0,31,0)
 4902 KPRINT FIX "..., 62,  0,10, 0",RGB(31,31,0)
 4903 KPRINT FIX "..., 62,  0,10, 0",RGB(31,31,0)
 4904 KPRINT FIX "..., 12,  0, 0, 0",RGB(31,31,0)
 4905 KPRINT FIX "..., 24,  0, 0, 0",RGB(31,31,0)
 4906 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4907 GOSUB *FADEIN
 4908 A$=INPUT$(1)
 4909 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 4910 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOSUB *TONE_RESET:GOTO *M_TUTORIAL_6_14
 4911 IF A$<>" "     THEN *M_TUTORIAL_6_15
 4912 CLS:PRINT "Init.FM..."
 4913 RESTORE *T615:TARG READ:CLS
 4914 *T615
 4915 DATA BUILDLAYER
 4916      'OP#,W,X,Y,  M,S, AR,DR,SR,RR,SL, TL, ml1,ml2, dt,KS
 4917 DATA FM,1,1,1,1, 10,0, 31,23,12,14,28,  6,  62,  0, 10, 0
 4918 DATA FM,2,1,2,2,  0,0, 31,13,23,14,24, 74,  62,  0, 10, 0
 4919 DATA FM,3,1,2,2, 12,0, 31,11,23,14,26, 40,  12,  0,  0, 0
 4920 DATA FM,4,1,3,1, 12,6, 31, 9,26,18,26,  0,  24,  0,  0, 0
 4921 DATA ENDLAYER
 4922 DATA ENDARRANGE
 4923 EFFECT(ST),1,"@1 O3 CDEFGAB>CDEFGAB>CDEFGAB>C"
 4924 GOSUB *KEYIN
 4925 VSYNC 2:PLAYSTOP ST
 4926 IF A$="0"      THEN *MAIN_MENU
 4927 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_6_14
 4928 IF A$<>" "     THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_6_15
 4929 '-------------
 4930 *M_TUTORIAL_6_16
 4931 KPRINT (10,20,0,1,0)
 4932 KPRINT "FM音源で音を作ろう！            16/17",,,RGB(20,0,20)
 4933 KPRINT "･いま鳴らした音色は､ｻﾝﾌﾟﾙ曲(ｳﾞｪｲｸﾞｽ)"
 4934 KPRINT " で実際に使用している";:KPRINT "ﾁｮｯﾊﾟｰ･ﾍﾞｰｽ";,RGB(31,22,22):KPRINT "の音"
 4935 KPRINT " です｡":KPRINT "･すべてのパラメータをバランス良く設定":KPRINT " しなければならないので､なかなかイメ"
 4936 KPRINT " ージした音色にならないと思いますが､":KPRINT " 色々パラメータを変えて､実験してみて":KPRINT " 下さい｡"
 4937 KPRINT "★ｻﾝﾌﾟﾙ曲のｿｰｽを参考にして下さい｡",RGB(31,31,0)
 4938 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4939 GOSUB *KEYIN
 4940 IF A$="0"      THEN *MAIN_MENU
 4941 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_6_15
 4942 IF A$<>" "     THEN *M_TUTORIAL_6_16
 4943 '-------------
 4944 *M_TUTORIAL_6_17
 4945 KPRINT (10,20,0,1,0)
 4946 KPRINT "FM音源で音を作ろう！            17/17",,,RGB(20,0,20)
 4947 KPRINT "･";:KPRINT "TARG";,RGB(22,22,31):KPRINT "命令の｢";
 4948 KPRINT FIX "FM";,RGB(31,31,20):KPRINT "｣の代わりに｢";:KPRINT FIX "FMEXT";,RGB(31,31,20):KPRINT "｣を使 "
 4949 KPRINT " えば､";:KPRINT "LFO";,RGB(31,22,22):KPRINT "の設定を行なうことができます｡"
 4950 KPRINT "･";:KPRINT "Start note";,RGB(31,22,22):KPRINT "､";:KPRINT "End note";,RGB(31,22,22):KPRINT "の設定もできます"
 4951 KPRINT " ので､PCM音源のレイヤー設定と同じよう":KPRINT " に､";:KPRINT "Key split";,RGB(31,22,22):KPRINT "も可能です｡"
 4952 KPRINT FIX " DATA FM,....",RGB(31,31,20):KPRINT (10,139,0,-7,0),"      ↓":KPRINT FIX " DATA FMEXT,....",RGB(31,31,20):KPRINT ""
 4953 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4954 GOSUB *KEYIN
 4955 IF A$="0"      THEN *MAIN_MENU
 4956 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_6_16
 4957 IF A$<>" "     THEN *M_TUTORIAL_6_17
 4958 '-------------
 4959 GOTO *M_TUTORIAL
 4960 '--------------------------------------------------------------------------------------------------------
 4961 *M_TUTORIAL_7_1
 4962 KPRINT (10,20,0,1,0)
 4963 KPRINT "様々な表現をするためのﾃｸﾆｯｸ      1/36",,,RGB(20,0,20)
 4964 KPRINT "･MML文字列は､マクロを使って簡潔に表記":KPRINT " することができます｡"
 4965 KPRINT "･マクロには､ベロシティのデフォルト値":KPRINT " を設定するための専用マクロと､フリー"
 4966 KPRINT " 定義可能な汎用マクロがあります｡":KPRINT "【ベロシティ･マクロ】",RGB(31,31,0)
 4967 KPRINT FIX " ppp";,RGB(31,31,20):KPRINT "､";:KPRINT FIX "pp";,RGB(31,31,20):KPRINT "､";
 4968 KPRINT FIX "p";,RGB(31,31,20):KPRINT "､";:KPRINT FIX "mp";,RGB(31,31,20):KPRINT "､";
 4969 KPRINT FIX "mf";,RGB(31,31,20):KPRINT "､";:KPRINT FIX "f";,RGB(31,31,20):KPRINT "､";
 4970 KPRINT FIX "ff";,RGB(31,31,20):KPRINT "､";:KPRINT FIX "fff",RGB(31,31,20)
 4971 KPRINT "【汎用マクロ】",RGB(31,31,0)
 4972 KPRINT " ｢";:KPRINT FIX "\A";,RGB(31,31,20):KPRINT "～";:KPRINT FIX "\Z";,RGB(31,31,20)
 4973 KPRINT "｣および｢";:KPRINT FIX "\a";,RGB(31,31,20):KPRINT "～";:KPRINT FIX "\z";,RGB(31,31,20)
 4974 KPRINT "｣(";:KPRINT "52";,RGB(22,22,0):KPRINT "種類)"
 4975 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4976 GOSUB *KEYIN
 4977 IF A$="0"      THEN *MAIN_MENU
 4978 IF A$=CHR$(13) THEN *M_TUTORIAL
 4979 IF A$<>" "     THEN *M_TUTORIAL_7_1
 4980 '-------------
 4981 *M_TUTORIAL_7_2
 4982 KPRINT (10,20,0,1,0)
 4983 KPRINT "様々な表現をするためのﾃｸﾆｯｸ      2/36",,,RGB(20,0,20)
 4984 KPRINT "･";:KPRINT "ベロシティ･マクロ";,RGB(31,22,22):KPRINT "は､｢";:KPRINT FIX "=";,RGB(31,31,20)
 4985 KPRINT "｣を付けた場合 ":KPRINT " に定義され､付けないと";:KPRINT "ベロシティ値";,RGB(31,22,22):KPRINT "｢";
 4986 KPRINT FIX "v";,RGB(31,31,20):KPRINT "｣":KPRINT " のデフォルトを書き換えます｡"
 4987 KPRINT FIX " @44 v127 CDE mf CDE mf=99 CDE mf CDE",RGB(31,31,0):KPRINT "              ↑     ^^^^^     ↑"
 4988 KPRINT FIX "             v=mf             v=99":KPRINT "":KPRINT "･次に､ベロシティ･マクロの種類と､予め"
 4989 KPRINT " 設定されている値の一覧を記します｡"
 4990 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 4991 GOSUB *FADEIN
 4992 A$=INPUT$(1)
 4993 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 4994 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOSUB *TONE_RESET:GOTO *M_TUTORIAL_7_1
 4995 IF A$<>" "     THEN *M_TUTORIAL_7_2
 4996 EFFECT(ST),1,"@44 v127 CDE mf CDE mf=99 CDE mf CDE"
 4997 GOSUB *KEYIN
 4998 VSYNC 2:PLAYSTOP ST
 4999 IF A$="0"      THEN *MAIN_MENU
 5000 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_7_1
 5001 IF A$<>" "     THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_7_2
 5002 '-------------
 5003 *M_TUTORIAL_7_3
 5004 KPRINT (10,20,0,1,0)
 5005 KPRINT "様々な表現をするためのﾃｸﾆｯｸ      3/36",,,RGB(20,0,20)
 5006 KPRINT "種類:記号の意味     :デフォルト設定値"
 5007 KPRINT FIX " ppp";,RGB(31,31,20):KPRINT ":            :pianopianissimo: 16"
 5008 KPRINT FIX " pp ";,RGB(31,31,20):KPRINT ":きわめて弱く:pianissimo     : 32"
 5009 KPRINT FIX " p  ";,RGB(31,31,20):KPRINT ":弱く        :piano          : 48"
 5010 KPRINT FIX " mp ";,RGB(31,31,20):KPRINT ":やや弱く    :mezzo piano    : 64"
 5011 KPRINT FIX " mf ";,RGB(31,31,20):KPRINT ":やや強く    :mezzo forte    : 80"
 5012 KPRINT FIX " f  ";,RGB(31,31,20):KPRINT ":強く        :forte          : 96"
 5013 KPRINT FIX " ff ";,RGB(31,31,20):KPRINT ":きわめて強く:fortissimo     :112"
 5014 KPRINT FIX " fff";,RGB(31,31,20):KPRINT ":            :fortefortissimo:127"
 5015 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 5016 GOSUB *KEYIN
 5017 IF A$="0"      THEN *MAIN_MENU
 5018 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_7_2
 5019 IF A$<>" "     THEN *M_TUTORIAL_7_3
 5020 '-------------
 5021 *M_TUTORIAL_7_4
 5022 KPRINT (10,20,0,1,0)
 5023 KPRINT "様々な表現をするためのﾃｸﾆｯｸ      4/36",,,RGB(20,0,20)
 5024 KPRINT "･";:KPRINT "汎用マクロ";,RGB(31,22,22):KPRINT "は､｢";:KPRINT FIX "\";,RGB(31,31,20)
 5025 KPRINT "｣に続くアルファベット":KPRINT " 1文字に､MML文字列を";:KPRINT "128";,RGB(22,22,0):KPRINT "文字まで登録す"
 5026 KPRINT " ることができます｡":KPRINT "･大文字小文字は別のマクロとして扱われ":KPRINT " ます｡"
 5027 KPRINT "･登録するときは､｢";:KPRINT FIX "=";,RGB(31,31,20):KPRINT "｣を付け､文字列を｢";
 5028 KPRINT FIX "\";,RGB(31,31,20):KPRINT "｣":KPRINT " 記号で挟みます｡"
 5029 KPRINT FIX " \K=\N36'4;127\ \S=\N38'4;120\";,RGB(31,31,0):KPRINT " ←登録"
 5030 KPRINT FIX " @31 \K(\K\S) \K(\K\S) \K(\K\S)";,RGB(31,31,0):KPRINT "←実行"
 5031 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 5032 GOSUB *FADEIN
 5033 A$=INPUT$(1)
 5034 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 5035 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOSUB *TONE_RESET:GOTO *M_TUTORIAL_7_3
 5036 IF A$<>" "     THEN *M_TUTORIAL_7_4
 5037 EFFECT(ST),1,"V12 \K=\N36'4;127\ \S=\N38'4;120\ @31 \K(\K\S) \K(\K\S) \K(\K\S)"
 5038 GOSUB *KEYIN
 5039 VSYNC 2:PLAYSTOP ST
 5040 IF A$="0"      THEN *MAIN_MENU
 5041 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_7_3
 5042 IF A$<>" "     THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_7_4
 5043 '-------------
 5044 *M_TUTORIAL_7_5
 5045 KPRINT (10,20,0,1,0)
 5046 KPRINT "様々な表現をするためのﾃｸﾆｯｸ      5/36",,,RGB(20,0,20)
 5047 KPRINT "･音名｢";:KPRINT FIX "CDEFGAB";,RGB(31,31,20):KPRINT "｣のサブ･オプションを汎用"
 5048 KPRINT " マクロに登録することもできます｡":KPRINT "･下の例は､ピッチ･ベンド･オプションを"
 5049 KPRINT " 登録して､表記を単純にしています｡":KPRINT FIX " @44 \p=\~64;90;\ C\p D\p E\p F\p G\p",RGB(31,31,0)
 5050 KPRINT "":KPRINT "":KPRINT "":KPRINT ""
 5051 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 5052 GOSUB *FADEIN
 5053 A$=INPUT$(1)
 5054 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 5055 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOSUB *TONE_RESET:GOTO *M_TUTORIAL_7_4
 5056 IF A$<>" "     THEN *M_TUTORIAL_7_5
 5057 EFFECT(ST),1,"@44 \p=\~64;90;\ C\p D\p E\p F\p G\p"
 5058 GOSUB *KEYIN
 5059 VSYNC 2:PLAYSTOP ST
 5060 IF A$="0"      THEN *MAIN_MENU
 5061 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_7_4
 5062 IF A$<>" "     THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_7_5
 5063 '-------------
 5064 *M_TUTORIAL_7_6
 5065 KPRINT (10,20,0,1,0)
 5066 KPRINT "様々な表現をするためのﾃｸﾆｯｸ      6/36",,,RGB(20,0,20)
 5067 KPRINT "･次に､";:KPRINT "ソフトウェア･レイヤー･コマンド",RGB(31,22,22)
 5068 KPRINT " ｢";:KPRINT FIX "/";,RGB(31,31,20):KPRINT "｣を紹介します｡"
 5069 KPRINT "･これは､";:KPRINT "1つのNote ON";,RGB(31,22,22):KPRINT "に";
 5070 KPRINT "複数の音色";,RGB(31,22,22):KPRINT "や､";:KPRINT "ピ",RGB(31,22,22)
 5071 KPRINT " ッチの異なる音";,RGB(31,22,22):KPRINT "を重ねて鳴らす場合に有":KPRINT " 効です｡"
 5072 KPRINT "･例えば､1ｵｸﾀｰﾌﾞ上と下の音を重ねて鳴ら"
 5073 KPRINT " す場合は､以下のように指定し､｢";:KPRINT FIX "/";,RGB(31,31,20):KPRINT "｣を指 "
 5074 KPRINT " 定する度に";:KPRINT "トグル";,RGB(31,22,22):KPRINT "で切り替わります｡"
 5075 KPRINT FIX " @44 CDE… /44;12;44;-12 CDE… / CDE…",RGB(31,31,0)
 5076 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 5077 GOSUB *FADEIN
 5078 A$=INPUT$(1)
 5079 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 5080 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOSUB *TONE_RESET:GOTO *M_TUTORIAL_7_5
 5081 IF A$<>" "     THEN *M_TUTORIAL_7_6
 5082 EFFECT(ST),1,"@44 CDEFGAB /44;12;44;-12 CDEFGAB / CDEFGAB"
 5083 GOSUB *KEYIN
 5084 VSYNC 2:PLAYSTOP ST
 5085 IF A$="0"      THEN *MAIN_MENU
 5086 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_7_5
 5087 IF A$<>" "     THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_7_6
 5088 '-------------
 5089 *M_TUTORIAL_7_7
 5090 KPRINT (10,20,0,1,0)
 5091 KPRINT "様々な表現をするためのﾃｸﾆｯｸ      7/36",,,RGB(20,0,20)
 5092 KPRINT "･下の例は､追加して重ねる3つの音色のう":KPRINT " ち､41番の音色はそのまま､36番の音色は"
 5093 KPRINT " 1オクターブ上､38番の音色は1オクター ":KPRINT " ブ下の音にして重ねます｡"
 5094 KPRINT FIX " @44 /41;0; 36;12; 38;-12 CDE / CDE",RGB(31,31,0):KPRINT "                             ↑"
 5095 KPRINT "  ここで､ｿﾌﾄｳｪｱ･ﾚｲﾔｰ機能がOFFになり､"
 5096 KPRINT "  残った音符はベース音色(ここでは";:KPRINT FIX "@44";,RGB(31,31,20):KPRINT ")":KPRINT "  だけで演奏します｡"
 5097 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 5098 GOSUB *FADEIN
 5099 A$=INPUT$(1)
 5100 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 5101 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOSUB *TONE_RESET:GOTO *M_TUTORIAL_7_6
 5102 IF A$<>" "     THEN *M_TUTORIAL_7_7
 5103 EFFECT(ST),1,"@44 /41;0; 36;12; 38;-12 CDE / CDE"
 5104 GOSUB *KEYIN
 5105 VSYNC 2:PLAYSTOP ST
 5106 IF A$="0"      THEN *MAIN_MENU
 5107 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_7_6
 5108 IF A$<>" "     THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_7_7
 5109 '-------------
 5110 *M_TUTORIAL_7_8
 5111 KPRINT (10,20,0,1,0)
 5112 KPRINT "様々な表現をするためのﾃｸﾆｯｸ      8/36",,,RGB(20,0,20)
 5113 KPRINT "･";:KPRINT "ｿﾌﾄｳｪｱ･ﾚｲﾔｰ･ｺﾏﾝﾄﾞ";,RGB(31,22,22):KPRINT "は､ソフトウェアでレ"
 5114 KPRINT " イヤー機能をシミュレートしているだけ":KPRINT " ですので､更に多彩なレイヤー設定を行 "
 5115 KPRINT " なう場合は｢";:KPRINT "TARG";,RGB(22,22,31):KPRINT "｣命令の｢";
 5116 KPRINT "BUILDLAYER";,RGB(31,22,22):KPRINT "｣で､":KPRINT " 音色データを構築して下さい｡"
 5117 KPRINT "･もう1つ例を紹介します｡"
 5118 KPRINT (10,139,0,-7,0),FIX " PLAYINIT "+CHR$(&H22)+"ORCHEST"+CHR$(&H22),RGB(31,31,0):KPRINT ""
 5119 KPRINT FIX " @35 /36;0;37;0;39;12;40;12;41;0;42;0",RGB(31,31,0)
 5120 KPRINT FIX " O3 / CDEFGAB / CDEFGAB / CDEFGAB    ",RGB(31,31,0)
 5121 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 5122 GOSUB *FADEIN
 5123 A$=INPUT$(1)
 5124 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 5125 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOSUB *TONE_RESET:GOTO *M_TUTORIAL_7_7
 5126 IF A$<>" "     THEN *M_TUTORIAL_7_8
 5127 CLS:PRINT "Loading ORCHEST Set...":PLAYINIT "ORCHEST":CLS
 5128 EFFECT(ST),1,"@35 /36;0;37;0;39;12;40;12;41;0;42;0 O3 / CDEFGAB / CDEFGAB / CDEFGAB"
 5129 GOSUB *KEYIN
 5130 VSYNC 2:PLAYSTOP ST
 5131 IF A$="0"      THEN *MAIN_MENU
 5132 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_7_7
 5133 IF A$<>" "     THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_7_8
 5134 '-------------
 5135 *M_TUTORIAL_7_9
 5136 KPRINT (10,20,0,1,0)
 5137 KPRINT "様々な表現をするためのﾃｸﾆｯｸ      9/36",,,RGB(20,0,20)
 5138 KPRINT "･次に､";:KPRINT "ダンパー･スイッチ";,RGB(31,22,22):KPRINT "｢";:KPRINT FIX "%";,RGB(31,31,20):KPRINT "｣を紹介しま"
 5139 KPRINT " す｡":KPRINT "･通常は｢";:KPRINT FIX "%0";,RGB(31,31,20):KPRINT "｣の状態で演奏しますが､｢";
 5140 KPRINT FIX "%1";,RGB(31,31,20):KPRINT "｣ ":KPRINT " にした場合は､ピアノのダンパー･ペダル"
 5141 KPRINT " を踏みながら演奏するような効果が得ら":KPRINT " れます｡"
 5142 KPRINT (10,139,0,-7,0),FIX " PLAYINIT "+CHR$(&H22)+"PIANO"+CHR$(&H22),RGB(31,31,0):KPRINT ""
 5143 KPRINT FIX " @1 L8 O3 CDEFGAB>C R4 O3 %1 CDEFGAB>C",RGB(31,31,0):KPRINT ""
 5144 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 5145 GOSUB *FADEIN
 5146 A$=INPUT$(1)
 5147 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 5148 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOSUB *TONE_RESET:GOTO *M_TUTORIAL_7_8
 5149 IF A$<>" "     THEN *M_TUTORIAL_7_9
 5150 CLS:PRINT "Loading PIANO Set...":PLAYINIT "PIANO":CLS
 5151 EFFECT(ST),1,"@1 L8 O3 CDEFGAB>C R4 O3 %1 CDEFGAB>C"
 5152 GOSUB *KEYIN
 5153 VSYNC 2:PLAYSTOP ST
 5154 IF A$="0"      THEN *MAIN_MENU
 5155 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_7_8
 5156 IF A$<>" "     THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_7_9
 5157 '-------------
 5158 *M_TUTORIAL_7_10
 5159 KPRINT (10,20,0,1,0)
 5160 KPRINT "様々な表現をするためのﾃｸﾆｯｸ     10/36",,,RGB(20,0,20)
 5161 KPRINT "･｢";:KPRINT FIX "%1";,RGB(31,31,20):KPRINT "｣の後の動作は､これ以降に発音する "
 5162 KPRINT " 音符の";:KPRINT "Key OFFを行なわない";,RGB(31,22,22):KPRINT "だけです｡  "
 5163 KPRINT "･したがって､リリースの長い音色や､減衰":KPRINT " しない音色に対して使った場合は､鳴り "
 5164 KPRINT " っぱなしになりますので注意して下さい｡"
 5165 KPRINT "･これを利用して､｢";:KPRINT "EXTRA3";,RGB(31,22,22):KPRINT "｣および｢";
 5166 KPRINT "EXTRA4";,RGB(31,22,22):KPRINT "｣"
 5167 KPRINT " セットの｢";:KPRINT "LOOP系リズム音色";,RGB(31,22,22):KPRINT "｣を簡単に鳴":KPRINT " らすことができます｡"
 5168 KPRINT ""
 5169 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 5170 GOSUB *KEYIN
 5171 IF A$="0"      THEN *MAIN_MENU
 5172 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_7_9
 5173 IF A$<>" "     THEN *M_TUTORIAL_7_10
 5174 '-------------
 5175 *M_TUTORIAL_7_11
 5176 KPRINT (10,20,0,1,0)
 5177 KPRINT "様々な表現をするためのﾃｸﾆｯｸ     11/36",,,RGB(20,0,20)
 5178 KPRINT "･｢";:KPRINT "LOOP系リズム音色";,RGB(31,22,22):KPRINT "｣は､Note ON状態が続"
 5179 KPRINT " く限り､リズムを刻む特殊な音色です｡":KPRINT "･普通に音符を指定しただけでは､指定音"
 5180 KPRINT " 長分しか演奏しませんが､｢";:KPRINT FIX "%1";,RGB(31,31,20):KPRINT "｣を使った "
 5181 KPRINT " 場合は";:KPRINT "Key OFFしない";,RGB(31,22,22):KPRINT "ため鳴り続けます｡"
 5182 KPRINT (10,122,0,-7,0),FIX " PLAYINIT "+CHR$(&H22)+"EXTRA4"+CHR$(&H22),RGB(31,31,0)
 5183 KPRINT FIX " EFFECT "+CHR$(&H22)+"@9 %1 C"+CHR$(&H22),RGB(31,31,0):KPRINT "":KPRINT "（演奏を止めるにはSpaceキー）"
 5184 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 5185 GOSUB *FADEIN
 5186 A$=INPUT$(1)
 5187 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 5188 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOSUB *TONE_RESET:GOTO *M_TUTORIAL_7_10
 5189 IF A$<>" "     THEN *M_TUTORIAL_7_11
 5190 CLS:PRINT "Loading EXTRA4 Set...":PLAYINIT "EXTRA4":CLS
 5191 EFFECT(ST),1,"@9 %1 C"
 5192 GOSUB *KEYIN
 5193 VSYNC 2:PLAYSTOP ST
 5194 IF A$="0"      THEN *MAIN_MENU
 5195 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_7_10
 5196 IF A$<>" "     THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_7_11
 5197 '-------------
 5198 *M_TUTORIAL_7_12
 5199 KPRINT (10,20,0,1,0)
 5200 KPRINT "様々な表現をするためのﾃｸﾆｯｸ     12/36",,,RGB(20,0,20)
 5201 KPRINT "･次に､";:KPRINT "制御コマンド";,RGB(31,22,22):KPRINT "｢";
 5202 KPRINT FIX "!";,RGB(31,31,20):KPRINT "｣を紹介します｡ ":KPRINT "･これは､MML文字列からBASICプログラム"
 5203 KPRINT " に値を返すコマンドです｡":KPRINT "･";:KPRINT "MMLSTAT";,RGB(22,22,31):KPRINT "関数を使って､いつでも現在演奏"
 5204 KPRINT " 中のノート番号や音量などがトラック単":KPRINT " 位に取得できますが､このコマンドをMML"
 5205 KPRINT " 文字列に挿入することによって､任意の"
 5206 KPRINT " 数値(";:KPRINT "1";,RGB(22,22,0):KPRINT "～";:KPRINT "127";,RGB(22,22,0):KPRINT ")を任意のタイミングで送る"
 5207 KPRINT " ことが可能になります｡"
 5208 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 5209 GOSUB *KEYIN
 5210 IF A$="0"      THEN *MAIN_MENU
 5211 IF A$=CHR$(13) THEN *M_TUTORIAL_7_11
 5212 IF A$<>" "     THEN *M_TUTORIAL_7_12
 5213 '-------------
 5214 *M_TUTORIAL_7_13
 5215 KPRINT (10,20,0,1,0)
 5216 KPRINT "様々な表現をするためのﾃｸﾆｯｸ     13/36",,,RGB(20,0,20)
 5217 KPRINT FIX " CDE !1 FGA !2 B>C !3 R",RGB(31,31,20):KPRINT "･上のようなMMLを鳴らした場合､BASICプ"
 5218 KPRINT " ログラムから";:KPRINT "MMLSTAT";,RGB(22,22,31):KPRINT "関数を使って､どこ"
 5219 KPRINT " まで演奏したかを知ることができます｡":KPRINT FIX " X=MMLSTAT(0,0)",RGB(31,31,20)
 5220 KPRINT " を実行したとき､｢";:KPRINT FIX "X=0";,RGB(31,31,20):KPRINT "｣なら｢";
 5221 KPRINT FIX "CDE";,RGB(31,31,20):KPRINT "｣演奏中｡"
 5222 KPRINT "                ｢";:KPRINT FIX "X=1";,RGB(31,31,20):KPRINT "｣なら｢";
 5223 KPRINT FIX "FGA";,RGB(31,31,20):KPRINT "｣演奏中｡"
 5224 KPRINT "                ｢";:KPRINT FIX "X=2";,RGB(31,31,20):KPRINT "｣なら｢";
 5225 KPRINT FIX "B>C";,RGB(31,31,20):KPRINT "｣演奏中｡"
 5226 KPRINT "                ｢";:KPRINT FIX "X=3";,RGB(31,31,20):KPRINT "｣なら演奏終了｡"
 5227 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 5228 GOSUB *KEYIN
 5229 IF A$="0"      THEN *MAIN_MENU
 5230 IF A$=CHR$(13) THEN *M_TUTORIAL_7_12
 5231 IF A$<>" "     THEN *M_TUTORIAL_7_13
 5232 '-------------
 5233 *M_TUTORIAL_7_14
 5234 KPRINT (10,20,0,1,0)
 5235 KPRINT "様々な表現をするためのﾃｸﾆｯｸ     14/36",,,RGB(20,0,20)
 5236 KPRINT FIX " CDE !1 FGA !2 B>C !3 R",RGB(31,31,20)
 5237 KPRINT "･｢";:KPRINT "ON MMLSTAT GOSUB";,RGB(22,22,31):KPRINT "｣命令を定義した場合"
 5238 KPRINT " は､上のMMLが";:KPRINT "トラック0";,RGB(31,22,22):KPRINT "に記述されてい "
 5239 KPRINT " る場合に限り､";:KPRINT "割り込みが発生";,RGB(31,22,22):KPRINT "します｡  "
 5240 KPRINT "･条件を満たした場合のみBGMを変えたり､":KPRINT " カラオケ･プログラムを作る場合に便利":KPRINT " です｡"
 5241 KPRINT "★この命令のサンプルは｢";,RGB(31,31,0):KPRINT FIX "S_F_HAWK.B";,RGB(31,31,20):KPRINT "｣",RGB(31,31,0)
 5242 KPRINT "  (ﾌｧｲﾔｰ･ﾎｰｸBGM集)にあります｡",RGB(31,31,0)
 5243 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 5244 GOSUB *KEYIN
 5245 IF A$="0"      THEN *MAIN_MENU
 5246 IF A$=CHR$(13) THEN *M_TUTORIAL_7_13
 5247 IF A$<>" "     THEN *M_TUTORIAL_7_14
 5248 '-------------
 5249 *M_TUTORIAL_7_15
 5250 KPRINT (10,20,0,1,0)
 5251 KPRINT "様々な表現をするためのﾃｸﾆｯｸ     15/36",,,RGB(20,0,20)
 5252 KPRINT "･次に､コードを演奏してみましょう｡"
 5253 KPRINT "･音名コマンド｢";:KPRINT FIX "CDEFGAB";,RGB(31,31,20):KPRINT "｣には｢";:KPRINT FIX "?";,RGB(31,31,20)
 5254 KPRINT "｣に続き､ ":KPRINT " コードネームを指定することができます｡"
 5255 KPRINT "･本MMLでは､";:KPRINT "14";,RGB(22,22,0):KPRINT "種類のコードネームが使用":KPRINT " 可能です｡"
 5256 KPRINT "･更に､各コードは";:KPRINT "第三転回";,RGB(31,22,22):KPRINT "まで可能です｡"
 5257 KPRINT "･大文字と小文字は､別のコマンドになり":KPRINT " ますので注意して下さい｡":KPRINT "･では､順に聞いてみましょう｡"
 5258 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 5259 GOSUB *KEYIN
 5260 IF A$="0"      THEN *MAIN_MENU
 5261 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_7_14
 5262 IF A$<>" "     THEN *M_TUTORIAL_7_15
 5263 '-------------
 5264 *M_TUTORIAL_7_16
 5265 KPRINT (10,20,0,1,0)
 5266 KPRINT "様々な表現をするためのﾃｸﾆｯｸ     16/36",,,RGB(20,0,20)
 5267 KPRINT "･まず､";:KPRINT "メジャー･トライアド";,RGB(31,22,22):KPRINT "を聞いてみま"
 5268 KPRINT " しょう｡｢";:KPRINT FIX "?";,RGB(31,31,20):KPRINT "｣の後ろには何も記述しません｡"
 5269 KPRINT "･これは､和音コマンド｢";:KPRINT FIX "()";,RGB(31,31,20):KPRINT "｣の例で鳴らし "
 5270 KPRINT " た｢";:KPRINT FIX "(CEG)";,RGB(31,31,20):KPRINT "｣のように､根音｢";:KPRINT FIX "C";,RGB(31,31,20)
 5271 KPRINT "｣に長3度｢";:KPRINT FIX "E";,RGB(31,31,20):KPRINT "｣ "
 5272 KPRINT " と､完全5度上の｢";:KPRINT FIX "G";,RGB(31,31,20):KPRINT "｣を重ねて鳴らした音 ":KPRINT " です｡"
 5273 KPRINT "･下の2行は､同じ演奏をします｡"
 5274 KPRINT FIX " @44 L2 (CEG)(DF#A)(EG#B)(FA>C)…",RGB(31,31,20)
 5275 KPRINT FIX " @44 L2 C? D? E? F? G? A? B?",RGB(31,31,0)
 5276 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 5277 GOSUB *FADEIN
 5278 A$=INPUT$(1)
 5279 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 5280 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOSUB *TONE_RESET:GOTO *M_TUTORIAL_7_15
 5281 IF A$<>" "     THEN *M_TUTORIAL_7_16
 5282 CLS:PRINT "Loading STANDARD Set...":PLAYINIT "DSP","STANDARD":CLS
 5283 EFFECT(ST),1,"@44 L2 R4 C? D? E? F? G? A? B?"
 5284 GOSUB *KEYIN
 5285 VSYNC 2:PLAYSTOP ST
 5286 IF A$="0"      THEN *MAIN_MENU
 5287 IF A$=CHR$(13) THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_7_15
 5288 IF A$<>" "     THEN GOSUB *TONE_RESET:GOTO *M_TUTORIAL_7_16
 5289 '-------------
 5290 *M_TUTORIAL_7_17
 5291 KPRINT (10,20,0,1,0)
 5292 KPRINT "様々な表現をするためのﾃｸﾆｯｸ     17/36",,,RGB(20,0,20)
 5293 KPRINT "･次に､";:KPRINT "マイナー･トライアド";,RGB(31,22,22):KPRINT "を聞いてみま":KPRINT " しょう｡"
 5294 KPRINT "･コマンドは､｢";:KPRINT FIX "?m";,RGB(31,31,20):KPRINT "｣または｢";:KPRINT FIX "?-";,RGB(31,31,20):KPRINT "｣です｡"
 5295 KPRINT "":KPRINT FIX " @44 L2 C?m D?m E?m F?m G?m A?m B?m  ",RGB(31,31,0):KPRINT "":KPRINT "":KPRINT "":KPRINT ""
 5296 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 5297 GOSUB *FADEIN
 5298 A$=INPUT$(1)
 5299 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 5300 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_7_16
 5301 IF A$<>" "     THEN *M_TUTORIAL_7_17
 5302 EFFECT(ST),1,"@44 L2 C?m D?m E?m F?m G?m A?m B?m"
 5303 GOSUB *KEYIN
 5304 VSYNC 2:PLAYSTOP ST
 5305 IF A$="0"      THEN *MAIN_MENU
 5306 IF A$=CHR$(13) THEN *M_TUTORIAL_7_16
 5307 IF A$<>" "     THEN *M_TUTORIAL_7_17
 5308 '-------------
 5309 *M_TUTORIAL_7_18
 5310 KPRINT (10,20,0,1,0)
 5311 KPRINT "様々な表現をするためのﾃｸﾆｯｸ     18/36",,,RGB(20,0,20)
 5312 KPRINT "･";:KPRINT "オーギュメント･トライアド";,RGB(31,22,22):KPRINT "です｡"
 5313 KPRINT "･｢";:KPRINT FIX "?aug";,RGB(31,31,20):KPRINT "｣または｢";:KPRINT FIX "?+";,RGB(31,31,20):KPRINT "｣を指定します｡"
 5314 KPRINT "":KPRINT FIX " @44 L2 C?aug D?aug E?aug F?aug …   ",RGB(31,31,0):KPRINT ""
 5315 KPRINT "":KPRINT "":KPRINT "":KPRINT ""
 5316 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 5317 GOSUB *FADEIN
 5318 A$=INPUT$(1)
 5319 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 5320 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_7_17
 5321 IF A$<>" "     THEN *M_TUTORIAL_7_18
 5322 EFFECT(ST),1,"@44 L2 C?aug D?aug E?aug F?aug G?aug A?aug B?aug"
 5323 GOSUB *KEYIN
 5324 VSYNC 2:PLAYSTOP ST
 5325 IF A$="0"      THEN *MAIN_MENU
 5326 IF A$=CHR$(13) THEN *M_TUTORIAL_7_17
 5327 IF A$<>" "     THEN *M_TUTORIAL_7_18
 5328 '-------------
 5329 *M_TUTORIAL_7_19
 5330 KPRINT (10,20,0,1,0)
 5331 KPRINT "様々な表現をするためのﾃｸﾆｯｸ     19/36",,,RGB(20,0,20)
 5332 KPRINT "･";:KPRINT "ディミニッシュ･トライアド";,RGB(31,22,22):KPRINT "です｡"
 5333 KPRINT "･｢";:KPRINT FIX "?dim";,RGB(31,31,20):KPRINT "｣または｢";:KPRINT FIX "?ﾟ";,RGB(31,31,20):KPRINT "｣を指定します｡"
 5334 KPRINT "":KPRINT FIX " @44 L2 C?dim D?dim E?dim F?dim …   ",RGB(31,31,0):KPRINT ""
 5335 KPRINT "":KPRINT "":KPRINT "":KPRINT ""
 5336 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 5337 GOSUB *FADEIN
 5338 A$=INPUT$(1)
 5339 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 5340 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_7_18
 5341 IF A$<>" "     THEN *M_TUTORIAL_7_19
 5342 EFFECT(ST),1,"@44 L2 C?dim D?dim E?dim F?dim G?dim A?dim B?dim"
 5343 GOSUB *KEYIN
 5344 VSYNC 2:PLAYSTOP ST
 5345 IF A$="0"      THEN *MAIN_MENU
 5346 IF A$=CHR$(13) THEN *M_TUTORIAL_7_18
 5347 IF A$<>" "     THEN *M_TUTORIAL_7_19
 5348 '-------------
 5349 *M_TUTORIAL_7_20
 5350 KPRINT (10,20,0,1,0)
 5351 KPRINT "様々な表現をするためのﾃｸﾆｯｸ     20/36",,,RGB(20,0,20)
 5352 KPRINT "･";:KPRINT "セブンス･コード";,RGB(31,22,22):KPRINT "です｡"
 5353 KPRINT "･｢";:KPRINT FIX "?7";,RGB(31,31,20):KPRINT "｣を指定します｡":KPRINT ""
 5354 KPRINT FIX " @44 L2 C?7 D?7 E?7 F?7 G?7 A?7 B?7  ",RGB(31,31,0):KPRINT "":KPRINT "":KPRINT "":KPRINT "":KPRINT ""
 5355 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 5356 GOSUB *FADEIN
 5357 A$=INPUT$(1)
 5358 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 5359 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_7_19
 5360 IF A$<>" "     THEN *M_TUTORIAL_7_20
 5361 EFFECT(ST),1,"@44 L2 C?7 D?7 E?7 F?7 G?7 A?7 B?7"
 5362 GOSUB *KEYIN
 5363 VSYNC 2:PLAYSTOP ST
 5364 IF A$="0"      THEN *MAIN_MENU
 5365 IF A$=CHR$(13) THEN *M_TUTORIAL_7_19
 5366 IF A$<>" "     THEN *M_TUTORIAL_7_20
 5367 '-------------
 5368 *M_TUTORIAL_7_21
 5369 KPRINT (10,20,0,1,0)
 5370 KPRINT "様々な表現をするためのﾃｸﾆｯｸ     21/36",,,RGB(20,0,20)
 5371 KPRINT "･";:KPRINT "マイナーセブンス･コード";,RGB(31,22,22):KPRINT "です｡"
 5372 KPRINT "･｢";:KPRINT FIX "?m7";,RGB(31,31,20):KPRINT "｣を指定します｡":KPRINT ""
 5373 KPRINT FIX " @44 L2 C?m7 D?m7 E?m7 F?m7 G?m7 …  ",RGB(31,31,0):KPRINT "":KPRINT "":KPRINT "":KPRINT "":KPRINT ""
 5374 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 5375 GOSUB *FADEIN
 5376 A$=INPUT$(1)
 5377 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 5378 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_7_20
 5379 IF A$<>" "     THEN *M_TUTORIAL_7_21
 5380 EFFECT(ST),1,"@44 L2 C?m7 D?m7 E?m7 F?m7 G?m7 A?m7 B?m7"
 5381 GOSUB *KEYIN
 5382 VSYNC 2:PLAYSTOP ST
 5383 IF A$="0"      THEN *MAIN_MENU
 5384 IF A$=CHR$(13) THEN *M_TUTORIAL_7_20
 5385 IF A$<>" "     THEN *M_TUTORIAL_7_21
 5386 '-------------
 5387 *M_TUTORIAL_7_22
 5388 KPRINT (10,20,0,1,0)
 5389 KPRINT "様々な表現をするためのﾃｸﾆｯｸ     22/36",,,RGB(20,0,20)
 5390 KPRINT "･";:KPRINT "マイナーセブンス･フラットファイブ･コ",RGB(31,22,22)
 5391 KPRINT " ード";,RGB(31,22,22):KPRINT "です｡"
 5392 KPRINT "･｢";:KPRINT FIX "?m7-5";,RGB(31,31,20):KPRINT "｣または｢";:KPRINT FIX "?m7b5";,RGB(31,31,20)
 5393 KPRINT "｣を指定します｡":KPRINT "":KPRINT FIX " @44 L2 C?m7-5 D?m7-5 E?m7-5 F?m7-5…",RGB(31,31,0):KPRINT "":KPRINT ""
 5394 KPRINT "":KPRINT ""
 5395 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 5396 GOSUB *FADEIN
 5397 A$=INPUT$(1)
 5398 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 5399 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_7_21
 5400 IF A$<>" "     THEN *M_TUTORIAL_7_22
 5401 EFFECT(ST),1,"@44 L2 C?m7-5 D?m7-5 E?m7-5 F?m7-5 G?m7-5 A?m7-5 B?m7-5"
 5402 GOSUB *KEYIN
 5403 VSYNC 2:PLAYSTOP ST
 5404 IF A$="0"      THEN *MAIN_MENU
 5405 IF A$=CHR$(13) THEN *M_TUTORIAL_7_21
 5406 IF A$<>" "     THEN *M_TUTORIAL_7_22
 5407 '-------------
 5408 *M_TUTORIAL_7_23
 5409 KPRINT (10,20,0,1,0)
 5410 KPRINT "様々な表現をするためのﾃｸﾆｯｸ     23/36",,,RGB(20,0,20)
 5411 KPRINT "･";:KPRINT "メジャーセブンス･コード";,RGB(31,22,22):KPRINT "です｡"
 5412 KPRINT "･｢";:KPRINT FIX "?M7";,RGB(31,31,20):KPRINT "｣または｢";:KPRINT FIX "?maj7";,RGB(31,31,20):KPRINT "｣を指定します｡"
 5413 KPRINT "":KPRINT FIX " @44 L2 C?M7 D?M7 E?M7 F?M7 G?M7 …  ",RGB(31,31,0):KPRINT "":KPRINT "":KPRINT "":KPRINT ""
 5414 KPRINT ""
 5415 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 5416 GOSUB *FADEIN
 5417 A$=INPUT$(1)
 5418 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 5419 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_7_22
 5420 IF A$<>" "     THEN *M_TUTORIAL_7_23
 5421 EFFECT(ST),1,"@44 L2 C?M7 D?M7 E?M7 F?M7 G?M7 A?M7 B?M7"
 5422 GOSUB *KEYIN
 5423 VSYNC 2:PLAYSTOP ST
 5424 IF A$="0"      THEN *MAIN_MENU
 5425 IF A$=CHR$(13) THEN *M_TUTORIAL_7_22
 5426 IF A$<>" "     THEN *M_TUTORIAL_7_23
 5427 '-------------
 5428 *M_TUTORIAL_7_24
 5429 KPRINT (10,20,0,1,0)
 5430 KPRINT "様々な表現をするためのﾃｸﾆｯｸ     24/36",,,RGB(20,0,20)
 5431 KPRINT "･";:KPRINT "マイナーメジャーセブンス･コード";,RGB(31,22,22):KPRINT "です｡"
 5432 KPRINT "･｢";:KPRINT FIX "?mM7";,RGB(31,31,20):KPRINT "｣を指定します｡":KPRINT ""
 5433 KPRINT FIX " @44 L2 C?mM7 D?mM7 E?mM7 F?mM7 …   ",RGB(31,31,0):KPRINT "":KPRINT "":KPRINT "":KPRINT "":KPRINT ""
 5434 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 5435 GOSUB *FADEIN
 5436 A$=INPUT$(1)
 5437 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 5438 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_7_23
 5439 IF A$<>" "     THEN *M_TUTORIAL_7_24
 5440 EFFECT(ST),1,"@44 L2 C?mM7 D?mM7 E?mM7 F?mM7 G?mM7 A?mM7 B?mM7"
 5441 GOSUB *KEYIN
 5442 VSYNC 2:PLAYSTOP ST
 5443 IF A$="0"      THEN *MAIN_MENU
 5444 IF A$=CHR$(13) THEN *M_TUTORIAL_7_23
 5445 IF A$<>" "     THEN *M_TUTORIAL_7_24
 5446 '-------------
 5447 *M_TUTORIAL_7_25
 5448 KPRINT (10,20,0,1,0)
 5449 KPRINT "様々な表現をするためのﾃｸﾆｯｸ     25/36",,,RGB(20,0,20)
 5450 KPRINT "･";:KPRINT "ディミニッシュセブンス･コード";,RGB(31,22,22):KPRINT "です｡"
 5451 KPRINT "･｢";:KPRINT FIX "?dim7";,RGB(31,31,20):KPRINT "｣を指定します｡":KPRINT ""
 5452 KPRINT FIX " @44 L2 C?dim7 D?dim7 E?dim7 F?dim7…",RGB(31,31,0):KPRINT "":KPRINT "":KPRINT "":KPRINT "":KPRINT ""
 5453 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 5454 GOSUB *FADEIN
 5455 A$=INPUT$(1)
 5456 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 5457 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_7_24
 5458 IF A$<>" "     THEN *M_TUTORIAL_7_25
 5459 EFFECT(ST),1,"@44 L2 C?dim7 D?dim7 E?dim7 F?dim7 G?dim7 A?dim7 B?dim7"
 5460 GOSUB *KEYIN
 5461 VSYNC 2:PLAYSTOP ST
 5462 IF A$="0"      THEN *MAIN_MENU
 5463 IF A$=CHR$(13) THEN *M_TUTORIAL_7_24
 5464 IF A$<>" "     THEN *M_TUTORIAL_7_25
 5465 '-------------
 5466 *M_TUTORIAL_7_26
 5467 KPRINT (10,20,0,1,0)
 5468 KPRINT "様々な表現をするためのﾃｸﾆｯｸ     26/36",,,RGB(20,0,20)
 5469 KPRINT "･";:KPRINT "メジャーシックス･コード";,RGB(31,22,22):KPRINT "です｡"
 5470 KPRINT "･｢";:KPRINT FIX "?6";,RGB(31,31,20):KPRINT "｣を指定します｡":KPRINT ""
 5471 KPRINT FIX " @44 L2 C?6 D?6 E?6 F?6 G?6 A?6 B?6  ",RGB(31,31,0):KPRINT "":KPRINT "":KPRINT "":KPRINT "":KPRINT ""
 5472 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 5473 GOSUB *FADEIN
 5474 A$=INPUT$(1)
 5475 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 5476 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_7_25
 5477 IF A$<>" "     THEN *M_TUTORIAL_7_26
 5478 EFFECT(ST),1,"@44 L2 C?6 D?6 E?6 F?6 G?6 A?6 B?6"
 5479 GOSUB *KEYIN
 5480 VSYNC 2:PLAYSTOP ST
 5481 IF A$="0"      THEN *MAIN_MENU
 5482 IF A$=CHR$(13) THEN *M_TUTORIAL_7_25
 5483 IF A$<>" "     THEN *M_TUTORIAL_7_26
 5484 '-------------
 5485 *M_TUTORIAL_7_27
 5486 KPRINT (10,20,0,1,0)
 5487 KPRINT "様々な表現をするためのﾃｸﾆｯｸ     27/36",,,RGB(20,0,20)
 5488 KPRINT "･";:KPRINT "マイナーシックス･コード";,RGB(31,22,22):KPRINT "です｡"
 5489 KPRINT "･｢";:KPRINT FIX "?m6";,RGB(31,31,20):KPRINT "｣を指定します｡":KPRINT ""
 5490 KPRINT FIX " @44 L2 C?m6 D?m6 E?m6 F?m6 G?m6 …  ",RGB(31,31,0):KPRINT "":KPRINT "":KPRINT "":KPRINT "":KPRINT ""
 5491 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 5492 GOSUB *FADEIN
 5493 A$=INPUT$(1)
 5494 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 5495 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_7_26
 5496 IF A$<>" "     THEN *M_TUTORIAL_7_27
 5497 EFFECT(ST),1,"@44 L2 C?m6 D?m6 E?m6 F?m6 G?m6 A?m6 B?m6"
 5498 GOSUB *KEYIN
 5499 VSYNC 2:PLAYSTOP ST
 5500 IF A$="0"      THEN *MAIN_MENU
 5501 IF A$=CHR$(13) THEN *M_TUTORIAL_7_26
 5502 IF A$<>" "     THEN *M_TUTORIAL_7_27
 5503 '-------------
 5504 *M_TUTORIAL_7_28
 5505 KPRINT (10,20,0,1,0)
 5506 KPRINT "様々な表現をするためのﾃｸﾆｯｸ     28/36",,,RGB(20,0,20)
 5507 KPRINT "･";:KPRINT "サスペンディド･フォース";,RGB(31,22,22):KPRINT "です｡"
 5508 KPRINT "･｢";:KPRINT FIX "?sus4";,RGB(31,31,20):KPRINT "｣を指定します｡":KPRINT ""
 5509 KPRINT FIX " @44 L2 C?sus4 D?sus4 E?sus4 F?sus4…",RGB(31,31,0):KPRINT "":KPRINT "":KPRINT "":KPRINT "":KPRINT ""
 5510 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 5511 GOSUB *FADEIN
 5512 A$=INPUT$(1)
 5513 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 5514 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_7_27
 5515 IF A$<>" "     THEN *M_TUTORIAL_7_28
 5516 EFFECT(ST),1,"@44 L2 C?sus4 D?sus4 E?sus4 F?sus4 G?sus4 A?sus4 B?sus4"
 5517 GOSUB *KEYIN
 5518 VSYNC 2:PLAYSTOP ST
 5519 IF A$="0"      THEN *MAIN_MENU
 5520 IF A$=CHR$(13) THEN *M_TUTORIAL_7_27
 5521 IF A$<>" "     THEN *M_TUTORIAL_7_28
 5522 '-------------
 5523 *M_TUTORIAL_7_29
 5524 KPRINT (10,20,0,1,0)
 5525 KPRINT "様々な表現をするためのﾃｸﾆｯｸ     29/36",,,RGB(20,0,20)
 5526 KPRINT "･";:KPRINT "セブンス･サスペンディド･フォース";,RGB(31,22,22):KPRINT "です｡"
 5527 KPRINT "･｢";:KPRINT FIX "?7sus4";,RGB(31,31,20):KPRINT "｣を指定します｡":KPRINT ""
 5528 KPRINT FIX " @44 L2 C?7sus4 D?7sus4 E?7sus4 …",RGB(31,31,0):KPRINT "":KPRINT "":KPRINT "":KPRINT "":KPRINT ""
 5529 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 5530 GOSUB *FADEIN
 5531 A$=INPUT$(1)
 5532 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 5533 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_7_28
 5534 IF A$<>" "     THEN *M_TUTORIAL_7_29
 5535 EFFECT(ST),1,"@44 L2 C?7sus4 D?7sus4 E?7sus4 F?7sus4 G?7sus4 A?7sus4 B?7sus4"
 5536 GOSUB *KEYIN
 5537 VSYNC 2:PLAYSTOP ST
 5538 IF A$="0"      THEN *MAIN_MENU
 5539 IF A$=CHR$(13) THEN *M_TUTORIAL_7_28
 5540 IF A$<>" "     THEN *M_TUTORIAL_7_29
 5541 '-------------
 5542 *M_TUTORIAL_7_30
 5543 KPRINT (10,20,0,1,0)
 5544 KPRINT "様々な表現をするためのﾃｸﾆｯｸ     30/36",,,RGB(20,0,20)
 5545 KPRINT "･以上､14種類のコードを紹介しました｡":KPRINT "･コードを使うと､伴奏を簡単に入力する":KPRINT " ことができます｡"
 5546 KPRINT "･4つのコードを使って､簡単な演奏をして":KPRINT " みます｡":KPRINT ""
 5547 KPRINT FIX " V10 @44 L1 A?m G? F? E?7",RGB(31,31,0):KPRINT "":KPRINT ""
 5548 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 5549 GOSUB *FADEIN
 5550 A$=INPUT$(1)
 5551 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 5552 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_7_29
 5553 IF A$<>" "     THEN *M_TUTORIAL_7_30
 5554 EFFECT(ST),1,"V10 @44 L1 A?m G? F? E?7","V10 @31 O2 CCCC CCCC CCCC CCCC","@31 O2 L8 \H=\RF#RF#RF#RA#\ \H\H\H\H"
 5555 GOSUB *KEYIN
 5556 VSYNC 2:PLAYSTOP ST
 5557 IF A$="0"      THEN *MAIN_MENU
 5558 IF A$=CHR$(13) THEN *M_TUTORIAL_7_29
 5559 IF A$<>" "     THEN *M_TUTORIAL_7_30
 5560 '-------------
 5561 *M_TUTORIAL_7_31
 5562 KPRINT (10,20,0,1,0)
 5563 KPRINT "様々な表現をするためのﾃｸﾆｯｸ     31/36",,,RGB(20,0,20)
 5564 KPRINT "･最後に､";:KPRINT "和音の転回";,RGB(31,22,22):KPRINT "を紹介して､チュート":KPRINT " リアルを終わります｡"
 5565 KPRINT "･和音の一番下の音を";:KPRINT "ベース";,RGB(31,22,22):KPRINT "と言って､こ"
 5566 KPRINT " れまで紹介してきたコードは､すべてベ":KPRINT " ースを根にして鳴らしました｡"
 5567 KPRINT "･これを";:KPRINT "基本形";,RGB(31,22,22):KPRINT "と呼びます｡"
 5568 KPRINT "･ベースを";:KPRINT "根音以外";,RGB(31,22,22):KPRINT "にして和音の並び方を"
 5569 KPRINT " 変えると､和音の響き方が変わります｡  "
 5570 KPRINT "･こうしてできた和音を";:KPRINT "転回形";,RGB(31,22,22):KPRINT "と呼びます｡"
 5571 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 5572 GOSUB *KEYIN
 5573 IF A$="0"      THEN *MAIN_MENU
 5574 IF A$=CHR$(13) THEN *M_TUTORIAL_7_30
 5575 IF A$<>" "     THEN *M_TUTORIAL_7_31
 5576 '-------------
 5577 *M_TUTORIAL_7_32
 5578 KPRINT (10,20,0,1,0)
 5579 KPRINT "様々な表現をするためのﾃｸﾆｯｸ     32/36",,,RGB(20,0,20)
 5580 KPRINT "･本MMLでは､各コードに対して";:KPRINT "3";,RGB(22,22,0):KPRINT "回まで転":KPRINT " 回することができます｡"
 5581 KPRINT "･シー･セブンス･コード｢";:KPRINT "Ｃ7";,RGB(31,22,22):KPRINT "｣を例に､これ":KPRINT " を転回してみましょう｡"
 5582 KPRINT "･まず､基本形のシー･セブンスを鳴らして":KPRINT " みます｡"
 5583 KPRINT "･これは､和音コマンド｢";:KPRINT FIX "(CEGB-)";,RGB(31,31,20):KPRINT "｣で鳴らし":KPRINT " た場合と同じです｡"
 5584 KPRINT FIX " @44 L1 C?7",RGB(31,31,0)
 5585 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 5586 GOSUB *FADEIN
 5587 A$=INPUT$(1)
 5588 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 5589 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_7_31
 5590 IF A$<>" "     THEN *M_TUTORIAL_7_32
 5591 EFFECT(ST),1,"@44 L1 C?7"
 5592 GOSUB *KEYIN
 5593 VSYNC 2:PLAYSTOP ST
 5594 IF A$="0"      THEN *MAIN_MENU
 5595 IF A$=CHR$(13) THEN *M_TUTORIAL_7_31
 5596 IF A$<>" "     THEN *M_TUTORIAL_7_32
 5597 '-------------
 5598 *M_TUTORIAL_7_33
 5599 KPRINT (10,20,0,1,0)
 5600 KPRINT "様々な表現をするためのﾃｸﾆｯｸ     33/36",,,RGB(20,0,20)
 5601 KPRINT "･次に､";:KPRINT "第一転回形";,RGB(31,22,22):KPRINT "で鳴らしてみます｡"
 5602 KPRINT "･これは､基本形の根音｢";:KPRINT FIX "C";,RGB(31,31,20):KPRINT "｣を1オクターブ"
 5603 KPRINT " 上げた形になります｡":KPRINT "･和音コマンドを使うと｢";:KPRINT FIX "(>C<EGB-)";,RGB(31,31,20):KPRINT "｣にな"
 5604 KPRINT " り､ベースが｢";:KPRINT FIX "E";,RGB(31,31,20):KPRINT "｣に変わります｡"
 5605 KPRINT "･コード入力では､｢";:KPRINT FIX "C?7";,RGB(31,31,20):KPRINT "｣の後ろに｢";:KPRINT FIX ";";,RGB(31,31,20)
 5606 KPRINT "｣で区":KPRINT " 切って､転回数｢";:KPRINT FIX "1";,RGB(31,31,20):KPRINT "｣を指定します｡"
 5607 KPRINT FIX " @44 L1 C?7;1",RGB(31,31,0):KPRINT ""
 5608 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 5609 GOSUB *FADEIN
 5610 A$=INPUT$(1)
 5611 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 5612 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_7_32
 5613 IF A$<>" "     THEN *M_TUTORIAL_7_33
 5614 EFFECT(ST),1,"@44 L1 C?7;1"
 5615 GOSUB *KEYIN
 5616 VSYNC 2:PLAYSTOP ST
 5617 IF A$="0"      THEN *MAIN_MENU
 5618 IF A$=CHR$(13) THEN *M_TUTORIAL_7_32
 5619 IF A$<>" "     THEN *M_TUTORIAL_7_33
 5620 '-------------
 5621 *M_TUTORIAL_7_34
 5622 KPRINT (10,20,0,1,0)
 5623 KPRINT "様々な表現をするためのﾃｸﾆｯｸ     34/36",,,RGB(20,0,20)
 5624 KPRINT "･次に､";:KPRINT "第二転回形";,RGB(31,22,22):KPRINT "で鳴らしてみます｡"
 5625 KPRINT "･これは､第一転回形でベースになった音"
 5626 KPRINT " ｢";:KPRINT FIX "E";,RGB(31,31,20):KPRINT "｣を1オクターブ上げた形になります｡"
 5627 KPRINT "･和音コマンドを使うと｢";:KPRINT FIX "(>CE<GB-)";,RGB(31,31,20):KPRINT "｣にな"
 5628 KPRINT " り､ベースが｢";:KPRINT FIX "G";,RGB(31,31,20):KPRINT "｣に変わります｡"
 5629 KPRINT "･コード入力では､｢";:KPRINT FIX "C?7";,RGB(31,31,20):KPRINT "｣の後ろに｢";:KPRINT FIX ";";,RGB(31,31,20)
 5630 KPRINT "｣で区 ":KPRINT " 切って､転回数｢";:KPRINT FIX "2";,RGB(31,31,20):KPRINT "｣を指定します｡"
 5631 KPRINT FIX " @44 L1 C?7;2",RGB(31,31,0):KPRINT ""
 5632 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 5633 GOSUB *FADEIN
 5634 A$=INPUT$(1)
 5635 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 5636 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_7_33
 5637 IF A$<>" "     THEN *M_TUTORIAL_7_34
 5638 EFFECT(ST),1,"@44 L1 C?7;2"
 5639 GOSUB *KEYIN
 5640 VSYNC 2:PLAYSTOP ST
 5641 IF A$="0"      THEN *MAIN_MENU
 5642 IF A$=CHR$(13) THEN *M_TUTORIAL_7_33
 5643 IF A$<>" "     THEN *M_TUTORIAL_7_34
 5644 '-------------
 5645 *M_TUTORIAL_7_35
 5646 KPRINT (10,20,0,1,0)
 5647 KPRINT "様々な表現をするためのﾃｸﾆｯｸ     35/36",,,RGB(20,0,20)
 5648 KPRINT "･最後に､";:KPRINT "第三転回形";,RGB(31,22,22):KPRINT "で鳴らしてみます｡"
 5649 KPRINT "･これは､第二転回形でベースになった音 "
 5650 KPRINT " ｢";:KPRINT FIX "G";,RGB(31,31,20):KPRINT "｣を1オクターブ上げた形になります｡ "
 5651 KPRINT "･和音コマンドを使うと｢";:KPRINT FIX "(>CEG<B-)";,RGB(31,31,20):KPRINT "｣にな "
 5652 KPRINT " り､ベースが｢";:KPRINT FIX "B-";,RGB(31,31,20):KPRINT "｣に変わります｡        "
 5653 KPRINT "･コード入力では､｢";:KPRINT FIX "C?7";,RGB(31,31,20):KPRINT "｣の後ろに｢";:KPRINT FIX ";";,RGB(31,31,20)
 5654 KPRINT "｣で区 ":KPRINT " 切って､転回数｢";:KPRINT FIX "3";,RGB(31,31,20):KPRINT "｣を指定します｡"
 5655 KPRINT FIX " @44 L1 C?7;3",RGB(31,31,0):KPRINT ""
 5656 KPRINT (10,190),"実行/次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 5657 GOSUB *FADEIN
 5658 A$=INPUT$(1)
 5659 IF A$="0"      THEN GOSUB *FADEOUT:GOTO *MAIN_MENU
 5660 IF A$=CHR$(13) THEN GOSUB *FADEOUT:GOTO *M_TUTORIAL_7_34
 5661 IF A$<>" "     THEN *M_TUTORIAL_7_35
 5662 EFFECT(ST),1,"@44 L1 C?7;3"
 5663 GOSUB *KEYIN
 5664 VSYNC 2:PLAYSTOP ST
 5665 IF A$="0"      THEN *MAIN_MENU
 5666 IF A$=CHR$(13) THEN *M_TUTORIAL_7_34
 5667 IF A$<>" "     THEN *M_TUTORIAL_7_35
 5668 '-------------
 5669 *M_TUTORIAL_7_36
 5670 KPRINT (10,20,0,1,0)
 5671 KPRINT "様々な表現をするためのﾃｸﾆｯｸ     36/36",,,RGB(20,0,20)
 5672 KPRINT "･これで､チュートリアルは終わりです｡":KPRINT "･各コマンドを効果的に使えば､サンプル"
 5673 KPRINT " プログラムで紹介した曲のように素晴ら":KPRINT " しい音楽が､あなたにも作れるはずです｡"
 5674 KPRINT "･一度に使いこなそうとせず､少しずつ試 "
 5675 KPRINT " しながら覚えていきましょう｡ "
 5676 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 5677 GOSUB *KEYIN
 5678 IF A$="0"      THEN *MAIN_MENU
 5679 IF A$=CHR$(13) THEN *M_TUTORIAL_7_35
 5680 IF A$<>" "     THEN *M_TUTORIAL_7_36
 5681 '-------------
 5682 *M_TUTORIAL_7_37
 5683 KPRINT (10,20,0,1,0)
 5684 KPRINT "BASICメイン･プログラム               ",RGB(31,31,10)
 5685 KPRINT "   金山素志                          "
 5686 KPRINT "サウンド･システム･プログラム         ",RGB(31,31,10)
 5687 KPRINT "   本間直純                          "
 5688 KPRINT "MMLサンプル･プログラム               ",RGB(31,31,10)
 5689 KPRINT "   蜷川幸広 / 三橋正邦               "
 5690 KPRINT "協 力                                ",RGB(31,31,10)
 5691 KPRINT "   三橋正邦 / 國島憲一 (FM Tune)     "
 5692 KPRINT "   召田英紀 / 大野直子 / 嶋田智幸    "
 5693 KPRINT "   山田康二 / 吉田行宏 / 本間直嗣    "
 5694 KPRINT (10,190),"     次へ→Space  戻る→Enter  TOP→0",,,RGB(0,16,16)
 5695 GOSUB *KEYIN
 5696 IF A$="0"      THEN *MAIN_MENU
 5697 IF A$=CHR$(13) THEN *M_TUTORIAL_7_36
 5698 IF A$<>" "     THEN *M_TUTORIAL_7_37
 5699 '-------------
 5700 GOTO *M_TUTORIAL
 5701 '
 5702 '----------------------------
 5703 '●サウンド･サンプルを聞いてみよう！
 5704 '----------------------------
 5705 *S_MENU_1
 5706 '
 5707 '---------------- MENU DATA
 5708 *MENU_STR
 5709   DATA "  サウンド･サンプルを聞いてみよう！  "
 5710   DATA "1:往年のゲーム アーツ作品～BGM集～   "
 5711   DATA "2:クラシック名曲集                   "
 5712 '
 5713   GOSUB *INIT_SYS
 5714 '
 5715 '================ Main Loop
 5716 *PAD_WATCH
 5717   TRIGGA=0
 5718   *PAD_W2:IF TRIGGA THEN KEY$="":KEY=0:GOTO *PAD_TRIGGA
 5719     KEY$=INKEY$:IF KEY$="" THEN *PAD_W2 ELSE KEY=ASC(KEY$)
 5720   *PAD_TRIGGA
 5721     WTIME=0
 5722     IF KEY=KEY_DOWN  OR KEY=KEY_D2 OR (TRIGGA AND @PAD_DOWN) THEN GOSUB *MOVE_DOWN:GOTO *PAD_WATCH
 5723     IF KEY=KEY_UP    OR KEY=KEY_U2 OR (TRIGGA AND @PAD_UP)   THEN GOSUB *MOVE_UP:  GOTO *PAD_WATCH
 5724     IF KEY=KEY_ENTER OR (TRIGGA AND (@PAD_START OR @PAD_C))  THEN *PLAY_GO
 5725     IF KEY=KEY_ESC   OR (TRIGGA AND (@PAD_Y     OR @PAD_B))  THEN POKE 0,0,0:GOSUB *FADEOUT:GOTO *MAIN_MENU
 5726     GOTO *PAD_WATCH
 5727 '
 5728 '================
 5729 *MOVE_DOWN
 5730   IF CNUM < NUM_OF_MSTR THEN CNUM=CNUM+1
 5731   IF (CNUM > 4) AND (CNUM <= (NUM_OF_MSTR - 3)) THEN MTOP=MTOP+1
 5732   GOSUB *DISPLAY_MENU
 5733   RETURN
 5734 '
 5735 '----------------
 5736 *MOVE_UP
 5737   IF CNUM > 1 THEN CNUM=CNUM-1
 5738   IF (CNUM > 3) AND (CNUM < (NUM_OF_MSTR - 3)) THEN MTOP=MTOP-1
 5739   GOSUB *DISPLAY_MENU
 5740   RETURN
 5741 '
 5742 '----------------
 5743 *DISPLAY_MENU
 5744   KPRINT (10,20,0,1,0),MSTR$(0),,,RGB(20,0,20)    :'ﾀｲﾄﾙﾋｮｳｼﾞ
 5745   LINE(10,164)-(307,164),RGB(31,31,0):KPRINT (10,124),"  ここから先は、コントロールパッド":KPRINT "  を使用してください。"
 5746   KPRINT (10,166),"↑↓";,RGB(31,22,22):KPRINT FIX "(ﾎｳｺｳ ﾎﾞﾀﾝ )--- ";,RGB(21,21,10)
 5747   KPRINT FIX "Move Cursor",RGB(0,31,20)
 5748   KPRINT (10,182-8),FIX "  START / Cﾎﾞﾀﾝ";,RGB(31,22,22):KPRINT FIX " --- ";,RGB(21,21,10)
 5749   KPRINT FIX "LOAD & EXEC.",RGB(0,31,20)
 5750   KPRINT (10,198-16),FIX "          Bﾎﾞﾀﾝ";,RGB(31,22,22):KPRINT FIX " --- ";,RGB(21,21,10)
 5751   KPRINT FIX "RETURN Main Menu",RGB(0,31,20)
 5752   MDY=38
 5753   FOR I=MTOP TO MTOP+1
 5754     IF I=CNUM THEN
 5755       KPRINT (10,MDY),MSTR$(I),RGB(31,31,31),,RGB(0,20,20)
 5756     ELSE
 5757       KPRINT (10,MDY),MSTR$(I),RGB(31,31,31)
 5758     ENDIF
 5759     MDY=MDY+18
 5760   NEXT
 5761   RETURN
 5762 '
 5763 '================ Subroutines
 5764 *INIT_SYS
 5765   MTOP=1:CNUM=PEEK(0,1):EMNUM=-1
 5766   RESTORE *MENU_STR:FOR I=0 TO NUM_OF_MSTR:READ MSTR$(I):NEXT
 5767 '
 5768   PAD_ABCXYZSTART = @PAD_A+@PAD_B+@PAD_C+@PAD_START+@PAD_X+@PAD_Y+@PAD_Z
 5769   PAD_UDLR  = @PAD_RIGHT+@PAD_LEFT+@PAD_DOWN+@PAD_UP+@PAD_L+@PAD_R
 5770   KEY_DOWN  = 31:  KEY_D2=ASC("X")-64
 5771   KEY_UP    = 30:  KEY_U2=ASC("E")-64
 5772   KEY_ENTER = 13: KEY_ESC = 27
 5773 '
 5774   SCREEN 0:WIDTH 1,1,38,26:COLOR ,RGB(31,31,31):COLOROFS ON,0:COLOROFS(-255,-255,-255):VSYNC:OFS=255
 5775   INITIAL_TOUCH=20:AFTER_TOUCH=3
 5776   ON INTERVAL (0) GOSUB *INT_COUNT: INTERVAL (0) ON,1
 5777 *CLEAR_INKEY: IF INKEY$<>"" THEN *CLEAR_INKEY
 5778   TRIGGA=PAD(0,2) :' Clear trigga
 5779   GOSUB *DISPLAY_MENU:GOSUB *FADEIN
 5780   RETURN
 5781 '
 5782 '----------------
 5783 *INT_COUNT:' Make repeat trigga of PAD ULDR
 5784   IF PAD(0)=52 THEN *INT_COUNT_RET: 'Ignore keyboard pad
 5785   TRIGGA=TRIGGA OR (PAD(0,2) AND PAD_ABCXYZSTART): 'Update A,B,C,START buttons
 5786   TESTBTN=PAD(0,1):IF (TESTBTN AND PAD_UDLR) = 0 THEN REPEAT_COUNT=0: GOTO *INT_COUNT_RET
 5787   IF TESTBTNL<>TESTBTN THEN TESTBTNL=TESTBTN: REPEAT_COUNT=0
 5788   IF REPEAT_COUNT=0 THEN REPEAT_COUNT=INITIAL_TOUCH: TRIGGA=TESTBTN: GOTO *INT_COUNT_RET
 5789   REPEAT_COUNT=REPEAT_COUNT-1: IF REPEAT_COUNT <= 0 THEN REPEAT_COUNT=AFTER_TOUCH: TRIGGA=TESTBTN
 5790 *INT_COUNT_RET
 5791   SKCLOSE
 5792   RETURN
 5793 '
 5794 '================ Start Sound Sample Program
 5795 *PLAY_GO:SCREEN 0:WIDTH 1,1,38,26
 5796   POKE 0,0,56:POKE 0,1,CNUM:POKE 0,2,1:POKE 0,4,1
 5797   IF CNUM=1 THEN PRINT "Loading S_G_ARTS.B":GOSUB *FADEOUT:LOAD"CD:S_G_ARTS",R
 5798   IF CNUM=2 THEN PRINT "Loading S_CLASSI.B":GOSUB *FADEOUT:LOAD"CD:S_CLASSI",R
 5799   GOTO *PAD_WATCH
 5800 '
 5801 '----------------------------
 5802 '●音色セット別の楽器名リスト
 5803 '----------------------------
 5804 *STANDARD_NAME
 5805 DATA "BEEP                             "
 5806 DATA "HEY! DANSEI                      "
 5807 DATA "HUA DANSEI                       "
 5808 DATA "POH DANSEI                       "
 5809 DATA "KYA ZYOSEI                       "
 5810 DATA "TAH ZYOSEI                       "
 5811 DATA "TOH ZYOSEI                       "
 5812 DATA "WAH ZYOSEI                       "
 5813 DATA "YAH ZYOSEI                       "
 5814 DATA "HAH DANSEI                       "
 5815 DATA "TOH2 DANSEI                      "
 5816 DATA "CHUKIN                           "
 5817 DATA "NOISE                            "
 5818 DATA "BA                               "
 5819 DATA "BASHA                            "
 5820 DATA "DOKA                             "
 5821 DATA "KACHA                            "
 5822 DATA "SHU                              "
 5823 DATA "SAW WAVE                         "
 5824 DATA "SINE WAVE                        "
 5825 DATA "SQUARE WAVE                      "
 5826 DATA "SAW SE1                          "
 5827 DATA "SINE SE1                         "
 5828 DATA "SQUARE SE1                       "
 5829 DATA "SAW SE2                          "
 5830 DATA "SINE SE2                         "
 5831 DATA "SQUARE SE2                       "
 5832 DATA "SINE SE3                         "
 5833 DATA "Crystal Bell                     "
 5834 DATA "GLOCKEN                          "
 5835 DATA "RUM                              "
 5836 DATA "Drum Set (0~/38/40/41/42~/45...) "
 5837 DATA "Percussion Set (0~/40~/55~/63...)"
 5838 DATA "Pick Bass (0~:36~127)            "
 5839 DATA "A.Bass (0~:36~96)                "
 5840 DATA "Synth Bass (0~:0~127)            "
 5841 DATA "A.Piano (0~:36~88)               "
 5842 DATA "E.Piano (0~:24~104)              "
 5843 DATA "Organ (0~/63~:28~62)             "
 5844 DATA "A.Guitar (0~:28~108)             "
 5845 DATA "Clean Guitar (0~/73~:24~72)      "
 5846 DATA "Over Drive Guitar (0~/58~:36~88) "
 5847 DATA "Glocken (0~:60~96)               "
 5848 DATA "Marimba (0~:48~108)              "
 5849 DATA "Strings (0~/68~:28~100)          "
 5850 DATA "Brass Sec. (0~:40~96)            "
 5851 DATA "Horn (0~:53~79)                  "
 5852 DATA "A.Sax (0~:48~88)                 "
 5853 DATA "Flute & Piccolo (0~/45~:60~96)   "
 5854 DATA "Oboe (0~:48~89)                  "
 5855 DATA "Clarinet (0~:36~89)              "
 5856 DATA "Synth Pad 1 (0~/0~:24~91)        "
 5857 DATA "Synth Pad 2 (0~/0~:43~96)        "
 5858 DATA "Brightness  (0~/0~/0~:60~96)     "
 5859 DATA "Solo Synth Lead 1 (0~:35~98)     "
 5860 DATA "Solo Synth Lead 2 (0~:24~103)    "
 5861 DATA "***"
 5862 '
 5863 *ORCHEST_NAME
 5864 DATA "BEEP                             "
 5865 DATA "HEY! DANSEI                      "
 5866 DATA "HUA DANSEI                       "
 5867 DATA "POH DANSEI                       "
 5868 DATA "KYA ZYOSEI                       "
 5869 DATA "TAH ZYOSEI                       "
 5870 DATA "TOH ZYOSEI                       "
 5871 DATA "WAH ZYOSEI                       "
 5872 DATA "YAH ZYOSEI                       "
 5873 DATA "HAH DANSEI                       "
 5874 DATA "TOH2 DANSEI                      "
 5875 DATA "CHUKIN                           "
 5876 DATA "NOISE                            "
 5877 DATA "BA                               "
 5878 DATA "BASHA                            "
 5879 DATA "DOKA                             "
 5880 DATA "KACHA                            "
 5881 DATA "SHU                              "
 5882 DATA "SAW WAVE                         "
 5883 DATA "SINE WAVE                        "
 5884 DATA "SQUARE WAVE                      "
 5885 DATA "SAW SE1                          "
 5886 DATA "SINE SE1                         "
 5887 DATA "SQUARE SE1                       "
 5888 DATA "SAW SE2                          "
 5889 DATA "SINE SE2                         "
 5890 DATA "SQUARE SE2                       "
 5891 DATA "SINE SE3                         "
 5892 DATA "NOISE2                           "
 5893 DATA "GLOCKEN                          "
 5894 DATA "RUM                              "
 5895 DATA "Orchest.Percussion (36/38~/54...)"
 5896 DATA "A.Piano (0~/32~/64~/70~/90~)     "
 5897 DATA "Pipe Organ (0~)                  "
 5898 DATA "Glocken (0~)                     "
 5899 DATA "Strings Arco (0~/68~)            "
 5900 DATA "Strings Pizz (0~/66~)            "
 5901 DATA "Harp (0~)                        "
 5902 DATA "Trombone (0~)                    "
 5903 DATA "Trumpet (0~)                     "
 5904 DATA "Horn (0~)                        "
 5905 DATA "Brass (T.B./0~)(T.P./0~)(H./0~)  "
 5906 DATA "Oboe (0~)                        "
 5907 DATA "Clarinet (0~)                    "
 5908 DATA "Flute (0~)                       "
 5909 DATA "Ocarina (0~)                     "
 5910 DATA "Timpani (0~)                     "
 5911 DATA "Orche.Cymbal (0~)                "
 5912 DATA "Marimba (0~)                     "
 5913 DATA "***"
 5914 '
 5915 *ROCK_NAME
 5916 DATA "BEEP                             "
 5917 DATA "HEY! DANSEI                      "
 5918 DATA "HUA DANSEI                       "
 5919 DATA "POH DANSEI                       "
 5920 DATA "KYA ZYOSEI                       "
 5921 DATA "TAH ZYOSEI                       "
 5922 DATA "TOH ZYOSEI                       "
 5923 DATA "WAH ZYOSEI                       "
 5924 DATA "YAH ZYOSEI                       "
 5925 DATA "HAH DANSEI                       "
 5926 DATA "TOH2 DANSEI                      "
 5927 DATA "CHUKIN                           "
 5928 DATA "NOISE                            "
 5929 DATA "BA                               "
 5930 DATA "BASHA                            "
 5931 DATA "DOKA                             "
 5932 DATA "KACHA                            "
 5933 DATA "SHU                              "
 5934 DATA "SAW WAVE                         "
 5935 DATA "SINE WAVE                        "
 5936 DATA "SQUARE WAVE                      "
 5937 DATA "SAW SE1                          "
 5938 DATA "SINE SE1                         "
 5939 DATA "SQUARE SE1                       "
 5940 DATA "SAW SE2                          "
 5941 DATA "SINE SE2                         "
 5942 DATA "SQUARE SE2                       "
 5943 DATA "SINE SE3                         "
 5944 DATA "NOISE2                           "
 5945 DATA "GLOCKEN                          "
 5946 DATA "RUM                              "
 5947 DATA "Drums Set (36/37~/39/41/42/45...)"
 5948 DATA "Fingered Bass (0~/46~/61~:36~55) "
 5949 DATA "Picked Bass (0~:40~64)           "
 5950 DATA "Power Guitar (0~/0~:40~84)       "
 5951 DATA "Solo Guitar (0~:57~81)           "
 5952 DATA "Clean Guitar (0~:50~86)          "
 5953 DATA "Organ (0~:38~91)                 "
 5954 DATA "Synth Brass (0~:36~84)           "
 5955 DATA "Choir Pad (0~/0~:47~91)          "
 5956 DATA "***"
 5957 '
 5958 *DANCE_NAME
 5959 DATA "BEEP                             "
 5960 DATA "HEY! DANSEI                      "
 5961 DATA "HUA DANSEI                       "
 5962 DATA "POH DANSEI                       "
 5963 DATA "KYA ZYOSEI                       "
 5964 DATA "TAH ZYOSEI                       "
 5965 DATA "TOH ZYOSEI                       "
 5966 DATA "WAH ZYOSEI                       "
 5967 DATA "YAH ZYOSEI                       "
 5968 DATA "HAH DANSEI                       "
 5969 DATA "TOH2 DANSEI                      "
 5970 DATA "CHUKIN                           "
 5971 DATA "NOISE                            "
 5972 DATA "BA                               "
 5973 DATA "BASHA                            "
 5974 DATA "DOKA                             "
 5975 DATA "KACHA                            "
 5976 DATA "SHU                              "
 5977 DATA "SAW WAVE                         "
 5978 DATA "SINE WAVE                        "
 5979 DATA "SQUARE WAVE                      "
 5980 DATA "SAW SE1                          "
 5981 DATA "SINE SE1                         "
 5982 DATA "SQUARE SE1                       "
 5983 DATA "SAW SE2                          "
 5984 DATA "SINE SE2                         "
 5985 DATA "SQUARE SE2                       "
 5986 DATA "SINE SE3                         "
 5987 DATA "NOISE2                           "
 5988 DATA "GLOCKEN                          "
 5989 DATA "RUM                              "
 5990 DATA "Drums (35~/37/38~/41/42/45/46...)"
 5991 DATA "Synth Bass (0~:0~56)             "
 5992 DATA "Piano (0~/42~/49~/56~/75~/81~...)"
 5993 DATA "Warm Bell (0~/39~/45~/51~/57~...)"
 5994 DATA "Vocoder Vox (0~:36~84)           "
 5995 DATA "Synth Brass (0~:36~84)           "
 5996 DATA "Square Wave (0~/39~/45~/51~...)  "
 5997 DATA "Organ (0~)                       "
 5998 DATA "Voice Ahh (0~/48~/54~/60~:36~84) "
 5999 DATA "Pulse Wave (0~/38~/44~/50~...)   "
 6000 DATA "Filter 1 (0~)                    "
 6001 DATA "Filter 2 (0~)                    "
 6002 DATA "Space Pad (0~/62~/66~/69~/71~...)"
 6003 DATA "Synth Pad (0~/62~/64~/67~/71~...)"
 6004 DATA "Metal Pad (0~/62~/66~/69~/71~...)"
 6005 DATA "Voice Pad (0~/48~/54~/60~ /0~)   "
 6006 DATA "***"
 6007 '
 6008 *PIANO_NAME
 6009 DATA "BEEP                             "
 6010 DATA "Piano (0~/34~/41~...)            "
 6011 DATA "***"
 6012 '
 6013 *METAL_NAME
 6014 DATA "BEEP                             "
 6015 DATA "Heavy Mute (0~:45~64)            "
 6016 DATA "Power Chord (0~:45~64)           "
 6017 DATA "Rock Bass (0~:45~64)             "
 6018 DATA "Pick Scratch (0~:48~55)          "
 6019 DATA "Drums (36/37~/41/42/45/46/48...) "
 6020 DATA "Solo Guitar (0~:57~81)           "
 6021 DATA "Harmonics (0~:52~69)             "
 6022 DATA "***"
 6023 '
 6024 *ETHNIC_NAME
 6025 DATA "BEEP                             "
 6026 DATA "Bagpipe (0~/56~/60~/65~:36~96)   "
 6027 DATA "Banjo (0~/58~/68~/75~:24~65)     "
 6028 DATA "Koto (0~:24~65)                  "
 6029 DATA "Shakuhati (0~/55~/73~:24~60)     "
 6030 DATA "Shamisen (0~/66~/76~ /0~:24~60)  "
 6031 DATA "Kalimba(0~/58~/64~/71~/78~:36~96)"
 6032 DATA "Steel Drum (0~:36~96)            "
 6033 DATA "Sitar (0~/72~:24~65)             "
 6034 DATA "Accordion (0~/59~/68~/78~)       "
 6035 DATA "Percussion (36/37/38/39/40/41...)"
 6036 DATA "***"
 6037 '
 6038 *MBOXPO_NAME
 6039 DATA "BEEP                             "
 6040 DATA "Music Box (0~96)                 "
 6041 DATA "Pipe Organ (0~/55~/66~)          "
 6042 DATA "***"
 6043 '
 6044 *EXTRA1_NAME
 6045 DATA "BEEP                             "
 6046 DATA "Orche.Hit 1 (0~:72)              "
 6047 DATA "Orche.Hit 2 (0~:72)              "
 6048 DATA "Orche.Hit 3 (0~:72)              "
 6049 DATA "Orche.Hit 4 (0~:72)              "
 6050 DATA "Orche.Hit 5 (0~:72)              "
 6051 DATA "Orche.Hit 6 (0~:72)              "
 6052 DATA "Orche.Hit 7 (0~:72)              "
 6053 DATA "Cembalo (0~/41~/54~/66~/82~)     "
 6054 DATA "Harmonica (0~)                   "
 6055 DATA "Oboe (0~/53~/65~)                "
 6056 DATA "Cow Bell (0~)                    "
 6057 DATA "Gun (0~)                         "
 6058 DATA "***"
 6059 '
 6060 *EXTRA2_NAME
 6061 DATA "BEEP                             "
 6062 DATA "Tromborn (0~/46~/58~)            "
 6063 DATA "Trumpet (0~/61~/73~)             "
 6064 DATA "Big Brass (0~/44~/56~)           "
 6065 DATA "Over Drive Guitar (0~/46~/58~)   "
 6066 DATA "***"
 6067 '
 6068 *EXTRA3_NAME
 6069 DATA "BEEP                             "
 6070 DATA "LOOP150A (0~:60)                 "
 6071 DATA "LOOP150B (0~:60)                 "
 6072 DATA "LOOP150C (0~:60)                 "
 6073 DATA "LOOP163 (0~:60)                  "
 6074 DATA "LOOP169 (0~:60)                  "
 6075 DATA "***"
 6076 '
 6077 *EXTRA4_NAME
 6078 DATA "BEEP                             "
 6079 DATA "Techno SE 1 (0~:60)              "
 6080 DATA "Techno SE 2 (0~:60)              "
 6081 DATA "Techno SE 3 (0~:60)              "
 6082 DATA "Techno SE 4 (0~:60)              "
 6083 DATA "Techno SE 5 (0~:60)              "
 6084 DATA "Techno SE 6 (0~:60)              "
 6085 DATA "Techno SE 7 (0~:60)              "
 6086 DATA "Techno SE 8 (0~:60)              "
 6087 DATA "LOOP149A (0~:60)                 "
 6088 DATA "LOOP149B (0~:60)                 "
 6089 DATA "LOOP201 (0~:60)                  "
 6090 DATA "***"
 6091 '
 6092 *GM_FM_NAME
 6093 DATA "Acoustic Grand Piano             "
 6094 DATA "Bright Acoustic Piano            "
 6095 DATA "Electric grand Piano             "
 6096 DATA "Honky Tonk Piano                 "
 6097 DATA "Eiectric Piano 1                 "
 6098 DATA "Electric Piano 2                 "
 6099 DATA "Harpsichord                      "
 6100 DATA "Clavinet                         "
 6101 DATA "Celesta                          "
 6102 DATA "Glockenspiel                     "
 6103 DATA "Music Box                        "
 6104 DATA "Vibraphone                       "
 6105 DATA "Marimba                          "
 6106 DATA "Xylophone                        "
 6107 DATA "Tubular bells                    "
 6108 DATA "Dulcimer                         "
 6109 DATA "Drawbar Organ                    "
 6110 DATA "Percussive Organ                 "
 6111 DATA "Rock Organ                       "
 6112 DATA "Church Organ                     "
 6113 DATA "Reed Organ                       "
 6114 DATA "Accordion                        "
 6115 DATA "Harmonica                        "
 6116 DATA "Tango Accordion                  "
 6117 DATA "Nylon Accustic Guitar            "
 6118 DATA "Steel Acoustic Guitar            "
 6119 DATA "Jazz Electric Guitar             "
 6120 DATA "Ciean Electric Guitar            "
 6121 DATA "Muted Electric Guitar            "
 6122 DATA "Overdrive Guitar                 "
 6123 DATA "Distorted Guitar                 "
 6124 DATA "Guitar Harmonics                 "
 6125 DATA "Acoustic Bass                    "
 6126 DATA "Electric Fingered Bass           "
 6127 DATA "Electric Picked Bass             "
 6128 DATA "Fretless Bass                    "
 6129 DATA "Slap Bass 1                      "
 6130 DATA "Slap Bass 2                      "
 6131 DATA "Syn Bass 1                       "
 6132 DATA "Syn Bass 2                       "
 6133 DATA "Violin                           "
 6134 DATA "Viola                            "
 6135 DATA "Cello                            "
 6136 DATA "Contrabass                       "
 6137 DATA "Tremolo Strings                  "
 6138 DATA "Pizzicato Strings                "
 6139 DATA "Orchestral Harp                  "
 6140 DATA "Timpani                          "
 6141 DATA "String Ensemble 1                "
 6142 DATA "String Ensemble 2 (Slow)         "
 6143 DATA "Syn Strings 1                    "
 6144 DATA "Syn Strings 2                    "
 6145 DATA "Choir Aahs                       "
 6146 DATA "Voice Oohs                       "
 6147 DATA "Syn Choir                        "
 6148 DATA "Orchestral Hit                   "
 6149 DATA "Trumpet                          "
 6150 DATA "Trombone                         "
 6151 DATA "Tuba                             "
 6152 DATA "Muted Trumpet                    "
 6153 DATA "French Horn                      "
 6154 DATA "Brass Section                    "
 6155 DATA "Syn Brass 1                      "
 6156 DATA "Syn Brass 2                      "
 6157 DATA "Soprano Sax                      "
 6158 DATA "Alto Sax                         "
 6159 DATA "Tenor Sax                        "
 6160 DATA "Baritone Sax                     "
 6161 DATA "Oboe                             "
 6162 DATA "English Horn                     "
 6163 DATA "Bassoon                          "
 6164 DATA "Clarinet                         "
 6165 DATA "Piccolo                          "
 6166 DATA "Flute                            "
 6167 DATA "Recorder                         "
 6168 DATA "Pan Flute                        "
 6169 DATA "Bottle Blow                      "
 6170 DATA "Shakuhachi                       "
 6171 DATA "Whistle                          "
 6172 DATA "Ocarina                          "
 6173 DATA "Syn Square Wave                  "
 6174 DATA "Syn Sawtooth Wave                "
 6175 DATA "Syn Calliope                     "
 6176 DATA "Syn Chiff                        "
 6177 DATA "Syn Charang                      "
 6178 DATA "Syn Voice                        "
 6179 DATA "Syn Fifths Sawtooth Wave         "
 6180 DATA "Syn Brass & Lead                 "
 6181 DATA "New Age Syn Pad                  "
 6182 DATA "Warm Syn Pad                     "
 6183 DATA "Polysynth Syn Pad                "
 6184 DATA "Choir Syn Pad                    "
 6185 DATA "Bowed Syn Pad                    "
 6186 DATA "Metal Syn Pad                    "
 6187 DATA "Halo Syn Pad                     "
 6188 DATA "Sweep Syn Pad                    "
 6189 DATA "SFX Rain                         "
 6190 DATA "SFX Soundtrack                   "
 6191 DATA "SFX Crystal                      "
 6192 DATA "SFX Atmosphere                   "
 6193 DATA "SFX Brightness                   "
 6194 DATA "SFX Goblins                      "
 6195 DATA "SFX Echoes                       "
 6196 DATA "SFX Sci-fi                       "
 6197 DATA "Sitar                            "
 6198 DATA "Banjo                            "
 6199 DATA "Shamisen                         "
 6200 DATA "Koto                             "
 6201 DATA "Kalimba                          "
 6202 DATA "Bag Pipe                         "
 6203 DATA "Fiddle                           "
 6204 DATA "Shanai                           "
 6205 DATA "Tinkle Bell                      "
 6206 DATA "Agogo                            "
 6207 DATA "Steel Drums                      "
 6208 DATA "Woodblock                        "
 6209 DATA "Taiko Drum                       "
 6210 DATA "Melodic Tom                      "
 6211 DATA "Syn Drum                         "
 6212 DATA "Reverse Cymbal                   "
 6213 DATA "Guitar Fret Noise                "
 6214 DATA "Breath Noise                     "
 6215 DATA "Seashore                         "
 6216 DATA "Bird Tweet                       "
 6217 DATA "Telephone Ring                   "
 6218 DATA "Helicopter                       "
 6219 DATA "Applause                         "
 6220 DATA "Gun Shot                         "
 6221 DATA "***"

