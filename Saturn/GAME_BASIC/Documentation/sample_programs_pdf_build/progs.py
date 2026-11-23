# Program catalogue: chapter, file, title, what it does, techniques, related files, notes
# Descriptions are written from the listings themselves, the User Guide's section 21
# and the Tutorial Manual's notes on the supplied programs (TM section 2.10).

CHAPTERS = [
 ("games", "Games", "These are complete games. They are the best models for writing your own: each one has a set-up part, a main loop built from labels and `GOSUB`, pad input, object updates and sound."),
 ("graphics", "Polygon and graphics demos", "Short programs that each show one graphics feature, plus the feature demo `DEMO.B`. Most are under 100 lines of code once the model data is left out, so they are easy to study and copy from."),
 ("sound", "Sound and music", "The interactive sound tutorial, the music players and the sound tests. The players are mostly MML data, so their listings here show the player code and leave out the long `DATA` blocks."),
 ("tools", "Tools and utilities", "The launcher, the paint program, the song and instrument editors, and small utilities. The tool main programs are the largest BASIC programs on the CD and show how to build windows, menus and mouse handling in GAME BASIC."),
 ("dxfconv", "DXFCONV sample output", "These three files come with the DXFCONV converter on the Windows 95 tools CD (folder `DXFCONV`), not the Saturn CD. They are what DXFCONV writes when it turns a DXF model into a GAME BASIC program, and show the smallest program that loads and spins a polygon model."),
]

P = []
def add(ch, f, title, what, tech, related="", note="", variant_of=None, same_code_as=None, src="cd"):
    P.append(dict(ch=ch, f=f, title=title, what=what, tech=tech, related=related, note=note,
                  variant_of=variant_of, same_code_as=same_code_as, src=src))

# ---------------------------------------------------------------- games
add("games","G_MOBIL.B","Mobil",
 "A 3D driving game. You steer a vehicle over a chequered field and touch the pylons in order before time runs out. The Tutorial Manual's chapter on making a game (TM section 2.8) explains this listing block by block, so read the two together.",
 ["`PAD(0,1)` read as a bit mask and tested with the `@PAD_...` constants",
  "Steering with a viewing direction, speed and acceleration, using `XSIN`/`XCOS` to move in the direction you face",
  "A ground built from character BG tiles with `PUTCHR`",
  "Pylon objects built with `SETVERTEX`/`SETPOLYGON` from `DATA`, placed at random on a map array",
  "Simple distance test for touching a pylon, a countdown timer, and `BGM`/`EFFECT` for music and sound effects"],
 note="Start here. It is the smallest complete 3D game on the CD.")
add("games","G_MOBILS.B","Mobil for the Racing Controller",
 "The same game as `G_MOBIL.B`, changed to read the analogue wheel of the SEGA Racing Controller.",
 ["Reading an analogue axis with `PAD(0,3)` (neutral 127) instead of the digital pad",
  "Waiting for the right controller before starting"],
 variant_of="G_MOBIL.B")
add("games","G_BOMB.B","Bomb",
 "A multi-player bomb game for the Multi-Terminal 6 multitap: up to six players move around and drop bombs (A button) that explode. It needs at least two pads.",
 ["Counting connected pads with `PAD(-1)` and refusing to start with fewer than two",
  "A main loop that is just a list of `GOSUB` calls: move, explode, collision check, game-over check",
  "Start positions read from `DATA` with `RESTORE`",
  "2D sprites placed with `PUTSPRITE`, one per player and one per bomb"])
add("games","G_HATA.B","Hata-age (Flag Up)",
 "A one- or two-player reaction game. The referee calls out commands such as \"red up, white don't lower\" and you must raise or lower the red and white flags correctly in time. Scores, a timer, a sun and clouds are drawn as polygons.",
 ["`ON INTERVAL` timer interrupts to read each pad and update the clock 60 times a second, separate from the main loop",
  "Building the spoken command from subject and predicate word lists in `DATA`",
  "Two players on one screen, each with its own pad handler",
  "Polygon objects for the people, the sun and the clouds; BG windows drawn with `LINE`",
  "`COLOROFS` fades and `EFFECT` sound effects"],
 note="The Tutorial Manual's list of supplied programs describes it (TM section 2.10).")
