%%%%%%%% %Section 1: Sets parameters for all calibration methods
clear,clc,format compact % close all
%Temperature measurement over 12:01 a.m. to 10:00 p.m.
SensorTemperature=[24.5,24.5;24.5,24.5;24.5,24.5;24.5,24.5;24.5,24.5;24.5,24.5;24.5,24.5;24.5,24.5;24.5,24.5;24.5,24.5;24.5,24.5;24.5,24.5;24.5,24.5;24.5,24.5;24.5,24.5;24.5,24.5;24.5,24.5;24.5,24.5;24.5,24.5;24.5,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24.5;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24.5;24,24;24,24.5;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;23.5,24;23.5,24;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23;23.5,23;23,23;23,23;23,23;23,23;23,23;23,22.5;23,22.5;23,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22;22.5,22;22.5,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,21.5;22,21.5;22,21.5;22,21.5;22,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21;21.5,21;21.5,21;21.5,21;21.5,21;21.5,21;21.5,21;21.5,21;21.5,21;21.5,21;21.5,21;21.5,21;21.5,21;21.5,21;21.5,21;21.5,21;21.5,21;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;22,21.5;22,21.5;22,21.5;22,21.5;22,21.5;22,21.5;22,21.5;22,21.5;22,21.5;22,21.5;22,21.5;22,21.5;22,21.5;22,21.5;22,21.5;22,21.5;22,21.5;22,21.5;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,21.5;22,21.5;22,21.5;22,21.5;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22.5;22.5,22;22.5,22;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22;22.5,22;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22,22.5;21,22.5;20,22.5;19,22.5;18,22.5;17.5,22;17,22;17,22;17.5,22;17.5,22;18,22;18,22;18.5,22;18.5,22;19,22;19,22;19.5,22;20,22;20,22;20.5,22;20.5,22;21,22;21,22;21.5,22;21.5,22;21.5,22;22,22;22,22;22,22;22,22;22,22.5;22,22.5;22,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;21.5,22.5;20.5,22.5;19,22.5;18.5,22.5;18,22.5;17.5,22;17,22;17.5,22;17.5,22;18,22;18,22;18.5,22;18.5,22;19,22;19,22;19.5,22;20,22;20,22;20.5,22;20.5,22;21,22;21,22;21.5,22;21.5,22;21.5,22;21.5,22;22,22;22,22;22,22;22,22;22,22.5;22,22.5;22,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22,22.5;21,22.5;20,22.5;19,22.5;18,22.5;17.5,22;17,22;17,22;17.5,22;17.5,22;18,22;18,22;18.5,22;18.5,22;19,22;19,22;19.5,22;20,22;20,22;20.5,22;20.5,22;21,22;21,22;21,22;21.5,22;21.5,22;21.5,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;21.5,22.5;20.5,22.5;19.5,22.5;18.5,22.5;18,22.5;17.5,22;17,22;17,22;17.5,22;17.5,22;18,22;18,22;18.5,22;18.5,22;19,22;19,22;19.5,22;20,22;20,22;20.5,22;20.5,22;21,22;21,22;21,22;21.5,22;21.5,22;21.5,22;21.5,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;23,23;23,23;23,23;23,23;23,23;23,23;23,23;23,23;23.5,23;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5];
Dim=4;
XTrue='unkown';
nh=09;
nl=18;
nh0=15;
RatioCost=3;
NoTrials=50;
Case=2;
InitialBudget = nl*1+RatioCost*nh
InitialBudget0= nh0*RatioCost
Budget=InitialBudget0+27
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SensorTemperatureEveryTwoHours=reshape(SensorTemperature,120,[]);
PhysData=mean(SensorTemperatureEveryTwoHours);
%%
%%%%%% %Section 2: Run BO with 50 simulation trials 

% Generates designs
for id =1:NoTrials
    disp(id)
    [Dl,Dh]=GenerateNestedLHD(nl,nh,Dim,1e5);     %Design for bi-fidelity Bayesian optimization
    [Dh0]=GenerateNestedLHD(nh0,nh0,Dim,1e5);     %Design for bi-fidelity Bayesian optimization
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
    MultiDataInput(id).Budget=Budget;        MultiDataInput(id).Case=Case;
    
    SingleDataInput(id).Dl =[] ;       SingleDataInput(id).Yl=[];
    SingleDataInput(id).Dh= Dh0;    SingleDataInput(id).Yh=Yh0;
    SingleDataInput(id).XTrue=XTrue;
    SingleDataInput(id).PhysData=PhysData;    SingleDataInput(id).RatioCost=RatioCost;
    SingleDataInput(id).Budget=Budget;        SingleDataInput(id).Case=Case;
