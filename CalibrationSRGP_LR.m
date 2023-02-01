function [RecordTable,RecordData]=CalibrationSRGP_LR(DataInput,ZRespSRGPorZRespLR)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Single fidelity calibration methods that include SR-GP, and LR
%           Resph: is a vector of HF response modeled as a GP
%           Xhats: is MLE of the calibration parameter vector at all iterations
%           Resphminhats: is posterior means/medians of the Resph at Xhats at all iterations
%           SSETrue_Xhats: is the true values of SSE evaluated at Xhats at all iterations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Referennces:
% Ranjan, P., Thomas, M., Teismann, H., & Mukhoti, S. (2016). Inverse problem for a time-series valued computer simulator via scalarization. Open Journal of Statistics, 6(3), 528-544.
% Pratola, M. T., Sain, S. R., Bingham, D., Wiltberger, M., & Rigler, E. J. (2013). Fast sequential computer model calibration of large nonstationary spatial-temporal processes. Technometrics, 55(2), 232-242.
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

N=numel(PhysData);
if ZRespSRGPorZRespLR==1%%%%%%%%%%%SR-GP
    Resph=(mean((Yh-PhysData).^2,2)).^0.5;  %Root MSE modeled as a GP in Ranjan et al. (2016)
elseif ZRespSRGPorZRespLR==0%%%%%%%%%%LR
    parfor id=1:n
        Delta=(PhysData-Yh(id,:))';
        [Logl_Unrestricted0,SobolsetTable,BestTryTable,BestTable]=GPFitUnresrictedModel(Delta,Case);
        Logl_Unrestricted(id,1)=Logl_Unrestricted0;
        BestTables(id,:)=BestTable;
        Logl_Restricted0=-1/2*N*log(Delta'*Delta/N);
        Logl_Restricted(id,1)=Logl_Restricted0;
        Resph(id,1)=-2*(Logl_Restricted0-Logl_Unrestricted0);%Minus 2 log Likelihood ratio modeled as a GP in Pratola, et al. (2013)

        CheckData(id).SobolsetTable=SobolsetTable;
        CheckData(id).BestTryTable=BestTryTable;
        CheckData(id).BestTable=BestTable;
    end
end

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
    
    if ZRespSRGPorZRespLR==1  %SR-GP
        MinResphRefEI=Resphminhats(n,:);
    elseif ZRespSRGPorZRespLR==0   %LR
        MinResphRefEI=min(Resph); 
    end
    
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
    
    if ZRespSRGPorZRespLR==1
        Resph(n,:)=(mean(  (Yh(n,:)-PhysData).^2))^0.5;
    elseif ZRespSRGPorZRespLR==0
        Delta=(PhysData-Yh(n,:))';
        [Logl_Unrestricted(n,1),SobolsetTable,BestTryTable,BestTable]=GPFitUnresrictedModel(Delta,Case);
        Logl_Restricted(n,1)=-1/2*N*log(Delta'*Delta/N);
        Resph(n,1)=-2*(Logl_Restricted(n)-Logl_Unrestricted(n));
        CheckData(n).SobolsetTable=SobolsetTable;
        CheckData(n).BestTryTable=BestTryTable;
        CheckData(n).BestTable=BestTable;
        BestTables(n,:)=BestTable;
    end
    
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
RecordData.ZResp=ZRespSRGPorZRespLR;
RecordData.Yh_Xhats=Yh_Xhats;

%%%%%%%Stores GP model parameters and the MLE of the calibration parameter vector at all iterations with a table
if ZRespSRGPorZRespLR==1
    RecordTable=table(D,Level,Resplh,Sigmas,Thetas,Mus,Xhats,Resphminhats,SSETrue_Xhats,condRs);
elseif ZRespSRGPorZRespLR==0
    RecordTable=table(D,Level,Resplh,Sigmas,Thetas,Mus,Xhats,Resphminhats,SSETrue_Xhats,condRs,Logl_Unrestricted,Logl_Restricted,BestTables);
end

end
%%
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

%%
%%%%%%%Fits the GP model for Delta (the discrepancy between simulator output and field observation)
%%%%%%%and gives the maximized value of log likelihood function for the unresricted model given by Pratola, et al. (2013) in Example 1 or Example 2
function [LogLikelihood,SobolsetTable,BestTryTable,BestTable]=GPFitUnresrictedModel(Delta,Case)
if Case==1 %For example 1
    [LogLikelihood,SobolsetTable,BestTryTable,BestTable]=GPFitUnresrictedModelE1(Delta);
elseif Case==2 %For example 2
    [LogLikelihood,SobolsetTable,BestTryTable,BestTable]=GPFitUnresrictedModelE2(Delta);
end
end

%%
%%%%%%%Fits the GP model for Delta (the discrepancy between simulator output and field observation)
%%%%%%%and gives the maximized value of log likelihood function for the unresricted model given by Pratola, et al. (2013) in Example 1
function [LogLikelihood,SobolsetTable,BestTryTable,BestTable]=GPFitUnresrictedModelE1(Delta)

lb=[log10(0.001)   log10(0.001)  -20];
ub =[log10(1000)     log10(1000)    20] ;
ObjS=@(Par) Fun_NegLogLikelihoodUnresrictedModelE1(Delta,10.^Par(1:2),10.^Par(3));
nvar=numel(ub);
options=optimoptions('patternsearch','Display','off','FunctionTolerance',1e-2,'StepTolerance',1e-3);

Sobolset=sobolset(nvar,'Skip',1e3,'Leap',1e2);
SobolsetPoints=net(Sobolset,1000*nvar);

parfor id=1:size(SobolsetPoints,1)
    StartPoints(id,:)=lb + (ub-lb).*SobolsetPoints(id,:);
    [fvals(id,1),condRLR(id,1),Theta0s(id,:),gamma(id,:)]=ObjS(StartPoints(id,:));
end

[~,Sortidx]=sort(fvals);
SobolsetTable= [Theta0s(Sortidx,:),gamma(Sortidx,:),condRLR(Sortidx,:),fvals(Sortidx,:)];

parfor id=1:20
    [x]=patternsearch(ObjS,StartPoints(Sortidx(id),:),[],[],[],[],lb,ub,[],options);
    [BestTryfvals(id,1),BestTrycondRLR(id,1),BestTryTheta0s(id,:),BestTrygamma(id,1)]=ObjS(x);
    
end
BestTryTable= [BestTryTheta0s,BestTrygamma,BestTrycondRLR,BestTryfvals] ;

[fBestfval,minidx]=min(BestTryfvals);
LogLikelihood=-fBestfval;
BestTable=BestTryTable(minidx,:);

end

function [fval,condRLR,Theta0s,gamma,inv1,Mu0,Sigma0]=Fun_NegLogLikelihoodUnresrictedModelE1(Delta,Theta0s,gamma)

Space=[ 1, 1.5, 2, 2.5 , 3]/3;NSpace=numel(Space);
dist=abs(Space-Space');
Rs=exp(-Theta0s(1)*dist.^1.99);
[Vs,DiagDs]=svd(Rs);%R1 5*5

Time=[0.3:0.3:60]';Ntime=numel(Time);%200
Rt=ComputeRMatrix0(Time,Time,Theta0s(2))+10^-6*speye(Ntime);
[Vt,DiagDt]=svd(Rt);%R2

N=NSpace*Ntime;

DiagUmiddle=1+ gamma*kron(diag(DiagDs),diag(DiagDt));
invUmiddle=diag((1./DiagUmiddle));
kronVsTVtT=kron(Vs',Vt');
logdetU=sum(log((DiagUmiddle)));
condRLR=max(DiagUmiddle)/min(DiagUmiddle);
if any(isnan(DiagUmiddle),'all')  ||  any(isinf(DiagUmiddle),'all')
    fval=Inf;
    return
elseif any(isnan(Vs),'all')  ||  any(isinf(Vs),'all')
    fval=Inf;
    return
elseif any(isnan(Vt),'all')  ||  any(isinf(Vt),'all')
    fval=Inf;
    return
end
kronVsTVtTOnes=kron(Vs'*ones(NSpace,1),Vt'*ones(Ntime,1));%1
invUmiddlekronVsTVtTOnes=invUmiddle*kronVsTVtTOnes;%2
kronVsTVtTDelta=kronVsTVtT*Delta;%3

inv1=1./(kronVsTVtTOnes'*invUmiddlekronVsTVtTOnes) ;
Mu0=inv1*(invUmiddlekronVsTVtTOnes'* kronVsTVtTDelta) ; %4
E=kronVsTVtTDelta-kronVsTVtTOnes*Mu0;
Sigma0=sum(invUmiddle.*E.^2,'all')/ (N );  %@@@add 'all'
% Sigma0=(E'*invUmiddle*E)/ (N );  %@@@add 'all'
LogLikelihood0=-1/2*(logdetU +N*log(Sigma0) );
fval=-LogLikelihood0;  %@@@
end
%%
%%%%%%%Fits the GP model for Delta (the discrepancy between simulator output and field observation)
%%%%%%%and gives the maximized value of log likelihood function for the unresricted model given by Pratola, et al. (2013) in Example 2
function [LogLikelihood,SobolsetTable,BestTryTable,BestTable]=GPFitUnresrictedModelE2(Delta)

lb=[log10(0.001)   log10(0.001)  -20];
ub =[log10(1000)     log10(1000)    20] ;
ObjS=@(Par) Fun_NegLogLikelihoodUnresrictedModelE2(Delta,10.^Par(1:2),10.^Par(3));
nvar=numel(ub);
options=optimoptions('patternsearch','Display','off','FunctionTolerance',1e-2,'StepTolerance',1e-3);

Sobolset=sobolset(nvar,'Skip',1e3,'Leap',1e2);
SobolsetPoints=net(Sobolset,1000*nvar);

parfor id=1:size(SobolsetPoints,1)
    StartPoints(id,:)=lb + (ub-lb).*SobolsetPoints(id,:);
    [fvals(id,1),condRLR(id,1),Theta0s(id,:),gamma(id,:)]=ObjS(StartPoints(id,:));
end

[~,Sortidx]=sort(fvals);
SobolsetTable= [Theta0s(Sortidx,:),gamma(Sortidx,:),condRLR(Sortidx,:),fvals(Sortidx,:)];

parfor id=1:20
    [x]=patternsearch(ObjS,StartPoints(Sortidx(id),:),[],[],[],[],lb,ub,[],options);
    [BestTryfvals(id,1),BestTrycondRLR(id,1),BestTryTheta0s(id,:),BestTrygamma(id,1)]=ObjS(x);
    
end
BestTryTable= [BestTryTheta0s,BestTrygamma,BestTrycondRLR,BestTryfvals] ;

[fBestfval,minidx]=min(BestTryfvals);
LogLikelihood=-fBestfval;
BestTable=BestTryTable(minidx,:);

end

function [fval,condRLR,Theta0s,gamma,inv1,Mu0,Sigma0]=Fun_NegLogLikelihoodUnresrictedModelE2(Delta,Theta0s,gamma)%Method 0

Space=[  2.88,3.13,2.55 ; 2.88,1.13,2.55 ]; NSpace=2;
dist=pdist2(Space,Space);
Rs=exp(-Theta0s(1)*dist.^1.99);
[Vs,DiagDs]=svd(Rs);%R1  2-by-2  %'vector' econ

NumTimePoints=11;
Time=[1:NumTimePoints]'/NumTimePoints;     NTime=numel(Time);
Rt=ComputeRMatrix0(Time,Time,Theta0s(2))+10^-6*speye(numel(Time));%11*11
[Vt,DiagDt]=svd(Rt);%R2

N=NSpace*NTime;


DiagUmiddle=1+ gamma*kron(diag(DiagDs),diag(DiagDt));
invUmiddle=diag((1./DiagUmiddle));
kronVsTVtT=kron(Vs',Vt');
logdetU=sum(log((DiagUmiddle)));
condRLR=max(DiagUmiddle)/min(DiagUmiddle);
if any(isnan(DiagUmiddle),'all')  ||  any(isinf(DiagUmiddle),'all')
    fval=Inf;
    return
elseif any(isnan(Vs),'all')  ||  any(isinf(Vs),'all')
    fval=Inf;
    return
elseif any(isnan(Vt),'all')  ||  any(isinf(Vt),'all')
    fval=Inf;
    return
end
kronVsTVtTOnes=kron(Vs'*ones(NSpace,1),Vt'*ones(NTime,1));%1
invUmiddlekronVsTVtTOnes=invUmiddle*kronVsTVtTOnes;%2
kronVsTVtTDelta=kronVsTVtT*Delta;%3

inv1=1./(kronVsTVtTOnes'*invUmiddlekronVsTVtTOnes) ;
Mu0=inv1*(invUmiddlekronVsTVtTOnes'* kronVsTVtTDelta) ; %4
E=kronVsTVtTDelta-kronVsTVtTOnes*Mu0;
Sigma0=sum(invUmiddle.*E.^2,'all')/ (N );  %@@@add 'all'
% Sigma0=(E'*invUmiddle*E)/ (N );  %@@@add 'all'
LogLikelihood0=-1/2*(logdetU +N*log(Sigma0) );
fval=-LogLikelihood0;  %@@@
end


%%
%Computes the prior correlation matrix given by the Gaussian correlation used for log likelihood function in the unresricted model  given by Pratola, et al. (2013)
function R=ComputeRMatrix0(Xs,Ys,Theta0s)
[nX,Dim]=size(Xs);
[nY,~]=size(Ys);

if Dim ~= numel(Theta0s)
    %     Theta0s
    %     Dim
    disp('Dimension does not match for input and correlation parameters')
    Dimension does not match for input and correlation parameters
end

R=ones(nX,nY);
for id=1:Dim
    x=Xs(:,id);
    y=Ys(:,id)';
    Theta0=Theta0s(id);
    d=abs(x-y);
    R=R.* [exp( -Theta0.*d.^1.99) ] ;% Gaussian correlation function
end
end