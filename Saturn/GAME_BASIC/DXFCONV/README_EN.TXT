DXFCONV README: Japanese original with English translation
Source: README_JP.TXT (Shift-JIS). Each Japanese line is followed by its English translation
on a line starting with 'EN: ', indented like the original. Lines with no Japanese appear once, unchanged.
================================================================================


DXFファイルからＧＡＭＥ ＢＡＳＩＣ ｆｏｒ ＳＥＧＡＳＡＴＵＲＮへのデータコンバータ
EN: Data converter from DXF files to GAME BASIC for SEGA SATURN

――――――――――――――――――――――――――――――――――――――――――――――――
	Ｗｉｎ９５バージョン
	EN: Win95 version
――――――――――――――――――――――――――――――――――――――――――――――――
【概要】
EN: [Overview]
ＤＸＦＣＯＮＶ．ｅｘｅ        ＤＸＦファイルから“3Dface”情報を抜き出しGAME BASIC for
EN: DXFCONV.exe        A tool that extracts "3Dface" information from a DXF file and creates a text file in GAME BASIC for
                               SEGASATURNフォーマットのテキストファイルを作成するツール。
                               EN: SEGA SATURN format.
                              又、選択により標準表示プログラムを先頭に付加する事も可能。
                              EN: Optionally, it can also prepend a standard display program.

    【実行方法】
    EN: [How to run]
     [スタート]メニューの[Dxfconv]から[DXFCONV]をクリックしてください。
     EN: From the [Start] menu, choose [Dxfconv] and click [DXFCONV].
        変換元のファイル名を指定してください。
        EN: Specify the source file name.
        変換先のファイル名を指定してください。指定しない場合は、変換元のファイル名の拡張子を
        EN: Specify the destination file name. If you don't specify one, the output uses the source file name with the extension
        “.B”として出力されます。
        EN: ".B".
        “変換実行”をクリックすると変換を開始します。
        EN: Click "Convert" (変換実行) to start the conversion.
        “ファイルが変換されました”のダイアログが表示されたら変換終了です。
        EN: The conversion is finished when the "The file has been converted" dialog appears.
        “終了”をクリックしてDXFCONV.EXEを終了してください。
        EN: Click "Exit" (終了) to quit DXFCONV.EXE.
        又、“表示プログラムを付加する”のチェックボックスを選択していると標準表示プログラム
        EN: Also, if the "Add display program" (表示プログラムを付加する) checkbox is selected, the standard display program
       “HEADBAS.B”を先頭に付加し、このままGAME BASIC for SEGASATURNへ転送して実行すること
       EN: "HEADBAS.B" is prepended, so the result can be sent straight to GAME BASIC for SEGA SATURN and run
        が可能です。
        EN: as-is.
        尚、付加するプログラムはユーザーの書き換えが可能です。（ファイルネーム固定）
        EN: The prepended program can be edited by the user. (The file name is fixed.)

    複数のグループ情報を使用している（ポリゴンを分割している）場合は“変換実行（グループ情報
    EN: If you use multiple group information (i.e. the polygons are split into groups), run "Convert (with group
    対応）を実行してください。
    EN: information)" (変換実行（グループ情報対応）).
    注意）
    EN: Note:
        グループ情報対応“変換実行”は表示プログラムの付加は出来ません。表示する場合は、ユー
        EN: The group-information "Convert" cannot prepend the display program. If you want to display the result, write
        ザー自身で表示プログラムを作成してください。
        EN: a display program yourself.
        但し、複数のグループ情報を使用していても通常の“変換実行”は可能です。その場合は表示 
        EN: However, the normal "Convert" can still be used even when multiple group information is used. In that case the display
        プログラムの付加は可能です。
        EN: program can be prepended.

【注意】
EN: [Caution]
    ＤＸＦファイルの１行の単位に注意してください。
    EN: Pay attention to the line format of the DXF file.
    １行の終了条件は[CR]+[LF]となっておりますので、Ｍａｃ等で作成したＤＸＦファイルの変換を
    EN: Lines must end with [CR]+[LF], so when converting a DXF file created on a Mac etc., first convert
    する場合には１行の終了条件を[CR]から[CR]+[LF]へ変換するツール等で変換してから、このコン
    EN: the line endings from [CR] to [CR]+[LF] with a suitable tool, and then run this
    バーターを実行してください。
    EN: converter.

――――――――――――――――――――――――――――――――――――――――――――――――
	ＤＯＳバージョン
	EN: DOS version