add("games","G_MAZE.B","Maze",
 "A first-person 3D maze. The maze is generated at random, turned into polygons, and you must find the exit within the time limit. Six one-use items, one per button, help you: a telescope view from above, walking through walls and more.",
 ["Random maze generation into a 2D array",
  "Turning the whole maze into one polygon object, so it needs few objects (see the comment at the top)",
  "Moving the camera through the maze one cell at a time with smooth turning",
  "Items placed at random and picked up by position, with a replay that keeps the same layout",
  "`ON INTERVAL` for the countdown"])
add("games","G_JUMP.B","Jump",
 "A 3D game where you steer and jump between floating platforms, with gravity and acceleration, small textured polygon models and its own instrument set for the music.",
 ["Physics with speed, acceleration and gravity variables",
  "Small 8x8 textures (`SETTEX`) and polygon models (`SETVERTEX`/`SETPOLYGON`) read from `DATA`, which is most of the file",
  "`TARG READ` to build a custom instrument set, `SETSONG` and `BGM` for music",
  "`ON INTERVAL` clock, and `PALETTE` set-up for a 256-colour texture"])
add("games","G_JUMP_A.B","Jump for the Multi Controller",
 "`G_JUMP.B` changed to use the analogue stick and triggers of the SEGA Multi Controller (the 3D pad) in analogue mode.",
 ["Analogue stick X and Y in `PAD(0,3)` and `PAD(0,4)` (neutral 128)",
  "Analogue triggers in `PAD(0,5)` and `PAD(0,6)` (0 to 255), used for a variable-strength jump"],
 variant_of="G_JUMP.B")
add("games","G_JUMP_M.B","Jump for the Mission Stick",
 "`G_JUMP.B` changed for the SEGA Mission Stick.",
 ["Reading the Mission Stick's analogue axes", "Jumping with the A and B buttons"],
 variant_of="G_JUMP.B")
add("games","G_SABA.B","Saba (Mackerel)",
 "A Virtua Gun shooting gallery. Mackerel leap out of the sea and you shoot them before they fall back. Now and then a fish-man, a surfer or a waiter appears instead. There are two modes, aimed shooting and rapid fire, and a sight calibration screen.",
 ["Finding which port the Virtua Gun is in, and reading its X/Y position and trigger from `PAD`",
  "Calibration: averaging three shots at the centre of the screen",
  "Sprites with several textured attributes, switched to change what a sprite shows",
  "Hit testing against each object's rectangle, score and hit-mark objects linked as children",
  "Appearance positions, speeds and probabilities that change with the level",
  "`GLOAD` for the background picture"],
 related="`SABA_BG.0` (background picture, 256 colours)")
add("games","G_THESEU.B","Theseus",
 "A maze action game with ten stages. You guide the hero through each maze, collecting items and avoiding enemies. Each stage's maze, items, enemies and settings are separate data files on the CD.",
 ["Loading level data from CD files with `OPEN` and `FREAD`",
  "Character (tile) graphics for walls, player, enemies and items, set up from data files",
  "A level loop: initialise, read items and enemies, draw, play, then go to the next level or back to the title",
  "`ON TIMER` to count frames, `SCROLL` for the screen",
  "Many small subroutines (over 60 `GOSUB` targets): a good example of breaking a big program up"],
 related="`PALWIN.D`, `BGCHR.D`, `WLCHR.D`, `MYCHR.D`, `ENECHR.D`, `YAKCHR.D`, `HEROCHR.D` (palette and character data); `MAZE01.D`-`MAZE10.D`, `ITEM01.D`-`ITEM10.D`, `ENEM01.D`-`ENEM10.D`, `INID01.D`-`INID10.D` (per-stage data)")
add("games","G_TEKE.B","Teke-teke",
 "A virtual-pet and ball game. Three creatures, Pokepoke, Pikepike and Pekepeke, live in a small world. You feed them, make them study and play a ball game against them. Their life, motivation, experience, hunger, sleepiness and mood change over time, and they can die and come back. Progress can be saved to cartridge RAM.",
 ["A large state machine with many parameters per character",
  "Shuttle Mouse or control pad, detected at start",
  "Saving and loading the game with `OPEN`, `FWRITE` and `FREAD`, with error handling",
  "Icons, a toolbar and parameter windows drawn with objects and `LINE`",
  "`COLOROFS` and `MOSAIC` effects, `GLOAD` pictures for the opening and ending"],
 related="`TEKST.1`, `TEKEND.1` (opening and ending pictures, 32768 colours)",
 note="At about 2,200 lines of code this is the biggest game on the CD.")
