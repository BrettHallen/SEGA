# GAME BASIC for SEGA SATURN: Tutorial Manual (English translation)

This is an English translation of the *GAME BASIC for SEGA SATURN Tutorial Manual* (チュートリアルマニュアル; ASCII Corp., Bits Laboratory and ESP inc., 1998). It follows the Japanese book page by page. Page markers such as *[p. 24]* give the book page number, so any passage can be checked against the original.

Commands, example programs and screen output are kept exactly as printed. Japanese text inside program listings (comments and strings) is kept as printed, with an English gloss in square brackets. Where the original has a clear misprint it is kept and marked "(sic)" or *[sic: …]*, with a short note where the meaning is not obvious. Pictures and screenshots are replaced by short descriptions in square brackets, and notes in square brackets in italics, such as *[p. 12 is blank]*, describe the layout of the book.

The full command details are in the separate *Reference Manual*, which has its own English translation.

---

## Front matter

*[Cover]*

*[Cover illustration: a perspective wireframe grid receding towards a dark block. The spine reads "SEGA SATURN" and "disc 取扱説明書" (disc instruction manual).]*

**GAME BASIC for SEGA SATURN**

**~ Tutorial Manual ~**

ASCII

*[Inside cover]*

> Thank you for purchasing "GAME BASIC for SEGA SATURN", software for the SEGA SATURN. Before use, please read this instruction manual carefully and use the software correctly. This instruction manual will not be reissued, so please keep it in a safe place.

*[Illustration: a six-pointed wireframe star above a receding grid.]*

PCM sound source provided by: Two-Five Ltd. (有限会社ツーファイブ)

## Introduction

### GAME BASIC for SEGA SATURN is a powerful assistant

When you play all kinds of games at home or in an arcade, have you ever wondered how the "characters" on the screen can be moved freely with the control pad, or how they bounce off or break apart when they hit a "wall" or an "enemy"?

GAME BASIC for SEGA SATURN (called BASIC from here on) is a powerful assistant tool for making your own original games on the SEGA SATURN.

### Features of BASIC

The main feature of BASIC is that it makes the SEGA SATURN's many computer graphics and sound functions easy to use.

Among them are kanji display and functions made specially for games, so you can create things that come close to commercial titles. The sound functions act as a powerful MIDI-compatible synthesizer, as capable as a commercial musical instrument.

BASIC also has the power of a computer with a 32-bit CPU, so you can set up a development environment just by connecting the SEGA SATURN to a television. If you use the supplied communication software and communication cable to connect the SEGA SATURN to your own Windows PC, you can also program on the PC.

BASIC is made to suit everyone, from people meeting a computer for the first time to people who are used to handling computers.

### Purpose and role of the Tutorial Manual

This Tutorial Manual serves as a **guidebook** as you begin development.

It is organised so that, from the first time you touch BASIC up to the basic way of making a game, you learn by actually using BASIC.

To make it easy to read even for beginners, it uses illustrations and keeps specialist computer terms as simple as possible.

The **Reference Manual** packed with it contains information for intermediate and advanced users that this Tutorial Manual does not explain, and more detailed explanations. To begin with, use it as a dictionary for the Tutorial Manual.

### Conventions used in the Tutorial Manual

There are a few things to know before you read the Tutorial Manual.

- Each Chapter is divided into a few large sections, and each of those is made up of several topics below it. Each topic has a heading in large type. Illustrations, photographs, tables and program listings are included where needed.
- Key operations in the text are shown in [ ] (for example, the [Home] key and the [Esc] key). Pressing two or more keys together is shown as [Ctrl]+[H].
- In Chapter 3, "Using the communication software", menu items and the like are also shown in [ ], as in the "[Communication] menu".

## Contents

**Chapter 1: Introduction**

| Section | Page |
|---|---|
| 1.1 Before starting GAME BASIC for SEGA SATURN | 3 |
| &emsp;Checking the package | 3 |
| &emsp;Connecting the equipment | 3 |
| &emsp;Starting GAME BASIC for SEGA SATURN | 5 |
| &emsp;Using the input devices | 6 |
| &emsp;Connecting to a PC | 9 |

**Chapter 2: Making the most of BASIC**

| Section | Page |
|---|---|
| 2.1 Trying out BASIC | 15 |
| &emsp;Starting BASIC | 15 |
| &emsp;Typing characters | 16 |
| &emsp;Error messages | 17 |
| &emsp;How to erase characters you have typed | 18 |
| 2.2 Using BASIC like BASIC | 19 |
| &emsp;Typing and running a "command" | 19 |
| &emsp;Characters BASIC can handle | 19 |
| &emsp;How BASIC commands are arranged (syntax) | 20 |
| &emsp;Displaying characters and numbers with commands | 20 |
| &emsp;Handling numbers and characters with variables | 21 |
| 2.3 Your first program | 23 |
| &emsp;"Direct mode" and "program mode" | 23 |
| &emsp;Correcting mistakes | 24 |
| &emsp;Running it | 25 |
| &emsp;Making a digital clock | 26 |
| 2.4 A slightly more advanced program | 32 |
| &emsp;Changing the flow of a program | 32 |
| &emsp;Controlling repetition | 34 |
| &emsp;Organising a program so it is easy to read | 36 |
| &emsp;Using numbers and characters well | 37 |
| &emsp;Summary | 39 |
| 2.5 Graphics | 40 |
| &emsp;How the screen is made up | 40 |
| &emsp;Modes | 41 |
| &emsp;Coordinates | 44 |
| &emsp;Drawing shapes | 46 |
| &emsp;Displaying sprites | 51 |
| &emsp;Graphics techniques | 56 |
| &emsp;Summary | 60 |
| 2.6 Real-time computer graphics and polygons | 61 |
| &emsp;About computer graphics (CG) | 61 |
| &emsp;Making CG | 64 |
| &emsp;CG programs seen through the samples | 67 |
| &emsp;Summary | 78 |
| 2.7 Making music with BASIC | 79 |
| &emsp;Music basics | 79 |
| &emsp;Enjoying music with BASIC | 82 |
| &emsp;Summary | 86 |
| 2.8 Making an original game | 87 |
| &emsp;Sample program: Flag raising (G_HATA.B) | 87 |
| &emsp;Sample program: Mobile (G_MOBIL.B) | 89 |
| 2.9 Using peripherals | 102 |
| 2.10 The supplied programs | 104 |
| &emsp;About the supplied programs | 104 |
| &emsp;List of the programs run inside the sound sample program "S_TUTOR" | 143 |

**Chapter 3: Using the communication software**

| Section | Page |
|---|---|
| 3.1 Operating the communication software | 147 |
| &emsp;Connecting the SEGA SATURN to a Windows machine | 147 |
| &emsp;Installation | 147 |
| &emsp;Uninstallation | 149 |
| &emsp;Starting BASTERM | 150 |
| &emsp;Key send | 154 |
| &emsp;The BASTERM menus | 156 |

**Index** (p. 173)

# Chapter 1: Introduction

*[p. 1: chapter title page, "Chapter 1 導入編" (Introduction), on a checkered background]*

*[p. 2 is blank]*

## 1.1 Before starting GAME BASIC for SEGA SATURN

*[p. 3]*

### Checking the package

First, please check that you have the following:

- The SEGA SATURN CD "GAME BASIC for SEGA SATURN"
- The Tutorial Manual
- The Reference Manual
- The Tools CD for Windows
- The Windows communication cable

### Connecting the equipment

#### When using a control pad

GAME BASIC for SEGA SATURN has a software keyboard, so you can enter programs even from the control pad.

*[Illustration: a control pad plugged into control port 1 (コントロール端子1) on the front of the SEGA SATURN.]*

Connecting the control pad

*[p. 4]*

#### When using the SEGA SATURN keyboard

You can operate GAME BASIC for SEGA SATURN more comfortably by connecting a SEGA SATURN keyboard (sold separately).

*[Illustration: a control pad plugged into control port 1 and a SEGA SATURN keyboard (sold separately) plugged into control port 2.]*

Connecting a SEGA SATURN keyboard and a control pad

> **Caution:** Use the SEGA SATURN keyboard or a control pad to enter programs.

*[p. 5]*

### Starting GAME BASIC for SEGA SATURN

Put GAME BASIC for SEGA SATURN into the SEGA SATURN and switch the power on.

After the SEGA SATURN start-up screen, a screen like the one in the figure is displayed.

```
GAME BASIC for SEGASATURN ver 1.00
(C)1998 ASCII Corp./Bits Laboratory
        /ESP inc.
Ready.
_
```

GAME BASIC for SEGA SATURN start-up screen

*[p. 6]*

### Using the input devices

#### Using the control pad

**■ Operating the software keyboard**

When you enter text from the control pad, you use the software keyboard.

*[Illustration: a control pad with each button labelled.]*

| Control pad button | Function |
|---|---|
| L button | [Shift] key |
| R button | Page change |
| X button | [Delete] key |
| Y button | [Space] key |
| Z button | [Enter] key (new line) |
| C button | Select (confirm) |
| B button | [Backspace] key |
| A button | (used in the combinations below) |
| Direction button | (moves the selection) |
| Start button | (used in the combinations below) |

| Operation | Buttons |
|---|---|
| Call up the software keyboard | L+R+Start button |
| Move the cursor on the edit screen | A+direction button |
| Break | A+Start button |
| Switch between insert and overwrite mode | A+X |
| BASIC system settings screen | L+R+Z |
| Software reset | A+B+C+Start button |
| Type lower-case letters | L+C (character input) |

Pressing the R button on the control pad switches the software keyboard pages in the following order.

*[p. 7]*

**Alphabet input page**

