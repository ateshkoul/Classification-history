

a = Data;

for k = 1:12
    initial_col = [8 18 40 50 60 70 80 90 100 170 180 190];
    tmp = a(:,initial_col(k):initial_col(k+9));
    for i = 1:888
        for j = 1:10
            p = polyfit(1:j,tmp(i,1:j),1);
            q(i,j)=p(1);
        end
        
    end
    a(:,initial_col(k):initial_col(k+9))=q(i,j);
end
