%%%%%% %Section 1: Sets parameters for all calibration methods
clc,clear,format compact
Dim=2;
Case=1;
nl=18;
nh=6;
nh0=12;
RatioCost=3;
InitialBudget=nl*1+nh*RatioCost;
InitialBudget0=nh0*RatioCost;
Budget=InitialBudget+12;
XTrue=[0.1 0.4];

[yh_XTrue]= Simulator(XTrue,2,Case);
std_error=(var(yh_XTrue)*0.0001)^0.5;
PhysData=yh_XTrue+normrnd(0,std_error,size(yh_XTrue));
SSE_XTrue=sum([Simulator(XTrue,2,Case)-PhysData].^2);

[X1,X2]=meshgrid(linspace(0,1,51)');
TestPoints= [X1(:) X2(:)];
for id=1:size(TestPoints,1)
    TrueSh(id,1)=sum((Simulator(TestPoints(id,:),2,Case)-PhysData).^2); 
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

NoTrials=100;
parfor id=1:NoTrials
    id
    rand
    [Dl,Dh]=GenerateNestedLHD(nl,nh,Dim,1e5);     %Design for bi-fidelity Bayesian optimization
    [Dh0]=GenerateNestedLHD(nh0,nh0,Dim,1e5);     %Design for bi-fidelity Bayesian optimization
    
    Dls(:,:,id)=Dl;
    Dhs(:,:,id)=Dh;
    Dh0s(:,:,id)=Dh0;    
end


for id=1:NoTrials
    id

    Dl=Dls(:,:,id);
    Dh=Dhs(:,:,id);
    Dh0=Dh0s(:,:,id);
    
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

id =86;
Yl = MultiDataInput(id).Yl(1:nh,:);
Yh = MultiDataInput(id).Yh;

Sl=sum( [Yl-PhysData].^2,2);
Sh=sum( [Yh-PhysData].^2,2);

clear AaGrid
Ones=ones(nh,1);
for kd=1:numel(PhysData)
    if all(Yl(:,kd)<10^(-12)) %only for example 1
        AaGrid(:,kd)=[0,1];
        Sum_ErrorYlYh0=sum(abs(Yh(:,kd)-Yl(:,kd))) ;
        if Sum_ErrorYlYh0>0
            return
        end
    else
        AaGrid(:,kd)=regress(Yh(:,kd),[Ones,Yl(:,kd)]);
    end
end



[X1,X2]=meshgrid(linspace(0,1,501)');
for id=1:size(X1,1)
    for jd=1:size(X1,2)
        yl0=Simulator([X1(id,jd),X2(id,jd)],1,Case);
        yh0=Simulator([X1(id,jd),X2(id,jd)],2,Case);
        YlModifiedGrid=AaGrid(1,:)+yl0.*AaGrid(2,:);
        
        fLFSSEModified(id,jd)=sum((YlModifiedGrid-PhysData).^2); 
        
        fLFSSE(id,jd)=sum([yl0-PhysData].^2); 
        fHFSSE(id,jd)=sum([yh0-PhysData].^2); 
    end
end

Levels=1*[  5 10 25 50 100 250 500 1000 1500 2.5e3 6e3  12e3   24e3 40e3 ] ;
Fontsize2=32;
FontSizeLevels=25;
figure(22),clf%in the Paper
tiledlayout(1,3,'Padding','none','TileSpacing','none');
nexttile%Figure 2 (a)
grid on
[C,h] = contour(X1,X2,fLFSSE,Levels,'TextStep',2) ;
clabel(C,h,'FontWeight','bold','FontSize',FontSizeLevels,'Color','k','linewidth',2)
xlabel('x_1','FontSize',Fontsize2)
ylabel('x_2','FontSize',Fontsize2,'Rotation',0,'HorizontalAlignment','right')
title('(a)','FontSize',Fontsize2,'FontWeight','Bold')
xticks([0:0.2:1])
yticks([0:0.2:1])
set(gca,'FontWeight','bold','FontSize',Fontsize2)
grid on
 
nexttile%Figure 2 (b)
[C,h] = contour(X1,X2,fHFSSE,Levels);
clabel(C,h,'LabelSpacing',155,'FontWeight','bold','FontSize',FontSizeLevels,'Color','k','linewidth',2)
xlabel('x_1','FontSize',Fontsize2)
ylabel('x_2','FontSize',Fontsize2,'Rotation',0,'HorizontalAlignment','right')
title('(b)','FontSize',Fontsize2,'FontWeight','Bold')
xticks([0:0.2:1])
yticks([0:0.2:1])
set(gca,'FontWeight','bold','FontSize',Fontsize2)
grid on

nexttile%Figure 2 (c)
[C,h] = contour(X1,X2,fLFSSEModified,Levels,'TextStepMode','manual') ;
clabel(C,h,'LabelSpacing',155,'FontWeight','bold','FontSize',FontSizeLevels,'Color','k','linewidth',2)
xlabel('x_1','FontSize',Fontsize2)
ylabel('x_2','FontSize',Fontsize2,'Rotation',0,'HorizontalAlignment','right')
title('(c)','FontSize',Fontsize2,'FontWeight','Bold')
xticks([0:0.2:1])
yticks([0:0.2:1])
set(gca,'FontWeight','bold','FontSize',Fontsize2)
grid on
set(findobj(gca,'type','line'),'linew',4)
set(gcf,'position'  ,[          0 150         1886         631])
set(findobj(gcf,'type','axes'),'FontWeight','Bold', 'LineWidth', 3);
pause(0.1)
pause(0.1)

[ corr(fLFSSEModified(:),fHFSSE(:))  corr(fLFSSE(:),fHFSSE(:))]
 
save Example1.mat
%%
%%%%%% %Section 2: Bayesian optimization
load Example1.mat
restoredefaultpath
ZNBC_BC=1;   ZNBC_ID=0;   ZNBC_SR=2;
ZMLFSSE=1;   ZLFSSE=0;

for Group=1:10
    idx0=(Group-1)*10+[1:10]
    parfor id=idx0
        disp('---')
        
        [T_MBC_AGP{id,1}] =CalibrationAGP(MultiDataInput(id),ZNBC_BC,ZMLFSSE); 'MBC-AGP'
        [T_BC_AGP{id,1}] =CalibrationAGP(MultiDataInput(id),ZNBC_BC,ZLFSSE); 'BC-AGP'
        [T_MID_AGP{id,1}] =CalibrationAGP(MultiDataInput(id),ZNBC_ID,ZMLFSSE); 'MID-AGP'
        [T_SR_AGP{id,1}] =CalibrationAGP(MultiDataInput(id),ZNBC_SR,ZLFSSE); 'SR-AGP'
        [T_Nested{id,1}] =CalibrationNested(MultiDataInput(id)); 'Nested'
        [T_BC_GP{id,1}] =CalibrationBCGP(SingleDataInput(id)); 'BC-GP'
        [T_SR_GP{id,1}] =CalibrationSRGP(SingleDataInput(id)); 'SR-GP'
        
    end
    save(['Example1Results.mat'],'T_MBC_AGP','T_BC_AGP','T_MID_AGP','T_SR_AGP','T_Nested','T_BC_GP','T_SR_GP')
    

end
%%
%%%%%% %Section 3: Show BO results as presented in Figures 3, 4, 5, and Figure A.1
clear
clc
load Example1.mat
load Example1Results.mat

BORecordTable=[  T_MBC_AGP T_BC_AGP   T_MID_AGP T_SR_AGP T_Nested T_BC_GP T_SR_GP  ];

Labels={'MBC-AGP     ','  BC-AGP ','  MID-AGP ', 'SR-AGP' , 'Nested' ,'BC-GP','SR-GP'}';
size(BORecordTable,1)
for Trainidx=1:size(BORecordTable,1)
    for Methodidx=1:7
        Table=BORecordTable{Trainidx,Methodidx} ;
        
        DiffSSETrue_XhatsEnd(Trainidx,Methodidx)=Table.SSETrue_Xhats(end,:)-SSE_XMLE;
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
        
        L2_Budget(1:Budget,Methodidx,Trainidx)=interp1(Budget_iter,L2s_iter,1:Budget);
        
        if Methodidx==5%Nested
            deleteLFidx=(nl+nh+1):2:size(Table,1);
            Budget_iter(deleteLFidx,:)=[];
            SSETrue_Xhats_iter(deleteLFidx,:)=[];
            L2s_iter(deleteLFidx,:)=[];
            
            TrueSSE_Xhats_Budget(:,Methodidx,Trainidx) = interp1(Budget_iter,SSETrue_Xhats_iter,1:(Budget));
            L2_Budget(:,Methodidx,Trainidx)=interp1(Budget_iter,L2s_iter,1:(Budget));
        end
        
    end
end

meanTrueSSE_Xhats_Budget_SSEXMLE=mean(TrueSSE_Xhats_Budget,3)-SSE_XMLE;
meanL2_Budget=mean(L2_Budget,3);


idx1=1;
for idx2=1:7
    if idx2<=5
        [ ~, ttest_p_Sh(idx2,1)]=ttest(DiffSSETrue_XhatsEnd(:,idx1),DiffSSETrue_XhatsEnd(:,idx2));
        signRank_p_Sh(idx2,1)=signrank(DiffSSETrue_XhatsEnd(:,idx1),DiffSSETrue_XhatsEnd(:,idx2));
    else
        [ ~, ttest_p_Sh(idx2,1)]=ttest(DiffSSETrue_XhatsEnd(:,idx1),DiffSSETrue_XhatsEnd(:,idx2));
        signRank_p_Sh(idx2,1)=signrank(DiffSSETrue_XhatsEnd(:,idx1),DiffSSETrue_XhatsEnd(:,idx2));
    end
    NumberWinSh(idx2,1) = sum(DiffSSETrue_XhatsEnd(:,idx2)> DiffSSETrue_XhatsEnd(:,idx1));
end
Labels1={'(i) vs (i) ','(i) vs BC-AGP ','(i) vs ID-AGP ','(i) vs SR-AGP ' ' (i) vs Nested' ,' (i) vs BC-GP',' (i) vs SR-GP'}';
TableSh =table(Labels1,signRank_p_Sh,ttest_p_Sh);

for idx2=1:7
    if idx2<=5    
    signRank_p_L2(idx2,1)=signrank(L2End(:,idx1),L2End(:,idx2));
    [ ~, ttest_p_L2(idx2,1)]=ttest(L2End(:,idx1),L2End(:,idx2));
    else
            signRank_p_L2(idx2,1)=signrank(L2End(:,idx1),L2End(:,idx2));
    [ ~, ttest_p_L2(idx2,1)]=ttest(L2End(:,idx1),L2End(:,idx2));

    end
    NumberWinL2(idx2,1) = sum(L2End(:,idx2)> L2End(:,idx1));
end

Table2 =table(Labels,mean(DiffSSETrue_XhatsEnd)',NumberWinSh,ttest_p_Sh,signRank_p_Sh,mean(L2End)',NumberWinL2,ttest_p_L2,signRank_p_L2)%Table 2 in the Paper



Labels={'MBC-AGP            ','    BC-AGP           ','       MID-AGP         ', 'SR-AGP' , 'Nested' ,'BC-GP','SR-GP'}';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(3),clf%in the Paper
subplot(121)
boxplot( DiffSSETrue_XhatsEnd,'Labels',Labels)
bp= gca;bp.FontSize=20;
bp.XAxis.FontWeight='bold';bp.XAxis.FontSize=21;
bp.YAxis.FontWeight='bold';bp.YAxis.FontSize=23;
hold on
ylim([0.00005,60])
set(gca,'YScale','log')
ylabel('$S_h(\hat{\textbf{x}}^*_{\mathbf{ML}})-0.093939$','FontWeight','bold','Interpreter','latex','FontSize',28);
set(findobj(gca,'type','line'),'linew',2)
title('(a)','FontSize',25,'FontWeight','bold')
set(gca,'Position',[0.07 0.12 0.42 0.8])
set(gca,'yGrid','on','GridLineStyle','--')
bp.GridLineStyle='--';
yticks([  10.^[-4:4]   ])


subplot(122)
boxplot( L2End,'Labels',Labels)
set(gca,'Position',[0.575 0.12 0.42 0.8])
set(findobj(gca,'type','line'),'linew',2)
bp= gca;bp.FontSize=20;
bp.XAxis.FontWeight='bold';bp.XAxis.FontSize=21;
bp.YAxis.FontWeight='bold';bp.YAxis.FontSize=23;
ylabel('$L_2(\hat{\textbf{x}}^*_{\mathbf{ML}})$','Interpreter','latex','FontSize',28);
set(findobj(gcf,'type','axes'),'FontWeight','Bold', 'LineWidth', 2);
title('(b)','FontSize',25,'FontWeight','bold')
set(gcf,'position'  ,[          0         386        1920         510])
set(gca,'yGrid','on','GridLineStyle','--')
bp.GridLineStyle='--';
yticks([  10.^[-4:4]   ])
ylim([   0.00020    0.6])
set(gca,'YScale','log')

%%%%%%%%%%%%%%%%%%%
FontSize=24;
Labels={'MBC-AGP','BC-AGP','MID-AGP', 'SR-AGP' , 'Nested' ,'BC-GP','SR-GP'}';
figure(4),clf%in the Paper
tiledlayout(1,2,'Padding','none','TileSpacing','none');
nexttile
htmlGray = [128 128 128]/255;
htmlGreen = [0.4660 0.6740 0.1880];

MarkerSize=15;
linewidth=4;
plot(1:Budget,meanTrueSSE_Xhats_Budget_SSEXMLE(1:Budget,1),'ko-','linewidth',linewidth,'MarkerSize',MarkerSize,'MarkerIndices',[InitialBudget:3:Budget Budget]),hold on
plot(1:Budget,meanTrueSSE_Xhats_Budget_SSEXMLE(1:Budget,2),'b:o','linewidth',linewidth,'MarkerSize',MarkerSize,'MarkerFaceColor','b','MarkerIndices',[InitialBudget (InitialBudget+2):2:Budget Budget]),
plot(1:Budget,meanTrueSSE_Xhats_Budget_SSEXMLE(1:Budget,3),'k^-','linewidth',linewidth,'MarkerSize',MarkerSize,'MarkerIndices',[InitialBudget (InitialBudget):3:Budget Budget])
plot(1:Budget,meanTrueSSE_Xhats_Budget_SSEXMLE(1:Budget,4),'--v','linewidth',linewidth,'Color', htmlGray,'MarkerSize',MarkerSize,'MarkerIndices',[(InitialBudget+1):2:Budget Budget]),hold on
plot(1:Budget,meanTrueSSE_Xhats_Budget_SSEXMLE(1:Budget,5),':s','linewidth',linewidth,'color',htmlGreen,'MarkerFaceColor',htmlGreen,'MarkerSize',MarkerSize,'MarkerIndices',[InitialBudget:4:Budget ])
plot(1:Budget,meanTrueSSE_Xhats_Budget_SSEXMLE(1:Budget,6),'b-x','linewidth',linewidth,'MarkerSize',MarkerSize+10,'MarkerIndices',[InitialBudget (InitialBudget+1):3:Budget Budget])
plot(1:Budget,meanTrueSSE_Xhats_Budget_SSEXMLE(1:Budget,7),'--s','linewidth',linewidth,'Color', htmlGray,'MarkerSize',MarkerSize,'MarkerIndices',[InitialBudget (InitialBudget+2):3:Budget Budget ]),hold on
ylim([0.25 130])
set(gca,'FontWeight','bold','FontSize',FontSize,'YScale','log')
xlim([InitialBudget,Budget])
xlabel('Computational cost','FontWeight','normal')
ylabel('Average  $S_h(\hat{\textbf{x}}^*_{\mathbf{ML}})-0.093939$','Interpreter','latex','FontSize',32);
leg = legend(Labels,'NumColumns',3,'Location','northeast');
leg.ItemTokenSize = [74,50];
title('(a)','FontWeight','bold')
yticks(10.^[-1:2])
yticklabels({'10^-1 ','10^0 ','10^1 ','10^2 '})

nexttile
plot(1:Budget,meanL2_Budget(1:Budget,1),'ko-','linewidth',linewidth,'MarkerSize',MarkerSize,'MarkerIndices',[InitialBudget:3:Budget Budget]),hold on
plot(1:Budget,meanL2_Budget(1:Budget,2),'b:o','linewidth',linewidth,'MarkerSize',MarkerSize,'MarkerFaceColor','b','MarkerIndices',[InitialBudget (InitialBudget):2:Budget Budget]),
plot(1:Budget,meanL2_Budget(1:Budget,3),'k^-','linewidth',linewidth,'MarkerSize',MarkerSize,'MarkerIndices',[InitialBudget (InitialBudget):3:Budget Budget])
plot(1:Budget,meanL2_Budget(1:Budget,4),'--v','linewidth',linewidth,'Color', htmlGray,'MarkerSize',MarkerSize,'MarkerIndices',[(InitialBudget+1):2:Budget Budget]),hold on
plot(1:Budget,meanL2_Budget(1:Budget,5),':s','linewidth',linewidth,'color',htmlGreen,'MarkerFaceColor',htmlGreen,'MarkerSize',MarkerSize,'MarkerIndices',[InitialBudget:4:Budget Budget])
plot(1:Budget,meanL2_Budget(1:Budget,6),'b-x','linewidth',linewidth,'MarkerSize',MarkerSize+10,'MarkerIndices',[InitialBudget (InitialBudget+1):3:Budget Budget])
plot(1:Budget,meanL2_Budget(1:Budget,7),'--s','linewidth',linewidth,'Color', htmlGray,'MarkerSize',MarkerSize,'MarkerIndices',[InitialBudget (InitialBudget+2):3:Budget Budget ]),hold on
xlim([InitialBudget,Budget])
ylim([0.019    0.5])

xlabel('Computational cost','FontWeight','normal')
title('(b)','FontWeight','bold')
set(gca,'FontWeight','bold','FontSize',FontSize)
ylabel('Average  $L_2(\hat{\textbf{x}}^*_{\mathbf{ML}})$','Interpreter','latex','FontSize',32);
leg = legend(Labels,'NumColumns',3,'Location','northeast');
leg.ItemTokenSize = [74,50];
set(findobj(gcf,'type','axes'),'FontWeight','Bold', 'LineWidth', 3);
set(gca,'YScale','log')
yticks(0.01*2.^[1:5])
yticklabels({'0.02 ','0.04 ','0.08 ','0.16 ','0.32 '})
set(gcf,'Position',[          0         0        1920         626])
set(gcf,'Position',[          0         100        1920         615])

%%%%%%%%%%%%%%%%%%%%%%%%
figure(5),clf%in the Paper
Labels2Method={'MBC-AGP','BC-AGP','BC-GP'};
boxplot( phiEnd(:,[1 2 6]), 'Labels',Labels2Method,'OutlierSize',10,'Widths',0.8*[1 1 1  ])
set(findobj(gca,'type','line'),'linew',2)
set(findobj(gcf,'type','axes'),'FontSize',27,'FontWeight','Bold', 'LineWidth', 2);
ylabel('$ \hat \varphi$','Interpreter','latex','FontSize',50,'Rotation',0,'HorizontalAlignment','right','VerticalAlignment','baseline')
set(gca,'Position',[    0.2    0.14    0.78    0.83])
set(gcf,'Position',[           409   559   900   410])
set(gcf,'Position',[           409   559   900   334])
set(findobj(gcf,'type','axes'),'FontWeight','Bold', 'LineWidth', 3);
yticks([-0.1:0.1:0.6])
set(gca,'yGrid','on','GridLineStyle','--')
ylim([-0.17 0.64])
set(gcf,'Position',[           109   159   900   372])
medians=median(phiEnd(:,[1 2 6]));
FontSize77=20;
text(1,1.11*medians(1),['Median=' num2str(medians(1),2)],'HorizontalAlignment','center','FontSize',FontSize77,'FontWeight','Bold')
text(2,1.1*medians(2),['Median=' num2str(medians(2),2)],'HorizontalAlignment','center','FontSize',FontSize77,'FontWeight','Bold')
text(3,1.14*medians(3),['Median=' num2str(medians(3),2)],'HorizontalAlignment','center','FontSize',FontSize77,'FontWeight','Bold')
xlim([0.45 3.55])



%%%%%%%%%%%%%%%%%%%%%%
%Figures in Appendix A %in the Paper
Trainidx=86;
figure(100);clf
tiledlayout(2,8,'Padding','none','TileSpacing','none');
pd1=1;
pd2=2;
Fontsize=21;
linewidth=1;
for Methodidx =1:5
    if Methodidx ==5
        nexttile([1 1])
        axis off

        nexttile([1 2])
    else
        
    nexttile([1 2])
    end
    
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
    
    title(Labels(Methodidx),'FontWeight','Bold')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for Methodidx =6:7
    
    Table=BORecordTable{Trainidx,Methodidx};
    XhatsEnd=Table.Xhats(end,:);
    
    Dh=Table.D;
    InitialDh=Dh(1:nh0,:);
    FollowDh=Dh(nh0+1:end,:);
    
    nexttile([1 2])
    
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
    
    title(Labels(Methodidx),'FontWeight','Bold')
end
set(findobj(gcf,'type','axes'),'FontSize',21,'FontWeight','Bold', 'LineWidth', 1);
set(gcf,'Position',[          0         0        1600         700])