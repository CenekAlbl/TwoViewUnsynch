function tracks = load_tracks(filename)

fid = fopen(filename,'r');
id = 1;
tracks{1} = [];
tracks{2} = [];
while(~feof(fid))
    ntracks1 = fscanf(fid,'%d',1);
    if(isempty(ntracks1))
        break;
    end
    tracks1 = fscanf(fid,'%d %f %f',[3 ntracks1]);
    tracks{1}{id} = tracks1';
    ntracks2 = fscanf(fid,'%d',1);
    tracks2 = fscanf(fid,'%d %f %f',[3 ntracks2]);
    tracks{2}{id} = tracks2';
    id = id+1;
end
fclose(fid);
