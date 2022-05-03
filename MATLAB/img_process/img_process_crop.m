function img_cropped=img_process_crop(img,ROI)
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
% Last rev by MK on 2021_12_04
%
%======> This is a work in progress.
%%

if length(size(img))==3
    img_cropped = img(1+ROI(1,1):end-ROI(1,2),1+ROI(2,1):end-ROI(2,2),1+ROI(3,1):end-ROI(3,2));
elseif length(size(img))== 2
    img_cropped = img(1+ROI(1,1):end-ROI(1,2),1+ROI(2,1):end-ROI(2,2));
end
%%
end