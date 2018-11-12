function [H,dt] = H_dt_5pt(x1,x2,v)
% solves (x2(i,:)+dt*v(i,:))'=H*x1(i,:)'
% x1- nx2 or nx3 with 3rd coordinate = 1
% x2- nx2 or nx3 with 3rd coordinate = 1
% v- nx2 or nx3 with 3rd coordinate = 0
dt = [];
H = [];

% 4.5 point
n= size(x1,1);
k = [1:5];
temp = [zeros(n,3) -x1(:,1) -x1(:,2) -ones(n,1) x2(:,2).*x1(:,1) x2(:,2).*x1(:,2) x2(:,2) v(:,2).*x1(:,1) v(:,2).*x1(:,2) v(:,2);
    x1(k,1) x1(k,2) ones(length(k),1) zeros(length(k),3) -x2(k,1).*x1(k,1) -x2(k,1).*x1(k,2) -x2(k,1) -v(k,1).*x1(k,1) -v(k,1).*x1(k,2) -v(k,1);
    ];

[U,D,V] = svd(temp);
n = V(:,10:end);

%[dt, a, b] = solver_H_unsynchron_dt(n(:,1), n(:,2), n(:,3));
[dt, a, b] = solver_H_unsynchron_dt_2(n);


for i = 1:size(a,1)
    H{i} = reshape((a(i)*n(1:9,1)+b(i)*n(1:9,2)+n(1:9,3)),3,3)';
end

test = 0;
if test
for i = 1:size(a,1)
    for j =1:5
    l = [x2(j,1:2),1]'+dt(i)*[v(j,1:2),0]';
    r = H{i}*[x1(j,1:2),1]';
    r = r./r(3);
    err = l-r
    end
end
end
end

