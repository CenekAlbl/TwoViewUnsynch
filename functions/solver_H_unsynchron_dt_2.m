% GB solver to H_unsynchronized_dt problem

function [dt, a, b] = solver_H_unsynchron_dt_2(n)

	% precalculate polynomial equations coefficients
	M = [ n(7,2) n(7,1) n(7,3) -n(10,2) -n(10,1) -n(10,3);
      n(8,2) n(8,1) n(8,3) -n(11,2) -n(11,1) -n(11,3);
      n(9,2) n(9,1) n(9,3) -n(12,2) -n(12,1) -n(12,3)];
    M = M(1:3,1:3)\M(:,4:6);

	A = zeros(3);
	amcols = [3 2 1];
	A(1, :) = -M(3, amcols);
	A(2, :) = -M(2, amcols);
	A(3, :) = -M(1, amcols);
    
    if (find(isnan(A)) > 0)
		
		dt = zeros(1, 0);
		a = zeros(1, 0);
		b = zeros(1, 0);
	else

        [V D] = eig(A);
        sol =  V([3, 2],:)./(ones(2, 1)*V(1,:));

        if (find(isnan(sol(:))) > 0)

            dt = zeros(1, 0);
            a = zeros(1, 0);
            b = zeros(1, 0);
        else

            ev  = diag(D);
            I = find(not(imag( sol(1,:) )) & not(imag( ev' )));
            dt = ev(I);
            a = sol(2,I)';
            b = sol(1,I)';
        end
    end
end
