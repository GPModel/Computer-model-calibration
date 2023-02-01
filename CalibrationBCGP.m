function [RecordTable,RecordData]=CalibrationBCGP(DataInput)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Single fidelity calibration method : BC-GP
%           Resph: is a vector of HF SSE,
%           Xhats: is MLE of the calibration parameter vector at all iterations
%           Resphminhats: is posterior means/medians of the Resph at Xhats at all iterations
%           SSETrue_Xhats: is the true values of SSE evaluated at Xhats at all iterations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%Computes the untransformed HF response
Dh=DataInput.Dh;
Yh=DataInput.Yh;
XTrue=DataInput.XTrue;
PhysData=DataInput.PhysData;
RatioCost=DataInput.RatioCost;
Budget=DataInput.Budget;
Case=DataInput.Case;
[n,Dim]=size(Dh);
Level=2*ones(n,1) ;
ZNBC=1;%Box-Cox transformation

Resph=sum((Yh-PhysData).^2,2);
Budget =Budget-(n*RatioCost);

if Dim==2
    nlevel=51;
elseif Dim==3
    nlevel=41;
elseif Dim==4
    nlevel=21;
end
AFPoints=(fullfact(nlevel*ones(1,Dim))-1)/(nlevel-1);
lb=0*ones(1,Dim);ub=1*ones(1,Dim);
options=optimoptions('patternsearch','disp','off');

%%%%%%%%%%%%%%%%%%%%%Bayesian optimization%%%%%%%%%%%%%%%%%%%%%
while (1)
    
    %%%%%%%Fits the GP model and finds the minimum posterior mean
    [Mu,Sigma,Theta,invR,invRRes,condR,Objfval,phis(n,:)]=GPFit(Dh,Resph,ZNBC);
    
    ObjQuantile=@(x) Fun_ZhQuantile(x,Dh,Resph,Theta,Mu,Sigma,invR,invRRes);
    fvalsObjQuantile= ObjQuantile(AFPoints);
    [~,Sortidx]=sort(fvalsObjQuantile);
    parfor id=1:10
        [XBestTry(id,:),fBestTry(id,1)]= patternsearch(ObjQuantile,AFPoints(Sortidx(id),:),[],[],[],[],lb,ub,[],options);
    end
    [minObjZhPreds,minidx]=min(fBestTry);
    Xhat_new=XBestTry(minidx,:) ;
    
    %%%%%%%Stores GP model parameters and the MLE of the calibration parameter vector
    Sigmas(n,:)=Sigma;    Thetas(n,:)=Theta;    Mus(n,:)=Mu;    condRs(n,:)=condR;
    
    Xhats(n,:)=Xhat_new;
    Resphminhats(n,:)= TransformData_inv(minObjZhPreds,phis(n,:),ZNBC);
    minZDataRef=Fun_PredictionZ(Xhat_new,Dh,Resph,Theta,Mu,Sigma,invR,invRRes);
    
    %%%Evaluate the true SSE at the MLE of the calibration parameter vector
    Yh_Xhats(n,:)=Simulator(Xhat_new,2,Case);
    SSETrue_Xhats(n,:)=sum( (Yh_Xhats(n,:)-PhysData).^2);
    
    if Case==2
        disp(['Xhat_new and SSETrue_Xhats at  ' num2str(n) ' -iter '  num2str(Xhats(n,:))  '    ' num2str(SSETrue_Xhats(n,:))  ])
    end
    
    if Budget<RatioCost% RatioCost=c_h
        break
    end
    
    %%%%%%%Adds a follow-up design point by Maximizing the AF
    MinusEIObj=@(TeD) Fun_MinusEI(TeD,Dh,Resph,Theta,Mu,Sigma,invR,invRRes,minZDataRef) ;
    fvals=MinusEIObj(AFPoints);
    [~,Sortidx]=sort(fvals);
    clear XBestTry fBestTry
    parfor id=1:10
        [XBestTry(id,:),fBestTry(id,1)]= patternsearch(MinusEIObj,AFPoints(Sortidx(id),:),[],[],[],[],lb,ub,[],options);
    end
    [fBest,minidx]=min(fBestTry);
    NextPoint=XBestTry(minidx,:) ;
    
    disp(['Current budget=' num2str(Budget) '. The ' num2str(n+1) '-th run will be at point ' num2str(NextPoint,' %1.3f ')     ])
    n=n+1;
    Dh(n,:)=NextPoint;
    Yh(n,:)=Simulator(NextPoint,2,Case);
    Level(n,:)=2;
    
    Resph(n,:)=sum((Yh(n,:)-PhysData).^2);
    Budget=Budget-RatioCost ;
    
end

