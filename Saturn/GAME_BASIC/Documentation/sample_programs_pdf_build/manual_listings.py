# Program listings from the two manuals, as printed (English translation of the
# Tutorial and Reference Manuals in this project). Japanese comments translated.
TM = [
 ("A digital clock", "TM section 2.3, \"Making a digital clock\"",
  "Your first real program: it enlarges the text with `ZOOM` and prints the time again and again. The same program is `CLOCK.B` on the CD.",
"""100 SCREEN 0
110 ZOOM 4,2,4
120 *LOOP
130 LOCATE 0,2:PRINT RIGHT$(DATE$,18)
140 GOTO *LOOP"""),
 ("Counting with IF...THEN", "TM section 2.4, \"The IF~THEN command\"",
  "Counts from 2 to 500 and stops. Line 35 decides when to leave the loop.",
"""10 A=1
20 A=A+1
30 PRINT A
35 IF A=500 THEN GOTO 50
40 GOTO 20
50 END"""),
 ("Adding up with FOR...NEXT", "TM section 2.4, \"The FOR~NEXT command\"",
  "Adds the numbers 1 to 10 and prints 55.",
"""10 A=0
20 FOR I=1 TO 10
30 A=A+I
40 NEXT I
50 PRINT A
60 END"""),
 ("Drawing a table, the long way", "TM section 2.4, \"Making a subroutine\"",
  "Draws a 4 by 4 table with one `PRINT` per line. Only three different lines are used, which is the cue for the next version.",
"""100 PRINT "-----------------"
110 PRINT "|   |   |   |   |"
120 PRINT "|---+---+---+---|"
130 PRINT "|   |   |   |   |"
140 PRINT "|---+---+---+---|"
150 PRINT "|   |   |   |   |"
160 PRINT "|---+---+---+---|"
170 PRINT "|   |   |   |   |"
180 PRINT "-----------------"
190 END"""),
 ("Drawing a table with subroutines", "TM section 2.4, \"Making a subroutine\"",
  "The same table, with each kind of line made into a subroutine and called with `GOSUB`.",
"""100 GOSUB 200
110 FOR I=1 TO 4
120 GOSUB 210:GOSUB 220
130 NEXT
140 GOSUB 210:GOSUB 200
150 END
200 PRINT "-----------------":RETURN
210 PRINT "|   |   |   |   |":RETURN
220 PRINT "|---+---+---+---|":RETURN"""),
 ("Array elements from DATA", "TM section 2.4, \"READ and DATA\"",
  "Fills a string array from a `DATA` line with `READ` and prints it.",
"""100 DIM HAKO$(4)
110 FOR I=0 TO 4
120 READ HAKO$(I)
130 PRINT HAKO$(I)
140 NEXT
150 END
160 DATA CANDY,MANJYU,CHOCO,SENBEI,JERRY"""),
 ("Moving a sprite", "TM section 2.5, \"What is a sprite?\"",
  "Defines a red 16x16 sprite and moves it slowly between a blue and a green circle. The book prints notes beside the lines; here they are shown as comments, which you can type in or leave out.",
"""100 SCREEN 1                          :'initialise the screen
110 PALETTE 10,1,RGB(31,0,0)          :'red in palette 1 of BG10 (the sprite plane)
120 SPRITE$=STRING$(16*16,CHR$(1))    :'define the sprite
130 '
140 PALETTE 0,2,RGB(0,0,31)           :'palette for the blue circle
150 PALETTE 0,3,RGB(0,31,0)           :'palette for the green circle
160 CIRCLE(100,50),25,2,F             :'draw the blue circle
170 CIRCLE( 200, 150), 25, 3, F       :'draw the green circle
180 '
190 FOR I= 0 TO 300 STEP .01          :'loop that moves the sprite
200     PUTSPRITE 1,(I,100),0         :'move the sprite
210 NEXT I"""),
 ("Object-type sprites", "TM section 2.5, \"Object-type sprites\"",
  "The three kinds of object sprite from one 8x8 texture: a rotating one, one with separate X and Y scale, and a 4-point distorted one. `XSIN` and `XCOS` make them wobble.",
"""100 SCREEN
110 '
120 PALETTE 10,1,RGB(31,31,31)     :'sprite colour
130 SETTEX 0,8,8,256,READ          :'texture pattern from the DATA statements
140 SETATR 0,1,(0, 1, 3, 0, 0, 0)
150 '
160 OBJ(1,@TYPE) = 1               :'Z-rotation sprite
170 OBJ(1,@ATR)  = 0
180 OBJ(1,@XP)   = -100,-50,300    :' X,Y position given
190 '
200 OBJ(2,@TYPE) = 2               :' sprite with independent H/V scale
210 OBJ(2,@ATR)  = 0
220 OBJ(2,@XP)   = 100,30,200      :' X,Y position given
230 '
240 OBJ(3,@TYPE) = 3               :' 4-point sprite
250 OBJ(3,@ATR)  = 0
260 OBJ(3,@XP)   = -70,50,100      :' X,Y,Z position given (reference point for the 4 points)
270 '
280 *LOOP
290 OBJ(1,@ZR) = XSIN(N*3)/16      :'tilt left and right
300 OBJ(1,@XS) = XSIN(N/4)*8       :'scale slowly
310 '
320 OBJ(2,@XS) = XSIN(N)*8         :'give the left/right scale factors
330 OBJ(2,@YS) = XCOS(N)*8
340 '
350 P0_X = -16 + XSIN(N*1.2)*50 :P0_Y = -16 + XSIN(N)*10
360 P1_X = +16 + XCOS(N*1.2)*50 :P1_Y = -16 + XCOS(N)*10
370 P2_X = +16 + XSIN(N)*50     :P2_Y = +16 + XSIN(N)*10
380 P3_X = -16 + XCOS(N)*50     :P3_Y = +16 + XCOS(N)*10
390 OBJ(3,@XP0) = P0_X,P0_Y, P1_X,P1_Y, P2_X,P2_Y, P3_X,P3_Y
400 '
410  N=(N+&H0.001) AND! &HFFFF.FFFC
420  GOTO *LOOP
430 '
440 DATA 0000000101000000
450 DATA 0000010000010000
460 DATA 0001000000000100
470 DATA 0100000101000001
480 DATA 0100000101000001
490 DATA 0001000000000100
500 DATA 0000010000010000
510 DATA 0000000101000000"""),
 ("Turning a circle", "TM section 2.5, \"Processing and transforming shapes\"",
  "Draws a green circle on a rotation screen and turns the screen clockwise with `ROTATE`.",
"""100 SCREEN 3
110 PALETTE 2,100,RGB(0,31,0)
120 CIRCLE(50,50),25,100,F
130 ROTCENTER 160,112,0
140 ROTPOS 0,0,0
150 '
160 I=1
170 ROTATE ,0,I
180 I=I-.0001
190 IF I<0 THEN I=1
200 GOTO 170"""),
 ("A spinning red polygon board", "TM section 2.6, \"Making a polygon\"",
  "The smallest polygon program: it makes a plain red 64x64 texture, a 4-vertex polygon and an attribute, joins them in object 1 and sets it turning. Every 3D sample builds on these steps.",
"""100 'Polygon Test Program (KSIN)
110 SCREEN 0
120 OBJ_NO = 1
130 TEX_ID = 0
140 VER_ID = 0
150 POL_ID = 0
160 ATR_ID = 0
170 TEX_W  = 64
180 TEX_H  = 64
190 '
200 TEX_COL = RGB(31, 0, 0)
210 TEX_COL = TEX_COL OR &H8000
220 PIXCEL$ = HEX$(TEX_COL)
230 PIXCEL$ = RIGHT$(PIXCEL$, 4)
240 PIXCEL$ = HEXBIN$(PIXCEL$)
250 TEX$    = STRW$(TEX_W*TEX_H*2, PIXCEL$)
260 '
270 SETTEX     TEX_ID, TEX_W, TEX_H, 32768, TEX$
280 SETVERTEX  VER_ID, 4, READ
290 SETPOLYGON POL_ID, 1, VER_ID, , (0, 1, 2, 3)
300 SETATR     ATR_ID, 1, (0, 1, 3, TEX_ID, 0, 0)
310 '
320 OBJTYPE OBJ_NO, 4
330 OBJATR  OBJ_NO, POL_ID, ATR_ID
340 OBJPOS  OBJ_NO, 0, 0, 0
350 OBJTURN OBJ_NO, .002, -.004
360 '
370 DATA -32, -32, 0
380 DATA  32, -32, 0
390 DATA  32,  32, 0
400 DATA -32,  32, 0"""),
 ("Virtua Gun test", "TM section 2.9, \"Using the Virtua Gun\"",
  "Point the Virtua Gun at the screen and pull the trigger to draw lines; press Start to fill an area; trigger and Start together clear the screen. A polygon-font \"A\" follows the gun. Lines 1260 and 1270 are each one program line (wrapped in the book).",
"""1000 '[Virtua Gun test (motos)]
1010 ' Always set SYNC to 2 or -2.
1020 ' Make the background or display plane bright. The sample colour is cyan.
1030 ' If you use a dark screen, brighten the screen when the trigger
1040 ' is pulled and wait about 2 SYNCs before reading.
1050 ' Does not respond on TVs that use a digital frame memory.
1060 ' The Virtua Gun's DEVICE ID is "37".
1070 ' Connect the Virtua Gun directly to control port 2.
1080 ' It is best to calibrate it in the program.
1090 '-------------------------------------------------------
1100 ' This test connects to control port 2.
1110 '   Trigger draws lines
1120 '   Start button fills
1130 '   Both together CLEAR
1140 '
1150 SCREEN,,,2: GUNPORT=15
1160 SETPFONT 1,65:OBJ(1,37)=.03
1170 COLOR,,,RGB(0,10,20)
1180 *LOOP: LOCATE 0,0
1190  PRINT PAD(GUNPORT,1)
1200  PRINT PAD(GUNPORT,3)
1210  PRINT PAD(GUNPORT,4)
1220  XP=PAD(GUNPORT,3)-&H80
1230  YP=PAD(GUNPORT,4)-&H0
1240  OBJ(1,4)=XP-&HE0,YP-&H80
1250  IF PAD(GUNPORT,1) THEN
1260     IF PAD(GUNPORT,1) = &H400 THEN LINE -(XP,YP),RGB(RND(32),RND(32),RND(32))
1270     IF PAD(GUNPORT,1) = &H800 THEN PAINT (XP,YP),ON RGB(RND(32),RND(32),RND(32))
1280     IF PAD(GUNPORT,1) = &HC00 THEN CLS 0
1290  ENDIF
1300 GOTO *LOOP"""),
]
RM = [
 ("Building a song in USERDATA", "RM, `USERDATA`, example 1",
  "Writes MML into user memory with `USERDATA`, saves it to backup RAM with `BSAVE` and registers it with `SETSONG`. The `:` lines stand for parts of the program the manual leaves out.",
"""100 CLEAR 100:RESTORE *NORMAL_DATA
110 USERDATA 0,0,"@44L8CDEFGAB>C"
120 USERDATA     "NEXT"
130 USERDATA     "C<BAGFEDC"
140 USERDATA     "ENDSONG"
150 BSAVE"BRAM:MML_TST",USERDATA(0),USERDATA(1),USERDATA(2),USERDATA(3)
160 SETSONG
170 USERDATA END
     :
300 *NORMAL_DATA
310 DATA ..."""),
 ("Following the music with MMLSTAT", "RM, `MMLSTAT()`, example 1",
  "Plays three notes and prints each note name as it sounds, by watching the note number that `MMLSTAT(0,1)` returns.",
"""100 EFFECT (I),"CDE"                    :'starts playback
110 *LOOP
120 IF PLAYSTAT(I)=0 THEN END           :'ends when it has finished sounding
130 MN=MMLSTAT(0,1)                     :'reads the new status
140 IF MN=MO THEN *LOOP ELSE MO=MN      :'same as last time: go back
150 IF MN=60 THEN PRINT "C ";           :'different: show the note
160 IF MN=62 THEN PRINT "D ";
170 IF MN=64 THEN PRINT "E ";
180 GOTO *LOOP"""),
 ("Song data for SETSONG", "RM, `SETSONG`, example",
  "How song data is laid out in `DATA` for `SETSONG`: `SONG1`, track strings, `NEXT` to continue the strings, `SONG2` for the next song and `ENDSONG` at the end.",
"""1000 SETSONG
 :
2000 DATA SONG1
2010 DATA #0,"T150S-2 @53 V12 P64 O4 L8"
2020 DATA #1,"     S-2 @52 V9  P64 O4 L8"
2030 DATA NEXT                            :'the MML strings from here on continue
2040 DATA #0,"R8|GAB>C<GAB>C<|GAB>C<GAB>C<"  :'the strings of line 2010
2050 DATA #1,"R8|R1|R1"
 :
3000 DATA SONG2    :'MML strings after this are registered to song number 2
 :
4000 DATA ENDSONG  :'must always be put at the end"""),
 ("Rearranging tones with TARG", "RM, `TARG`, example 2",
  "Builds a 13-instrument set from several tone files: a drum kit assembled layer by layer, single instruments, and a two-layer \"chorus\" made of a vocoder and a pad.",
"""1000 CLEAR ,1360:RESTORE *TONE_DATA
1010 TARG READ
 :
2000 *TONE_DATA                     :'(Tone Number)Tone Name
2010 DATA BUILDLAYER                :' (1)Drum Set
2020 DATA ROCK,      31, 3, 0, 0, -3  :'|  Hi Hat      42-42 -> 39- 39
2030 DATA            31, 0, 0, 0,  0  :'|  Kick        36-36 -> 36- 36
2040 DATA ORCHEST,   31, 2, 0, 0,-17  :'|  Orch. cymbal 57-57 -> 40- 40
2050 DATA STANDARD,  32, 8, 0, 0,+50  :'|  Hand Clap    0-39 -> 50- 89
2060 DATA            32, 1, 0, 0,+50  :'|  Tambourine  40-54 -> 90-104
2070 DATA            31, 0, 0, 0,  0  :'|  Kick         0-36 ->  0- 36
2080 DATA            31, 1, 0, 0, -1  :'|  Snare       38-38 -> 37- 37
2090 DATA            31, 1, 0, 0, -1  :'|  Snare       38-38 -> 37- 37
2100 DATA ENDLAYER                  :''+
2110 '
2120 DATA ROCK,      34             :'  (2)Power Guitar
2130 DATA ORCHEST,   32             :'  (3)A.Piano
2140 DATA            35             :'  (4)Strings Arco
2150 DATA            37             :'  (5)Harp
2160 DATA            42             :'  (6)Oboe
2170 DATA            40             :'  (7)Horn
2180 DATA STANDARD,  35             :'  (8)synth Bass
2190 DATA            51             :'  (9)Synth Pad 1
2200 DATA            52             :' (10)Synth Pad 2
2210 DATA            53             :' (11)Brightness
2220 DATA DANCE,     39             :' (12)Voice Ahh
2230 '
2240 DATA BUILDLAYER                :' (13)Chorus-like
2250 DATA DANCE,     35, 0,-1,-1,-1  :'|    Vocoder Vox
2260 DATA            45, 0,-1,-1,-1  :'|    Metal Pad
2270 DATA ENDLAYER                  :'+
2280 '
2290 DATA ENDARRANGE"""),
 ("Your own PCM sample with TARG", "RM, `TARG`, example 3",
  "Registers an 8-bit sample written out in `DATA` (between `STARTPCM` and `ENDPCM`) as instrument 1 and plays it. The manual leaves out most of the sample data.",
"""1000 CLEAR ,1360 :'reserve the file buffer
1001 PLAYINIT"STANDARD":TARG READ
1002 PLAY"@1 L1 CDEFG"
1003 END
1004 DATA STARTPCM, 8, 0, 0, 127, 60   :'8bit Sample BASE = N60
1005 DATA 00000000000000000000000000000101
1006 DATA 01010101010101010101010202010101
       :
5961 DATA 00000000000000000000000000000000
5962 DATA 00000000000000000000000000000000
5963 DATA 00000000000000000000000000000000
5964 DATA ENDPCM
5965 DATA ENDARRANGE"""),
 ("A two-operator FM tone", "RM, `TARG`, example 5",
  "Defines an FM instrument with two operators and plays a scale over four octaves. The comment line names each parameter column.",
"""1000 CLEAR ,1360:TARG READ
1001 EFFECT"@1 O2CDE>CDE>CDE>CDE"
1002 END
1003 '
1004 DATA BUILDLAYER
1005 '    OP#, W, X, Y, M, S, AR, DR, SR, RR, SL, TL, ml1, ml2, dt, KS
1006 DATA FM,  1, 1, 1, 1, 0, 0,  11, 0,  0,  11, 0,  0,   24,  0,  0
1007 DATA FM,  2, 1, 1, 1, 5, 7,  11, 0,  0,  11, 0,  0,   12,  0,  0
1008 DATA ENDLAYER
1009 DATA ENDARRANGE"""),
]
