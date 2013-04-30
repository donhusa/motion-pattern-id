function tracks = clearHist(tracks)
    for i=1:size(tracks,1)
        tracks(i).xMotion=0;
        tracks(i).yMotion=0;
        %tracks(i).bboxHist;
    end
end