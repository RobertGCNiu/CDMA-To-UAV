%% Author: Niu G.C
%% Data:2018/09/29
%% Objective: minimize the total power for CDMA system
clear; clc;
%% ======Parameters========
N_users = 10;  % the number of users.
u_distance = 100;  %%all the users are distributed in a 100 * 100 square
k_center = 2; %% the number of base stations.
centerpoint = u_distance*rand(k_center,2);
all_users = u_distance*rand(N_users,2);
% plot(all_users(:,1), all_users(:,2),'*'); hold on
% plot(centerpoint(:,1), centerpoint(:,2),'o','MarkerSize',12)
%% grouping the users to centerpoints
label = zeros(N_users,1);
dist_all = zeros(N_users,1);
for u = 1:N_users
    dist_u = zeros(k_center,1);
    for N =  1:k_center
            dist_u(N) = norm(all_users(u,:) - centerpoint(N,:));
    end
    [N_dist, N_belong] = min(dist_u);
    label(u) =  N_belong;
    dist_all(u) = N_dist;
    %plot([all_users(u,1); centerpoint(N_belong,1)], [all_users(u,2), centerpoint(N_belong,2)])
end
%%
%------the matrix G = [D_11 D_12 ���� D_1,N_users; D_21 D_22 ���� D_2,N_users;����]
for u_row = 1:N_users  
    for u_col = 1:N_users
%         if norm(all_users(u_col,:)-centerpoint(label(u_row),:))>20
        G(u_row, u_col) = (norm(all_users(u_row,:)-centerpoint(label(u_row),:))^3)/(norm(all_users(u_col,:)-centerpoint(label(u_row),:))^3) ;
%         else
%             G(u_row,u_col) = (norm(all_users(u_row,:)-centerpoint(label(u_row),:))^3)/(20^3);
%         end
    end
end

% diag_G = diag(G);
% for t = 1:length(diag_G)
%     G(:,t) = G(:,t) *diag_G(t)^(-1);
% end
G = G-eye(N_users);
[P_all,Y] = eig(G);
[maxY, index_max] = max(diag(Y));
p = P_all(:,index_max);
r = 1/(max(diag(maxY)));
if p(1)<0
p = -1*p;
end

%%