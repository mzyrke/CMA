function [disp_field,targetReg]=img_reg_ddemons(images,iterations,smoothing_ratio,img_dim,slice_z)
%%
%======> This is a work in progress.
%
%======> img_registration_D_Field:
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
% Developed by MK on 2021_11_20
% Last rev by MK on 2020_12_02
%
%======> This is a work in progress.
%%
tic
img_disp_timeStep=length(images)-1;
disp_field=cell(1,img_disp_timeStep);
targetReg=cell(1,img_disp_timeStep);

if (img_dim==2)
    for(tt=1:img_disp_timeStep)
       
        fixed=images{tt+1}(:,:,slice_z);
        moving=images{tt}(:,:,slice_z); %Goal is to find the def that allows us to arrive at fixed
        %moving = imhistmatch(moving,fixed);
        [disp_field{1,tt},targetReg{1,tt}] = imregdemons(moving,fixed,iterations,...
            'AccumulatedFieldSmoothing',smoothing_ratio);
    end
elseif(img_dim==3)
    for(tt=1:img_disp_timeStep)

        fixed=images{tt+1}(:,:,:);
        moving=images{tt}(:,:,:);
        
        size(fixed)
        size(moving)
        %moving = imhistmatch(moving,fixed);
        [disp_field{1,tt},targetReg{1,tt}] = imregdemons(moving,fixed,iterations,...
            'AccumulatedFieldSmoothing',smoothing_ratio);
    end
end
toc
end