*[Screen: the software keyboard at the bottom of the screen. Tabs ALPH, カナ, CMD. and GRPH; a row of keys F1 to F12; then three rows of keys: `! " # $ % & ' ( ) < = > ? : ; ^ ¥ ` ~`, `A`–`M @ _ [ ] { }`, `N`–`Z ,` SPACE `|`, a numeric block 7 8 9 / 4 5 6 / 0 1 2 3, and `- / + * . =`, R↑, R↓ and ↵ (Enter).]*

**Kana input page**

*[Screen: the same software keyboard with the カナ tab selected, showing katakana ア to ン, the dakuten and handakuten marks, small kana ァィゥェォャュョッ, 。「」、・ and ↵.]*

*[p. 8]*

**Command input page**

*[Screen: the software keyboard with the CMD. tab selected. Keys F1 to F12, then whole commands: `CLS FOR NEXT STEP LOCATE PRINT` / `IF THEN ELSE GOTO GOSUB RETURN` / `COLOR PSET LINE CIRCLE PAINT` and ↵.]*

**Graphic character input page**

*[Screen: the software keyboard with the GRPH tab selected, showing block and line-drawing graphic characters, triangles, the card suits ♠ ♥ ♦ ♣, ● ○ ／ ＼ ╳, and the characters 円 年 月 日 時 分 秒 (yen, year, month, day, hour, minute, second), then ↵.]*

*[p. 9]*

**■ Using the keyboard**

On the keyboard you can type the character printed on each key directly.

*[Illustration: the SEGA SATURN keyboard with these keys labelled: [CapsLock] key (Caps Lock), [Esc] key (Escape), [F1] to [F12] keys (function keys), [Backspace] key, [Ctrl] key (Control), [Alt] key, [Space] key, [Enter] key (new line), arrow keys, [Shift] key.]*

For details of the operation, see the Reference Manual.

### Connecting to a PC (a PC running Windows 95 is needed)

Connecting your own PC to the SEGA SATURN makes it easy to write very large programs and to debug them. You can also save the programs you write on the PC's hard disk. For details, see Chapter 3, "Using the communication software".

Have the Windows communication cable ready.

*[Illustration: the Windows communication cable. The SEGA SATURN end (セガサターン本体側) is on the left, a box sits in the middle of the cable, and the PC end (パソコン側) on the right is a D-sub connector.]*

*[p. 10]*

#### Connecting at the SEGA SATURN end

Make sure the power is off, then connect the Windows communication cable to the expansion communication port on the back of the SEGA SATURN.

*[Illustration: the rear of the SEGA SATURN with the cable plug going into the communication port. Callout: "Insert the plug the right way round."]*

#### Connecting at the PC end

To connect to the PC you must buy, separately, an extension cable (an RS-232C straight cable) that suits your PC.

Make sure the PC is switched off, then connect the extension cable to the PC.

Next, connect the other end of the extension cable to the Windows communication cable.

> **Caution:** Do not connect the Windows communication cable directly to the PC. This will cause a fault.

### About the cable

The extension cable is the cable that connects the PC to the Windows communication cable.

It is called an "RS-232C straight cable" or an "RS-232C cable (for modem connection)".

At the Windows communication cable end it has a 25-pin D-sub connector (male). The connector at the other end depends on your PC.

*[p. 11]*

**■ If you use a DOS/V compatible PC**

The PC end is a small 9-pin D-sub connector. Connect it to the communication port.

When you buy the cable, ask for "an RS-232C straight cable for DOS/V".

**■ If you use a PC-9801 series PC**

The PC end is the same shape of connector as the Windows communication cable end (a 25-pin D-sub, female). Connect it to the RS-232C port.

When you buy the cable, ask for "an RS-232C straight cable for the PC-9801".

| Windows communication cable end (25-pin female) | Connectors of the cable you add | PC end |
|---|---|---|
| *[Illustration: 25-pin female D-sub]* | 25-pin male to 9-pin female | 9-pin male |
| *[Illustration: 25-pin female D-sub]* | 25-pin male to 25-pin female | 25-pin male |

※ A cable for an external modem can be used.

※ When you buy one in a shop, check the shape of the connectors.

For which communication port to connect to, see the manual for your PC.

*[p. 12 is blank]*

# Chapter 2: Making the most of BASIC

*[p. 13: chapter title page, "Chapter 2 BASIC活用術" (Making the most of BASIC), on a checkered background]*

*[p. 14 is blank]*

## 2.1 Trying out BASIC

*[p. 15]*

### Starting BASIC

This Tutorial Manual explains the basic operation of GAME BASIC for SEGA SATURN (called BASIC from here on).

When BASIC starts, a screen like the one in the figure is displayed. Under the R of "Ready." a small, wide rectangle is blinking. This is called the **cursor**.

```
GAME BASIC for SEGA...
(C)1998 ASCII Corp. ...
          /ESP inc.

Ready.
█
```

The cursor

*[p. 16]*

### Typing characters

If you are using the control pad, call up the software keyboard.

When you type the letter A on the software keyboard or the SEGA SATURN keyboard, the character "A" appears on the screen and the cursor moves one place to the right.

```
A_
```

"A" appears on the screen and the cursor moves one character to the right

Next, on the software keyboard select "A" and hold down the C button, or on the SEGA SATURN keyboard hold down the [A] key. You will see "A" typed again and again, with the cursor moving right each time. This is the **key repeat** function: when a key is held down for a certain time, the same character is automatically repeated. Input continues until you let go of the button or key.

*[p. 17]*

### Error messages

#### Producing an error message

With the characters from before still on the screen, select the arrow mark at the bottom right of the software keyboard, or press the [Enter] key on the SEGA SATURN keyboard.

```
A
Syntax error
A
Ready.
```

Syntax error

If a speaker is connected you will hear a sound, and at the same time an English message like the one in the figure is displayed.

When you give an instruction that is wrong or contradictory, BASIC displays an **error message** that matches the mistake, to tell the user.

"Syntax error" means "I cannot understand what work the text you typed is asking for". It is the error message for a **mistake in grammar**.

When you tell the SEGA SATURN to do something through BASIC, you type the text and then **press** the [Enter] key. BASIC then interprets, in order, the characters typed up to the moment [Enter] was pressed. But BASIC has rules for how the words that give instructions must be arranged, and if they are not followed it cannot understand the instruction. Even a small typing mistake is not accepted, so you will see this Syntax error (grammar mistake) many times.

*[p. 18]*

#### Understanding error messages

There are several kinds of error message, and the message changes with the kind of mistake. This also means that if you know what an error message means, you will have a fair idea of how to deal with it.

### How to erase characters you have typed

#### The CLS command

This time, let's erase the characters written on the screen.

```
CLS[Enter]
```

Type this. [Enter] means selecting the arrow mark at the bottom right of the software keyboard, or pressing the [Enter] key on the SEGA SATURN keyboard.

The screen should look like this:

```
Ready.
```

Typing CLS erases the characters on the screen

The characters on the screen vanish in an instant. CLS is a command you will use often, so try it a few times and learn it.

> **Note:** CLS is short for Clear Screen. Many of the words used in BASIC are made-up words based on English, like this one.

## 2.2 Using BASIC like BASIC

*[p. 19]*

### Typing and running a "command"

#### Commands

A string of characters that gives BASIC **an instruction with a fixed meaning** is called a **command** (命令, also コマンド). With the CLS command just now, you controlled the SEGA SATURN and erased the characters on the screen. In other words, you typed the command CLS, and BASIC operated the SEGA SATURN as the command told it to. This whole sequence of actions is called **execution** (running).

Typing a "command" and having it **executed** is the basic flow of work in BASIC.

You can also add various limits and ways of control to a "command". These are called **options** and **parameters**. By using options and parameters you can, for example, erase only half the screen or display characters slowly.

Things such as how much of the screen to erase and how fast to display characters are given as **numbers** and **characters**.

### Characters BASIC can handle

The characters you can use in BASIC commands are only the letters of the alphabet, the digits and some symbols.

You cannot use hiragana, katakana or kanji. For details of the symbols you can use, see the Reference Manual.

#### Numbers

There are two ways of thinking about numbers. One is to treat them as **characters**, as in the topic above. The other is as **numbers** for doing calculations.

The numbers BASIC handles include whole numbers and decimals. You can add, subtract, multiply and divide, but fractions cannot be handled as they are; convert them to decimals instead.

*[p. 20]*

### How BASIC commands are arranged (syntax)

The rules for arranging commands, parameters and options are called the **syntax**. The basic structure of the syntax is:

**command parameter (option)**

For details of each command, including its parameters and options, see the Reference Manual.

### Displaying characters and numbers with commands

Let's display characters and numbers using BASIC commands.

Type the following:

```
PRINT "HELLO"[Enter]
```

On the SEGA SATURN keyboard, type the double quotation mark (") with [Shift]+[2].

```
PRINT "HELLO"
HELLO
Ready.
█
```

HELLO is displayed

The word HELLO, which was enclosed in double quotation marks ("), has been displayed.

**PRINT** is a command. One of the things it does is display the characters, words or sentences placed between double quotation marks (").

Next, let's display a number.

*[p. 21]*

```
PRINT 1+2[Enter]
```

Type this.

```
PRINT 1+2
 3
Ready.
█
```

Displaying the answer to a calculation

The answer to the calculation, 3, is displayed. The PRINT command can display a number given as its parameter as it is, but when a calculation is given as the parameter it can also display the answer.

### Handling numbers and characters with variables

#### Assigning with LET

Imagine a box. This box can hold just one number or one piece of text. In BASIC, a box that holds a number or text is called a **variable** (変数, *hensū*). You can give a variable a name made from the letters and symbols that BASIC can use. Here we use one-letter names, but any name of 31 characters or fewer is fine.

To put a value into a variable, use the command **LET** and = (the equals sign, meaning assignment). First let's put a number into a variable. Type the following:

```
LET A=1[Enter]
PRINT A[Enter]
```

1 is displayed. In the first line, LET A=1, the value 1 is assigned to the letter A with the = sign. In terms of the box, you have put the number 1 into the box named A.

*[p. 22]*

You can also use it like this. The LET command can be left out, so from now on we will not write it.

```
X=2[Enter]
Y=3[Enter]
Z=X+Y[Enter]
PRINT Z[Enter]
```

The result is 5. Here 2 is assigned to X and 3 to Y. Z is X and Y added together, so the answer is 5.

Next, let's put text into a variable.

```
A$="HELLO !"[Enter]
PRINT A$[Enter]
HELLO !
```

A variable that handles text has **$ (dollar)** added after its name. After the = sign comes the text, word or sentence enclosed in double quotation marks (").

You can also write calculations with text variables.

```
A$="HELLO,"[Enter]
B$="WORLD !"[Enter]
PRINT A$+B$[Enter]
```

When you run this:

```
HELLO,WORLD !
```

You have used variables to add text together. In this way you can join on words or parts of sentences with a calculation.

Variables are the most basic part of BASIC, so make sure you understand them well.

## 2.3 Your first program

*[p. 23]*

### "Direct mode" and "program mode"

When you operate the SEGA SATURN with BASIC there are two states (modes). One is "**direct mode**", in which you give a command for each single action, such as clearing the characters on the screen or doing a calculation, and BASIC waits for the next command when that action is finished. The other is "**program mode**", which is explained from here on.

Think of a music box, for example. It has a paper or metal score prepared in advance that describes how to play. Once this is set in the mechanism, it plays exactly as the score says for as long as the spring (its power) lasts. A set of instructions for a machine made in advance like this is called a **program**, and making a program is called **programming** (making a program).

#### Processing in a set order

In program mode you also combine **commands** to say what should be done, but the method is a little different from direct mode. In program mode you write a **list of processing steps** called a **program listing**, have it stored, and then run it all in one go. This is far more efficient than giving a command every time.

Next, we explain the program listing.

#### The program listing

Type the following:

```
10 PRINT "HELLO !"[Enter]
20 END[Enter]
```

The 10 at the start is the **line number**. Line numbers show the order of the commands. END on line 20 means just what it says, "end", so execution finishes when processing reaches it.

When you have finished typing, the screen should look like this.

*[p. 24]*

```
10 PRINT "HELLO!"
20 END
█
```

Processing ends with the END command

Now type CLS and then LIST.

The program listing you typed earlier is displayed just as it was. The LIST command lists the program that has been typed in.

The program listing you have typed stays in the SEGA SATURN's **work RAM** until you give a command to "erase" it or switch the power off. Work RAM is where BASIC carries out processing according to the commands you have typed.

> **Note:** A line is the unit of processing in BASIC. The commands written in a line are processed from left to right.

### Correcting mistakes

Before you press [Enter], check that there are no mistakes. We have already explained that an error message is displayed if there is a mistake. If you run the program and an error message appears, use the LIST command to display the program listing.

There are the following ways to correct mistakes:

- Erase every character from the cursor position back to the mistake, one character at a time, with the B button on the control pad or the [Backspace] key on the SEGA SATURN keyboard, then type the correct characters again.
- Move the cursor back to just right of the wrong character with A+direction button on the control pad or the arrow keys on the SEGA SATURN keyboard, and erase it with the B button or the [Backspace] key. Then

*[p. 25]*

type the correct character.

*[Illustration: "ABC" with the cursor after it becomes "AB": pressing the key erases the character one place to the left of the cursor.]*

Erasing characters with the B button or the [Backspace] key

You can also pick out one particular line to correct. For example, if you notice a mistake in line 10, you can correct it in these ways:

- Type LIST 10[Enter], move the cursor to the mistake and correct it.
- Type DELETE 10[Enter].
- Type the whole of line 10 again.

Correcting mistakes like this is called **debugging**.

Long, complicated programs may need more convenient methods. For those, see the Reference Manual.

### Running it

Now let's run the program listing. Type the following:

```
RUN[Enter]
```

```
10 PRINT "HELLO!"
20 END
RUN
HELLO!
Ready.
```

Running the program

*[p. 26]*

BASIC interpreted the program listing you typed, operated the SEGA SATURN and displayed characters on the screen.

Next, let's make a program that uses the commands provided in BASIC and the functions of the SEGA SATURN.

### Making a digital clock

#### How to think about a program

You cannot write a program just by knowing the commands. You have to think through, step by step, what processing the program you want needs, and which commands to use for it, and build up your ideas in order.

Here we explain this concretely while looking at a program listing (called a listing from here on) that displays a digital clock.

Before typing in this listing, type the following:

```
NEW[Enter]
```

"Ready." is displayed. The NEW command **erases** the listing currently in the SEGA SATURN from work RAM. Get into the habit of always typing it before you enter a new listing. If you don't, the previous program may be left behind and cause unexpected behaviour.

Now type in the following listing:

```
100 SCREEN 0
110 ZOOM 4,2,4
120 *LOOP
130 LOCATE 0,2:PRINT RIGHT$(DATE$,18)
140 GOTO *LOOP
```

When you have checked that there are no mistakes, run it.

```
RUN[Enter]
```

*[p. 27]*

```
06/25 THU 12:02:02
```

Digital clock *[Screen: the date and time shown in large characters.]*

This listing uses nothing but commands we have not explained yet. We now explain, in order, what processing each line asks for.

- Line 100. The **SCREEN** command initialises the screen. It erases the characters and pictures drawn on the screen and prepares an environment where new work can be done. This processing is done even if nothing is drawn on the screen.
- Line 110. The **ZOOM** command sets the screen that characters are written on to be displayed enlarged 2 times horizontally and 4 times vertically.
- Line 120. The *LOOP in this line is called a **label**. This line does no processing by itself, but it has an important meaning. This is explained in detail under line 140.
- Line 130. The **LOCATE** command says where on the screen characters and so on are displayed. It is usually used together with the PRINT command.
  The ":" (colon) is a slightly special symbol. Separating commands with ":" (colon) lets you write two or more commands on one line. Putting two or more commands on one line is called a **multi-statement**.
- The DATE$ function and the RIGHT$ function read the date and time from the SEGA SATURN's built-in clock, and the PRINT command displays it.
- Line 140. A program basically runs in line-number order, but some commands change this order. The GOTO command is one of them. *LOOP appeared in line 120. If you write GOTO "label", execution jumps to the position of the label. This is how the order of operation can be changed. You can also give a line number instead of a label, but line numbers can change when you add to the listing, so making a label and using it leads to fewer mistakes.

*[p. 28]*

To sum up, in lines 100 to 110 this program initialises the screen and asks for enlarged characters. It repeats between line 120 and line 140, and keeps displaying the current time obtained in line 130. So when one second passes at line 130, the characters displayed also change by one second.

In other words, the processing needed for the goal of displaying a digital clock, "getting the date and time" and "displaying it", was solved with the DATE$ and RIGHT$ functions and the ZOOM and GOTO commands.

#### Stopping a running program

Looking at the listing, you can see there is no END command, so this program never stops. Of course execution stops if you switch the power off, but there is also a way to force a program to stop. On the control pad press A+Start button, or on the SEGA SATURN keyboard press [Ctrl]+[c]. The program is interrupted. Forcing a running program to stop is called a **Break**.

```
06/25 THU 12:02:08
Break at 130
Ready.
█
```

Break stops the processing

But the characters stay large on the screen. Type:

```
SCREEN 0[Enter]
LIST[Enter]
```

The enlarged screen environment is initialised, and you are back to how things were before you ran the program listing.

*[p. 29]*

#### Saving the program you wrote on the SEGA SATURN

A program you have written is only stored temporarily in the SEGA SATURN's work RAM. So if you clear work RAM with the NEW command, or switch off the power, the listing is gone. Typing it in every time you use it is a nuisance and a waste of time, not only for long programs but even for programs a few lines long. Save the programs you write. The SEGA SATURN also has storage devices such as cartridge RAM (the Power Memory, sold separately), but here, as an example, we explain saving to the **internal RAM** of the console.

```
SAVE "BRAM:DATE.B"[Enter]
```

Type this.

When "Ready." is displayed, saving is finished. A saved program is called a **file**. The SAVE command saves a program to the storage device you name. BRAM: is the storage device called internal RAM. DATE.B is the name given to the file when the program is stored, and is called the **file name**. To be sure, let's check that it has been saved.

> **Caution:** This explanation assumes there is enough free space in internal RAM. If internal RAM holds other game data, there may not be enough space and the program may not save.

#### Checking that it was saved

Check like this:

```
FILES "BRAM:"[Enter]
```

If internal RAM holds no files other than the one you just saved, the screen looks like the figure.

*[p. 30]*

```
FILES "BRAM:
DATE    .B
Free size 105 / 512 file blocks
Ready.
█
```

The FILES command

As well as checking a save, the FILES command can find out what files are on a storage device such as internal RAM, or on the CD-ROM. Try typing the following:

```
FILES "CD:"[Enter]
```

Lots of file names appeared. "CD:" names the CD-ROM in the console. The "BRAM:" from before is the internal RAM. Cartridge RAM is named "CRAM:". With these you can find out what you have saved on which storage device.

To name other storage devices, see the Reference Manual.

#### Loading a file you have checked

Now let's type the NEW command. Typing RUN only shows "Ready.". The digital clock program has been erased from work RAM.

Now let's load the file we saved before.

```
LOAD "BRAM:DATE.B"[Enter]
```

The LOAD command loads a file, such as a program, from a particular storage device.

```
LIST[Enter]
```

It seems to have been loaded properly.

*[p. 31]*

Being able to save programs means not only that you can stop programming at any time, but also that you can avoid accidents such as losing the whole program you are working on in a power cut. When you write a program you want to keep, we recommend saving it often.

*[The rest of p. 31 is blank.]*

## 2.4 A slightly more advanced program

*[p. 32]*

#### Kinds of command

BASIC has four broad systems of commands:

- **General commands**: mainly the commands that handle numeric expressions and operations on text.
- **File commands**: the commands that mainly handle files, that is, programs and the similar things called data.
- **Video commands**: the commands that handle initialising the screen and displaying pictures and text.
- **Sound commands**: the commands that handle sound.

For details of each group of commands, see the Reference Manual.

### Changing the flow of a program

#### The IF～THEN command

In the digital clock program listing, we used the GOTO command to repeat processing. The GOTO command can also be used to force a change of where the program jumps to. Here we introduce a new way of control that makes GOTO even more useful.

First, type in the following listing:

```
10 A=1
20 A=A+1
30 PRINT A
40 GOTO 20
```

When you run it, it keeps displaying a rising number for ever. This program will not stop if you leave it. Interrupt it with a **Break**.

There are several ways to make it finish by itself. Here we will make the program end when the variable A reaches 500. For this we use the IF～THEN command.

*[p. 33]*

Its basic use is as follows:

**IF** *condition* **THEN** *statement*

The condition compares text or numbers with a condition. If it is met, control passes to the statement after THEN. Let's use IF～THEN to change the listing from before.

```
35 IF A=500 THEN GOTO 50[Enter]
50 END[Enter]
```

Then:

```
LIST[Enter]
```

and you will see:

```
10 A=1
20 A=A+1
30 PRINT A
35 IF A=500 THEN GOTO 50
40 GOTO 20
50 END
```

The newly added lines are 35 and 50. Line 35 says that when the variable A becomes 500, jump to line 50. The END command on line 50 completes the program. If the variable A is any value other than 500, execution goes past THEN to line 40 and, as that command says, jumps to line 20.

Now let's run it. When 500 is displayed on the screen, "Ready." appears and the program has ended successfully. Conditions can be written in many ways.

#### Conditions

| Symbol | Meaning | Example | |
|---|---|---|---|
| `=` | equal | `IF A=B` | when A and B are equal |
| `>` | greater | `IF A>B` | when A is greater than B |
| `<` | less | `IF A<B` | when A is less than B |
| `>=` | greater or equal | `IF A>=B` | when A is greater than or equal to B |
| `<=` | less or equal | `IF A<=B` | when A is less than or equal to B |
| `<>` | not equal | `IF A<>B` | when A and B are not equal |

By using conditions, the IF～THEN command makes many kinds of control possible.

*[p. 34]*

#### RENUM tidies up line numbers

In the listing before, we made a line numbered 35. The other line numbers go up in tens, but only this one has an odd 5. It works without any problem, but in a program with many lines it can become hard to read. So we use RENUM, a special command that is run in direct mode. It is the command that tidies up the line numbers of the listing and renumbers them (RENUMber).

```
RENUM[Enter]
```

The line numbers have been tidied up. To be sure, type the LIST command and check.

```
Ready.
LIST
 10 A=1
 20 A=A+1
 30 PRINT A
 35 IF A=500 THEN GOTO 50
 40 GOTO 20
 50 END
Ready.
RENUM
Ready.
LIST
 100 A=1
 110 A=A+1
 120 PRINT A
 130 IF A=500 THEN GOTO 150
 140 GOTO 110
 150 END
Ready.
```

The line numbers are tidied up

RENUM renumbers from line 100. This is because it is fixed by BASIC's standard settings. In this way, the parameters and options of a command are sometimes set in advance. These settings are called the **default settings**, or just the **defaults**.

The default settings can also be changed. For the default values and how to change them, see the Reference Manual.

### Controlling repetition

#### The FOR～NEXT command

The FOR～NEXT command controls repetition. It is useful when you know how many times to repeat. It is also handy when you want to display the same text many times, or when making tables.

*[p. 35]*

**FOR** *variable* **=** *start value* **TO** *end value*
&emsp;*any program (may be empty)*
**NEXT** *variable*

Any program between them is repeated while the variable goes from the start value assigned to it up to the end value. The variable name after FOR and after NEXT must be the same. Let's explain with a concrete example.

Before typing in a new program, don't forget to type the NEW command. If you need to, save your previous listing first.

```
10 FOR I=1 TO 10
20 PRINT "HELLO !"
30 NEXT I
40 END
```

When you run it, HELLO ! is displayed 10 times. Change the 10 after TO on line 10 to 5 and run it again. This time it is displayed 5 times.

By actually changing the numbers like this, you can see that the FOR～NEXT command controls the repetition.

Let's use FOR～NEXT to program one more well-known calculation problem.

```
10 A=0
20 FOR I=1 TO 10
30 A=A+I
40 NEXT I
50 PRINT A
60 END
```

When you run it, 55 should be displayed.

This listing adds up the numbers from 1 to 10, as you learn in arithmetic. Before, we only used repetition for text, but it can be used for calculations too.

As a further use of FOR～NEXT, you can also write this:

```
FOR I=0 TO 10
    FOR J=0 TO 10
        any program
    NEXT J
NEXT I
```

This is a FOR～NEXT placed inside a FOR～NEXT. It is also called **nesting**. Nesting can be used, for example, when making tables. When you nest them, the variable names in each of the two FOR～NEXT pairs must match. Take care that each variable belongs to the inner or the outer FOR～NEXT.

*[p. 36]*

### Organising a program so it is easy to read

As a program gets more complicated, even the person who wrote it can find it hard to follow. Writing programs that are easy to read is also a technique.

#### The idea of a subroutine

While a listing is short, it is fine to think out a draft and write it in order from the start, using IF～THEN and GOTO to change where it jumps as needed. But as the listing gets longer, you end up writing similar processing, differing only slightly, again and again. So here we introduce the idea of a **subroutine**, which cuts down the work of writing the same thing and raises productivity.

A subroutine is **one component** that gathers together a job that is repeated many times in a program. Turning a job that is repeated many times into a subroutine is also called **making it a subroutine**. In contrast, the listing as a whole is called the **main routine**.

#### Making a subroutine

We explain making a subroutine with a concrete example.

Look at the following listing:

```
100 PRINT "-----------------"
110 PRINT "|   |   |   |   |"
120 PRINT "|---+---+---+---|"
130 PRINT "|   |   |   |   |"
140 PRINT "|---+---+---+---|"
150 PRINT "|   |   |   |   |"
160 PRINT "|---+---+---+---|"
170 PRINT "|   |   |   |   |"
180 PRINT "|---+---+---+---|"
190 PRINT "|   |   |   |   |"
200 PRINT "-----------------"
```

This table is just simple vertical and horizontal lines put together. For a small table that is no problem, but for a large table, adding lines one row at a time is inefficient. We use a subroutine to hand the tedious work over to the computer.

First, find the lines in the table that do the same job:

- Lines 100 and 200
- Lines 110, 130, 150, 170 and 190
- Lines 120, 140, 160 and 180

Putting these jobs together gives the following.

*[p. 37]*

```
100 PRINT "-----------------"
110 PRINT "|   |   |   |   |"
120 PRINT "|---+---+---+---|"
```

You can see that only these 3 lines are needed to make the table in this program. If each line is reused as a component, the listing should become much easier to read. Let's rewrite it with subroutines.

```
100 GOSUB 200
110 FOR I=1 TO 4
120 GOSUB 210:GOSUB 220
130 NEXT
140 GOSUB 210:GOSUB 200
150 END
200 PRINT "-----------------":RETURN
210 PRINT "|   |   |   |   |":RETURN
220 PRINT "|---+---+---+---|":RETURN
```

The command using GOSUB on line 100 means "jump to the subroutine".

Lines 200, 210 and 220 are the job of making the table turned into subroutines. Each line ends with the command RETURN. This is the rule for returning to the command after the GOSUB command. If you forget it, you cannot get back from the subroutine to the main routine that jumped to it.

Using subroutines well makes a program concise. Making programs that are easy to understand is important.

### Using numbers and characters well

#### Array variables

We have already explained variables. Next we explain **array variables**, an idea that develops variables a little further.

A variable is a single box for holding a number or text, but an array variable can hold several numbers or pieces of text. Think of it as boxes of the same size joined together into one group.

As a picture, it looks like this:

*[Illustration: on the left a single box labelled A with the number 5 being put in; on the right a row of joined boxes labelled A(0), A(1), A(2), A(3), with 5 being put into one of them.]*

The difference between a variable and an array variable

*[p. 38]*

You declare an array variable before you first use it.

**DIM** *array variable name* **(***subscript***)**

Example: `DIM A(3)`

In the example, the array variable A has ( ) after it, with the number 3 written inside. This is called the **subscript** (添字, *soeji*). In this example the number of values it can hold is the 4 from A(0) to A(3). The contents at each subscript of an array variable are called an **element**. Once it has been declared, you don't need DIM at the start in later lines.

Array variables can also handle text.

Example: `DIM A$(3)`

As with ordinary variables, add $ (dollar) after the variable to handle text.

Now let's look at a program that uses an array variable. So that it is easy to check when displayed, the explanation uses text.

```
100 DIM HAKO$(4)
110 HAKO$(0)="CANDY"
120 HAKO$(1)="MANJYU"
130 HAKO$(2)="CHOCO"
140 HAKO$(3)="SENBEI"
150 HAKO$(4)="JERRY"
160 FOR I=0 TO 4
170 PRINT HAKO$(I)
180 NEXT
190 END
```

*[HAKO is Japanese for "box". MANJYU (manjū, a sweet bun) and SENBEI (rice cracker) are Japanese snacks.]*

Line 100 declares an array variable called HAKO$, and lines 110 to 150 set each element. Lines 160 to 180 display each element, and line 190 ends.

An array variable is a very useful kind of variable: you can assign different elements just by changing the subscript of a variable with the same name.

Next, let's introduce statements that are often used when putting elements into an array variable.

#### READ and DATA: setting array elements efficiently

Look again at the part of the previous program that sets the elements of the array variable.

```
100 DIM HAKO$(4)
110 HAKO$(0)="CANDY"
120 HAKO$(1)="MANJYU"
130 HAKO$(2)="CHOCO"
140 HAKO$(3)="SENBEI"
150 HAKO$(4)="JERRY"
```

*[p. 39]*

Similar statements are repeated. This listing is fine while it is short, but when there are dozens or hundreds of these, the listing gets longer and longer just from setting the elements. Here, let's make the listing easier to read with the READ and DATA commands, which are handy for setting each element. Type in the following listing:

```
100 DIM HAKO$(4)
110 FOR I=0 TO 4
120 READ HAKO$(I)
130 PRINT HAKO$(I)
140 NEXT
150 END
160 DATA CANDY,MANJYU,CHOCO,SENBEI,JERRY
```

When you run it, you get the same result as the previous listing. BASIC's READ and DATA commands are a pair: the numbers, text and so on written in a DATA line are defined as **data**. READ reads them and assigns them to the variable written after it.

In the program, the READ command on line 120 reads the data defined on line 160 in order, separated by commas (,), and sets each one as an element of the array variable HAKO$. Line 130 displays the result.

A typical use of READ and DATA is in games. The pictures of the characters are defined in advance with DATA commands, and the defined data is read into array variables with the READ command.

Many of the sample programs introduced in the second half of this Tutorial Manual use these commands, so refer to them.

### Summary

So far we have explained the basic handling of BASIC, displaying things, and how to control the flow of operation.

We have also said that when you write a program, you must think through in order what processing a program needs to do what you want, and which commands to use for it, and build up your ideas.

Next, we explain programs that use the commands for pictures and music, which are essential for making games.

## 2.5 Graphics

*[p. 40]*

### How the screen is made up

#### Structure diagram

The BASIC screen is made up as follows.

*[Diagram: a stack of layers. Several character screens (キャラクタ画面), a bitmap rotation screen (ビットマップ回転画面), bitmap screens (ビットマップ画面) and a character rotation screen (キャラクタ回転画面) are drawn as overlapping planes. Dotted lines lead from them to the text screen (テキスト画面), labelled "can be chosen from any one screen" (任意の一面より選択可). Separately, the sprite screen (polygon screen) (スプライト画面(ポリゴン画面)) is shown in front.]*

**■ Character screen**

BASIC interprets characters as strings of numbers, and these number strings are sent to the character screen, turned into characters and displayed. The number strings that BASIC interprets are called **character codes**. For the character codes, see the "Character code table" at the end of the Reference Manual.

The character screen is a screen that shows characters by looking up their character codes.

*[p. 41]*

**■ Bitmap screen**

A screen for drawing shapes in 256 or 32768 colours. In BASIC, kanji, hiragana and so on are also handled as shapes, so they are displayed on the bitmap screen too.

**■ Text screen**

Part of the character screens: the BG screen used specially for displaying BASIC's characters. With the SCREEN command you can choose any one character screen for it.

**■ Sprite screen (polygon screen)**

Sprites are a slightly special screen. If the other screens are like walls, the sprite screen is like picture frames hung on those walls. A frame holds a picture drawn by the user, and it can be moved around freely.

It is treated as a separate display screen, but it is shared with the **polygon screen**.

Each screen is a transparent layer, and the layers overlap so that they look like one. Each layer is displayed independently, so unless you give a special instruction they do not affect each other.

### Modes

#### The SCREEN command

There are several basic combinations of screen layout, and there is a command for switching between them. Parameters in [ ] can be left out.

`SCREEN [<screen mode>][,<text logical BG>][,<text colours>][,<drawing frame unit>]`

**■ Screen mode**

The parameter that changes the initial settings of the screen. Use it by giving a number, as below. For details, see the Reference Manual.

```
SCREEN 0
```

*[p. 42]*

**Screen mode 0 (default)**

| Logical BG | Kind of screen | Colour mode | Colours | Notes |
|---|---|---|---|---|
| 0 | Bitmap screen | RGB | 32768 | Can scroll and zoom |
| 1–3 | Not usable | – | – | |
| 4 | Character screen | Palette | 512 | Can scroll and zoom |
| 5 | Character screen | Palette | 512 | Can scroll |
| 6–9 | Not usable | – | – | |

**Screen mode 1**

| Logical BG | Kind of screen | Colour mode | Colours | Notes |
|---|---|---|---|---|
| 0 | Bitmap screen | Palette | 256 | Can scroll and zoom |
| 1 | Bitmap screen | Palette | 256 | Can scroll and zoom |
| 2–3 | Not usable | – | – | |
| 4 | Character screen | Palette | 512 | Can scroll |
| 5 | Character screen | Palette | 512 | Can scroll |
| 6–9 | Not usable | – | – | |

**Screen mode 2**

| Logical BG | Kind of screen | Colour mode | Colours | Notes |
|---|---|---|---|---|
| 0–3 | Not usable | – | – | |
| 4 | Character screen | Palette | 512 | Can scroll and zoom |
| 5 | Character screen | Palette | 512 | Can scroll and zoom |
| 6–7 | Not usable | – | – | |
| 8 | Character rotation screen | Palette | 512 | Can rotate about the Z axis |
| 9 | Not usable | – | – | |

※ The Z-axis rotation screen on logical BG 8 is 256×256 characters in size. The last 16 colours of logical BG 8 are used by the virtual keyboard.

*[p. 43]*

**Screen mode 3**

| Logical BG | Kind of screen | Colour mode | Colours | Notes |
|---|---|---|---|---|
| 0–1 | Not usable | – | – | |
| 2 | Bitmap rotation screen | Palette | 256 | Can rotate about the Z axis |
| 3 | Not usable | – | – | |
| 4 | Character screen | Palette | 512 | Can scroll and zoom |
| 5 | Character screen | Palette | 512 | Can scroll and zoom |
| 6–9 | Not usable | – | – | |

**Screen mode 4**

| Logical BG | Kind of screen | Colour mode | Colours | Notes |
|---|---|---|---|---|
| 0–3 | Not usable | – | – | |
| 4 | Character screen | Palette | 256 | Can scroll and zoom |
| 5 | Character screen | Palette | 256 | Can scroll and zoom |
| 6 | Character screen | Palette | 256 | Can scroll |
| 7 | Character screen | Palette | 256 | Can scroll |
| 8–9 | Not usable | – | – | |

**Screen mode 5**

| Logical BG | Kind of screen | Colour mode | Colours | Notes |
|---|---|---|---|---|
| 0–3 | Not usable | – | – | |
| 4 | Character screen | Palette | 512 | Can scroll and zoom |
| 5 | Character screen | Palette | 512 | Can scroll and zoom |
| 6–7 | Not usable | – | – | |
| 8 | Character rotation screen | Palette | 512 | Can rotate on 3 axes |
| 9 | Not usable | – | – | |

※ The 3-axis rotation screen on logical BG 8 is 256×256 characters in size.

*[p. 44]*

**Screen mode 6**

| Logical BG | Kind of screen | Colour mode | Colours | Notes |
|---|---|---|---|---|
| 0–3 | Not usable | – | – | |
| 4 | Character screen | Palette | 512 | Can scroll and zoom |
| 5 | Character screen | Palette | 512 | Can scroll and zoom |
| 6–7 | Not usable | – | – | |
| 8 | Character rotation screen | Palette | 512 | Can rotate on 3 axes |
| 9 | Character rotation screen | Palette | 512 | Can rotate on 3 axes |

**■ Text logical BG**

The screen used mainly for displaying text. However, it is separate from the character screen that displays the program listing.

**■ Text colours**

Gives the number of colours of the text logical BG.

**■ Drawing frame unit**

Gives the screen switching time, as a number of sixtieths of a second.

> **Note:** Every game machine that connects to a home television uses a technique of switching drawing frames (double buffering and so on). The drawing frame being in units of 1/60 second comes from the characteristics of the television.

### Coordinates

In the screen display of a computer such as the SEGA SATURN, the whole screen is thought of as divided into squares, like fine graph paper. Each of these squares is called a **dot**. A dot is pinpointed with numbers, such as "3rd from the left, 5th from the top", and a point expressed in numbers is called a **coordinate**. The idea of coordinates differs between the character screen, where characters are drawn, and the bitmap screen, where pictures are drawn.

*[p. 45]*

*[Diagram: the character screen as a grid of character cells, numbered 0 to 38 across and 0 to 25 down, with one cell marked "1 character" (1キャラクタ).]*

Character screen

*[Diagram: the bitmap screen as a fine grid, numbered 0 to 319 across and 0 to 223 down, with one cell marked "1 dot" (1ドット).]*

Bitmap screen

When you draw text or pictures on the computer screen, you use the BASIC commands for the screen concerned. In this Tutorial Manual, coordinates are described with the horizontal axis as the **X coordinate** and the vertical axis as the **Y coordinate**.

*[p. 46]*

### Drawing shapes

#### Drawing a point

Changing the colour of one square (dot) on the screen makes it look as if a single point has been drawn on the screen. This is the basis of every shape. The position of the square whose colour is changed is given by coordinates.

`PSET(X coordinate,Y coordinate)[,<colour>]`

The PSET command draws a point on the bitmap screen at the X and Y coordinates given, in the colour given. Colours are explained later.

A program that displays a point in the centre of the screen:

```
100 SCREEN 0
110 PSET(160,112)
```

Line 100 initialises the bitmap screen. Line 110 draws a point in the centre of the bitmap screen. When you run it, a single, slightly wide point is displayed.

> **Caution:** Depending on your television, the point may not show as a true white, or may look doubled. This is due to the characteristics of the television signal, and is not a fault in the equipment.

#### Drawing a straight line

In BASIC, a line is treated as a shape made of points gathered together. Straight lines are drawn on the bitmap screen with the LINE command.

*[Illustration: a diagonal line on a TV screen, with a magnified circle showing that it is made of a staircase of dots.]*

How BASIC thinks of a line

`LINE[(<start X>,<start Y>)]-(<end X>,<end Y>)[,<colour>][,B or BF]`

The LINE command joins the start and end points given as coordinates with a straight line in the colour given. With the option B or BF, it draws a rectangle with the start and end points as opposite corners, or a filled rectangle.

A program that draws a straight line on the screen:

```
100 SCREEN 0
110 LINE(0,0)-(319,223)
```

*[p. 47]*

Line 100 initialises the bitmap screen. Line 110 draws a straight line on the bitmap screen from the top left corner to the bottom right corner.

#### Drawing shapes

BASIC also has commands for drawing shapes other than lines and rectangles. CIRCLE is the command that draws circles.

`CIRCLE(<X coordinate>,<Y coordinate>),<radius>[,<colour>][,F]`

The CIRCLE command draws a circle centred on the X and Y coordinates, with the radius and colour given. With the option F, the inside is filled in the same colour as the line that drew the circle.

A program that draws a circle on the screen:

```
100 SCREEN 0
110 CIRCLE(160,112),25
```

Line 100 initialises the bitmap screen. Line 110 draws a true circle of radius 25 from the centre of the bitmap screen. The circle command can also draw ellipses. For details, see the Reference Manual.

#### Making colours

A computer draws colours on the same principle as a television shows them. The colour of a dot is decided by a combination of **RGB**.

The colour of a dot is expressed on the following principle.

**■ RGB colour**

| Colour component | 32768 colours |
|---|---|
| Red (RED) | 32 levels (0–31) |
| Green (GREEN) | 32 levels (0–31) |
| Blue (BLUE) | 32 levels (0–31) |

The colours a computer draws are made by combining the **three primary colours of light**. The shade changes as you control the value of each colour. In BASIC, up to 32768 colours can be set. The colour is calculated as follows:

**Value of the colour = red component + (green component × 32) + (blue component × 1024)**

Here we have set a colour in the circle-drawing program from before.

```
100 SCREEN 0
110 CIRCLE(160,112),25,RGB(0,31,0),F
```

*[p. 48]*

*[Screen: a filled circle in the middle of the screen, with "Ready." at the top left.]*

A green circle

A circle filled with green is displayed on the screen. Line 100 initialises the bitmap screen. Line 110 draws the circle in the colour given.

#### Filling an area

It is fine for simply filling a circle or rectangle, but where the fill option can't be used, or a complicated area must be filled, a dedicated command is used.

`PAINT(<X coordinate>,<Y coordinate>)[,<fill colour>][,<border colour>][,<border colour>].....`

The PAINT command fills from the coordinates given with the colour given. By giving several border colours as well, you can fill the part enclosed by the border colours without spilling over.

A program that fills the part where a white rectangle and a white circle overlap:

```
100 SCREEN 0
110 LINE (100,50)-(200,150),RGB(31,31,31),B
120 CIRCLE (200,100),50,RGB(31,31,31)
130 PAINT (160,100),RGB(0,31,0),RGB(31,31,31)
```

Line 100 initialises the bitmap screen. Line 110 draws the rectangle and line 120 the circle. Line 130 fills the overlapping part with green. The border is RGB(31,31,31), the brightest colour number BASIC can display.

#### Drawing points and lines in a colour set in a palette number

The palette was devised as a way to make drawing on the screen faster. Using this method called a palette makes drawing on the screen faster.

*[p. 49]*

You can think of the idea of the palette like this. BASIC has containers numbered 0 to 255, and you put the colours you want to use into each container in advance.

By preparing the colours you will use in advance, you can use the palette as "remember the number of the container you put the colour in, and when you want to use it, take the colour out by that number and paint with it".

In other words, the advantage of the palette is that instead of the old work of saying "the colour made from a red component of 31, a green component of 0 and a blue component of 31", you can say "the colour in palette number 10", so drawing on the screen can be made faster.

In the earlier example we gave the RGB values directly to draw. This time let's use the palette to draw a point and a line.

```
10 SCREEN 1
20 ACTIVE 1
30 PALETTE ,10,RGB(0,31,0)
40 PALETTE ,20,RGB(0,0,31)
50 PSET (100,100),10
60 LINE (0,200)-(200,200),20
```

Line 10 sets up the screen. Line 20 sets the screen that points are drawn on.

Lines 30 and 40 set the palettes used for the lines. Take care with the format here. Line 50 actually uses the colour in palette number 10 to draw a point at X coordinate 100, Y coordinate 100. Line 60 uses the colour in palette number 20 to draw a horizontal line from X coordinate 0, Y coordinate 200 to X coordinate 200, Y coordinate 200.

#### Displaying kanji

To display kanji in BASIC, a connection to a PC is needed. For connecting to a PC, see Chapter 3, "Using the communication software", later.

The explanation of displaying kanji assumes that the SEGA SATURN is connected to a PC.

**■ Preparing before display**

Kanji are displayed as shapes on the bitmap screen. To display kanji you must have the kanji character data ready. Type the following:

```
KLOAD ON[Enter]
```

To display kanji in BASIC, use the KLOAD command to load the kanji character data from BASIC. However, using the KLOAD command reduces the amount of work RAM a program can use. For details, see the Reference Manual.

*[p. 50]*

#### The display command

Kanji are displayed with the following command.

`KPRINT [(<start X>,<start Y>[,<X character spacing>,<Y character spacing>,<half-width position>]),][FIX][<string expression>][;][,<text colour>][,<SCALE>][,<background colour>]`

A program that displays kanji:

```
100 SCREEN 0
110 KLOAD ON
120 KPRINT "せがた三四郎"
130 LOCATE 0,2
```

*[せがた三四郎 is "Segata Sanshiro", the character from SEGA SATURN advertising in Japan.]*

```
せがた三四郎
Ready.
█
```

Displaying kanji

Line 100 initialises the bitmap screen, line 110 loads the kanji data from the CD-ROM, and line 120 displays the kanji. Line 130 moves the cursor position so that the kanji displayed and "Ready." do not overlap.

> **Note:** There are two kinds of kanji data, "full-width" and "half-width". A half-width character is half as wide as a full-width one, and the same height. These are called "full-width characters" and "half-width characters".

*[p. 51]*

### Displaying sprites

#### What is a "sprite"?

The idea of a sprite is like drawing a character or the like on a transparent sheet, and managing and operating it by number. The number of transparent sheets you can control is limited, but you can combine several of them to add variety to the display.

There are two ways of thinking about the sprites BASIC handles.

One is the sprite managed by a number from 0 to 255, in 256 kinds. Its size is 16×16 dots, and the colours are fixed at 256. The arrangement of colours drawn on one sheet is called the **pattern**.

The other is based on the idea of polygons, which is explained later. Simply put, it is an extension of the first kind and can be enlarged, reduced, rotated and so on. This is explained next.

```
0 0 1 1 1 1 0 0 0 0 0 0 0 0 0 0
0 1 1 0 0 1 1 0 0 0 0 0 0 0 0 0
1 1 0 0 0 0 1 1 0 0 0 0 0 0 0 0
0 1 1 0 0 1 1 0 0 0 0 0 0 0 0 0
0 0 1 1 1 1 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
```

Sprite pattern *[a 16×16 grid of 0s and 1s; the 1s form a small ring in the top left corner]*

This arrangement of 0s and 1s is the sprite's pattern.

The parts of the table that are 0 are the transparent colour: where it overlaps the background, the background shows through.

The parts that are 1 are where colour is actually applied. The colour of the 1 parts is changed by setting the palette with the PALETTE command.

Using the palette explained before, we actually set it like this:

*[p. 52]*

```
PALETTE 10,1,RGB(31,0,0)
PALETTE 10,2,RGB(0,31,0)
PALETTE 10,3,RGB(0,0,31)
PALETTE 10,4,RGB(0,0,0)
PALETTE 10,5,RGB(31,31,31)
```

Putting these settings into a table to make them easy to follow, the palette is arranged as follows (there are really 256 palette entries, but only the 1 to 5 just set are shown here).

**Palette definition**

| 0 | 1 | 2 | 3 | 4 | 5 | … | 255 (&HFF) |
|---|---|---|---|---|---|---|---|
| ??? | RGB(31,0,0) | RGB(0,31,0) | RGB(0,0,31) | RGB(0,0,0) | RGB(31,31,31) | … | ??? |
| ??? | Red | Green | Blue | Black | White | … | ??? |

Now let's assign the palette in the table to the pattern made on the grid.

The pattern before uses only 0 and 1, so it has two colours: the **transparent colour** and palette number 1 (red at the moment). (There are really 16×16 = 256 dots, but here everything after the first 6 dots is left out.)

**Sprite pattern (first 6 dots)**

| Dot number | 0 | 1 | 2 | 3 | 4 | 5 | … | 255 |
|---|---|---|---|---|---|---|---|---|
| Palette number | 0 | 0 | 1 | 1 | 1 | 1 | … | 0 |
| Actual colour | Transparent | Transparent | Red | Red | Red | Red | … | Transparent |

The transparent colour is the part where the background colour is shown as it is. To picture the final image displayed, we also draw a picture of the background.

**Background pattern**

| Dot number | 0 | 1 | 2 | 3 | 4 | 5 | … | n |
|---|---|---|---|---|---|---|---|---|
| Palette number | 5 | 5 | 5 | 5 | 5 | 5 | … | 5 |
| Actual colour | White | White | White | White | White | White | … | White |

(n is the last dot number of the background CG. It depends on the background you set.)

The image with the sprite and background combined is as in the following table.

*[p. 53]*

**Sprite and background combined**

| Dot number | 0 | 1 | 2 | 3 | 4 | 5 | … | 255 |
|---|---|---|---|---|---|---|---|---|
| Palette number | 5 | 5 | 1 | 1 | 1 | 1 | … | 5 |
| Actual colour | White | White | Red | Red | Red | Red | … | White |

Now let's actually make a sprite with a program. We use the following program.

```
100 SCREEN 1                                  :'画面の初期化
110 PALETTE 10,1,RGB(31,0,0)                  :'BG10(スプライト面)のパレット1番に赤を設定
120 SPRITE$=STRING$( 16*16, CHR$(1))          :'スプライト定義
130 PUTSPRITE 1,(100,100),0                   :'スプライト表示
```

*[Comments: 画面の初期化 = initialise the screen; BG10(スプライト面)のパレット1番に赤を設定 = set red in palette 1 of BG10 (the sprite plane); スプライト定義 = define the sprite; スプライト表示 = display the sprite.]*

Line 100 initialises the screen in screen mode 1. Line 110 sets red in palette number 1 of logical BG10 (the sprite plane).

Line 120 defines as a sprite a 16×16-dot block filled entirely with palette number 1 (red). Defining a detailed pattern makes the listing long, so here only a single colour is used.

Line 130 displays the sprite defined in line 120 at X coordinate = 100, Y coordinate = 100.

**■ Moving a sprite**

Next we explain moving a sprite.

```
100 SCREEN 1                          → initialise the screen
110 PALETTE 10,1,RGB(31,0,0)          → set red in palette 1 of BG10 (the sprite plane)
120 SPRITE$=STRING$(16*16,CHR$(1))    → define the sprite
130 '
140 PALETTE 0,2,RGB(0,0,31)           → set the palette for the blue circle
150 PALETTE 0,3,RGB(0,31,0)           → set the palette for the green circle
160 CIRCLE(100,50),25,2,F             → draw the blue circle
170 CIRCLE( 200, 150), 25, 3, F       → draw the green circle
180 '
190 FOR I= 0 TO 300 STEP .01          → loop that moves the sprite
200     PUTSPRITE 1,(I,100),0         → move the sprite
210 NEXT I
```

*[In the book the arrows and their notes, here translated, are annotations beside the listing; they are not typed in.]*

Line 100 initialises the screen in screen mode 1. Line 110 sets the sprite's palette.

Line 120 defines the sprite. Line 130 is a comment line to make the listing easier to read; this line is not processed.

*[p. 54]*

Line 140 sets the palette for the blue circle, and line 150 sets the palette for the green circle. Line 160 actually draws the blue circle, and line 170 draws the green circle. Line 180, like line 130, is a comment line. Lines 190 to 210 move the sprite.

When you run it, a red square moves slowly between the blue and green circles.

#### Object-type sprites

The test program explained here handles object types 1 to 3, the sprites based on polygons.

Object type 1 can be scaled (enlarged and reduced) and rotated about the Z axis (rotation), so it repeatedly enlarges and shrinks a texture (a picture pattern), the basic shape, while swinging it left and right.

Object type 2 adds to object type 1 the ability to set the XY (horizontal and vertical) scaling independently. In the test program the basic shape repeatedly stretches and shrinks vertically and horizontally.

With object type 3 any 4 points can be given independently, so the 4 points are changed continuously with trigonometric functions to deform the basic shape.

Sample program:

```
100 SCREEN
110 '
120 PALETTE 10,1,RGB(31,31,31)     :'sprite color from DATA
                                     statement.
130 SETTEX 0,8,8,256,READ          :'texture pattern from DATA
                                     statement.
140 SETATR 0,1,(0, 1, 3, 0, 0, 0)
150 '
160 OBJ(1,@TYPE) = 1               :'Z ｶｲﾃﾝ sprite
170 OBJ(1,@ATR)  = 0
180 OBJ(1,@XP)   = -100,-50,300    :' X,Y position ｼﾃｲ
190 '
200 OBJ(2,@TYPE) = 2               :' HV ﾄﾞｸﾘﾂ scale ｼﾃｲ sprite
210 OBJ(2,@ATR)  = 0
220 OBJ(2,@XP)   = 100,30,200      :' X,Y position ｼﾃｲ
230 '
240 OBJ(3,@TYPE) = 3               :' 4 ﾃﾝ ｼﾃｲ sprite
250 OBJ(3,@ATR)  = 0
260 OBJ(3,@XP)   = -70,50,100      :' X,Y,Z position ｼﾃｲ (4ﾃﾝﾉ ｷｼﾞｭﾝ ｲﾁ)
270 '
280 *LOOP
290 OBJ(1,@ZR) = XSIN(N*3)/16      :'ｻﾕｳﾆ ｶﾀﾑｹﾙ
300 OBJ(1,@XS) = XSIN(N/4)*8       :'ﾕｯｸﾘﾄ ｽｹｰﾘﾝｸﾞ
310 '
```

*[p. 55]*

```
320 OBJ(2,@XS) = XSIN(N)*8         :'ｻﾕｳﾉ ﾊﾞｲﾘﾂｦ ｼﾃｲｽﾙ
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
510 DATA 0000000101000000
```

*[Comments in half-width katakana: Z ｶｲﾃﾝ = Z rotation; ｼﾃｲ = set; HV ﾄﾞｸﾘﾂ scale ｼﾃｲ = set independent H and V scale; 4 ﾃﾝ ｼﾃｲ = 4-point; (4ﾃﾝﾉ ｷｼﾞｭﾝ ｲﾁ) = (reference position of the 4 points); ｻﾕｳﾆ ｶﾀﾑｹﾙ = tilt left and right; ﾕｯｸﾘﾄ ｽｹｰﾘﾝｸﾞ = slow scaling; ｻﾕｳﾉ ﾊﾞｲﾘﾂｦ ｼﾃｲｽﾙ = set the left and right scale factors.]*

Line 120 sets white, RGB(31,31,31), in palette 1 of logical BG10 (the sprite screen). This is the only colour the program uses.

Line 130 defines the texture data set in lines 440 to 510 as texture number 0, and line 140 defines **attribute data** as attribute number 0. Attributes are properties of an object, such as its colour. For details of attributes, see the Reference Manual.

```
160 OBJ(1,@TYPE) = 1
170 OBJ(1,@ATR)  = 0
180 OBJ(1,@XP)   = -100,-50,300
```

Line 160 is the display setting for object type 1 (a 2D sprite with a scale and Z rotation). Line 170 sets the attribute, and line 180 decides the reference position for display.

```
200 OBJ(2,@TYPE) = 2
210 OBJ(2,@ATR)  = 0
220 OBJ(2,@XP)   = 100,30,200
```

Line 200 is the display setting for object type 2 (a 2D sprite with X and Y scales and Z rotation). Line 210 sets the attribute, and line 220 decides the reference position for display.

```
240 OBJ(3,@TYPE) = 3
250 OBJ(3,@ATR)  = 0
260 OBJ(3,@XP)   = -70,50,100
```

Line 240 is the display setting for object type 3 (a 2D sprite given by 4 points). Line 250 sets the

*[p. 56]*

attribute, and line 260 decides the reference position for display.

Line 280 is the start of the display loop.

```
290 OBJ(1,@ZR) = XSIN(N*3)/16
300 OBJ(1,@XS) = XSIN(N/4)*8
```

These change the parameters of object type 1. They vary the Z-rotation parameter to turn it left and right, and add a change of enlargement and reduction.

```
320 OBJ(2,@XS) = XSIN(N)*8
330 OBJ(2,@YS) = XCOS(N)*8
```

These change the parameters of object type 2. The X and Y scaling are varied independently.

```
350 P0_X = -16 + XSIN(N*1.2)*50 :P0_Y = -16 + XSIN(N)*10
360 P1_X = +16 + XCOS(N*1.2)*50 :P1_Y = -16 + XCOS(N)*10
370 P2_X = +16 + XSIN(N)*50     :P2_Y = +16 + XSIN(N)*10
380 P3_X = -16 + XCOS(N)*50     :P3_Y = +16 + XCOS(N)*10
390 OBJ(3,@XP0) = P0_X,P0_Y, P1_X,P1_Y, P2_X,P2_Y, P3_X,P3_Y
```

These change the parameters of object type 3. The positions of the 4 points set are each varied independently.

Line 410 advances the parameter that changes the various parameters.

Line 420 jumps back to the start of the display loop.

### Graphics techniques

#### Scrolling

Scroll means "a scroll" (a roll of paper). In BASIC it means the technique of making the text and shapes on the screen appear to flow up or down.

Ground and other backgrounds in games move smoothly because scrolling is used. Here we deal with scrolling the bitmap screen, as used for game backgrounds.

*[p. 57]*

*[Illustration: a long picture scroll being wound past a TV screen, with an arrow showing the direction of movement.]*

The principle of scrolling

Let's introduce a sample.

Scrolling the bitmap screen:

```
100 SCREEN 0
110 CIRCLE(160,112),25,RGB(0,31,0),F
120 SCROLL 0,STEP 0,1
130 GOTO 120
```

When you run it, the green circle starts moving upwards fast. As the circle disappears off the top of the screen, it appears again from the bottom. This is because the top and bottom of the screen are virtually joined.

The SCROLL command on line 120 is used as follows:

`SCROLL [<logical BG>],[STEP ][<X position>][,<Y position>]`

With STEP, the distance is relative to the current position. For logical BGs, see the Reference Manual.

#### Processing and transforming shapes

BASIC has functions for transforming the text and shapes that have been drawn.

There are two kinds of processing and transforming: doing it to the shape itself, and doing it only to the screen the shape is drawn on. Here we deal with the second. The first is explained in the next section.

**■ Enlarging**

Enlarges a character screen or bitmap screen by a fixed factor.

`ZOOM [<logical BG>],[<horizontal factor>][,<vertical factor>]`

Enlarging sample:

```
100 SCREEN 0
110 PRINT "ZOOM"
120 ZOOM 4,3,3
```

*[p. 58]*

When you run this, you get the following.

```
ZOOM
Ready.
█
```

The ZOOM command *[Screen: the text shown at three times its normal size.]*

To return the text to its original size, type the SCREEN command to initialise the screen.

The bitmap screen can also be enlarged by changing the logical BG number. For details, see the Reference Manual.

**■ Rotating**

BASIC has a function for rotating the screen. Think of the principle of rotation like this.

*[Diagram: a rectangle with its pivot (支点) at the top left corner, where a horizontal and a vertical axis cross. Turning it about the horizontal axis makes it look like a trapezium narrower at the bottom; turning it about the vertical axis makes it look like a trapezium narrower on the right.]*

The principle of rotation

*[p. 59]*

A point on the screen is taken as the pivot, and the whole screen is rotated about it. Rotation uses a combination of dedicated commands.

`ROTCENTER <X coordinate>,<Y coordinate>,<Z coordinate>`

This command sets the centre position of the rotation screen. The ROTCENTER command takes each coordinate as a parameter. The Z coordinate is explained later.

`ROTPOS [<X distance>][,<Y distance>][,<Z distance>]`

Sets the distance from the position you are looking from (the camera position) to the point given with the ROTCENTER command. The Z distance is explained later. For the camera position, see the Reference Manual.

`ROTATE [<X-axis rotation angle>][,<Y-axis rotation angle>][,<Z-axis rotation angle>]`

The command that gives the display angle of the rotation screen. The angle is written in a unit called **radians**. 90 degrees clockwise is 0.25, and 180 degrees is 0.5 *[sic: these values are fractions of a full turn, not radians]*. You can give the rotation angle in each direction about the position given with the ROTCENTER command. The Z axis is explained later.

Let's look at a sample.

A program that turns a green circle clockwise:

```
100 SCREEN 3
110 PALETTE 2,100,RGB(0,31,0)
120 CIRCLE(50,50),25,100,F
130 ROTCENTER 160,112,0
140 ROTPOS 0,0,0
150 '
160 I=1
170 ROTATE ,0,I
180 I=I-.0001
190 IF I<0 THEN I=1
200 GOTO 170
```

Line 100 initialises the screen. Line 110 sets green in palette number 100, line 120 draws a circle on the bitmap screen, and the ROTCENTER command on line 130 makes the centre of the screen the centre point of the rotation.

The ROTPOS command on line 140 can give the distance from the viewpoint to the centre of rotation, but this time there is no movement in depth, so it is not set. Line 160 is the initial parameter for the rotation, and line 170 actually rotates. Line 180 calculates the rotation parameter. Line 190 is a command that puts the rotation parameter back to its original value when it goes past the limit (the limit of the radians).

By jumping to line 160 *[sic: the listing jumps to line 170]* on line 200, the program forms a loop.

*[p. 60]*

**■ Mosaic**

BASIC has a slightly unusual processing command: the mosaic command. Leaving the details to the Reference Manual, let's run a sample and see the effect.

A mosaic program:

```
100 SCREEN 0:CLS
110 PRINT "HELLO, WORLD !"
120 PRINT "HELLO, FRIENDS !"
130 MOSAIC ON
140 MOSAIC (4,4)
```

*[Screen: the text at the top left broken into large blocks and unreadable.]*

Mosaic

A mosaic is applied to the character screen, and the program listing becomes unreadable. To cancel the mosaic, press [F12].

### Summary

Here we have explained the BASIC commands for drawing pictures on a flat plane. The screen layout and sprites are basic ideas for making games in BASIC. Next we explain making CG that handles solid objects.

## 2.6 Real-time computer graphics and polygons

*[p. 61]*

One of the most distinctive features of the SEGA SATURN is **real-time computer graphics**. In computer graphics (CG from here on) that handle these three dimensions, the idea of depth (the Z axis) is added to the horizontal (X axis) and vertical (Y axis) of the graphics explained so far.

### About computer graphics (CG)

Here we explain the basics of 3D CG. In a game that uses 3D CG, the screen gains depth, and space seems to spread out beyond the screen.

#### The idea of CG

The CG familiar from television commercials and films can be said to be things we see every day without thinking, such as building blocks on the floor, books and pencils, created virtually on a computer together with the space around them. By changing the camera (viewpoint), the way the virtually created objects look also changes, and you can see the view from another angle without actually moving. This idea is called **simulation**, and the closer you bring things such as how the light falls to reality, the more realistic the CG you can make.

#### Coordinate systems

We said that there seems to be another space beyond the CG screen. This is not just an illusion: when CG is actually drawn, it is thought of as if that space really exists. For the computer to place an object in space, the position of the object must be given. We explained before that a computer's screen display is divided up like graph paper, and the space of CG likewise has coordinates divided up in the same way. These are called **world coordinates**.

*[p. 62]*

*[Diagram: three axes crossing at a point, with the screen plane to the left. The X axis (X軸) runs from − on the left to + on the right, the Y axis (Y軸) from − at the top to + at the bottom, and the Z axis (Z軸) from − in front to + going away into the distance.]*

World coordinates

In BASIC, as in the figure, the values get larger as you move from left to right for the X coordinate, from top to bottom for the Y coordinate, and from front to back for the Z coordinate. All the objects, lights, cameras and so on are placed in this space. In BASIC, objects are placed in the space by giving the values of these coordinates.

#### Polygons

A **polygon** is a many-sided shape with several vertices. Objects are made by combining these polygons. However, the polygons of CG are made with dedicated commands, which work differently from the way the shapes handled so far are drawn. A program that uses these commands is introduced later, so refer to it.

#### Objects

Anything that exists in the space, whether it is displayed or not, is called an **object**. The building blocks and pencils placed in the virtual space are of course objects, but so is the light source that lights them. Objects can also be thought of in finer detail.

For example, imagine a lamp with three joints in its arm. If you divide this lamp at each joint, each part can be thought of as an object, but you can also look at the whole arm together as one object. This difference becomes very important when displaying moving objects.

*[p. 63]*

*[Illustration: a desk lamp clamped to the edge of a table. Its parts are labelled: lamp head (照明), lower arm (下腕部), upper arm (上腕部) and base (土台).]*

An example of an object

Objects can form parent and child relationships. If you move the upper arm of the lamp in the figure, the parts above it are carried along and move too. If the upper arm is the **parent object**, all the parts beyond it can be thought of as **child objects**.

#### Modelling

**Modelling** is the work of making objects and placing them in the space. Because modelling builds objects up from parts, it takes time and effort when the object being made is complicated. So programs that assist modelling are used to cut down or take over the time and effort of the processing. There are many commercial tools for this.

BASIC has no modelling function, so we explain using the sample programs.

#### Rendering

CG is a virtual space. When modelling is finished, the material of the objects arranged in the space, and the strength and colour of the lights that light them, are set afterwards to finish them off. This finishing work is called **rendering**.

BASIC does real-time CG, so there is no special need to think about "finishing afterwards".

*[p. 64]*

#### Lights

A light is, just as it sounds, lighting that lights up objects and the space. But unlike real ones, a light in CG does not show the light source itself, such as a bulb. So it needs no support or power supply, there are no physical limits on where it can be placed, and its colour and the direction of its light can be set freely.

#### Textures

A texture is the process of pasting a picture onto the surface of an object. It is part of rendering, and textures can give an object a feeling of material.

#### Animation

Animation is the work of deciding how the placed objects move and are staged. It changes the world coordinate values continuously, or changes the object itself by changing its parameters.

### Making CG

Before making CG, decide roughly what to place where in the space. Once your ideas are settled, make the objects. Once the placement is decided, decide the strength of the light and the position of the viewpoint.

Now let's actually use a short listing to explain an example of how to make CG and how the program works.

#### Deciding the shape to display

The aim is to display a plain square so that it comes roughly in the centre of the screen. As a figure, it looks like this:

*[Illustration: a TV screen with a square in the middle.]*

Placing the object

#### Making a polygon

Polygons are the basis for making solid objects. Complicated vehicles and game characters that move about can also be expressed with polygons. Using a short program that "rotates a red board in the centre of the screen", we explain the commands for making polygons.

*[p. 65]*

A program that rotates a red polygon board:

```
100 'Polygon Test Program (KSIN)
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
400 DATA -32,  32, 0
```

**■ Steps up to display**

Lines 100, 190, 260, 310 and 360 are comment lines, left empty only to make the listing easier to read. The single quotation mark (') is the short form of the REM command, a command for ignoring processing. When it is present, BASIC does not interpret the characters after the (') on that line.

- **Make the object not displayed**

  Line 110 initialises the screen in screen mode 1 *[sic: the listing uses SCREEN 0]*.

  Lines 120 to 180 initialise variables to make the program easier to understand.

*[p. 66]*

- **Make the texture data**

  Line 200 sets the colour to be set in the texture.

  As a result of line 210, the value put in TEX_COL becomes &H801F. Here a calculation called OR is done. This is needed when making texture data; if it is not done, the colour is not displayed correctly. For details, see the Reference Manual.

  Line 240 converts the texture data into a binary string. Texture data can only be set up from a binary string.

  The SETTEX command on line 250 *[sic: SETTEX is on line 270; line 250 builds TEX$]* makes the data for the texture pasted onto the polygon.

  This completes making the red texture data.

- **Define the texture of the face with the SETTEX command**

  Line 270 defines the texture data made a moment ago.

- **Make the vertices with the SETVERTEX command**

  Line 280 sets the coordinates of the vertices. We are making a four-sided polygon, so the second parameter is 4. The actual values are read from the data on lines 370 to 400 with the READ command.

  Each point is set clockwise: "line 370 is the top left point", "line 380 is the top right point", "line 390 is the bottom right point" and "line 400 is the bottom left point".

- **Gather the vertices made with SETVERTEX into a face with the SETPOLYGON command**

  Line 290 decides how the vertices are joined to make the polygon. Since the coordinates were set in line 280, they are set clockwise in the same order here too (when the coordinates are decided clockwise, the polygon is set to be facing front).

- **Make the attributes of the face with the SETATR command**

  Line 300 sets the attributes of the polygon's face (whether it has a texture, and so on).

- **Decide the type of the OBJ**

  Line 320 makes a provisional polygon object. The values needed for display are also set by default, so a suitable rectangle is displayed even without making a polygon object specially. Here, think of it as just making the box called an object that holds the polygon's information.

- **Give the OBJ the face and attributes made with the SETPOLYGON and SETATR commands**

  Line 330 sets the vertices and the attributes of the face on the object made a moment ago. With this, a polygon with 4 vertices and a texture has been set up.

- **Give the OBJ the coordinates to display it at**

  Line 340 moves the polygon board to the centre of the screen. The coordinates (0,0) are the centre of the screen because the polygon coordinate system has (0,0) at its centre.

- **Rotate the OBJ**

  Line 350 rotates the polygon object that was made.

*[p. 67]*

### CG programs seen through the samples

#### Displaying polygon fonts

**■ Polygon font: P_PFONT.B**

A sample program that uses BASIC's PFONT command.

*[Screen: "Alphabet Soup2... (motos)" and "Ready." at the top left; solid, coloured 3D letters arranged in a ring and seen at an angle.]*

P_PFONT.B

```
1000 SCREEN 0
1010 '-----------------------------------
1020 'Object Item Number
1030 TYPE = 0: FLAG = 1
1040 XP = 4: YP = 5: XR = 8: YR = 9: ZR = 10: XS = 12
1050 ATR = 16: POLYGON = 17: ORDER = 18
1060 PARENT = 20: CHILD = 21
1070 XV = 24: XA = 28: XL = 32: XRV= 36
1080 '-----------------------------------
1090 PRINT "Alphabet Soup2... (motos)"
1100 'SETLIGHT 0.7,0.01,0.1,RGB(10,0,30),RGB(3,3,3)
1110 SETLIGHT 1,0,0
1120 SETDISP 3
1130 PRIORITY 10,1: OBJ(100,TYPE)=6
1140 OBJ(100,XRV)=-.001,.0001,&H0.002
1150 OBJ(100,XR)=-.17,.1
1160 OBJ(100,XP)=-20,-70,110
1170 '
```

*[p. 68]*

```
1180 FOR I=ASC("A") TO ASC("Z")
1190  N=I-ASC("A")
1200  OBJ(N+1,PARENT)=100: OBJ(N+1,TYPE)=4
1210  OBJ(N+1,XRV)=.0008,.003
1220  OBJ(N+1,XP)=XSIN(N/26)*250,XCOS(N/26)*250
1230  SETPFONT N+1,I,,RGB(RND(32),RND(32),RND(32))
1240 NEXT
1250 '
```

This rotates polygon fonts made solid.

Line 1000 initialises the screen in screen mode 0. Lines 1030 to 1070 initialise variables.

Line 1090 simply displays a message. Lines 1100 and 1110 both contain a SETLIGHT command, but line 1100 has a (') in it, so it is ignored. Line 1110 uses the SETLIGHT command to set up the light source. This sets the direction (vector) the light comes from. In line 1110 it is (1,0,0), so the direction of the light is from (0,0,0) towards (1,0,0); in other words, it is set so that "the light falls from the left".

Line 1120 makes a setting called the "display level". For details of this line, see the SETDISP command in the Reference Manual.

Line 1130 first lowers the priority of BG number 10 (the polygon plane) with the PRIORITY command. The OBJ command after it makes a transparent object that is the parent for rotating the letters.

Line 1140 makes the transparent object made in line 1130 rotate automatically.

Line 1150 tilts the transparent object to the right.

Line 1160 moves the transparent object to the upper left and back.

Lines 1180 to 1240 attach each letter in a circle to the transparent object made a moment ago (with the transparent object as the parent).

In this way, the letters, which are children of the transparent object, turn together with the transparent object.

*[p. 69]*

**■ Polygon clock: P_CLOCK.B**

The digital clock made earlier, made solid with polygon fonts.

*[Screen: "TUE 15 21 48" in large solid polygon characters.]*

P_CLOCK.B

```
1000 '-----------------------------------
1010 'Object Item Number
1020 TYPE = 0: FLAG = 1
1030 XP = 4: YP = 5: XR = 8: XS = 12
1040 ATR = 16: POLYGON = 17: ORDER = 18
1050 PARENT = 20: CHILD = 21
1060 XV = 24: XA = 28: XL = 32: XRV= 36
1070 '-----------------------------------
1080 SCREEN 0
1090 GOSUB *SETFONT
1100 *LOOP
1120   TIME$=RIGHT$(DATE$,12)
1130   FOR LN=1 TO LEN(TIME$)
1140     CH$=MID$(TIME$,LN,1): CH=ASC(CH$)
1150      IF CH$ >= "A" AND CH$ <= "Z" THEN CH2=CH-ASC("A")+10: GOTO *PUT
1160     IF CH$ >= "0" AND CH$ <= "9" THEN CH2=CH-ASC("0"): GOTO *PUT
1170     GOTO *NOCHR
1180 *PUT
1190     OBJ(LN,ATR)=CH2,CH2
1200     OBJ(LN,TYPE)=4:OBJ(LN,PARENT)=0
```

*[p. 70]*

```
1210     OBJ(LN,XP)=(LN-1-LEN(TIME$)/2)*20
1220 *NOCHR
1230   NEXT LN
1240   GOTO *LOOP
1250 '
1260 *SETFONT
1270   FOR I=0 TO 9
1280     SETPFONT,ASC("0")+I,(.3,1,1)
1290   NEXT I
1300   FOR I=0 TO 25
1310     SETPFONT,ASC("A")+I,(.3,1,1)
1320   NEXT I
1330   RETURN
```

Lines 1010 to 1060 initialise variables. Line 1080 initialises the screen. The GOSUB on line 1090 jumps to the subroutine from line 1260 to line 1330, labelled *SETFONT, to make the characters solid.

Lines 1100 to 1170 calculate the time and prepare the string to display. Lines 1180 to 1210 display the time string in solid characters.

Polygon fonts and the general commands make a program you can apply in many situations.

#### Textures

**■ Texture test: P_FLOWER.B**

A program that moves textured polygons to make the space look three-dimensional.

*[Screen: a ring of polygons, each textured with a picture of a white flower, with "Ready." at the top left.]*

P_FLOWER.B

*[p. 71]*

When you run it, polygons textured with a picture of a flower rotate. The same polygon is also placed in the centre. The ring of flowers turns at a constant speed. The flowers get bigger as they come to the front, and smaller in the distance.

#### The camera

**■ Camera test: P_CAME2.B**

A program in which the view changes as the camera moves. It shows pictures as if you were floating through the air. Where this program differs from the others explained so far is that it is not the objects that move, but the viewpoint.

*[Screen: "Camera with BG (motos)" at the top; a ground plane covered in a repeated pattern of letters stretching into the distance, with a few cubes floating above it.]*

P_CAME2.B

```
1000 '円運動のカメラテストwith BG (motos)
1010 SCREEN 5,4,256
1020 PRINT "Camera with BG (motos)"
1030 '-----------------------------------
1040 'Object Item Number
1050 TYPE = 0: FLAG = 1
1060 XP = 4: YP = 5: ZP = 6:XR = 8: YR = 9: ZR = 10: XS = 12
1070 ATR = 16: POLYGON = 17: ORDER = 18
1080 PARENT = 20: CHILD = 21
1090 XV = 24: XA = 28: XL = 32: XRV= 36
1100 '-----------------------------------
1110 ROTZOOM 2,2:  'Ground size
1120 VIEW_HEIGHT=300
1130 RBG_PRIORITY=4
```

*[Comment on line 1000: 円運動のカメラテスト = camera test with circular motion.]*

*[p. 72]*

```
1140 PRIORITY 8,RBG_PRIORITY
1150 A$=READCHR$(4,0,256)
1160 SETCHR 8,0,A$
1170 PALETTE 8,1,RGB(10,10,10)
1180 PALETTE 8,15,RGB(0,30,30)
1190 FOR I=1 TO 5000
1200   PUTCHR 8,(RND(128),RND(128)),ASC("A")*2
1210 NEXT I
1220 CCOPY 8,(0,0)-(127,127) TO 8,(0,128)
1230 CCOPY 8,(0,0)-(127,127) TO 8,(128,0)
1240 CCOPY 8,(0,0)-(127,127) TO 8,(128,128)
1250 '
1260 CUBE_CENTER=-12
1270 SETLIGHT -1,1,0
1280 OBJ(1,TYPE)=4
1290 OBJ(1,XP)=0,CUBE_CENTER,0
1300 OBJ(2,TYPE)=4
1310 OBJ(2,XP)=0,-100,0
1320 OBJ(3,TYPE)=4
1330 OBJ(3,XP)=-40,CUBE_CENTER,0
1340 OBJ(4,TYPE)=4
1350 OBJ(4,XP)=40,CUBE_CENTER,0
1360 OBJ(5,TYPE)=4
1370 OBJ(5,XP)=30,CUBE_CENTER,50
1380 N=0
1390 CX=80:CZ=0:CZV=-&H0.001
1400 TARGET=3
1410 SETDISP 3
1420 *LOOP:VSYNC
1430 OBJ(3,XP)=XCOS(N*4)*380
1440 OBJ(3,ZP)=XSIN(N*5)*280
1450 OBJ(3,XR+1)=.5-N
1460 N=FRAC(N+&H0.002)
1470 GOSUB *LOOK
1480 GOTO *LOOP
1490 *LOOK
1500 HIGHT=XSIN(CZ)*VIEW_HEIGHT-VIEW_HEIGHT/2
1510 IF HIGHT > 0 THEN PRIORITY 10,RBG_PRIORITY-1 ELSE PRIORITY 10,RBG_PRIORITY
1520 CAMERA (XCOS(CZ*2)*500,HIGHT,XSIN(CZ*9)*320),-.04 TO TARGET,BG
1530 CZ=FRAC(CZ+CZV)
1540 IF 0 AND (CN > 10000) THEN CN=0
1550 RETURN
```

*[p. 73]*

Line 1010 initialises the screen in screen mode 5. Lines 1050 to 1090 initialise variables. Line 1110 sets the horizontal and vertical ratio of the rotating screen to twice the standard, so the objects displayed look large. Lines 1120 and 1130 set variables. Line 1140 sets in advance the ordering of the display screens.

Lines 1150 and 1160 use the hardware inside the SEGA SATURN that holds the character patterns (the arrangement of dots), called the **pattern generator**. Lines 1170 and 1180 set the palette.

Lines 1190 to 1210 fill the screen that becomes the ground with the letter "A". Lines 1220 to 1240 copy it around the edges, in the invisible part outside the screen, to make the ground area drawn look larger.

Lines 1260 to 1410 are the various settings for the cubes displayed. Lines 1420 to 1480 set the movement of the objects. Line 1470 jumps to the display subroutine labelled *LOOK, from line 1500. Inside it, the movement and direction of the camera are decided.

#### Modelling

**■ DXF conversion tool (Dxfconv.exe)**

This tool uses a Windows PC to read 3D data made with commercial modelling tools, and converts it to a file with the extension .B, the same as BASIC programs. It handles the standard format for 3D data with the extension .DXF (AutoCAD Data eXchange Format).

The tool is made up of several files, but using Dxfconv.exe does all the processing in one go.

**■ Installation**

Put the Tools CD for Windows into the PC's CD-ROM drive. Before installing, close all programs. If applications are running, installation may not succeed. Also check the free space on the hard disk you are installing to.

**If AutoRun (CD automatic start) is set**

Insert the CD in the CD-ROM drive. The installer starts automatically.

**If AutoRun (CD automatic start) is not set**

First choose [Run...] (ファイル名を指定して実行) from the [Start menu] and give Instbc10.exe on the CD-ROM drive. You are asked whether to start the installer; click [Yes (Y)] and the setup program starts. Click [No (N)] to finish without installing.

*[p. 74]*

*[Screen: an "InstallShield 自動抽出 Exe" (self-extracting exe) dialog: "これは、DXFCONV をインストールします。続行しますか？" (This will install DXFCONV. Continue?), with [はい(Y)] (Yes) and [いいえ(N)] (No) buttons.]*

The installer start screen

When the installer starts, the DXF conversion tool installation screen fills the screen, and a dialog box with the installation steps opens in the middle. Follow the explanations to proceed.

*[Screen: the full-screen "DXFCONVのインストール" (DXFCONV installation) setup with a "ようこそ" (Welcome) dialog: welcome to the DXFCONV setup program; close all Windows programs before running setup; click [キャンセル] (Cancel) to quit setup and close running programs, or [次へ] (Next) to continue; a copyright warning. Buttons: [戻る] (Back), [次へ(N)>] (Next), [キャンセル] (Cancel).]*

The selection screen

When you have finished the step explanations and chosen where to install, the DXF conversion tool is automatically installed in the directory you chose.

*[p. 75]*

*[Screen: the DXFCONV installation with a "セットアップ" (Setup) progress dialog: "プログラム ファイルをコピー中…" (Copying program files…) dxfconv.exe, 39 %, and a [キャンセル] (Cancel) button.]*

The installing screen

When the software has been installed in the directory, a dialog asks whether to read the README file. Normally press [Yes (Y)]. README.TXT then opens in Notepad, the program that comes with Windows 95.

*[Screen: README.TXT open in Notepad. It reads, in Japanese: "Data converter from DXF files to GAME BASIC for SEGA SATURN – Win95 version. [Overview] DXFCONV.exe: a tool that extracts the "3Dface" information from a DXF file and makes a text file in GAME BASIC for SEGA SATURN format; it can also optionally add the standard display program at the start. [Installation] Copy the 4 files DXF2POL.EXE, POL2BAS.EXE, POL2BAS2.EXE and HEADBAS.B into the same directory as DXFCONV.EXE. [How to run] Double-click the DXFCONV.EXE icon. Give the source file name. Give the destination file name; if you don't, the output takes the source file name with the extension changed to ".B". Click "Convert" to start the conversion. When the "File converted" dialog appears, the conversion is finished. Click "Exit" to close DXFCONV.EXE. If the "Add display program" check box is selected, the standard display program "HEADBAS.B" is added at the start, and the result can be sent straight to GAME BASIC for SEGA SATURN and run. The added program can be rewritten by the user (the file name is fixed)."]*

The README.TXT screen

*[p. 76]*

When all the work is finished, a dialog saying setup is complete is displayed. README.TXT is displayed behind the setup screen.

**■ Uninstallation**

To remove the DXF conversion tool from Windows 95, choose [Control Panel] under [Settings] from the [Start] button.

When the [Control Panel] window opens, choose [Add/Remove Programs] in it, then select DXFCONV from the list and click it. Then follow the instructions to remove the DXF conversion tool.

**■ How to run it**

Double-click the Dxfconv.exe icon.

*[Screen: the DXFCONV window. Fields and controls: 変換元ファイル名(DXF) (source file name (DXF)) with a [参照] (Browse) button; a check box 変換先ファイル名を指定する (specify the destination file name) with its own field and [参照] (Browse) button; the note 指定しない場合は変換元ファイル名の拡張子をBにしてセーブします (if not specified, it is saved with the source file name's extension changed to B); buttons [変換実行] (Convert), [変換実行(グループ情報対応)] (Convert (with group information), greyed out) and [終了] (Exit); a check box 表示プログラムを付加する (add display program), ticked; and a コンソール (console) area.]*

The DXF conversion tool

**■ How to convert**

When you start Dxfconv.exe, the application window is displayed. Type the file name in [Source file name (DXF)]. Click the [Browse] button to choose a file from any storage device on the PC.

*[p. 77]*

*[Screen: the DXFCONV window with a "ファイルを開く" (Open file) dialog in front: ファイルの場所 (Look in) dxf_conv, ファイル名 (File name), ファイルの種類 (Files of type) DXFファイル(*.dxf), and the buttons [開く(O)] (Open) and [キャンセル] (Cancel).]*

The Browse button

The source and destination file names differ only in their extension.

If you want to change the destination file name, tick [Specify the destination file name]. A file name can then be typed below the check box. The [Browse] button can be used here too, but in this case the file name you browse to is overwritten.

*[Screen: the DXFCONV window with 変換先ファイル名を指定する (specify the destination file name) ticked and its field enabled.]*

Changing the file name

*[p. 78]*

When you have checked the file names, press the [Convert] button or the [Convert (with group information)] button. For what the buttons do, see the Reference Manual.

If [Add display program] is ticked, a short program for displaying the data in BASIC is added at the start of the converted data.

During conversion its progress is shown in the [Console], and the [Conversion finished dialog] appears to tell you the conversion is over.

*[Screen: the DXFCONV window with C:¥Program Files¥dxf_conv¥test.dxf as the source file and a "DXFCONV" message box: "ファイルが変換されました" (The file has been converted) [OK]. The console shows: "DXFファイルから 3Dface 情報を…" (… the 3Dface information from the DXF file), "3Dface 情報をGAME BASIC for SEGASATURNのデータに変換します" (Converting the 3Dface information to GAME BASIC for SEGA SATURN data), "VTXファイルとPNTファイルをマージします" (Merging the VTX file and the PNT file).]*

The conversion finished dialog

Click the [Exit] button to close the program.

### Summary

Here we have explained CG with the emphasis on real-time CG, which is closely involved in making games. This is the end of the Tutorial Manual's explanation of graphics; for making more complicated and effective CG, refer to the Reference Manual. Next we explain sound, the other big element of games.

## 2.7 Making music with BASIC

*[p. 79]*

### Music basics

Before explaining the commands for making music, we explain a few music basics.

#### Sound and the score

Sound can be classified in many ways, but here we think of a sound as "high", "low", "long", "short", "strong" or "weak".

These expressed with symbols and so on make a "score".

#### High and low sounds

**■ Note names**

The scale do, re, mi, fa, so, la, ti… is formally called the **note names**. In BASIC, the note names correspond as follows.

**Note name table**

| Note name | ド (do) | レ (re) | ミ (mi) | ファ (fa) | ソ (so) | ラ (la) | シ (ti) |
|---|---|---|---|---|---|---|---|
| BASIC | C | D | E | F | G | A | B |

**■ Whole tones and semitones**

The pitch of sounds has **whole tones** and **semitones**. Normally, between one note name and the next the sound rises by a fixed step of frequency, but if the step between do and re is 1, then only between mi and fa and between ti and do does it rise by just 0.5. You can see this if you look at a piano keyboard.

*[p. 80]*

*[Illustration: a piano keyboard with the white keys labelled ラ シ ド レ ミ ファ ソ ラ シ ド レ ミ ファ (A B C D E F G A B C D E F). The pairs シ–ド (B–C) and ミ–ファ (E–F), which have no black key between them, are marked 半 (semitone).]*

**■ Sharp**

To raise the pitch of a note by a semitone just for the moment, put a # (sharp) sign to the left of the note. This sign is valid only in that bar.

*[Illustration: a treble staff with a sharpened F, labelled ファ# (F♯).]*

**■ Flat**

To lower the pitch of a note by a semitone just for the moment, put a ♭ (flat) sign to the left of the note. This sign is valid only in that bar.

*[Illustration: a treble staff with a flattened B, labelled シ♭ (B♭).]*

**■ Natural**

Used in a bar where a sharp or flat is in effect, when you want to cancel the sharp or flat for a note.

#### Length of sounds

The length of a sound is expressed with **notes**. The kinds of note are as follows. Going down the table, each length is half the one before.

*[p. 81]*

**Kinds of note**

| |
|---|
| Whole note |
| Half note |
| Quarter note |
| Eighth note |
| Sixteenth note |
| Thirty-second note |

When a note has a dot, its length becomes 1.5 times the length without the dot. This is called a **dotted note**. The dotted notes are as follows.

**Kinds of dotted note**

| |
|---|
| Dotted half note |
| Dotted quarter note |
| Dotted eighth note |

**■ Resting (making no sound)**

A **note** was a symbol giving the length of time a sound is made. A **rest** is a symbol giving the length of time no sound is made.

**Kinds of rest**

| |
|---|
| Whole rest |
| Half rest |
| Quarter rest |
| Eighth rest |
| Sixteenth rest |
| Thirty-second rest |

**Dotted rests** also follow the same rule as dotted notes.

*[p. 82]*

#### Strong and weak sounds

**■ Bars**

A score is divided, according to the time signature, by vertical lines called **bar lines**. Each section divided off by the vertical lines is a bar. The notes placed in a bar are basically played with the first beat strong.

*[Illustration: a treble staff divided by a vertical bar line (縦線) into two bars (小節).]*

With all that in mind, we now go into the actual explanation of BASIC's sound.

### Enjoying music with BASIC

#### Sound sources

Sound is a vibration that travels through the air. This vibration is expressed as something called a **waveform**. **Electronic instruments** create waveforms artificially, and simulate (imitate) sounds close to musical instruments and the like.

The sounds of BASIC are also made by creating waveforms artificially, and there are several ways of doing this. BASIC makes sounds with the following methods.

**■ FM sound source**

**FM** stands for **Frequency Modulator**. It produces a single simple waveform, but by combining waveforms it can create complex waveforms.

*[Diagram: two simple waves, one of them faster, combined into one complex waveform.]*

The FM sound source method (making sound by combining waveforms)

*[p. 83]*

**■ PCM sound source**

Whereas the FM sound source makes sound by imitating the original waveform, a **PCM sound source** takes the minimum characteristics needed to reproduce a sound from a recording and turns them into data. Because it is based on recorded data, it gives a sound close to the real thing, but the data is large.

#### Ways of expressing a score

BASIC processes a dedicated language internally to reproduce scores.

**■ MML**

MML means **Music Macro Language**. In MML you can write in almost the same way as the score notation studied in the music basics.

**■ MIDI**

**MIDI** (ミディ) is short for **Musical Instrument Digital Interface**. Equipment that supports the MIDI standard can have its playing controlled by a computer. MIDI is an international standard, but the extensions to its functions differ between makers, so to unify them a standard called **General MIDI** (ジェネラルミディ), or **GM** (ジーエム), was set up. BASIC matches its note numbers and way of sounding to MIDI.

#### Trying MML

Among the samples there is a program called the MML Tutorial. While running it, let's practise the basics of making music. Load S_TUTOR.B from BASIC.

*[Screen: the S_TUTOR.B menu, in Japanese: サウンド機能のサンプル・プログラム (Sound function sample program). 1: 用語説明 (Explanation of terms), 2: サウンド・システムのスペック (Sound system specifications), 3: 音色データについて (About voice data), 4: MMLとサウンド命令の使い方 (How to use MML and the sound commands), 5: サウンド・サンプルを聞いてみよう！ (Listen to the sound samples!), 0: 終了 (Quit). 【重要】 (Important) ・サターン本体の音声出力設定がモノラルの場合、パン関連のコマンドは無効です。 (If the SEGA SATURN's audio output setting is mono, the pan commands have no effect.) 番号を選択して下さい。 (Choose a number.)]*

Running S_TUTOR.B

*[p. 84]*

Choose "4: How to use MML and the sound commands", then choose "2: MML Tutorial".

*[Screen: the MMLチュートリアル (MML Tutorial) menu: 1: 音を鳴らしてみよう！ (Make a sound!), 2: 楽譜通りに打ち込んでみよう！ (Type in a score as written!), 3: 音色を組み替えてみよう！ (Rearrange the voices!), 4: 音色を加工してみよう！ (Process a voice!), 5: DSPエフェクターを使ってみよう！ (Use the DSP effector!), 6: FM音源で音を作ろう！ (Make sounds with the FM sound source!), 7: 様々な表現をするためのテクニック (Techniques for various kinds of expression). ★Space, Enter, 0 以外を押してから、もう一度Spaceを押すと、リプレイできます。 (★ Press any key other than Space, Enter or 0, then Space again, to replay.) 番号を選択して下さい。 戻る→Enter (Choose a number. Back → Enter)]*

The MML Tutorial

#### Make a sound!

To make a sound, use the following command.

**■ Making a sound**

`EFFECT"note names"`

The EFFECT command plays **note names**. Let's run the following program.

```
EFFECT "CDEFGAB"
```

"Do, re, mi, fa, so, la, ti" came out of the speaker. The EFFECT command turned the note names in its parameter into sound and played them. The kind of sound played here is the default **voice** called the **BEEP sound**. Think of a voice as **the kind of sound source**. There are several voices, and you change them by giving a number. The voice is chosen with the @ command.

The BEEP sound is @0 (zero). Unless a **voice set** has been loaded in advance, the same number gives a different sound. When the STANDARD set is loaded, @44 changes the voice to one called Strings. Let's run it.

```
EFFECT "@44 CDEFGAB"
```

A voice can be inserted in the middle of the note-name parameter, and it changes from the next note name.

*[p. 85]*

```
EFFECT "@35 CDEF @36 GAB"
```

35 is the voice Synth Bass and 36 is A.Piano.

**■ Changing the octave**

In a scale, the notes from the base do up to ti are called **one octave**. When making a melody you sometimes want to use notes from a different octave. For that, use "O (the letter O) value". The value is the parameter that decides the octave.

You can also change the octave with ">" to go up one, and "<" to go down one.

Playing the following two lines with the EFFECT command gives the same result.

`@35 O2 C O3 C O4 C O5 C O4 C O3 C O2 C`

`@35 O2 C > C > C > C < C < C < C`

**■ The rest command**

Use "R" for a rest.

`@35 CD R EF R GA R B`

**■ Sharps and flats**

Just as signs are added to notes to change their pitch and so on, the same kinds of sign can be used in MML. A sharp, which raises by a semitone, is "#" or "+"; a flat, which lowers by a semitone, is "-"; and a natural is "n".

`@35 C C# D D# E E- D D- C`

**■ Giving the length of a note**

The length of a note is given as a number. The lengths you can give are:

1, 2, 3, 4, 6, 8, 12, 16, 24, 32, 48, 64, 96, 128

These mean **into how many equal parts the whole note is divided**, taking the length of a whole note as "1".

`@35 C1 R C2 R C3 R C4 R C6 R C8 R C12 R C24 R C32 R C48 R C64 R C128`

In addition, to express dotted notes and rests, up to three dots "." can be added after the number.

`@35 C4 R4 C4. R4.C4.. R4.. C4...`

**■ Chords**

On a piano, this means sounding several keys at the same time.

`@44 C E G (CEG)`

**Enclose in brackets** the note names you want to sound at the same time.

*[p. 86]*

**■ Setting sound per track**

BASIC handles 16 tracks by allocating them dynamically to the 32 channels of the SEGA SATURN's sound source. A volume can be given for each track.

"v" changes the volume as a relative ratio in 16 steps from 0 to 15. "@v" has 128 steps from 0 to 127, and its degree of change is in **dB (decibels)**, the unit of sound. "v" and "@v" affect each other.

`@44 V15 C V10 C V5 C @127 C @V90 C`

### Summary

Here we have explained how to make sounds with BASIC, based on the basics of music.

If you refer to the Reference Manual and work out more effective sounds, you can liven up your game even more than with pictures.

## 2.8 Making an original game

*[p. 87]*

Here we explain making an original game with BASIC. While looking at sample programs, we look at the process up to the finished game, and at the key points in making a game.

### Sample program: Flag raising (G_HATA.B)

#### Outline of the game

In this game you raise and lower a red flag and a white flag following the computer's instructions, and compete on accuracy.

*[はたあげ (hata-age, "flag raising") is a Japanese party game in which players must raise or lower red and white flags as a caller instructs.]*

#### Notes on use

- **Connect control pads to the SEGA SATURN.**

The game supports the control pad. It does not support the SEGA SATURN keyboard or other devices.

**■ Controls**

- Choose 1 player or 2 players with left and right on the direction button, and start the game with the Start button.
- The L button raises the red flag and the R button raises the white flag.
- The flag stays raised while you hold the button. To lower the flag, let go of the button.

**■ How to play**

- The time limit for one game is 60 seconds.
- Moving the flags as instructed adds 1 point. A mistake takes away 1 point. When the game ends, the player with more points wins. As the score rises, the instruction messages get faster.
- You can act only once per message. After "ｿﾉﾏﾏﾃﾞ" (stay as you are), "ｱｹﾞﾅｲﾃﾞ" (don't raise) and "ｻｹﾞﾅｲﾃﾞ" (don't lower) you can act once more.
- "ｱｹﾞﾅｲﾃﾞ" (don't raise) means not raising the flag, in other words the same as "ｻｹﾞﾙ" (lower). Conversely, "ｻｹﾞﾅｲﾃﾞ" (don't lower) means raising the flag, so be careful.
- Messages can be skipped by pressing the A button. However, the player who pressed the A button

*[p. 88]*

  cannot raise or lower their flags after that.
- When you make a mistake, match the flags you have raised and lowered to the character shown in the centre of the screen. The game then continues.
- After the game ends, press the A button to play again, or the Z button to finish.

*[Screen: the G_HATA.B title screen. A banner at the top reads "ﾊﾀｱｹﾞ" (Hata-age), "PRESS START BUTTON", "1 PLAY  2 PLAY". Below, the screen is split in two: on each side a stick figure with a round face holds a red flag and a white flag; a smiling cloud is on the left and a crossed-out sun on the right.]*

G_HATA.B

#### Flow of the game

In "Hata-age" the computer gives instructions, and the player makes the character do the flag-raising movement within a fixed time. At that moment it judges whether the movement matches the instruction. This is repeated for 60 seconds, and the scores of player 1 and player 2 are compared to decide the winner.

#### Elements needed

As well as the program system, elements such as people holding flags and music are needed, so that the result is shown properly and the players know how the game is going.

*[Illustration: the stick-figure character holding a red flag and a white flag.]*

The flag-raising character

*[p. 89]*

#### Adding elements

It is also important to think about **added value** that makes players feel "this is fun!"

In this game, pictures of a sun and a cloud were added to give the background some movement.

*[Illustration: the smiling cloud and the crossed-out sun.]*

The sun and the cloud

"Hata-age" is a simple game where you just carry out the instructed actions accurately, but as the instructions get faster the difficulty rises and the game becomes more of a game. Adding more flags or making the instructions more complicated also widens the possibilities for variations.

Note that the added sun and cloud are not the essence of the game.

What matters is the idea, and how you bring it together.

### Sample program: Mobile (G_MOBIL.B)

#### Outline of the game

You pass in order through pylons carrying number objects, and your time is displayed.

**■ How to start**

```
LOAD "CD:G_MOBIL.B",R[Enter]
```

*[Screen: "PRESS START" over a checkerboard field stretching to the horizon, with pylons topped by numbers standing on it.]*

G_MOBIL.B

*[p. 90]*

**■ How to play**

You see the view from a vehicle like a hovercraft (an "air mobile"), and the game starts when you press the Start button.

Grey pylons are placed here and there, and on top of each pylon a number displayed in 3D is spinning. Ram the pylons in number order to make them disappear. When you have cleared them all, the CLEAR TIME is shown. A pylon does not disappear unless you pass through them in order.

**Controls**

| Button | Action |
|---|---|
| Direction button up | Not used |
| Direction button right | Turn right |
| Direction button left | Turn left |
| Direction button down | Not used |
| A button | Forward thrust (keeps firing while held) |
| B button | Brake thrust (keeps firing while held) |
| C button | Reverse thrust (keeps firing while held) |
| X button | Not used |
| Y button | Not used |
| Z button | Not used |
| L button | Slide left |
| R button | Slide right |
| Start button | Not used |

#### Elements

- The sense of speed of racing around a 3D field in an air mobile
- A satisfying feeling of drift
- The game play of competing on time

With these elements in mind, the key to writing this program is how to simplify the processing to gain speed.

#### Outline of the program

To give a sense of speed and of control, the screen is displayed from a 3D viewpoint. Because the player races around a field and the view is in 3D, the screen mode used is the **3-axis rotation BG mode**.

*[p. 91]*

Also, the field should be as large as possible, so screen mode 5 is used, which gives a size of 256×256 characters.

Next, to place 8 pylons on the field, the 256×256-character screen is made into a map of 64×64 blocks, with 4×4 characters as one block.

The 4×4 unit is the minimum spacing between pylons. For this, the array is defined as follows:

```
MAP(64,64)
```

By drawing a check pattern in each block so that the whole thing looks like a chessboard, the player is given visual stimulation while racing around the field.

Next, consider the part the player actually controls.

"Racing freely around a 3D field" means being able to move in any direction through 360 degrees, so the air mobile's parameters must hold the current direction and the velocity vector separately.

Also, to express the floating feeling of the air mobile, it is made to slide sideways in its previous direction even after changing direction, which gives the feeling of floating.

This is achieved in the air mobile movement processing in the program by calculating the sideways speed as well as the direction of travel.

Collision checks could be done on all the pylons 1 to 8, but in BASIC that makes the processing heavy, so a target pylon is set and only that target pylon is checked for collision.

**■ Explanation of the program**

Now let's go a step further and explain the program concretely, adding notes to the program listing. Read it with reference to the Reference Manual too.

The listing is long, so it is explained divided up by what each part does.

```
1000 SCREEN 5,4,256:SKCLOSE
```

Screen mode 5 is chosen to use the 3-axis rotation BG mode (logical BG8, a screen 256×256 characters in size). After the colon (:), the software keyboard is closed.

```
1001 '-----------------------------------
1002 'BGM & ｺｳｶｵﾝ Set
1003 PLAYINIT "EXTRA4"
1004 EFFECT 1,0,"@10 %1 C"   :'SONG#1=BGM1
1005 EFFECT 2,0,"@9  %1 C"   :'SONG#2=BGM2
1006 EFFECT 3,0,"@11 %1 C"   :'SONG#3=BGM3
```

*[p. 92]*

```
1007 EFFECT 4,0,"@7C"        :'SONG#4=ﾊﾟｲﾛﾝ ﾀｯﾁ Sound
1008 '-----------------------------------
```

*[Comments: ｺｳｶｵﾝ = sound effects; ﾊﾟｲﾛﾝ ﾀｯﾁ Sound = pylon touch sound.]*

As the comment on line 1002 says, this sets up the BGM and sound effects.

```
1010 PRIORITY 4,7
```

Sets the priority of the text screen to the very front (highest priority), to display messages and the measured time.

```
1030 SETPERS 60
1040 SETLIGHT 1,1,.5,RGB(29,29,31),RGB(0,0,8)
1050 SETDISP 7
```

These set the angle of view (SETPERS command), the colour of the lighting (SETLIGHT command) and the display level (SETDISP command).

```
1060 ROTCENTER 0,0,15
```

Sets the centre of rotation of the screen. Here the centre of the XY-axis 3-axis rotation plane is set at a position 15 points along the Z axis.

```
1070 ROTPOS 128*8,128*8,15
```

Scrolls the 3-axis rotation BG and sets the initial position of the air mobile.

```
1080 BANK=-.25:ROTATE BANK
```

Rotates the world coordinates, the BG, away (about the X axis).

```
1090 DIM MAP(64,64)
```

Here the map array is declared, which is used so that pylon positions do not overlap.

```
1100 DIM POALX(9),POALY(9)
```

The declaration of the arrays that hold the pylon positions.

```
1120 A$=READCHR$(4,0,256)
1130 SETCHR 8,0,A$
```

Reads all the character patterns of the text BG area for the 3-axis rotation BG mode (logical BG8), and copies them to the character pattern area of the 3-axis rotation BG.

```
1140 PALETTE 8,1,RGB(10,10,10)
1150 PALETTE 8,15,RGB(10,10,30)
```

*[p. 93]*

Sets colour data in palette 1 and palette 15 of the 3-axis rotation BG (logical BG8) mode.

The character data of the text BG area uses 3 colours, so colour 1 (the shadow colour) and colour 15 (the actual colour of the characters) are set.

```
1160   FOR GX= 0 TO 15
1170     FOR GY = 0 TO 15
1180       FOR X = 0 TO 3
1190         FOR Y = 0 TO 3
1200           PUTCHR 8,((GX*8)+X,(GY*8)+Y),135*2
1210           PUTCHR 8,((GX*8)+4+X,(GY*8)+4+Y),135*2
1220         NEXT
1230       NEXT
1240     NEXT
1250   NEXT
```

Places squares of 4×4 characters in the pattern area of the 3-axis rotation BG to make a chessboard-like pattern.

```
1260 CCOPY 8,(0,0)-(127,127) TO 8,(0,128)
1270 CCOPY 8,(0,0)-(127,127) TO 8,(128,0)
1280 CCOPY 8,(0,0)-(127,127) TO 8,(128,128)
```

The previous processing draws only a quarter of the 3-axis rotation BG (logical BG8 in SCREEN 5 is 256×256 characters), so it is copied into the areas left undrawn to fill the whole screen.

```
1300 SETVERTEX  0,16,READ
1310 SETPOLYGON 0,8,0,READ
1320 SETATR     0,8,READ
```

Reads the modelling data of the pylons. This corresponds to the DATA commands in lines 2660 to 2970.

```
1330 SETVERTEX  1,4,READ
1340 SETPOLYGON 1,1,1,READ
1350 SETATR     1,1,READ
```

Reads the modelling data of the square spinning on top of the pylons. This corresponds to the DATA commands in lines 2990 to 3040.

```
1370   FOR X=0 TO 64
1380     FOR Y=0 TO 64
1390       MAP(X,Y)= 0
1400     NEXT
1410   NEXT
```

*[p. 94]*

The map array used to stop pylon positions overlapping is initialised here (set to 0).

```
1420 OBJ(0,@ORDER) = 6
```

Sets the object conversion order.

```
1430   FOR P = 1 TO 8
```

The start of the loop that places the pylons. The variable P is the pylon number (1 to 8).

```
1440 *GEN_POAL
1450     X = (RND(56)+4)
1460     Y = (RND(56)+4)
```

Decides the pylon position with random numbers.

```
1470     IF MAP(X,Y)<>0 THEN *GEN_POAL
1480     MAP(X,Y) = 1
```

Checks the map array that stops pylon positions overlapping, and if nothing is placed there (if it is 0), places the pylon at that position (sets it to 1).

If something is already placed there (if it is not 0), the pylon position is set again with random numbers.

```
1490     X = X * 32
1500     Y = Y * 32
```

As it stands, the smallest actual spacing between pylons would be 32 points *[sic: the spacing at this point is 1; multiplying by 32 spreads the pylons out]*, so the pylons would all be crowded into one place. So the X and Y values are made larger so that the pylons are placed at suitable intervals. Here X and Y are multiplied by 32.

```
1510     POALX(P) = X
1520     POALY(P) = Y
```

Stores the pylon position in the arrays that hold it.

```
1540     OBJ(P,@ATR)    = 0,0
1550     OBJ(P,@XP)     = X,,-Y
1560     OBJ(P,@ORDER)  = 0
```

Defines the pylon as an object.

```
1580     OBJ(P+8,@ATR)  = 1,1
1590     OBJ(P+8,@TYPE) = 4
```

*[p. 95]*

```
1600     OBJ(P+8,@XP)   = X,,-Y
1610     OBJ(P+8,@XRV)  = 0,-.005
1620     OBJ(P+8,@ORDER) = 0
```

Defines a red square as an object and rotates it about the Y axis. This is the board spinning under the number.

```
1640     SETPFONT P+16,48+P,(.5,.5,.2),RGB(15,15,15)
```

Defines a polygon font (the numerals "1" to "8") to display the pylon number.

```
1650     OBJ(P+16,@XR)    = ,RND(10)/10
1660     OBJ(P+16,@XRV)   = 0,.008
1670     OBJ(P+16,@XP)    = X,-104,-Y
1680     OBJ(P+16,@ORDER) = 0
```

Displays the polygon number and rotates it about the Y axis.

```
1690   NEXT
```

The end of the loop that places the pylons.

```
1700 *RESET_TERGET
1710 TERGET = 1
1720   FOR P = 1 TO 8
1730     OBJ(P,@TYPE)  = 4
1740   NEXT
```

At the start all the pylons are displayed, so TYPE=4 is set. This is where the setting is made to display the pylons again in the next game after one game ends.

The pylon positions are kept unless the program is run again.

```
1760 ROTOVER 1,240*2
```

Fills the outside of the 3-axis rotation BG with character number 240.

```
1770 PX=0:PY=0:PZ=15
1780 DIR      = .375          :'ｼﾝｺｳﾎｳｺｳ
```

Initialises (a variable) the direction parameter of the air mobile.

```
1790 PVY      = 0             :'ﾌﾟﾚｲﾔXｿｸﾄﾞ
1800 PVX      = 0             :'ﾌﾟﾚｲﾔYｿｸﾄﾞ
```

*[Comments: ｼﾝｺｳﾎｳｺｳ = direction of travel; ﾌﾟﾚｲﾔXｿｸﾄﾞ = player X speed; ﾌﾟﾚｲﾔYｿｸﾄﾞ = player Y speed. The X and Y comments are swapped in the original.]*

This initialises (variables) the XY component parameters of the air mobile's speed.

*[p. 96]*

```
1810 PVA      = .025          :'ﾌﾟﾚｲﾔｶｿｸﾄﾞﾊﾟﾗﾒｰﾀ
```

*[Comment: player acceleration parameter.]*

Sets the acceleration parameter of the air mobile (a constant). Making this value larger increases the acceleration.

```
1820 BRK      = .02           :'ｹﾞﾝｿｸﾊﾟﾗﾒｰﾀ
```

*[Comment: deceleration parameter.]*

Sets the deceleration parameter of the air mobile (a constant). Making this value larger increases the deceleration.

```
1830 DIR_PRM = .003
```

Sets the turning parameter of the air mobile (a constant). Making this value larger makes changes of course (turning the direction of travel) faster.

```
1840 F=0
1850 TIME = 0
```

Initialises the other parameters.

```
1860 START = 0
```

Detects the state of the game. 0 means waiting and 1 means playing.

```
1870 BGM 1:LOCATE 14,10:PRINT "PRESS START  "
```

Displays the message that waits for the game to start.

```
1880 *LOOP
```

The start of the main loop.

```
1890 IF START = 1 THEN *SKIP_STT
```

If the game is in progress (1), skips the processing that waits for the Start button.

```
1900 PDL = PAD(0,1)
1910 IF PDL AND @PAD_START THEN BGM 2:GOTO *GAME_START
1920 GOTO *SKIP_MOVE
```

Waits for the Start button to be pressed. If it is not pressed, it carries on displaying the screen.

```
1930 *GAME_START
1940 LOCATE 14,10:PRINT "              "
1950 LOCATE  8,12:PRINT "                          "
1960 START = 1
```

*[p. 97]*

The game start processing. It erases the message and the end-of-game time from the screen, and sets the state to playing (1).

```
1980 *SKIP_STT
```

If the game is in progress, processing skips the wait for the Start button and comes here.

```
1990 DY = ABS(POALY(TERGET)-PY)
2000 IF DY > 10 THEN *NO_TOUCH
2010 DX = ABS(POALX(TERGET)-PX)
2020 IF DX > 10 THEN *NO_TOUCH
```

Calculates the X and Y distances (not the radius) from the centre of the pylon, and if the X or Y distance is 10 or more, goes to the processing for not hitting the pylon (2080 *NO_TOUCH).

```
2030 EFFECT -4   :'ﾊﾟｲﾛﾝ ﾀｯﾁ
```

*[Comment: pylon touch.]*

Makes a sound effect when you hit a pylon.

```
2040 OBJ(TERGET+0,@TYPE) = 0
```

The pylon has been hit, so it is removed.

```
2050 TERGET = TERGET + 1
```

Sets the next target pylon. This is the trick for not checking collisions with every pylon.

```
2060 IF TERGET = 9 THEN *GAME_END
```

When all the pylons have been hit, goes to the end processing. The target number reaching 9 moves on to the game end processing.

```
2100 PDL = PAD(0,1)
2110 '
2120 IF PDL AND @PAD_LEFT  THEN DIR = DIR - DIR_PRM
2130 IF DIR < 0 THEN DIR = DIR + 1
2140 IF PDL AND @PAD_RIGHT THEN DIR = DIR + DIR_PRM
2150 IF DIR > 1 THEN DIR = DIR - 1
```

Takes the direction button input from the control pad and changes the direction of the air mobile.

The direction of the air mobile is 0 to 1, so when the direction value goes negative +1 is done, and when it goes over 1, -1 is done.

*[p. 98]*

```
2170 SIDE = PVX*XCOS(DIR)-PVY*XSIN(DIR)
2180 SX = -SIDE*XCOS(DIR)*.01
2190 SY = SIDE*XSIN(DIR)*.01
2200 PVX=PVX+SX
2210 PVY=PVY+SY
```

The formula that keeps the previous velocity vector to some extent even when the direction changes (the calculation of the sideways speed parameter). This expresses the feeling of floating.

```
2230 AX=PVA*XCOS(DIR)
2240 AY=-PVA*XSIN(DIR)
```

For the left and right sideslip processing, separates the XY components from the air mobile's acceleration parameter.

```
2250 IF PDL AND @PAD_R THEN PVX=PVX+AX: PVY=PVY+AY
2260 IF PDL AND @PAD_L THEN PVX=PVX-AX: PVY=PVY-AY
```

Calculates the slide to the left or right from the input of the L and R buttons.

```
2280 AX=PVA*XSIN(DIR)
2290 AY=PVA*XCOS(DIR)
```

For the forward and backward acceleration processing, separates the XY components from the air mobile's acceleration parameter.

```
2300 IF PDL AND @PAD_A THEN PVX=PVX+AX: PVY=PVY+AY
2310 IF PDL AND @PAD_B THEN PVX=PVX-PVX*BRK:PVY=PVY-PVY*BRK
2320 IF PDL AND @PAD_C THEN PVX=PVX-AX: PVY=PVY-AY
```

Processes the control pad input. The A button accelerates in the direction of travel, the B button slows down, and the C button accelerates the other way (accelerates backwards).

```
2340 PX=PX+PVX:PY=PY-PVY
```

Calculates the air mobile's coordinates from the speed parameters calculated up to here.

```
2360 TIME = TIME + .0167
```

The timing processing (the unit of the variable TIME is seconds). One loop runs in 1/60 second, so 1 second ÷ 60 = 0.0167.

```
2370 MIN = INT(TIME/60)
2380 SEC = TIME-INT(TIME/60)*60
```

Separates minutes and seconds from the variable TIME.

*[p. 99]*

```
2390 LOCATE 1,20:PRINT USING "##:##.##";MIN,SEC
```

Handles displaying the time passed since timing started.

```
2400 IF TIME > 300 THEN *TIME_OUT
```

It would be odd for a game to go on and on without ending, so a time limit is set. When 5 minutes have passed, it is set to time out and go to the game end processing.

```
2420 *SKIP_MOVE
2430 F=F+.005
2440 IF F > 1 THEN F = 0
2450 FZ = .5*XSIN(F)
```

Processing for an up-and-down movement using a sine curve, to give a feeling of floating. The effect of this processing is easy to see on the start waiting screen.

```
2470 ROTPOS PX,PY,PZ+FZ
```

Calculates from the air mobile's coordinates and scrolls the 3-axis rotation BG in three dimensions.

```
2480 ROTATE,,DIR
```

Calculates from the air mobile's direction and rotates the 3-axis rotation BG about the Z axis.

```
2490 OBJ(0,@YR) = -DIR
```

Calculates from the air mobile's direction and rotates the object world coordinates about the Y axis.

```
2500 OBJ(0,@XP) = -PX,PZ+FZ,PY
```

Calculates from the air mobile's position and scrolls (translates) the object world coordinates in three dimensions.

```
2510 VSYNC
```

Waits for VSYNC, to synchronise with VSYNC. For VSYNC, see the Reference Manual.

```
2520 GOTO *LOOP
```

Jumps back to the start of the main loop.

```
2540 *GAME_END
2541 BGM 3
2550 LOCATE 1,20:PRINT "            "
```

*[p. 100]*

```
2560 LOCATE 14,10:PRINT "FINISH !!"
2570 LOCATE  8,12:PRINT USING "CLEAR TIME ##:##.##";MIN,SEC
2580 VSYNC 180
2590 GOTO *RESET_TERGET
```

The end processing when the game is cleared. It displays the time taken to remove all the pylons.

It displays "FINISH" for 3 seconds, and goes through the pylon initialisation processing to the start waiting processing.

```
2600 *TIME_OUT
2601 PLAYFADE 0,0,4
2610 LOCATE 1,20:PRINT "            "
2620 LOCATE 14,10:PRINT "TIME OUT !!"
2630 VSYNC 180
2640 GOTO *RESET_TERGET
```

The end processing when the game could not be cleared. All the pylons could not be removed even after 5 minutes, so "TIME OUT" is displayed.

It displays "TIME OUT" for 3 seconds, and goes through the pylon initialisation processing to the start waiting processing.

```
2660 DATA  -2, -64, -2
2670 DATA   2, -64, -2
2680 DATA   2, -64, -2
2690 DATA   2, -64,  2
2700 DATA   2, -64,  2
2710 DATA  -2, -64,  2
2720 DATA  -2, -64,  2
2730 DATA  -2, -64, -2
2740 DATA  -5,   0,-10
2750 DATA   5,   0,-10
2760 DATA  10,   0, -5
2770 DATA  10,   0,  5
2780 DATA   5,   0, 10
2790 DATA  -5,   0, 10
2800 DATA -10,   0,  5
2810 DATA -10,   0, -5
2820 DATA    , (0, 1, 9, 8)
2830 DATA    , (1, 2,10, 9)
2840 DATA    , (2, 3,11,10)
2850 DATA    , (3, 4,12,11)
2860 DATA    , (4, 5,13,12)
```

*[p. 101]*

```
2870 DATA    , (5, 6,14,13)
2880 DATA    , (6, 7,15,14)
2890 DATA    , (7, 0, 8,15)
2900 DATA (4, 0, 3, 0, 7399, 8)
2910 DATA (4, 0, 3, 0, 7399, 8)
2920 DATA (4, 0, 3, 0, 7399, 8)
2930 DATA (4, 0, 3, 0, 7399, 8)
2940 DATA (4, 0, 3, 0, 7399, 8)
2950 DATA (4, 0, 3, 0, 7399, 8)
2960 DATA (4, 0, 3, 0, 7399, 8)
2970 DATA (4, 0, 3, 0, 7399, 8)
```

The polygon modelling data of the pylons. It corresponds to the READ commands in lines 1300 to 1320.

```
2990 DATA  -3, -70,  0
3000 DATA   3, -70,  0
3010 DATA   3, -65,  0
3020 DATA  -3, -65,  0
3030 DATA    , (0, 1, 2, 3)
3040 DATA (4, 1, 3, 0,   28, 8)
```

The modelling data of the red board spinning on top of the pylons. It corresponds to the READ commands in lines 1330 to 1350.

G_MOBIL.B adds to the basic rule of going round pylons 1 to 8 in order a distinctive feel to controlling the air mobile, which increases the game play. The program also shows tricks for making the processing run smoothly at key points, and is a good model for making an original game.

## 2.9 Using peripherals

*[p. 102]*

With BASIC you can make and enjoy games that use the peripherals made for the SEGA SATURN, such as the Virtua Gun, the Mission Stick and the SEGA Multi Controller.

### Using the Virtua Gun

As a sample, we look at a program that uses the Virtua Gun. To use a peripheral connected to the SEGA SATURN, BASIC must be made to recognise the new peripheral.

Point the Virtua Gun at the screen and pull the trigger to draw lines. Pressing the Start button as well fills an area. Trigger + Start button clears (erases) the shapes drawn on the screen.

> **Caution:** It may not work with some televisions that have a function for storing and replaying the picture. It may also not work well depending on how bright the room is or how dirty the screen is.

```
1000 '【バーチャガンのテスト (motos)】
1010 ' 必ず SYNCを 2 または -2とすること
1020 ' 背景または表示面を明るくすること。サンプル色はシアン。
1030 ' 暗い画面を使う場合はトリガーを引いたら画面を
1040 ' 明るくして 2 SYNC位待ってから読み取る
1050 ' デジタルフレームメモリを使うテレビには反応しない。
1060 ' バーチャガンのDEVICE IDは "37"
1070 ' バーチャガンはコントロール端子2へ直に接続すること
1080 ' プログラムによってキャリブレートしてやることが望ましい。
1090 '-------------------------------------------------------
1100 ' このテストはコントロール端子2に接続する。
1110 '   トリガーで線引き
1120 '   スタートボタンで塗り潰し
1130 '   同時でCLEAR
1140 '
1150 SCREEN,,,2: GUNPORT=15
1160 SETPFONT 1,65:OBJ(1,37)=.03
1170 COLOR,,,RGB(0,10,20)
```

*[Comments: 1000 Virtua Gun test (motos). 1010 Always set SYNC to 2 or -2. 1020 Make the background or display plane bright; the sample colour is cyan. 1030–1040 If you use a dark screen, brighten the screen when the trigger is pulled and wait about 2 SYNCs before reading. 1050 Does not respond on televisions that use a digital frame memory. 1060 The Virtua Gun's DEVICE ID is "37". 1070 Connect the Virtua Gun directly to control port 2. 1080 It is best to calibrate it in the program. 1100 This test connects to control port 2. 1110 Trigger draws lines. 1120 Start button fills. 1130 Both together CLEAR.]*

*[p. 103]*

```
1180 *LOOP: LOCATE 0,0
1190  PRINT PAD(GUNPORT,1)
1200  PRINT PAD(GUNPORT,3)
1210  PRINT PAD(GUNPORT,4)
1220  XP=PAD(GUNPORT,3)-&H80
1230  YP=PAD(GUNPORT,4)-&H0
1240  OBJ(1,4)=XP-&HE0,YP-&H80
1250  IF PAD(GUNPORT,1) THEN
1260     IF PAD(GUNPORT,1) = &H400 THEN LINE
-(XP,YP),RGB(RND(32),RND(32),RND(32))
1270     IF PAD(GUNPORT,1) = &H800 THEN PAINT (XP,YP),ON
RGB(RND(32),RND(32),RND(32))
1280     IF PAD(GUNPORT,1) = &HC00 THEN CLS 0
1290  ENDIF
1300 GOTO *LOOP
```

*[Lines 1260 and 1270 are each one program line, wrapped in the book.]*

*[The rest of p. 103 is blank.]*

## 2.10 The supplied programs

*[p. 104]*

### About the supplied programs

This chapter introduces the sample programs that come with BASIC. There are tools useful for programming, sound, games and more, so refer to them when making your own original game.

### Demo: DEMO.B

A program that shows a demo introducing BASIC's features. When started, it shows all kinds of drawing, with P_TANK.B, P_HERI.B and others in its list, together with explanatory text.

**■ How to start**

```
LOAD "CD:DEMO.B",R[Enter]
```

*[Screen: a cube with a rough stone texture, with the caption "テクスチャに対してグラフィック命令を！" (Graphics commands on textures!).]*

DEMO.B

*[p. 105]*

### LAUNCH.B

To check the files saved on a storage device we used the FILES command, but with this program you can choose and run the program you want using the control pad.

From the software keyboard choose L button + [F1], or on the SEGA SATURN keyboard press [Shift]+[F1], or run the following.

**■ How to start**

```
LOAD "CD:LAUNCH.B",R[Enter]
```

```
            INSTANT PROGRAM LAUNCHER

    DEVICE [CD:]
    S_TUTOR  .B   G_MOBIL  .B   P_SHOWER .B
    T_KAMI   .B   G_MOBILS .B   P_TANK   .B
    T_OTO    .B   G_SABA   .B   P_TEXMAP .B
    T_HIBIKI .B   G_TEKE   .B   S_AIFF   .B
    T_KANADE .B   G_THESEU .B   S_ALISIA .B
    CLOCK    .B   PLAYMIDI .B   S_ARIA   .B
    DEMO     .B   P_CAME2  .B   S_ARIA_P .B
    G_BOMB   .B   P_CLOCK  .B   S_CLASSI .B
    G_BOU    .B   P_DLPLAY .B   S_FM_TA  .B
    G_HATA   .B   P_DOLL   .B   S_FUGA   .B
    G_JUMP   .B   P_FLOWER .B   S_F_HAWK .B
    G_JUMP_A .B   P_HERI   .B   S_GM_FM1 .B
    G_JUMP_M .B   P_NEKO   .B   S_GM_FM2 .B
    G_MAZE   .B   P_PFONT  .B   S_GM_FM3 .B
                                          →
      A ﾎﾞﾀﾝ/TAB    ... select device
      START/ENTER   ... run program
      ↑↓←→ ﾎｳｺｳｷｰ   ... move cursor
      [A-Z 0-9 F4]  ... search program

    Programmed by Bits Laboratory   motos
```

LAUNCH.B *[ﾎﾞﾀﾝ = button; ﾎｳｺｳｷｰ = direction keys]*

**■ Controls**

The background of the selected file name is coloured blue. Choose the file name you want with the direction button. With the bottom-right file name selected, pressing right or down shows the next screen. These are the files that did not fit on one screen because there are too many. Select the top-left one again and press left or up to go back to the previous screen.

To run the selected file, press the Start button.

The A button switches the storage device being looked at.

*[p. 106]*

### Bomb: G_BOMB.B

A battle game for 2 to 6 players, for the Multi-Terminal 6 only.

**■ How to start**

```
LOAD "G_BOMB.B",R [Enter]
```

Type this and run it.

*[Screen: "Press Start" on a plain screen.]*

G_BOMB.B

**■ How to play**

Connect a Multi-Terminal 6 to control port 1, and connect two or more control pads.

You can move freely around the screen with up, down, left and right on the direction button. There are walls you cannot see, and you cannot go outside them.

The A button places a time bomb where you are. There is no collision with players or with bombs that have not yet exploded. A bomb that has been placed explodes after about 0.5 seconds. Bombs placed within the range of an explosion are set off without waiting for their own timer.

Each player can have up to 10 bombs on the screen at the same time. Bombs that have exploded and vanished do not count. Up to 6 people can play, so up to 60 bombs can be placed on the screen.

Whether from their own bomb or a chain explosion, a player who touches the range of an explosion is removed from the screen and cannot take part again in the same game. Even then, bombs already placed stay on the screen until they explode on their timer or are set off. The game ends when the number of surviving players becomes 0 or 1.

*[p. 107]*

### Stick: G_BOU.B

A game in which you get past all kinds of obstacles and move a ball from the start point to the goal.

*[棒 (bō) means "stick" or "rod".]*

This game does not support the control pad. Have a Virtua Gun or a Shuttle Mouse ready.

**■ How to start**

```
LOAD "CD:G_BOU.B",R[Enter]
```

*[Screen: the title, the kanji 棒 written in brush strokes over a cloudy sky.]*

G_BOU.B (start screen)

*[Screen: a checkered field with a monkey, a panda and a gorilla, and a small ball near the bottom left.]*

G_BOU.B (menu screen)

*[p. 108]*

**■ Controls**

**Virtua Gun (advanced)**

| Control | Action |
|---|---|
| Trigger | Basically not used (you can shoot the animals), but while on the course it can switch off the collision check for leaving the course. |
| Start button | Confirm |

**Shuttle Mouse (beginner)**

| Control | Action |
|---|---|
| A button | Basically not used (you can shoot the animals), but while on the course it can switch off the collision check for leaving the course. |
| B button | Not used |
| C button | Not used |
| Start button | Confirm |

When the opening has finished and 3 animals, a yellow object and a blue object appear, the game begins. The blue object is the stick (ball) the player controls.

**■ Choosing a course**

Aim at one of the 3 animals and press the Start button to choose a course.

| Animal | Course |
|---|---|
| Yellow monkey | Course for beginners |
| Black and white panda | Course for intermediate players |
| Pitch-black gorilla | Course for advanced players |

**Screen**

| Item | Meaning |
|---|---|
| Window | A long, thin, tree-like stick that runs away when you bring your ball close. When the game starts, your number of hits and the elapsed time are shown. |
| Yellow background with arrows | The course: the path the player's stick goes along. |
| Grey and black background with plus and minus signs | Outside the course. |

**■ Start and goal**

To start, move to the course screen and shoot the red start square.

- Start: the red square at the far left of the course
- Goal: the green square at the far right of the course

*[p. 109]*

**■ How to play**

The player can bump the stick up to 3 times. On the 4th bump you go back to the course selection screen where the animals appear.

*[Screen: the course made of tiles, some marked with arrows; a window at the top shows "HIT!" and "TIME 16"; a gorilla and other characters with spinning arms stand on the course.]*

G_BOU.B (game screen)

A collision with the player's stick happens in the following cases:

- It bumps into part of the body of a character that is swinging its arms.
- It goes outside the course (except when riding on the monkey).
- It bumps into a character holding both arms out.

The small balls circling the player's stick have no collision.

> **Caution:** When using the Virtua Gun, if your ball goes off the screen at the start of a course, the scrolling automatically goes back, so take care.

**■ The program**

The courses are made by reading DATA statements. Changing these lets you make different courses, but some layouts cannot be handled.

*[p. 110]*

### Jump: G_JUMP.B

A game that uses the polygon functions. It shows a view as if you were flying through the sky. You take off from the start point, pass through rings in the order given, and compete on the time until you land.

**■ How to play**

When you take off from the start point, a ring (yellow triangles turning in an arc) appears somewhere. Move to it and pass through the ring.

When you pass through a ring, a sound plays and the next target ring is shown somewhere.

When you have passed through all the rings and land at the start point, the elapsed time is displayed.

**■ How to start**

```
LOAD "CD:G_JUMP.B",R[Enter]
```

Type this and run it.

*[Screen: "PRESS START !" over a 3D airfield with a control tower, runway markings and the sea in the distance.]*

G_JUMP.B

> **Caution:** G_JUMP.B supports the control pad.

*[p. 111]*

**Controls**

| Button | Action |
|---|---|
| Direction button up | Forward |
| Direction button right | Turn right |
| Direction button left | Turn left |
| Direction button down | Back |
| A button | Small thrust (keeps firing while held) |
| B button | Large thrust (keeps firing while held) |
| C button | Not used |
| X button | Switches the viewpoint to horizontal (facing forward; used for normal flight) |
| Y button | Switches the viewpoint to diagonally down |
| Z button | Switches the viewpoint to straight down |
| L and R buttons | Not used |
| Start button | Not used |

> **Caution:** G_JUMP_A.B is G_JUMP.B adapted for the SEGA Multi Controller.

**Controls for G_JUMP_A.B**

| Control | Action |
|---|---|
| Direction button | Not used |
| Analogue key | Tilt forward: forward. Tilt right: turn right. Tilt left: turn left. Tilt back: back. |
| A, B and C buttons | Not used |
| X button | Switches the viewpoint to horizontal (facing forward; used for normal flight) |
| Y button | Switches the viewpoint to diagonally down |
| Z button | Switches the viewpoint to straight down |
| L trigger | Not used |
| R trigger | Thrust (keeps firing while held) |
| Start button | Not used |

*[p. 112]*

> **Caution:** G_JUMP_M.B is G_JUMP.B adapted for the Mission Stick.

**Controls for G_JUMP_M.B**

| Control | Action |
|---|---|
| Stick | Tilt forward: forward. Tilt right: turn right. Tilt left: turn left. Tilt back: back. |
| Throttle | Not used |
| Trigger A | Small thrust (keeps firing while held) |
| Trigger B | Large thrust (keeps firing while held) |
| Trigger C | Not used |
| A button | Small thrust (keeps firing while held) |
| B button | Large thrust (keeps firing while held) |
| C button | Not used |
| X button | Switches the viewpoint to horizontal (facing forward; used for normal flight) |
| Y button | Switches the viewpoint to diagonally down |
| Z button | Switches the viewpoint to straight down |
| L and R buttons | Not used |
| Start button | Not used |

*[The rest of p. 112 is blank.]*

*[p. 113]*

### Maze: G_MAZE.B

A game in which you get out of a maze within a time limit (5 minutes at first).

**■ How to start**

```
LOAD "CD:G_MAZE.B",R [Enter]
```

Type this and run it.

*[Screen: "Press Start" over a 3D view down a corridor of the maze.]*

G_MAZE.B

**■ The game**

The player is placed at the centre of the maze. The exit is in one of the four corners. The maze is generated automatically with random numbers, but it has no islands, so if you keep following one wall you will always reach the exit.

> **Caution:** G_MAZE.B supports the control pad.

**Controls**

| Button | Action |
|---|---|
| Direction button | Move |
| X button | Periscope: look around from above the walls. |
| Z button | Wall pass: you can pass through the wall in front of you. |

※ The X button and Z button can each be used 3 times at first.

*[p. 114]*

There are items placed in the maze:

- Blue cube: extends the time (+1 minute).
- Red cube: the number of uses of the X button goes up by 1.
- Green cube: the number of uses of the Z button goes up by 1.

A blue cube is always placed in the 3 corners that have no exit. As well as these, several items are placed at random.

**■ How to play**

The game ends when you reach the exit or the time runs out. To keep playing the same maze, press the A button at the "Try Again?" question.

To play a different maze, finish once with the B button and then run it again.

### Mobile: G_MOBILS.B

G_MOBILS.B is G_MOBIL.B, introduced in "2.8 Making an original game", adapted for the Racing Controller. It is a game in which you pass in order through cones carrying number objects, and your time is displayed.

**■ How to start**

```
LOAD "CD:G_MOBILS.B",R[Enter]
```

Type this and run it.

> **Caution:** G_MOBILS.B is G_MOBIL.B adapted for the Racing Controller.

**Controls**

| Control | Action |
|---|---|
| Handle | Turn right: turn right. Turn left: turn left. |
| Butterfly shift | Pull the right side: slide right. Pull the left side: slide left. |
| A button | Forward thrust (keeps firing while held) |
| B button | Brake thrust (keeps firing while held) |
| C button | Reverse thrust (keeps firing while held) |
| X, Y and Z buttons | Not used |
| Start button | Not used |

*[p. 115]*

### Mackerel: G_SABA.B

In this game you use the Virtua Gun to shoot down mackerel (鯖, *saba*) flying across the screen.

**■ How to start**

```
LOAD "CD:G_SABA.B",R[Enter]
```

Type this and run it.

*[Screen: the title, the large kanji 鯖 (mackerel), with a menu in half-width katakana: > ﾈﾗｲｳﾁ (aimed shooting), ﾋﾀｽﾗｳﾂ (rapid shooting), ｼｮｳｼﾞｭﾝｱﾜｾ (sight adjustment), ｹﾞｰﾑｼｭｳﾘｮｳ (end game).]*

G_SABA.B

**■ How to play**

- Choose the game mode on the title screen. Choose one of "aimed shooting" (狙い撃ち), "rapid shooting" (ひたすら撃つ) or "sight adjustment" (照準あわせ).
- In "aimed shooting" mode you compete on hit rate and score. There is no time limit. The game ends after 20 misses. Letting a target escape off the screen, or missing a shot, counts as a miss. When the game ends, the number of shots and the number of misses are shown.
- In "rapid shooting" you compete for the highest score in 60 seconds. The game ends when the time limit has passed.
- "Sight adjustment" adjusts the aim of the Virtua Gun. Aim at the centre of the screen and shoot 3 times. The aim is adjusted.

*[p. 116]*

*[Screen: a tropical beach with palm trees; "ﾈﾗｲｳﾁ!!" (aimed shooting!!) at the top left, "MISS: 1" at the top right, a flying fish, and at the bottom "ﾄｸﾃﾝ = 0" (score = 0) with a row of 10 bullets.]*

G_SABA.B (game screen)

**■ Controls**

- On the title screen, pull the trigger to choose a mode, and confirm with the Start button.
- When a target (a mackerel) appears on the game screen, pull the Virtua Gun's trigger to shoot it. You have 10 shots. When the number of shots left reaches 0, you must shoot off the screen to reload (refill your bullets).

### Teketeke: G_TEKE.B

A game in which you raise 3 characters well within the time given, and create the best environment.

**■ How to start**

```
LOAD "CD:G_TEKE.B",R[Enter]
```

Type this and run it.

*[p. 117]*

*[Screen: the title "てけてけの巻" (The Teketeke Volume) written vertically beside a burst of sunlight through clouds, credited "Keita Kobayashi".]*

G_TEKE.B (start screen)

*[Screen: a row of icons along the top; three blob-like characters in the middle; at the bottom "1998 06/30 TUE 15:40:40" and, for each character, bars labelled ﾓﾉｼﾘ, ﾔﾙｷ and ｲﾉﾁ, with ｺﾞﾊﾝ, ﾍﾞﾝｷｮｳ and TIME on the right.]*

G_TEKE.B (game screen)

*[p. 118]*

**Names of the characters**

| Character | Name |
|---|---|
| Fire character (red) | Pokepoke (ぽけぽけ) |
| Water character (light blue) | Pikepike (ぴけぴけ) |
| Earth character (earth colour) | Pekepeke (ぺけぺけ) |

> **Caution:** G_TEKE.B supports the control pad.

**Controls**

| Button | Action |
|---|---|
| Direction button up | Moves the cursor up |
| Direction button right | Moves the cursor right |
| Direction button left | Moves the cursor left |
| Direction button down | Moves the cursor down |
| A button | Grab or release a character. Confirm during play. Confirm save or load. |
| B button | Cancel during play |
| C button | Select or place an icon; cancel save or load |
| X, Y and Z buttons | Not used |
| Start button | Not used |
| B + direction button | Move the cursor fast |

**Screens**

| Screen | Description |
|---|---|
| Main screen | The first screen you see when you start the game. A row of icons is along the top: from the left, food, study, play and save/load. Along the bottom are the characters' parameters, the amount of food left, the amount of study left and the time left. The screen in the middle is the area where the characters move about. All sorts of things are created here (land, sky, sea and so on). |
| Play | Choosing the play icon switches to the play screen. Lined up on the left are the characters' scores (the number of balls that went into their own territory). Lined up on the right is your score (the number of balls that went into the territory of one of the 3 characters). The square in the centre is the area where the ball game is played. The things turning at the top right and bottom left inside it are arrows. The characters and your icon are placed at random. |

*[p. 119]*

**■ How to play**

The bar graphs at the bottom show, from the left, the state of fire (Pokepoke), water (Pikepike) and earth (Pekepeke). As "ﾓﾉｼﾘ" (knowledge) rises, they create more and more land and other things.

A character you have fed and whose stomach is full ignores food. When it starts ignoring food, play with it.

If you make it study too much it gets grumpy, so play with it.

As "ﾔﾙｷ" (motivation) falls, it stops studying and in the end gets angry. Feeding it or playing with it makes "ﾔﾙｷ" rise.

When "ｲﾉﾁ" (life) falls to 0, the character disappears. "ｲﾉﾁ" falls little by little over time (its lifespan), but if you don't feed it, it falls faster. Once "ｲﾉﾁ" has fallen it cannot be won back.

The game ends when the "ｲﾉﾁ" of all 3 characters reaches 0.

**■ Parameters**

The food, study and time parameters are shown at the bottom right of the screen.

| Parameter | Meaning |
|---|---|
| "ｺﾞﾊﾝ" (food) | The amount of food that can be given at one time. It goes down and down as the characters eat. |
| "ﾍﾞﾝｷｮｳ" (study) | The amount of study that can be given at one time. It goes down and down as the characters study. |
| "TIME" | The time left in this world. When it runs out, the game also ends. |

**■ Icons**

The icons are shown at the top of the screen.

- **Food**

  When you choose the food icon, a picture of food appears. Take it near a character, or place it and then bring a character near it, and the character starts eating. You cannot place two or more lots of food at the same time.

> **Caution:** A character does not eat when it is full, sleeping, playing, angry or studying.

- **Study**

  As with food, choose the icon and bring it near a character. When a character is near, it starts studying. You cannot place two or more lots of study at the same time.

> **Caution:** A character does not study when it is eating, sleeping, playing, angry or studying.

*[p. 120]*

- **Play**

  Choosing the play icon switches to the play screen. Control a board to bounce the ball back. The game goes on until all the balls have gone into someone's territory.

- **Save**

  Choosing the save icon darkens the screen and asks whether to save. Press the A button or the C button to confirm your answer. Only one set of data can be saved.

- **Load**

  Choosing the load icon darkens the screen and asks whether to load. Press the A button or the C button to confirm your answer.

### Theseus: G_THESEU.B

**■ How to start**

```
LOAD "CD:G_THESEU.B",R[Enter]
```

Type this and run it.

```
    ｺﾝﾄﾛｰﾙ

    PAD 0

    C ﾎﾞﾀﾝ   : ｼﾞｬﾝﾌﾟ
        =>   : ﾐｷﾞ ｲﾄﾞｳ
        <=   : ﾋﾀﾞﾘ ｲﾄﾞｳ

    C ﾎﾞﾀﾝ ｦ ｵｼﾂﾂﾞｹﾙﾄ ｱｶﾞﾘﾂﾂﾞｹﾙ
    ｲﾁﾄﾞ C ﾎﾞﾀﾝ ｦ ﾊﾅｽﾄ ﾁｬｸﾁ ｽﾙﾏﾃﾞ
    ﾌﾀﾀﾋﾞ ｼﾞｬﾝﾌﾟ ﾊ ﾃﾞｷﾅｲ

    ﾕﾋﾞﾜ ﾄ ｶｷﾞ ｦ ﾄｯﾃ ｵﾝﾅﾉｺｦ ﾀｽｹﾚﾊﾞ
    1ﾒﾝ ｸﾘｱ

  PUSH C BUTTON TO START
```

G_THESEU.B *[Screen text: Controls. PAD 0. C button: jump. =>: move right. <=: move left. Holding the C button keeps you rising; once you release the C button you cannot jump again until you land. Take the ring and the key and rescue the girl to clear stage 1.]*

**■ The game**

A stage-clear game in which you take the ring and the key while avoiding obstacles and pools of blood, and go to the princess.

*[p. 121]*

*[Screen: a platform maze of brick walls. Header "LIFE 1500  SCORE 0  TIME 124  LEV 1  KEY  RING"; a small figure stands on a ledge near a key and a flag, with spinning squares nearby; "HELP ME! THESEUS!!" along the bottom.]*

G_THESEU.B (game screen)

**■ The screen**

An explanation of the display at the top of the screen:

| Item | Meaning |
|---|---|
| LIFE | When it reaches 0 the character dies and the game is over. |
| SCORE | Goes up when you take flags or stars. When you clear a stage, the time left is added. |
| TIME | Goes down from the start of the game. Whatever is left when you clear the stage is added to the score. |
| LEV | The stage number. |
| KEY | When you take the key, "OK" is shown below it. |
| RING | When you take the ring, "OK" is shown below it. |

At the bottom of the screen, messages such as the input at the start of the game and Continue (Y/N) are shown. All sorts of messages are also shown during play.

An explanation of the main screen:

| Item | Meaning |
|---|---|
| Enemies | Touching the squares that spin while moving back and forth on the screen reduces "LIFE". |
| Pools of blood | "LIFE" goes down while you are in them. |
| OPEN | Opens a door (a particular door in the area). |
| CLOSE | Closes a door (a particular door in the area). |
| Flags and stars | Added to the score. |

*[p. 122]*

> **Caution:** G_THESEU.B supports the control pad.

**Controls**

| Button | Action |
|---|---|
| Direction button up | Not used |
| Direction button right | Move right |
| Direction button down | Not used |
| Direction button left | Move left |
| A and B buttons | Not used |
| C button | Jump (keeps rising while held) |
| X, Y and Z buttons | Not used |
| L and R buttons | Not used |
| Start button | Not used |

### Doll: P_DOLL.B

A keyframe animation program that makes keyframes by changing things such as the joint angles of a doll, and makes an animation by interpolating the movement between keyframes.

**■ How to start**

```
LOAD "CD:P_DOLL.B",R[Enter]
```

Type this and run it.

*[Screen: a jointed polygon mannequin standing on a tiled floor. At the top: "BODY POS 0 0 0" and "FR: 1 STEP: 20 VDIF: 4".]*

P_DOLL.B

*[p. 123]*

**■ The screen**

The part shown at the top of the screen gives the settings of the frame currently shown.

```
BODY ANGL   250   0   500
FR: 3  STEP:30  VDIF: 6
```

From the left these show "the object being edited", "X rotation angle", "Y rotation angle" and "Z rotation angle". As well as rotation angles, function choices such as the polygon doll's position "X coordinate", "Y coordinate" and "Z coordinate", moving and copying frames, and saving and loading data are also shown here.

The next line shows "the current frame position", "the number of interpolation steps between the current frame and the previous frame" and "the size of the change in values when editing".

The parameter shown in yellow is the one being edited.

> **Caution:** P_DOLL.B supports the control pad.

**Controls**

| Button | Action |
|---|---|
| Direction button up and down | Move through the objects to edit and the function choices |
| Direction button left and right | Move through the parameters to edit and the function choices |
| A button | Confirms the value in some function choices |
| B button | Not used |
| C button | Confirms a function choice |
| X button | Increases the amount a parameter changes when the L or R button is pressed |
| Y button | Edits while rotating the object |
| Z button | Decreases the amount a parameter changes when the L or R button is pressed |
| L button | Decreases the parameter value |
| R button | Increases the parameter value |
| Start button | Not used |

**■ The function choices**

- **PREV**

  Shows the previous frame. The smallest frame number is 1.

- **TIME**

  Changes the number of interpolation steps between the previous frame and the current frame. Change the steps with the L and R buttons, and confirm with the C button. The largest number of steps is 99.

*[p. 124]*

- **NEXT**

  Shows the next frame. The largest frame number is 199.

- **INS**

  Inserts one frame at the current frame position. From the frame after the inserted frame, the frame numbers move along in order, and any data in frame 199 is lost.

- **COPY**

  Copies the data of another frame position to the current position. Choose the source data with the L and R buttons, and confirm with the C button.

- **DEL**

  Deletes the data at the current frame position. The data of the next frame position becomes the data of the current frame position. The data of frame 199 is copied to frame 198, and the new frame 199 is in its initial state.

- **SAVE**

  Saves the current animation data. When you choose this item you are asked for a file name, so give it a file name. Saved data is large, so watch the capacity of the storage device.

- **LOAD**

  Loads animation data. Give the file name to load by typing it.

- **PLAY**

  Plays the animation. It plays from frame 1 to the current frame, so open the frame you want to play up to. However, if the frame currently open is frame 1, it plays up to frame 2.

- **END**

  Ends P_DOOL.B *(sic)*.

### Doll demo: P_DLPLAY.B

An animation made with P_DOLL.B. A polygon doll does exercises while slowly turning around on the screen. Refer to it when making animations with P_DPLL.B *(sic)*.

**■ How to start**

```
LOAD "CD:P_DLPLAY.B",R[Enter]
```

Type this and run it.

*[p. 125]*

*[Screen: the polygon mannequin bending sideways with one arm raised, on a tiled floor; "FRAME:119  STEP: 5" at the top.]*

P_DLPLAY.B

### Polygon helicopter: P_HERI.B

Shows an animation of a solid helicopter in real time.

```
LOAD "CD:P_HERI.B",R[Enter]
```

Type this and run it.

*[Screen: a polygon helicopter with its rotor blades, and "Ready." at the top left.]*

P_HERI.B

*[p. 126]*

### Polygon tank: P_TANK.B

Shows an animation of a solid tank in real time.

```
LOAD "CD:P_TANK.B",R[Enter]
```

Type this and run it.

*[Screen: a polygon tank with a long gun barrel, and "Ready." at the top left.]*

P_TANK.B

### Cat: P_NEKO.B

A sprite display test program. It displays sprite types 1 to 3.

*[ネコ (neko) means "cat".]*

**■ How to start**

```
LOAD "CD:P_NEKO.B",R[Enter]
```

Type this and run it.

*[p. 127]*

*[Screen: three copies of a photograph of a fluffy cat: one tilted, labelled "← スプライト・タイプ1" (sprite type 1); one upright, labelled "スプライト・タイプ2 ↓" (sprite type 2); and one stretched into a skewed shape, labelled "↑ スプライト・タイプ3" (sprite type 3).]*

P_NEKO.B

### Polygon shower sample: P_SHOWER.B

Shows in real time an animation of cubes shooting up into the air like a fountain.

**■ How to start**

```
LOAD "CD:P_SHOWER.B",R[Enter]
```

Type this and run it.

*[Screen: many small cubes scattered through the air.]*

P_SHOWER.B

*[p. 128]*

### P_TEXMAP.B

A sample program for drawing on polygons that have a texture.

**■ How to start**

```
LOAD "CD:P_TEXMAP.B",R [Enter]
```

It draws shapes with the LINE command, the CIRCLE command and so on onto each face of a textured polygon.

### TRANSFOR.B

A tool for sending data files with the extension .D to Basterm, the communication software. Run it and type the device ID and the file name. When it finishes, a message appears.

For device IDs, see the Reference Manual.

**■ How to start**

```
LOAD "CD:TRANSFOR.B",R[Enter]
```

Type this and run it.

### Kanade: T_KANADE.B

An example of how to use the sample BGM. The explanation uses the VEIGUES Opening Music, "S_VEIGUS.B", as an example.

*[奏 (kanade) means "playing music".]*

1. Type LOAD "CD:S_VEIGUS.B",R[Enter], and S_VEIGUS is loaded and run.
2. When the music starts, Break the program. This leaves the BGM in the memory used for music.
3. Type LOAD "CD:T_KANADE.B",R[Enter]. Kanade starts and plays the tune left in the music memory (in the example, the VEIGUES Opening Music).

While it is playing, pressing any key, or a button on the control pad connected to control port 1, stops the music and ends the program.

### Paper: T_KAMI.B

This tool is for simple drawing on the SEGA SATURN.

*[紙 (kami) means "paper".]*

**■ How to start**

```
LOAD "CD:T_KAMI.B",R[Enter]
```

Type this and run it.

**■ Outline of the functions**

1. Drawing functions such as lines, straight lines, rectangles and paint
2. Copying and pasting rectangular areas
3. Saving and loading 256-colour images (32,000-colour images can only be viewed)


*[p. 129]*

4. Magnifier (2×, 4×, 8×, 16×)
5. Loading Windows bitmaps (uncompressed only; 16.7-million-colour images can only be viewed)
6. Tile pattern drawing
7. Undo

**■ Notes on use**

- Connect a Shuttle Mouse or a control pad. If both are connected, the mouse takes priority.
- If the SEGA SATURN keyboard is connected, you can type characters in the file selection dialog.
- Large images cannot be saved to internal RAM (BRAM:).

**■ Controls**

- Start button: click it to hide all the windows; click it again to show them again.
- C button: clicking on the canvas picks up the colour under the pointer.
- Dragging a window's title bar (the blue part) with the A button moves the window.
- Clicking the B button magnifies the screen 2×, 4×, 8× or 16×, centred on the pointer. This works even in line mode and the like.
- Dragging with the B button scrolls the screen. This also works in line mode.
- C-clicking on any window other than the System window closes it.

**■ Menu window**

This window appears first when the program starts. From the left, its buttons show the Pen window, the Colour window, the Edit window and the System window. A-clicking a button shows that window, and the button stays pressed in. Clicking it again hides the window.

*[Picture: the Menu window with its four buttons.]*

*[p. 130]*

**■ Pen window**

*[Diagram: the Pen window, with each button labelled.]*

- Point button: draws freehand curves.
- Line button: draws straight lines.
- Rectangle button: draws the outline of a rectangle.
- Filled rectangle button: draws a filled rectangle.
- Circle button: draws a circle.
- Filled circle button: draws a filled circle.
- Paint button: fills an enclosed area.
- Spray button: draws various tile patterns. The pattern changes each time you click.

※ A-click a button to press it.

**■ Colour window**

*[Picture: the Colour window, showing the palette.]*

Choose the drawing colour by A-clicking it.

*[p. 131]*

**■ Edit window**

*[Picture: the Edit window.]*

- Copy button: select a rectangular area and copy it.
- Paste button: paste the copied rectangle.
- Undo button: undoes the last operation.

**■ System window**

*[Picture: the System window.]*

- Load button: loads an image chosen in the file selection dialog.
- Save button: writes the image to a file selected or typed in the file selection dialog.
- Rectangle save button: select a rectangular area and save it to a file.
- Exit button: quits the program.

*[p. 132]*

**■ File selection dialog box**

*[Screenshot: the file selection dialog, with device tabs BRAM, CRAM, FD0, FD1, COM and CD along the top, a file list with scroll buttons, and Ok and Cancel buttons.]*

This dialog box is used to select files and to type file names. How you type depends on whether the SEGA SATURN keyboard is connected, but selecting files and devices works the same way either way.

*Common operations*

- Device selection: click a device to choose it. The selected device is shown pressed in.
- File selection and scroll buttons: click a file to select it. The selected file has a yellow background. When saving, "*ｼﾝｷ ｻｸｾｲ*" *[shinki sakusei, "create new"]* appears in the list; click it to switch to file name input mode. It does not appear when loading.
- OK button and Cancel button: confirm or cancel the operation.

*File name input mode, with only a control pad or Shuttle Mouse connected*

- A-click: confirms the current character and moves to the next one.
- B-click: goes back one character. B-clicking on the first character cancels input.

*[p. 133]*

- C-click: selects a character.
- Start button click: confirms the file name.

*File name input mode, with the SEGA SATURN keyboard connected*

- Type characters from the keyboard.
- The [Backspace] key or the left arrow key goes back one character.
- The [Enter] key confirms the file name.
- The [Esc] key cancels file name input.

**■ Supplementary note 1 (how to use Rectangle save)**

Clicking the Rectangle save button closes all the windows on the screen and switches to rectangle selection mode. Set the rectangular area to save by dragging with the A button.

While you are selecting, the rectangle is drawn with a solid line; once it is selected, it is drawn with a dotted line. Double-clicking the A button inside the selected rectangle confirms the area to save and moves on to the file selection dialog. From there, everything works as for an ordinary save.

To cancel Rectangle save, click the Start button or the C button.

After selecting a rectangle, there are two ways to change it. One is to drag with the A button again somewhere outside the selected rectangle. The other is to drag with the A button inside the selected rectangle, which moves the selection.

With the second method, only the position changes; the width and height of the rectangle stay the same.

Click the B button to zoom, and drag with the B button to scroll the screen.

### Sound: T_OTO.B

This tool lets you compose simple tunes on the SEGA SATURN.

*[音 (oto) means "sound".]*

**■ How to start**

```
LOAD "CD:T_OTO.B",R[Enter]
```

Type this and run it.

**■ Outline of the functions**

1. Edit tunes of 16 tracks, about 100 bars, with notes down to 32nd notes.
2. Set the tone, pan pot, volume, pitch bend and damper switch for each note.
3. Set the key. (Changing key partway through a tune is not supported.)
4. Convert the tune you have composed to MML.
5. Edit in a score-like view, using notation such as "D.S. (dal segno)".
6. Use line mode to specify notes in finer detail.

*[p. 134]*

**■ Notes on use**

- Connect either a Shuttle Mouse or a control pad to the SEGA SATURN. If both are connected, the mouse takes priority.
- If the SEGA SATURN keyboard is connected, you can type from the keyboard in the file selection dialog box.

**■ The screens**

There are two editing modes: one where you edit with musical notes, and one where the notes are shown as lines and you edit those.

*[Screenshot: editing with notes. Top left: TEMPO 120, トラック (track) 1, フレーズ (phrase) 1; top right: STANDARD No. 0 [BEEP]. A treble staff and a bass staff fill the middle, with a "Vol" bar along the bottom.]*

*Editing with notes*

The notes are shown as line segments.

*[p. 135]*

*[Screenshot: editing in line mode. Header: STANDARD No. 0 [BEEP], TEMPO 120, Octave 4, トラック (track) 1, フレーズ (phrase) 1. A piano keyboard runs down the left side beside a grid, with a "Vol" bar along the bottom.]*

*Editing in line mode*

**■ The controls**

*[Screenshot: the menu screen, with a row of icon buttons across the top of the note-editing screen.]*

*Menu screen (move the cursor to the top of the screen)*

*[p. 136]*

**1: Menu bar**

Selects the various functions.

From the left, the buttons are:

- 1-1. "Load tune"
- 1-2. "Save tune"
- 1-3. "Convert to MML"
- 1-4. "Change tone set"
- 1-5. "Copy bar"
- 1-6. "Paste bar"
- 1-7. "Play"
- 1-8. None
- 1-9. None
- 1-10. None
- 1-11. "Switch editing mode"
- 1-12. "Quit Oto" *[音の終了, "end Oto"]*

The buttons do the following.

- **1-1. "Load tune"**
  Loads a tune. Select the file in the file selection dialog box, and it is loaded.
- **1-2. "Save tune"**
  Saves the tune. Select the file in the file selection dialog box, and it is saved.
- **1-3. "Convert to MML"**
  Saves the tune you are editing to a file in MML format. Select the file in the file selection dialog box, and it is saved.
- **1-4. "Change tone set"**
  Changes the tone set. You can load tone data in "Hibiki" format.
- **1-5. "Copy bar"**
  Copies the bar you are editing to the copy buffer.
- **1-6. "Paste bar"**
  Pastes from the copy buffer into the bar you are editing. All the information, including volume and pan pot, is pasted.
- **1-7. "Play"**
  Plays the tune. It may take a little while before playing starts.

  Pressing the Start button on the control pad plays the part currently shown.

*[p. 137]*

- **1-11. "Switch editing mode"**
  Switches between "note mode" and "line mode (provisional name)".
- **1-12. "Quit Oto"**
  Quits Oto.

**2: Key selection**

Selects the key.

- B-click switches between "major" and "minor".
- A-click changes the "tonic".
- C-click sets "C major".

**3: Note editing**

Edits notes.

- 1: Editing pitch
  B-click or drag on the note you want to change to change its pitch.
- 2: Editing length
  On the note whose length you want to change, drag with the A button to set the length.
- 3: Adding and deleting rests and notes
  C-clicking where there is a note turns it into a rest. C-clicking again deletes the rest. C-clicking where there is nothing inserts a note there.

**4: Repeats**

Sets repeats. A-clicking switches between ":|", "D.S." and "none".

**5: Sub-window**

Specifies the "volume", "pan pot" and "pitch bend" of each note.

- A-click or drag to set the value for one note; B-click or drag to set values for several notes in a row.
- C-dragging at the right edge of the screen sets the value for the whole bar.
- C-dragging changes the position within the bar.

**6: Note editing (lines)**

Edits notes as line segments.

- C-drag where there is nothing to draw a line segment (a note).
- C-click on a line segment to delete it.
- A-click in the middle of a line segment to move it.
- A-drag on the end of a line segment to adjust its length.
- B-drag on a line segment to adjust its height.

*[p. 138]*

**■ The file selection dialog box**

*[Screenshot: the file selection dialog box over the line-mode screen, with device tabs BRAM, CRAM, FD0, FD1, COM and CD, and Ok and Cancel buttons.]*

*File selection dialog box*

This is used to select files and to type file names. How you type file names differs depending on whether the SEGA SATURN keyboard is connected. Selecting files, devices and so on works the same way either way.

*Common operations*

- Device selection: click a device to select it. The currently selected device is shown pressed in.
- File selection and scroll buttons: click a file to select it. The selected file has a yellow background. When saving, "*ｼﾝｷ ｻｸｾｲ*" *[shinki sakusei, "create new"]* is shown; click it to switch to file name input mode. It is not shown when loading.
- OK button and Cancel button: confirm or cancel the operation.

*File name input mode, with only a control pad or Shuttle Mouse connected to the SEGA SATURN*

- A-click: confirms one character and moves on to the next.
- B-click: goes back one character. B-clicking on the first character cancels input.

*[p. 139]*

- C-click: selects a character.
- Start button click: confirms the file name.

*With the SEGA SATURN keyboard connected*

- Type characters from the SEGA SATURN keyboard.
- The [Backspace] key or the left arrow key goes back one character.
- The [Enter] key confirms the file name.
- The [Esc] key cancels file name input.

### Resonance: T_HIBIKI.B

*[響 (hibiki) means "resonance" or "echo".]*

**■ Overview**

With "Hibiki" you can choose tones built into the CD and make your own tone set. The data you make here can be loaded when you change tones in "Oto", so you can compose tunes with your own tone set.

**■ How to start**

```
LOAD "CD:T_HIBIKI.B",R
```

Start it with this. A title screen appears, then the main program starts.

**■ The controls**

*[Screenshot: the T_HIBIKI start-up screen. A list of tone names in three columns (0.BEEP, 1.HEY!, 2.HUA … 17.SHU; 18.SAW WAVE … 35.Synth Bass; 36.A.P, 37.Rho, 38.Org … 53.Bri) inside an ornate frame, with the menu bar of icon buttons over the middle.]*

*T_HIBIKI.B (start-up screen)*

**Menu bar (save, load, BASIC conversion of the tone set, quitting the application, etc.)**

Provides system functions such as saving and loading.

*[p. 140]*

You can move the menu bar by dragging its blue part with the A button. From the left, the buttons are:

- "Load tone" button
- "Save tone" button
- "Select CD built-in tones" button
- "Convert tone set to BASIC" button
- "(No function)"
- "Exit" button

The buttons do the following.

- **"Load tone" button**
  Loads the selected tone.
- **"Save tone" button**
  Saves the selected tone. Saved tone data can be loaded in "Oto".
- **"Select CD built-in tones" button**
  You can choose from these 16 tone sets:

  ```
  STANDARD
  ORCHEST
  ROCK
  DANCE
  PIANO
  ETHNIC
  METAL
  MBOXPO
  EXTRA1
  EXTRA2
  EXTRA3
  EXTRA4
  GM_FM1
  GM_FM2
  GM_FM3
  GM_FM4
  ```

  *[Faint screenshot: the tone-set selection window.]*
- **"Convert tone set to BASIC" button**
  Converts the selected tones into a BASIC program. A file name selection window appears; choose the file name to save to.
- **"(No function)"**
  No function is assigned to this button at present.
- **"Exit" button**
  Quits the application.

*[p. 141]*

**CD built-in tone pool (the one with the horizontal scroll bar)**

Select tones here and add them to the tone tray. Just after start-up, it lists the tones of the "STANDARD" tone set.

- A-click to "select a tone".
- A-double-click to add that tone to the "tone tray (③)".
- B-drag to scroll left and right.
- The scroll bar works the same way as in ordinary window systems.

**Tone tray (the one with the vertical scroll bar)**

Shows the tones you have selected. What is shown here is your own tone set. Just after start-up, nothing is selected. You can select tones from the CD built-in tone pool and add them.

- A-click to "select a tone".
- C-click to "delete a tone".
- B-drag to scroll up and down (only when it can scroll).

The scroll bar works the same way as in ordinary window systems.

### UD_DATA1.B

A sample program that plays music using sound data set by the user.

**■ How to start**

```
LOAD "CD:UD_DATA1.B",R[Enter]
```

Type this and run it.

> **Caution:** This program saves data to internal RAM. If there is no free space, it stops with an ERROR.

### UD_DATA2.B

A sample program that plays music using sound data set by the user.

**■ How to start**

```
LOAD "CD:UD_DATA2.B",R[Enter]
```

Type this and run it.

### S_AIFF.B

Plays files recorded in AIFF format, as used on the Macintosh and other machines.

**■ How to start**

```
LOAD"CD:S_AIFF.B",R[Enter]
```

Type this and run it.

### S_T_NAME.B

A list of tone names (nothing happens if you run it). It is included for use when writing your own programs

*[p. 142]*

and so on. The same names as the "TLIST" command gives are laid out as a BASIC program. The same thing is also attached to the end of "S_TUTOR.B".

### S_WAVE.B

Plays files recorded in WAVE format, the PCM data format for Window *[sic: Windows]*.

**■ How to start**

```
LOAD "CD:S_WAVE.B",R [Enter]
```

Each time you press a key, a sample wave file is played.

### S_GM_FM1.B

Introduces the parameters of the tone file "GM-FM1" using the FM commands of the TARG instruction.

**■ How to start**

```
LOAD "CD:S_GM_FM1.B",R[Enter]
```

Type this and run it.

### S_GM_FM2.B

Introduces the parameters of the tone file "GM-FM2" using the FM commands of the TARG instruction.

**■ How to start**

```
LOAD "CD:S_GM_FM2.B",R[Enter]
```

Type this and run it.

### S_GM_FM3.B

Introduces the parameters of the tone file "GM-FM3" using the FM commands of the TARG instruction.

**■ How to start**

```
LOAD "CD:S_GM_FM3.B",R[Enter]
```

Type this and run it.

### S_GM_FM4.B

Introduces the parameters of the tone file "GM-FM4" using the FM commands of the TARG instruction.

*[p. 143]*

**■ How to start**

```
LOAD "CD:S_GM_FM4.B",R[Enter]
```

Type this and run it.

### S_FM_TA.B

A sample program that test-plays sounds using several of the FM sound source's waveform oscillators.

**■ How to start**

```
LOAD "CD:S_FM_TA.B",R[Enter]
```

Type this and run it.

### PLAYMIDI.B

A sample program that plays Standard MIDI Files.

**■ How to start**

```
LOAD "CD:PLAYMIDI.B",R[Enter]
```

Type this and run it.

### List of the programs run inside the sound sample program "S_TUTOR"

**S_G_ARTS.B**: "GAME ARTS Sound Sample Menu"

- S_ALISIA.B
- S_F_HAWK.B
- S_LUNARA.B
- S_LUNARB.B
- S_SILPH.B
- S_TUBASA.B
- S_VEIGUES.B *[sic: the file on the CD is S_VEIGUS.B]*
- S_ZELIAR.B

**S_CLASSI.B**: "Famous classical pieces"

- S_ARIA.B
- S_ARIA_P.B
- S_FUGA.B
- S_KANON.B
- S_MARIA.B
- S_POLONA.B

*[p. 144 is blank]*

# Chapter 3: Using the communication software

*[p. 145: chapter title page, "Chapter 3 通信ソフト活用術" (Using the communication software), on a checkered background]*

*[p. 146 is blank]*

*[p. 147]*

## 3.1 Operating the communication software

With the supplied communication software, "BASTERM", you can develop advanced programs by linking your own Windows PC with the SEGA SATURN. BASTERM provides functions for editing program listings and for operating the SEGA SATURN remotely.

### Connecting the SEGA SATURN to a Windows machine

When connecting the SEGA SATURN to your Windows 95 machine, always use the supplied Windows communication cable. Make sure the connectors are firmly connected. A loose connection causes transmission errors.

### Installation

Put the tool CD for Windows into the PC's CD-ROM drive. Before installing, close all other programs first. If applications are running, the installation may not work properly. Also check that there is enough free space on the hard disk you are installing to.

**If AutoRun (CD auto-start) is set**

Insert the CD in the CD-ROM drive. The installer starts automatically.

**If AutoRun (CD auto-start) is not set**

First choose [Run...] from the [Start] menu and enter Instbt10.exe. You are asked whether to start the installer. Click the [Yes (Y)] button and the setup program starts. Click [No (N)] and it quits without installing.

*[Screenshot: the dialog "InstallShield 自動抽出 Exe" (InstallShield self-extracting EXE), reading "これは、BASTERM をインストールします。続行しますか?" (This will install BASTERM. Do you want to continue?), with [はい(Y)] (Yes) and [いいえ(N)] (No) buttons.]*

*Installer start-up screen*

*[p. 148]*

When the installer starts, the BASTERM installation screen fills the whole display, and a dialog box with the installation steps opens in the middle. Follow the instructions to carry on.

*[Screenshot: the full-screen "BASTERMのインストール" (BASTERM installation) setup window, with the "インストール先の選択" (Choose destination location) dialog in the middle. It says setup will install BASTERM in the directory below, to click [次へ] (Next) to install there, [参照] (Browse) to choose another directory, or [キャンセル] (Cancel) to quit without installing. The destination directory is C:\Program Files\BASTERM.]*

*Selection screen*

When you have read the steps and chosen where to install, BASTERM is installed automatically into the folder you chose.

*[Screenshot: the same setup window with a "セットアップ" (Setup) progress box reading "プログラム ファイルをコピー中" (Copying program files), program\basterm.exe, 52%, with a Cancel button.]*

*Installation in progress*

*[p. 149]*

When the software has been installed in the folder, a dialog asks whether to read the README file. Normally press [Yes (Y)]. README.TXT then opens in Notepad, the editor supplied with Windows 95.

*[Screenshot: readme.txt open in Notepad. It reads: "BASTERM Ver.1.0 リリースノート" (release notes); "・BASTERMの使用方法 / BASTERMの使用方法についてはヘルプファイルをご参照ください。" (How to use BASTERM: see the help file); "・BASTERMのアンインストール方法 / [コントロールパネル]の[アプリケーションの追加と削除]で[BASTERM]を選択してください。" (How to uninstall BASTERM: select [BASTERM] in [Add/Remove Programs] in the [Control Panel]); "(C)1998 ASCII Corp./Bits Laboratory/ESP inc."]*

*README.TXT screen*

When everything has finished, a dialog appears saying setup is complete. README.TXT is shown behind the setup screen.

### Uninstallation

To remove BASTERM from Windows 95, choose [Control Panel] under [Settings] from the [Start] button.

When the [Control Panel] window opens, choose [Add/Remove Programs], pick BASTERM from the list and click it. Then follow the instructions, and BASTERM is removed.

*[p. 150]*

### Starting BASTERM

Now let's start BASTERM. The BASTERM program itself is in the folder you chose on the installation screen, but during installation it was also added to the [Start] program menu. So you can run it by choosing [Programs] from the [Start] button and clicking the BASTERM icon in the [BASTERM] menu. The start-up screen looks like this.

*[Screenshot: the BASTERM window, titled "Untitled - BASTERM", with the menus ファイル(F) (File), 編集(E) (Edit), 表示(V) (View), 通信(C) (Communication), 設定(S) (Settings) and ヘルプ(H) (Help), a toolbar of icons, a large white editing area, and a status bar reading "レディ" (Ready) and "NUM".]*

*BASTERM start-up screen*

The **title bar** at the top of the window shows the name of this program, "BASTERM". Below it is a row of menus. The several small pictures shown next are called **[icons]**: they are buttons for some of the most frequently used menu commands. This row is called the **[toolbar]**.

The large white area in the middle is the window for editing programs. The grey strip at the very bottom is called the **[status bar]**. It shows short explanations of whatever the mouse cursor is pointing at, and the state of some of the keys on the keyboard. You can show or hide the [status bar] and the [toolbar] with settings in the **[View]** menu.

Now let's start editing a program.

#### The most basic operations

First, use the mouse cursor to choose the [New...] command from the [File] menu. You can edit program listings in BASTERM, but you can also use any other editor that runs on Windows 95.

*[p. 151]*

Let's type the following program listing into BASTERM.

*Sample program*

```
100 SCREEN
110 PRINT "HELLO,WORLD !"
120 GOTO 110
```

#### Sending a program to the SEGA SATURN through BASTERM

When you have finished typing, choose the [Send] command from the [Communication] menu. A message saying "通信ネゴシエーション中" (negotiating communication), like the one below, appears in the middle of the BASTERM screen. This means that the program you wrote on the PC is being sent to the SEGA SATURN. This can either work or not work, so each case is explained below.

*[Screenshot: the "プログラム送受信の進捗" (Program send/receive progress) dialog, reading "通信ネゴシエーション中" (Negotiating communication), with a キャンセル (Cancel) button.]*

*The "Negotiating communication" screen*

**If the message "セガサターンとの接続に失敗しました。接続を確認してください。" (Failed to connect to the SEGA SATURN. Please check the connection.) appears**

The SEGA SATURN and the PC may not be connected correctly. Choose the [Settings] command from the [Communication] menu; a communication port settings menu appears, where you can set up the connection.

If the communication port in the settings is already connected to another device, such as a modem, specify the communication port that the Windows communication cable is connected to. If it still does not work, check the connectors.

Communication is easily affected by its surroundings, and even a little noise can stop it working. Move electrical appliances away from the cable and try again.

*[Screenshot: a BASTERM warning dialog reading "セガサターンとの接続に失敗しました。接続を確認してください。" (Failed to connect to the SEGA SATURN. Please check the connection.), with an OK button.]*

*Connection failure dialog*

*[p. 152]*

**If it worked**

The SEGA SATURN receives the LOAD instruction and loads the program from the PC. The last line number loaded is shown, followed by Ready.

*[Screenshot: the SEGA SATURN screen, showing:]*

```
LOAD "COM:TBASTERM.B"
Line 120
Ready.
```

*Loading finished*

If this works, let's now read a program written on the SEGA SATURN into BASTERM.

#### Reading a program from the SEGA SATURN into BASTERM

Type LIST[Enter] on the SEGA SATURN and check the program you sent just now. Once you have confirmed the program is there, choose the [New...] command from BASTERM's [File] menu. A dialog asks "Untitled - BASTERM への変更を保存しますか?" (Save changes to Untitled - BASTERM?); click [No (N)]. This clears the program listing on the BASTERM side.

*[Screenshot: a BASTERM dialog reading "Untitled - BASTERM への変更を保存しますか?" (Save changes to Untitled - BASTERM?), with [はい(Y)] (Yes), [いいえ(N)] (No) and キャンセル (Cancel) buttons.]*

*The "Save changes to Untitled - BASTERM?" dialog*

*[p. 153]*

**■ Reading from the SEGA SATURN**

Next, choose the [Receive] command from the [Communication] menu. The program is read from the SEGA SATURN, and its listing appears in BASTERM's editing window.

#### Running a program from BASTERM

So far we have run programs on the SEGA SATURN with the RUN instruction, but with the PC and SEGA SATURN connected, you can run programs from BASTERM.

Choose [Run program] from the [Communication] menu and click it, and the program runs.

#### Stopping a program

To stop a program that is running normally, choose the [Stop running] command from the [Communication] menu.

#### Saving a program on the PC

To save a program on the PC, choose the [Save As] command from the [File] menu. If you are editing a program you saved before, choose the [Save] (overwrite) command. Here you can choose any storage device to save to.

*[Screenshot: the Windows "名前を付けて保存" (Save As) dialog, with 保存する場所 (Save in) set to Temp, ファイル名 (File name) "Untitled.B", ファイルの種類 (Save as type) "BASTERM Files (\*.b)", and 保存(S) (Save) and キャンセル (Cancel) buttons.]*

*Save dialog*

*[p. 154]*

#### Reading a program from the PC

To read a program from the PC, choose the [Open] command from the [File] menu.

*[Screenshot: the Windows "ファイルを開く" (Open) dialog, with ファイルの場所 (Look in) set to Temp, an empty ファイル名 (File name) box, ファイルの種類 (Files of type) "BASIC Files (\*.b;\*.bas)", and 開く(O) (Open) and キャンセル (Cancel) buttons.]*

*Open dialog*

#### Quitting BASTERM

Choose the [Exit BASTERM] command from the [File] menu. If the file you are editing has been changed, a confirmation message appears.

*[Screenshot: a BASTERM dialog reading "Untitled への変更を保存しますか?" (Save changes to Untitled?), with [はい(Y)] (Yes), [いいえ(N)] (No) and キャンセル (Cancel) buttons.]*

*Confirming whether to save the file*

### Key send

Before explaining the menus and commands, here is a useful feature of BASTERM.

When you use the PC and the SEGA SATURN together, exchanging the whole listing just to make a small correction, or switching back and forth between the PC's and the SEGA SATURN's input devices, is inefficient and tiresome. The [Key send] command lets you edit the SEGA SATURN's listing directly from the PC keyboard.

We'll use a listing to explain it. Type the following on the SEGA SATURN.

```
LOAD "P_SHOWER.B"[Enter]
```

*[p. 155]*

When loading has finished, choose the [Receive] command from the [Communication] menu in BASTERM. P_SHOWER.B has now been read into BASTERM.

The program listing is as follows.

*P_SHOWER.B*

```
1000 SCREEN 0:SETDISP 1
1001 '-----------------------------------
1002 'Object Item Number
1003 TYPE = 0: FLAG = 1
1004 XP = 4: YP = 5: ZP = 6
1005 XR = 8: YR = 9: ZR = 10
1006 XS = 12: XRV = 36: YRV = 37: ZRV = 38
1007 ATR = 16: POLYGON = 17: ORDER = 18
1008 PARENT = 20: CHILD = 21
1009 XV = 24: XA = 28: XL = 32: XRV= 36
1010 '-----------------------------------
1011 *SETUP
1012  OBJ(0,ZP)=500
1013  FOR I=2 TO 100
1014   OBJ(I,TYPE)  =4
1015   OBJ(I,PARENT)=1
1016   OBJ(I,XP)=0,0,0
1017   OBJ(I,XR)=RND(1024)/1024,RND(1024)/1024,RND(1024)/1024
1018   OBJ(I,XL)=4,16,4
1019   OBJ(I,XV)=(RND(128)-64)/32,-(RND(128)+128)/32,(RND(128)-64)/32
1020   OBJ(I,XA)=0,&H0.0E,0
1021   OBJ(I,XRV)=RND(16)/1024,RND(16)/1024,RND(16)/1024
1022  NEXT
1023  OBJ(1,TYPE)=4
1024  OBJ(1,XP)=0,224,0
1025  OBJ(1,YRV)=&H0.01
1026  VSYNC 60*4:GOTO  *SETUP
```

This program shows graphics of lots of cubes flying out of a box. Run it and see.

Once you have confirmed it works properly, change the program on the SEGA SATURN as follows.

```
CLS[Enter]
1022 NAXT[Enter]
RUN[Enter]
```

Line 1022 now gives a Syntax Error. When writing programs, you often make spelling mistakes like this.

*[p. 156]*

With a long program listing, sending the whole listing every time you make a correction takes time and slows down development. With the [Key send] command, the PC keyboard is linked to character input on the SEGA SATURN, so you can correct just the parts that need it.

Choose the [Key send] command from the [Communication] menu, and a picture of a keyboard appears in the middle of the BASTERM screen as a sign that it is ready. Press keys on the PC keyboard, and the key presses are typed on the TV screen.

*[Screenshot: the BASTERM window with a "GAME BASIC for SEGASATURNへのキー送信" (Key send to GAME BASIC for SEGA SATURN) window in the middle, showing a picture of a keyboard.]*

*A keyboard appears in the middle*

While the [Key send] command is active, you can move the BASIC cursor on the TV screen with the PC keyboard. You can now edit BASIC directly from the PC keyboard.

### The BASTERM menus

This section explains the BASTERM menus. Where a command has an icon, the icon is shown too.

#### [File] menu

**■ [New...]**

Creates a new BASTERM document. To open an existing program, use the [Open...] command.

| Shortcut | |
|---|---|
| Toolbar | *[icon: a blank page]* |
| Keyboard | [Ctrl]+[N] |

*[p. 157]*

**■ [Open...]**

Opens an existing program. To create a new program, use the [New] command.

| Shortcut | |
|---|---|
| Toolbar | *[icon: an open folder]* |
| Keyboard | [Ctrl]+[O] |

**The [Open...] dialog box**

In the [Open...] dialog box you can set the following options.

- **File name**
  Type or select the name of the document you want to open. The list box shows the files whose extension matches the file type chosen in the [Files of type] box.
- **Files of type**
  Choose the file format of the document you want to open. The format BASTERM supports is ".b", but ".bas", which is normally used as the GAME BASIC extension, is also shown. To show only ".b" or only ".bas" files, use this pop-up to choose the file type. To show all files regardless of extension, type "\*.\*".
- **Look in**
  Choose the directory where the document you want to open in BASTERM is stored.

**■ [Save]**

Saves the document you are working on without changing its file name or location. When you save a newly created document for the first time, the [Save As] dialog box appears, so you can give the document a suitable file name and save it.

To save with a different file name or location, use the [Save As...] command.

| Shortcut | |
|---|---|
| Toolbar | *[icon: a floppy disk]* |
| Keyboard | [Ctrl]+[S] |

*[p. 158]*

**■ [Save As...]**

Saves the document you are working on under a file name. Running the command shows the [Save As] dialog box, where you can give the document a suitable file name and save it. The file extension is ".b".

To save without changing the file name or location, use the [Save] command.

**The [Save As] dialog box**

In the [Save As...] dialog box you can set the following options, which specify the file name and location.

- **File name**
  Type a file name different from the original one. File names can be up to 8 half-width characters, and ".b" is added automatically as the extension. You can use full-width characters (kanji and so on) or long file names of more than 8 characters, but then BASIC can only handle the file by sending and receiving it through BASTERM.
- **Save as type**
  Choose the file format to save the document in. The format BASTERM basically supports is ".b", but if you want to save as, say, a ".txt" file to import into another application, choose "\*.\*" and type the file name including its extension.
- **Save in**
  Choose the directory where the document you want to open in BASTERM is stored *[sic: the directory to save the document in]*.

**■ [File list]**

The bottom of the [File] menu shows the names of up to 8 recently closed files, with numbers. You can choose a file here to open it.

**■ [Exit BASTERM]**

Quits BASTERM. If changes to the document have not been saved yet, BASTERM shows a dialog box asking whether to save them.

| Shortcut | |
|---|---|
| Keyboard | [Alt]+[F4] |

*[p. 159]*

#### [Edit] menu

**■ [Undo]**

Cancels the last editing operation and returns the document to how it was before that edit.

Some operations, however, cannot be undone.

| Shortcut | |
|---|---|
| Keyboard | [Ctrl]+[Z] or [Alt]+[Backspace] |

**■ [Cut]**

Deletes the selected data from the document and stores it on the clipboard. This command cannot be used when no data is selected.

When you cut data to the clipboard, whatever was on the clipboard before is overwritten by what you have just cut.

| Shortcut | |
|---|---|
| Toolbar | *[icon: scissors]* |
| Keyboard | [Ctrl]+[X] |

**■ [Copy]**

Copies the selected data from the document and stores it on the clipboard. This command cannot be used when no data is selected.

When you copy data to the clipboard, whatever was on the clipboard before is overwritten by what you have just copied.

| Shortcut | |
|---|---|
| Toolbar | *[icon: two documents]* |
| Keyboard | [Ctrl]+[C] |

**■ [Paste]**

Inserts the contents of the clipboard at the cursor position. This command cannot be used when nothing is stored on the clipboard.

| Shortcut | |
|---|---|
| Toolbar | *[icon: a clipboard with a document]* |
| Keyboard | [Ctrl]+[V] |

*[p. 160]*

**■ [Select All]**

Selects all the text currently shown in the window.

| Shortcut | |
|---|---|
| Keyboard | [Ctrl]+[A] |

**■ [Find...]**

Searches for a character string.

| Shortcut | |
|---|---|
| Keyboard | [Ctrl]+[F] |

**■ [Find Next]**

Finds the next match for what you set with the [Find...] command.

| Shortcut | |
|---|---|
| Keyboard | [F3] |

**■ [Replace]**

Replaces a character string.

| Shortcut | |
|---|---|
| Keyboard | [Ctrl]+[H] |

#### [View] menu

**■ [Toolbar]**

Shows or hides the toolbar.

The toolbar contains tools that do the same as commands often used in BASTERM, such as the [Send] command. When the toolbar is shown, a check mark appears next to this command name.

- **Toolbar functions**
  The toolbar is shown at the top of the window, just below the menu bar. You can operate many of the tools used in BASTERM by clicking them with the mouse.

*[p. 161]*

| Icon | | |
|---|---|---|
| *[blank page]* | [New document] icon | Creates a new document. |
| *[open folder]* | [Open] icon | Opens an existing document. BASTERM shows the [Open] dialog box, where you choose the file you want to open. |
| *[floppy disk]* | [Save] icon | Saves the document you are working on, overwriting it. If the document has not been named yet, BASTERM shows the [Save As] dialog box. |
| *[scissors]* | [Cut] icon | Cuts the selected range and stores it on the clipboard. |
| *[two documents]* | [Copy] icon | Copies the selected range and stores it on the clipboard. |
| *[clipboard]* | [Paste] icon | Inserts the clipboard data at the cursor position. |
| *[two computers with arrows]* | [Connect] icon | Connects and disconnects the SEGA SATURN and the PC. |
| *[right arrow]* | [Run] icon | Runs the program. |
| *[red "止まれ" (stop) sign]* | [Stop running] icon | Stops the program from running. |
| *[computer with downward arrow]* | [Receive] icon | Receives a program from the SEGA SATURN. |
| *[computer with upward arrow]* | [Send] icon | Sends a program to the SEGA SATURN. |
| *[keyboard]* | [Key send] icon | Sends key input to the SEGA SATURN. |

*[p. 162]*

**■ [Status Bar]**

Shows or hides the status bar. The status bar shows a short description of a command when you choose a menu command or a toolbar button, and the ON/OFF state of special keys on the keyboard. When the status bar is shown, a check mark appears next to this command name.

- **Status bar functions**
  The status bar is shown at the very bottom of the window. To show or hide it, choose the [Status Bar] command from the [View] menu.

  The left part of the status bar shows a short description of each menu command as you select it. Likewise, holding down a toolbar button also shows a short description. If, after reading it, you want to cancel that toolbar command, move the mouse pointer away from the toolbar button and release the mouse button.

  The right part of the status bar shows the ON/OFF state of the following keys.

| Display | Description |
|---|---|
| 送信 *[Send]* | Flashes while data is being sent to the SEGA SATURN. |
| 受信 *[Receive]* | Flashes while data is being received from the SEGA SATURN. |
| ｶﾅ *[Kana]* | The [Kana] key is ON. |
| CAP | The [Caps Lock] key is ON. |
| NUM | The [Num Lock] key is ON. |
| SCRL | The [Scroll Lock] key is ON. |

#### [Communication] menu

**■ [Connect]**

Connects to and disconnects from the SEGA SATURN.

When you use a series of file access commands that treat the SEGA SATURN as a file server (fopen, fread, fwrite, fclose and so on, for COM), you must first connect the SEGA SATURN and the PC with this command.

When you run the [Connect] command and a connection is established, the command gets a check mark and the *[Connect icon]* button on the toolbar stays pressed in. Running the [Connect] command in this state disconnects.

You can still correct programs and so on while connected. However, the PC uses some of its resources to monitor the connection, so if the PC feels slow, it is better to disconnect.

*[p. 163]*

Any files the SEGA SATURN has open when the connection is cut are closed unilaterally on the PC side, so if you reconnect and the SEGA SATURN accesses those files, you get an error. Before disconnecting during access, close any files that are open on the SEGA SATURN side.

| Shortcut | |
|---|---|
| Toolbar | *[Connect icon]* |

**■ [Send]**

Sends the program edited in BASTERM to the SEGA SATURN.

If this command is run when no connection to the SEGA SATURN has been requested, BASTERM connects automatically, sends, and disconnects when sending has finished.

When sending starts, a panel showing the sending status appears. To stop sending, click the [Cancel] button on the panel.

With the [Send settings] command you can set send options such as "RUN after sending", and with the [Filter] command you can apply a filter of your own to the content being sent.

> **Caution:** If a communication error occurs, or communication is interrupted by key input from the SEGA SATURN keyboard, BASTERM may not show a send error. Always check the messages on the SEGA SATURN side as well to see whether sending succeeded.

| Shortcut | |
|---|---|
| Toolbar | *[Send icon]* |
| Keyboard | [Ctrl]+[P] |

**■ [Receive]**

Receives a program from BASIC and loads it into the editing window.

If this command is run when no connection to the SEGA SATURN has been requested, BASTERM connects automatically, receives, and disconnects when receiving has finished.

When receiving starts, a panel showing the receiving status appears. To stop receiving, click the [Cancel] button on the panel.

Once receiving starts, the document being edited in BASTERM is lost (the file name is kept). This is no problem when sending and receiving a single program, but when copying several files from BASIC, use the [Save As...] command so that you do not overwrite the same file.

*[p. 164]*

> **Caution:** If a communication error occurs, or communication is interrupted by key input from the SEGA SATURN keyboard, BASTERM may not show a receive error. Always check the messages on the SEGA SATURN side as well to see whether receiving succeeded.

| Shortcut | |
|---|---|
| Toolbar | *[Receive icon]* |
| Keyboard | [Ctrl]+[G] |

**■ [Run program]**

Sends the RUN instruction. If a program is running, it stops it and then sends the RUN instruction.

This command also shows whether BASIC is running a program. While a program is running, the command has a check mark and the *[Run icon]* button on the toolbar is shown pressed in.

> **Caution:** When it is unknown whether the program is running or stopped, the button's check state is indeterminate. Treat the button's check state as a rough guide only.

| Shortcut | |
|---|---|
| Toolbar | *[Run icon]* |
| Keyboard | [Ctrl]+[R] |

**■ [Stop running]**

Sends a stop to BASIC. This command keeps sending the stop instruction until the program stops.

The [Stop running] command shows whether the SEGA SATURN is not running a program. When no program is running, the command has a check mark and the *[Stop running icon]* button on the toolbar is shown pressed in.

> **Caution:** When it is unknown whether the program is running or stopped, the button's check state is indeterminate. Treat the button's check state as a rough guide only.

| Shortcut | |
|---|---|
| Toolbar | *[Stop running icon]* |
| Keyboard | [Ctrl]+[B] |

*[p. 165]*

**■ [Key send]**

While the [Key send] graphic is shown on BASTERM's editing screen, key input typed into BASTERM is sent as it is to the SEGA SATURN.

As well as ordinary characters, you can send the arrow keys, the [Ctrl] key, function keys and so on, but some input, such as the [F10] key and [Ctrl]+[Break], cannot be used. Other commands cannot be used during key send either. To stop key send, click the dialog or press [Alt]+[K].

> **Caution:** If you press [Alt]+[K] to start the [Key send] command, the [Key send] graphic may open and close again at once, or may be slow to open. If this happens, try opening the [Key send] command with [Ctrl]+[K] and using [Alt]+[K] to close it.
>
> The [Key send] command can give errors (typed characters do not appear, or unintended characters appear) when BASIC is doing heavy processing, such as displaying polygons. In that case you can press the [F12] key to turn polygon display off.
>
> However, if you turn polygon display off with a key, the polygons do not reappear even if you then continue the program with Continue or operate objects with direct commands. Also, the [Key send] command only works with BASIC. You cannot use this feature in place of the SEGA SATURN keyboard in other software that uses the SEGA SATURN keyboard.

| Shortcut | |
|---|---|
| Toolbar | *[Key send icon]* |
| Keyboard | [Alt]+[K] (only valid when [Ctrl]+[K] has turned [Key send] ON) |

#### [Settings] menu

**■ [Change current directory]**

Changes the current directory. The current directory is the directory where file access from the SEGA SATURN actually takes place.

Running this command shows the [Change current directory] dialog. The dialog shows the current directory.

To change the current directory, edit this. For example, to make the current directory the top level of the C drive, type "C:¥" *[C:\ on non-Japanese systems]*. If you specify a directory that does not exist, a message appears when you close the dialog and the setting goes back to its original value.

*[p. 166]*

**■ [Communication conditions]**

Changes the communication conditions.

This command cannot be run while the communication port is in use. If the port is in use, disconnect with the [Connect] command first.

- **Port number**
  Choose the communication port the Windows communication cable connecting the SEGA SATURN is plugged into.

  The default value is "COM1".
- **Baud rate**
  Choose the baud rate for the connection to the SEGA SATURN. Set it to the same value as on the SEGA SATURN side.

  A higher number sends and receives programs faster, but the communication conditions (CPU load and noise) become stricter. If you get frequent communication errors or load/save errors at 19200, use a baud rate of 9600. The default value is 9600.

**■ [Filter]**

Filter programs add functions that BASTERM lacks on its own. If you work with BASTERM alone, you do not need them.

Filters are limited to console-type programs that run under MS-DOS. One example of a filter program would be a tool that converts structured GAME BASIC into BASIC.

Using a filter program can require some basic knowledge of MS-DOS, so use the [Filter] command only when someone with a fair knowledge of PCs is on hand.

Please note in advance that filter programs themselves are not supported.

If you set a filter by mistake and things stop working properly, turn off (uncheck) the [Use filter program] check box in the [Filter program settings] dialog.

*[p. 167]*

*[Screenshot: the "フィルタプログラム設定" (Filter program settings) dialog. At the top, a ticked "フィルタプログラムを使用" (Use filter program) check box. Fields: "フィルタへの入力ファイル名" (Input file name for the filter) IBASTERM.B, "フィルタからの出力ファイル名" (Output file name from the filter) OBASTERM.B, each with a 選択 (Select) button, and "フィルタのカレントディレクトリ" (Filter's current directory) C:¥WINDOWS¥TEMP¥. A "実行する内容" (Command to run) box with 挿入 (Insert) buttons: プログラム選択 (Select program), 入力ファイル名 (Input file name) and 出力ファイル名 (Output file name). Check boxes: 標準エラー出力をエラー情報に追加 (Add standard error output to error information, ticked), 標準出力をエラー情報に追加 (Add standard output to error information), 入力ファイル・出力ファイルを削除 (Delete input and output files, ticked), 実行ウィンドウを表示 (Show execution window, ticked). OK and キャンセル (Cancel) buttons.]*

*The [Filter] dialog box*

- **[Use filter program]**
  Tick this to use a filter. If it is not ticked, the other items cannot be set.
- **[Input file name for the filter]**
  The contents of the file being edited in BASTERM are saved under the file name given here. The filter program can take this file name as its input file. You can also choose it with the [Select] button.
- **[Output file name from the filter]**
  Specifies the file name in which the result converted by the filter is saved. The file created here is what gets loaded into the SEGA SATURN. You can also choose it with the [Select] button.
- **[Command to run]**
  Specify the program command line to run here. This entry must begin with an executable file name (.com, .exe, .bat). You can choose the executable file name with the [Select filter program name] button.

*[p. 168]*

  [Input file name] and [Output file name] can be chosen while the text cursor is in [Command to run]; they insert the current value of the corresponding field at the cursor position.
- **[Add standard error output to error information]**
  Adds the filter program's standard error output to the error information. Either standard output or standard error output, or both, must be added to the error information.
- **[Add standard output to error information]**
  Adds the filter program's standard output to the error information. Either standard output or standard error output, or both, must be added to the error information.
- **[Filter's current directory]**
  Specifies the directory used when running the filter program.
- **[Delete input and output files]**
  Deletes the input file and output file when processing has finished. It is normally fine to leave this ticked. Untick it when you want to check what the filter has output.
- **[Show execution window]**
  When ticked, the filter program's execution window (the MS-DOS console) is shown. If the filter program needs you to type anything, it must be shown. In most cases the execution window does not need to be shown.

> **Caution:** The filter program runs as a child process of BASTERM, but if the filter program runs out of control, you may have to force BASTERM to quit. In the worst case, a problem in the filter program could even reset the Windows system.
>
> Always save the file you are working on before using a filter.

**Supplement**

This is the process up to sending when a filter is used.

1. Save the content being edited.
2. If the filter is enabled, call the filter program (can be turned off in the Filter settings).
3. Add line numbers (can be turned off in the Send settings).
4. Check the file (can be turned off in the Send settings).
5. Take the difference from what was sent last time (can be turned off in the Send settings).
6. Issue a LOAD (or LOAD,M) instruction to the SEGA SATURN and have it load the program.

*[p. 169]*

**■ [Send settings]**

Sets how sending is done.

*[Screenshot: the "送信設定" (Send settings) dialog. Check boxes: 送信後に実行する (Run after sending); 送信後と実行でキー送信をオンにする (Turn on key send after sending and running); 差分送信を行う (Send differences only); 行番号を付加して送る (Send with line numbers added), with fields 開始行番号 (Starting line number) 1, 行番号増分 (Line number increment) 1, and 行頭が\*の時の増分間隔 (Increment interval when a line starts with \*) 10; 送信後にエラー情報がある時にダイアログで表示 (Show a dialog when there is error information after sending, ticked); エラー情報がある時送信中止 (Stop sending when there is error information, ticked); エラー情報ファイルを削除しない (Do not delete the error information file), file name ERRORLOG.TXT; 送受信のテンポラリファイルを削除しない (Do not delete the temporary send/receive file), file name TBASTERM.B; 常にLoad ,Mを発行する (Always issue Load ,M). OK and キャンセル (Cancel) buttons.]*

*The [Send settings] dialog box*

- **[Run after sending]**
  RUNs the program automatically after sending it.
- **[Turn on key send after sending and running]**
  After an action that runs the program (clicking the [Run program] button, or sending when Run after sending is ticked), shows the keyboard and switches to [Key send] mode.
- **[Send differences only]**
  When you have changed a file in BASTERM after sending it once, only the differences are sent from then on. For programs that contain fairly large data sections, such as graphics, turning this on sends only the changed parts, so you can send your edits quickly.

  With difference transfer turned on, the LOAD instruction and the LOAD,M instruction are used as appropriate. Even if [Send differences only] is ticked, after opening a file, and after an interrupted send, the whole content is sent with the LOAD instruction rather than just the differences.

*[p. 170]*

  Also, if the amount of difference data becomes too large, it switches automatically to normal sending, so that a method is chosen that does not make sending extremely slow.

  However, BASTERM cannot know if the program has been edited separately on the SEGA SATURN, so the send information BASTERM holds and the text being edited on the SEGA SATURN may no longer match, and the information may not be sent correctly.

  In that case, run the [Send] command while holding down the [Shift] key. The whole content is then sent rather than the differences, even if this item is ticked. Switch between the two as needed.
- **[Send with line numbers added]**
  When sending, adds line numbers automatically at the start of each line, beginning at [Starting line number] in steps of [Line number increment]. If you write programs using only labels, ticking this saves you numbering the lines yourself.

  Do not turn this on if you number lines yourself or with a filter or the like. Note, however, that adding line numbers that way can make difference sending less efficient.

  For lines that begin with \* (usually label lines), the number is rounded up to a multiple of **Increment interval when a line starts with \***. This option is for making difference sending more efficient, so choose a value that suits your program.

  For example, if line numbers are assigned from 100 in steps of 1 to source without line numbers, the third line *[of the excerpt below]* starts with \*, so it becomes 200 rather than 125.

  ```
  123 next
  124 '
  200 *thisp
  201 for i = 1 to 2
  ```

  If a line already has a line number, that number is used even when this box is ticked, and the following lines are numbered automatically from the next number.

  By putting a line number at the start of a data section, for example, you can make files that give efficient difference information.

  Example: if the original content is as follows

  ```
  PRINT I
  '
  1234 PRINT J
  PRINT Z
  ```

  and lines are generated from 100 in steps of 1:

  ```
  100 PRINT I
  101 '
  ```

*[p. 171]*

  ```
  1234 PRINT J
  1235 PRINT Z
  ```

  is the result.

  When the [Send with line numbers added] check box is ticked, blank lines (lines with nothing but the line break, not even spaces) are turned into comments. When line numbers are not added, blank lines are deleted automatically.
- **[Do a simple check of what is sent and add the results to the error information]**
  BASTERM can do a simple check of the program listing before sending. It checks the following.
  - Whether there are line numbers
  - Duplicate line numbers
  - Line number values
  - Number of characters in one line
- **[Show a dialog when there is error information after sending]**
  After sending has finished, shows together any errors produced by the filter and any errors found by the check before sending.
- **[Stop sending when there is error information]**
  Stops sending when an error is found. If this is not ticked, all the content is sent.
- **[Do not delete the error information file]**
  Tick this if you do not want the error information file deleted after sending. Tick it when you want to look at the error information later. The error information file is specified in [File name] below it.
- **[Do not delete the temporary send/receive file]**
  Tick this if you do not want the temporary file deleted after sending or receiving. The temporary file is the file actually used for sending and receiving, and it is also the parameter of the LOAD and SAVE instructions sent to the SEGA SATURN. Give it a file name BASIC can recognise (8 half-width characters + .b).
- **[Always issue LOAD,M] check box**
  Always makes the LOAD instruction issued to the SEGA SATURN `LOAD"file name",M`. This instruction means merging programs: it does not do a NEW (erase the program) before loading starts.

  This setting takes priority over difference sending's automatic switching between the LOAD instruction and the LOAD,M instruction.

*[p. 172]*

#### [Help] menu

**■ [Help]**

Opens the help file.

**■ [Version information...]**

Shows information about BASTERM's version, copyright and so on.

**■ About the extended command**

This is not a BASIC instruction, but as a feature of its own, BASTERM provides a program command that takes data into the source program.

Write the following command, without a line number.

```
#include "ファイル名"
```

*[ファイル名 means "file name".]*

In the file name part, give the name of the file to take in. For example, when loading data made with a modeller, writing source like the following lets you maintain the program and the data separately, which makes development more efficient.

```
DIM TESTD$(10)
RESTORE *TESTDATA
FOR I = 1 TO 10
READ TESTD$(I)
NEXT I
END
10000 ' Start Data Part
*TESTDATA
#include "TESTDATA.B"
```

# Index

*[p. 173]*

The index is reproduced in the book's order, which follows the Latin alphabet and then the Japanese kana order. Japanese headwords are given with an English translation. Page numbers are the book's.

### Symbols and numbers

| Entry | Pages |
|---|---|
| # | 85 |
| $ (dollar) | 22, 38 |
| + | 85 |
| - | 85 |
| .DXF | 73 |
| : (colon) | 27 |
| = | 21 |
| 3軸回転BGモード (3-axis rotation BG mode) | 90 |

### B

| Entry | Pages |
|---|---|
| BASTERM | 147 |
| BEEP音 (BEEP sound) | 84 |
| BGM | 92 |
| BRAM: | 30 |
| Break | 6, 28, 32 |

### C

| Entry | Pages |
|---|---|
| CD: | 30 |
| CIRCLE instruction | 47 |
| CLS instruction | 18 |
| CRAM: | 30 |

### D

| Entry | Pages |
|---|---|
| DATA instruction | 38 |
| DATE$ function | 27 |
| dB (decibel) | 86 |
| DELETE instruction | 25 |
| DEMO.B | 104 |
| DIM | 38 |
| DXF変換ツール (DXF conversion tool) | 73 |

### E

| Entry | Pages |
|---|---|
| EFFECT instruction | 84 |
| END instruction | 28 |

### F

| Entry | Pages |
|---|---|
| FILES instruction | 30 |
| FM音源 (FM sound source) | 82 |
| FOR〜NEXT instruction | 34 |

### G

| Entry | Pages |
|---|---|
| GM | 83 |
| GOSUB instruction | 37 |
| GOTO instruction | 27, 32 |

### I

| Entry | Pages |
|---|---|
| IF〜THEN instruction | 32 |

### K

| Entry | Pages |
|---|---|
| KLOAD instruction | 49 |

### L

| Entry | Pages |
|---|---|
| LAUNCH.B | 105 |
| LET instruction | 21 |
| LINE instruction | 46 |
| LIST instruction | 24 |
| LOAD instruction | 30, 152 |
| LOCATE instruction | 27 |

### M

| Entry | Pages |
|---|---|
| MIDI | 83 |
| MML | 83 |

*[p. 174]*

| Entry | Pages |
|---|---|
| MOSAIC instruction | 60 |

### N

| Entry | Pages |
|---|---|
| n | 85 |
| NEW instruction | 26, 29 |

### O

| Entry | Pages |
|---|---|
| O (letter O) value | 85 |

### P

| Entry | Pages |
|---|---|
| PAINT instruction | 48 |
| PALETTE instruction | 51 |
| PCM音源 (PCM sound source) | 83 |
| PLAYMIDI.B | 143 |
| PRINT instruction | 27 |
| PRIORITY instruction | 68 |
| PSET instruction | 46 |
| P_TEXMAP.B | 128 |

### R

| Entry | Pages |
|---|---|
| R | 85 |
| README.TXT | 149 |
| READ instruction | 38 |
| REM instruction | 65 |
| RENUM instruction | 34 |
| RGB | 47 |
| RIGHT$ function *[printed "RIGHTS関数"]* | 27 |
| ROTATE instruction | 59 |
| ROTCENTER instruction | 59 |
| ROTPOS instruction | 59 |
| RUN instruction | 25, 153 |

### S

| Entry | Pages |
|---|---|
| SAVE instruction | 29 |
| SCREEN instruction | 27, 41 |
| SCROLL instruction | 57 |
| SETATR instruction | 66 |
| SETDISP instruction | 92 |
| SETLIGHT instruction | 68, 92 |
| SETPERS instruction | 92 |
| SETPOLYGON instruction | 66 |
| SETTEX instruction | 66 |
| SETVERTEX instruction | 66 |
| STEP | 57 |
| Syntax error | 17, 155 |
| S_AIFF.B | 141 |
| S_CLASSI.B | 143 |
| S_FM_TA.B | 143 |
| S_GM_FM1.B | 142 |
| S_GM_FM2.B | 142 |
| S_GM_FM3.B | 142 |
| S_GM_FM4.B | 142 |
| S_G_ARTS.B | 143 |
| S_TUTOR.B | 83 |
| S_T_NAME.B | 142 |
| S_WAVE.B | 142 |

### T

| Entry | Pages |
|---|---|
| TRANSFOR.B | 128 |

### U

| Entry | Pages |
|---|---|
| UD_DATA1.B | 141 |
| UD_DATA2.B | 141 |

### W

| Entry | Pages |
|---|---|
| Windows用ツールCD (tool CD for Windows) | 147 |

### X

| Entry | Pages |
|---|---|
| X座標 (X coordinate) | 45 |

### Y

| Entry | Pages |
|---|---|
| Y座標 (Y coordinate) | 45 |

### Z

| Entry | Pages |
|---|---|
| ZOOM instruction | 27, 57 |

*[p. 175]*

### ア (a)

| Entry | Pages |
|---|---|
| アイコン (icon) | 156 |
| アトリビュートデータ (attribute data) | 55 |
| アニメーション (animation) | 64 |
| イコール (equals) | 21 |
| 入れ子 (nesting) | 35 |
| エラーメッセージ (error message) | 17 |
| 延長ケーブル (extension cable) | 10 |
| オクターブ (octave) | 85 |
| 音 T_OTO.B (Sound) | 133 |
| オブジェクト (object) | 62 |
| オブジェクトタイプ (object type) | 54 |
| オプション (option) | 19, 20 |
| 音符 (note) | 80 |
| 音名 (note name) | 79 |

### カ (ka)

| Entry | Pages |
|---|---|
| カーソル (cursor) | 15, 16 |
| カートリッジRAM (cartridge RAM) | 29 |
| 拡張子 (extension) | 73, 158 |
| 奏 T_KANADE.B (Kanade) | 128 |
| 紙 T_KAMI.B (Paper) | 128 |
| カメラテスト P_CAME2.B (camera test) | 71 |
| 画面モード (screen mode) | 41 |
| 漢字 (kanji) | 49 |
| カンマ (,) (comma) | 39 |
| キーリピート (key repeat) | 16 |
| 記憶装置 (storage device) | 29 |
| キャラクタコード (character code) | 40 |
| キャラクタ画面 (character screen) | 40 |
| 休符 (rest) | 81 |
| 休符コマンド (rest command) | 85 |
| 行 (line) | 24 |
| 行番号 (line number) | 23 |
| 効果音 (sound effect) | 92 |
| 構文 (syntax) | 20 |
| コマンド (command) | 19 |

### サ (sa)

| Entry | Pages |
|---|---|
| 鯖 G_SABA.B (Mackerel) | 115 |
| 座標 (coordinates) | 44 |
| サブルーチン (subroutine) | 36 |
| 実行 (run) | 19 |
| シミュレーション (simulation) | 61 |
| シャープ (sharp) | 80 |
| ジャンプ (jump) | 27 |
| ジャンプ G_JUMP.B (Jump) | 110 |
| 消去 (erase) | 26 |
| 条件式 (conditional expression) | 33 |
| 小節線 (bar line) | 82 |
| 初期化 (initialisation) | 27 |
| シングルクォーテーション (') (single quotation mark) | 65 |
| 数字 (numbers) | 19 |
| スクロール (scroll) | 56 |
| スケーリング (scaling) | 54 |
| スプライト (sprite) | 51 |
| スプライト画面 (sprite screen) | 41 |
| 全音 (whole tone) | 79 |
| 宣言 (declaration) | 38 |
| 添字 (subscript) | 38 |
| ソフトウェア・キーボード (software keyboard) | 6, 16 |
| ソフトウェア・リセット (software reset) | 6 |

### タ (ta)

| Entry | Pages |
|---|---|
| ダブルクォーテーション (double quotation mark) | 20 |
| 直接実行モード (direct mode) | 23 |
| 通信ポート (communication port) | 11, 151 |
| データ (data) | 39 |
| 定義 (definition) | 39 |
| テキスト画面 (text screen) | 41 |
| テキスト表示色数 (number of text colours) | 44 |
| テキスト表示論理BG (text logical BG) | 44 |
| テクスチャ (texture) | 64 |
| テクスチャテスト P_FLOWER.B (texture test) | 70 |
| てけてけ G_TEKE.B (Teketeke) | 116 |
| テセウス G_THESEU.B (Theseus) | 120 |

*[p. 176]*

| Entry | Pages |
|---|---|
| デバッグ (debugging) | 9, 25 |
| デフォルト (default) | 34 |
| ドール P_DOLL.B (Doll) | 122 |
| ドールデモ P_DLPLAY.B (Doll demo) | 124 |
| 透明色 (transparent colour) | 52 |
| ドット (dot) | 44 |

### ナ (na)

| Entry | Pages |
|---|---|
| ナチュラル (natural) | 80 |
| 音色 (tone) | 84 |
| 音色セット (tone set) | 84 |
| ネコ P_NEKO.B (Cat) | 126 |

### ハ (ha)

| Entry | Pages |
|---|---|
| 配列変数 (array variable) | 37 |
| 波形 (waveform) | 82 |
| パターン (pattern) | 51 |
| はたあげ G_HATA.B (Flag raising) | 87 |
| パラメータ (parameter) | 19, 20 |
| パレット (palette) | 48 |
| 半音 (semitone) | 79 |
| 光の三原色 (three primary colours of light) | 47 |
| ビットマップ画面 (bitmap screen) | 41 |
| 響 T_HIBIKI.B (Resonance) | 139 |
| 描画フレーム単位 (drawing frame unit) | 44 |
| ファイル (file) | 29 |
| ファイル名 (file name) | 29, 158 |
| 付点音符 (dotted note) | 81 |
| 付点休符 (dotted rest) | 81 |
| フラット (flat) | 80 |
| プログラミング (programming) | 23 |
| プログラム (program) | 23 |
| プログラム実行モード (program mode) | 23 |
| プログラムリスト (program listing) | 23, 26 |
| 変数 (variable) | 21, 35, 37 |
| 棒 G_BOU.B (Stick) | 107 |
| ボム G_BOMB.B (Bomb) | 106 |
| ポリゴン (polygon) | 62 |
| ポリゴンシャワーサンプル P_SHOWER.B (polygon shower sample) | 127 |
| ポリゴン戦車 P_TANK.B (polygon tank) | 126 |
| ポリゴン時計 P_CLOCK.B (polygon clock) | 68 |
| ポリゴンフォント P_PFONT.txt (polygon font) | 67 |
| ポリゴンヘリコプター P_HERI.B (polygon helicopter) | 125 |
| ポリゴン面 (polygon screen) | 41 |
| 本体RAM (internal RAM) | 29 |

### マ (ma)

| Entry | Pages |
|---|---|
| マルチステートメント (multi-statement) | 27 |
| メイズ G_MAZE.B (Maze) | 113 |
| 命令 (instruction) | 19, 20 |
| メインルーチン (main routine) | 36 |
| モービル G_MOBIL.B (Mobile) | 89 |
| モービル G_MOBILS.B (Mobile) | 114 |
| モザイク (mosaic) | 60 |
| モデリング (modelling) | 63 |

### ヤ (ya)

| Entry | Pages |
|---|---|
| 要素 (element) | 38 |

### ラ (ra)

| Entry | Pages |
|---|---|
| ライト (light) | 64 |
| ラジアン (radian) | 59 |
| ラベル (label) | 27 |
| リアルタイムコンピュータグラフィックス (real-time computer graphics) | 61 |
| リスト (listing) | 26 |
| レンダリング (rendering) | 63 |
| 論理BG (logical BG) | 58 |

### ワ (wa)

| Entry | Pages |
|---|---|
| ワークRAM (work RAM) | 24 |
| ワールド座標 (world coordinates) | 61, 92 |

## Back matter

### Inside back cover

**⚠ Caution: Precautions for using SEGA SATURN CDs**

*Health precautions*

- A very small number of people may suffer symptoms such as temporary muscle spasms or loss of consciousness when exposed to strong light stimulation, flashing, or TV images. If you have had such an experience, always consult a doctor before using this software. If such symptoms occur while you are using it, stop at once and see a doctor.
- When using this software, keep the room well lit and sit as far from the TV screen as possible. For your health, take a 10 to 20 minute break every hour, and avoid using it when you are tired or short of sleep.

*Do not scratch or soil the disc*

Handle the disc carefully so that neither side gets scratched or dirty. Do not bend the disc or enlarge the centre hole.

*Do not write on the disc*

Do not write on either side of the disc or stick labels on it.

*Cleaning the disc*

Wipe it gently with a soft cloth such as a lens-cleaning cloth, in straight lines from the centre outwards. Do not use thinners, benzine or the like.

*Take care where you store it*

After use, put the disc back in its case and store it away from high temperatures and humidity.

*[Boxed notes:]* The SEGA SATURN CD is software for the SEGA SATURN only. Using it in an ordinary CD player and the like may damage headphones or speakers, so never do so. Connecting the SEGA SATURN to a projection TV (a TV that projects onto a screen) may cause screen burn from after-images, so do not connect it to one.

- This SEGA SATURN CD works with SEGA SATURN consoles for use in Japan bearing the SEGA SATURN mark or the NTSC J label. The V-SATURN and Hi-SATURN are compatible with the SEGA SATURN.
- ■ Always read the instruction manuals for the SEGA SATURN console and any peripherals you use as well.
- ■ Copying this disc without permission or using it for rental is prohibited.

Patents: U.S. Nos. 4,442,486/4,454,594/4,462,076; Europe No. 80244; Canada No. 1,183,276; Hong Kong No. 88-4302; Singapore No. 88-155; U.K. No. 1,535,999

**User support**

We cannot answer any questions by telephone, letter or otherwise about the content of this game or hints for it. If anything about this product is unclear, please contact:

ASCII Corporation, User Support, Mikami Building, 1-18-10 Wakabayashi, Setagaya-ku, Tokyo 154-0023. TEL 03-5351-8499 or 03-5433-7152 (10:00–12:00 and 13:00–17:00, except Saturdays, Sundays and public holidays).

Using this software or its manual for rental is prohibited. Except for personal use of all or part of this software and its manual, copying or reproducing them by any means without the written permission of ASCII Corporation and the rights holders is prohibited.

ASCII Entertainment home page: http://www.ascii.co.jp/et/ · ASCII Corporation, 4-33-10 Yoyogi, Shibuya-ku, Tokyo 151-8024

- \* "BASIC/ベーシック" is a registered trademark of ASICS Corporation.
- \* Microsoft® Windows95® is a registered trademark of Microsoft Corporation in the United States and other countries.
- \* Macintosh is a trademark of Apple Computer, Inc.

### Back cover

*[A dark background with a perspective grid of light lines.]*

This product is software for the SEGA SATURN only; SEGA Enterprises, Ltd. has licensed the use of its registered trademark SEGA for it.

T-2111G · ©1998 ASCII Corp./Bits Laboratory/ESP inc. · ASCII Corporation, 4-33-10 Yoyogi, Shibuya-ku, Tokyo 151-8024
