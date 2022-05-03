function img_filtered=img_filter_thresh(img, thresh)
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
% Developed by MK on 2021_11_01
% Last rev by MK on 2021_12_04
%
%======> This is a work in progress.
%%
img_filtered=nan(size(img));

idx=find(img>=thresh(1) & img<=thresh(2));

img_filtered(idx) = img(idx);

end