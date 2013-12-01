// TianMatch.cpp : Defines the entry point for the console application.
//
#include "stdafx.h"

#include "cv.h"
#include "highgui.h"

#include "wzhlib.h"
#include "descriptor.h"
#include "Match.h"

#include <string.h>
#include <fstream>

#pragma comment(lib, "v4500v.lib")

int MatchLineBySC(char* imageFilename1,char* imageFilename2,
				  char* txtFilename1,char* txtFilename2,
				  char* txtSaveFile,double fDistinctive);

int _tmain(int argc, char* argv[])
{
	char * imageFilename1;
	char * imageFilename2;
	char * txtFilename1;
	char * txtFilename2;
	char * txtSaveFileSc;

	if(argc >= 6) {
		imageFilename1 = argv[1];
		imageFilename2 = argv[2];
		txtFilename1 = argv[3];
		txtFilename2 = argv[4];
		txtSaveFileSc = argv[5];
	} else {
		printf("Usage: TianMatch.exe <path_to_image1> <path_to_image2> <path_to_txt_image1> <path_to_txt_image2> <path_to_results_file>");
		return 1;
	}
	
	double fDistinctive = 0.8;
	MatchLineBySC(imageFilename1,imageFilename2,txtFilename1,txtFilename2,txtSaveFileSc,fDistinctive);
	return 1;
}

int MatchLineBySC(char* imageFilename1,char* imageFilename2,
					 char* txtFilename1,char* txtFilename2,
					 char* txtSaveFile,double fDistinctive)
{
	DWORD dStart = GetTickCount();
	char * txtDescriptor1="Descriptor1.txt";
	char * txtDescriptor2="Descriptor2.txt";

	/******************************************************************************

									处理第1幅图像

	******************************************************************************/
	//读入图像1
	double* pImageData1	= NULL;
	int nWidth1			= 0;
	int nHeight1		= 0;
	if(!wzhLoadImage(pImageData1,nWidth1,nHeight1,imageFilename1))
	{
		return 0;
	}

	//读入文本文件1
	int nLineCount1		= 0;
	int szCountForEachLine1[nMaxLineCount];
	double* pLinePts1	= NULL;
	if(!LoadLineTxt(pLinePts1,nLineCount1,szCountForEachLine1,txtFilename1))
	{
		return 0;
	}	

	//计算描述子1
	//printf("%s %d %s","Computing descriptor for ", nLineCount1," lines in image 1...\n");
	float* pDes1 = NULL;
	byte*  pByValidFlag1 = new byte[nLineCount1];
	pDes1 = new float[nDesDim*nLineCount1];
	ComputeDes(	pDes1,pByValidFlag1,
				pImageData1,nWidth1,nHeight1,
				pLinePts1,nLineCount1,szCountForEachLine1);

	// Write to file
	if(!SaveDescriptor(pDes1, nLineCount1, pByValidFlag1, szCountForEachLine1,txtDescriptor1))
	{
		return 0;
	}

	/******************************************************************************

								处理第2幅图像

	******************************************************************************/
	//读入图像2
	double* pImageData2	= NULL;
	int nWidth2			= 0;
	int nHeight2		= 0;
	if(!wzhLoadImage(pImageData2,nWidth2,nHeight2,imageFilename2))
	{
		return 0;
	}

	//读入文本文件2
	int nLineCount2		= 0;
	int szCountForEachLine2[nMaxLineCount];
	double* pLinePts2	= NULL;
	if(!LoadLineTxt(pLinePts2,nLineCount2,szCountForEachLine2,txtFilename2))
	{
		return 0;
	}
	
	//计算描述子2
	//printf("%s %d %s","Computing descriptor for ", nLineCount2," lines in image 2...\n");
	float* pDes2 = NULL;
	byte*  pByValidFlag2 = new byte[nLineCount2];
	pDes2 = new float[nDesDim*nLineCount2];
	ComputeDes(	pDes2,pByValidFlag2,
				pImageData2,nWidth2,nHeight2,
				pLinePts2,nLineCount2,szCountForEachLine2);

	if(!SaveDescriptor(pDes2, nLineCount2, pByValidFlag2, szCountForEachLine2,txtDescriptor2))
	{
		return 0;
	}

	wzhFreePointer(pImageData1);
	wzhFreePointer(pImageData2);
	wzhFreePointer(pLinePts1);
	wzhFreePointer(pLinePts2);
	wzhFreePointer(pDes1);
	wzhFreePointer(pDes2);
	wzhFreePointer(pByValidFlag1);
	wzhFreePointer(pByValidFlag2);

	/******************************************************************************

										完成

	******************************************************************************/
	//printf("%d %s",nMacthCount, "matches are found!\n");
	DWORD dEnd	  = GetTickCount();
	float fCost  = (float)(dEnd-dStart)/1000.0f;
	ofstream fp1;
	fp1.open("Elapsed_time.txt");
	fp1 << fCost;
	fp1.close();
	return 0;
}