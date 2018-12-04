%
% Program to optimize UAV resource allocation
%
% Written by Simon Pun (SimonPun@cuhk.edu.cn)
% Last update on April 13, 2018
%
close all;
clear all;
addpath(genpath(['./']));

%%
load system;
% AreaLength = 400;
% Users.totNum = 50;
% Users.Loc=AreaLength*rand(Users.totNum,2);
Users.UAVIndexAssigned=zeros(Users.totNum,1);
Users.SigPow=zeros(Users.totNum,1);
Users.InterfPow=zeros(Users.totNum,1);
Users.SINR=zeros(Users.totNum,1);
        
% plot figure
plot(Users.Loc(:,1),Users.Loc(:,2),'*');
set(gca,'XTick',[0:50:AreaLength],'YTick',[0:50:AreaLength]);
axis square; grid on;
hold on;
%%
%
% define system requirements
%
% min. SINR required for each user
minSINR.dB=3;

% UAV Max. TX power
maxPtx.dBm=10;
% maxPtx.real=10^(maxPtx.dBm/10);

% User Min. RX power
minPrx.dBm=-90;
% minPrx.real=10^(minPrx.dBm/10);

% Find the max. radius and the corresponding height
% for the max. PL allowed
maxPathLossAllowed.dB=maxPtx.dBm-minPrx.dBm;
maxUAVHeight=100;
[Rmax,optUAVHeight] = FindMaxR(maxPathLossAllowed.dB,maxUAVHeight);

% Cluster Search
% Grid search step size in X and Y
GridSearch.x=5;
GridSearch.y=5;
GridSearch.numCol=length(0:GridSearch.x:AreaLength-GridSearch.x);
GridSearch.numRow=length(0:GridSearch.y:AreaLength-GridSearch.y);

% Max.iterations
maxIterations=20;

% record deployed UAV info.
DeployedUAV.totNum=0;

% Remaining User Index; Program stops when all users are UAVIndexAssigned
IndexRemainingUsers=[1:Users.totNum]';
Iteration=1;

