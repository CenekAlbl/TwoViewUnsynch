function tracks = filter_static_tracks(tracks,thr)
for i=1:length(tracks{1})
   track1 = tracks{1}{i};
   track2 = tracks{2}{i};
   std1 = std(track1(:,2:3));
   std2 = std(track2(:,2:3));
   if(sum(std1)<thr||sum(std2)<thr)
      tracks{1}{i} = [];
      tracks{2}{i} = [];
   end
end