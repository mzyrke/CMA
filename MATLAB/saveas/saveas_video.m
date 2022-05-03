function saveas_video(Frames,filename,frameRate)
%%
%======> This is a work in progress.
%
%======> :
%
%           INPUTS:
%
%
%
%           OUTPUTS:
%
%
%
%
%======
% Developed by MK on 2020_12_13
% Last rev by MK on 2020_12_44
%
%======> This is a work in progress.
%%
% create the video writer with 1 fps
writeVid = VideoWriter(filename);
writeVid.FrameRate = frameRate;
writeVid.Quality=100;
% set the seconds per image

open(writeVid);
for i=1:length(Frames)
    % convert the image to a frame
    frame = Frames(i) ;
    writeVideo(writeVid, Frames(i));
end
close(writeVid);
end