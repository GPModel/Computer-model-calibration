function [RecordTable,RecordData]=CalibrationAGP(DataInput,ZNBC,ZMLFSSEorZLFSSE)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Bi-fidelity calibration methods that include MBC-AGP, BC-AGP, ID-AGP and SR-AGP methods
%           Resph: is the HF SSE
%           Respl: is the LF SSE or modified LF SSE
%           Xhats: is MLE of the calibration parameter vector at all iterations
%           Resphminhats: is posterior means/medians of the Resph at Xhats at all iterations
%           SSETrue_Xhats: is the true values of SSE evaluated at Xhats at all iterations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%Computes the untransformed HF and the LF responses
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
if ZMLFSSEorZLFSSE==1
    NTimePoints=numel(PhysData);
    [~,idxinDl,idxinDh]=intersect(Dl,Dh,'rows','stable');
    SameYl=Yl(idxinDl,:);
    SameYh=Yh(idxinDh,:);
    Ones2=ones(numel(idxinDh),1);
    for kd=1:NTimePoints
        ai_bi(:,kd)=regress(SameYh(:,kd),[Ones2,SameYl(:,kd)]);
    end
    YlModified=ai_bi(1,:)+Yl.*ai_bi(2,:);
    Respl=sum((YlModified-PhysData).^2,2);
    Resph=sum((Yh-PhysData).^2,2);
elseif ZMLFSSEorZLFSSE==0
    Resph=sum((Yh-PhysData).^2,2);
    Respl=sum((Yl-PhysData).^2,2);
end

Resplh= [Respl;Resph ];
Budget=Budget-(nl*1+nh*RatioCost);%Remaining budget 

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
    [Objfval,Sigmal,Thetal,Rho,RatioSigmah,Sigmah,Thetah,phi,Mu,V,invV,invVRes,condV]= AGPFit(Dl,Respl,Dh,Resph,ZNBC);
    
    Obj_Fun_ZhQuantile=@(x) Fun_ZhQuantile(x,2,Dl,Respl,Dh,Resph,Sigmal,Thetal,Rho,Sigmah,Thetah,phi,ZNBC,Mu,invV,invVRes);
    [~,Sortidx]=sort(Obj_Fun_ZhQuantile(AFPoints));
    parfor id=1:10
        [XBestTry(id,:),fBestTry(id,1)]= patternsearch(Obj_Fun_ZhQuantile,AFPoints(Sortidx(id),:),[],[],[],[],lb,ub,[],options);
    end
    [MinZhQuantile,minidx]=min(fBestTry);
    Xhat_new=XBestTry(minidx,:) ;
        
    %%%%%%%Stores GP model parameters and the MLE of the calibration parameter vector
    Objfvals(n,:)=Objfval;    Sigmals(n,:)=Sigmal;    Thetals(n,:)=Thetal;    Rhos(n,:)=Rho;
    RatioSigmahs(n,:)=RatioSigmah;    Sigmahs(n,:)=Sigmah;    Thetahs(n,:)=Thetah;
    phis(n,:)=phi;      Mus(n,:)=Mu;    condVs(n,:)=condV;
    
    Xhats(n,:)=Xhat_new;
    Resphminhats(n,:)=TransformData_inv(MinZhQuantile,phi,ZNBC);
    
    %%%Evaluate the true SSE at the MLE of the calibration parameter vector
    Yh_Xhats(n,:)=Simulator(Xhat_new,2,Case);
    SSETrue_Xhats(n,:)=sum( (Yh_Xhats(n,:)-PhysData).^2);
    
    if Case==2
        disp(['Xhat_new and SSETrue_Xhats at  ' num2str(n) ' -iter '  num2str(Xhats(n,:))  '    ' num2str(SSETrue_Xhats(n,:))  ])
    end
    
    if Budget<1 %=c_l
        break
    end
    
    %%%%%%%Adds a follow-up design point by Maximizing the AF
    [NextPoint,NextLevel]=SequentialRun_AEI(Budget,RatioCost,Dl,Respl,Dh,Resph,Sigmal,Thetal,Rho,Sigmah,Thetah,phi,ZNBC,Mu,invV,invVRes,AFPoints,Xhat_new);
    
    disp(['Current budget=' num2str(Budget) '. The ' num2str(n+1) '-th run will be at point ' num2str(NextPoint,' %1.3f ') ' at Level ' num2str(NextLevel)  ])
    n=n+1;
    if NextLevel==1%%%%%%%Adds a LF design point
        nl=nl+1;
        Dl(nl,:)=NextPoint;
        Yl(nl,:)=Simulator(NextPoint,1,Case);
        if ZMLFSSEorZLFSSE==1
            YlModified=ai_bi(1,:)+Yl.*ai_bi(2,:);
            Respl=sum((YlModified-PhysData).^2,2);
        elseif ZMLFSSEorZLFSSE==0
            Respl=sum((Yl-PhysData).^2,2);
        end
        Budget=Budget-1;
        Resplh(n,1)=Respl(nl,:);
        
    else%%%%%%%Adds a HF design point
        nh=nh+1;
        Dh(nh,:)=NextPoint;
        Yh(nh,:)=Simulator(NextPoint,2,Case);
        Resph=sum((Yh-PhysData).^2,2);
        if ZMLFSSEorZLFSSE==1
            [~,idxinDl,idxinDh]=intersect(Dl,Dh,'rows','stable');
            SameYl=Yl(idxinDl,:);
            SameYh=Yh(idxinDh,:);
            Ones2=ones(numel(idxinDh),1);
            for kd=1:NTimePoints
                ai_bi(:,kd)=regress(SameYh(:,kd),[Ones2,SameYl(:,kd)]);
            end
            YlModified=ai_bi(1,:)+Yl.*ai_bi(2,:);
            Respl=sum((YlModified-PhysData).^2,2);
        end
        Budget=Budget-RatioCost;
        Resplh(n,1)=Resph(nh,:);
    end
    
    D(n,:)=NextPoint;
    Level(n,:)=NextLevel;
    
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
RecordData.Yh_Xhats=Yh_Xhats;

