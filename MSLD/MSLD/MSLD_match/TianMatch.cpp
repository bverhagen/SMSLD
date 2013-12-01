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

int MatchLineBySC(char* txtFilename1,char* txtFilename2,
				  char* txtSaveFile,double fDistinctive);

int _tmain(int argc, char* argv[])
{
	char * txtFilename1;
	char * txtFilename2;
	char * txtSaveFileSc;

	if(argc == 4) {
		txtFilename1 = argv[1];
		txtFilename2 = argv[2];
		txtSaveFileSc = argv[3];
	} else {
		printf("Usage: TianMatch.exe <path_to_descriptor_image1> <path_to_descriptor_image2> <path_to_results_file>");
		return 1;
	}
	
	double fDistinctive = 0.8;
	MatchLineBySC(txtFilename1,txtFilename2,txtSaveFileSc,fDistinctive);
	return 1;
}

int MatchLineBySC(char* txtFilename1,char* txtFilename2,
					 char* txtSaveFile,double fDistinctive)
{
	DWORD dStart = GetTickCount();

	byte*  pByValidFlag1 = new byte[nMaxLineCount];
	float * pDes1 = new float[nDesDim*nMaxLineCount];
	int * szCountForEachLine1 = new int[nMaxLineCount];

	int nLineCount1 = loadDescriptor(pDes1, pByValidFlag1,szCountForEachLine1, txtFilename1);

	byte*  pByValidFlag2 = new byte[nMaxLineCount];
	float * pDes2 = new float[nDesDim*nMaxLineCount];
	int * szCountForEachLine2 = new int[nMaxLineCount];
	int nLineCount2 = loadDescriptor(pDes2, pByValidFlag2, szCountForEachLine2, txtFilename2);

	/******************************************************************************
						进行匹配并保存结果
	******************************************************************************/
	//printf("%s","matching...\n");
	int nMaxMatchNum = max(nLineCount1,nLineCount2);
	double* pMatches  = new double[nMaxMatchNum*2];
	int nMatchCount = 0;
	matchDes(pMatches,nMatchCount,nDesDim,fDistinctive,
			 pDes1,nLineCount1,pByValidFlag1,szCountForEachLine1,
			 pDes2,nLineCount2,pByValidFlag2,szCountForEachLine2);

	/******************************************************************************

						输出结果并释放内存

	******************************************************************************/
	wzhOut(txtSaveFile,pMatches,2,nMatchCount);
	wzhFreePointer(pDes1);
	wzhFreePointer(pDes2);
	wzhFreePointer(szCountForEachLine1);
	wzhFreePointer(szCountForEachLine2);
	wzhFreePointer(pByValidFlag1);
	wzhFreePointer(pByValidFlag2);
	wzhFreePointer(pMatches);

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
	return nMatchCount;
}