%%
while ~isempty(IndexRemainingUsers) && Iteration< maxIterations;    
    maxNumNewUserCovered=0;
    IndexAssignedUsers=find(Users.UAVIndexAssigned);

    for ii=1:GridSearch.numCol
        for jj=1:GridSearch.numRow
            %
            % find the number of users within the current UAV circle
            %
            % current center under test
            currGridCenter.Loc=[(ii-1)*GridSearch.x+0.5*GridSearch.x ...
            (jj-1)*GridSearch.y+0.5*GridSearch.y];

            % Compute signal power
            % compute the distance of each remainng user to the current center
            currGridCenter.Dist=sqrt((Users.Loc(IndexRemainingUsers,1)-currGridCenter.Loc(1)).^2+...
                (Users.Loc(IndexRemainingUsers,2)-currGridCenter.Loc(2)).^2);
            % note this user index is indexing on vector "IndexRemainingUsers"
            % not the actual user index vector
            currGridCenter.UserIndex=find(currGridCenter.Dist < Rmax);
            currGridCenter.NumUsers=length(currGridCenter.UserIndex);
            
            if currGridCenter.NumUsers
                % if at least one remaining user is covered, evaluate SINR
                % otherwise, move onto the next grid center 
                    
                % Compute Signal Power
                currGridCenter.SigPow=maxPtx.dBm - PathLossA2G(currGridCenter.Dist(currGridCenter.UserIndex),optUAVHeight);

                % Compute interference
                % compute the distance of each remaining user to the deployed centers
                InterPowerdB=[];
                if DeployedUAV.totNum
                    currGridCenter.InterPowerdB=zeros(DeployedUAV.totNum,length(currGridCenter.UserIndex));
                    currGridCenter.UserLoc=Users.Loc(IndexRemainingUsers(currGridCenter.UserIndex),:);
                
                    for kk=1:DeployedUAV.totNum
                        % interfernece from each deployed UAV
                        currInterfDist=sqrt((currGridCenter.UserLoc(:,1)-DeployedUAV.Loc(kk,1)).^2+...
                            (currGridCenter.UserLoc(:,2)-DeployedUAV.Loc(kk,2)).^2);
                        InterPowerdB(kk,:)=maxPtx.dBm-PathLossA2G(currInterfDist,optUAVHeight);
                    end
                end
                % sum interference power from all interferring UAV's
                % (in the same column) for all users (across columns)
                % Note: currGridCenter.InterfPow is a column vector
                currGridCenter.InterfPow=sumPowerdB(InterPowerdB);

                % Compute the corresponding SINR
                currGridCenter.UserSINR=currGridCenter.SigPow-currGridCenter.InterfPow;
                    
                if (~sum(currGridCenter.UserSINR < minSINR.dB))
                    if (length(IndexAssignedUsers)>0)
                        % check if the new grid center interfers already assigned users
                        currInterfDist=sqrt((Users.Loc(IndexAssignedUsers,1)-currGridCenter.Loc(1)).^2+...
                            (Users.Loc(IndexAssignedUsers,2)-currGridCenter.Loc(2)).^2);
                        currGridCenter.LeakagePow=maxPtx.dBm-PathLossA2G(currInterfDist,optUAVHeight);
                        currGridCenter.totInterfAssignedUsers=sumPowerdB([currGridCenter.LeakagePow';  Users.InterfPow(IndexAssignedUsers)']);
                        currGridCenter.SINRAssignedUsers=Users.SigPow(IndexAssignedUsers)-currGridCenter.totInterfAssignedUsers;
                    end
                    
                    if (~length(IndexAssignedUsers) || ~sum(currGridCenter.SINRAssignedUsers < minSINR.dB))
                        % the addition of the new UAV at the current grid
                        % center will not voliate the min. SINR requirements
                        % for already assigned users
                        if maxNumNewUserCovered < currGridCenter.NumUsers
                            maxNumNewUserCovered=currGridCenter.NumUsers;
                            tempBstGridCenter=currGridCenter;
                        end
                    end % end if
                end % end if
            end % end if 
        end % end jj
    end % end ii
    
    %
    % find the grid center with the max. number of new users covered
    % and add to the DeployedUAV
    %
    if maxNumNewUserCovered > 0
        % update UAV
        DeployedUAV.totNum=DeployedUAV.totNum+1;
        DeployedUAV.Loc(DeployedUAV.totNum,:)=tempBstGridCenter.Loc;
        DeployedUAV.UserIndex(DeployedUAV.totNum)={IndexRemainingUsers(tempBstGridCenter.UserIndex)};
        DeployedUAV.UserSINR(DeployedUAV.totNum)={tempBstGridCenter.UserSINR};
        DeployedUAV.R(DeployedUAV.totNum,1)=Rmax;
        DeployedUAV.TxPow(DeployedUAV.totNum,1)=maxPtx.dBm;
         
        % update Users
        % Existing users: update interference power for existing users due to the new UAV
        if ~isempty(IndexAssignedUsers)
            Users.InterfPow(IndexAssignedUsers)=tempBstGridCenter.totInterfAssignedUsers; 
            Users.SINR(IndexAssignedUsers)=Users.SigPow(IndexAssignedUsers)-tempBstGridCenter.totInterfAssignedUsers; 
        end
        
        % New users associated with the new UAV
        IndexNewUsers=cell2mat(DeployedUAV.UserIndex(DeployedUAV.totNum));
        Users.UAVIndexAssigned(IndexNewUsers)=DeployedUAV.totNum;
        Users.SigPow(IndexNewUsers)=tempBstGridCenter.SigPow;
        Users.InterfPow(IndexNewUsers)=tempBstGridCenter.InterfPow;
        Users.SINR(IndexNewUsers)=tempBstGridCenter.SigPow-tempBstGridCenter.InterfPow;
        
        % update remaining user list
        IndexRemainingUsers=find(~Users.UAVIndexAssigned);

        % plot the newly added circle and users
        circle(DeployedUAV.Loc(DeployedUAV.totNum,1),DeployedUAV.Loc(DeployedUAV.totNum,2),Rmax);
        hold on;
        NewlyAddedUserLoc=Users.Loc(cell2mat(DeployedUAV.UserIndex(DeployedUAV.totNum)),:);
        plot(NewlyAddedUserLoc(:,1),NewlyAddedUserLoc(:,2),'rs');
        text(DeployedUAV.Loc(DeployedUAV.totNum,1),DeployedUAV.Loc(DeployedUAV.totNum,2),num2str(DeployedUAV.totNum));
        axis([0 400 0 400]);
        pause;
    else
        % shrink the cell radius to cover the remaining users
        maxPtx.dBm=maxPtx.dBm-3;
        maxPathLossAllowed.dB=maxPtx.dBm-minPrx.dBm;
        [Rmax,optUAVHeight] = FindMaxR(maxPathLossAllowed.dB,maxUAVHeight);
    end
    Iteration=Iteration+1;
end
hold off;