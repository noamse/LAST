function Im = ImagePoll(Q,filepath)
Im = Q.poll_live_image;

if (~isempty(Im.img))
    ImMat=double(Im.img(:));
    imstd= std(ImMat);
    med = median(ImMat);
    temp = Q.temperature;
    exptime = Q.expTime;
    t= now;
    fileID=fopen(filepath,'a');
    fprintf(fileID,'%12.12d %12.2d %12.2d %12.2d %12.2d \n',t,exptime,temp,imstd,med);
    fclose(fileID);

else
    sprintf('Image is empty');
end
end