add("games","G_BOU.B","Bou (Stick): starter",
 "A six-line program that shows a loading message and runs `BOU_SCD.B`. The game is split over three files because it is too big to load at once.",
 ["Chaining programs with `LOAD \"CD:name\",R`"])
add("games","BOU_SCD.B","Bou: opening",
 "The first part of \"Bou\": checks for a Virtua Gun or Shuttle Mouse, then plays the opening, a camera fly-through of textured polygon objects, before running `BOU_TCD.B`.",
 ["Moving the camera smoothly from one point to another in steps",
  "Building textured objects from vertex, face and texture data in `DATA`",
  "Detecting the input device"])
add("games","BOU_TCD.B","Bou: texture and object set-up",
 "The second part of \"Bou\": loads the textures, sets up the BG and registers all the objects, then runs `BOU_MCD.B`.",
 ["Registering many textures and objects from `DATA`, then handing over to the next program"])
add("games","BOU_MCD.B","Bou: main program",
 "The game itself. You ride a vehicle along a course; aliens swing their arms and you must avoid being hit, while animals (a monkey, a panda, a gorilla) move about and tiles appear. Works with a Virtua Gun, Shuttle Mouse or control pad.",
 ["A main loop of `GOSUB` calls with an `ON INTERVAL` pad handler",
  "Hit tests based on distance from a rotating arm",
  "Object animation for many moving parts (over 270 `OBJ` references)",
  "A time bar and window drawn with `LINE`"])

# ---------------------------------------------------------------- graphics
add("graphics","DEMO.B","GAME BASIC feature demo",
 "The self-running demo that introduces GAME BASIC's features: graphics commands, polygons, parent-child objects, lights, sprites, texture mapping, BG screens, sound, kanji and the supported peripherals, each with a caption. It runs several of the `P_` demos as parts of itself.",
 ["A catalogue of techniques in one program: `PSET`/`LINE`/`CIRCLE`, polygon models, `SETLIGHT`, sprites, textures and `PFONT`",
  "`KPRINT` captions over the graphics",
  "Parent-child object trees (the \"AZ-1\" cube demo)",
  "`ON INTERVAL` to run animation while the main program shows captions"],
 related="`FONT161.D`, `FONT162.D` (kanji fonts, loaded by `KLOAD`)")
add("graphics","CLOCK.B","Clock",
 "A five-line digital clock: it enlarges the text screen with `ZOOM` and prints the time from `DATE$` in a loop. It is the Tutorial Manual's first program (TM section 2.3).",
 ["`ZOOM`, `LOCATE`, `RIGHT$(DATE$,18)` and a label loop"])
add("graphics","P_CLOCK.B","Polygon clock",
 "A digital clock made of polygon font characters. Each character of the time is a separate object. The Tutorial Manual explains it (TM section 2.6, \"Displaying polygon fonts\").",
 ["`SETPFONT` to make 3D letters and digits",
  "The \"Object Item Number\" constants (`TYPE`, `XP`, `ATR`...) used with `OBJ(n,item)`",
  "Placing objects in a row centred on the screen"])
add("graphics","P_PFONT.B","Polygon font test (\"Alphabet Soup\")",
 "The 26 letters as polygon font objects, arranged in a ring around a parent object that spins. Explained in TM section 2.6.",
 ["`SETPFONT` with colours from `RND`", "Parent-child objects: rotating the parent turns the whole ring", "`SETLIGHT`"])
add("graphics","P_CAME2.B","Camera test",
 "The camera circles over a rotating, scaling BG plane covered in random letters. Explained in TM section 2.6, \"The camera\".",
 ["`CAMERA` and object 0 as the camera", "A rotation BG (`ROTZOOM`, `SETCHR`, `PUTCHR`) as the ground", "Circular motion with `XSIN`/`XCOS`"])
