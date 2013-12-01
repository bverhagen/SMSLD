//descriptor.cpp
#pragma  once
#include "stdafx.h"
#include "descriptor.h"
#include "wzhlib.h"
#include <math.h>


SCNo	LUTSubRegion[360][nMaxRegionNum*nEachRPixes];	//各子区内的点
SCNo	LUTDes2Region[nMaxRegionNum*3-2];				//描述子区域
SCPos	LUTBiPos[nMaxRegionNum*nEachRPixes];
double	LUTWeight[nMaxRegionNum*nEachRPixes];

/********************************************************************************
					构造	函数
					析构	函数
********************************************************************************/
CDescriptor::CDescriptor(double* pGrayData,int nWidth,int nHegiht,double* pLinePts,int inLineCounts,int szPtsCounts[])
{
	m_nLineCount = inLineCounts;

	//计算总个数
	m_nTotolPts = 0;
	for(int i = 0; i < inLineCounts; i++)
	{
		m_nTotolPts = m_nTotolPts + szPtsCounts[i];
		m_szPtsCounts[i] = szPtsCounts[i];
	}

	//图像
	m_pImageData = NULL;
	if(pGrayData != NULL)
	{
		m_nWidth		= nWidth;
		m_nHeight		= nHegiht;
		m_nTotolPixels	= m_nWidth*m_nHeight;
		m_pImageData	= new double[m_nTotolPixels];
		memcpy(m_pImageData, pGrayData, sizeof(double)*m_nTotolPixels);
		m_pLinePts		= new double[m_nTotolPts*2];
		memcpy(m_pLinePts,pLinePts,sizeof(double)*m_nTotolPts*2);		
		m_pMainArc		= new double[m_nLineCount];
		wzhSet(m_pMainArc,0.0f,m_nLineCount);
	}

	//梯度图像
	m_pDxImage	 = new double[m_nTotolPixels];
	m_pDyImage	 = new double[m_nTotolPixels];
	m_pMagImage	 = new double[m_nTotolPixels];

	//参数
	m_fSigma	= 1.2f;
	m_scDes		= NULL;

	//描述子相关
	m_nDesDim				= nDesDim;
	m_scDes					= new float[m_nDesDim*m_nLineCount];
	m_pByValidFlag			= new byte[inLineCounts];
	memset(m_pByValidFlag,0,sizeof(byte)*inLineCounts);

	//初始化查找表
	InitializeLUT();
}

CDescriptor::~CDescriptor()
{
	//图像
	wzhFreePointer(m_pImageData);

	//直线点
	wzhFreePointer(m_pLinePts);
	wzhFreePointer(m_pByValidFlag);

	//梯度图像
	wzhFreePointer(m_pDxImage);
	wzhFreePointer(m_pDyImage);
	wzhFreePointer(m_pMagImage);

	//描述子
	wzhFreePointer(m_scDes);
	wzhFreePointer(m_pMainArc);
}

