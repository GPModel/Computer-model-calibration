function Y=Simulator(x,Level,Case)

if Case==1 %Example 1
    Y=Simulator1(x,Level);
elseif Case==2      %Example 2
    Y=Simulator2(x,Level);
end

end
%%
function [Y,YRow]=Simulator1(xx,Level)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ENVIRONMENTAL MODEL FUNCTION
%
% Authors: Sonja Surjanovic, Simon Fraser University
%          Derek Bingham, Simon Fraser University
% Questions/Comments: Please email Derek Bingham at dbingham@stat.sfu.ca.
%
% Copyright 2013. Derek Bingham, Simon Fraser University.
%
% THERE IS NO WARRANTY, EXPRESS OR IMPLIED. WE DO NOT ASSUME ANY LIABILITY
% FOR THE USE OF THIS SOFTWARE.  If software is modified to produce
% derivative works, such modified software should be clearly marked.
% Additionally, this program is free software; you can redistribute it
% and/or modify it under the terms of the GNU General Public License as
% published by the Free Software Foundation; version 2.0 of the License.
% Accordingly, this program is distributed in the hope that it will be
% useful, but WITHOUT ANY WARRANTY; without even the implied warranty
% of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
% General Public License for more details.
%
% For function details and reference information, see:
% http://www.sfu.ca/~ssurjano/
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% OUTPUT AND INPUTS:
%
% y=row vector of scaled concentrations of the pollutant at the
%     space-time vectors (s, t)
%     Its structure is:
%     y(s_1, t_1), y(s_1, t_2), ..., y(s_1, t_dt), y(s_2, t_1), ...,
%     y(s_2,t_dt), ..., y(s_ds, t_1), ..., y(s_ds, t_dt)
% xx=[M, D, L, tau]
% s=vector of locations (optional), with default value
%     [0.5, 1, 1.5, 2, 2.5]
% t=vector of times (optional), with default value
%     [0.3, 0.6, ..., 60]
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%
% L ∈ [0.01, 3]	location of the second spill
% τ ∈ [30.01, 30.295]   	time of the second spill

D=(0.12-0.02)*xx(1)+0.02;
M =7+6*xx(2);

if Level ==1%LF
    L =0.94;
    tau =30.295;
elseif Level==2 %HF
    L  =0.92;
    tau =30.295;
end
% if (nargin < 3)
t=[0.3:0.3:60];
% end
% if (nargin < 2)
s= [1, 1.5, 2, 2.5 3];
% end

ds=length(s);
dt=length(t);
dY=ds * dt;
Y=zeros(ds, dt);
% Create matrix Y, where each row corresponds to si and each column
% corresponds to tj.
for (ii=1:ds)
    si=s(ii);
    for (jj=1:dt)
        tj=t(jj);
        
        term1a=M / sqrt(4*pi*D*tj);
        term1b=exp(-si^2 / (4*D*tj));
        term1=term1a * term1b;
        
        term2=0;
        if (tau < tj)
            term2a=M / sqrt(4*pi*D*(tj-tau));
            term2b=exp(-(si-L)^2 / (4*D*(tj-tau)));
            term2=term2a * term2b;
        end
        
        C=term1 + term2;
        Y(ii, jj)=sqrt(4*pi) * C;
    end
end

% Convert the matrix into a vector (by rows).
YRow=Y';
Y=YRow(:)';

end

%%
function OutputForCalibration=Simulator2(x,Level)
% x1 -  FCU cooling air flow rate m³/s [0.5,0.7]
% x2 -  Outdoor air supply per unit floor area (m³/s)/m2 [0.12,0.3]
% x3 -  FCU cooling water flow rate m³/s [0.0004,0.001]
% x4 - Overnight equipment heat gain (ratio of overnight equipment heat gain to peak daytime value) n/a [0,1]

XNames={'x1' 'x2' 'x3' 'x4'} ;
SimMin= [0.5   0.12  0.0004   0];
SimMax= [0.7   0.3   0.001     1];
SimGap=SimMax-SimMin;
SimInput=SimMin + SimGap.*x ; %Transform values of stadnardized design point in [0,1]^4 to values of EP simulation inputs

%%%%%%%%%%%%%%%%%%Read all the lines in the EPBasicFile.idf
AllLines = readlines("EPBasicFile.idf");
MaxLine=length(AllLines);

%%%%%%%%%%%%%%%%%%Add values of x1 to x4 to the lines that contain variables by replacing '*****'
Lines{1}=[3809 3826 3843];
Lines{2}=[ 3427];
Lines{3}=[ 3808 3825 3842];
Lines{4}=[ 340 365 390 425 460 495 520 545 570 960 995];
for var=1:4
    for idx=1:numel(Lines{var})
        Line=Lines{var}(idx);
        AllLines{Line}=strrep(AllLines{Line},'*****',num2str(SimInput(var),10));%
    end
end

if Level==2%HF
    Number_TimePoint_EveryHour=60;  %Number_TimePoint_EveryHour  can be 1 2 3 4 5 6 10 12 15 20 30 60 
elseif Level==1%LF
    Number_TimePoint_EveryHour=5;
end

AllLines{76}=strrep(AllLines{76},'*****',num2str(Number_TimePoint_EveryHour)); %!- Number of timesteps per hour for EP simulation

%%%%%%%%%%%%%%%%%%Create the EPNewFile.idf using all the lines with added values of x1 to x4.
NewFileName='EPNewFile.idf';
fileID=fopen(NewFileName,'w+');
for idxLine=1:MaxLine
    fprintf(fileID,'%s\t\n',AllLines{idxLine});
end
fclose(fileID);

%%%%%%%%%%%%%%%%%%Run EP simulations based on the EPNewFile.idf%%%%%%%%%%%%%%%%%%
Command=['C:\EnergyPlusV9-4-0\energyplus     -s C   -r   -c   -p EPNewFile        -w  EPWeather.epw      EPNewFile.idf'];
[status,cmdout]=system(Command); %Run EP simulations


%%%%%%%%%%%%%%%%%%Read standard simulator output from the output file (EPNewFile.csv)
ReadData=readmatrix(['EPNewFile.csv']);
SimTemperature=ReadData(:,[55 67 ] );   %Simulator output with different timesteps over 0:01 - 24:00 for Sensor 1 and Sensor2 

%%%%%%%%%%%%%%%%%%Average temperature for each of the two-hour intervals over 0:01 - 22:00 for Sensor 1 and Sensor2 
Number_TimePoint_EveryTwoHours=Number_TimePoint_EveryHour*2;

OutputForCalibration= [ ];
for Sensor=1:2
    AverageTemperature=SimTemperature(:,Sensor); %LF simulator output with different timesteps over 0:01 - 24:00 for Sensor 1 and Sensor2
    AverageTemperature=reshape(AverageTemperature,Number_TimePoint_EveryTwoHours,[]);
    AverageTemperature11Points=mean(AverageTemperature); %Average temperature for each of the two-hour intervals
    AverageTemperature11Points(end)=[]; %Remove the last one point (22:01 to 24:00) to get 11 points
    OutputForCalibration=[OutputForCalibration AverageTemperature11Points];%2*11
end
%  delete *.audit *.bnd   *.eio  *.err  *.eso  *.end  *.epJSON  *.mdd  *.mtd  *.mtr  *.mvi  *.rdd  *.audirvaudit  *.shd  *.sql  *.html  *.svg   *.rvaudit  *.rvi  *.ZsZ  *Meter*   *Table*   *SsZ*  *ZsZ* *htm
end