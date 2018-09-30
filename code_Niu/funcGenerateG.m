%% Generate the matrix G
function G = funcGenerateG(all_users, centerpoint, label)
N_users = size(all_users,1);
for u_row = 1:N_users  
    for u_col = 1:N_users
         if norm(all_users(u_col,:)-centerpoint(label(u_row),:))>20
        G(u_row, u_col) = (norm(all_users(u_row,:)-centerpoint(label(u_row),:))^3)/(norm(all_users(u_col,:)-centerpoint(label(u_row),:))^3) ;
        else
            G(u_row,u_col) = (norm(all_users(u_row,:)-centerpoint(label(u_row),:))^3)/(20^3);
        end
    end
end
end
