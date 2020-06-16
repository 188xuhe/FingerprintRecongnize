
if exist('Htable','var') == 0
    Htable = zeros(8,181,181,400);
end

if (exist ('ccount','var') ) == 0
   ccount  = 1;
else
    ccount = ccount + 1;
end

[filename, pathname, filterindex] = uigetfile('H:\毕业论文\数据集\自建指纹\0001\*.bmp', '选择需注册指纹');
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
tsign = ones(sizex,1);
for i = 1:sizex
    temptsign(1:3) = co(ETSU(i,mval(i,1:3)),3);
    te1 = 2;
    for te = 1:3
        tsign(i) = tsign(i)+temptsign(te)*(2^te1);
        te1 = te1 - 1;
    end
    Htable(tsign(i),ang(i,1)+1,ang(i,2)+1,ccount) = Htable(tsign(i),ang(i,1)+1,ang(i,2)+1,ccount)+1;
end
save('Htable.mat','Htable'); 