%%%%%%%Stores design points and their corresponding simulator output
Resplh=Resph;
D=Dh;

RecordData.Dl=[];
RecordData.Yl=[];
RecordData.Respl=[];
RecordData.Dh=Dh;
RecordData.Yh=Yh;
RecordData.Resph=Resph;
RecordData.XTrue=XTrue;
RecordData.PhysData=PhysData;
RecordData.RatioCost=RatioCost;
RecordData.Budget=Budget;
RecordData.ZNBC=[];
RecordData.Yh_Xhats=Yh_Xhats;

%%%%%%%Stores GP model parameters and the MLE of the calibration parameter vector at all iterations with a table
RecordTable=table(D,Level,Resplh,Sigmas,phis,Thetas,Mus,Xhats,Resphminhats,SSETrue_Xhats,condRs);
end
%%
function [Mu,Sigma,Theta,invR,invRRes,condR,Objfval,phi]=GPFit(Dh,Resph,ZNBC)
[n,Dim]=size(Dh);

lb=[ (0.1)*ones(1,Dim) -2];
ub=[ (20)*ones(1,Dim) 2];
ObjS=@(Par) Fun_NegLogLikelihood(Dh,Resph,Par(1:Dim),Par(Dim+1),n,ZNBC);
nvar=numel(ub);

Sobolset=sobolset(nvar,'Skip',1e3,'Leap',1e2);
SobolsetPoints=net(Sobolset,1000*nvar);
options=optimoptions('patternsearch','disp','off');

parfor id=1:size(SobolsetPoints,1)
    StartPoints(id,:)=lb + (ub-lb).*SobolsetPoints(id,:);
    fvals(id,1)=ObjS(StartPoints(id,:));
end
[~,Sortidx]=sort(fvals);
parfor id=1:10
    StartPoint=StartPoints(Sortidx(id),:);
    [XBestTry(id,:),fBestTry(id,1)]= patternsearch(ObjS,StartPoint,[],[],[],[],lb,ub,[],options);
end

[fBest,minidx]=min(fBestTry);
Parin=XBestTry(minidx,:) ;
[Objfval,Mu,Sigma,Theta,invR,invRRes,condR,phi]=ObjS(Parin);
end
%%
function [fval,Mu,Sigma,Theta,invR,invRRes,condR,phi]=Fun_NegLogLikelihood(D,Resph,Theta,phi,n,ZNBC)

[ZData,SumLogdZ]=TransformData(Resph,phi,ZNBC);
FT=ones(1,n) ;
R=ComputeRmatrix2(D,Theta);
[invR,logdetR,condR]=invandlogdet(R);
FTinvR=FT*invR;
Mu=(FTinvR*ZData)/sum(invR,'all');

Res=ZData-Mu ;
invRRes=invR*Res;
Sigma=Res'*invRRes/ (n ) ;
fval=n*log(Sigma)+logdetR-2*SumLogdZ;

if any(isnan(invR),'all') || any(isinf(invR),'all') || Sigma==0%
    fval=Inf;Mu=[];Sigma=[];Theta=[];invR=[];invRRes=[];condR=[];phi=[];
    return
end
end
%%
function [Fval_ZQuantile]=Fun_ZhQuantile(TeD,Dh,Resph,Theta,Mu,Sigma,invR,invRRes)
[ZPreds,ZCovs]=Fun_PredictionZ(TeD,Dh,Resph,Theta,Mu,Sigma,invR,invRRes);
Fval_ZQuantile=ZPreds+norminv(0.9)*ZCovs.^0.5;
end
%%
function [ZPreds,ZCovs]=Fun_PredictionZ(TeD,Dh,Resph,Theta,Mu,Sigma,invR,invRRes)
nugget=1e-6;
rT=ComputeRmatrix(TeD,Dh,Theta);
rT_invR=rT*invR;
ZPreds=Mu + rT*invRRes;
ZCovs =Sigma * ( 1+nugget - sum(rT_invR.*rT,2) ) ;
ZCovs=max(ZCovs,0);
end
%%
function Fval_MinusEI=Fun_MinusEI(TeD,Dh,Resph,Theta,Mu,Sigma,invR,invRRes,minZData)

[ZPreds,ZCovs]=Fun_PredictionZ(TeD,Dh,Resph,Theta,Mu,Sigma,invR,invRRes);
SD=ZCovs.^0.5;
Bias=minZData-ZPreds;
EIfval=Bias.*normcdf(Bias./SD)+SD.*normpdf(Bias./SD);
EIfval(   logical( [ZCovs==0] |  min(pdist2(TeD,Dh),[],2) < 10^(-2)  )    )=0;
Fval_MinusEI=-EIfval;
end
