%%%%%%%%%%%Add cell breathing
%The UAV coverage radius is R_m = 100m
%The area is 100*100m
clear;clc;
lengthOfArea =400;
R_m = 100;
n_users = 50;
users_dist = rand(n_users,2) * lengthOfArea; % The coordinate of every user
min_users_inaUAV = 5;
max_users_in_aUAV = 10;
power_Trans = 30;
R_cov_all = 0;
iteration = 10;
rate = zeros(iteration,1);
%plot(users_dist(:,1),users_dist(:,2)3'r*');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%===================Kmeans===========
stop=0;
k_index_old = 0;

%%%%%%% Kmeans tryting
 for k_cluster = 3:40;
     change = 1;
  while change == 1;
    height_all = zeros(k_cluster,1);
    [k_index,k_center] = kmeans(users_dist,k_cluster);
    if k_index == k_index_old
        change = 0;
    end
    k_index_old = k_index;


for k = 1:k_cluster
%plot the original location of each user%
plot(users_dist(k_index==k,1),users_dist(k_index==k,2),'.','MarkerSize',12);hold on
end

%===================================
%%%%%%%%%%%%%%%%%%%
%----------In order to avoid too much overlapped area, I modify Kmeans by
%-----------------selecting the centroid from the middle of farthest users in
%-----------------one cluster
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%=========find the farthest distance in one cluster
max_k_all = [];
k_means_center = [];
rate = [];
users_data=[];
for k_k = 1:k_cluster
    max_all = [];
    users_in_acluster = zeros(length(users_dist(k_index==k_k,:)),2);
    users_in_acluster = users_dist(k_index==k_k,:);
   for user_index = 1:size(users_in_acluster,1)
       [max_dista, max_index]= max((users_in_acluster(user_index,1) - users_in_acluster(:,1)).^2+(users_in_acluster(user_index,2) - users_in_acluster(:,2)).^2);
       max_all = [max_all;[sqrt(max_dista), user_index, max_index]];
   end
       [max_k,max_index]= max(max_all(:,1));      
       max_index_in_acluster = max_all(max_index,2:3);
       coor_center = sum(users_in_acluster(max_index_in_acluster,:),1)/2;
       radiusOfCenter = norm(users_in_acluster(max_index_in_acluster(1),:)-users_in_acluster(max_index_in_acluster(2),:))/2;
       k_means_center = [k_means_center; coor_center radiusOfCenter];%store the locations and radius of each cluster 
end
%---------------------------------The locations of clusters have been fixed----------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%------------------The overlapped area---------------------------------
all_overlap_area = 0;
all_area = 0;
for k = 1:length(k_means_center)-1
        for k_left = k+1:length(k_means_center)
        radius_two_cluster = sqrt(sum((k_means_center(k,1:2)-k_means_center(k_left,1:2)).^2));
            if radius_two_cluster < (k_means_center(k,3)+k_means_center(k_left,3))
                r_1 = k_means_center(k,3); r_2 = k_means_center(k_left,3); D = radius_two_cluster;
                theta_1 = acos((r_1^2+D^2-r_2^2)/(2*r_1*D));
                theta_2 = acos((r_2^2+D^2-r_1^2)/(2*r_2*D));
                overlap_area = theta_1*r_1^2 + theta_2*r_2^2-r_1*D*sin(theta_1);
                all_overlap_area = all_overlap_area+overlap_area;
            end
        end
end
%---------------------------------------------------------------------
%r_distance = zeros(length(users_dist),length(k_means_center));
users_sum = 0;
%%%%%%%%%%%%%%%%%%%%%%
%--------Cell breathing to constrain the number of users. 
users_overlap = 0;
for k = 1:k_cluster
    r_distance = 0;
    users_in_cell = users_dist(k_index==k,:);
    for k_users = 1: size(users_in_cell,1)
        r_distance = norm(users_in_cell(k_users,:)-k_means_center(k,1:2));
       if r_distance>k_means_center(k,3)
          k_means_center(k,3) = r_distance;
       end

    end
end
%--------------cell breathing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%计算所有重叠部分的用户数
     for k = 1:k_cluster
        users_in_cell = users_dist(k_index==k,:);
      for k_users = 1: size(users_in_cell,1)
        for k_cluster_else = 1:k_cluster
            if k_cluster_else~=k && norm(users_in_cell(k_users,:)-k_means_center(k_cluster_else,1:2))<k_means_center(k_cluster_else,3)
                users_overlap = users_overlap+1;
            end
        end
       end
     end

%     if length(users_in_cluster)>= max_users_in_aUAV 
%        [~,dis_label] = sort(r_distance(:,k));
%        k_means_center(k,3) = r_distance(dis_label(max_users_in_aUAV),k);
%     end
   % users_sum = users_sum + sum(r_distance(:,k)<=k_means_center(k,3));

%--------------This function has been closed.
%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----------------------------------------------------------
%Check the constraint of Kmeans. 
%If true, plot the centroids. If not, increase cluster numbers
%R_cov=users_sum/n_users;
all_area = pi*sum(k_means_center(:,3).^2);
  if users_overlap/n_users==0 && sum(k_means_center(:,3)<R_m)==k_cluster 
    stop =1;
    for k_each = 1:k_cluster
        [pathloss, height] = solveForNumuerialReusult(k_means_center(k_each,3));%%Solve the optimal height and pathloss.
        height_all(k_each) = height;
    end
    for k_circle = 1 : k_cluster
         circle(k_means_center(k_circle,1),k_means_center(k_circle,2),k_means_center(k_circle,3));
         plot(k_means_center(k_circle,1),k_means_center(k_circle,2),'*','MarkerSize',16)
            users_final_self = users_dist(k_index==k_circle,:);
            users_final_other = users_dist(k_index~=k_circle,:);
             for k_in_cluster = 1:size(users_final_self,1)
              R =  norm(users_final_self(k_in_cluster,:) - k_means_center(k_circle,1:2)); 
              pl_self = Main_Kmeans_SINR(R,height);
              interf = 0;
              pl_else_collect = [];
                for k_else = 1:size(k_means_center,1) %%%%%Calculate the interference from other centroid
                    if k_else ~= k_circle
                       R_other =  norm(users_final_self(k_in_cluster,:) - k_means_center(k_else,1:2));
                       pl = Main_Kmeans_SINR(R_other,height_all(k_else));
                       interf = interf + 10^((power_Trans - pl)/10); %%%interference
                       pl_else_collect = [pl_else_collect 10pl];
                    end
                end
              signal = power_Trans - pl_self;   %%signal
              inter_dB = 10*log10(interf+10^(-8));
              users_data = [users_data;k_circle pl_self pl_else_collect];
              rate = [rate (signal-inter_dB)];
              text(users_final_self(k_in_cluster,1),users_final_self(k_in_cluster,2)+10,{['(' num2str(signal) ',' num2str(inter_dB) ')' ] ,'\downarrow'},'FontSize',10,'FontWeight','bold');
             end           
    end
    break         
   end
  end %While end

    if stop == 1
            break
    end
 end
%rate(iter) = rate(iter)/k_cluster;

figure;plot(rate,'*')
