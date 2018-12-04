function PL = PathLossA2G(R,h)
%
% Reference :   
% Optimal LAP Altitude for Maximum Coverage
% By Akram Al-Hourani et. al.    
% IEEE Wireless Communications Letters, VOL. 3, NO. 6, December 2014
%

% Parameters for the Urban environments
a = 9.61;
b = 0.16;
eta_los = 1;
eta_Nlos = 20;

f_c = 28e9;
% f_c = 2000*10^6;
c = 3*10^8;
A = eta_los-eta_Nlos;
B = 20*log10(f_c) + 20*log10(4*pi/c) + eta_Nlos;
PL = A./(1+a.*exp(-b.*(atand(h./R)-a)))+10*log10(h.^2+R.^2)+ B;
% pl = 10^(pl_dB/10);