function [RecordTable,RecordData]=CalibrationSRGP(DataInput)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Single fidelity calibration method : SR-GP
%           Resph: is a vector of HF response modeled as a GP
%           Xhats: is MLE of the calibration parameter vector at all iterations
%           Resphminhats: is posterior means/medians of the Resph at Xhats at all iterations
%           SSETrue_Xhats: is the true values of SSE evaluated at Xhats at all iterations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Referennces:
% Ranjan, P., Thomas, M., Teismann, H., & Mukhoti, S. (2016). Inverse problem for a time-series valued computer simulator via scalarization. 
% Open Journal of Statistics, 6(3), 528-544.
%%%%%%%Computes the HF response
Dh=DataInput.Dh;
Yh=DataInput.Yh;
XTrue=DataInput.XTrue;
PhysData=DataInput.PhysData;
RatioCost=DataInput.RatioCost;
Budget=DataInput.Budget;
Case=DataInput.Case;
[n,Dim]=size(Dh);
Level=2*ones(n,1) ;


Resph=(mean((Yh-PhysData).^2,2)).^0.5;  %Root MSE modeled as a GP in Ranjan et al. (2016)
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
    [Mu,Sigma,Theta,invR,invRRes,condR,Objfval]=GPFit(Dh,Resph);
    
    ObjResphPreds=@(x) Fun_GPPrediction(x,Dh,Resph,Theta,Mu,Sigma,invR,invRRes);
    fvalsObjResphPreds= ObjResphPreds(AFPoints);
    [~,Sortidx]=sort(fvalsObjResphPreds);
    parfor id=1:10
        [XBestTry(id,:),fBestTry(id,1)]= patternsearch(ObjResphPreds,AFPoints(Sortidx(id),:),[],[],[],[],lb,ub,[],options);
    end
    [Resphminhats(n,:),minidx]=min(fBestTry);
    
    
    %%%%%%%Stores GP model parameters and the MLE of the calibration parameter vector
    Sigmas(n,:)=Sigma;    Thetas(n,:)=Theta;    Mus(n,:)=Mu;condRs(n,:)=condR;
    
    %%%Evaluate the true SSE at the MLE of the calibration parameter vector    
    Xhats(n,:)=XBestTry(minidx,:) ;
    Yh_Xhats(n,:)=Simulator(Xhats(n,:),2,Case);
    SSETrue_Xhats(n,:)=sum( (Yh_Xhats(n,:)-PhysData).^2);
    
    
        if Case==2
        disp(['Xhat_new and SSETrue_Xhats at  ' num2str(n) ' -iter '  num2str(Xhats(n,:))  '    ' num2str(SSETrue_Xhats(n,:))  ])
        end
    
        
    if Budget<RatioCost% RatioCost=c_h
        break
    end
    
    MinResphRefEI=Resphminhats(n,:);
    
    %%%%%%%Maximizes the EI AF and adds a follow-up design point
    MinusEIObj=@(TeD) Fun_MinusEI(TeD,Dh,Resph,Theta,Mu,Sigma,invR,invRRes,MinResphRefEI);
    fvals=MinusEIObj(AFPoints);
    [~,Sortidx]=sort(fvals);
    clear XBestTry fBestTry
    parfor id=1:10
        [XBestTry(id,:),fBestTry(id,1)]= patternsearch(MinusEIObj,AFPoints(Sortidx(id),:),[],[],[],[],lb,ub,[],options);
    end
    [fBest,minidx]=min(fBestTry);
    NextPoint=XBestTry(minidx,:) ;
    
    disp(['Current budget=' num2str(Budget) '. The ' num2str(n+1) '-th run will be at point ' num2str(NextPoint,' %1.3f ')   ])
    n=n+1;
    Dh(n,:)=NextPoint;
    Yh(n,:)=Simulator(NextPoint,2,Case);
    Level(n,:)=2;
    
    Resph(n,:)=(mean(  (Yh(n,:)-PhysData).^2))^0.5;
    
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
RecordTable=table(D,Level,Resplh,Sigmas,Thetas,Mus,Xhats,Resphminhats,SSETrue_Xhats,condRs);
end
%%
function [Mu,Sigma,Theta,invR,invRRes,condR,Objfval]=GPFit(Dh,Resph)
[n,Dim]=size(Dh);

lb=[ (0.1)*ones(1,Dim) ];
ub=[ (20)*ones(1,Dim) ];
ObjS=@(Par) Fun_NegLogLikelihood(Dh,Resph,Par,n);
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
[Objfval,Mu,Sigma,Theta,invR,invRRes,condR]=ObjS(Parin);
end
%%
function [fval,Mu,Sigma,Theta,invR,invRRes,condR]=Fun_NegLogLikelihood(D,Resph,Theta,n)

FT=ones(1,n) ;
R=ComputeRmatrix2(D,Theta);
[invR,logdetR,condR]=invandlogdet(R);
FTinvR=FT*invR;
% inv1=invandlogdet(FTinvR*F);
Mu=(FTinvR*Resph)/sum(invR,'all');

Res=Resph-Mu ;
invRRes=invR*Res;
Sigma=Res'*invRRes/ (n ) ;
fval=n*log(Sigma)+logdetR;

if any(isnan(invR),'all') || any(isinf(invR),'all') || Sigma==0
    fval=Inf;Mu=[];Sigma=[];Theta=[];invR=[];invRRes=[];condR=[];
    return
end
end
%%
function [RespPreds,RespCovs]=Fun_GPPrediction(TeD,Dh,Resph,Theta,Mu,Sigma,invR,invRRes)
nugget=1e-6;
rT=ComputeRmatrix(TeD,Dh,Theta);
rT_invR=rT*invR;
RespPreds=Mu + rT*invRRes;
RespCovs =Sigma * ( 1+nugget - sum(rT_invR.*rT,2) ) ;
RespCovs=max(RespCovs,0);
end
%%
function Fval_MinusEI=Fun_MinusEI(TeD,Dh,Resph,Theta,Mu,Sigma,invR,invRRes,minResph)

[RespPreds,RespCovs]=Fun_GPPrediction(TeD,Dh,Resph,Theta,Mu,Sigma,invR,invRRes);
SD=RespCovs.^0.5;
Bias=minResph-RespPreds;
EIfval=Bias.*normcdf(Bias./SD)+SD.*normpdf(Bias./SD);
EIfval(   logical( [RespCovs==0] |  min(pdist2(TeD,Dh),[],2) < 10^(-2)  )    )=0;
Fval_MinusEI=-EIfval;
end