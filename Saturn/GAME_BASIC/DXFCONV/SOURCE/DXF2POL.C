#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

FILE    *datain;
FILE    *dataout;

char    dgc[255];
char    dgv[255];

char    layer[255];
int             pcolor;

char    cvsst[10] = "3DFACE\n";
char    cvest[10] = "EOF\n";

char    nlayer[10] = "default";
int             ncolor = 0;

int             pln;
int             cvsflag = 0;


double  px1,px2,px3,px4,py1,py2,py3,py4,pz1,pz2,pz3,pz4;

int             col;
int             polnflag;
int             cvfl;

void    rstring()
{
        int             groupcode;

        if (fgets(dgc,255,datain)== NULL){printf("error\n");exit(0);}
        if (fgets(dgv,255,datain)== NULL){printf("error\n");exit(0);}
        
        groupcode = atoi(dgc);
        
        if (groupcode == 0 && strcmp(dgv,cvsst) == 0) cvfl =1;
        if (groupcode == 0 && strcmp(dgv,cvsst) != 0) cvfl =0;
        
        
        //printf("code=%i\n",groupcode);

        if (groupcode == 10 && cvfl == 1) px1 = atof(dgv);
        if (groupcode == 20 && cvfl == 1) py1 = atof(dgv);
        if (groupcode == 30 && cvfl == 1) pz1 = atof(dgv);

        if (groupcode == 11 && cvfl == 1) px2 = atof(dgv);
        if (groupcode == 21 && cvfl == 1) py2 = atof(dgv);
        if (groupcode == 31 && cvfl == 1) pz2 = atof(dgv);

        if (groupcode == 12 && cvfl == 1) px3 = atof(dgv);
        if (groupcode == 22 && cvfl == 1) py3 = atof(dgv);
        if (groupcode == 32 && cvfl == 1) pz3 = atof(dgv);

        if (groupcode == 13 && cvfl == 1) px4 = atof(dgv);
        if (groupcode == 23 && cvfl == 1) py4 = atof(dgv);
        if (groupcode == 33 && cvfl == 1) pz4 = atof(dgv);

        if (groupcode == 62 && cvfl == 1) pcolor = atoi(dgv);
        if (groupcode == 8 && cvfl == 1) strcpy(layer,dgv);


}


void    polout()
{
        int     npt;
        
        if ((px3 == px4) && (py3 == py4) && (pz3 == pz4)) {npt = 3;}else{npt = 4;}
        
        pln++;
/*        printf("%i\n",pln);*/
                
        fprintf(dataout,"%i\n",pln);
        fprintf(dataout,"%i\n",npt);
        fprintf(dataout,"%s",layer);
        fprintf(dataout,"%i\n",pcolor);
        fprintf(dataout,"%lf  %lf  %lf\n",px1,py1,pz1);
        fprintf(dataout,"%lf  %lf  %lf\n",px2,py2,pz2);
        fprintf(dataout,"%lf  %lf  %lf\n",px3,py3,pz3);
        fprintf(dataout,"%lf  %lf  %lf\n",px4,py4,pz4);
        
}


void    convpol()
{
        if (cvsflag == 1) polout();     
        cvsflag =1;
        
        px1 = 0;   py1 = 0;   pz1 = 0;
        px2 = 0;   py2 = 0;   pz2 = 0;
        px3 = 0;   py3 = 0;   pz3 = 0;
        px4 = 0;   py4 = 0;   pz4 = 0;
        
        pcolor = ncolor;
        strcpy(layer,nlayer);
        
}


#define		MAX_INFILE	1		/* 同時にオープンできる入力ファイル		*/
#define		MAX_OUTFILE	1		/* 同時にオープンできる出力ファイル		*/


typedef struct {				/* ファイル名とハンドルの構造体			*/
	char	filename[_MAX_PATH];		/* フルパスで格納できるエリアと			*/
	char	name[9];			/* フルパスから分解したファイルネームのみ	*/
	char	ext[5];				/* フルパスから分解した拡張子のみ (.???)	*/
	int	handle;				/* それに対応したハンドルを格納出来る		*/
} FTBL;						/* 						*/

FTBL	infile[MAX_INFILE];			/* オープンする数だけエリアを確保		*/
FTBL	outfile[MAX_OUTFILE];			/* オープンする数だけエリアを確保		*/
char	drive[64];				/* ドライブの展開エリア				*/
char	dir[64];				/* ディレクトリの展開エリア			*/

void main( int argc, char *argv[] )
{
int i;

char	*p;					/* コマンドラインのポインタ用ワーク		*/


i = 0;
pln = 0;
puts("DXF2pol.exe Ver 1.00\n",stdout);

	if ( argc >= 2 ){				/* コマンドラインに何かあるとき		*/
		while( --argc ){			
			p = *++argv;
			strcpy( infile[0].filename, p );				/* ファイル名のコピー	 		*/
			_splitpath( p, drive, dir, infile[0].name, infile[0].ext );	/* ファイル名と、拡張子の切出し		*/
			if ( strlen( infile[0].ext ) <= 1 ){
				strcpy( infile[0].ext, "DXF" );
			}
			if ( strlen( infile[0].name ) <= 1 ){				/* 拡張子がないときは			*/
				strcpy( infile[0].name, "DAT" );			/* デフォルトの拡張子を付ける		*/
			}
			_makepath( infile[0].filename, drive, dir, infile[0].name, infile[0].ext );
			strcpy( outfile[0].ext, "POL" );
			strcpy( outfile[0].name, infile[0].name );
			_makepath( outfile[0].filename, drive, dir, outfile[0].name, outfile[0].ext );
			
			if( (datain = fopen( &infile[0].filename,"rt"))  == NULL){printf("READ OPEN error\n", &infile[0].filename);exit(0);}
			if( (dataout = fopen( &outfile[0].filename,"wt"))  == NULL){printf("WRITE OPEN error\n");exit(0);}
			break;
		}
	} else {
		if( (datain = fopen("DAT.DXF","rt"))  == NULL){printf("READ OPEN error\n");exit(0);}
		if( (dataout = fopen("DAT.POL","wt"))  == NULL){printf("WRITE OPEN error\n");exit(0);}
	}



while ( i == 0 ){

rstring();

if(strcmp(dgv,cvsst) == 0 ) convpol();
if(strcmp(dgv,cvest) == 0 ) i=1;


}

        if(cvsflag == 1)polout();

fprintf(dataout,"-1\n-1\n-1\n-1\n-1 -1 -1\n-1 -1 -1\n-1 -1 -1\n-1 -1 -1 \n");


fclose(datain);
fclose(dataout);


        exit(0);
}
