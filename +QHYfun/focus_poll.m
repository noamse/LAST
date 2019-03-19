function focus_poll(Q,h)
    QHYim = Q.poll_live_image;
    S =  SIM; 
    S.Im = QHYim.img;
    
    if isempty(h)
        imagesc(S.Im);
    else
        h.CData= S.Im;
        
    end
    %S= mextractor(S);
    
end