end


%%
% Plot figure 8 in the Paper 
clear
load Example2.mat
for id =1:NoTrials
    
    Yl = MultiDataInput(id).Yl(1:nh,:);
    Yh = MultiDataInput(id).Yh;
    
    Sl=sum( [Yl-PhysData].^2,2);
    Sh=sum( [Yh-PhysData].^2,2);
    
    clear AaGrid
    Ones=ones(nh,1);
    for kd=1:numel(PhysData)
        AaGrid(:,kd)=regress(Yh(1:nh,kd),[Ones,Yl(:,kd)]);
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

%Plots MLE of error variance for the linear regressions of Sh on Sl, and of Sh on S'l based on 50 initial designs...
figure(8),clf%in the Paper
hAx=gca;
Labels2methods={'  Linear regression of \mbox{               }' , '\mbox{            }       Linear regression of  '};
boxplot([MLE_Error_Sh_ModifiedSl MLE_Error_ShSl  ],'Labels',Labels2methods)
FontSize7=33;
text(1,0.0016,'$S_h(\cdot)$ on $S''_l(\cdot)$   ','FontSize',FontSize7,'FontWeight','Bold','HorizontalAlignment','center','Interpreter','latex')
text(2,0.0016,'$S_h(\cdot)$ on $S_l(\cdot)$     ','FontSize',FontSize7,'FontWeight','Bold','HorizontalAlignment','center','Interpreter','latex')

hAx.XAxis.TickLabelInterpreter='latex';
set(gca,'YScale','log','Position',[0.15 0.25 0.83 0.74] )
set(findobj(gca,'type','line'),'linew',2)
set(findobj(gcf,'type','axes'),'FontSize',FontSize7,'FontWeight','Bold', 'LineWidth', 2);
yticks(10.^[-1 0 1 2])
ylim([0.02  350])
Ratio= 0.4846;
Length=950;
ylabel('MLE of error variance        ','FontSize',30,'HorizontalAlignment','center','VerticalAlignment','baseline')
set(gcf,'position' , [100, 100 , Length ,Length*Ratio]) 
set(findobj(gcf,'type','axes'),'FontWeight','Bold', 'LineWidth', 3);

%Plots boxplots of correlation between Sh and Sl, and Sh and modified Sl based on 50 initial designs...
figure(21),clf
labels2={'Correlation between', 'Correlation between'};
boxplot([CorrModifiedSlSh CorrSlSh],'labels',labels2);
set(gca,'Position',[0.15 0.25 0.82 0.7] )
ylim([0.9997 1.0001])
FontSize=18;
text(1,0.9996,'$S_h(\cdot)$ and $S''_l(\cdot)$   ','FontSize',FontSize,'FontWeight','Bold','HorizontalAlignment','center','Interpreter','latex')
text(2,0.9996,'$S_h(\cdot)$ and $S_l(\cdot)$     ','FontSize',FontSize,'FontWeight','Bold','HorizontalAlignment','center','Interpreter','latex')
set(findobj(gcf,'type','axes'),'FontWeight','Bold', 'LineWidth', 2,'FontSize',FontSize)
set(gcf,'position', [  876   457   650   300])
hAx=gca;
hAx.XAxis.TickLabelInterpreter='latex';

