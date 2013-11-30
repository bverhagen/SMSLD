===== SOFTWARE =====
This software contains the SMSLD implementation as proposed by 
Bart Verhagen, Radu Timofte (radu.timofte@esat.kuleuven.be) and 
Luc Van Gool (luc.vangool@esat.kuleuven.be). The current implementation
is based on the MSLD implementation of Zhiheng Wang (zhwang@nlpr.ia.ac.cn), 
Fuchao Wu and Zhanyi Hu.

This software contains the SMSLD descriptor. The SMSLD descriptor is a scale-invariant 
line segment descriptor for wide baseline matching. More info can be found in the paper
about SMSLD.

All comments can be addressed to barrie.verhagen@gmail.com.

===== Requirements =====
 - MATLAB
 - OpenCV
 - Preferably Microsoft Visual Studio

===== How to install =====
 - Change the *.props files in SMSLD/opencv to point to your openCV implementation.
 - Compile the SMSLD/SMSLD/SMSLD_Step2_Match/TianMatch.sln project using Visual Studio.
 - Change in matlab/workspace/testbench/SMSLD/testSMSLD.m and 
	matlab/workspace/testbench/SMSLD/testBenchmark.m the 'path_to_exe' variable to
	point to the binary created during the compilation of the TianMatch.sln project.
 - Run testSMSLD using matlab.