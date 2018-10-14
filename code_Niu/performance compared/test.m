function [r,gamma] = test(N_users) 
%N_users = 10;  % the number of users.
u_distance = 100;  %%all the users are distributed in a 100 * 100 square
k_center = 2; %% the number of base stations.
centerpoint = u_distance*rand(k_center,2);
all_users = u_distance*rand(N_users,2);
h=0;
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
G = funcGenerateG(all_users, centerpoint, label, h);
G = G-eye(N_users);
[P_all,Y] = eig(G);
[maxY, index_max] = max(diag(Y));
p = P_all(:,index_max);
if p < 0 ;
    p=-p;
end

 r = db( 1/( maxY  ))/2;
%  plot(N_users,r,'o');hold on;grid on;
p_ave(1:N_users) = sum(p)/N_users;

for i = 1:N_users
    c=G(i,:)*(p_ave.');
    gamma(i)= db(p_ave(i)/(c-p_ave(i)))/2;
end
gamma=min(gamma);
% plot(N_users,gamma,'*');hold on;

end
