function x=dist_nor(k)
p1=normcdf(0,0,1);
p2=normcdf(1,0,1);
A=p1+(p2-p1)*rand(k,1);
x=100*norminv(A,0,1);

end


