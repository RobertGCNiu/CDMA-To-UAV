%
% Reference :   
% Optimal LAP Altitude for Maximum Coverage
% By Akram Al-Hourani et. al.    
% IEEE Wireless Communications Letters, VOL. 3, NO. 6, December 2014
%
clear all;
PL_dB=110;

% LapAltitude=100:2:4500;
% LapAltitude=500;
% CellRadTestRange=100:2:4500;

LapAltitude=10:2:100;
CellRadTestRange=10:2:200;

MaxCellRad=zeros(length(LapAltitude),1);
for x=1:length(LapAltitude)
    tempPL=PathLossA2G(CellRadTestRange,LapAltitude(x));
    [minPL,nn]=min(abs(tempPL-PL_dB));
    MaxCellRad(x)=CellRadTestRange(nn);
end
plot(LapAltitude,MaxCellRad,'-*b');