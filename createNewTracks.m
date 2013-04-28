function [tracks,nextId] = createNewTracks(unassignedDetections,centroids,bboxes,tracks,nextId)
        centroids = centroids(unassignedDetections, :);
        bboxes = bboxes(unassignedDetections, :);

        for i = 1:size(centroids, 1)

            centroid = centroids(i,:);
            bbox = bboxes(i, :);

            % create a Kalman filter object
            kalmanFilter = configureKalmanFilter('ConstantVelocity', ...
                centroid, [200, 50], [100, 25], 100);

            % create a new track
            newTrack = struct(...
                'id', nextId, ...
                'bbox', bbox, ...
                'bboxHist', bbox, ...
                'kalmanFilter', kalmanFilter, ...
                'age', 1, ...
                'totalVisibleCount', 1, ...
                'consecutiveInvisibleCount', 0);

            % add it to the array of tracks
            tracks(end + 1) = newTrack;

            % increment the next id
            nextId = nextId + 1;
        end
    end