%%%%%%%Stores GP model parameters and the MLE of the calibration parameter vector at all iterations with a table
RecordTable=table(D,Level,Resplh,Objfvals,Sigmals,Thetals,Rhos,RatioSigmahs,Sigmahs,Thetahs,phis,Mus,Xhats,Resphminhats,SSETrue_Xhats,condVs);
end
%%
function [Objfval,Sigmal,Thetal,Rho,RatioSigmah,Sigmah,Thetah,phi,Mu,V,invV,invVRes,condV]=AGPFit(Dl,Respl,Dh,Resph,ZNBC)
[nl,Dim]=size(Dl);
[nh,~]=size(Dh);

if ZNBC==1
    lb=[    (0.1)*ones(1,Dim)       (0.1)*ones(1,Dim)          0             -3      -2 ];
    ub=[      (20)*ones(1,Dim)    (20)*ones(1,Dim)           10             6       2 ];
    Obj_NegLogL=@(Par) Fun_NegLogLikelihood(Dl,Respl,Dh,Resph,ZNBC,Par(1:Dim),Par((Dim+1):(2*Dim)),Par(2*Dim+1),10^Par(2*Dim+2),Par(2*Dim+3),nl,nh);
elseif ZNBC==0 || ZNBC==2
    lb=[    (0.1)*ones(1,Dim)       (0.1)*ones(1,Dim)          0             -3       ];
    ub=[      (20)*ones(1,Dim)    (20)*ones(1,Dim)           10             6      ];
    Obj_NegLogL=@(Par) Fun_NegLogLikelihood(Dl,Respl,Dh,Resph,ZNBC,Par(1:Dim),Par((Dim+1):(2*Dim)),Par(2*Dim+1),10^Par(2*Dim+2),0,nl,nh);