――――――――――――――――――――――――――――――――――――――――――――――――
【概要】
EN: [Overview]
ＤＸＦ２ｐｏｌ．ｅｘｅ        ＤＸＦファイルから“3Dface”情報を抜き出しテキストファイル
EN: DXF2pol.exe        A converter that extracts "3Dface" information from a DXF file and creates a text file
                              （＊．ＰＯＬ）を作成するコンバーター。
                              EN: (*.POL).
    【実行方法】
    EN: [How to run]
     コマンドプロンプトより…
     EN: From the command prompt:
         DXF2POL [<ファイル名>[.<拡張子>]]
         EN: DXF2POL [<filename>[.<extension>]]
              全てを省略した場合は “DAT.DXF"を変換します。
              EN: If everything is omitted, "DAT.DXF" is converted.
              拡張子を省略した場合は“.DXF”が付加されます。
              EN: If the extension is omitted, ".DXF" is added.

    【出力ファイル】
    EN: [Output files]
     頂点テキストデータを出力します。
     EN: Outputs vertex text data.
          <ファイル名>.POL
          EN: <filename>.POL
     ファイル名を省略した場合は、
     EN: If the file name is omitted,
          DAT.POL
     を出力します。
     EN: is output.

ＰＯＬ２ｂａｓ．ｅｘｅ        頂点情報（テキストファイル：＊．ＰＯＬ）からＢＡＳＩＣファ
EN: POL2bas.exe        A converter that creates BASIC files (*.VTX, *.PTN) from vertex information (text file: *.POL).
                              イル（＊．ＶＴＸ、＊．ＰＴＮ）を作成するコンバーター。
ＰＯＬ２ｂａｓ２．ｅｘｅ      同上ですが、グループ情報を元にオブジェクトを分割してデータ
EN: POL2bas2.exe      Same as above, but a converter that splits the data into objects based on the group information
                              を作成するコンバーター。
                              EN: when creating it.
    【実行方法】
    EN: [How to run]
     コマンドプロンプトより…
     EN: From the command prompt:
         POL2bas [<ファイル名>[.<拡張子>]]
         EN: POL2bas [<filename>[.<extension>]]
         POL2bas2 [<ファイル名>[.<拡張子>]]
         EN: POL2bas2 [<filename>[.<extension>]]
              全てを省略した場合は “DAT.POL"を変換します。
              EN: If everything is omitted, "DAT.POL" is converted.
              拡張子を省略した場合は“.POL”が付加されます。
              EN: If the extension is omitted, ".POL" is added.

    【出力ファイル】
    EN: [Output files]
     ＢＡＳＩＣテキストデータを出力します。
     EN: Outputs BASIC text data.
          <ファイル名>.VTX
          EN: <filename>.VTX
          <ファイル名>.PNT
          EN: <filename>.PNT
     ファイル名を省略した場合は、
     EN: If the file name is omitted,
          DAT.VTX
          DAT.PNT
     を出力します。
     EN: are output.
     

【詳細】
EN: [Details]
3Dモデリングソフト等で作成されたDXFファイルをGAME BASIC for SEGASATURNのVERTEXデータ、
EN: A DOS tool that converts DXF files created with 3D modelling software etc. into GAME BASIC for SEGA SATURN VERTEX data
POLYGONデータに変換するＤＯＳ用のツールです。
EN: and POLYGON data.

サポートするDXFデータは「3DFACE」のみ。
EN: The only DXF data supported is "3DFACE".

コンバーターは２パス構成となっており、
EN: The converter is made up of two passes.

