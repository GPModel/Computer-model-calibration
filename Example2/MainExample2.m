%Section 1: Sets parameters for all calibration methods 
clear,clc,format compact 
%Temperature measurement over 12:01 a.m. to 10:00 p.m.
SensorTemperature=[24.5,24.5;24.5,24.5;24.5,24.5;24.5,24.5;24.5,24.5;24.5,24.5;24.5,24.5;24.5,24.5;24.5,24.5;24.5,24.5;24.5,24.5;24.5,24.5;24.5,24.5;24.5,24.5;24.5,24.5;24.5,24.5;24.5,24.5;24.5,24.5;24.5,24.5;24.5,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24.5;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24.5;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24.5;24,24;24,24.5;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;24,24;23.5,24;23.5,24;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23;23.5,23;23,23;23,23;23,23;23,23;23,23;23,22.5;23,22.5;23,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22;22.5,22;22.5,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,21.5;22,21.5;22,21.5;22,21.5;22,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21;21.5,21;21.5,21;21.5,21;21.5,21;21.5,21;21.5,21;21.5,21;21.5,21;21.5,21;21.5,21;21.5,21;21.5,21;21.5,21;21.5,21;21.5,21;21.5,21;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;21.5,21.5;22,21.5;22,21.5;22,21.5;22,21.5;22,21.5;22,21.5;22,21.5;22,21.5;22,21.5;22,21.5;22,21.5;22,21.5;22,21.5;22,21.5;22,21.5;22,21.5;22,21.5;22,21.5;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,21.5;22,21.5;22,21.5;22,21.5;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22.5;22.5,22;22.5,22;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22;22.5,22;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22,22.5;21,22.5;20,22.5;19,22.5;18,22.5;17.5,22;17,22;17,22;17.5,22;17.5,22;18,22;18,22;18.5,22;18.5,22;19,22;19,22;19.5,22;20,22;20,22;20.5,22;20.5,22;21,22;21,22;21.5,22;21.5,22;21.5,22;22,22;22,22;22,22;22,22;22,22.5;22,22.5;22,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;21.5,22.5;20.5,22.5;19,22.5;18.5,22.5;18,22.5;17.5,22;17,22;17.5,22;17.5,22;18,22;18,22;18.5,22;18.5,22;19,22;19,22;19.5,22;20,22;20,22;20.5,22;20.5,22;21,22;21,22;21.5,22;21.5,22;21.5,22;21.5,22;22,22;22,22;22,22;22,22;22,22.5;22,22.5;22,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22,22.5;21,22.5;20,22.5;19,22.5;18,22.5;17.5,22;17,22;17,22;17.5,22;17.5,22;18,22;18,22;18.5,22;18.5,22;19,22;19,22;19.5,22;20,22;20,22;20.5,22;20.5,22;21,22;21,22;21,22;21.5,22;21.5,22;21.5,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;21.5,22.5;20.5,22.5;19.5,22.5;18.5,22.5;18,22.5;17.5,22;17,22;17,22;17.5,22;17.5,22;18,22;18,22;18.5,22;18.5,22;19,22;19,22;19.5,22;20,22;20,22;20.5,22;20.5,22;21,22;21,22;21,22;21.5,22;21.5,22;21.5,22;21.5,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22.5,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22;22,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;22.5,22.5;23,23;23,23;23,23;23,23;23,23;23,23;23,23;23,23;23.5,23;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5;23.5,23.5];
Dim=3;
XTrue='unkown';
nh=08;
nl=16;
nh0=12;
RatioCost=4;
Case=2;
InitialBudget = nl*1+RatioCost*nh
InitialBudget0= nh0*RatioCost
Budget=InitialBudget0+15
Budget1=Budget+1;
NoTrials=100;

SensorTemperatureEveryTwoHours=reshape(SensorTemperature,120,[]);
PhysData=mean(SensorTemperatureEveryTwoHours);

