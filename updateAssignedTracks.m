function tracks = updateAssignedTracks(assignments,centroids,bboxes,tracks)
        numAssignedTracks = size(assignments, 1);
        
        largeInd=0;
        maxLen=0;
        
        for i = 1:numAssignedTracks
            trackIdx = assignments(i, 1);
            detectionIdx = assignments(i, 2);
            centroid = centroids(detectionIdx, :);
            bbox = bboxes(detectionIdx, :);

            % correct the estimate of the object's location
            % using the new detection
            correct(tracks(trackIdx).kalmanFilter, centroid);

            % replace predicted bounding box with detected
            % bounding box
            tracks(trackIdx).bbox = bbox;

            %right?????
            tracks(trackIdx).bboxHist(end+1,:) = bbox;

            siz=size(tracks(trackIdx).bboxHist);
            if siz>maxLen
                largeInd=trackIdx;
            end
            
            [oldCentX,oldCentY]=findCentroid(tracks(trackIdx).bboxHist(end-1,:));
            [newCentX,newCentY]=findCentroid(tracks(trackIdx).bboxHist(end,:));
            
            %displacement doesn't care about direction, thus abs
            tracks(trackIdx).xMotion(end+1)=abs(newCentX-oldCentX);
            tracks(trackIdx).yMotion(end+1)=abs(newCentY-oldCentY);
            
            
            
            tracks(trackIdx).time(end+1)=now;
            
            t=(now-tracks(trackIdx).time(end-1))/10^(-5);
            %fprintf('time %d\n',t);
            
            
            
            % update track's age
            tracks(trackIdx).age = tracks(trackIdx).age + 1;

            % update visibility
            tracks(trackIdx).totalVisibleCount = ...
                tracks(trackIdx).totalVisibleCount + 1;
            tracks(trackIdx).consecutiveInvisibleCount = 0;
        end
        
        if largeInd>0
            boxes=tracks(largeInd).bboxHist;
            x=boxes(:,1);
            y=boxes(:,2);
            figure(3);
            plot(x,y);
            str=sprintf('Number %d',tracks(largeInd).id);
            title(str);
            axis([0 640 0 480]);
            
            
            figure(5);
            x=tracks(largeInd).xMotion;
            y=tracks(largeInd).yMotion;
            plot(x);
            axis([0 12 0 150]);
        end
        
    end