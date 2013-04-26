function vid_test()

%%%%%%%%%% Parameters you need to set: %%%%%%%%%%%%

% The initial threshold. Threshold at "bwthresh" times darker than the
% median in each block. Use the slider bar to adjust this in real time.
blksize = 92;  %blocksize for block processing /

% Specify whether to overlay the solution not. 1 or 0. /
tracking = 1;

% You may need to adjust your video settings here:
% Also, if you use RGB instead of YUY2, you *may* need to adjust
% lines 14-16 of sudokuvideo_fn_trace.m. I'm not sure, my camera doesn't output RGB.
imaqreset
obj = videoinput('macvideo', 1, 'YCbCr422_640x480');
obj.ReturnedColorspace = 'rgb';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
try
    
    %Initialize various parameters, and load in the template data
    set(obj,'framesperTrigger',10,'TriggerRepeat',Inf);
    start(obj);
    
    A_tmin = 30; % Bounds for the digit pixel area
        
    % h = The B/W image. h_g = Green box. h_pts = magenta box
    h = imshow(zeros(480,640));
    hold on;
    
    figure(1);
    
    while islogging(obj);
        %bwthresh = get(hslider,'value');
        
        Icam = getdata(obj,1);
        %Icam = imread('sample.bmp'); %<--- For debugging
        flushdata(obj);
        
        %masking
        Icam1 = Icam(:,:,1);
        % I0 represents only the inner green square
        I0 = Icam1(10+(1:460),90+(1:460));
        %Block processed threshhold
        makebw2 = @(I) im2bw(I.data,median(double(I.data(:)))/1.3/255);
        IBW = ~blockproc(I0,[blksize blksize],makebw2);
        % Noise reduction and border elimination
        IBW = imclose(IBW,[1 1; 1 1]);
        I = IBW;
        I = bwareaopen(I,A_tmin);
        I = imclearborder(I);
        % Iout is an augmented 640x480 version of I, for display.
        Iout = zeros(480,640);
        Iout(10+(1:460),90+(1:460)) = I;
        
        
        %if ~tracking || ~found
            set(h,'CData',Icam);
        %end

        
        drawnow;

        
    end
catch
    % This attempts to take care of things when the figure is closed
    stop(obj);
    imaqreset
    %keyboard
    figure(1);
    imshow(get(h,'CData'));
    drawnow;
end
