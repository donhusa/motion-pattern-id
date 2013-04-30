function multiObjectTracking()

debug=false;
[vid,detect,blob,colorVid,maskVid] = setupSystemObjects(debug);
tracks = initializeTracks(); % create an empty array of tracks
nextId = 1; % ID of the next track
iter=0;
input_socket=[];
person='';

% detect moving objects, and track them across video frames
try
    start(vid);
    
    while islogging(vid);
        iter=iter+1;
        frame = getdata(vid,1);
        flushdata(vid);
        if mod(iter,5)==0
            [person, phoneData, input_socket]=client('10.190.50.175',57193,input_socket,person);
            if ~isempty(phoneData)
                phoneData=str2num(phoneData);
                figure(4);
                plot(phoneData);
                axis([0 280 -1.5 1.5]);
                if ~isempty(tracks)
                    tracks = correlateMotion(person, phoneData,tracks);
                    tracks = clearHist(tracks);
                end
            end

            %if message not empty, signal process
        end
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
    stop(vid); 
    imaqreset
    if ~isempty(input_socket)
        input_socket.close;
    end
    rethrow(err);
end
