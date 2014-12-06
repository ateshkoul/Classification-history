function [results,Data,q] = svm_history(Data,intervalPts,interval,filename,method)
% Function to classify data using history of previous points in the data.
% The script is for something like a time series trying to predict labels.
% Recursively goes in the data and replaces the data with a value using
% history.

% Inputs:
%       Data                    -Raw Data with different factors in column 2
%
%       intervalPts             -Interval points or Points that discriminate different
%                               factors
%
%       interval               -Interval (or length) of the factors (time points for 
%                                a time series)
%
%       filename (optional)    - Enter name of the file to be saved (you would
%                                 like to save it right??)
%
%       method (optional)     - Method of history. Many are implemented.

% Outputs:
%       results                 - results of the classification
%
%
%
%       Data                    - Transformed data
%
%
% Saves the results of the svm classification



% Requirements:
% kineticsvm.m
% libsvm installed and in matlab path.


if ~exist('intervalPts','var')
    % For back compatibility with previous runs of my experiment
    % Not necessary that you keep this.
    % I advise to remove and always provide intervalPts unless you just
    % want to run one experiment over and over and over again and you are
    % tired of inputting the intervalPts. If you are that lazy (like me) 
    % why not add the line for interval as well?? 
    % intervalPts = [8 18 40 50 60 70 80 90 100 170 180 190]; 
    intervalPts=[8 18 41 51 61 71 81 91 101 111 121 131 171 181 191 201];
end

% Here I put it for you!! How dare you called me lazy??? But seriously
% input the intervalPts and interval...
if ~exist('interval','var')
    interval = 10;
end

if ~exist('filename','var')
    filename = ('Results_history');
end


if ~exist('method','var')
    method = 'LPolyfit';
end

for k = 1:size(intervalPts,2)
    
    tmp = Data(:,intervalPts(k):intervalPts(k)+9);
    for i = 1:size(Data,1)
        for j = 1:interval
            switch(method)
                case 'LPolyfit'
                    % Linerar Fitting Polyfit
                    p = polyfit(1:j,tmp(i,1:j),1);
                    q(i,j)=p(1);
                case 'LRegress'
                    % Linear Regression Yuan Method
                    p = regress(tmp(i,1:j)',[1:j]');
                    q(i,j)=p(1);
                case 'QPolyfit'
                    % Polynomial Degree 2 Value 'a'
                    p = polyfit(1:j,tmp(i,1:j),2);
                    q(i,j)=p(1);
                case 'QRegress'
                    % Quadratic regression
                    p = regress(tmp(i,1:j)',((1:j).^2)');
                    q(i,j)=p(1);
                otherwise
                    disp('I dont know this method. why don''t you write it??');
            end
                    
        end
        
    end
    Data(:,intervalPts(k):intervalPts(k)+9)=q;
end


y = Data(:,2);

% choose which columns to use
% the colum names are used as in the origional file so as to keep it simple
% that is the columns that are not used are not eliminated, but not sent to
% the feature selection.
% unbin_col = [3 4 5 6 7 35 220 221 242 243 244];
% unbin_col_no_aper = [3 4 5 7 35 220 221 242 243 244];
% unbin_col_no_aper_no_lug = [3 4 5 7 35 220 221 242];


% first column- trial no. is present
% data has been kept in origional form
% to have a consistant naming of columns through out


% % first all the unbinned columns
% data_unbin = Data(:,unbin_col);
% matrix_unbin = [y data_unbin];
% kinematicsvm(matrix_unbin,'unbin.txt');
% 
% 
% data_unbin_no_aper = Data(:,unbin_col_no_aper);
% matrix_unbin_no_aper = [y data_unbin_no_aper];
% kinematicsvm(matrix_unbin_no_aper,'unbin-no-aper.txt');
% 
% 
% data_unbin_no_aper_no_lug = Data(:,unbin_col_no_aper_no_lug);
% matrix_unbin_no_aper_no_lug = [y data_unbin_no_aper_no_lug];
% kinematicsvm(matrix_unbin_no_aper_no_lug,'unbin-no-aper-no-lug.txt');




% % for all binned have to loop for all 10 bins:
%initial_col = [8 18 40 50 60 70 80 90 100 170 180 190];
% 

colHeaders = {'AccTest','AccCv','fs'};
results = cell(11,length(colHeaders)); %preallocate resutls
results(1,:)= colHeaders;
% loop for the number of bins (= 10 in our case)

% starting the loop from 0 because the initial column would have to be like
% matrix_bin = [y Data(:,initial_col-1+i)];
% subtract 1 as the initial columns would have to have been subtracted by 1
% This is done to not think about subtracting 1 from the column numbers and
% simply put the column no. of dynamic variables to be used.

for i = 0:9
    matrix_bin = [y Data(:,initial_col+i)];
    file= strcat('bin-', num2str(i),'.txt');
    [accTest, accCv] = kinematicsvm(matrix_bin,file);
    results{i+2,1}=num2str(accTest);
    results{i+2,2}=num2str(accCv);
    %results{i+2,3}=num2str(fs);
end


%save('results_svm_history_regress_poly_1.mat','results')
% really strcat is not necessary... but i like it!! Remove it if you like.
% Also you can save results in any form you want..
save(strcat(filename,'.mat'),'Data')
