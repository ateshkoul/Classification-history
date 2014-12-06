
[j,k]=(max(Data(:,8:17),[],2));
k = k+8;

for i = 1:size(Data,1)
    Data(i,k(i)+1:17)=2.*Data(i,k(i))-Data(i,k(i)+1:17);
end
    