parfor id=1:NoTrials
    id
    rand
    [Dl,Dh]=GenerateNestedLHD(nl,nh,Dim,1e5);     
    [Dh0]=GenerateNestedLHD(nh0,nh0,Dim,1e5);     
    
    Dls(:,:,id)=Dl;
    Dhs(:,:,id)=Dh;
    Dh0s(:,:,id)=Dh0;    
end

for id =1:NoTrials
    rand
    disp(id)
    Dl=Dls(:,:,id);
    Dh=Dhs(:,:,id);
    Dh0=Dh0s(:,:,id);
    clear Yl Yh
    for jd=1:nl
        [id jd]
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
    save Example2.mat
end
%%
%Section 2: Bayesian optimization
ZNBC_BC=1;   ZNBC_ID=0;   ZNBC_SR=2;
ZMLFSSE=1;   ZLFSSE=0;
ZWError=1;
for id=1:NoTrials
    disp('---')
    [T_MBC_AGP{id,1},Data_MBC_AGP{id,1}] =CalibrationAGP(MultiDataInput(id),ZNBC_BC,ZMLFSSE); 'MBC-AGP'
    [T_BC_AGP{id,1},Data_BC_AGP{id,1}] =CalibrationAGP(MultiDataInput(id),ZNBC_BC,ZLFSSE); 'BC-AGP'
    [T_MID_AGP{id,1},Data_MID_AGP{id,1}] =CalibrationAGP(MultiDataInput(id),ZNBC_ID,ZMLFSSE); 'MID-AGP'
    [T_SR_AGP{id,1},Data_SR_AGP{id,1}] =CalibrationAGP(MultiDataInput(id),ZNBC_SR,ZLFSSE); 'SR-AGP'
    [T_Nested{id,1},Data_Nested{id,1}] =CalibrationNested(MultiDataInput(id)); 'Nested'
    [T_SVDAGP{id,1},Data_SVDAGP{id,1}] =CalibrationSVDAGP(MultiDataInput(id));'SVD-AGP'
    [T_BC_GP{id,1},Data_BC_GP{id,1}] =CalibrationBCGP(SingleDataInput(id)); 'BC-GP'
    [T_SR_GP{id,1},Data_SR_GP{id,1}] =CalibrationSRGP(SingleDataInput(id)); 'SR-GP'
    [T_SVD{id,1},Data_SVD{id,1}] =CalibrationSVD(SingleDataInput(id));'SVD'
    save('Example2.mat')
end
%%
%Section 3: Show BO results 
clear,clc
load Example2.mat

idx=(1:100);
Labels={'MBC-AGP','BC-AGP','MID-AGP','SR-AGP', 'Nested','SVD-AGP','BC-GP','SR-GP' ,'SVD'}' ;
RecordTableShow=[T_MBC_AGP(idx)  T_BC_AGP(idx)   T_MID_AGP(idx)  T_SR_AGP(idx)   T_Nested(idx)  T_SVDAGP(idx) T_BC_GP(idx)  T_SR_GP(idx)              T_SVD(idx)     ];
RecordDataShow=[Data_MBC_AGP(idx)  Data_BC_AGP(idx)  Data_MID_AGP(idx)  Data_SR_AGP(idx)    Data_Nested(idx) Data_SVDAGP(idx)   Data_BC_GP(idx)  Data_SR_GP(idx)   Data_SVD(idx)   ];

XMLE= [  0.458078384399414         0.971454620361328                         1 ];
SSE_XMLE =3.5264931476456; 

SimMin= [ 0.12  0.0004   0];
SimMax= [  0.3   0.001   0.975];
SimGap=SimMax-SimMin;
SimXMLE=SimMin + SimGap.*XMLE;