１ｓｔパスでＤＸＦファイルから“３ＤＦＡＣＥ”情報を切り出します。）
EN: 1st pass: extracts the "3DFACE" information from the DXF file.)

    DXFファイルを以下のフォーマットの「.POL」ファイルにコンバートします。
    EN: Converts the DXF file into a ".POL" file in the following format.

        ポリゴンID（1から順に増加）
        EN: Polygon ID (incrementing from 1)
        頂点数（３もしくは４）
        EN: Number of vertices (3 or 4)
        DXFのグループコード8で定義されるレイヤー名
        EN: Layer name defined by DXF group code 8
        DXFのグループコード62で定義される色コード
        EN: Colour code defined by DXF group code 62
        DXFのグループコード10、20、30で定義される1点目のx座標、y座標、z座標
        EN: x, y, z coordinates of the 1st point, defined by DXF group codes 10, 20, 30
        DXFのグループコード11、21、31で定義される2点目のx座標、y座標、z座標
        EN: x, y, z coordinates of the 2nd point, defined by DXF group codes 11, 21, 31
        DXFのグループコード12、22、32で定義される3点目のx座標、y座標、z座標
        EN: x, y, z coordinates of the 3rd point, defined by DXF group codes 12, 22, 32
        DXFのグループコード13、23、33で定義される4点目のx座標、y座標、z座標
        EN: x, y, z coordinates of the 4th point, defined by DXF group codes 13, 23, 33

    ＃３頂点ポリゴンの場合は、３点目と４点目の座標値は同じになります。
    EN: # For a 3-vertex polygon, the 3rd and 4th point coordinates are the same.
    ＃終了コードは、全データに-1が入ります。
    EN: # The terminating record has -1 in every field.
    ＃3DFACEから次の3DFACEまでの間にグループコード8が無かった場合にはレイヤー名は
    EN: # If there is no group code 8 between one 3DFACE and the next, the layer name is
      default、グループコード62が無かった場合には色コードは0になります。
      EN: "default"; if there is no group code 62, the colour code is 0.

    プログラムを実行すると、変換したポリゴンIDが表示されます。
    EN: When the program runs, the IDs of the converted polygons are displayed.

２ｎｄパスで“３ＤＦＡＣＥ”情報からＢＡＳＩＣテキストファイルにコンバートします。）
EN: 2nd pass: converts the "3DFACE" information into BASIC text files.)
    「.POL」ファイルを、以下のフォーマットの「.VTX」ファイル、「.PNT」ファイルにコンバー
    EN: Converts the ".POL" file into ".VTX" and ".PNT" files in the following format.
    トします。
    ２段階目のコンバータは、入力されたファイルを一つのオブジェクトに変換するプログラムと、
    EN: Two second-stage converters are provided: one that converts the input file into a single object, and
    レイヤー名が同一の3DFACEを一つのオブジェクトにまとめて複数のオブジェクトを発生させる
    EN: one that groups 3DFACEs with the same layer name into one object each, producing multiple objects.
    プログラムの２種類用意されています。
    「.POL」ファイルのうち、色コードの情報は使用していません。また、頂点数もこのプログラ
    EN: The colour code information in the ".POL" file is not used. The vertex count is not used by this program
    ムでは利用していません。
    EN: either.


    「.VTX」ファイルフォーマット
    EN: ".VTX" file format


        10000 REM-----------
        10001 DATA N           （頂点数）
        EN: 10001 DATA N           (number of vertices)
        10002 DATA X,Y,Z　　　　（１頂点目の座標）
        EN: 10002 DATA X,Y,Z        (coordinates of the 1st vertex)
        10003 DATA X,Y,Z　　　　（２頂点目の座標）
        EN: 10003 DATA X,Y,Z        (coordinates of the 2nd vertex)
        ・・・・・・・・・
        EN: ..........

    「.PNT」ファイルフォーマット
    EN: ".PNT" file format
        20000 REM-----------
        20001 DATA N　　　　　　（ポリゴン数）
        EN: 20001 DATA N            (number of polygons)
        20002 DATA ,(A,B,C,D)　　（１枚目のポリゴンの頂点IDリスト）
        EN: 20002 DATA ,(A,B,C,D)   (vertex ID list of the 1st polygon)
        20003 DATA ,(E,F,G)　　　（２枚目のポリゴンの頂点IDリスト）
        EN: 20003 DATA ,(E,F,G)     (vertex ID list of the 2nd polygon)
        ・・・・・・・・・
        EN: ..........

    ＃複数のオブジェクトを作成するプログラムの場合には、
    EN: # For the program that creates multiple objects,
        10000 REM-----
        10001 DATA N
        10002 DATA X,Y,Z
        10003 DATA X,Y,Z
        10004 DATA X,Y,Z
        10005 DATA X,Y,Z
        10006 REM-----
        10007 DATA N
        10008 DATA X,Y,Z
        10009 DATA X,Y,Z
        10010 DATA X,Y,Z
        10011 DATA X,Y,Z
        10012 DATA X,Y,Z
        10013 REM-----
        10014 DATA N
        10015 DATA X,Y,Z
        10016 DATA X,Y,Z
        10017 DATA X,Y,Z
    のように複数のデータが連続した一つのファイルが生成されます。
    EN: a single file is generated with the multiple data sets one after another, as above.

    複数のオブジェクトを発生させるプログラムを実行した場合には、まず、元DXFファイルの中
    EN: When you run the program that creates multiple objects, it first displays the list of layer names that existed
    に存在したレイヤー名の一覧およびレイヤー数が表示されます。
    EN: in the original DXF file and the number of layers.
    GAME BASIC for SEGASATURN上でプログラムを作成する際には、このレイヤー数を元にオブジ
    EN: When writing the program in GAME BASIC for SEGA SATURN, you need to register objects based on this
    ェクトを登録する必要があります。
    EN: number of layers.


