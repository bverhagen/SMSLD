//descriptor.h
/***************************************************************
函数名: CDescriptor
描述：	该类利用内外积计算图像中一点的描述子
输入：
输出：	
作者：	zhwang
邮件：	zhwang@nlpr.ia.ac.cn
日期：	06.12.30
最后修改：
调试：	
***************************************************************/
#include "stdafx.h"
#include "cv.h"
#include "highgui.h"
#include "wzhlib.h"

typedef struct SCNo
{
	int		nNo1;									// 第1个区域号
	int		nNo2;									// 第2个区域号
} SCNo;

typedef struct SCPos
{
	int		nNo1;									// 第1个区域号
	int		nNo2;									// 第2个区域号
	double	dCoe1;
	double	dCoe2;
} SCPos;

class CDescriptor
{	
	//参数
	public:
		double		m_fSigma;						//高斯滤波尺度
	public:
		//图像信息
		double*		m_pImageData;					//图像数据
		int			m_nWidth;						//图像高度
		int			m_nHeight;						//图像宽度
		int			m_nTotolPixels;					//图像总像素数
		
		//角点信息
		int			m_nLineCount;					//直线数量
		int			m_nTotolPts;					//所有直线上的点总个数
		int			m_szPtsCounts[nMaxLineCount];	//各个直线上点的个数
		double*		m_pLinePts;						//点的位置信息
		
		//梯度
		double*		m_pDxImage;						//dx图像
		double*		m_pDyImage;						//dy图像
		double*		m_pMagImage;					//梯度幅值
				
		//描述子信息
		float*		m_scDes;						//Std总描述子
		int			m_nDesDim;						//描述子维数
		byte*		m_pByValidFlag;					//标记角点是否有效
		double*		m_pMainArc;						//每条直线的主方向

	//函数成员
	public:
		CDescriptor(double* pGrayData,int nWidth,int nHegiht,
					double* pLinePts,int inLineCounts,int szPtsCounts[]);
		~CDescriptor();

		//计算描述子
		void	ComputeLineDescriptor();
		
	private:
		void	InitializeLUT();
		void	ComputeDescriptorByMatrix(double* pLineDes,double* pMatrix,int nD,int nValid);
		void	ComputeSubRegionProjection(double* pDesMatrix,double dMainArc,int nCenterR,int nCenterC);

		//计算内积和外积
		double	ComputeLineDir(double* pLinePts,int nCount,double dDxAvg, double dDyAvg);
};
