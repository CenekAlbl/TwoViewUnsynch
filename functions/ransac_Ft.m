function [Ftres,dtres,inliers_best,emin] = ransac_Ft(u1,u2,interp_dist,thr,rounds,algorithm,error_function)
% simple 8-point F + time shift RANSAC
inliers_best = [];
emin = Inf; 
Ftres = [];
dtres = [];
if(nargin<7)
   error_function = 'epipolar_distance'; 
end
switch(error_function)
    case 'epipolar_distance'
        err_fcn = @symmetric_epipolar_distance;
    case 'sampson_distance'
        err_fcn = @sampson_distance;
    otherwise
        err_fcn = @symmetric_epipolar_distance;
end

if(nargin<6)
	algorithm = '8pt';
end
if(strcmp(algorithm,'8pt'))
    fn = @(u2,u1,v)F_dt_8pt(u2,u1,v);
    nsamples = 8;
else
    fn = @(u2,u1,v)F_dt_9pt(u2,u1,v,1);
    nsamples = 9;
end

% reserve enough samples for interpolation
if(interp_dist>0)
    start = 1;
    finish = size(u1,2)-interp_dist;
    u2next = u2(:,1+interp_dist:end);
    u2curr = u2(:,1:end-interp_dist);
    u1curr = u1(:,1:end-interp_dist);
else
    start = -interp_dist+1;
    finish = size(u1,2);
    u2curr = u2(:,-interp_dist+1:end);
    u2next = u2(:,1:end+interp_dist);
    u1curr = u1(:,-interp_dist+1:end);
end
% direction vectors for interpolation
vv = u2next-u2curr;
for i=1:rounds
    %sample points
    sample = randperm(finish-start,nsamples);
    sample = sample + (start-1);
    u1s = u1(:,sample);
    u2s = u2(:,sample);
    
	sample_next = sample+interp_dist;
	v =u2(1:2,sample_next)'-u2(1:2,sample)';
    
    %calculate F
    [F,dt] = fn(u1s',u2s',v);
    if(isempty(F))
       continue 
    end
    %evaluate hypotheses
    for k =1:length(F)
        Fh = F{k};
        dth = dt(k);
        u2dt = u2curr+dth.*vv;
        ejs  = abs(err_fcn(u1curr,u2dt,Fh'));        
        inliers = find(ejs<thr);   
        e = sum(ejs(inliers));
        % found better candidate
        if(length(inliers)>length(inliers_best)||(length(inliers)==length(inliers_best)&&e<emin))
            Ftres = Fh';
            dtres = dth;
            emin = e;
            inliers_best = inliers+start-1;
        end
    end
end       
end