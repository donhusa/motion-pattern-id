function multiObjectTracking()

[vid,detect,blob] = setupSystemObjects();
tracks = initializeTracks(); % create an empty array of tracks
nextId = 1; % ID of the next track

% detect moving objects, and track them across video frames
try
    set(vid,'framesperTrigger',10,'TriggerRepeat',Inf);
    start(vid);
    
    figure(1);
    colorVid = imshow(zeros(480,640));
    hold on;

    figure(2);
    maskVid = imshow(zeros(480,640));
    
    while islogging(vid);
        frame = getdata(vid,1);
        flushdata(vid);
        
        
        [centroids, bboxes, mask, detect, blob] = detectObjects(frame,detect,blob);
        tracks = predictNewLocationsOfTracks(tracks);
        [assignments, unassignedTracks, unassignedDetections] = ...
            detectionToTrackAssignment(tracks,centroids);

        tracks = updateAssignedTracks(assignments,centroids,bboxes,tracks);
        tracks = updateUnassignedTracks(unassignedTracks,tracks);
        tracks = deleteLostTracks(tracks);
        [tracks,nextId] = createNewTracks(unassignedDetections,centroids,bboxes,tracks,nextId);

        displayTrackingResults(frame,mask,tracks,colorVid,maskVid);        
        drawnow;        
    end
catch err
    stop(vid); 
    imaqreset
    
    rethrow(err);
end
