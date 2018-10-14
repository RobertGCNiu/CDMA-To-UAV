iterations=1;
while(iterations<=500)
for i = 1:21
    N_users(1)=10;
    [r(i),gamma(i)]=test(N_users(i));
  
    N_users(i+1)=N_users(i)+5;
    r(iterations,i) = r(i);
    gamma(iterations,i)=gamma(i);
end


iterations=iterations+1;
end
for i=1:21
    a(i)=sum(r(:,i))/500;
    b(i)=sum(gamma(:,i))/500;
end
N_users(end)=[];
plot(N_users,a,'r',N_users,b,'b');hold on;
legend('with PCA','without PCA');
title('Performance in CDMA Cellular System ');
 xlabel('Number of mobiles in cell');
 ylabel('SIR');