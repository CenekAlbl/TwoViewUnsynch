% 8pt algorithm to compute F and time shift
% unsynchronized cameras - linear approximation + fundamental matrix


function  [F,u] = F_dt_8pt(xp,x,v)
% input 8x2 vectros x,xp,v

% a*f11, f11, a*f12, f12, a*f13, f13, a*f21, f21, a*f22, f22, a*f23, f23, f31, f32, f33
M = [ v(:,1).*xp(:,1), x(:,1).*xp(:,1), v(:,1).*xp(:,2), x(:,1).*xp(:,2), v(:,1), x(:,1), v(:,2).*xp(:,1), x(:,2).*xp(:,1), v(:,2).*xp(:,2), x(:,2).*xp(:,2), v(:,2), x(:,2), xp(:,1), xp(:,2), ones(size(x,1),1)];
M2 = M(:,[2,4,6,8,10,12,13,14,15,1,3,5,7,9,11]);
n = null(M2);

[a, b, c, d, e, f] = solver_F_unsynchron_a_sturmfels(n(:,1), n(:,2), n(:,3), n(:,4), n(:,5),n(:,6),n(:,7));
F = [];
u = [];
for i = 1:length(a)
    FF = a(i)*n(:,1)+b(i)*n(:,2)+c(i)*n(:,3)+d(i)*n(:,4)+e(i)*n(:,5)+f(i)*n(:,6)+n(:,7);
    
    F{i} = reshape(FF(1:9)', 3,3); 
    
    u(i) = FF(10)/FF(1);
   % uu(i) = FF(11)/FF(2)
end
 