end
nvar=numel(lb);
options=optimoptions('patternsearch','disp','off','MaxFunctionEvaluations',2000*nvar,'MaxIterations',100*nvar); %Default optimoptions
Sobolset=sobolset(nvar,'Skip',1e3,'Leap',1e2);

NS=1000*nvar;
SobolsetPoints=net(Sobolset,NS);
StartPoints=lb + (ub-lb).*SobolsetPoints;

fvals=zeros(NS,1);
parfor id=1:NS
    fvals(id,1)=Obj_NegLogL(StartPoints(id,:));
end
[~,Sortidx]=sort(fvals);
parfor id=1:10
    [XBestTry(id,:),fBestTry(id,1)]= patternsearch(Obj_NegLogL,StartPoints(Sortidx(id),:),[],[],[],[],lb,ub,[],options); %#ok<PFBNS>
end
[~,minidx]=min(fBestTry);
ParIn=XBestTry(minidx,:) ;

[Objfval,Sigmal,Thetal,Rho,RatioSigmah,Sigmah,Thetah,phi,Mu,V,invV,invVRes,condV]=Obj_NegLogL(ParIn);
end
%%
function [Objfval,Sigmal,Thetal,Rho,RatioSigmah,Sigmah,Thetah,phi,Mu,V,invV,invVRes,condV,invVprime,invVprimeRes,ZData]=Fun_NegLogLikelihood(Dl,Respl,Dh,Resph,ZNBC,Thetal,Thetah,Rho,RatioSigmah,phi,nl,nh)

[ZData,SumLogdZ]=TransformData([Respl;Resph],phi,ZNBC);

