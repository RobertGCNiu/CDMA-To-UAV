clear;clc;
N_users = 30;

height_uav = 10:5:50;
range_users_uav = 50;
p_x = range_users_uav*(rand(N_users,1)); % randomly distributed in a 10*10 square
p_y = range_users_uav*(rand(N_users,1));
p_z = zeros(N_users, 1);
P_xyz = [p_x, p_y, p_z];
%plot(p_x, p_y,'bx');hold on
%%%%%%%%%%%%%%%%%%%%%%%
%=========Parameters in the system
f_c = 28*10^6;
 c = 3*10^8;
% a = 4.88;
% b = 0.43;
% ita_LoS = 0.1;
% ita_NLoS = 21;
% a = 9.61;b=0.16; ita_LoS = 1;ita_NLoS = 20;
a = 12.08;b=0.11; ita_LoS = 1.6;ita_NLoS = 23;
lamda = 35;
Pro = zeros(500, 500, 500);
L_1 = zeros(500, 500, 500);
%C_addi = 20*log10(4*pi*f_c/c)+0.95*ita_LoS + 0.05*ita_NLoS;
u1=[1,1];u2=[20,20];
for h = 10:10:500
    for x = 10:10:500
        for y = 10:10:500
            r_1 = real(sqrt((x-u1(1))^2+(y-u1(2)^2)));
            r_2 = real(sqrt((x-u2(1))^2+(y-u2(2)^2)));
            
            for r_i = [r_1, r_2]               
            Pro(h/10,x/10,y/10) = Pro(h/10,x/10,y/10) + 1/(1+a*exp(-b*(atand((h)/(r_i))-a)));
            L_1(h/10,x/10,y/10) = L_1(h/10,x/10,y/10) + 20*log10(4*pi*f_c/c) + 20*log10(norm((r_i)+h))...
                 + Pro(h/10,x/10,y/10)*ita_LoS + (1-Pro(h/10,x/10,y/10))*ita_NLoS;
             range_U(h/10,x/10,y/10) = r_1;
%         Pro(h,r_i) = 1/(1+a*exp(-b*(atand((h)/(r_i))-a)));
%         L_1(h,r_i) = 20*log10(4*pi*f_c/c) + 20*log10(norm((r_i)+h))...
%                  + Pro(h, r_i)*ita_LoS + (1-Pro(h,r_i))*ita_NLoS;
            end           
        end
    end
   
end

