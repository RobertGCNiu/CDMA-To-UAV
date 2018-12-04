%%%%%%%%%%%%%
%%% TiTle: UAV position deployment by K-means
%%%%: Author: Niu Guanchong
%%%%: Time: 2017/11/20

clear;
clc;

%%%Parameters



N_users = 30;
P_xyz  = zeros(N_users, 2);
TX_ant = 64;
RX_ant = 16;
height_uav = 10;
range_users = 10; %%%%%The range of users' range
p_x = range_users*(rand(N_users,1)); % randomly distributed in a 10*10 square
p_y = range_users*(rand(N_users,1));
p_z = zeros(N_users, 1);
P_xyz = [p_x, p_y];

Pow_initial = 100; %dB
pow = zeros(N_users, 1);
range_uav = 10;
N_UAV = 2; %%Number of UAVs
P_uav_initial = zeros(N_UAV, 2);
for u_uav = 1:N_UAV
P_uav_initial(u_uav, :) = [range_uav*rand   range_uav*rand];
end
lamda = 20;  %%minimal power for each user.
alpha = 1.5;  % distance gain
beta = 1.8;
distance = zeros(1,30);
% p_one_D = [P_xyz(:,1); P_xyz(:,2)];
% uav_cluster = kmeans(p_one_D,3);
% uav_p = reshape(uav_cluster,N_users, 2);
% plot(uav_p(:,1), uav_p(:,2), 'g*'); hold on
% plot(P_xyz(:,1),P_xyz(:,2), 'r*')
uav_old = P_uav_initial;
uav_new = zeros(N_UAV, 2);
begin = 0;
while norm(uav_new-uav_old,'fro')>0.01
%     P_new_xyz_uav_1 = [];
%     P_new_xyz_uav_2 = [];
%     if begin == 1
%     uav_old = uav_new;
%     end
%     for ue = 1: N_users
%         for u_uav = 1:N_UAV 
%             distance(u_uav, ue) = norm(uav_old(u_uav) - P_xyz(ue, :), 'fro')^2;
%         end
%         if distance(1,ue)<=distance(2,ue)
%             P_new_xyz_uav_1 = [P_new_xyz_uav_1; P_xyz(ue,:)];
%         else 
%             P_new_xyz_uav_2 = [P_new_xyz_uav_2; P_xyz(ue,:)];
%         end
%         begin =1;
%         uav_new(1,:) = mean(P_new_xyz_uav_1.^2);
%         uav_new(2,:) = mean(P_new_xyz_uav_2.^2);
%     end
%     
    
%%%%%%%%%%%%%%%%%%%%%%%%
if begin ==1
         uav_old = uav_new;
end
     for ue = 1:N_users
         for u_uav = 1:N_UAV
             distance(ue, u_uav) = norm(uav_old(u_uav) - P_xyz(ue, :), 'fro')^2;
         end
     end    
     
     P_uav_new_xyz_1 = P_xyz(distance(:, 1)<distance(:, 2), :);
     P_uav_new_xyz_2 = P_xyz(distance(:, 1)>=distance(:, 2), :);
     uav_new = [mean(P_uav_new_xyz_1);  mean(P_uav_new_xyz_2)];
      begin = 1;
end
  hold on;
  box on
plot(P_uav_new_xyz_1(:,1), P_uav_new_xyz_1(:,2), 'r*');
plot(P_uav_new_xyz_2(:,1), P_uav_new_xyz_2(:,2), 'g*');
plot(uav_new(:,1), uav_new(:,2), 'b*');
legend('optimal user group_1', 'optimal user group_2', 'uav location')
    