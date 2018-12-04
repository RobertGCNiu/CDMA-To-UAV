function [Rmax,optHeight] = FindMaxR(PL_dB,maxHeight)
%
% Reference :   
% Optimal LAP Altitude for Maximum Coverage
% By Akram Al-Hourani et. al.    
% IEEE Wireless Communications Letters, VOL. 3, NO. 6, December 2014
%
% Last update on 4/12/2018
%

% Search Range
LapAltitude=1:maxHeight;
CellRadius=1:100;

MaxCellRad=zeros(length(LapAltitude),1);
for x=1:length(LapAltitude)
    tempPL=PathLossA2G(CellRadius,LapAltitude(x));
    [minPL,nn]=min(abs(tempPL-PL_dB));
    MaxCellRad(x)=CellRadius(nn);
end
[Rmax,mm]=max(MaxCellRad);
optHeight=LapAltitude(mm);

% plot(LapAltitude,MaxCellRad,'-*b');
% xlabel('Altitude (m)');
% ylabel('Max. Cell Radius (dB)');