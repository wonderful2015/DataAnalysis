%% Input these data
filename = 'data.csv';delimiter = ',';startRow = 2;
formatSpec = '%s%s%s%s%s%s%s%s%s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));
for col=[1,2,3,4,5,6,7,8,9]
    rawData = dataArray{col};
    for row = 1:size(rawData, 1);
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(thousandsRegExp, ',', 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); 
raw(R) = {NaN}; 
T = cell2mat(raw(:, 1));
TAX = cell2mat(raw(:, 2));
GDP = cell2mat(raw(:, 3));
EXP = cell2mat(raw(:, 4));
IE = cell2mat(raw(:, 5));
RS = cell2mat(raw(:, 6));
COM = cell2mat(raw(:, 7));
INV = cell2mat(raw(:, 8));
DEP = cell2mat(raw(:, 9));
clearvars filename delimiter startRow formatSpec fileID dataArray ans raw 
clearvars col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me R;
%% Regression analysis
y=TAX;x=GDP;
x1=[ones(length(x),1),x];
[b,bint,r,rint,stats]=regress(y,x1);
b,bint,stats,rcoplot(r,rint)
plot(x,y,'o');
f=lsline;
set(f,'Color',[0 0 0])
%% Time series
%TAX
m1=length(y);n=6; %n is the number of moving average
m1
for i=1:m1-n+1
    yhat1(i)=sum(y(i:i+n-1))/n;
end
yhat1
m2=length(yhat1);
for i=1:m2-n+1
    yhat2(i)=sum(yhat1(i:i+n-1))/n;
end
yhat2
a37=2*yhat1(end)-yhat2(end)
b37=2*(yhat1(end)-yhat2(end))/(n-1)
y2015=a37+b37
%GDP
m1=length(x);
for i=1:m1-n+1
    xhat1(i)=sum(x(i:i+n-1))/n;
end
xhat1
m2=length(xhat1);
for i=1:m2-n+1
    xhat2(i)=sum(xhat1(i:i+n-1))/n;
end
xhat2
a37=2*xhat1(end)-xhat2(end);
b37=2*(xhat1(end)-xhat2(end))/(n-1);
x2015=a37+b37