%{

% New Plot figure 8 in the Paper 
clear
load Example2.mat
for id =1:NoTrials
    
    Yl = MultiDataInput(id).Yl(1:nh,:);
    Yh = MultiDataInput(id).Yh;
    
    Sl=sum( [Yl-PhysData].^2,2);
    Sh=sum( [Yh-PhysData].^2,2);
    
    clear AaGrid
    Ones=ones(nh,1);
    for kd=1:numel(PhysData)
        AaGrid(:,kd)=regress(Yh(1:nh,kd),[Ones,Yl(:,kd)]);
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

%Plots MLE of error variance for the linear regressions of Sh on Sl, and of Sh on S'l based on 50 initial designs...
figure(8),clf%in the Paper
hAx=gca;
Labels2methods={'  Linear regression of \mbox{               }' , '\mbox{            }       Linear regression of  '};
boxplot([MLE_Error_Sh_ModifiedSl MLE_Error_ShSl  ],'Labels',Labels2methods)
FontSize7=33;
text(1,0.0015,'$S_h(\cdot)$ on $S''_l(\cdot)$   ','FontSize',FontSize7,'FontWeight','Bold','HorizontalAlignment','center','Interpreter','latex')
text(2,0.0015,'$S_h(\cdot)$ on $S_l(\cdot)$     ','FontSize',FontSize7,'FontWeight','Bold','HorizontalAlignment','center','Interpreter','latex')

hAx.XAxis.TickLabelInterpreter='latex';
set(gca,'YScale','log','Position',[0.15 0.26 0.83 0.73] )
set(findobj(gca,'type','line'),'linew',2)
set(findobj(gcf,'type','axes'),'FontSize',FontSize7,'FontWeight','Bold', 'LineWidth', 2);
yticks(10.^[-1 0 1 2])
ylim([0.02  350])
Ratio= 0.4846;
Length=950;
ylabel('MLE of error variance        ','FontSize',28,'HorizontalAlignment','center','VerticalAlignment','baseline')
set(gcf,'position' , [100, 100 , 928 ,400]) 
set(findobj(gcf,'type','axes'),'FontWeight','Bold', 'LineWidth', 3);


%}

%%
% Run BO
ZNBC_BC=1;     
ZMLFSSE=1;   ZLFSSE=0;   
ZRespSRGP=1;     ZRespLR=0;
for id=1:NoTrials
    disp('---')
    
    [T_MBC_AGP{id,1},Data_MBC_AGP{id,1}] =CalibrationAGP(MultiDataInput(id),ZNBC_BC,ZMLFSSE); 'MBC-AGP'
    [T_BC_AGP{id,1},Data_BC_AGP{id,1}] =CalibrationAGP(MultiDataInput(id),ZNBC_BC,ZLFSSE); 'BC-AGP'    
    [T_Nested{id,1},Data_Nested{id,1}] =CalibrationNested(MultiDataInput(id)); 'Nested'
    [T_BC_GP{id,1},Data_BC_GP{id,1}] =CalibrationBCGP(SingleDataInput(id)); 'BC-GP'
    [T_SR_GP{id,1},Data_SR_GP{id,1}] =CalibrationSRGP_LR(SingleDataInput(id),ZRespSRGP); 'SR-GP'
    [T_LR{id,1},Data_LR{id,1}] =CalibrationSRGP_LR(SingleDataInput(id),ZRespLR); 'LR'
    
    save(['Example2.mat'])    
end

%%
%%%%%% %Section 3: Show BO simulation results as presented in Figures 6, 7, and Figure B.1 Figure B.2
clc,clear
load Example2.mat
Labels={'MBC-AGP','BC-AGP', 'Nested' ,'BC-GP','SR-GP' ,'LR'  }' ;
RecordTableShow=[  T_MBC_AGP T_BC_AGP    T_Nested T_BC_GP T_SR_GP   T_LR];
RecordDataShow=[  Data_MBC_AGP Data_BC_AGP    Data_Nested Data_BC_GP Data_SR_GP   Data_LR];

XNames={'x1' 'x2' 'x3' 'x4'} ;
SimMin= [0.5   0.12  0.0004   0];
SimMax= [0.7      0.3   0.001     1];
XMLE=[0.000244 ,0,0.2843 ,1];
SSE_XMLE=[3.49375814550985];
XMLESim=SimMin+(SimMax-SimMin).*XMLE;