for idxMethod=9:-1:1
    AllXhats=[];
    for idxTrain=idx
        Table=RecordTableShow{idxTrain,idxMethod};
        
        SSETrue_XhatsEnd(idxTrain,idxMethod)=Table.SSETrue_Xhats(end,:);
        XhatsEnd = Table.Xhats(end,:);
        L2End(idxTrain,idxMethod)=norm(XhatsEnd-XMLE);L2End_a2=L2End;
        if idxMethod<=2 || idxMethod==7
            phiEnd(idxTrain,idxMethod)=Table.phis(end,:);
        end
        
        costs=[1 RatioCost]';
        SSETrue_Xhats_iter=Table.SSETrue_Xhats;
        Xhats_iter=Table.Xhats;
        AllXhats=[AllXhats;];
        L2s_iter=sum((Xhats_iter-XMLE).^2,2).^0.5;
        Level_iter=Table.Level;
        Budget_iter=cumsum(costs(Level_iter));
        
        if idxMethod==7 || idxMethod==8 ||idxMethod==9
            TrueSSE_Xhats_Budget(1:Budget1,idxMethod,idxTrain) = interp1(Budget_iter,SSETrue_Xhats_iter,1:Budget1);
            L2s_Xhats_Budget(1:Budget1,idxMethod,idxTrain)=interp1(Budget_iter,L2s_iter,1:Budget1);
        elseif idxMethod<=4
            TrueSSE_Xhats_Budget(1:Budget,idxMethod,idxTrain) = interp1(Budget_iter,SSETrue_Xhats_iter,1:Budget);
            L2s_Xhats_Budget(1:Budget,idxMethod,idxTrain)=interp1(Budget_iter,L2s_iter,1:Budget);
        elseif idxMethod==5 || idxMethod==6
            deleteLFidx=(nl+nh+1):2:30;
            Budget_iter(deleteLFidx,:)=[];
            SSETrue_Xhats_iter(deleteLFidx,:)=[];
            L2s_iter(deleteLFidx,:)=[];
            
            TrueSSE_Xhats_Budget(1:Budget,idxMethod,idxTrain) = interp1(Budget_iter,SSETrue_Xhats_iter,1:Budget);
            L2s_Xhats_Budget(1:Budget,idxMethod,idxTrain) = interp1(Budget_iter,L2s_iter,1:Budget);
            
        end
    end
end
meanTrueSSE_Xhats_Budget=mean(TrueSSE_Xhats_Budget(:,:,:),3);
meanTrueSSE_Xhats_Budget_SSEXMLE=meanTrueSSE_Xhats_Budget-SSE_XMLE;
meanL2s_Xhats_Budget=mean(L2s_Xhats_Budget,3);

idx1=1;
for idx2=1:9
        [ ~, ttest_p_Sh(idx2,1)]=ttest(SSETrue_XhatsEnd(:,idx1),SSETrue_XhatsEnd(:,idx2));
        [ ~, ttest_p_L2(idx2,1)]=ttest(L2End(:,idx1),L2End(:,idx2));
end
Labels1={'(i) vs (i) ','(i) vs BC-AGP ','(i) vs MID-AGP ','(i) vs SR-AGP ' ' (i) vs Nested' ,'(i) vs SVDAGP', ' (i) vs BC-GP',' (i) vs SR-GP',' (i) vs SVD'}';
Table2 =table(Labels1,mean(SSETrue_XhatsEnd)',ttest_p_Sh,mean(L2End)',ttest_p_L2)
htmlGray = [128 128 128]/255;
htmlGreen =[0.4660 0.6740 0.1880];


