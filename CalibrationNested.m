function [RecordTable,RecordData]=CalibrationNested(DataInput)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Bi-fidelity calibration method : Nested proposed by Pang et al. (2017)
%           Resph: is the square root of HF SSE
%           Respl: is the square root of LF SSE
%           Xhats: is MLE of the calibration parameter vector at all iterations
%           Resphminhats: is posterior mean of the Resph at Xhats at all iterations
%           SSETrue_Xhats: is the true values of SSE evaluated at Xhats at all iterations
% Reference: 
% Le Gratiet L, Garnier J (2014) Recursive co-kriging model for design of computer experiments with multiple levels of fidelity. Int J Uncertain Quantif, 4(5):365-386
% Pang, G., Perdikaris, P., Cai, W., & Karniadakis, G. E. (2017). Discovering variable fractional orders of advection-dispersion equations from field data using multi-fidelity Bayesian optimization. Journal of Computational Physics, 348, 694-714.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%Computes the HF response and the LF response
Dl=DataInput.Dl;
Yl=DataInput.Yl;
Dh=DataInput.Dh;
Yh=DataInput.Yh;
XTrue=DataInput.XTrue;
PhysData=DataInput.PhysData;
RatioCost=DataInput.RatioCost;
Budget=DataInput.Budget;
Case=DataInput.Case;

[nl,Dim]=size(Dl);
[nh,~]=size(Dh);
n=nl+nh;
D=[Dl; Dh];
Level=[ ones(nl,1) ; 2*ones(nh,1) ];
Resph=(sum((Yh-PhysData).^2,2)).^0.5;
Respl=(sum((Yl-PhysData).^2,2)).^0.5;

Resplh=[Respl;Resph];
Budget=Budget-(nl*1+nh*RatioCost);
DlnotDh=Dl(nh+1:nl,:);
ResplnotDh=Respl(nh+1:nl,:);

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
    %%%%%%%Fits the GP model and finds the minimum posterior mean using the recursive formulations by Le Gratiet L and Garnier J (2014)
    [Thetal,Mul,Sigmal,invRl,Objfvall,condRl,invRlRes]=GPFitLF(Dl,Respl);
    [Thetah,Rho,Muh,Sigmah,invRh,Objfvalh,condRh,invRhRes]=GPFitHF(Dh,Resph,Dl,Respl);
    
    [minResph,minidx]=min(Resph);
    Xhat_new=Dh(minidx,:) ;
    Resphminhat_new=minResph;
    
    %%%%%%%Stores GP model parameters and the MLE of the calibration parameter vector
    Sigmals(n-1:n,:)=[Sigmal;Sigmal];
    Thetals(n-1:n,:)=[Thetal;Thetal];
    Rhos(n-1:n,:)=[Rho;Rho];
    Sigmahs(n-1:n,:)=[ Sigmah;Sigmah];
    Thetahs(n-1:n,:)=[Thetah;Thetah];
    Mus(n-1:n,:)=[Mul Muh; Mul Muh];
    condRlRhs(n-1:n,:)=[condRl,condRh;condRl,condRh];

    Xhats(n-1:n,:)=[ Xhat_new; Xhat_new];
    Resphminhats(n-1:n,:)=[ Resphminhat_new; Resphminhat_new];
    
    %%%Evaluate the true SSE at the MLE of the calibration parameter vector
    Yh_Xhat_new=Yh(minidx,:);
    SSEXhat_new=sum( (Yh_Xhat_new-PhysData).^2);
    Yh_Xhats(n-1:n,:)=[ Yh_Xhat_new ; Yh_Xhat_new];
    SSETrue_Xhats(n-1:n,:)=[SSEXhat_new; SSEXhat_new  ];

    if Case==2
        disp(['Xhat_new and SSETrue_Xhats at  ' num2str(n) ' -iter '  num2str(Xhats(n,:))  '    ' num2str(SSETrue_Xhats(n,:))  ])
    end
    
    if Budget<RatioCost
        break
    end
    
    %%%%%%%Adds the follow-up design points by maximizing the EI for the HF response
    Obj_MinusEI_HF= @(x) Fun_MinusEI_HF(x,Dh,Resph,Dl,Respl,Thetal,Mul,Sigmal,invRl,invRlRes,Thetah,Rho,Muh,Sigmah,invRh,invRhRes,minResph);
    fvalEIObj=Obj_MinusEI_HF(AFPoints);
    [~,Sortidx]=sort(fvalEIObj);
    parfor id=1:10
        StartPoint=AFPoints(Sortidx(id),:);
        [XBestTry(id,:),fBestTry(id,1)]=patternsearch(Obj_MinusEI_HF,StartPoint,[],[],[],[],lb,ub,[],options);
    end
    [fBest,minidx]=min(fBestTry);
    NextPoint=XBestTry(minidx,:) ;
    disp(['Current budget=' num2str(Budget) '. The ' num2str(n+1:n+2) '-th run will be at point ' num2str(NextPoint,' %1.3f ')    ])
    
    Dh(nh+1,:)=NextPoint;
    Yh(nh+1,:)=Simulator(NextPoint,2,Case);
    Resph(nh+1,:) =sum((Yh(nh+1,:)-PhysData).^2)^0.5;
    
    Dl=[Dh;DlnotDh];
    Yl(nl+1,:)=Simulator(NextPoint,1,Case);
    Respl_new=sum((Yl(nl+1,:)-PhysData).^2)^0.5;
    Respl=[Respl(1:nh,:); Respl_new; ResplnotDh];
    
    D=[D ; NextPoint; NextPoint ];
    Level=[ Level ; 2 ;1];
    Resplh=[Resplh; Resph(nh+1,:) ; Respl_new];
        
    Budget=Budget-RatioCost-1;
    nh=nh+1;
    nl=nl+1;
    n=n+2;
