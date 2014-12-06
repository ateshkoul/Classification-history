a = Data;
%ft = fittype( 'poly2' );
for k = 1:12
    initial_col = [8 18 40 50 60 70 80 90 100 170 180 190];
    %initial_col = [2 12 22 32 42 52 62 72 82 92 102 112];
    tmp = a(:,initial_col(k):initial_col(k)+9);
    for i = 1:size(a,1)
        for j = 1:10
%             n = polyfit(1:j,tmp(i,1:j),2);
%             %q(i,j)=n(1).*n(2);
%             % vertex
%             q(i,j)=-n(2)./(2*n(1)); 
              p = regress(tmp(i,1:j)',[(1:j).^2]');
              q(i,j)=p;
            
%             [xData, yData] = prepareCurveData(1:j,tmp(i,1:j));
%             [fitresult, gof] = fit( xData, yData, ft );        
%             p = coeffvalues(fitresult);
%             q(i,j)=p(1);           
        end
        
    end
    a(:,initial_col(k):initial_col(k)+9)=q;
end


% Area under curve
a = Data;
%ft = fittype( 'poly2' );
q=zeros(size(a,1),10);
for k = 1:12
    initial_col = [8 18 40 50 60 70 80 90 100 170 180 190];
    %initial_col = [2 12 22 32 42 52 62 72 82 92 102 112];
    tmp = a(:,initial_col(k):initial_col(k)+9);
    for i = 1:size(a,1)
        for j = 1:10
            q(i,j)=trapz(0:j,[0 tmp(i,1:j)]);       
            
            
            %n = polyfit(1:j,tmp(i,1:j),2);
            %q(i,j)=n(1).*n(2);
%             [xData, yData] = prepareCurveData(1:j,tmp(i,1:j));
%             [fitresult, gof] = fit( xData, yData, ft );        
%             p = coeffvalues(fitresult);
%             q(i,j)=p(1);           
        end
        
    end
    a(:,initial_col(k):initial_col(k)+9)=q;
end