figure(2),clf
subplot(121)
FontSize6=28;
linewidth=0.1*30;
MarkerSize1=15;
plot(1:Budget,meanTrueSSE_Xhats_Budget_SSEXMLE(1:Budget,1),'ko-','linewidth',linewidth+1,'MarkerSize',MarkerSize1,'MarkerIndices',[InitialBudget:6:Budget Budget]),hold on
plot(1:Budget,meanTrueSSE_Xhats_Budget_SSEXMLE(1:Budget,2),'b:o','linewidth',linewidth+1,'MarkerSize',MarkerSize1,'MarkerFaceColor','b','MarkerIndices',[(InitialBudget+3):6:Budget Budget])
plot(1:Budget,meanTrueSSE_Xhats_Budget_SSEXMLE(1:Budget,3),'k^-','linewidth',linewidth+1,'MarkerSize',MarkerSize1,'MarkerIndices',[InitialBudget+2:3:Budget Budget]),hold on
plot(1:Budget,meanTrueSSE_Xhats_Budget_SSEXMLE(1:Budget,4),'--v','linewidth',linewidth+1,'Color', htmlGray,'MarkerSize',MarkerSize1,'MarkerIndices',[InitialBudget+2:3:Budget Budget])
plot(1:Budget,meanTrueSSE_Xhats_Budget_SSEXMLE(1:Budget,5),':s','linewidth',linewidth+1,'color',htmlGreen,'MarkerFaceColor',htmlGreen,'MarkerSize',MarkerSize1,'MarkerIndices',[InitialBudget (InitialBudget):4:Budget Budget ])
plot(1:Budget,meanTrueSSE_Xhats_Budget_SSEXMLE(1:Budget,6),'b:x','linewidth',linewidth+1,'MarkerSize',MarkerSize1+10,'MarkerIndices',[InitialBudget (InitialBudget+2):4:Budget Budget]),hold on
plot(1:Budget1,meanTrueSSE_Xhats_Budget_SSEXMLE(1:Budget1,7),'--rs','linewidth',linewidth+1,'MarkerSize',MarkerSize1,'MarkerIndices',[InitialBudget InitialBudget+1:4:Budget1 Budget1])
plot(1:Budget1,meanTrueSSE_Xhats_Budget_SSEXMLE(1:Budget1,8),'--h','linewidth',linewidth+1,'MarkerFaceColor','none','MarkerSize',MarkerSize1,'MarkerIndices',[InitialBudget InitialBudget+1:4:Budget1 Budget1])
plot(1:Budget1,meanTrueSSE_Xhats_Budget_SSEXMLE(1:Budget1,9),':d','linewidth',linewidth+1,'MarkerSize',MarkerSize1,'MarkerIndices',[InitialBudget (InitialBudget):4:Budget1 Budget1])
xlabel('Computational cost','FontWeight','normal')
ylabel('Average  $S_h(\hat{\textbf{x}}^*_{\mathbf{ML}})$-3.526493  {   }','Interpreter','latex');
leg = legend(Labels,'NumColumns',3,'Location','northeast','fontsize',20);
leg.ItemTokenSize = [64,50];
set(gca,'YScale','log','FontSize',FontSize6,'FontWeight','Bold', 'LineWidth', 3);
yticks([.0625 0.125 0.25 0.5 1 2 4 8 ])
ylim([0.05 11])
set(gca,'Position',[0.1 0.2 0.41 0.71])
title('(a)','FontSize',25,'FontWeight','Bold')
xticks([48:2:64])
xlim([47.9 64.2])

