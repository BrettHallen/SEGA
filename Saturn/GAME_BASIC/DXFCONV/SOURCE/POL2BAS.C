#include <stdio.h>
#include <stdlib.h>
#include <math.h>


FILE    *datain;
FILE    *dataout;
FILE *dataout2;

double          lx[3000],ly[3000],lz[3000];
/* double          lx[2000],ly[2000],lz[2000]; */
int                     p1[1000],p2[1000],p3[1000],p4[1000];
int                     pn,sn;
int                     lineno = 10010;
int                     lineno2 = 20010;

char            layern[255];
int                     pcolor,ptn;

//char          *layerlist[100];
//void  checklayer()
//{
//}


void    checkpoint(int polpoint)
{
        int     i,tp;
        double  x,y,z;

        if      (pn < 3) {
                                fscanf (datain," %lf %lf %lf ",&x,&y,&z);
                                lx[pn] = x;
                                ly[pn] = y;
                                lz[pn] = z;
                        pn=pn+1;

                        if (polpoint == 0) p1[sn] = pn-1;
                        if (polpoint == 1) p2[sn] = pn-1;
                        if (polpoint == 2) p3[sn] = pn-1;
                        if (polpoint == 3) p4[sn] = pn-1;
                        return;
                
                        }

        
        fscanf (datain," %lf %lf %lf ",&x,&y,&z);

        tp = -1;
                for(i=0;i<pn;i++){
                        if (x == lx[i] && y == ly[i] && z == lz[i]) tp = i;
                        }

        if ( tp == -1){

                                lx[pn] = x;
                                ly[pn] = y;
                                lz[pn] = z;
                                pn=pn+1;
                
                        if (polpoint == 0) p1[sn] = pn-1;
                        if (polpoint == 1) p2[sn] = pn-1;
                        if (polpoint == 2) p3[sn] = pn-1;
                        if (polpoint == 3) p4[sn] = pn-1;

                }
                else{
                        
                        if (polpoint == 0) p1[sn] = tp;
                        if (polpoint == 1) p2[sn] = tp;
                        if (polpoint == 2) p3[sn] = tp;
                        if (polpoint == 3) p4[sn] = tp;

                }
}



#define		MAX_INFILE	1		/* 同時にオープンできる入力ファイル		*/
#define		MAX_OUTFILE	2		/* 同時にオープンできる出力ファイル		*/

char	*default_name = "DAT";
char	*extension = "DXF";

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

char	*p;					/* コマンドラインのポインタ用ワーク		*/
int             i;
int             ln1,ln2;

ln1 = 10000;
ln2 = 20000;

puts("POL2bas.exe Ver 1.00\n",stdout);

	if ( argc >= 2 ){				/* コマンドラインに何かあるとき		*/
		while( --argc ){			
			p = *++argv;
			strcpy( infile[0].filename, p );				/* ファイル名のコピー	 		*/
			_splitpath( p, drive, dir, infile[0].name, infile[0].ext );	/* ファイル名と、拡張子の切出し		*/
			if ( strlen( infile[0].ext ) <= 1 ){
				strcpy( infile[0].ext, "POL" );
			}
			if ( strlen( infile[0].name ) <= 1 ){				/* 拡張子がないときは			*/
				strcpy( infile[0].name, "DAT" );			/* デフォルトの拡張子を付ける		*/
			}
			_makepath( infile[0].filename, drive, dir, infile[0].name, infile[0].ext );
			strcpy( outfile[0].ext, "VTX" );
			strcpy( outfile[1].ext, "PNT" );
			strcpy( outfile[0].name, infile[0].name );
			strcpy( outfile[1].name, infile[0].name );
			_makepath( outfile[0].filename, drive, dir, outfile[0].name, outfile[0].ext );
			_makepath( outfile[1].filename, drive, dir, outfile[1].name, outfile[1].ext );
			
			
			if( (datain = fopen( &infile[0].filename,"rt"))  == NULL){printf("READ OPEN error\n", &infile[0].filename);exit(0);}
			if( (dataout = fopen( &outfile[0].filename,"wt"))  == NULL){printf("WRITE OPEN error\n");exit(0);}
			if( (dataout2 = fopen( &outfile[1].filename,"wt"))  == NULL){printf("WRITE OPEN error\n");exit(0);}
			break;
		}
	} else {
		if( (datain = fopen("DAT.POL","rt"))  == NULL){printf("FILE OPEN error\n");exit(0);}
		if( (dataout = fopen("DAT.VTX","wt"))  == NULL){printf("FILE OPEN error\n");exit(0);}
		if( (dataout2 = fopen("DAT.PNT","wt"))  == NULL){printf("EILE OPEN error\n");exit(0);}
	}




sn = 0;
i=0;
pn = 0;

while (i !=-1){
        fscanf(datain,"%d",&i);
        fscanf(datain,"%d\n",&ptn);
        fgets(layern,255,datain);
        fscanf(datain,"%d",&pcolor);
        
//      printf("%s",layern);
        
        if( i != -1){
                checkpoint (0);
                checkpoint (1);
                checkpoint (2);
                checkpoint (3);
                sn++;
                }
        }


fprintf (dataout,"%d REM  ----------\n",ln1);
fprintf (dataout2,"%d REM ----------\n",ln2);

ln1++;
ln2++;

fprintf (dataout,"%d DATA  %d\n",ln1,pn);
fprintf (dataout2,"%d DATA %d\n",ln2,sn);

ln1++;
ln2++;


for     (i=0; i < pn; i++){
        fprintf (dataout,"%d DATA %lf , %lf , %lf\n",ln1,lx[i],ly[i],lz[i]);
        ln1++;
        }

for (i=0; i < sn; i++){
        
        if (p3[i]== p4[i]){
                fprintf(dataout2,"%d DATA , (%d,%d,%d)\n",ln2,p1[i],p2[i],p3[i]);
                }
        else{
                fprintf(dataout2,"%d DATA , (%d,%d,%d,%d)\n",ln2,p1[i],p2[i],p3[i],p4[i]);
                }

        ln2++;

}



fclose(datain);
fclose(dataout);
fclose(dataout2);


        exit(0);
}
