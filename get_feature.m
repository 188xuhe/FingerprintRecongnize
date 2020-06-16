function [term,bif,nterm,nbif]=get_feature(i_thin,msk)
i_thin = ~i_thin;
[ht,wt]=size(i_thin);     %白色为脊线
cha_m=zeros(ht,wt);
nterm=0;nbif=0;
term = zeros(2,100);
bif = zeros(2,100);
for i=3:ht-3                %粗提取特征点
    for j=3:wt-3
        if i_thin(i,j)==1
            if abs(i_thin(i-1,j)-i_thin(i-1,j+1))+abs(i_thin(i-1,j-1)-i_thin(i-1,j))+...
     +abs(i_thin(i,j-1)-i_thin(i-1,j-1))+abs(i_thin(i+1,j-1)-i_thin(i,j-1))+...
     +abs(i_thin(i+1,j)-i_thin(i+1,j-1))+abs(i_thin(i+1,j+1)-i_thin(i+1,j))+...
     +abs(i_thin(i,j+1)-i_thin(i+1,j+1))+abs(i_thin(i-1,j+1)-i_thin(i,j+1))==2
            nterm=nterm+1;
            term(1,nterm)=i;
            term(2,nterm)=j;
            cha_m(i,j)=1;
            end
            if abs(i_thin(i-1,j)-i_thin(i-1,j+1))+abs(i_thin(i-1,j-1)-i_thin(i-1,j))+...
     +abs(i_thin(i,j-1)-i_thin(i-1,j-1))+abs(i_thin(i+1,j-1)-i_thin(i,j-1))+...
     +abs(i_thin(i+1,j)-i_thin(i+1,j-1))+abs(i_thin(i+1,j+1)-i_thin(i+1,j))+...
     +abs(i_thin(i,j+1)-i_thin(i+1,j+1))+abs(i_thin(i-1,j+1)-i_thin(i,j+1))==6
            nbif=nbif+1;
            bif(1,nbif)=i;
            bif(2,nbif)=j;
            cha_m(i,j)=2;
            end
        end
    end
end



for i=1:nterm       %
    if term(1,i)<10 || term(1,i)+10>ht || term(2,i)+10>wt || term(2,i)<10
        cha_m(term(1,i),term(2,i))=0;
    else
        for r=0:9
            if msk(term(1,i)-r,term(2,i))==0 || msk(term(1,i)+r,term(2,i))==0 || ...
               msk(term(1,i),term(2,i)-r)==0 || msk(term(1,i),term(2,i)+r)==0
               cha_m(term(1,i),term(2,i))=0;
            end
        end
%        if sum(msk(term(1,i),1:term(2,i)-6))==0 || sum(msk(term(1,i),term(2,i)+6:wt))==0 || ...
%           sum(msk(1:term(1,i)-6,term(2,i)))==0 || sum(msk(term(1,i)+6:ht,term(2,i)))==0 
%           cha_m(term(1,i),term(2,i))=0;
%        end
    end
end
for i=1:nbif
     if bif(1,i)<10 || bif(1,i)+10>ht|| bif(2,i)+10>wt || bif(2,i)<10
        cha_m(bif(1,i),bif(2,i))=0;
     else
        for r=0:9
            if msk(bif(1,i)-r,bif(2,i))==0 || msk(bif(1,i)+r,bif(2,i))==0 || ...
               msk(bif(1,i),bif(2,i)-r)==0 || msk(bif(1,i),bif(2,i)+r)==0
               cha_m(bif(1,i),bif(2,i))=0;
            end
        end
%        if sum(msk(bif(1,i),1:bif(2,i)-6))==0 || sum(msk(bif(1,i),bif(2,i)+6:wt))==0 || ...
%           sum(msk(1:bif(1,i)-6,bif(2,i)))==0 || sum(msk(bif(1,i)+6:ht,bif(2,i)))==0 
%           cha_m(bif(1,i),bif(2,i))=0;
%        end
     end
end

for i=1:nterm             
 for j=i+1:nterm
    if sqrt((term(1,i)-term(1,j))^2+(term(2,i)-term(2,j))^2)<6
        cha_m(term(1,i),term(2,i))=0;
        cha_m(term(1,j),term(2,j))=0;
    end
 end
 for j=1:nbif
    if sqrt((term(1,i)-bif(1,j))^2+(term(2,i)-bif(2,j))^2)<6
        cha_m(term(1,i),term(2,i))=0;
        cha_m(bif(1,j),bif(2,j))=0;
    end
 end
end
for i = 1:nbif 
  for j = i+1:nbif
    if sqrt((bif(1,i)-bif(1,j))^2+(bif(2,i)-bif(2,j))^2)<4
        cha_m(bif(1,i),bif(2,i))=0;
%        cha_m(bif(1,j),bif(2,j))=0;
    end
  end
end
  nterm=0;nbif=0;
   term=[];bif=[];
 for i=1:ht
    for j=1:wt
   if cha_m(i,j)==1
    nterm=nterm+1;
    term(1,nterm)=i;
    term(2,nterm)=j;
   end
   if cha_m(i,j)==2
       nbif=nbif+1;
       bif(1,nbif)=i;
       bif(2,nbif)=j;
   end
     end
 end