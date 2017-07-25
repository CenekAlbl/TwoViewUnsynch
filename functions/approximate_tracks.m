function tracks = approximate_tracks(times,fps,offset,tracks2)
times2 = frame2time(tracks2(:,1),fps,offset);
for i=1:length(times)
    idxs = find(times2>times(i));
    if(isempty(idxs))
        tracks(:,i) = tracks2(end,2:3)';
    else
        id = idxs(1);
        if(id==1)
            tracks(:,i) = tracks2(1,2:3)';
        else
            interp1 = tracks2(id-1,2:3);
            interp2 = tracks2(id,2:3);
            dt = (times(i)-times2(id-1))/(times2(id)-times2(id-1));
            tracks(:,i) = interp1+dt*(interp2-interp1);
        end
    end
end