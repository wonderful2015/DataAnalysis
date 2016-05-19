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
