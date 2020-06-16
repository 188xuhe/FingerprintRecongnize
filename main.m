clc
clear
close all
tic
% file_name = 'H:\Graduation_thesis\Datasets\unet_img\raw_perfect\60\sub_img_16\005_0_2.tif';
% image1=imread(file_name);
[filename, pathname, filterindex] = uigetfile('H:\Detect_Point\FingerNet\sourcedata\2011_SagemTrain\img_files\*.*', 'ѡ����ע��ָ��');
image1=imread(fullfile(pathname, filename));
image1 = double(image1);
label = imread("./pic/segment2.tif");
%% ͼ��ת 
% image1 = flip_image(image1);
figure,imshow(image1,[0 255]);

%% pad image
image1 = sub_image(image1,16);   
label = sub_image(label,16);  
figure,imshow(image1,[0 255]),title('ͼ����չ');

%% �ߴ�
[m,n] = getsize(image1);

%% �ݶ�
[grad_complex,grad] = getgrad(image1,m,n,8);
figure,imshow(grad,[0 255]),title("�ݶ�");
figure,imshow(grad_complex),title("Sobel�ݶ�");
%% �ָ�
[image1_seg,g]=segment_filter(image1,grad,m,n);
figure,imshow(g,[0 1]),title('ͼ��ָ�1');
%figure,imshow(image1_seg,[0 255]),title('ͼ��ָ�2');
%% ָ�ƹ�һ��
%�˲���δ������
image1_norm = normalize_image(image1,100,200);
figure,imshow(image1_norm,[0 255]),title('ͼ���һ��');

image2_norm = image1_norm;
image2_norm(g==0)=255;
figure,imshow(image2_norm,[0 255]),title('ͼ��ָ�3');
%% ָ�ƿ鷽��ͼ
image1_orient = blk_orientation_image(image1_norm,16);

%% ����ƽ��
image1_orient_smooth = smoothen_orientation_field(image1_orient);
figure,
subplot(1,2,1)
plotOrientation(image1, image1_orient, 16); title('����');
subplot(1,2,2)
plotOrientation(image1, image1_orient_smooth, 16); title('��˹�˲���ķ���');
%% ָ��Ƶ�ʳ�
imge1_fre = frequency_image(image1,image1_orient_smooth,m,n,16);

%% Ƶ�ʳ�ƽ��
image1_fre_smooth = filter_frequency_image(imge1_fre);

%% gabor��ǿ
image1_gabor1 = do_gabor_filtering(image1_norm,image1_orient_smooth,image1_fre_smooth,m,n,16);     %gobor�˲���ǿͼ��

figure,imshow(image1_gabor1),title('gaborͼ��');

T = graythresh(image1_gabor1);
image1_gabor = im2bw(image1_gabor1,T);

image1_gabor_save = image1_gabor;
image1_gabor2 = image1_gabor;
image1_gabor3 = image1_gabor;

image1_gabor2(label==0)=1;
image1_gabor3(g==0)=1;
figure,imshow(image1_gabor3),title('gaborͼ������');
%% ϸ��
% image1_thin = bwmorph(image1_gabor,'skel',5);
image1_thin = thin(image1_gabor3);
figure,imshow(image1_thin),title('ͼ��ϸ��');

%% ȥ���̰���ë��

%% ��ȡϸ�ڵ�����
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

fid=fopen('point.txt','wt'); %д�ķ�ʽ���ļ����������ڣ������ļ�����
fprintf(fid,'%d %d %d %f \n',Point');  % %d ��ʾ��������ʽд�����ݣ�����������Ҫ�ģ�
fclose(fid);  %�ر��ļ���
%% ƥ��

toc
%% 
%���������ָ�ͼ��ǩ

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

%����ͼƬ
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

