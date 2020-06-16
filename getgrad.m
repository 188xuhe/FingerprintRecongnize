function [grad_complex,grad] = getgrad(image,m,n,r)
%GETGRAD �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%% 
EPI	= 57.29578;     %360/2pi���ǶȺͻ��ȵĻ���
Vx = zeros(m,n);
Vy = zeros(m,n);
grad = zeros(m,n);
f_temp = image;

hy  = fspecial('sobel');
hx  = hy';
gx  = imfilter(image,hx,'same','symmetric');
gy  = imfilter(image,hy,'same','symmetric');
% grad_complex  = sqrt(gx .* gx + gy .* gy);
% grad_complex = grad_complex / max(max(grad_complex)) .* 255;
grad_complex  = abs(gx) + abs(gy);
grad_complex = grad_complex / max(max(grad_complex));

for x = 1:m
    for y = 1: n
         vx = 0;
         vy = 0;
         lvx = 0;
         lvy = 0;
         num = 0;
            %%%%%%%%%%%%%%%%%%%r * r ���µĴ���%%%%%%%%%%%%%%%%%%%
            for i = -r:r
                %%%%%%%%%%%%%%%%%% �߽紦�� %%%%%%%%%%%%%%%%%%%%%
                if(x + i -1 < 1 || x + i + 1 > m )
                    continue;
                end
                    for j = -r:r
                        if (y + j -1 < 1 || y + j + 1 > n)
                            continue;
                        end
                         Vx(x+i,y+j) = f_temp(x+i+1,y+j+1) - f_temp(x+i+1,y+j-1) + f_temp(x+i,y+j+1)*2 - f_temp(x+i,y+j-1)*2 + f_temp(x+i-1,y+j+1) - f_temp(x+i-1,y+j-1);
                         Vy(x+i,y+j) = (f_temp(x+i-1,y+j+1) - f_temp(x+i+1,y+j+1)) + (f_temp(x+i-1,y+j)*2 - f_temp(x+i+1,y+j)*2) + (f_temp(x+i-1,y+j-1) - f_temp(x+i+1,y+j-1) );
                         vx = vx + abs(Vx(x+i,y+j));
                         vy = vy + abs(Vy(x+i,y+j));                        
                         num=num+1;                         
                    end
            end
            if num==0
                num=1;
            end
            grad(x,y) = (vx + vy)/num;     %ͼ���ݶ�
    end
end


