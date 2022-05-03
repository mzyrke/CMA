function images_res = img_struct_resampler(images_cr, timestep_last, img_res_params, files_contours_LA_endo, files_contours_LA_epi,files_contours_SA_endo, files_contours_SA_epi, max_thread, coordsRconst)
%%
%======> This is a work in progress.
%
%======> img_struct_resampler:
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
% Developed by MK on 2022_01_18
% Last rev. by MK on 2022_01_18
%
%======> This is a work in progress.
%%
[images_res.pvals.gray, ...
    images_res.coords.RCS.X, images_res.coords.RCS.Y, images_res.coords.RCS.Z,  ...
    images_res.ROI.LV, ...
    images_res.ROI.LV3D.LA] = ...
    img_sr_2isometric_par(...%==
    images_cr.pvals.gray(images_cr.props.LA.index,:),...
    images_cr.coords.RCS.X(images_cr.props.LA.index ,:),...
    images_cr.coords.RCS.Y(images_cr.props.LA.index ,:),...
    images_cr.coords.RCS.Z(images_cr.props.LA.index ,:), ...
    img_res_params.LA.resample_ratio,...
    img_res_params.LA.expand,...
    img_res_params.LA.interp.img,...
    timestep_last, ...
    img_res_params.LA.has_contours, ...
    files_contours_LA_endo, ...
    files_contours_LA_epi, ...
    images_cr.props.LA.PixelSpacing, ...
    img_res_params.LA.crop_dims, ...
    img_res_params.LA.flip_contours, ...
    max_thread, coordsRconst);

images_res.props.LA.index=1:1:size(images_res.pvals.gray,1);
images_res.props.LA.img_dim = size(images_res.pvals.gray{1,1});
%%
SA_start_res = size(images_res.pvals.gray,1)+1;

[temp.pvals, temp.X, temp.Y, temp.Z,  temp.LV, temp.LV3D] = img_sr_2isometric_par(...%==
    images_cr.pvals.gray(images_cr.props.SA.index,:),...
    images_cr.coords.RCS.X(images_cr.props.SA.index ,:),...
    images_cr.coords.RCS.Y(images_cr.props.SA.index ,:),...
    images_cr.coords.RCS.Z(images_cr.props.SA.index ,:), ...
    img_res_params.SA.resample_ratio,...
    img_res_params.SA.expand,...
    img_res_params.SA.interp.img,...
    timestep_last, ...
    img_res_params.SA.has_contours, ...
    files_contours_SA_endo, ...
    files_contours_SA_epi, ...
    images_cr.props.SA.PixelSpacing, ...
    img_res_params.SA.crop_dims, ...
    img_res_params.SA.flip_contours, ...
    max_thread, coordsRconst);

images_res.pvals.gray(SA_start_res:SA_start_res+size(temp.pvals,1)-1,:) = temp.pvals;
images_res.coords.RCS.X(SA_start_res:SA_start_res+size(temp.pvals,1)-1,:) = temp.X;
images_res.coords.RCS.Y(SA_start_res:SA_start_res+size(temp.pvals,1)-1,:) = temp.Y;
images_res.coords.RCS.Z(SA_start_res:SA_start_res+size(temp.pvals,1)-1,:) = temp.Z;
images_res.ROI.LV(SA_start_res:SA_start_res+size(temp.pvals,1)-1,:) = temp.LV;
images_res.ROI.LV3D.SA = temp.LV3D;

images_res.props.SA.index = SA_start_res:1:size(images_res.pvals.gray,1);
images_res.props.SA.img_dim = size(images_res.pvals.gray{SA_start_res,1});
%%
end