MSLD can be excuted as followings:

*************************************************************
Step1: 	Line/Curve Detecting(matlab)
       	Find and Open the file wzhFindLineSegs.m
	Inpute the image path
		filename = 'D:\MSLD\ImageAndResult\L001_A.jpg';
		filename = 'D:\MSLD\ImageAndResult\L001_B.jpg';
	Inpute the result path
		SaveName1 = 'D:\MSLD\ImageAndResult\L001_A.txt';
    		SaveName2 = 'D:\MSLD\ImageAndResult\L001_MA.txt';
    		SaveName3 = 'D:\MSLD\ImageAndResult\L001_MA_Count.txt'; 
		SaveName1 = 'D:\MSLD\ImageAndResult\L001_B.txt';
    		SaveName2 = 'D:\MSLD\ImageAndResult\L001_MB.txt';
   		SaveName3 = 'D:\MSLD\ImageAndResult\L001_MB_Count.txt';
	Run the program (F5) and the detected lines/curves will be stored in the files: 
			L001_A.txt;L001_MA.txt;L001_MA_Count.txt 
			L001_B.txt;L001_MB.txt;L001_MB_Count.txt;

*************************************************************
Step2: Line/Curve Matching(VC2008)
	open the file:	D:\MSLD\MSLD_Step2_Match\TianMatch.sln
	rebiuld and run the project and the matching result will be stored in the file:
	"D:\\MSLD\\ImageAndResult\\L001_MatchAB.txt";



*************************************************************
Step3: Line/Curve Matching Result Showing(matlab)
	Find and run the file ShowLineMatches.m

*************************************************************

Note:	MSLD need opencv support.