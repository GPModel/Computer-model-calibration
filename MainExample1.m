%%%%%% %Section 1: Sets parameters for all calibration methods
clc,clear,format compact
Dim=2;
Case=1;
nl=15;
nh=5;
nh0=10;
RatioCost=3;
InitialBudget=nl*1+nh*RatioCost;%30
Budget=InitialBudget+RatioCost*5;%45
XTrue=[0.7 0.2];
NoTrials=200;

[yh_XTrue]= Simulator(XTrue,2,Case);
std_error=(var(yh_XTrue)*0.0001)^0.5;
PhysData=yh_XTrue+normrnd(0,std_error,size(yh_XTrue));
SSE_XTrue=sum([Simulator(XTrue,2,Case)-PhysData].^2);

[X1,X2]=meshgrid(linspace(0,1,51)');
TestPoints= [X1(:) X2(:)];
for id=1:size(TestPoints,1)
    TrueSh(id,1)=sum((Simulator(TestPoints(id,:),2,Case)-PhysData).^2); %HF SSE
end
[~,sortidx]=sort(TrueSh);

lb=0*ones(1,Dim);
ub=1*ones(1,Dim);
options=optimoptions('patternsearch','MaxIterations',10^6,'MeshTolerance',10^-6,'TolFun',10^-8,'TolX',10^-8,'MaxFunEvals',10^8);

SSHFun=@(x) sum([Simulator(x,2,Case)-PhysData].^2);
for id=1:50
    StartPoint= TestPoints(sortidx(id),:);
    [XMLETry(id,:),fval(id,:)]=patternsearch(SSHFun,StartPoint,[],[],[],[],lb,ub,[],options)  ;
end
[~,minidx]=min(fval);
XMLE=XMLETry(minidx,:);
SSE_XMLE=min(fval);

XTrue
SSE_XTrue
XMLE
SSE_XMLE

%%
% Generates 200 initial designs

for id =1:NoTrials
    disp(id)
    [Dl,Dh]=GenerateNestedLHD(nl,nh,Dim,1e3);     %Design for bi-fidelity Bayesian optimization
    [Dh0]=GenerateNestedLHD(nh0,nh0,Dim,1e3);     %Design for bi-fidelity Bayesian optimization
    clear Yl Yh
    for jd=1:nl
        Yl(jd,:)=Simulator(Dl(jd,:),1,Case);
    end
    for jd=1:nh
        Yh(jd,:)=Simulator(Dh(jd,:),2,Case);
    end
    clear  Yh0
    for jd=1:nh0
        Yh0(jd,:)=Simulator(Dh0(jd,:),2,Case);
    end
    
    MultiDataInput(id).Dl=Dl;       MultiDataInput(id).Yl=Yl;
    MultiDataInput(id).Dh= Dh;    MultiDataInput(id).Yh=Yh;
    MultiDataInput(id).XTrue=XTrue;
    MultiDataInput(id).PhysData=PhysData;    MultiDataInput(id).RatioCost=RatioCost;
    MultiDataInput(id).Budget=Budget;           MultiDataInput(id).Case=Case;
    
    SingleDataInput(id).Dl =[] ;       SingleDataInput(id).Yl=[];
    SingleDataInput(id).Dh= Dh0;    SingleDataInput(id).Yh=Yh0;
    SingleDataInput(id).XTrue=XTrue;
    SingleDataInput(id).PhysData=PhysData;    SingleDataInput(id).RatioCost=RatioCost;
    SingleDataInput(id).Budget=Budget;          SingleDataInput(id).Case=Case;
end

save Example1.mat

%%
%Plot Figure 2, and boxplots of correlation between Sh and Sl, and Sh and modified Sl based on 200 initial designs...
clear
load Example1.mat

for id =1:NoTrials
    id
    Yl = MultiDataInput(id).Yl(1:nh,:);
    Yh = MultiDataInput(id).Yh;
    
    Sl=sum( [Yl-PhysData].^2,2);
    Sh=sum( [Yh-PhysData].^2,2);
    
    clear AaGrid
    Ones=ones(nh,1);
    for kd=1:numel(PhysData)
        AaGrid(:,kd)=regress(Yh(:,kd),[Ones,Yl(:,kd)]);
    end
    
    ModifiedYl=AaGrid(1,:)+Yl.*AaGrid(2,:);
    ModifiedSl=sum((ModifiedYl-PhysData).^2,2);
    
    CorrSlSh(id,1)=corr(Sl,Sh);
    CorrModifiedSlSh(id,1)=corr(ModifiedSl,Sh);
    
    
    [~,~,r_ShSl]=regress(Sh,[Ones,Sl]);
    MLE_Error_ShSl(id,1)=(sum(r_ShSl.^2))/(nh);
        
    [~,~,r_Sh_ModifiedSl]=regress(Sh,[Ones,ModifiedSl]);
    MLE_Error_Sh_ModifiedSl(id,1)=(sum(r_Sh_ModifiedSl.^2))/(nh);
    
end

    
FontSize7=33 ;
figure(11),clf
labels2={'Correlation between', 'Correlation between'};
boxplot([CorrModifiedSlSh CorrSlSh],'labels',labels2);
set(findobj(gcf,'type','axes'),'FontWeight','Bold', 'LineWidth', 2,'FontSize',21)
ylim([0.85 1.01])
set(gca,'Position',[0.1 0.25 0.88 0.74] )
text(1,0.81,'$S_h(\cdot)$ and $S''_l(\cdot)$   ','FontSize',21,'FontWeight','Bold','HorizontalAlignment','center','Interpreter','latex')
text(2,0.81,'$S_h(\cdot)$ and $S_l(\cdot)$     ','FontSize',21,'FontWeight','Bold','HorizontalAlignment','center','Interpreter','latex')
set(gcf,'position', [  876   457   650   300])
hAx=gca;
hAx.XAxis.TickLabelInterpreter='latex';


figure(12),clf
Labels2methods={'  Linear regression of \mbox{               }' , '\mbox{            }       Linear regression of  '};
boxplot([MLE_Error_Sh_ModifiedSl MLE_Error_ShSl  ],'Labels',Labels2methods)
hAx=gca;
hAx.XAxis.TickLabelInterpreter='latex';
set(gca,'YScale','log','Position',[0.15 0.25 0.83 0.74] )
set(findobj(gca,'type','line'),'linew',2)
set(findobj(gcf,'type','axes'),'FontSize',FontSize7,'FontWeight','Bold', 'LineWidth', 2);
yticks(10.^[-1:7])
ylim([10^2 2.3*10^7])
Ratio= 0.4846;
Length=950;
ylabel('MLE of error variance        ','FontSize',30,'HorizontalAlignment','center','VerticalAlignment','baseline')
set(gcf,'position' , [100, 100 , Length ,Length*Ratio]) 
set(findobj(gcf,'type','axes'),'FontWeight','Bold', 'LineWidth', 3);
text(1,5,'$S_h(\cdot)$ on $S''_l(\cdot)$   ','FontSize',FontSize7,'FontWeight','Bold','HorizontalAlignment','center','Interpreter','latex')
text(2,5,'$S_h(\cdot)$ on $S_l(\cdot)$     ','FontSize',FontSize7,'FontWeight','Bold','HorizontalAlignment','center','Interpreter','latex')

%%
% % % % % % % % % % % % % % % Plot SSE in Figure 2 in the Paper
Fontsize2=32;
[tempX1,tempX2]=meshgrid(0.05:0.1:1);%10 x 10 grid
GridPoints=[tempX1(:),tempX2(:)] ;
clear YlGrid YhGrid
for id=1:size(GridPoints,1)
    YlGrid(id,:)=Simulator(GridPoints(id,:),1,Case);
    YhGrid(id,:)=Simulator(GridPoints(id,:),2,Case);
end

Ones=ones(100,1);
for kd=1:numel(PhysData)
    AaGrid(:,kd)=regress(YhGrid(:,kd),[Ones,YlGrid(:,kd)]);
end %Estimates of a_i's and b_i's using data on the 10 x 10 grid

for id=1:size(X1,1)
    for jd=1:size(X1,2)
        yl0=Simulator([X1(id,jd),X2(id,jd)],1,Case);
        yh0=Simulator([X1(id,jd),X2(id,jd)],2,Case);
        YlModifiedGrid=AaGrid(1,:)+yl0.*AaGrid(2,:);
        
        fLFSSEModified(id,jd)=sum((YlModifiedGrid-PhysData).^2); %S'_l on a 51 x 51 grid
        
        fLFSSE(id,jd)=sum([yl0-PhysData].^2); %LF SSE on a 51 x 51 grid 
        fHFSSE(id,jd)=sum([yh0-PhysData].^2); %HF SSE on a 51 x 51 grid 
    end
end

FontSizeLevels=28
Levels=[  80  400  1e3 2e3 4e3  10e3   20e3 40e3 60e3] ;


figure(2),clf%in the Paper
tiledlayout(1,3,'Padding','none','TileSpacing','none');
nexttile%Figure 2 (a)
[C,h] = contour(X1,X2,fLFSSE,Levels) ;
clabel(C,h,'FontWeight','bold','FontSize',FontSizeLevels,'Color','k','linewidth',2)
set(gca,'FontWeight','bold','FontSize',Fontsize2)
xlabel('x_1','FontSize',Fontsize2)
ylabel('x_2','FontSize',Fontsize2,'Rotation',0,'HorizontalAlignment','right')
title('(a)','FontSize',Fontsize2)
xticks([0:0.2:1])
yticks([0:0.2:1])
       
nexttile%Figure 2 (b)
[C,h] = contour(X1,X2,fHFSSE,Levels);
clabel(C,h,'FontWeight','bold','FontSize',FontSizeLevels,'Color','k','linewidth',2)
set(gca,'FontWeight','bold','FontSize',Fontsize2)
xlabel('x_1','FontSize',Fontsize2)
ylabel('x_2','FontSize',Fontsize2,'Rotation',0,'HorizontalAlignment','right')
title('(b)','FontSize',Fontsize2)
xticks([0:0.2:1])
yticks([0:0.2:1])

nexttile%Figure 2 (c)
[C,h] = contour(X1,X2,fLFSSEModified,Levels);
clabel(C,h,'FontWeight','bold','FontSize',FontSizeLevels,'Color','k','linewidth',2)
set(gca,'FontWeight','bold','FontSize',Fontsize2)
xlabel('x_1','FontSize',Fontsize2)
ylabel('x_2','FontSize',Fontsize2,'Rotation',0,'HorizontalAlignment','right')
title('(c)','FontSize',Fontsize2)
xticks([0:0.2:1])
yticks([0:0.2:1])
set(findobj(gcf,'type','axes'), 'FontWeight','Bold', 'LineWidth', 3);
set(gcf,'position'  ,[          0 0         1600         561])
% set(gcf,'position'  ,[          0 0         1600         500])
%%
%%%%%%%%%%%%%%%%%%%%R2 and MLE of error variance for linear regression of Sh on Sl m and linear regression of Sh on modified Sl
n=51^2;
Ones=ones(n,1);
[A,~,r_Sh_Sl,~,stat_Sh_Sl ]=regress(fHFSSE(:),[Ones,fLFSSE(:)]);
MLE_Error_Sh_Sl=(sum(r_Sh_Sl.^2))/(n);
R2_Sh_Sl=stat_Sh_Sl(1);

[A_modified,~,r_Sh_Sl_modified,~,stat_Sh_Sl_modified]=regress(fHFSSE(:),[Ones,fLFSSEModified(:)]);
MLE_Error_Sh_Sl_modified=(sum(r_Sh_Sl_modified.^2))/(n);
R2_Sh_Sl_modified=stat_Sh_Sl_modified(1);


R2=[R2_Sh_Sl_modified   R2_Sh_Sl  ]
MLE_Error=[MLE_Error_Sh_Sl_modified MLE_Error_Sh_Sl ]


%%%%%%%%%%%%%%%Verify the following sentence
% This is because a transformation close to g_0.5 (S) is appropriate for the BC-AGP model, as shown in Figure 5. 
% Indeed, for randomly chosen x, √(S_h (x) ) and √(S_l (x) ) have less heavy right tails than S_h (x) and S_l (x) respectively, 
% which makes the AGP model better suited for modeling √(S_h (∙) ) and √(S_l (∙) ) than S_h (⋅) and S_l (⋅).
% Plots S_l, S_h and S'_l on the 51 x 51 grid
figure(13),clf
subplot(221)
histogram( fLFSSE(:) )
title('LF SSE')

subplot(222)
histogram( fHFSSE(:) )
title('HF SSE')

subplot(223)
histogram( fLFSSE(:).^0.5)
title('Squared root of LF SSE')

subplot(224)
histogram( fHFSSE(:).^0.5)
title('Squared root of HF SSE')


%%%%%%%%%%%Plots of estimate of a_i, b_i,Yl and Yh at x*_ML  vs time and space, where a_i and b_i are based on data on the 10 x 10 grid
t=[0.3:0.3:60];
s= [1, 1.5, 2, 2.5 3];
[tgrid,sgrid]=meshgrid(t,s);

a_estimate_reshape_s =reshape(AaGrid(1,:),200,5)';
b_estimate_reshape_s=reshape(AaGrid(2,:),200,5)';
Yh_True_reshape_s=reshape(Simulator(XTrue,2,Case),200,5)';
Yl_True_reshape_s=reshape(Simulator(XTrue,1,Case),200,5)';

figure(14),clf
subplot(221)
mesh(tgrid,sgrid,a_estimate_reshape_s)
title('a_i')
xlabel('time')
ylabel('space')

subplot(222)
mesh(tgrid,sgrid,b_estimate_reshape_s)
title('b_i')
xlabel('time')
ylabel('space')

subplot(223)
mesh(tgrid,sgrid,Yh_True_reshape_s)
title('Yh')
xlabel('time')
ylabel('space')

subplot(224)
mesh(tgrid,sgrid,Yl_True_reshape_s)
title('Yl')
xlabel('time')
ylabel('space')

%%
% Run BO 
clear  
clc
load Example1.mat
ZNBC_BC=1;   ZNBC_ID=0;   ZNBC_SR=2;  
ZMLFSSE=1;   ZLFSSE=0;   
ZRespSRGP=1;     ZRespLR=0;
for Group=1:1:10
    idx0=(Group-1)*10+[1:10]
    parfor id=idx0
        disp('---')
        
        [T_MBC_AGP{id,1}] =CalibrationAGP(MultiDataInput(id),ZNBC_BC,ZMLFSSE); 'MBC-AGP'
        [T_BC_AGP{id,1}] =CalibrationAGP(MultiDataInput(id),ZNBC_BC,ZLFSSE); 'BC-AGP'
        [T_ID_AGP{id,1}] =CalibrationAGP(MultiDataInput(id),ZNBC_ID,ZLFSSE); 'ID-AGP'
        [T_SR_AGP{id,1}] =CalibrationAGP(MultiDataInput(id),ZNBC_SR,ZLFSSE); 'SR-AGP'
        [T_Nested{id,1}] =CalibrationNested(MultiDataInput(id)); 'Nested'
        [T_BC_GP{id,1}] =CalibrationBCGP(SingleDataInput(id)); 'BC-GP'
        [T_SR_GP{id,1}] =CalibrationSRGP_LR(SingleDataInput(id),ZRespSRGP); 'SR-GP'
        [T_LR{id,1}] =CalibrationSRGP_LR(SingleDataInput(id),ZRespLR); 'LR'
        
        
    end
    save(['Example1Results.mat'])
    
end
%%
%%%%%% %Section 3: Show BO results as presented in Figures 3, 4, 5, and Figure A.1
clear
clc
load Example1.mat
load Example1Results.mat

BORecordTable=[  T_MBC_AGP T_BC_AGP   T_ID_AGP T_SR_AGP T_Nested T_BC_GP T_SR_GP   T_LR];
Labels={'MBC-AGP  ','  BC-AGP ','  ID-AGP ', 'SR-AGP' , 'Nested' ,'BC-GP','SR-GP' ,'LR'  }';
FontSize=25;

size(BORecordTable,1)
for Trainidx=1:size(BORecordTable,1)
    for Methodidx=1:8
        Table=BORecordTable{Trainidx,Methodidx} ;
        
        SSETrue_XhatsEnd(Trainidx,Methodidx)=Table.SSETrue_Xhats(end,:);
        XhatsEnd=Table.Xhats(end,:);
        L2End(Trainidx,Methodidx)=norm(XhatsEnd-XMLE);
        if Methodidx<=2 || Methodidx==6
            phiEnd(Trainidx,Methodidx)=Table.phis(end,:);
        end
        
        costs=[1 RatioCost]';
        SSETrue_Xhats_iter=Table.SSETrue_Xhats;
        Xhats_iter=Table.Xhats;
        L2s_iter=sum((Xhats_iter-XMLE).^2,2).^0.5;
        Level_iter=Table.Level;
        Budget_iter=cumsum(costs(Level_iter));
        
        TrueSSE_Xhats_Budget(1:Budget,Methodidx,Trainidx) = interp1(Budget_iter,SSETrue_Xhats_iter,1:Budget);        
        TrueSSE_Xhats_Budget(Budget+1,Methodidx,Trainidx) = TrueSSE_Xhats_Budget(Budget,Methodidx,Trainidx);

        L2_Budget(1:Budget,Methodidx,Trainidx)=interp1(Budget_iter,L2s_iter,1:Budget);                
        L2_Budget(Budget+1,Methodidx,Trainidx) = L2_Budget(Budget,Methodidx,Trainidx);
        
        if Methodidx==5%Nested
            deleteLFidx=(nl+nh+1):2:28;
            Budget_iter(deleteLFidx,:)=[];
            SSETrue_Xhats_iter(deleteLFidx,:)=[];
            L2s_iter(deleteLFidx,:)=[];
            
            TrueSSE_Xhats_Budget(:,Methodidx,Trainidx) = interp1(Budget_iter,SSETrue_Xhats_iter,1:(Budget+1));        
            L2_Budget(:,Methodidx,Trainidx)=interp1(Budget_iter,L2s_iter,1:(Budget+1));    
        end
        
    end
end

meanTrueSSE_Xhats_Budget=mean(TrueSSE_Xhats_Budget,3);
meanL2_Budget=mean(L2_Budget,3);

idx1=1;
for idx2=1:8
    signRank_p(idx2,1)=signrank(SSETrue_XhatsEnd(:,idx1),SSETrue_XhatsEnd(:,idx2));
    [ ~, ttest_p(idx2,1)]=ttest(SSETrue_XhatsEnd(:,idx1),SSETrue_XhatsEnd(:,idx2));
end
Labels1={'(i) vs (i) ','(i) vs BC-AGP ','(i) vs ID-AGP ', ' (i) vs SR-AGP' , ' (i) vs Nested' ,' (i) vs BC-GP',' (i) vs SR-GP' ,' (i) vs LR'  }';

TableSh =table(Labels1,signRank_p,ttest_p)

for idx2=1:8
    signRank_p(idx2,1)=signrank(L2End(:,idx1),L2End(:,idx2));
    [ ~, ttest_p(idx2,1)]=ttest(L2End(:,idx1),L2End(:,idx2));
end
TableL2 =table(Labels1,signRank_p,ttest_p)


figure(3),clf%in the Paper
subplot(121)
boxplot( SSETrue_XhatsEnd,'Labels',Labels)
bp= gca;bp.FontSize=20;
bp.XAxis.FontWeight='bold';bp.XAxis.FontSize=19;
bp.YAxis.FontWeight='bold';bp.YAxis.FontSize=23;
set(gca,'YScale','log')
ylabel('$S_h(\hat{\textbf{x}}^*_{\mathbf{ML}})$','FontWeight','bold','Interpreter','latex','FontSize',28);
set(findobj(gca,'type','line'),'linew',2)
title('(a)','FontSize',25)
set(gca,'Position',[0.055 0.12 0.435 0.8])
set(gca,'yGrid','on','GridLineStyle','--')
bp.GridLineStyle='--';
yticks(10.^[1:4])

subplot(122)
boxplot( L2End,'Labels',Labels)
set(gca,'Position',[0.555 0.12 0.435 0.8])
set(findobj(gca,'type','line'),'linew',2)
bp= gca;bp.FontSize=20;
bp.XAxis.FontWeight='bold';bp.XAxis.FontSize=19;
bp.YAxis.FontWeight='bold';bp.YAxis.FontSize=23;
ylabel('$L_2(\hat{\textbf{x}}^*_{\mathbf{ML}})$','Interpreter','latex','FontSize',28);
set(findobj(gcf,'type','axes'),'FontWeight','Bold', 'LineWidth', 2);
title('(b)','FontSize',25)
set(gcf,'position'  ,[          35         386        1920         530])
set(gca,'yGrid','on','GridLineStyle','--')
bp.GridLineStyle='--';


figure(4),clf%in the Paper
tiledlayout(1,2,'Padding','none','TileSpacing','none');
nexttile
MarkerSize=12;
linewidth=0.1*30;
Budget=45;
plot(1:Budget,meanTrueSSE_Xhats_Budget(1:Budget,1),'k-o','linewidth',linewidth,'MarkerSize',MarkerSize,'MarkerIndices',[InitialBudget:3:Budget Budget]),hold on
plot(1:Budget,meanTrueSSE_Xhats_Budget(1:Budget,2),'b--o','linewidth',linewidth,'MarkerSize',MarkerSize,'MarkerFaceColor','b','MarkerIndices',[InitialBudget (InitialBudget+3):3:Budget Budget]),
plot(1:Budget,meanTrueSSE_Xhats_Budget(1:Budget,3),'b--o','linewidth',linewidth,'MarkerSize',MarkerSize,'MarkerIndices',[InitialBudget (InitialBudget+2):3:Budget Budget])
plot(1:Budget,meanTrueSSE_Xhats_Budget(1:Budget,4),'k:d','linewidth',linewidth,'MarkerSize',MarkerSize,'MarkerIndices',[(InitialBudget+1):3:Budget Budget]),hold on
plot(1:Budget+1,meanTrueSSE_Xhats_Budget(1:Budget+1,5),'k:s','linewidth',linewidth,'MarkerFaceColor','k','MarkerSize',MarkerSize,'MarkerIndices',[InitialBudget:4:Budget+1 ])
plot(1:Budget,meanTrueSSE_Xhats_Budget(1:Budget,6),'k-','linewidth',linewidth,'MarkerSize',MarkerSize,'MarkerIndices',[(InitialBudget):4:Budget Budget])
plot(1:Budget,meanTrueSSE_Xhats_Budget(1:Budget,7),'--s','color',[0.4660 0.6740 0.1880],'linewidth',linewidth,'MarkerSize',MarkerSize,'MarkerIndices',[InitialBudget (InitialBudget+3):4:Budget ]),hold on
plot(1:Budget,meanTrueSSE_Xhats_Budget(1:Budget,8),'r^--','linewidth',linewidth,'MarkerSize',MarkerSize,'MarkerIndices',[InitialBudget:3:Budget Budget])
set(gca,'FontWeight','bold','FontSize',FontSize,'YScale','log')
xlim([InitialBudget,Budget+1])
xlabel('Computational cost','FontWeight','normal')
ylabel('Average  $S_h(\hat{\textbf{x}}^*_{\mathbf{ML}})$','Interpreter','latex','FontSize',35);
yline(SSE_XMLE,'--','linewidth',4)
text(31,SSE_XMLE*2,'True global minimum HF SSE','FontWeight','bold','FontSize',20)
annotation(gcf,'arrow',0.07+[0.02 0],[0.230769230769231 0.18],'LineWidth',4);
leg = legend(Labels,'NumColumns',4,'Location','northeast');
leg.ItemTokenSize = [54,50];
title('(a)')
ylim([1.6 10e3])

nexttile
plot(1:Budget,meanL2_Budget(1:Budget,1),'k-o','linewidth',linewidth,'MarkerSize',MarkerSize,'MarkerIndices',[InitialBudget:3:Budget Budget]),hold on
plot(1:Budget,meanL2_Budget(1:Budget,2),'b--o','linewidth',linewidth,'MarkerSize',MarkerSize,'MarkerFaceColor','b','MarkerIndices',[InitialBudget (InitialBudget+3):3:Budget Budget]),
plot(1:Budget,meanL2_Budget(1:Budget,3),'b--o','linewidth',linewidth,'MarkerSize',MarkerSize,'MarkerIndices',[InitialBudget (InitialBudget+2):3:Budget Budget])
plot(1:Budget,meanL2_Budget(1:Budget,4),'kd:','linewidth',linewidth,'MarkerSize',MarkerSize,'MarkerIndices',[(InitialBudget+1):3:Budget Budget]),hold on
plot(1:Budget+1,meanL2_Budget(1:Budget+1,5),'k:s','linewidth',linewidth,'MarkerFaceColor','k','MarkerSize',MarkerSize,'MarkerIndices',[InitialBudget:4:Budget+1])
plot(1:Budget,meanL2_Budget(1:Budget,6),'k-','linewidth',linewidth,'MarkerSize',MarkerSize,'MarkerIndices',[(InitialBudget):4:Budget Budget])
plot(1:Budget,meanL2_Budget(1:Budget,7),'--s','color',[0.4660 0.6740 0.1880],'linewidth',linewidth,'MarkerSize',MarkerSize,'MarkerIndices',[InitialBudget (InitialBudget+3):4:Budget ]),hold on
plot(1:Budget,meanL2_Budget(1:Budget,8),'r^--','linewidth',linewidth,'MarkerSize',MarkerSize,'MarkerIndices',[InitialBudget:3:Budget Budget])
xlim([InitialBudget,Budget+1])
xlabel('Computational cost','FontWeight','normal')
title('(b)')
set(gca,'FontWeight','bold','FontSize',FontSize)
ylabel('Average  $L_2(\hat{\textbf{x}}^*_{\mathbf{ML}})$','Interpreter','latex','FontSize',35);
leg = legend(Labels,'NumColumns',4,'Location','northeast');
leg.ItemTokenSize = [54,50];
set(findobj(gcf,'type','axes'),'FontWeight','Bold', 'LineWidth', 2);
set(gcf,'Position',[          0         0        1920         650])
ylim([0 0.35])




figure(5),clf%in the Paper
Labels2Method={'MBC-AGP','BC-AGP'};boxplot( phiEnd(:,[1 2] ), 'Labels',Labels2Method) 
% Labels2Method={'MBC-AGP','BC-AGP','BC-GP'};boxplot( phiEnd(:,[1 2 6]), 'Labels',Labels2Method)
% hold on,% yline(0.5)
set(findobj(gca,'type','line'),'linew',2)
set(findobj(gcf,'type','axes'),'FontSize',35,'FontWeight','Bold', 'LineWidth', 2);
ylabel('$ \hat \varphi$','Interpreter','latex','FontSize',50,'Rotation',0,'HorizontalAlignment','right')
set(gca,'Position',[    0.2    0.1571    0.78    0.78])
set(gcf,'Position',[           409   559   900   410])%420
set(findobj(gcf,'type','axes'),'FontWeight','Bold', 'LineWidth', 4);

%%
%Figures in Appendix A %in the Paper
Trainidx=137;
figure(100);clf
tiledlayout(2,4,'Padding','none','TileSpacing','none');
pd1=1;
pd2=2;
linewidth=1;
for Methodidx =1:5
    nexttile
    
    Table=BORecordTable{Trainidx,Methodidx};
    XhatsEnd=Table.Xhats(end,:);
    Level=Table.Level;
    
    Dh=Table.D(Level==2,:);
    Dl=Table.D(Level==1,:);
    
    
    InitialDh=Dh(1:nh,:);
    InitialDl=Dl(1:nl,:);
    FollowDh=Dh(nh+1:end,:);
    FollowDl=Dl(nl+1:end,:);
    
    plot(InitialDh(:,pd1),InitialDh(:,pd2),'bs','linewidth',linewidth,'markersize',15)
    hold on
    plot(InitialDl(:,pd1),InitialDl(:,pd2),'bx','linewidth',linewidth,'markersize',15)
    
    plot(FollowDh(:,pd1),FollowDh(:,pd2),'ko','linewidth',linewidth,'markersize',15)
    hold on
    plot(FollowDl(:,pd1),FollowDl(:,pd2),'k+','linewidth',linewidth,'markersize',15)
    
    
    xlabel('x_1','FontSize',Fontsize)
    ylabel('x_2','FontSize',Fontsize,'Rotation',0,'HorizontalAlignment','right')
    xticks([0:0.2:1])
    yticks([0:0.2:1])
    
    xygird0=0.03;
    xlim([-xygird0 1+xygird0])
    ylim([-xygird0 1+xygird0])

    plot(XhatsEnd(:,pd1),XhatsEnd(:,pd2),'k^','MarkerSize',25)
    hold on
    plot(XMLE(:,pd1),XMLE(:,pd2),'kp','MarkerSize',25)
    
    title(Labels(Methodidx))
%     axis square
end

for Methodidx =6:8
    
    Table=BORecordTable{Trainidx,Methodidx};
    XhatsEnd=Table.Xhats(end,:);
    
    Dh=Table.D;
    InitialDh=Dh(1:nh0,:);
    FollowDh=Dh(nh0+1:end,:);
    
    nexttile
    
    pd1=1;
    pd2=2;
    
    plot(XMLE(:,pd1),XMLE(:,pd2),'kp','MarkerSize',25)
    hold on
    plot(XhatsEnd(:,pd1),XhatsEnd(:,pd2),'k^','MarkerSize',25)

    
    plot(InitialDh(:,pd1),InitialDh(:,pd2),'bs','linewidth',linewidth,'markersize',15)
    hold on
    plot(FollowDh(:,pd1),FollowDh(:,pd2),'ko','linewidth',linewidth,'markersize',15)
    
    xlabel('x_1','FontSize',Fontsize)
    ylabel('x_2','FontSize',Fontsize,'Rotation',0,'HorizontalAlignment','right')
    
    xticks([0:0.2:1])
    yticks([0:0.2:1])
    
    xygird0=0.03;
    xlim([-xygird0 1+xygird0])
    ylim([-xygird0 1+xygird0])
    
    title(Labels(Methodidx))
%     axis square
end
set(findobj(gcf,'type','axes'),'FontSize',21,'FontWeight','Bold', 'LineWidth', 2);
% set(gcf,'Position',[          0         0        1800         900])
set(gcf,'Position',[          0         0        1600         700])

% % copygraphics(gcf)

%%

% %%%%%% %Condition numbers, correlation paraemeter for space, time , and gamma           for the unrestricted model of the LR method
AllConditionNumber= [ ];
for id=1:200
    Table=T_LR{id};
    Alltheta_space(id,:)=  [  Table.BestTables(:,1) ];
    Alltheta_time(id,:)=  [  Table.BestTables(:,2) ];
    Allgamma(id,:)=  [  Table.BestTables(:,3) ];
    AllConditionNumber(id,:)=  [  Table.BestTables(:,4) ]; 
end


figure(101),clf
subplot(221)
Alltheta_space=sort(Alltheta_space(:));
histogram(Alltheta_space(1:2900))
title('correaltion parameter for space, example 1')

subplot(222)
Alltheta_time=sort(Alltheta_time(:));
histogram(Alltheta_time(1:2900))
title('correaltion parameter for time')

subplot(223)
Allgamma=sort(Allgamma(:));
histogram(Allgamma(1:2900))
title(' gamma')


subplot(224)
AllConditionNumber=sort(AllConditionNumber(:));
histogram(AllConditionNumber(1:2900))
title('condition number')

%%%%%%%%%%%%%%%%%%%Check interpolation at the design points for the unrestricted model in LR method..
ThisDesign=1
ThisObs=3

Table=T_LR{ThisDesign};
Delta=[SingleDataInput(ThisDesign).Yh(ThisObs,:)-PhysData]';%GP
Theta0s=Table.BestTables(ThisObs,1:2);
gamma=Table.BestTables(ThisObs,3);


Space=[ 1, 1.5, 2, 2.5 , 3]/3;NSpace=numel(Space);
dist=abs(Space-Space');
Rs=exp(-Theta0s(1)*dist.^1.99);
[Vs,DiagDs]=svd(Rs);%R1 5*5  %'vector' econ

Time=[0.3:0.3:60]';Ntime=numel(Time);
Rt=ComputeRMatrix0(Time,Time,Theta0s(2))+10^-6*speye(numel(Time));
[Vt,DiagDt]=svd(Rt);%R2

N=NSpace*Ntime;
invRs=invandlogdet(Rs);
invRt=invandlogdet(Rt);
V=gamma*kron(Rs,Rt)+eye(N);
[invV,logdetV,condV]=invandlogdet(V);
F = ones(N,1);
FTinvV=F'*invV;
inv1 = 1./(FTinvV*F) ;
Mu00 = inv1*(FTinvV*Delta);
Res = Delta-F*Mu00 ;
Sigma00=Res'*invV*Res/ (N );  
LogLikelihood00=-1/2*(logdetV +N*log(Sigma00) );
fval00=-LogLikelihood00;


V1=gamma*kron(Rs,Rt);
ZPred=Mu00+V1*invV*(Delta-Mu00);
ZCov=max(diag(Sigma00*(V1-V1*invV*V1)),0);
ZLCL = ZPred+norminv(0.025)*ZCov.^0.5;
ZUCL= ZPred+norminv(1-0.025)*ZCov.^0.5;


Delta1=reshape(Delta,200,5)';
ZPred1=reshape(ZPred,200,5)';
ZLCL1=reshape(ZLCL,200,5)';
ZUCL1=reshape(ZUCL,200,5)';
t=[0.3:0.3:60];
s= [1, 1.5, 2, 2.5 3];
[tgrid,sgrid]=meshgrid(t,s);


figure(102),clf
subplot(221)
mesh(tgrid,sgrid,Delta1)
hold on
plot3(tgrid(:),sgrid(:),ZPred1(:),'bo');
plot3(tgrid(:),sgrid(:),ZLCL1(:),'k+');
plot3(tgrid(:),sgrid(:),ZUCL1(:),'rx');
legend('data:delta','posterior mean', 'LCL','UCL','Location', 'best')
set(findobj(gcf,'type','axes'),'FontSize',21,'FontWeight','Bold', 'LineWidth', 2);

subplot(222)
Temp = SingleDataInput(ThisDesign).Yh(ThisObs,:) + Delta';
Temp1=reshape(Temp,200,5)';
mesh(tgrid,sgrid,Temp1)
hold on
title('Yh+delta')
set(findobj(gcf,'type','axes'),'FontSize',21,'FontWeight','Bold', 'LineWidth', 2);

subplot(223)
Yh = SingleDataInput(ThisDesign).Yh(ThisObs,:);
Yh1=reshape(Yh,200,5)';
mesh(tgrid,sgrid,Yh1)
title('Yh')
set(findobj(gcf,'type','axes'),'FontSize',21,'FontWeight','Bold', 'LineWidth', 2);

subplot(224)
PhysData1=reshape(PhysData,200,5)';
mesh(tgrid,sgrid,PhysData1)
hold on
max(PhysData(:))
min(PhysData(:))
title('PhysData')
set(findobj(gcf,'type','axes'),'FontSize',21,'FontWeight','Bold', 'LineWidth', 2);



figure(103),clf
plot(Yh1(:),Temp1(:),'+')
xlabel('yh')
ylabel('yh+delta')
hold on
plot(Yh1(:),Yh1(:),'-')
set(findobj(gcf,'type','axes'),'FontSize',21,'FontWeight','Bold', 'LineWidth', 2);


function R=ComputeRMatrix0(Xs,Ys,Theta0s)
[nX,Dim]=size(Xs);
[nY,~]=size(Ys);

R=ones(nX,nY);
for id=1:Dim
    x=Xs(:,id);
    y=Ys(:,id)';
    Theta0=Theta0s(id);
    d=abs(x-y);
    R=R.* [exp( -Theta0.*d.^1.99) ] ;% Gaussian correlation function
end
end