for Methodidx=1:6
    for Trainidx=1:size(RecordTableShow,1)
        Table=RecordTableShow{Trainidx,Methodidx};

        SSETrue_XhatsEnd(Trainidx,Methodidx)=Table.SSETrue_Xhats(end,:);        
        XhatsEnd = Table.Xhats(end,:);
        XhatsEndSimEP(Methodidx,:,Trainidx)=SimMin+(SimMax-SimMin).*XhatsEnd;
        L2End(Trainidx,Methodidx)=norm(XhatsEnd-XMLE);
        if Methodidx<=2 || Methodidx==4
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
        
        L2s_Xhats_Budget(1:Budget,Methodidx,Trainidx)=interp1(Budget_iter,L2s_iter,1:Budget);        
        L2s_Xhats_Budget(Budget+1,Methodidx,Trainidx) = L2s_Xhats_Budget(Budget,Methodidx,Trainidx);        
        
        if Methodidx==3
            deleteLFidx=(nl+nh+1):2:40;
            Budget_iter(deleteLFidx,:)=[];            
            SSETrue_Xhats_iter(deleteLFidx,:)=[];
            L2s_iter(deleteLFidx,:)=[];

            TrueSSE_Xhats_Budget(:,Methodidx,Trainidx) = interp1(Budget_iter,SSETrue_Xhats_iter,1:(Budget+1));       
            L2s_Xhats_Budget(:,Methodidx,Trainidx) = interp1(Budget_iter,L2s_iter,1:(Budget+1));       
            
        end
    end
end

meanTrueSSE_Xhats_Budget=mean(TrueSSE_Xhats_Budget,3);
meanTrueSSE_Xhats_Budget_SSEXMLE=meanTrueSSE_Xhats_Budget-SSE_XMLE;

meanL2s_Xhats_Budget=mean(L2s_Xhats_Budget,3);


idx1=1;
for idx2=1:6
    signRank_p_Sh(idx2,1)=signrank(SSETrue_XhatsEnd(:,idx1),SSETrue_XhatsEnd(:,idx2));
    [ ~, ttest_p_Sh(idx2,1)]=ttest(SSETrue_XhatsEnd(:,idx1),SSETrue_XhatsEnd(:,idx2));
end
Labels1={'(i) vs (i) ','(i) vs BC-AGP ', ' (i) vs Nested' ,' (i) vs BC-GP',' (i) vs SR-GP' ,' (i) vs LR'  }';
TableSh =table(Labels1,signRank_p_Sh,ttest_p_Sh);

for idx2=1:6
    signRank_p_L2(idx2,1)=signrank(L2End(:,idx1),L2End(:,idx2));
    [ ~, ttest_p_L2(idx2,1)]=ttest(L2End(:,idx1),L2End(:,idx2));
end
TableL2 =table(Labels1,signRank_p_L2,ttest_p_L2);

Table2 =table(Labels,mean(SSETrue_XhatsEnd)',ttest_p_Sh,mean(L2End)',ttest_p_L2)%Table 2 in the Paper

figure(6),clf%in the Paper 
FontSize6=30;
linewidth=0.1*30;
MarkerSize1=15;
plot(1:Budget,meanTrueSSE_Xhats_Budget_SSEXMLE(1:Budget,1),'ko-','linewidth',linewidth+1,'MarkerSize',MarkerSize1,'MarkerIndices',[InitialBudget:6:Budget Budget]),hold on
plot(1:Budget,meanTrueSSE_Xhats_Budget_SSEXMLE(1:Budget,2),'b--o','linewidth',linewidth+1,'MarkerSize',MarkerSize1,'MarkerFaceColor','b','MarkerIndices',[(InitialBudget+3):6:Budget Budget])
plot(1:Budget+1,meanTrueSSE_Xhats_Budget_SSEXMLE(1:Budget+1,3),'k:s','linewidth',linewidth+1,'MarkerFaceColor','k','MarkerSize',MarkerSize1,'MarkerIndices',[InitialBudget (InitialBudget):4:Budget+1 Budget+1 ])
plot(1:Budget,meanTrueSSE_Xhats_Budget_SSEXMLE(1:Budget,4),'k-','linewidth',linewidth+1,'MarkerSize',MarkerSize1,'MarkerIndices',[InitialBudget (InitialBudget+2):6:Budget Budget]),hold on
plot(1:Budget,meanTrueSSE_Xhats_Budget_SSEXMLE(1:Budget,5),'--s','color',[0.4660 0.6740 0.1880],'linewidth',linewidth+1,'MarkerSize',MarkerSize1,'MarkerIndices',[InitialBudget:6:Budget Budget])
plot(1:Budget,meanTrueSSE_Xhats_Budget_SSEXMLE(1:Budget,6),'r^--','linewidth',linewidth+1,'MarkerSize',MarkerSize1,'MarkerIndices',[InitialBudget (InitialBudget+3):6:Budget Budget]),hold on
xlim([InitialBudget,Budget+1])
xlabel('Computational cost','FontWeight','normal')
ylabel('Average  $S_h(\hat{\textbf{x}}^*_{\mathbf{ML}})$-3.4938','Interpreter','latex');
set(findobj(gcf,'type','axes'),'FontSize',FontSize6,'FontWeight','Bold', 'LineWidth', 3);
leg = legend(Labels,'NumColumns',3,'Location','best');
leg.ItemTokenSize = [73,50];
set(gca,'YScale','log','Position',[0.17 0.2 0.81 0.76],'FontSize',FontSize6,'FontWeight','Bold')
set(gcf,'Position',[   100   100   1000 600])
yticks([0.125 0.25 0.5 1 2 4 8  16])
yticklabels({'0.125','0.25','0.5','1','2','4','8','16'})
ylim([0.1 16])


