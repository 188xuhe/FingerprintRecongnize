clc
clear
close all

%%
%[filename, pathname, filterindex] = uigetfile('H:\Detect_Point\MNet\Dataset\CoarseNet_test\img_files\*.*', 'Ñ¡ÔñĞè×¢²áÖ¸ÎÆ');
image=imread("H:\Detect_Point\FingerNet\output\20191122-200524\fvc2006_DB4_A\seg_results\3_9_seg.png");
figure, imshow(image,[0 255])

%%
% T = graythresh(image)+0.13;
% imbin = im2bw(image,T);
% figure, imshow(imbin)
