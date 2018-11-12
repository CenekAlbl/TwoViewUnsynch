function [Htres,dtres,inliers_best,emin] = ransac_Ht(u1,u2,interp_dist,thr,rounds)
% simple 5-point H + time shift RANSAC
inliers_best = [];
emin = Inf; 
H = [];
dtres = [];
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
    sample = randperm(finish-start,5);
    sample = sample + (start-1);
    u1s = u1(:,sample);
    u2s = u2(:,sample);
      
	sample_next = sample+interp_dist;
	v = [u2(1:2,sample_next)'-u2(1:2,sample)'];

    %calculate H
    [H,dt] = H_dt_5pt(u1s',u2s',v);
    if(isempty(H))
       continue 
    end
    %evaluate hypotheses
    for k =1:length(H)
        Hh = H{k};
        dth = dt(k);
        u2dt = u2curr+dth.*vv;
        ejs  = sqrt(sum((h2a(Hh*u1curr)-h2a(u2dt)).^2));        
        inliers = find(ejs<thr);   
        e = sum(ejs(inliers));
        % found better candidate
        if(length(inliers)>length(inliers_best)||(length(inliers)==length(inliers_best)&&e<emin))
            Htres = Hh;
            dtres = dth;
            emin = e;
            inliers_best = inliers+start-1;
        end
    end
end       
end