figure(22),clf
FontSize6=30;
linewidth=0.1*30;
MarkerSize1=15;
plot(1:Budget,meanL2s_Xhats_Budget(1:Budget,1),'ko-','linewidth',linewidth+1,'MarkerSize',MarkerSize1,'MarkerIndices',[InitialBudget:6:Budget Budget]),hold on
plot(1:Budget,meanL2s_Xhats_Budget(1:Budget,2),'b--o','linewidth',linewidth+1,'MarkerSize',MarkerSize1,'MarkerFaceColor','b','MarkerIndices',[(InitialBudget+3):6:Budget Budget])
plot(1:Budget+1,meanL2s_Xhats_Budget(1:Budget+1,3),'k:s','linewidth',linewidth+1,'MarkerFaceColor','k','MarkerSize',MarkerSize1,'MarkerIndices',[InitialBudget (InitialBudget):4:Budget+1 Budget+1 ])
plot(1:Budget,meanL2s_Xhats_Budget(1:Budget,4),'k-','linewidth',linewidth+1,'MarkerSize',MarkerSize1,'MarkerIndices',[InitialBudget (InitialBudget+2):3:Budget Budget]),hold on
plot(1:Budget,meanL2s_Xhats_Budget(1:Budget,5),'--s','color',[0.4660 0.6740 0.1880],'linewidth',linewidth+1,'MarkerSize',MarkerSize1,'MarkerIndices',[InitialBudget:6:Budget Budget])
plot(1:Budget,meanL2s_Xhats_Budget(1:Budget,6),'r^--','linewidth',linewidth+1,'MarkerSize',MarkerSize1,'MarkerIndices',[InitialBudget (InitialBudget+3):6:Budget Budget]),hold on
xlim([InitialBudget,Budget+1])
xlabel('Computational cost','FontWeight','normal')
ylabel('Average  $L_2(\hat{\textbf{x}}^*_{\mathbf{ML}})$','Interpreter','latex');  %log10
set(gca,'Position',[0.13 0.20 0.855 0.76],'FontSize',FontSize6,'FontWeight','Bold')
set(gcf,'Position',[   100   100   1000 600])
set(findobj(gcf,'type','axes'),'FontSize',FontSize6,'FontWeight','Bold', 'LineWidth', 3);
ylim([0.45   1.21])
yticks([0.5:0.2:1.2 1.2])
leg = legend(Labels,'NumColumns',3,'Location','northeast');
leg.ItemTokenSize = [73,50];
%%
figure(7),clf%in the Paper 
Labels2Method={'MBC-AGP','BC-AGP'};boxplot( phiEnd(:,[1 2]), 'Labels',Labels2Method);
% Labels2Method={'MBC-AGP','BC-AGP','BC-GP'};boxplot( phiEnd(:,[1 2 4]), 'Labels',Labels2Method)
set(findobj(gca,'type','line'),'linew',2)
set(findobj(gcf,'type','axes'),'FontSize',35,'FontWeight','Bold', 'LineWidth', 2);
ylabel('$ \hat \varphi$','Interpreter','latex','FontSize',50,'Rotation',0,'HorizontalAlignment','right')
set(gca,'Position',[    0.2    0.1571    0.78    0.78])
set(gcf,'Position',[           409   559   900   410])%420
set(findobj(gcf,'type','axes'),'FontWeight','Bold', 'LineWidth', 4);
yticks([-0.2:0.1:0.5]) 