・以上のツールは、ソース公開します。（ＣＤに同梱）
EN: - The source code of the above tools is published. (Included on the CD)
・ このソースを元に、ユーザーが改良を加えることを前提としています。
EN: - It is intended that users will make their own improvements based on this source.
・ 変換ファイルのフォーマットはＤＸＦフォーマットを想定しているためそれ以外のファイルを
EN: - The converted file format assumes DXF format, so behaviour is not guaranteed if you try to convert
   変換しようとした場合の動作の保証はいたしません。
   EN: any other kind of file.


作成されたVERTEX、POINTデータを表示するプログラムのサンプルです。
EN: This is a sample program that displays the generated VERTEX and POINT data.
オブジェクトが一つの場合には、以下のサンプルプログラムに「.VTX」「.PNT」データを結合する
EN: If there is only one object, you can display it by joining the ".VTX" and ".PNT" data to the
と表示することができます。
EN: sample program below.

簡易表示プログラム"Headbas.b"
EN: Simple display program "Headbas.b"

        1000 '----------------------------------
        1010 'Polygon TEST PROGRAM
        1020 '       for
        1030 'DXFconv.exe Output file
        1040 '----------------------------------
        2000 SCREEN
        2010 READ VTN
        2020 SETVERTEX 1,VTN,READ,(5,5,5)
        2030 READ PLN
        2040 SETPOLYGON 1,PLN,1,READ
        2050 SETATR 1,PLN,(4,1,3,0,7399,8)
        2060 OBJ(1,@ATR)  = 1,1
        2070 OBJ(1,@TYPE) = 4 
        2080 OBJ(1,@XRV) = 0.002,0.001,0
        2090 '----------------------------------


詳細は、マニュアルの「SETVERTX」命令、「SETPOLYGON」命令、「SETATR」命令などを参照して
EN: For details, refer to the "SETVERTX", "SETPOLYGON" and "SETATR" instructions etc. in the manual.
ください。
頂点数や面数などをREAD命令で読み出し、SETVERTEX等でREADする際に頂点数を指定するためのデ
EN: The number of vertices, faces etc. is read with the READ instruction and used as the data that specifies the vertex count
ータとして用いる。
EN: when reading with SETVERTEX etc.
複数のオブジェクトが発生したデータの場合には、FOR-NEXTなどで複数回のSETVERTEXやSETPOLY
EN: For data that produces multiple objects, SETVERTEX and SETPOLYGON must be repeated several times with FOR-NEXT etc.
GONを繰り返す必要がある。

必要に応じてズームやオフセットをつけて読み込み、オブジェクトの親子関係を定義してください。
EN: Load with zoom or offset as needed, and define the parent-child relationships of the objects.


【注意】
EN: [Caution]
    ＤＸＦファイルの１行の単位に注意してください。
    EN: Pay attention to the line format of the DXF file.
    １行の終了条件は[CR]+[LF]となっておりますので、Ｍａｃ等で作成したＤＸＦファイルの変
    EN: Lines must end with [CR]+[LF], so when converting a DXF file created on a Mac etc., first convert
    換をする場合には１行の終了条件を[CR]から[CR]+[LF]へ変換するツール等で変換してから、
    EN: the line endings from [CR] to [CR]+[LF] with a suitable tool, and then run
    このコンバーターを実行してください。
    EN: this converter.


――――――――――――――――――――――――――――――――――――――――――――――――
	アンインストール方法
	EN: How to uninstall
――――――――――――――――――――――――――――――――――――――――――――――――
インストールしたアプリケーションを削除するには
EN: To remove the installed application, open
[コントロールパネル]の[アプリケーションの追加と削除]で
EN: [Add/Remove Programs] in the [Control Panel] and
[ＤＸＦＣＯＮＶ]を選択してください。
EN: select [DXFCONV].


(C)1998 ASCII Corp./Bits Laboratory/ESP inc.
