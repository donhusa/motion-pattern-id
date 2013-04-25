function multiObjectTracking()
% create system objects used for reading video, detecting moving objects,
% and displaying the results
obj = setupSystemObjects();

tracks = initializeTracks(); % create an empty array of tracks

nextId = 1; % ID of the next track

% detect moving objects, and track them across video frames
while ~isDone(obj.reader)
    frame = readFrame(obj);
    [centroids, bboxes, mask] = detectObjects(frame,obj);
    tracks = predictNewLocationsOfTracks(tracks);
    [assignments, unassignedTracks, unassignedDetections] = ...
        detectionToTrackAssignment(tracks,centroids);

    tracks = updateAssignedTracks(assignments,centroids,bboxes,tracks);
    tracks = updateUnassignedTracks(unassignedTracks,tracks);
    tracks = deleteLostTracks(tracks);
    [tracks,nextId] = createNewTracks(unassignedDetections,centroids,bboxes,tracks,nextId);

    displayTrackingResults(frame,mask,tracks,obj);
end