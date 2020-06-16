% read image
thres = 5;


[filename, pathname, filterindex] = uigetfile('H:\毕业论文\数据集\自建指纹\0001\*.bmp', '选择需匹配图片');
f = fullfile(pathname, filename); 

co=get_minutia(f);
n=size(co,1);
TR1 = delaunay(co(1:n,1),co(1:n,2));
ETS = TR1;
triplot(TR1,co(1:n,1),co(1:n,2))
ETSU = sort(ETS,2);
ETSU = unique(ETSU,'rows');
sizex = size(ETSU,1);
x = zeros(sizex,3);
y = zeros(sizex,3);
for i = 1:sizex
    x(i,1:3) = co(ETSU(i,1:3),1);
    y(i,1:3) = co(ETSU(i,1:3),2);
end
[ang,dist,mval] = triangledetails(x,y);
tsign1 = ones(sizex,1);
hashT= zeros(400,1);
for i = 1:sizex
    temptsign(1:3) = co(ETSU(i,mval(i,1:3)),3);
    te1 = 2;
    for te = 1:3
        tsign1(i) = tsign1(i)+temptsign(te)*(2^te1);
        te1 = te1-1;
    end
    ta1 = ang(i,1)+1;
    ta2 = ang(i,2)+1;
    temphashTemplate = zeros(400,1);
    temphashTemplate1 = zeros(400,1);
    for j1 = -thres:thres
        for j2 = -thres:thres
            if((ta1+j1)>0 && (ta2+j2)>0 && (ta1+j1)<182 && (ta2+j2)<182)
            temphashTemplate1(1:400,1) =(Htable(tsign1(i),ta1+j1,ta2+j2,:)>0);
            temphashTemplate = temphashTemplate + temphashTemplate1;
            end
        end
    end
    hashT = hashT + (temphashTemplate>0);
end
hashT = reshape(hashT,4,100);
hashT = hashT';
[hashT1,y1] = max(hashT,[],2);
siMatrix=hashT1/size(ETSU,1);
save('siMatrix.mat','siMatrix');
if max(siMatrix) < 0.65
    msgbox('找不到可以匹配的指纹');
else
    index = find(siMatrix  == max(siMatrix));
    msgbox(strcat('最可能匹配的指纹是',num2str(index),'!'));
end
