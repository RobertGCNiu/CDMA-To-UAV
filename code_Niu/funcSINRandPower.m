%% SNR by eigenvalue decomposition
function [p,r] = funcSINRandPower(G) 
N_users = size(G,1);
G = G-eye(N_users);
[P_all,Y] = eig(G);
[maxY, index_max] = max(diag(Y));
p = P_all(:,index_max);
r = 1/(max(diag(maxY)));
    if p(1)<0
        p = -1*p;
    end
end

