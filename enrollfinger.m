clear all;
Htable = zeros(8,181,181,40);
ccount = 1;
for count = 101:110
    for count2 = 2:2:8  %2 4 6 8作为模板
         %if(count == 32 && count2 == 7)
         %ccount = ccount + 1;
         %    continue;
         %end
        f= strcat('H:\毕业论文\数据集\FVC2002\DB1_B (1)\',num2str(count),'_',num2str(count2),'.tif');
        co=get_minutia(f);
        %co=textscan('point.txt');
        n=size(co,1);
        TR1 = delaunay(co(1:n,1),co(1:n,2));
        ETS = TR1;
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
        ccount = ccount + 1;
    end
end