add("graphics","P_SHOWER.B","Shower",
 "A shower of polygon objects falling with random speeds and spins. The Tutorial Manual uses it as the example for sending a program from the PC (TM section 3.1, \"Key send\").",
 ["Random object speed (`XV`) and rotation speed (`XRV`) so objects move by themselves", "`SETDISP`"])
add("graphics","P_TEXMAP.B","Texture drawing test",
 "Draws on a texture with ordinary graphics commands while the texture is shown on a spinning polygon, so the picture changes as it turns.",
 ["Making a texture and drawing into it with `LINE`, `CIRCLE` and `PAINT`", "`ON INTERVAL` to keep drawing", "Linking attribute and polygon to an object"])
add("graphics","P_FLOWER.B","Texture display test",
 "A textured flower picture on a polygon, with several copies linked to it and turning.",
 ["`PALETTE ... READHEX$` to load a 256-colour palette from `DATA`", "`SETTEX`, `SETVERTEX`, `SETPOLYGON`, `SETATR`", "The `OBJATR`, `OBJTYPE`, `OBJTURN`, `OBJLINK` commands"])
add("graphics","P_NEKO.B","2D sprite test",
 "Shows the three kinds of object-type sprite: a rotating sprite, one with independent horizontal and vertical scale, and a 4-point distorted sprite, using a cat picture.",
 ["Sprite object types 1, 2 and 3", "Z position as sprite priority", "Putting sprites behind the text screen with `PRIORITY`"])
add("graphics","P_HERI.B","Helicopter model",
 "A polygon helicopter built from three parts (body, rotor and tail rotor) that turn.",
 ["A multi-part model: several `SETVERTEX`/`SETPOLYGON` sets joined as parent and children", "Spinning the rotors with rotation speed"])
add("graphics","P_TANK.B","Tank model",
 "A polygon tank built from three parts.",
 ["The same multi-part model technique as `P_HERI.B`"])
add("graphics","P_DOLL.B","Doll animation editor",
 "An editor for animating a jointed polygon doll. You pick a joint, set its angles for each frame with the pad, and insert, copy, delete, save and load frames.",
 ["A hierarchical model: each body part is an object linked to its parent with an offset", "Key-frame animation stored in arrays", "Saving and loading motion data with `FWRITE`/`FREAD`", "An on-screen parameter display updated with `LOCATE`/`PRINT USING`"],
 related="`TAISO.D` (sample motion data: exercises)")
add("graphics","P_DLPLAY.B","Doll animation player",
 "Plays back motion data made with `P_DOLL.B` on the same polygon doll.",
 ["Reading motion data with `FREAD` and playing it frame by frame on the jointed model"],
 related="`TAISOPT.D` (sample motion data)")

# ---------------------------------------------------------------- sound
add("sound","S_TUTOR.B","Sound tutorial",
 "An interactive tutorial on GAME BASIC's sound system, all on screen: a 20-page glossary, the specification, the tone sets, and a seven-part MML tutorial with examples you can hear (notes, lengths, velocity, gate time, pitch bend, chords, tuplets, key signatures, repeats, rearranging tones with `TARG`, shaping them with `TPROP`, the DSP effector, FM synthesis, macros, chords and inversions). The Tutorial Manual points to it as the place to start with sound (TM pp. 83-84).",
 ["Paged text screens with `KPRINT` and a key loop for next, back and top",
  "Playing MML from a program with `EFFECT`, `BGM`, `SETSONG` and `PLAY`",
  "Every sound command in use: `PLAYINIT`, `TARG`, `TPROP`, `DSP`, `MMLSTAT`"],
 note="All of its screen text has been translated, so the listing reads as an English sound tutorial. The text is split into many short `KPRINT` pieces in the original, so some lines read a little choppily.")
add("sound","PLAYMIDI.B","MIDI to MML converter",
 "Reads a standard MIDI file, converts its events to MML for up to 16 tracks, sets the tones, plays the result and can save it.",
 ["Reading a binary file byte by byte with `FREAD`", "Parsing the MThd and MTrk chunks and variable-length delta times", "Building MML strings in `USERDATA` and playing them with `SETSONG`/`BGM`"])
add("sound","S_AIFF.B","PCM test with AIFF files",
 "Loads three AIFF samples from the CD as instruments with `TARG READ` and plays each one when you press a key.",
 ["Using your own sampled sounds: `DATA` lines that name the AIFF files", "`EFFECT \"@1 %1 C\"`: the damper switch keeps a looping sample sounding"],
 related="`BEAT_A.D`, `SAMPLE_A.D`, `WAVE1_A.D`")
