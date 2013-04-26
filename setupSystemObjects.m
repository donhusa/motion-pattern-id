function [vid,detect,blob] = setupSystemObjects()

        imaqreset
        vid = videoinput('macvideo', 1, 'YCbCr422_640x480');
        vid.ReturnedColorspace = 'rgb';

        % Create system objects for foreground detection and blob analysis

        % The foreground detector is used to segment moving objects from
        % the background. It outputs a binary mask, where the pixel value
        % of 1 corresponds to the foreground and the value of 0 corresponds
        % to the background.

        %lower variance = more foreground
        detect=vision.ForegroundDetector('NumGaussians', 3, ...
            'NumTrainingFrames', 100, 'MinimumBackgroundRatio', 0.7,'InitialVariance', 20);
%         vid.detector = vision.ForegroundDetector('NumGaussians', 3, ...
%             'NumTrainingFrames', 40, 'MinimumBackgroundRatio', 0.7);

        % Connected groups of foreground pixels are likely to correspond to moving
        % objects.  The blob analysis system object is used to find such groups
        % (called 'blobs' or 'connected components'), and compute their
        % characteristics, such as area, centroid, and the bounding box.

        blob= vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
            'AreaOutputPort', true, 'CentroidOutputPort', true, ...
            'MinimumBlobArea', 400);
%         vid.blobAnalyser = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
%             'AreaOutputPort', true, 'CentroidOutputPort', true, ...
%             'MinimumBlobArea', 400);
    end