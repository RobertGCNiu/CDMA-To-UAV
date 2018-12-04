%
% Program to investigate the PL curve as a function of R and h
% 
% Reference :   
% Optimal LAP Altitude for Maximum Coverage
% By Akram Al-Hourani et. al.    
% IEEE Wireless Communications Letters, VOL. 3, NO. 6, December 2014
%
clear all;

R=0:100;
h=[1:9 10:10:100];

for ii=1:length(h)
    PL(:,ii)=PathLossA2G(R,h(ii));
end
plot(R,PL);
grid;
legend('h=1','h=2','h=3','h=4','h=5',...
    'h=6','h=7','h=8','h=9',...
    'h=10','h=20','h=30','h=40','h=50',...
    'h=60','h=70','h=80','h=90','h=100');
xlabel('Radius (m)');
ylabel('PL (dB)');

% hold on;
% dd=sqrt(h.^2+R.^2);
% fc=2e9;
% plot(R, 32.4+20*log10(dd)+20*log10(fc),'-r');
