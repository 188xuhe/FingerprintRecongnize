function Point = get_minutia(filename)
%GET_MINUTIA �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
image1=imread(filename);
image1 = double(image1);
%% ͼ��ת
% image1 = flip_image(image1);
%figure,imshow(image1,[0 255]);

%% pad image
image1 = sub_image(image1,16);
%figure,imshow(image1,[0 255]),title('ͼ����չ');

%% �ߴ�
[m,n] = size(image1);
%[m,n] = getsize(image1);

%% �ݶ�
[gradx,grady,grad] = getgrad(image1,m,n,6);
%figure,imshow(grad,[0 255]),title("�ݶ�");

%% �ָ�
[image1_seg,g]=segment_filter(image1,grad,m,n);
%figure,imshow(image1_seg,[0 255]),title('ͼ��ָ�');

%% ָ�ƹ�һ��
%�˲���δ������
image1_norm = normalize_image(image1,50,50);
%figure,imshow(image1_norm,[0 255]),title('ͼ���һ��');

%% ָ�ƿ鷽��ͼ
image1_orient = blk_orientation_image(image1,16);
%figure,imshow(image1_orient,[0 3.14]),title('�鷽��ͼ');

%% ����ƽ��
image1_orient_smooth = smoothen_orientation_field(image1_orient);

%% ָ��Ƶ�ʳ�
imge1_fre = frequency_image(image1,image1_orient_smooth,m,n,16);

%% Ƶ�ʳ�ƽ��
image1_fre_smooth = filter_frequency_image(imge1_fre);

%% gabor��ǿ
image1_gabor = do_gabor_filtering(image1_norm,image1_orient_smooth,image1_fre_smooth,m,n,16);     %gobor�˲���ǿͼ��
%figure,imshow(image1_gabor),title('gaborͼ��');
image1_gabor(g==0)=1;
%figure,imshow(image1_gabor),title('gaborͼ������');
%% ϸ��
% image1_thin = bwmorph(image1_gabor,'skel',5);
image1_thin = thin(image1_gabor);
%figure,imshow(image1_thin),title('ͼ��ϸ��');

%% ȥ���̰���ë��

%% ��ȡϸ�ڵ�����
[term,bif,nterm,nbif]=get_feature(image1_thin,g);
figure,imshow(image1_thin),hold on,plot(term(2,:),term(1,:),'bo'),plot(bif(2,:),bif(1,:),'ro');

point = [[term;zeros(1,nterm)],[bif;ones(1,nbif)]];
Point = [point(2,:);point(1,:);point(3,:)];
Point = Point';
end

