%% Generate the matrix G
function G = funcGenerateG(all_users, centerpoint, label, h)
N_users = size(all_users,1);
G = zeros(N_users,N_users);
for u_row = 1:N_users  
    for u_col = 1:N_users
%          if norm(all_users(u_col,:)-centerpoint(label(u_row),:))>20
            R_deno = norm(all_users(u_row,:)-centerpoint(label(u_row),:));
            R_nume = norm(all_users(u_col,:)-centerpoint(label(u_row),:));
            G(u_row, u_col) = pathloss3D(R_deno, h)/pathloss3D(R_nume, h);
            %G(u_row, u_col) = (norm(all_users(u_row,:)-centerpoint(label(u_row),:))^3)/(norm(all_users(u_col,:)-centerpoint(label(u_row),:))^3) ;
%         else
%             G(u_row,u_col) = (norm(all_users(u_row,:)-centerpoint(label(u_row),:))^3)/(20^3);
%        end
    end
end

end