%%

Trainidx=13;%@@@@%This one
% Trainidx=34;%@@@@

% Trainidx=48;%@@@
% Trainidx=45;---

% Trainidx=23;%@@

% Trainidx=8;
% Trainidx=2;
% Trainidx=3;

aaa=[1 2 ; 1 3; 1 4; 2 3; 2 4; 3 4;];
for Methodidx =1:2
    Data=RecordDataShow{Trainidx,Methodidx};
    Table=RecordTableShow{Trainidx,Methodidx};
    XhatsEnd=Table.Xhats(end,:);
    
    InitialDh=Data.Dh(1:nh,:);
    InitialDl=Data.Dl(1:nl,:);
    FollowDh=Data.Dh(nh+1:end,:);
    FollowDl=Data.Dl(nl+1:end,:);
    
    figure(22+Methodidx),clf
    tiledlayout(2,3,'Padding','none','TileSpacing','none');
    
    
    for kd=1:6
        pd1=aaa(kd,1);
        pd2=aaa(kd,2);
        nexttile
        markersize=15;
        linewidth=1.5;
        plot(InitialDh(:,pd1),InitialDh(:,pd2),'bs','linewidth',linewidth,'markersize',markersize)
        hold on
        plot(InitialDl(:,pd1),InitialDl(:,pd2),'bx','linewidth',linewidth,'markersize',markersize)
        
        plot(FollowDh(:,pd1),FollowDh(:,pd2),'ko','linewidth',linewidth,'markersize',markersize)
        hold on
        plot(FollowDl(:,pd1),FollowDl(:,pd2),'k+','linewidth',linewidth,'markersize',markersize)
        
        plot(XMLE(:,pd1),XMLE(:,pd2),'kp','MarkerSize',25,'linewidth',linewidth)
        plot(XhatsEnd(:,pd1),XhatsEnd(:,pd2),'k^','MarkerSize',25,'linewidth',linewidth)
        
        xlabel(['x_' num2str(pd1)])
        ylabel(['x_' num2str(pd2)],'Rotation',0,'HorizontalAlignment','right')

%         Ticks0=[0:0.2:1];
%         Ticks1=SimMin(pd1)+(SimMax(pd1)-SimMin(pd1)).*Ticks0;
        xticks([0:0.2:1]);
%         xticklabels(mat2cell(Ticks1,1,6))
%         if kd>=6
%             xtickangle(20)
%         end
        
%         Ticks0=[0:0.2:1];
%         Ticks2=SimMin(pd2)+(SimMax(pd2)-SimMin(pd2)).*Ticks0;
        yticks([0:0.2:1])
%         yticklabels(mat2cell(Ticks2,1,6))
        
        lim0=0.02;
        xlim( [-lim0 1+lim0])
        ylim( [-lim0 1+lim0])
        
%          
                 
        if kd==1
           xticklabels({'0.5'  ,  '0.54' ,   '0.58'  ,  '0.62'  ,  '0.66',    '0.70'})
           yticklabels({'0.12'  ,      '0.156'  ,      '0.192' ,       '0.228'  ,      '0.264'         , '0.3'})
        end
        
        if kd==2 
            xticklabels({'0.5'  ,  '0.54' ,   '0.58'  ,  '0.62'  ,  '0.66',    '0.70'})
            yticklabels({'0.0004'      ,'0.00052'      ,'0.00064'      ,'0.00076'      ,'0.00088'         ,'0.001'})
        end
        
        if kd==3
            xticklabels({'0.5'  ,  '0.54' ,   '0.58'  ,  '0.62'  ,  '0.66',    '0.7'})
            yticklabels({'0'   ,       '0.2'  ,        '0.4'  ,        '0.6'  ,        '0.8'   ,      '1'}            )
        end


        if kd==4
           xticklabels({'0.12'  ,      '0.156'  ,      '0.192' ,       '0.228'  ,      '0.264'         , '0.3'})
           yticklabels({'0.0004'      ,'0.00052'      ,'0.00064'      ,'0.00076'      ,'0.00088'         ,'0.001'})
        end
        
        if kd==5
            xticklabels({'0.12'  ,      '0.156'  ,      '0.192' ,       '0.228'  ,      '0.264'         , '0.3'})
            yticklabels({'0'   ,       '0.2'  ,        '0.4'  ,        '0.6'  ,        '0.8'   ,      '1'}            )
        end
        
        if kd==6
            xticklabels({'0.0004           '      ,' 0.00052       '      ,'  0.00064    '      ,'    0.00076  '      ,'      0.00088'         ,'       0.001'})
            yticklabels({'0'   ,       '0.2'  ,        '0.4'  ,        '0.6'  ,        '0.8'   ,      '1'}            )
        end
        
        
                
    end

    
    if Methodidx==1
        sgtitle('(a) MBC-AGP','fontsize',25,'FontWeight','Bold')
    else
        sgtitle('(b) BC-AGP','fontsize',25,'FontWeight','Bold')
    end

    set(findobj(gcf,'type','axes'),'FontSize',17,'FontWeight','Bold', 'LineWidth', 2);
    set(gcf,'Position' , [         100         270        1600         650])
