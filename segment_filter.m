function [image_seg,g] = segment_filter(image,grad,m,n)
%SEGMENT_FILTER �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%% �ݶ�ͼ���ֵ��
image=double(image);
grad=grad/max(grad(:));
se = strel('square',6);
grad_open = imopen(grad,se);
grad_close = imclose(grad_open,se);
%figure,imshow(grad_close),title('���ز���');
%imwrite(image1_thin,"./pic/image1_thin.tif","tif");

grad = grad_close;

hp=imhist(grad);
hp(1)=0;
%T=otsuthresh(hp)-0.25;%�ɶԱȿ���graythresh
T=graythresh(hp)-0.28;
g=imbinarize(grad,T);
g(1:4,:)=0;
g(:,1:4)=0;
g(m-3:m,:)=0;
g(:,n-3:n)=0;

%���ߣ�
% g(1:2,:)=0;
% g(:,1:2)=0;
% g(m-2:m,:)=0;
% g(:,n-2:n)=0;

%figure,imshow(g),title('�ָ�����');
%% ͼ��ָ�
%image_seg=image .* g;
%% 
 image_seg=image+255*(1-g);
% figure,imshow(image_seg,[0 255]),title('�������');
end

