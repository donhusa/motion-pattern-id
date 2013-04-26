function multiObjectTrackingDebug()

debug=true;
[vid,detect,blob,colorVid,maskVid] = setupSystemObjects(debug);
tracks = initializeTracks(); % create an empty array of tracks
nextId = 1; % ID of the next track

% detect moving objects, and track them across video frames
try  
    while ~isDone(vid.reader)
        frame = vid.reader.step();

        [centroids, bboxes, mask, detect, blob] = detectObjects(frame,detect,blob);
        tracks = predictNewLocationsOfTracks(tracks);
        [assignments, unassignedTracks, unassignedDetections] = ...
            detectionToTrackAssignment(tracks,centroids);

        tracks = updateAssignedTracks(assignments,centroids,bboxes,tracks);
        tracks = updateUnassignedTracks(unassignedTracks,tracks);
        tracks = deleteLostTracks(tracks);
        [tracks,nextId] = createNewTracks(unassignedDetections,centroids,bboxes,tracks,nextId);

        displayTrackingResults(frame,mask,tracks,vid,colorVid,maskVid,debug);        
        drawnow;

    end
    
catch err
    rethrow(err);
end
