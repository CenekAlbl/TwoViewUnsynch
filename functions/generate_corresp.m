function corresp = generate_corresp(tracks,fps1,fps2,offset1,offset2)
u1 = [];
u2 = [];
for i=1:length(tracks{1})
    track1 = tracks{1}{i};
    track2 = tracks{2}{i};
    times1 = frame2time(track1(:,1),fps1,offset1);
    u2 = [u2 approximate_tracks(times1,fps2,offset2,track2)];
    u1 = [u1 track1(:,2:3)'];
end
corresp{1} = u1;
corresp{2} = u2;