subplot(122)
plot(1:Budget,meanL2s_Xhats_Budget(1:Budget,1),'ko-','linewidth',linewidth+1,'MarkerSize',MarkerSize1,'MarkerIndices',[InitialBudget:6:Budget Budget]),hold on
plot(1:Budget,meanL2s_Xhats_Budget(1:Budget,2),'b:o','linewidth',linewidth+1,'MarkerSize',MarkerSize1,'MarkerFaceColor','b','MarkerIndices',[(InitialBudget+3):6:Budget Budget])
plot(1:Budget,meanL2s_Xhats_Budget(1:Budget,3),'k^-','linewidth',linewidth+1,'MarkerSize',MarkerSize1,'MarkerIndices',[InitialBudget+2:3:Budget Budget]),hold on
plot(1:Budget,meanL2s_Xhats_Budget(1:Budget,4),'--v','linewidth',linewidth+1,'Color', htmlGray,'MarkerSize',MarkerSize1,'MarkerIndices',[(InitialBudget+2):3:Budget Budget])
plot(1:Budget,meanL2s_Xhats_Budget(1:Budget,5),'g:s','linewidth',linewidth+1,'color',htmlGreen,'MarkerFaceColor',htmlGreen,'MarkerSize',MarkerSize1,'MarkerIndices',[InitialBudget (InitialBudget):4:Budget Budget ])
plot(1:Budget,meanL2s_Xhats_Budget(1:Budget,6),'b:x','linewidth',linewidth+1,'MarkerSize',MarkerSize1+10,'MarkerIndices',[InitialBudget (InitialBudget):3:Budget Budget]),hold on
plot(1:Budget1,meanL2s_Xhats_Budget(1:Budget1,7),'--s','linewidth',linewidth+1,'Color', 'r','MarkerSize',MarkerSize1,'MarkerIndices',[InitialBudget InitialBudget+1:4:Budget1 Budget1])
plot(1:Budget1,meanL2s_Xhats_Budget(1:Budget1,8),'--h','linewidth',linewidth+1,'MarkerFaceColor','none','MarkerSize',MarkerSize1,'MarkerIndices',[InitialBudget InitialBudget+1:4:Budget1 Budget1])
plot(1:Budget1,meanL2s_Xhats_Budget(1:Budget1,9),':d','linewidth',linewidth+1,'MarkerSize',MarkerSize1,'MarkerIndices',[InitialBudget (InitialBudget):4:Budget1 Budget1 ])
xlim([InitialBudget,Budget+1])
xlabel('Computational cost','FontWeight','normal')
ylabel('Average  $L_2(\hat{\textbf{x}}^*_{\mathbf{ML}})$','Interpreter','latex');  
yticks([0.2 0.3:0.1:1.2 ] )
leg = legend(Labels,'NumColumns',3,'Location','northeast','fontsize',20);
leg.ItemTokenSize = [64,45];
set(gca,'Position',[0.583 0.2 0.41 0.71])
title('(b)','FontSize',24,'FontWeight','Bold')
ylim([0.19  0.8])
set(findobj(gcf,'type','axes'),'FontSize',FontSize6,'FontWeight','Bold', 'LineWidth', 3);
set(gcf,'Position',[          0         100        1920         615])
xticks([InitialBudget:2:Budget1 ])
xlim([InitialBudget-0.1 Budget1+0.2])


figure(3),clf
Labels2Method={'MBC-AGP','BC-AGP','BC-GP'};
boxplot( phiEnd(:,[1 2 7]), 'Labels',Labels2Method,'OutlierSize',10,'Widths',0.8*[1 1 1  ])
set(findobj(gca,'type','line'),'linew',2)
set(findobj(gcf,'type','axes'),'FontSize',27,'FontWeight','Bold', 'LineWidth', 2);
ylabel('$ \hat \varphi$','Interpreter','latex','FontSize',50,'Rotation',0,'HorizontalAlignment','right','VerticalAlignment','baseline')
set(gca,'Position',[    0.2    0.15    0.78    0.83])
set(gcf,'Position',[           409   559   900   410])
set(gcf,'Position',[           409   559   900   334])
set(findobj(gcf,'type','axes'),'FontWeight','Bold', 'LineWidth', 3);
yticks([-0.1:0.1:0.6])
set(gca,'yGrid','on','GridLineStyle','--')
ylim([-0.17 0.67])
set(gcf,'Position',[           109   159   900   372])
medians=median(phiEnd(:,[1 2 7]));
FontSize77=21;
text(1,1.15*medians(1),['Median=' num2str(medians(1),2)],'HorizontalAlignment','center','FontSize',FontSize77,'FontWeight','Bold')
text(2,1.091*medians(2),['Median=' num2str(medians(2),2)],'HorizontalAlignment','center','FontSize',FontSize77,'FontWeight','Bold')
text(3,1.2*medians(3),['Median=' num2str(medians(3),2)],'HorizontalAlignment','center','FontSize',FontSize77,'FontWeight','Bold')
xlim([0.45 3.55])

