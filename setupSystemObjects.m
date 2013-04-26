function [vid,detect,blob,colorVid,maskVid] = setupSystemObjects(debug)
        if ~debug
            imaqreset
            vid = videoinput('macvideo', 1, 'YCbCr422_640x480');
            vid.ReturnedColorspace = 'rgb';

            figure(1);
            colorVid = imshow(zeros(480,640));
            hold on;

            figure(2);
            maskVid = imshow(zeros(480,640));
            set(vid,'framesperTrigger',10,'TriggerRepeat',Inf);
        
        else 
            vid.reader = vision.VideoFileReader('atrium.avi');
            vid.videoPlayer = vision.VideoPlayer('Position', [20, 400, 700, 400]);
            vid.maskPlayer = vision.VideoPlayer('Position', [740, 400, 700, 400]);
            colorVid=1;
            maskVid=1;
        end
        % Create system objects for foreground detection and blob analysis

        % The foreground detector is used to segment moving objects from
        % the background. It outputs a binary mask, where the pixel value
        % of 1 corresponds to the foreground and the value of 0 corresponds
        % to the background.

        %lower variance = more foreground
        detect=vision.ForegroundDetector('NumGaussians', 3, ...
            'NumTrainingFrames', 100, 'MinimumBackgroundRatio', 0.7);
        if ~debug
            detect.InitialVariance=20;
        end
        % Connected groups of foreground pixels are likely to correspond to moving
        % objects.  The blob analysis system object is used to find such groups
        % (called 'blobs' or 'connected components'), and compute their
        % characteristics, such as area, centroid, and the bounding box.

        blob= vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
            'AreaOutputPort', true, 'CentroidOutputPort', true, ...
            'MinimumBlobArea', 400);
    end