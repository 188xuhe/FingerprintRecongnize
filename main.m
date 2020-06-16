clc
clear
close all
tic
% file_name = 'H:\Graduation_thesis\Datasets\unet_img\raw_perfect\60\sub_img_16\005_0_2.tif';
% image1=imread(file_name);
[filename, pathname, filterindex] = uigetfile('H:\Detect_Point\FingerNet\sourcedata\2011_SagemTrain\img_files\*.*', '选择需注册指纹');
image1=imread(fullfile(pathname, filename));
image1 = double(image1);
label = imread("./pic/segment2.tif");
%% 图像翻转 
% image1 = flip_image(image1);
figure,imshow(image1,[0 255]);

%% pad image
image1 = sub_image(image1,16);   
label = sub_image(label,16);  
figure,imshow(image1,[0 255]),title('图像扩展');

%% 尺寸
[m,n] = getsize(image1);

%% 梯度
[grad_complex,grad] = getgrad(image1,m,n,8);
figure,imshow(grad,[0 255]),title("梯度");
figure,imshow(grad_complex),title("Sobel梯度");
%% 分割
[image1_seg,g]=segment_filter(image1,grad,m,n);
figure,imshow(g,[0 1]),title('图像分割1');
%figure,imshow(image1_seg,[0 255]),title('图像分割2');
%% 指纹归一化
%此部分未有用上
image1_norm = normalize_image(image1,100,200);
figure,imshow(image1_norm,[0 255]),title('图像归一化');

image2_norm = image1_norm;
image2_norm(g==0)=255;
figure,imshow(image2_norm,[0 255]),title('图像分割3');
%% 指纹块方向图
image1_orient = blk_orientation_image(image1_norm,16);

%% 方向场平滑
image1_orient_smooth = smoothen_orientation_field(image1_orient);
figure,
subplot(1,2,1)
plotOrientation(image1, image1_orient, 16); title('方向场');
subplot(1,2,2)
plotOrientation(image1, image1_orient_smooth, 16); title('高斯滤波后的方向场');
%% 指纹频率场
imge1_fre = frequency_image(image1,image1_orient_smooth,m,n,16);

%% 频率场平滑
image1_fre_smooth = filter_frequency_image(imge1_fre);

%% gabor增强
image1_gabor1 = do_gabor_filtering(image1_norm,image1_orient_smooth,image1_fre_smooth,m,n,16);     %gobor滤波增强图像

figure,imshow(image1_gabor1),title('gabor图像');

T = graythresh(image1_gabor1);
image1_gabor = im2bw(image1_gabor1,T);

image1_gabor_save = image1_gabor;
image1_gabor2 = image1_gabor;
image1_gabor3 = image1_gabor;

image1_gabor2(label==0)=1;
image1_gabor3(g==0)=1;
figure,imshow(image1_gabor3),title('gabor图像修正');
%% 细化
% image1_thin = bwmorph(image1_gabor,'skel',5);
image1_thin = thin(image1_gabor3);
figure,imshow(image1_thin),title('图像细化');

%% 去除短棒和毛刺

%% 求取细节点特征
[term,bif,nterm,nbif]=get_feature(image1_thin,g);
long = 16;

a = ceil(term(1,:)/long);
b = ceil(term(2,:)/long);
thterm = zeros(nterm,1);
for i = 1:nterm
    thterm(i,1) = image1_orient( a(i),b(i) );
end
c = ceil(bif(1,:)/long);
d = ceil(bif(2,:)/long);
thbif = zeros(nbif,1);
for i = 1:nbif
    thbif(i,1) = image1_orient( c(i),d(i) );
end
th = [thterm;thbif];
point = [[term;zeros(1,nterm)],[bif;ones(1,nbif)]];
Point = [point(2,:);point(1,:);point(3,:)];
Point = [Point',th(:)];
figure,imshow(image1,[0 255]),hold on,plot(term(2,:),term(1,:),'bo'),plot(bif(2,:),bif(1,:),'ro');
hold on 
for i = 1:nterm
    line([Point(i,1),(Point(i,1)-8*cos(th(i)))],[Point(i,2),(Point(i,2)-8*sin(th(i)))],'color','b','linewidth', 2);
end
for i = nterm+1:nterm+nbif
    line([Point(i,1),(Point(i,1)-8*cos(th(i)))],[Point(i,2),(Point(i,2)-8*sin(th(i)))],'color','r','linewidth', 2);
end

fid=fopen('point.txt','wt'); %写的方式打开文件（若不存在，建立文件）；
fprintf(fid,'%d %d %d %f \n',Point');  % %d 表示以整数形式写入数据，这正是我想要的；
fclose(fid);  %关闭文件；
%% 匹配

toc
%% 
%用于制作分割图标签

% path_save_label = "I:\Graduation_thesis\Datasets\unet_img\test\label";
% path_save_gabor = "I:\Graduation_thesis\Datasets\unet_img\test\label";
% file_label = fullfile(path_save_label , filename);
% file_gabor = fullfile(path_save_gabor , filename);
% reply = input('Do you want save? Y/N :','s');
% if isempty(reply)
%     disp("no save!");
% elseif reply == "0"
%     imwrite(g,file_label,"tif");
%     disp("label save!");
% else
%     imwrite(image1_gabor_save,file_gabor,"tif");
%     disp("gabor save!");
% end

%%

%保存图片
imwrite(image1 ./ 255,"./pic/image.tif","tif");
imwrite(grad_complex,"./pic/grad_complex.tif","tif");
imwrite(grad ./ 255,"./pic/grad.tif","tif");
imwrite(g,"./pic/g.tif","tif");
imwrite(image1_seg ./ 255,"./pic/image1_seg.tif","tif");
imwrite(image1_orient,"./pic/image1_orient.tif","tif");
imwrite(image1_orient_smooth,"./pic/image1_orient_smooth.tif","tif");
imwrite(image1_gabor1,"./pic/image1_gabor1.tif","tif");
imwrite(image1_gabor,"./pic/image1_gabor_bina.tif","tif");
imwrite(image1_gabor2,"./pic/image1_gabor_label.tif","tif");
imwrite(image1_gabor3,"./pic/image1_gabor_g.tif","tif");
imwrite(image1_thin,"./pic/image1_thin.tif","tif");