%%
idxTrain=12;
aaa=[1 2 ; 1 3;2 3;];
for idxMethod=1:2
    Data=RecordDataShow{idxTrain,idxMethod};
    Table=RecordTableShow{idxTrain,idxMethod};
    XhatsEnd=Table.Xhats(end,:);
    SSEEnd=Table.SSETrue_Xhats(end,:)
    InitialDh=Data.Dh(1:nh,:);
    InitialDl=Data.Dl(1:nl,:);
    FollowDh=Data.Dh(nh+1:end,:);
    FollowDl=Data.Dl(nl+1:end,:);
    
    figure(3+idxMethod),clf
    tiledlayout(1,3,'Padding','none','TileSpacing','none');
    
    for kd=1:3
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

        xticks([0:0.2:1]);
        yticks([0:0.2:1])

        lim0=0.02;
        xlim( [-lim0 1+lim0])
        ylim( [-lim0 1+lim0])
                         
    end
    
    set(findobj(gcf,'type','axes'),'FontSize',17,'FontWeight','Bold', 'LineWidth', 1);
    if idxMethod==1
        sgtitle('(a) MBC-AGP','fontsize',25,'FontWeight','Bold')
        set(gcf,'Position' , [         0         450        1600         350])        
    else
        sgtitle('(b) BC-AGP','fontsize',25,'FontWeight','Bold')

        set(gcf,'Position' , [         0         0        1600         350])
        
    end
    
end

%%
idxTrain=68;




for idxMethod=1:9
    Table=RecordTableShow{idxTrain,idxMethod};
    Yh_Xhat(idxMethod,:)=RecordDataShow{idxTrain,idxMethod}.Yh_Xhats(end,:);
    SSET_End(idxMethod,1)=Table.SSETrue_Xhats(end,:);
end
linewidth=3;
MarkerSize1=15;

Labels1={'MBC-AGP','BC-AGP','MID-AGP','SR-AGP', 'Nested','SVD-AGP','Field data'};
html1=[0.3010 0.7450 0.9330];
figure(6),clf
for kd=1:2
    subplot(1,2,kd)
    
    kdidx=(kd-1)*11+[1:11];
    plot(Yh_Xhat(1,kdidx),'k:','linewidth',linewidth+3,'MarkerFaceColor','none','MarkerSize',MarkerSize1,'MarkerIndices',[1:1:11])
    hold on
    plot(Yh_Xhat(2,kdidx),':v','linewidth',linewidth,'color','m','MarkerSize',MarkerSize1,'MarkerIndices',[1:2:11])
    plot(Yh_Xhat(3,kdidx),':o','color','r', 'linewidth',linewidth,'MarkerFaceColor','none','MarkerSize',MarkerSize1,'MarkerIndices',[1:2:11 11]),
    plot(Yh_Xhat(4,kdidx),'--bs','linewidth',linewidth,'MarkerSize',MarkerSize1,'MarkerIndices',[2:2:11])
    plot(Yh_Xhat(5,kdidx),'--d','color',html1,'linewidth',linewidth,'MarkerFaceColor','none','MarkerSize',MarkerSize1,'MarkerIndices',[1 2:2:11 11]),
    plot(Yh_Xhat(6,kdidx),'--r^','linewidth',linewidth,'MarkerSize',MarkerSize1,'MarkerIndices',[1:3:11 11]),
    plot(PhysData(kdidx),'-p','color',htmlGreen	, 'linewidth',linewidth,'MarkerSize',MarkerSize1,'MarkerIndices',[1:1:11])
    xticks(1:11)
    
    if kd==1
        ylim([20.8 24.6])
        title('(a)','FontWeight','bold')
        set(gca,'Position',[0.065 0.215 0.425 0.745])
    else
        ylim([21.4 24.6])
        title('(b)','FontWeight','bold')
        set(gca,'Position',[0.56 0.215 0.425 0.745])
    end
    
    set(findobj(gca,'type','axes'), 'FontWeight','Bold', 'LineWidth', 2);
    bp= gca;bp.FontSize=20;
    bp.XAxis.FontWeight='bold';bp.XAxis.FontSize=20;
    bp.YAxis.FontWeight='bold';bp.YAxis.FontSize=23;
    
    row1 = {'12:01 a.m.','2:01 a.m. ','4:01 a.m.','6:01 a.m.','8:01 a.m.','  10:01 a.m.','12:01 p.m.','2:01 p.m.','4:01 p.m.','6:01 p.m.','8:01 p.m.'};
    row2 = {'to 2:00 a.m.' 'to 4:00 a.m.' 'to 6:00 a.m.' 'to 8:00 a.m.' 'to 10:00 a.m.' 'to 12:00 p.m.','to 2:00 p.m.','to 4:00 p.m.','to 6:00 p.m.','to 8:00 p.m.','to 10:00 p.m.'};
    labelArray = [row1; row2;];
    tickLabels = strtrim(sprintf('%s\\newline%s\n', labelArray{:}));
    bp.XTickLabel = tickLabels;
    bp.XTickLabelRotation=90;
    
    xlabel('Time interval','FontWeight','bold','FontSize',20)
    
    xlim([0.8 11.2])
    ylabel('Temperature (Celsius)','FontWeight','bold')
    leg = legend(Labels1,'NumColumns',2);
    leg.ItemTokenSize = [60,50];
    set(gcf,'Position' , [         0         59        1800         963])
