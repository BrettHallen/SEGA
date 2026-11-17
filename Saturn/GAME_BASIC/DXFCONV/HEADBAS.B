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