/********************************************************************************
				初始化查找表
********************************************************************************/
void  CDescriptor::InitializeLUT()
{
	//先计算0度角的点
	int nC = nMaxRegionNum*nH/2;
	for(int i = 0;i<nMaxRegionNum; i++)
		for(int j = 0; j < nH; j++)
			for(int k=0; k < nW; k++)
			{
				int temp = nW*nH*i + j*nW +k;
				LUTSubRegion[0][temp].nNo1 = k-(nW-1)/2;
				LUTSubRegion[0][temp].nNo2 = i*nH + j - nC;
			}
	
	//计算各旋转位置
	for(int i= 1;i < 360; i++)
	{	
		double dArc = -(double)(i*PI/180);
		for(int j= 0; j < nMaxRegionNum*nEachRPixes; j++)
			{
				int xx = LUTSubRegion[0][j].nNo1;
				int yy = LUTSubRegion[0][j].nNo2;
				LUTSubRegion[i][j].nNo1 = wzhRound(xx*cos(dArc) - yy*sin(dArc));
				LUTSubRegion[i][j].nNo2 = wzhRound(xx*sin(dArc) + yy*cos(dArc));
			}
	}

	//自相关
	int nDim = 0;
	for(int i = 0; i < nMaxRegionNum; i++)
	{
		LUTDes2Region[nDim].nNo1 = i;
		LUTDes2Region[nDim].nNo2 = i;
		nDim ++;
	}

	//互相关
	for(int i = 0; i < nMaxRegionNum-1; i++)
	{
		LUTDes2Region[nDim].nNo1 = i;
		LUTDes2Region[nDim].nNo2 = i+1;
		nDim ++;
		LUTDes2Region[nDim].nNo1 = i+1;
		LUTDes2Region[nDim].nNo2 = i;
		nDim ++;
	}

	//
	double dSigma = 22.0;
	int nR = (nH-1)/2;
	for(int i=0; i<nMaxRegionNum; i++)
		for(int j=0; j<nH; j++)
			for(int k=0; k<nW;k++)
			{
				int P = i*nEachRPixes + j*nW + k;
				int nNo1 = 0;
				int nNo2 = 0;
				double dCoe1 = 0;
				if(j < nR)
				{
					nNo1 = i-1;
					nNo2 = nNo1 + 1;
					dCoe1 = double(nR-j)/nH;
				}
				else if(j == nR)
				{
					nNo1 = i;
					nNo2 = i;
					dCoe1 = 1;
				}
				else
				{
					nNo1 = i;
					nNo2 = nNo1 + 1;
					dCoe1 = 1 - double(j-nR)/nH;
				}
				
				//特殊
				if(nNo1 == -1)
				{
					nNo1 = 0;
					dCoe1 = 1;
				}
				if(nNo2 == nMaxRegionNum)
				{
					nNo2	= nMaxRegionNum-1;
					dCoe1	= 0;
				}

				LUTBiPos[P].nNo1	= nNo1;
				LUTBiPos[P].nNo2	= nNo2;
				LUTBiPos[P].dCoe1	= dCoe1;
				LUTBiPos[P].dCoe2	= 1-dCoe1;

				int nC		 = (nH*nMaxRegionNum-1)/2;
				double	d	 = (double)abs(i*nH+j-nC);
				LUTWeight[P] = exp(-d*d/(2*dSigma*dSigma));
			}
}

/********************************************************************************
					直线描述子
********************************************************************************/
void  CDescriptor::ComputeLineDescriptor()
{
	//计算梯度图像
	ConputeGaussianGrad(m_pDxImage,m_pImageData,m_nWidth,m_nHeight,m_fSigma,11);
	ConputeGaussianGrad(m_pDyImage,m_pImageData,m_nWidth,m_nHeight,m_fSigma,12);
	ComputeMag(m_pMagImage,m_pDxImage,m_pDyImage,m_nTotolPixels);

	//计算每一条直线的描述子
	int nPtsPos = 0;
	double* pSubDesLineDes	= new double[nMaxRegionNum*8];
	for(int nNo = 0; nNo < m_nLineCount;nNo++)
	{
		//*************************************************
		//		1 如果直线上无效的点超过一半,则无效
		//*************************************************
		int nPtsPos_bak = nPtsPos;
		int nInValid	= 0;
		double dDxAvg	= 0;
		double dDyAvg	= 0;
		for(int nT1=0; nT1<m_szPtsCounts[nNo]; nT1++)
		{
			//获得当前点的位置信息
			int	nCenterR	= (int)m_pLinePts[2*nPtsPos];
			int	nCenterC	= (int)m_pLinePts[2*nPtsPos+1];
			int nCenterP	= nCenterR*m_nWidth + nCenterC;
			dDxAvg			= dDxAvg + m_pDxImage[nCenterP];
			dDyAvg			= dDyAvg + m_pDyImage[nCenterP];
			nPtsPos++;

			//判断是否越界
			if(	nCenterR < SCRadius+1 || nCenterR > m_nHeight-SCRadius-1 || 
				nCenterC < SCRadius+1 || nCenterC > m_nWidth-SCRadius-1)
			{
				nInValid ++;
			}
		}
		int nValid = m_szPtsCounts[nNo] - nInValid;
		if(nInValid > m_szPtsCounts[nNo]/2)
		{
			m_pByValidFlag[nNo] = 0;
			continue;
		}
		else
		{
			m_pByValidFlag[nNo] = 1;
		}
		
		//***************************************************
		//		2	计算直线的主方向
		//***************************************************
		double dMainArc = 0;
		if(matchType == 1)
			dMainArc = ComputeLineDir(&m_pLinePts[2*nPtsPos_bak],m_szPtsCounts[nNo],dDxAvg,dDyAvg);

		//***************************************************
		//		3	计算子区域描述子矩阵
		//***************************************************
		int nReCount = 0;
		nPtsPos = nPtsPos_bak;
		double* pSubDesMatrix  = new double[nMaxRegionNum*4*nValid];
		wzhSet(pSubDesMatrix,0,nMaxRegionNum*4*nValid);
		for(int nT1=0; nT1<m_szPtsCounts[nNo]; nT1++)
		{
			//获得当前点的位置信息
			int	nCenterR	= (int)m_pLinePts[2*nPtsPos];
			int	nCenterC	= (int)m_pLinePts[2*nPtsPos+1];
			int nCenterP	= nCenterR*m_nWidth + nCenterC;
			nPtsPos++;

			//判断是否越界
			if(	nCenterR < SCRadius+1 || nCenterR > m_nHeight-SCRadius-1 || 
				nCenterC < SCRadius+1 || nCenterC > m_nWidth-SCRadius-1)
			{
				continue;
			}

			//当前梯度信息
			if(matchType != 1)
			{
				dMainArc = atan2(-m_pDyImage[nCenterP],-m_pDxImage[nCenterP]);
				dMainArc = LimitArc(dMainArc);
			}

			//计算直线点描述子矩阵表
			double pSingleSubDes[nMaxRegionNum*4];
			ComputeSubRegionProjection(pSingleSubDes,dMainArc,nCenterR,nCenterC);
			memcpy(&pSubDesMatrix[nMaxRegionNum*4*nReCount],pSingleSubDes,sizeof(double)*nMaxRegionNum*4);
			nReCount++;
		}

		//***************************************************
		//		4	计算描述子并存入描述子
		//***************************************************
		ComputeDescriptorByMatrix(pSubDesLineDes,pSubDesMatrix,nMaxRegionNum*4,nValid);
		for(int g = 0; g < nMaxRegionNum*8; g++)
		{
			m_scDes[nNo*m_nDesDim+g] = (float)pSubDesLineDes[g];
		}

		//***************************************************
		//		5	释放内存
		//***************************************************
		wzhFreePointer(pSubDesMatrix);
	}
	wzhFreePointer(pSubDesLineDes);
}