end


Labels2={'MBC-AGP','BC-GP','SR-GP','SVD','Field data'};

figure(7),clf
for kd=1:2
    subplot(1,2,kd)
    
    kdidx=(kd-1)*11+[1:11];
    plot(Yh_Xhat(1,kdidx),'k:','linewidth',linewidth+3,'MarkerFaceColor','none','MarkerSize',MarkerSize1,'MarkerIndices',[1:1:11])
    hold on
    plot(Yh_Xhat(7,kdidx),'<--b','linewidth',linewidth,'MarkerFaceColor','none','MarkerSize',MarkerSize1,'MarkerIndices',[1:3:11 11]),
    plot(Yh_Xhat(8,kdidx),':r>','linewidth',linewidth,'MarkerSize',MarkerSize1,'MarkerIndices',[1 2:3:11 11]),
    plot(Yh_Xhat(9,kdidx),'-.ks','linewidth',linewidth,'MarkerSize',MarkerSize1,'MarkerIndices',[1 3:3:11 11]),
    plot(PhysData(kdidx),'-p','color',htmlGreen	, 'linewidth',linewidth,'MarkerSize',MarkerSize1,'MarkerIndices',[1:1:11 11])
    xticks(1:11)
    
    if kd==1
        ylim([20.8 24.6])
        title('(a)','FontWeight','bold')
        set(gca,'Position',[0.065 0.255 0.425 0.695])
    else
        ylim([21.4 24.6])
        title('(b)','FontWeight','bold')
        set(gca,'Position',[0.56 0.255 0.425 0.695])
        
    end
    
    set(findobj(gca,'type','axes'), 'FontWeight','Bold', 'LineWidth', 2);
    bp= gca;bp.FontSize=20;
    bp.XAxis.FontWeight='bold';bp.XAxis.FontSize=20;
    bp.YAxis.FontWeight='bold';bp.YAxis.FontSize=23;
    
    row1 = {'12:01 a.m.','2:01 a.m. ','4:01 a.m.','6:01 a.m.','8:01 a.m.','  10:01 a.m.','12:01 p.m.','2:01 p.m.','4:01 p.m.','6:01 p.m.','8:01 p.m.'};
    row2 = {'to 2:00 a.m.' 'to 4:00 a.m.' 'to 6:00 a.m.' 'to 8:00 a.m.' 'to 10:00 a.m.' 'to 12:00 p.m.','to 2:00 p.m.','to 4:00 p.m.','to 6:00 p.m.','to 8:00 p.m.','to 10:00 p.m.'};
    labelArray = [row1; row2;];
    tickLabels = strtrim(sprintf('%s\\newline%s\n', labelArray{:}));
    bp.XTickLabel = tickLabels;
    bp.XTickLabelRotation=90;
    
    xlabel('Time interval','FontWeight','bold','FontSize',20)
    
    xlim([0.8 11.2])
    ylabel('Temperature (Celsius)','FontWeight','bold')
    leg = legend(Labels2,'NumColumns',2);
    leg.ItemTokenSize = [60,50];
    set(gcf,'Position' , [         0         59        1800         800])
end