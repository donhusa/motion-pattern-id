function [centroids, bboxes, mask,detect,blob] = detectObjects(frame,detect,blob)
        
        % detect foreground
        mask = step(detect,frame);
        
        % apply morphological operations to remove noise and fill in holes
        mask = imopen(mask, strel('rectangle', [3,3]));
        mask = imclose(mask, strel('rectangle', [15, 15]));
        mask = imfill(mask, 'holes');
        
        % perform blob analysis to find connected components
        [~, centroids, bboxes] = blob.step(mask);
    end