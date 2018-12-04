%%%%%%%%%%%%%%%%%%%%%%
%=====This code is design to find whether the null space of steering vector
%++++ can be represented by analog format, i.e. exp(j*theta).  
%===========Spirited bythe orthogonality property, we want to select the users whose AoDs
%+++++++ +++++++are in null space and can be represented by analog format.

function [Frf_selected,  H_selected, Wrf_selected]= users_selection_based_on_AoD(H, a_TX, a_RX, users, usersToSupport, Space_have)
%%%%%%%%%%%%%%%%%%%

if nargin<6;
    Space_have = [];
    vector_have = 0; 
else 
    vector_have = size(Space_have, 2);
end
Frf_selected = zeros(size(a_TX,1), usersToSupport);
clear optimal_beam_for_uth_user;
 optimal_beam_for_uth_user = zeros(size(a_TX,1), usersToSupport, users);
 optimal_user_collection = zeros(usersToSupport-vector_have, users);
 %%%%%%%%%%%%%%%
 %begin to find the optimal users(AoDs)
 st= a_TX;

  u_selected = zeros(usersToSupport-vector_have, 1);
 for user =1 : users
     users_selected = [];
        if nargin<6
        users_selected= [users_selected user];
        else
            users_selected = [];
        end
  %%%%%%%%%%%%%%%%%%%%%%%%%
   %========
   %use greedy algorithm
   %=======
   %%Use projectoin operator to detect the distance between null space with steering vector
           % p_u = (u(:, 2:end, user)'*u(:,2:end, user))^(-1)*u(:, 2:end, user)';%%%projector
           % p_u = pinv(u(:, 2:end));
           
          %select_beam_space = zeros(At, 1);
          clear   Frf_selected_all_user;
        %  Frf_selected_all_user = zeros(size(st,1), 1);
          if nargin==6
            for u = 1:vector_have
           Frf_selected_all_user( :, u) = Space_have(:, u);
            end
          else
              Frf_selected_all_user(:,1) = st(:, user);
          end
           
  while length(users_selected)<(usersToSupport-vector_have)

      P_select_beam_space = Frf_selected_all_user* pinv(Frf_selected_all_user);
      %%%%%%%%%%%%%
      %%====search user to find  the minimal projection on seleted space
      for user_search = 1 : users
          if ~ismember(user_search, users_selected)
            p_detect(user_search) =  sum(abs( P_select_beam_space*st(:, user_search)));%% orthogonal distance
          else
              p_detect(user_search) = NaN;
          end
      end
      [~, selected_user] = min(p_detect);
      %%%%%%%%%%%%%%%%%%%%%% end search user
      users_selected = [users_selected selected_user];
      if (length(users_selected)+length(vector_have)) >1
     Frf_selected_all_user = [Frf_selected_all_user  st(:, selected_user)];
      end
   end
  %%%%%%%%%%%%%%%%%%%
        %Store the optimal user for u-th user
        optimal_beam_for_uth_user(:, :, user) = Frf_selected_all_user;
        optimal_user_collection(:,user) =users_selected'; 
        %%%%%%%pick the optimal users
%         optimal_users = [];
 
 end
 
 %%%Now we have all optimal users when we select one user first.
 rate_to_find_optimal_user = zeros( 1, users);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%====here we try to find the optimal set in all the optimal sets for all
%users. This part of code will store all user's rate.
for user_in_users =1: users
    selected_users = optimal_user_collection(:, user_in_users); % find the 4 optimal users for u-th user
    for user = 1:usersToSupport
        interf = [];
        %%%just to define the interf users
        for index = 1:usersToSupport
            if index~=user;
                interf = [interf index];     
            end
        end
        %%%%%%
        signal_u = optimal_beam_for_uth_user(:,user, user_in_users);
        interference_u = optimal_beam_for_uth_user(:, interf, user_in_users);
        rate_to_find_optimal_user(user_in_users) =  rate_to_find_optimal_user(user_in_users)  +log2( 1+norm(signal_u'*signal_u, 'fro')/(norm(signal_u'*interference_u,'fro')+1));       
    end
end

%optimal_index(user_group_index, SNR(snr_index)) = max(interference);

 
 [~ ,optimal_user_for_select] = max(rate_to_find_optimal_user);
 u_selected = optimal_user_collection(:, optimal_user_for_select);
 H_selected = H(u_selected, :,:);
 Frf_selected(:,:) = optimal_beam_for_uth_user(:,:, optimal_user_for_select);
 Wrf_selected = a_RX(:, u_selected);

end  %end for function