/********************************************************************************
							计算直线点描述子
********************************************************************************/
void  CDescriptor::ComputeSubRegionProjection(double* pSubRegionDes,double dMainArc,int nCenterR,int nCenterC)
{
	//取出9类小区域内的的梯度
	int nMainAngle = (int)(dMainArc*180/PI);
	double* pDataDx = new double[nMaxRegionNum*nEachRPixes];
	double* pDataDy = new double[nMaxRegionNum*nEachRPixes];
	for(int i=0; i<nMaxRegionNum; i++)
		for(int j=0; j<nEachRPixes; j++)
		{
			int k = i*nEachRPixes + j;
			int rr = LUTSubRegion[nMainAngle][k].nNo1 + nCenterR;
			int cc = LUTSubRegion[nMainAngle][k].nNo2 + nCenterC;
			int kk = rr*m_nWidth+cc;
			
			if(kk < 0 || kk > m_nTotolPixels-1)
			{
				continue;
			}
			pDataDx[k] = m_pDxImage[kk];
			pDataDy[k] = m_pDyImage[kk];
		}

	//主方向
	double dLineVx = cos(dMainArc);
	double dLineVy = sin(dMainArc);

	//计算每一类的四个分量
	for(int i=0; i< 4*nMaxRegionNum; i++)
	{
		pSubRegionDes[i] = 0;
	}
	for(int i=0; i<nMaxRegionNum*nEachRPixes; i++)
	{
		//梯度加权
		double dx = pDataDx[i]*LUTWeight[i];
		double dy = pDataDy[i]*LUTWeight[i];
		double IP = dx*dLineVx + dy*dLineVy;
		double EP = dx*dLineVy - dy*dLineVx;

		//查表获得最接近的2区域和相应的权值
		int nNo1 = LUTBiPos[i].nNo1;
		int nNo2 = LUTBiPos[i].nNo2;
		double dCoe1 = LUTBiPos[i].dCoe1;
		double dCoe2 = LUTBiPos[i].dCoe2;
		
		//累加到区域1上
		if(IP > 0)
		{
			pSubRegionDes[4*nNo1]	 = pSubRegionDes[4*nNo1] + IP*dCoe1;
		}
		else
		{
			pSubRegionDes[4*nNo1+2]	 = pSubRegionDes[4*nNo1+2] + abs(IP*dCoe1);
		}
		if(EP > 0)
		{
			pSubRegionDes[4*nNo1+1]	 = pSubRegionDes[4*nNo1+1] + EP*dCoe1;
		}
		else
		{
			pSubRegionDes[4*nNo1+3]	 = pSubRegionDes[4*nNo1+3] + abs(EP*dCoe1);
		}

		//累加到区域2上
		if(IP > 0)
		{
			pSubRegionDes[4*nNo2]	 = pSubRegionDes[4*nNo2] + IP*dCoe2;
		}
		else
		{
			pSubRegionDes[4*nNo2+2]	 = pSubRegionDes[4*nNo2+2] + abs(IP*dCoe2);
		}
		if(EP > 0)
		{
			pSubRegionDes[4*nNo2+1]	 = pSubRegionDes[4*nNo2+1] + EP*dCoe2;
		}
		else
		{
			pSubRegionDes[4*nNo2+3]	 = pSubRegionDes[4*nNo2+3] + abs(EP*dCoe2);
		}

	}
	/***********************************************************************/
	//释放内存
	wzhFreePointer(pDataDx);
	wzhFreePointer(pDataDy);
}