end

%%%%%%%Stores design points and their corresponding simulator output
RecordData.Dl=Dl;
RecordData.Yl=Yl;
RecordData.Respl=Respl;
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
RecordTable=table(D,Level,Resplh,Sigmals,Thetals,Rhos,Sigmahs,Thetahs,Mus,Xhats,Resphminhats,SSETrue_Xhats,condRlRhs);
end
%%
%%%%%%%Gives ML estimates of the parameters of the GP model for the LF repsonse
function [Thetal,Mul,Sigmal,invRl,Objfvall,condRl,invRlRes]=GPFitLF(Dl,Respl)

[nl,Dim]=size(Dl);
lb=[(0.1)*ones(1,Dim) ];
ub=[(20)*ones(1,Dim ) ];
nvar=numel(lb) ;
Objl=@(Parl) Fun_NegLogLikehoodLF(Dl,Respl,Parl);
options=optimoptions('patternsearch','disp','off','MaxFunctionEvaluations',2000*nvar,'MaxIterations',100*nvar);

Sobolset=sobolset(nvar,'Skip',1e3,'Leap',1e2);
SobolsetPoints=net(Sobolset,1000*nvar);

parfor id=1:size(SobolsetPoints,1)
    StartPoints(id,:)=lb + (ub-lb).*SobolsetPoints(id,:);
    fvals(id,1)=Objl(StartPoints(id,:));
end
[~,Sortidx]=sort(fvals);
parfor id=1:10
    StartPoint=StartPoints(Sortidx(id),:);
    [XBestTry(id,:),fBestTry(id,1)]= patternsearch(Objl,StartPoint,[],[],[],[],lb,ub,[],options);
end
[fBest,minidx]=min(fBestTry);
Parl=XBestTry(minidx,:) ;
[Objfvall,Mul,Sigmal,invRl,Thetal,condRl,invRlRes]=Objl(Parl);
end

function [Objfvall,Mul,Sigmal,invRl,Thetal,condRl,invRlRes]=Fun_NegLogLikehoodLF(Dl,Respl,Thetal)
[nl,~]=size(Respl);
FlT=ones(1,nl);
Rl=ComputeRmatrix2(Dl,Thetal);
[invRl, logdetRl,condRl]=invandlogdet(Rl);
FlT_invRl=FlT*invRl;

Mul=(FlT_invRl*Respl)/sum(invRl,'all');
Res=Respl-Mul;
invRlRes=invRl*Res;
Sigmal=Res'*invRlRes/ (nl );
Objfvall=(nl)*log(Sigmal)+ logdetRl;
end
%%
%Gives ML estimates of the parameters of the GP model for the discrepancy term
function [Thetah,Rho,Muh,Sigmah,invRh,Objfvalh,condRh,invRhRes]=GPFitHF(Dh,Resph,Dl,Respl)

