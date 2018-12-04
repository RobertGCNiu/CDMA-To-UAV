%
% Reference : Optimal LAP Altitude for Maximum Coverage
% Authors:    Akram Al-Hourani et. al.    
% Journal:    IEEE WIRELESS COMMUNICATIONS LETTERS, VOL. 3, NO. 6, DECEMBER 2014
%
close all;
clear all;

% Urban 
alpha=0.3;
beta=500;
gamma=15;

h=100;
htx=h;
hrx=2;

a = 9.61;
b = 0.16;

theta=0:90;
% PL=ones(1,length(theta));
% for ii=1:length(theta)
%     r=h/tand(theta(ii));
%     m=floor(r*sqrt(alpha*beta)-1);
%     for n=0:m
%         PL(ii)=PL(ii)*(1-exp(-(htx-(n+1/2)*(htx-hrx)/(m+1)).^2/2/gamma^2));
%     end
% end
PL=1./(1+a.*exp(-b.*(theta-a)));
plot(theta,PL,'-*');