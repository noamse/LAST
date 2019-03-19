function Im = take_seq(Q,filepath)
tic;
Im = Q.poll_live_image;
if (~isempty(Im.img))
    

    t= clock;
    filename = [filepath 'Im_' num2str(t(end-2)) '_' num2str(t(end-1)) '_' ...
        num2str(floor(t(end))) '.mat'] ;
    
    
    save(filename,'Im','-v6');%,'-nocompression')
    
else
    sprintf('Image is empty');
end
toc;

end