add("sound","S_WAVE.B","PCM test with WAVE files",
 "The same as `S_AIFF.B`, using WAVE files.",
 ["As `S_AIFF.B`"], related="`BEAT_W.D`, `SAMPLE_W.D`, `WAVE1_W.D`", variant_of="S_AIFF.B")
add("sound","S_FM_TA.B","FM synthesis test",
 "Plays a short phrase with each of the 47 FM modulation waveforms and several `ml2` (multiple) values, rebuilding the FM tone with `TARG READ` each time.",
 ["Building an FM tone definition (`BUILDLAYER` ... `ENDLAYER`) as strings in `USERDATA`, then loading it with `TARG READ`", "Changing one FM parameter at a time in a loop to hear its effect"])
add("sound","S_GM_FM1.B","FM General MIDI set 1",
 "Builds a full 128-instrument FM set laid out in General MIDI order with `TARG READ`, then plays every instrument in turn. The `DATA` holds the FM parameters for each instrument, one `BUILDLAYER` block per instrument.",
 ["A complete FM instrument library in `DATA`: copy the blocks you like into your own programs"])
add("sound","S_GM_FM2.B","FM General MIDI set 2","A second FM General MIDI set: same program as `S_GM_FM1.B`, with different FM parameters in the `DATA`.",[],same_code_as="S_GM_FM1.B")
add("sound","S_GM_FM3.B","FM General MIDI set 3","A third FM General MIDI set: same program as `S_GM_FM1.B`, with different FM parameters.",[],same_code_as="S_GM_FM1.B")
add("sound","S_GM_FM4.B","FM General MIDI set 4","A fourth FM General MIDI set: same program as `S_GM_FM1.B`, with different FM parameters.",[],same_code_as="S_GM_FM1.B")
add("sound","S_CLASSI.B","Classical music menu",
 "A menu of six classical pieces. Choosing one loads and runs its player program, which returns here when you press a key.",
 ["A menu with fade in and out (`COLOROFS` under `ON INTERVAL`)", "Remembering the menu position across programs with `POKE`/`PEEK` in user memory", "Chaining with `LOAD \"CD:...\",R`"])
add("sound","S_ARIA.B","Air on the G String (strings)","Bach's *Air on the G String* played with the orchestral strings set.",
 ["The shortest complete music player: `PLAYINIT \"DSP\",\"ORCHEST\"`, `SETSONG`, `BGM`", "Returning to the menu program"])
add("sound","S_ARIA_P.B","Air on the G String (pipe organ)","The same piece with a pipe organ tone.",[],variant_of="S_ARIA.B")
add("sound","S_POLONA.B","Heroic Polonaise","Chopin's *Heroic Polonaise*.",["A long song in `DATA` read by `SETSONG`"])
add("sound","S_MARIA.B","Ave Maria","Gounod's *Ave Maria*.",["As `S_ARIA.B`"])
add("sound","S_FUGA.B","Little Fugue in G minor","Bach's *Little Fugue in G minor*.",["Several independent tracks in MML"])
add("sound","S_KANON.B","Pachelbel's Canon","Pachelbel's *Canon*.",["Adjusting tones with `TPROP` before playing"])
add("sound","S_G_ARTS.B","Game Arts music menu",
 "A menu of arrangements of Game Arts game music, with notes on each game (translated). Each entry loads a player program. Tunes 2-9 load ready-made tone sets from the CD; tunes 10-17 rebuild them with `TARG` each time.",
 ["A two-level menu and information pages with `KPRINT`", "`POKE`/`PEEK` to pass the choice to the player program"])
add("sound","S_SILPH.B","Silpheed music","Tunes from *Silpheed* (Game Arts), in versions close to the original and new arrangements. Shares its player code with the other Game Arts players.",
 ["A menu of tracks driven by the pad", "Rearranging tones with `TARG` and adjusting them with `TPROP`", "`PLAYFADE` to fade out"])