[nh,Dim]=size(Dh);
lb=[(0.1)*ones(1,Dim) ];
ub=[(20)*ones(1,Dim ) ];
nvar=numel(lb) ;
options=optimoptions('patternsearch','disp','off','MaxFunctionEvaluations',2000*nvar,'MaxIterations',100*nvar);
Objh= @(Parh) Fun_NegLogLikehoodHF(Dh,Resph,Dl,Respl,Parh);

Sobolset=sobolset(nvar,'Skip',1e3,'Leap',1e2);
SobolsetPoints=net(Sobolset,1000*nvar);
StartPoints=lb + (ub-lb).*SobolsetPoints;

for id=1:size(SobolsetPoints,1)
    fvals(id,1)=Objh(StartPoints(id,:));
end
[~,Sortidx]=sort(fvals);
parfor id=1:10
    StartPoint=StartPoints(Sortidx(id),:);
    [XBestTry(id,:),fBestTry(id,1)]= patternsearch(Objh,StartPoint,[],[],[],[],lb,ub,[],options);
end
[~,minidx]=min(fBestTry);
Parh=XBestTry(minidx,:) ;
[Objfvalh,Rho,Muh,Sigmah,invRh,Thetah,condRh,invRhRes]=Objh(Parh);
end

function [Objfvalh,Rho,Muh,Sigmah,invRh,Thetah,condRh,invRhRes]=Fun_NegLogLikehoodHF(Dh,Resph,Dl,Respl,Thetah)
[nh,~]=size(Resph);
Fh=[Respl(1:nh,:) ones(nh,1)];
Rh=ComputeRmatrix2(Dh,Thetah);
[invRh, logdetRh,condRh]=invandlogdet(Rh);
FhT_invRh=Fh'*invRh;

Betah=(FhT_invRh * Fh)\( FhT_invRh *Resph);
Rho=Betah(1);
Muh=Betah(2);
Res=Resph-Fh*Betah;
invRhRes=invRh*Res;
Sigmah=Res'*invRh*Res/ (nh);
Objfvalh=nh*log(Sigmah)+ logdetRh;
end
%%
%%%%%%%Gives the posterior mean and variance for Respl and Resph at each point from a design TeDh
function [Predh,Covh,Predl,Covl]=Fun_Prediction(TeDh,Dh,Resph,Dl,Respl,Thetal,Mul,Sigmal,invRl,invRlRes,Thetah,Rho,Muh,Sigmah,invRh,invRhRes)
[nTest,~]=size(TeDh);
nugget=1e-6;

rlT=ComputeRmatrix(TeDh,Dl,Thetal);
Predl=Mul+ rlT*invRlRes;

rhT=ComputeRmatrix(TeDh,Dh,Thetah);
fh=[ Predl ones(nTest,1) ] ;
Betah=[Rho; Muh];
Predh=fh*Betah+rhT*invRhRes;%invRh*(Resph-Fh*Betah);

Covl=Sigmal*( 1+nugget- sum(rlT*invRl.*rlT,2));
Covl=max(Covl ,0);

Covh=Rho^2*Covl+Sigmah*( 1+nugget- sum(rhT*invRh.*rhT,2));
Covh=max(Covh,0);

end
%%
%%%%%%%EI for the HF response
function Fval_MinusEI_HF=Fun_MinusEI_HF(AFPoints,Dh,Resph,Dl,Respl,Thetal,Mul,Sigmal,invRl,invRlRes,Thetah,Rho,Muh,Sigmah,invRh,invRhRes,minResph)
[Predh,Covh]=Fun_Prediction(AFPoints,Dh,Resph,Dl,Respl,Thetal,Mul,Sigmal,invRl,invRlRes,Thetah,Rho,Muh,Sigmah,invRh,invRhRes);
SD=Covh.^0.5;
Bias=minResph-Predh;
fvalEI=Bias.*normcdf(Bias./SD)+SD.*normpdf(Bias./SD);
fvalEI( (Covh==0) |  (min(pdist2(AFPoints,Dh),[],2) < 10^(-2)))=0;
Fval_MinusEI_HF=-fvalEI;
end