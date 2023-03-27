% When delta <=1, the transformation is strictly increasing on R for any lambda>0
% When delta >1, the transformation is piecewise increasing on (-infty,1) and (1,infty) for any lambda>0

% When M >=1, the transformation is strictly increasing on R for any lambda<0
% When M <1, the transformation is piecewise increasing on (-infty,1) and (1,infty) for any lambda<0

%ii
clc
clear
delta =1+1.1;%+0.1%0.5;

lambda= unifrnd(0,2)

x=0.01:0.005:10;
rho = (log(x)- log(delta) )./log(x);
rho(199)=1;
y1 = rho.*(  log(x)+  boxcox(delta,lambda)  - log(delta) ) + (1-rho).*boxcox(x,lambda);
y2 = boxcox(x,lambda);
y = y1.*(x<=delta) + y2.*(x>delta);

dy1 =log(delta)./( x.*(log(x)).^2) .*(log(x)- boxcox(x,lambda)+boxcox(delta,lambda) -log(delta))+(log(x)-log(delta))./log(x)./x+log(delta)./log(x).*de_boxcox(x,lambda);
dy = dy1.*(x<=delta) +  de_boxcox(x,lambda).*(x>delta);

% LagY =[y(2:end)-y(1:end-1)];
% % IndicatorDecreasing = sum(LagY<0)
% 
% figure(1),clf
% plot(x,y,'+')
% ylabel 'y'
% set(gca,'XScale','log')
% 
% %%
figure(1),clf
subplot(121)
plot(x,y,'+')
ylabel 'y'

subplot(122)
plot(x,log(dy),'+')
ylabel 'dy'

sgtitle('ii')

dy_A=dy;

%%
clear
clc
M =1% unifrnd(1,10)%2+rand %0.5*1
lambda=-unifrnd(0,2)
delta=M;

x=0.01:0.005:10;
rho = (log(x)- log(M) )./log(x);
rho(199)=1;
y1 = boxcox(x,lambda);
y2 = rho.*(log(x)+boxcox(M,lambda) -log(M))+(1-rho).*boxcox(x,lambda);
y = y1.*(x<=M) + y2.*(x>M);

dy1 =log(delta)./( x.*(log(x)).^2) .*(log(x)- boxcox(x,lambda)+boxcox(delta,lambda) -log(delta))+(log(x)-log(delta))./log(x)./x+log(delta)./log(x).*de_boxcox(x,lambda);
dy =   de_boxcox(x,lambda).*(x<=delta)+dy1.*(x>delta);

LagY2 =[y(2:end)-y(1:end-1)];
% IndicatorDecreasing = sum(LagY2<0)


figure(2),clf
plot(x,y,'+')
ylabel 'y'
set(gca,'XScale','log')

%%

figure(2),clf
subplot(121)
plot(x,y,'+')
ylabel 'y'

subplot(122)
plot(x,dy,'+')
ylabel 'dy'

sgtitle('iii')



dy_B=dy;

% min(dy_A)
% min(dy_B)

function fval = boxcox(x,lambda)
fval = (x.^lambda-1)/lambda;
end
function fval = de_boxcox(x,lambda)
fval = x.^(lambda-1);
end

% %%
% M = 100 ;
% lambda= -0.5;
% alpha=M;
% x=0.01:0.01:10;
% rho = (log(x)- log(alpha) )/log(x);
% y = rho.*(  log(x)+  (delta.^lambda -1)/lambda  - log(delta) ) + (1-rho).*(x.^lambda-1)/lambda;