add("sound","S_ZELIAR.B","Zeliard music","Tunes from *Zeliard*. The PC-88 MML was ported as it was, using only the standard tone sets rearranged, no FM.",["As `S_SILPH.B`"])
add("sound","S_VEIGUS.B","Veigues music","The opening of *Tactical Gladiator Veigues*, almost entirely FM.",["FM tones defined in `DATA` and loaded with `TARG`"])
add("sound","S_F_HAWK.B","Fire Hawk music","Tunes from *Fire Hawk (Thexder 2)*. The boss tune cuts in seamlessly at a musical break point.",
 ["`ON MMLSTAT GOSUB` and the MML `!` command: the music tells the program when it reaches a good point to change BGM",
  "Several tone arrangements shared between tunes"])
add("sound","S_ALISIA.B","Alisia Dragoon music","Tunes from *Alisia Dragoon*, mixing FM and PCM, including some not in the released game.",["As `S_SILPH.B`"])
add("sound","S_LUNARA.B","Lunar music, version A","Tunes from *Lunar: The Silver Star*. Every tune uses the same tone layout, with the first 30 tones left free for sound effects, so they can be used as BGM in your own game.",["One shared tone layout for all tunes: a model for game BGM"])
add("sound","S_LUNARB.B","Lunar music, version B","Version A with each tune's tones rearranged for listening, using the DSP effects. Each tune is initialised separately.",
 ["Advanced MML: per-tune `PLAYINIT` DSP modes and heavy use of `TPROP` (over 170 calls)"])
add("sound","S_TUBASA.B","Lunar: Tsubasa (karaoke)","The *Lunar* opening theme as a karaoke sample: the lyrics appear in time with the music.",
 ["`ON MMLSTAT GOSUB` to show each lyric line when the MML reaches it"])
add("sound","S_T_NAME.B","Instrument names",
 "Not a program to run: `DATA` lists of the instrument names in each tone set, one label per set, to merge into your own program (TM p. 141).",
 ["Named `DATA` blocks you can `RESTORE` by label"])

# ---------------------------------------------------------------- tools
add("tools","LAUNCH.B","Launcher",
 "The menu GAME BASIC boots into (also started with Shift+F1). It lists the files on a device in a window, lets you move a cursor with the pad or keyboard and runs or loads the chosen file. The CD's own programs are listed in a preferred order.",
 ["A scrolling file list built from `FILES`/`DIR$`", "Switching between devices with error handling (`ON ERROR GOTO`)", "Text-screen user interface with `COLOR` and `LOCATE`"])
add("tools","T_KAMI.B","Kami (Paper): title","Shows the title screen of the paint program and runs `K_MAIN.B`.",["A title screen made of circles and lines, then `LOAD ... ,R`"])
add("tools","K_MAIN.B","Kami: paint program",
 "A paint program with movable windows for the pen, colours, editing and system menu. Tools include freehand, lines, rectangles, circles, fill, spray, tile patterns, copy and paste, undo, zoom and scroll. Pictures can be loaded and saved, including Windows BMP files. Works with a Shuttle Mouse, control pad or keyboard.",
 ["A window system made of sprites: dragging, bringing to the front, hit tests, a message queue",
  "Mouse input with click and double-click timing",
  "BMP loading in 1, 4, 8 and 24-bit formats with `FREAD`",
  "`GLOAD`/`GSAVE` and undo buffers"])
add("tools","T_OTO.B","Oto (Sound): title","Title screen for the song editor. Runs `O_SET.B`.",["Title animation with polygon objects"])
add("tools","O_SET.B","Oto: set-up","Loads the editor's sprite and texture data, then runs `O_MAIN.B`.",["Defining sprites and palettes from `DATA` in a separate program"])
add("tools","O_MAIN.B","Oto: song editor",
 "A song editor that shows music on a five-line staff. You place notes with the mouse or pad, edit length, volume, pan and pitch bend, work by track and phrase (bar), copy and paste, play all tracks or one bar, and save the result as its own format or convert it to MML.",
 ["Drawing a staff, notes, accidentals and repeat signs with `LINE` and sprites",
  "A music data structure in `USERDATA`",
  "Converting the edited data to MML text and saving it",
  "Keyboard accelerators read from `OTO_KEY.D`"],
 related="`OTO_DATA.D`")
