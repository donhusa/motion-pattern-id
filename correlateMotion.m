function tracks=correlateMotion(person, phoneData,tracks)
    %only have one phone right now
    maxXC=0;
    maxInd=0;
    thresh = 0;%NONZERO THRESHOLD
    
    for i=1:size(tracks,1)
        tracks(i).currPerson='';
        xMove=tracks(i).xMotion;
        xc=xcorr(phoneData,xMove);
        xc =sum(xc)
        if xc > maxXC
            maxInd=i;
            maxXC=xc;
        end
    end
    
    %add some weight function to something assigned as person
    if maxXC> thresh
        tracks(maxInd).currPerson=person;
        try
            temp=tracks(maxInd).personCount.(person);
            tracks(maxInd).personCount.(person)=temp+1;
        catch
            tracks(maxInd).personCount.(person)=0;
        end
        %keep a map of assignedperson -> number of times its been assigned
        %tracks(person(id))++
        %user gives feedback to make algorithm more robust?
            %click a button to verify if that's the box
            %requires messing with assignment function (hard)
    end
    
end