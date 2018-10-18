%% Author: Niu G.C
%% Data:2018/09/29
%% Objective: minimize the total power for CDMA system
clear; clc;
%% ======Parameters========

ITER = 500;
%ITER = 1;
users_sets = 10:5:30;
%users_sets = 50;
r_N_remove = zeros(length(users_sets),1); % removing algorithm
remove_N = zeros(length(users_sets),1); % the removing number
r_N_move = zeros(length(users_sets),1); % moving algorithm
r_org = zeros(length(users_sets),1); %without any algorithm
h = 50;
for N_users_idex = 1:length(users_sets)  % the number of users.
    N_users = users_sets(N_users_idex);
r_acc_remove = 0;
r_acc_move=0;
remove_all = 0;
r_acc_org = 0;
    for iter = 1:ITER

u_distance = 100;  %%all the users are distributed in a 100 * 100 square
k_center = 4; %% the number of base stations.
centerpoint = u_distance*rand(k_center,2);
all_users = u_distance*rand(N_users,2);
%  plot(all_users(:,1), all_users(:,2),'*'); hold on
%  plot(centerpoint(:,1), centerpoint(:,2),'o','MarkerSize',12)
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
%     plot([all_users(u,1); centerpoint(N_belong,1)], [all_users(u,2), centerpoint(N_belong,2)])
end
%%
%------the matrix G = [D_11 D_12 бнбн D_1,N_users; D_21 D_22 бнбн D_2,N_users;бнбн]
G = funcGenerateG(all_users, centerpoint, label,h);
%%
%----find positive eigen value(r) and eigenvector(p). 
    [p,r] = funcSINRandPower(G);
    r_acc_org = r_acc_org + db(r)/2/ITER;
    %%
%----removing the user with maximal interference until the SIR satisfies
%---------the threshhold
    remove_user = 0;
    r_remove = r;
    p_remove = p;
    G_remove = G;
    while db(r_remove)/2<-10
        remove_user = remove_user +1;
        interference_all = G_remove*p_remove;
        [~,max_index_interf] = max(interference_all);
        G_remove(max_index_interf,:) = [];
        G_remove(:,max_index_interf) = [];
        [p_remove,r_remove] = funcSINRandPower(G_remove);
    end
        r_acc_remove = r_acc_remove+db(r_remove)/2/ITER;  % transfer Ratio to dB.
        remove_all = remove_all + remove_user/ITER;
        
    %%
 %---------moving the user with maximal interference and calculate the new
 %SIR to check if it satisfies the threshold
    move_user = 0;
    r_move = r;
    p_move = p;
    flag = 0;
    G_move= G;
    t=0;
    while db(r_move)/2<-10
        t=t+1;
        r_move_old = r_move;
        move_user = move_user+1;
        interference_all = G_move*p_move;
         [~,max_index_interf] = max(interference_all);
         r_collect = zeros(k_center,1);
         for N_center = 1:k_center
                label(max_index_interf) = N_center;
                G_move = funcGenerateG(all_users, centerpoint, label,h);
                [p_move,r_move] = funcSINRandPower(G_move);
                r_collect(N_center) = r_move;
                if db(r_move)/2>-10
                    flag = 1;
                    break
                end
         end
         if max(r_collect) ==r_move_old || t>100
             r_move = max(r_collect);
             %disp('Cannot find the satisfied grouping method');
             break;
         end
    end
        r_acc_move = r_acc_move+db(r_move)/2/ITER;  % transfer Ratio to dB.
        
    end
    r_N_remove(N_users_idex) = r_acc_remove;
    remove_N(N_users_idex) = remove_all;
    r_N_move(N_users_idex) = r_acc_move;
    r_org(N_users_idex) = r_acc_org;
end

hold on;
plot(users_sets,r_N_remove,'LineWidth',1.5);
plot(users_sets, r_N_move,'LineWidth',1.5); 
plot(users_sets, r_org,'LineWidth',1.5)
legend('removing', 'moving', 'original');
 title(' Distance Based Power Control Algorithm');
 xlabel('Number of Users');
 ylabel('SIR');
   
%%