clear;clc
t = rand(8);
[p, Y] = eig(t);
[~, index] = max(diag(Y));
p(:,index)
Y(index,index)