%     set(gcf,'Position' , [         100         270        1700         700])
    
end

%%

MFidxTrial=46;
LFidxTrial=3;

RecordTableShow2= [   RecordTableShow(MFidxTrial,1:3)   RecordTableShow(LFidxTrial,4:6) ]  ;
RecordDataShow2= [   RecordDataShow(MFidxTrial,1:3)   RecordDataShow(LFidxTrial,4:6) ]    ;

for idxMethod=1:numel(RecordTableShow2)
    Table=RecordTableShow2{1,idxMethod};
    Yh_Xhat(idxMethod,:)=RecordDataShow2{1,idxMethod}.Yh_Xhats(end,:);
    SSET_End(idxMethod,1)=Table.SSETrue_Xhats(end,:);
end
sum([Yh_Xhat-PhysData].^2,2)
Labels={'MBC-AGP','BC-AGP', 'Nested' ,'BC-GP','SR-GP' ,'LR' ,'Field data'};
linewidth=3;
MarkerSize1=15;
figure(25),clf
tiledlayout(1,2,'Padding','none','TileSpacing','none');

for kd=1:2
    nexttile
    kdidx=(kd-1)*11+[1:11];
    plot(Yh_Xhat(1,kdidx),'k:','linewidth',linewidth+3,'MarkerFaceColor','none','MarkerSize',MarkerSize1,'MarkerIndices',[1:1:11])
    hold on
    plot(Yh_Xhat(2,kdidx),'--v','linewidth',linewidth,'MarkerFaceColor','w','MarkerSize',MarkerSize1,'MarkerIndices',[1:2:11])
    plot(Yh_Xhat(3,kdidx),'-.bd','linewidth',linewidth,'MarkerFaceColor','none','MarkerSize',MarkerSize1,'MarkerIndices',[4:2:11]),
    plot(Yh_Xhat(4,kdidx),'o:r','linewidth',linewidth,'MarkerFaceColor','none','MarkerSize',MarkerSize1,'MarkerIndices',[2:3:11]),
    plot(Yh_Xhat(5,kdidx),'--ks','linewidth',linewidth,'MarkerFaceColor','w','MarkerSize',MarkerSize1,'MarkerIndices',[5:3:11]),
    plot(Yh_Xhat(6,kdidx),'-.^','linewidth',linewidth,'MarkerFaceColor','w','MarkerSize',MarkerSize1,'MarkerIndices',[1:3:11 11]),
    plot(PhysData(kdidx),'-p','linewidth',linewidth,'MarkerSize',MarkerSize1,'MarkerIndices',[1:1:11])
    xticks(1:11)
    
    xlabel 'Number of hours after 12:00 a.m.'
    if kd==1
        ylim([20.8 24.4])
        title '(a)'
        xticklabels({'1','3','5','7','9','11','13','15','17','19','21 '})
    else
        ylim([21.5 24.6])
        title '(b)'
    xticklabels({'1','3','5','7','9','11','13','15','17','19','21  '})
    end
    xlim([0.8 11.2])
    
    ylabel 'Temperature'
    
    leg = legend(Labels,'NumColumns',2);
    leg.ItemTokenSize = [70,50];

    set(findobj(gcf,'type','axes'),'FontSize',24,'FontWeight','Bold', 'LineWidth', 2);
    set(gcf,'Position' , [         100         170        1770         666])