add("tools","T_HIBIKI.B","Hibiki (Resonance): title","Title screen for the instrument editor. Runs `H_SET.B`.",["A title drawn on two bitmap screens with `ACTIVE` and `LINE`, then `LOAD ... ,R`"])
add("tools","H_SET.B","Hibiki: set-up","Loads the editor's sprites, textures and palettes, then runs `H_MAIN.B`.",["As `O_SET.B`"])
add("tools","H_MAIN.B","Hibiki: instrument editor",
 "An instrument (tone) editor. You browse the built-in tone sets, make new PCM tones from sample files or new FM tones, edit FM algorithms and parameters, arrange tones in a tray and save tone sets.",
 ["Tone editing with `TARG` and `TPROP`", "Drawing FM algorithm diagrams", "Trays and scroll bars built from sprites", "A level meter and on-screen keyboard"],
 related="`HIBIKI_0.0` (background), `LST1_00.D`-`LST1_15.D` (tone names)")
add("tools","T_KANADE.B","Kanade (Playing)",
 "A music visualiser: plays the BGM and shows a keyboard and level meter for each of the 16 tracks, lighting the keys as notes play (TM p. 128).",
 ["`MMLSTAT(track,1)` to read the note each track is playing", "`PLAYSTAT` to see when the song ends", "Fades with `COLOROFS` under `ON INTERVAL`"])
add("tools","TRANSFOR.B","Transfer a file to the PC",
 "Copies any file from a Saturn device to the PC over `COM:`, showing the percentage done. Use it with BASTERM or the modern tools to get `.D` data files off the CD.",
 ["`OPEN` for input and output, `FREAD`/`FWRITE` one byte at a time, `LOF`"])
add("tools","UD_DATA1.B","USERDATA test 1",
 "Builds songs in `USERDATA` from strings and saves them to backup RAM with `BSAVE`.",
 ["`USERDATA` to assemble MML in memory", "`BSAVE` of `USERDATA` areas"])
add("tools","UD_DATA2.B","USERDATA test 2",
 "Loads the songs saved by `UD_DATA1.B` with `BLOAD` and plays them, then shows how to go back to reading ordinary `DATA`.",
 ["`BLOAD` into `USERDATA`", "Switching `SETSONG` between `USERDATA` and `DATA`"])

# ---------------------------------------------------------------- dxfconv
add("dxfconv","HEADBAS.B","DXFCONV program header",
 "The header DXFCONV puts at the start of every program it writes: it reads the vertex and polygon counts, sets up one object and spins it.",
 ["The minimum code to show a polygon model: `SETVERTEX`, `SETPOLYGON`, `SETATR`, `OBJ(1,@TYPE)=4`"], src="dxf")
add("dxfconv","ASCII.B","DXFCONV sample: ASCII","A model converted by DXFCONV from `ASCII.DXF`, in five parts.",["Several models in one program, each with its own vertex and polygon set"], src="dxf")
add("dxfconv","GIRL.B","DXFCONV sample: girl","A model of a girl converted by DXFCONV from `GIRL.DXF`.",["As `ASCII.B`"], src="dxf")

LEARNING_PATH = [
 ("Tutorial Manual examples", "chapter 7", "Read the short listings from the manuals first: they introduce lines, loops, subroutines, arrays, sprites and a first polygon one idea at a time."),
 ("`P_CLOCK.B`, `P_PFONT.B`, `P_FLOWER.B`, `P_NEKO.B`", "chapter 3", "One graphics idea each: polygon fonts, parent-child objects, textures and sprites."),
 ("`G_MOBIL.B`", "chapter 2", "The smallest complete 3D game, with a line-by-line explanation in the Tutorial Manual (TM section 2.8)."),
 ("`G_BOMB.B` and `G_HATA.B`", "chapter 2", "How a game loop is organised as a list of subroutines, and how `ON INTERVAL` reads the pads in the background."),
 ("`G_MAZE.B` and `G_JUMP.B`", "chapter 2", "Bigger 3D games: generating a level, building it from polygons, simple physics and custom music."),
 ("`G_SABA.B`, `G_THESEU.B`, the `BOU` files and `G_TEKE.B`", "chapter 2", "Full games: light-gun input, stage data in files, programs split across several files, saving progress."),
 ("`S_TUTOR.B`", "chapter 4", "When you are ready to add music and sound effects: a complete MML course, now in English."),
]
