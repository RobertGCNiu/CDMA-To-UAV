function [pathloss_opt, h_opt] = solveForNumuerialReusult(R)
eta_LoS = 1;
eta_NLoS = 20;
f_c = 2*10e9;
c = 3*10e8;
 a = 9.61;
 b=0.16;
%PL_max = 100;
%R = 100;
A = eta_LoS - eta_NLoS;
B = 20*log10(f_c) + 20*log10(4*pi/c) + eta_NLoS;
% distanceOfUavs = 3000;
f_z = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%------------This part is to numerically solve the eq(11)
for h = 1:1:(R*2)
 f=@(PL_max) A/(1+a*exp(-b*(atand(h/R)-a)))+10*log10(h^2+R^2)+ B- PL_max;
         
     [t,~] = fsolve(f,1);
     f_z = [f_z t];
  %  plot(h, t,'r*');  hold on
end
[pathloss_opt, h_opt] = min(f_z);
 %plot(1:1:200, f_z);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$



%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%===============This part is to solve the Eq(13) The optimal theta = 42
% f_left =@(theta) pi/(9*log(10))*tand(theta) + a*b*A*exp(-b*(theta-a))/power(a*exp(-b*(theta-a))+1,2) ; 
% x = fzero(f_left,10);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