%     set(gcf,'Position' , [         100         170        1770         500])
end


%%
%%%%%% %Condition numbers
% clear
% clc
load Example2.mat
AllConditionNumber= [ ];
for id=1:50
    Table=T_LR{id};
    AllConditionNumber(id,:)=  [  Table.BestTables(:,4) ];
    Allgamma(id,:)=  [  Table.BestTables(:,3) ];
    Alltheta_space(id,:)=  [  Table.BestTables(:,1) ];
    Alltheta_time(id,:)=  [  Table.BestTables(:,2) ];
end


allidx=1000;

figure(26),clf
subplot(221)
Alltheta_space=sort(Alltheta_space(:));
histogram(Alltheta_space(1:allidx))
title('correaltion parameter for space, example 2')

subplot(222)
Alltheta_time=sort(Alltheta_time(:));
histogram(Alltheta_time(1:allidx))
title('correaltion parameter for time')

subplot(223)
Allgamma=sort(Allgamma(:));
histogram(Allgamma(1:allidx))
title('gamma')


subplot(224)
AllConditionNumber=sort(AllConditionNumber(:));
histogram(AllConditionNumber(1:allidx))
title('condition number')






ThisDesign=1;
ThisObs=15

Table=T_LR{ThisDesign};
Delta=[SingleDataInput(ThisDesign).Yh(ThisObs,:)-PhysData]';
Theta0s=Table.BestTables(ThisObs,1:2);
gamma=Table.BestTables(ThisObs,3);


Space=[  2.88,3.13,2.55 ; 
                 2.88,1.13,2.55 ]; NSpace=2;
dist=pdist2(Space,Space);%=2
Rs=exp(-Theta0s(1)*dist.^1.99);
[Vs,DiagDs]=svd(Rs);%R1  2-by-2  %'vector' econ

Ntime=11;
Time=[1:Ntime]'/Ntime;     NTime=numel(Time);
Rt=ComputeRMatrix0(Time,Time,Theta0s(2))+10^-6*speye(numel(Time));%11*11
[Vt,DiagDt]=svd(Rt);%R2
N=NSpace*NTime;

%%Way 2 to get Sigma 0, and the covariance matrix V and its inverse invV
invRs=invandlogdet(Rs);
invRt=invandlogdet(Rt);
V=gamma*kron(Rs,Rt)+eye(N);%covariance function
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
ZCov=max(diag(Sigma00*(V1-V1*invV*V1')),0);
ZLCL = ZPred+norminv(0.025)*ZCov.^0.5;
ZUCL= ZPred+norminv(1-0.025)*ZCov.^0.5;

figure(27),clf
plot(Delta,'-s','LineStyle','-')
hold on
plot(ZPred,'o')%,'LineStyle','none')
plot(ZLCL,'x','LineStyle','none')
plot(ZUCL,'+','LineStyle','none')

legend('Data:delta','Posterior mean','LCL','UCL')
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
%{

%%
clc
Trainidx=3 
% Trainidx=8
% Trainidx=12
% Trainidx=13
% Trainidx=16
% Trainidx=17
% Trainidx=27
% Trainidx=29
% Trainidx=30
% Trainidx=31
% Trainidx=32
% Trainidx=34%Good
% Trainidx=36
% Trainidx=38
% Trainidx=39
% Trainidx=40
% Trainidx=46
% Trainidx=47
MFidxTrial=Trainidx;
LFidxTrial=3;

%%
%Same LF=MF
clc
% Trainidx=3%ad
% Trainidx=8%a
% Trainidx=12%a
% Trainidx=13%ad
% Trainidx=16%ad
% Trainidx=17%ad
% Trainidx=27%a
% Trainidx=29%a
Trainidx=30%ad
% Trainidx=31%a
% Trainidx=32%a
% Trainidx=34%Good-a
% Trainidx=36%a
% Trainidx=38%ad
% Trainidx=39%ad
% Trainidx=40%ad
% Trainidx=46%a
% Trainidx=47%ad

MFidxTrial=Trainidx;
LFidxTrial=3;
%}