/********************************************************************************
根据描述子矩阵计算描述子
********************************************************************************/
void  CDescriptor::ComputeDescriptorByMatrix(double* pLineDes,double* pMatrix,int nD,int nValid)
{
	//计算均值
	double* pAvg = new double[nD];
	wzhSet(pAvg,0,nD);
	for(int i = 0; i < nD; i++)
	{
		for(int j = 0; j < nValid; j++)
		{
			int k = j*nD + i;
			pAvg[i] = pAvg[i] + pMatrix[k];
		}
	}
	for(int i = 0; i < nD; i++)
	{
		pAvg[i] = pAvg[i]/nValid;
	}

	//计算标准差
	double* pStd = new double[nD];
	wzhSet(pStd,0,nD);
	for(int i = 0; i < nD; i++)
	{
		for(int j = 0; j < nValid; j++)
		{
			int k = j*nD + i;
			double dVar = (pMatrix[k]-pAvg[i])*(pMatrix[k]-pAvg[i]);
			pStd[i] = pStd[i] + dVar;
		}
	}
	for(int i = 0; i < nD; i++)
	{
		pStd[i] = sqrt(pStd[i]/nValid);
	}

	//分别归一化
	wzhNormorlizeNorm(pAvg,nD);
	wzhNormorlizeNorm(pStd,nD);

	//描述子
	for(int i = 0; i < nD; i++)
	{
		if(pAvg[i] < 0.4)
			pLineDes[i]		= pAvg[i];
		else
			pLineDes[i]		= 0.4;
		if(pStd[i] < 0.4)
			pLineDes[nD+i]	= pStd[i];
		else
			pLineDes[nD+i]	= 0.4;
	}

	wzhNormorlizeNorm(pLineDes,2*nD);

	//释放内存
	wzhFreePointer(pStd);
	wzhFreePointer(pAvg);
}

double  CDescriptor::ComputeLineDir(double* pLinePts,int nCount,double dDxAvg, double dDyAvg)
{
	//利用最小二乘技术求方向
	initM(MATCOM_VERSION);
	Mm mMatrix = zeros(nCount,3);
	for(int g1 = 0; g1 < nCount; g1++)
	{
		mMatrix.r(g1+1,1) = pLinePts[2*g1];
		mMatrix.r(g1+1,2) = pLinePts[2*g1+1];
		mMatrix.r(g1+1,3) = 1;
	}

	//奇异值分解获得精确位置
	Mm u,s,v;
	i_o_t i_o = {0,0};
	svd(mMatrix,i_o,u,s,v);

	//计算方向
	double a = v.r(1,3);
	double b = v.r(2,3);
	double dMainArc = atan2(-b,a);
	dMainArc = LimitArc(dMainArc);

	//退出
	exitM();

	//判定方向
	double dMainArc1 = dMainArc - PI/2;
	dMainArc1 = LimitArc(dMainArc1);
	double dMainArc2 = dMainArc + PI/2;
	dMainArc2 = LimitArc(dMainArc2);
	double dAvgArc = atan2(-dDyAvg,-dDxAvg);
	dAvgArc = LimitArc(dAvgArc);

	double error1 = ArcDis(dMainArc1,dAvgArc);
	double error2 = ArcDis(dMainArc2,dAvgArc);

	//返回最终方向
	double nArcReturn = dMainArc1;
	if(error1 > error2)
		nArcReturn = dMainArc2;

	return nArcReturn;
}