VprimeDl_Dh=Rho*ComputeRmatrix(Dl,Dh,Thetal);
Vprime=[ ComputeRmatrix2(Dl,Thetal) ,           VprimeDl_Dh;
    VprimeDl_Dh' , Rho^2*ComputeRmatrix(Dh,Dh,Thetal)+RatioSigmah*ComputeRmatrix2(Dh,Thetah) ];

F=[                ones(nl,1) , zeros(nl,1);
    Rho*ones(nh,1) , ones(nh,1)];
[invVprime,logdetVprime,condV]=invandlogdet(Vprime);
if any(isnan(invVprime),'all')  ||  any(isinf(invVprime),'all')
    Objfval=Inf;Sigmal=[];Thetal=[];Rho=[];RatioSigmah=[];Sigmah=[];Thetah=[];phi=[];Mu=[];V=[];invV=[];invVRes=[];condV=[];invVprime=[];invVprimeRes=[];ZData=[];
    return
end
FT_invVprime=F'*invVprime;
[inv1,~]=invandlogdet(FT_invVprime*F);

Mu=inv1*FT_invVprime*ZData;
Res=ZData-F*Mu;

invVprimeRes=invVprime*Res;
Sigmal=(Res'*invVprimeRes)/(nl+nh);

Objfval=logdetVprime+(nl+nh)*log(Sigmal)     - 2*SumLogdZ;

Sigmah=RatioSigmah*Sigmal;
V=Vprime*Sigmal;
invV=invVprime/Sigmal;
invVRes=invVprimeRes/Sigmal;
end
%%
function Fval_ZhQuantile=Fun_ZhQuantile(TeD,Level,Dl,Respl,Dh,Resph,Sigmal,Thetal,Rho,Sigmah,Thetah,phi,ZNBC,Mu,invV,invVRes)
[ZhPreds,ZhCovs]=Fun_PredictionZ(TeD,Level,Dl,Respl,Dh,Resph,Sigmal,Thetal,Rho,Sigmah,Thetah,phi,ZNBC,Mu,invV,invVRes);
Fval_ZhQuantile=ZhPreds+norminv(0.9)*ZhCovs.^0.5; %ZhQuantile at TeD
end
%%
function [ZhPreds,ZhCovs,ZlPreds,ZlCovs,Corrs,CrossCovs]=Fun_PredictionZ(TeD,Level,Dl,Respl,Dh,Resph,Sigmal,Thetal,Rho,Sigmah,Thetah,phi,ZNBC,Mu,invV,invVRes,ForAEI)
ZhPreds=[];
ZhCovs=[];
ZlPreds=[];
ZlCovs=[];
Corrs=[];
CrossCovs=[];
nugget=1e-6;
if Level==1
    fl=[1 ,0 ] ;
    rlT= [ Sigmal*ComputeRmatrix(TeD,Dl,Thetal) , Rho*Sigmal*ComputeRmatrix(TeD,Dh,Thetal)];
    rlT_invV=rlT*invV;
    ZlPreds=fl*Mu + rlT*invVRes;
    ZlCovs=Sigmal*(1+nugget) - sum(rlT_invV.*rlT,2);%%column vector
    ZlCovs=max(ZlCovs,0);
    
    if(nargin>16)
        %%%Covariance and correlation coefficient between Zh(TeD)|Z and Zl(TeD)|Z
        fh=[Rho ,1];
        rhT=[ Rho*Sigmal*ComputeRmatrix(TeD,Dl,Thetal) , Rho^2*Sigmal*ComputeRmatrix(TeD,Dh,Thetal)+Sigmah*ComputeRmatrix(TeD,Dh,Thetah) ] ;
        rhT_invV=rhT*invV;
        ZhPreds=fh*Mu + rhT*invVRes;
        ZhCovs= Rho^2*Sigmal + Sigmah*(1+nugget) - sum(rhT_invV.*rhT,2);%column vector
        ZhCovs=max(ZhCovs,0);
        
        CrossCovs=Rho*Sigmal*(1+nugget) - sum(rlT_invV.*rhT,2);%column vector
        Corrs=CrossCovs./ ((ZlCovs).^0.5) ./ ((ZhCovs).^0.5);%column vector
        Corrs(((ZhCovs==0) | (ZlCovs==0)  ))=0;%column vector
        Corrs=min(Corrs,1);
    end
    
end
if Level==2
    fh=[Rho ,1];
    rhT=[ Rho*Sigmal*ComputeRmatrix(TeD,Dl,Thetal) , Rho^2*Sigmal*ComputeRmatrix(TeD,Dh,Thetal)+Sigmah*ComputeRmatrix(TeD,Dh,Thetah) ] ;
    ZhPreds=fh*Mu + rhT*invVRes;
    rhT_invV=rhT*invV;
    ZhCovs= Rho^2*Sigmal + Sigmah*(1+nugget) - sum(rhT_invV.*rhT,2);%column vector
    ZhCovs=max(ZhCovs,0);
end

end
%%
function [NextPoint,NextLevel]=SequentialRun_AEI(Budget,RatioCost,Dl,Respl,Dh,Resph,Sigmal,Thetal,Rho,Sigmah,Thetah,phi,ZNBC,Mu,invV,invVRes,AFPoints,Xhat_new)
Dim=size(Dl,2);
lb=0*ones(1,Dim);ub=1*ones(1,Dim);
options=optimoptions('patternsearch','disp','off');
minZhRef=Fun_PredictionZ(Xhat_new,2,Dl,Respl,Dh,Resph,Sigmal,Thetal,Rho,Sigmah,Thetah,phi,ZNBC,Mu,invV,invVRes);
if Budget<RatioCost

    NextLevel=1;
    Obj_Fun_MinusAEI=@(x) Fun_MinusAEI(x,minZhRef,RatioCost,NextLevel,Dl,Respl,Dh,Resph,Sigmal,Thetal,Rho,Sigmah,Thetah,phi,ZNBC,Mu,invV,invVRes);
    [~,Sortidx]=sort(Obj_Fun_MinusAEI(AFPoints));
    parfor id=1:10
        [XBestTry(id,:),fBestTry(id,1)]= patternsearch(Obj_Fun_MinusAEI,AFPoints(Sortidx(id),:),[],[],[],[],lb,ub,[],options);
    end
    [fBest,minidx]=min(fBestTry);
    NextPoint=XBestTry(minidx,:) ;
    
else
    Level1=1;
    Obj_Fun_MinusAEI1=@(x) Fun_MinusAEI(x,minZhRef,RatioCost,Level1,Dl,Respl,Dh,Resph,Sigmal,Thetal,Rho,Sigmah,Thetah,phi,ZNBC,Mu,invV,invVRes);
    [~,Sortidx]=sort(Obj_Fun_MinusAEI1(AFPoints));
    parfor id=1:10
        [XBestTry(id,:),fBestTry(id,1)]= patternsearch(Obj_Fun_MinusAEI1,AFPoints(Sortidx(id),:),[],[],[],[],lb,ub,[],options);
    end
    [fval_MinusAEI1,minidx]=min(fBestTry);
    NextPoint1=XBestTry(minidx,:) ;
    
    Level2=2;
    Obj_Fun_MinusAEI2=@(x) Fun_MinusAEI(x,minZhRef,RatioCost,Level2,Dl,Respl,Dh,Resph,Sigmal,Thetal,Rho,Sigmah,Thetah,phi,ZNBC,Mu,invV,invVRes);
    [~,Sortidx]=sort(Obj_Fun_MinusAEI2(AFPoints));
    parfor id=1:10
        [XBestTry(id,:),fBestTry(id,1)]= patternsearch(Obj_Fun_MinusAEI2,AFPoints(Sortidx(id),:),[],[],[],[],lb,ub,[],options);
    end
    [fval_MinusAEI2,minidx]=min(fBestTry);
    NextPoint2=XBestTry(minidx,:) ;
    
    %[fval_MinusAEI1 fval_MinusAEI2 ]
    if fval_MinusAEI1<= fval_MinusAEI2
        NextPoint=NextPoint1;        NextLevel=1;
    else
        NextPoint=NextPoint2;        NextLevel=2;
    end
end

end
%%
function [fval_MinusAEI,EIs,Corrs,ZhCovs]=Fun_MinusAEI(TeD,MinZhRef,RatioCost,AEILevel,Dl,Respl,Dh,Resph,Sigmal,Thetal,Rho,Sigmah,Thetah,phi,ZNBC,Mu,invV,invVRes)

if AEILevel==2
    Corrs=1;RatioCost1=1;
    TeDLevel2=2;
    [ZhPreds,ZhCovs]=Fun_PredictionZ(TeD,TeDLevel2,Dl,Respl,Dh,Resph,Sigmal,Thetal,Rho,Sigmah,Thetah,phi,ZNBC,Mu,invV,invVRes);
    Bias=MinZhRef-ZhPreds;
    SD=ZhCovs.^0.5;
    EIs=Bias.*normcdf(Bias./SD) +SD.*normpdf(Bias./SD);
    fvalAEIs=EIs.*Corrs*RatioCost1;
    fvalAEIs(  [ZhCovs==0] |  (min(pdist2(TeD,Dh),[],2) < 10^(-2))         ) =0;   % 2 or 4  or 6  %n(TeD)*n(Dh) matrix
    
elseif AEILevel==1
    
    ForAEI=1;
    TeDLevel1=1;
    [ZhPreds,ZhCovs,~,~,Corrs]=Fun_PredictionZ(TeD,TeDLevel1,Dl,Respl,Dh,Resph,Sigmal,Thetal,Rho,Sigmah,Thetah,phi,ZNBC,Mu,invV,invVRes,ForAEI);
    Bias=MinZhRef-ZhPreds;
    SD=ZhCovs.^0.5;
    EIs=Bias.*normcdf(Bias./SD) +SD.*normpdf(Bias./SD);
    fvalAEIs=EIs.*Corrs*RatioCost;
    fvalAEIs(  [ min(pdist2(TeD,Dl),[],2) < 10^(-2)] |   [min(pdist2(TeD,Dh),[],2) < 10^(-2)] |  [Corrs < 0]      )=0; %1 and 3 and 4 and 5
end
fval_MinusAEI=-fvalAEIs;
end