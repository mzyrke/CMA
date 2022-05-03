%%
% This is a work in progress. PLEASE USE AT YOUR OWN RISK!
%
%   This is part of the Cardiac Motion Analyzer Toolbox.
%
%   We are in the process of adding new features, transferring the MATLAB
%   codes to python, and publishing our next papers. Please consider this
%   while using this work and please let us know about your comments, 
%   suggestions, and questions. 
%
%
%       Thank you!
%       MK
%
%
%%
%   Project: DD image registration Toolbox for cardiac cine MRI scans.
%
%	    Goal: Assess cardiac contractile function by 
%       calculating myocardial strains from cardiac cine MRI scans
%   
%   If you intend to use this work, as a whole or in part, 
%   please kindly cite the following manuscript:
%   
%       Keshavarzian, M., et al. (2021). An Image Registration Framework to 
%       Estimate 3D Myocardial Strains from Cine Cardiac MRI in Mice. 
%       Functional Imaging and Modeling of the Heart (pp. 273-284). Springer, Cham. 
%       
%       https://link.springer.com/chapter/10.1007/978-3-030-78710-3_27
%   
%       
%%
%======>img_reg_cmr_script:
%       
%
%
%
%
%
%======
% Developed by MK on 2021_11_11
% Last rev. by MK on 2022_01_18
%%
% This is a work in progress. PLEASE USE AT YOUR OWN RISK!
%
%%
%======== clear params, figs, etc.
poolobj = gcp('nocreate');
delete(poolobj);
clc;
clear all;
close all;
%%
%======== set the dir for the MATLAB lib & the project
dirs.mfile_libraries_root='Your_MATLAB_LIB_DIR';
dirs.project_root='Project_Dir\';
%%
%========
cd(dirs.mfile_libraries_root);
%%
%========Load libraries
matlab_libs = {...
    'data_structs', 'img_readers', 'img_process',...
    'utility',...
    'utility/struct', 'utility/convex_hull', 'utility/cell', 'utility/img', 'utility/contours', 'utility/plots'...
    'img_dicom', 'img_reg', 'img_plot',...
    'strain'};

matlab_libs_array = {dirs.mfile_libraries_root, matlab_libs};
dirs.mfile_libraries = matlab_load_libs(matlab_libs_array);
%%
%======== Specify the study ids
study_ids.patient = 'M123';
study_ids.scan = 'S012';
study_ids.images_used = 'SA'; %'SALA' 'SA' 'LA'
study_ids.param_id = 'img_reg_param_id_of_your_choice';
%%
%========Set output filenames
filenames.outputs.results = {'results.mat'};
filenames.outputs.images = {'images_o.mat','images_res.mat'};
filenames.outputs.figures_2D = {'myfig2D.fig'};
filenames.outputs.figures_animations ={'myanim.gif'};
filenames.outputs.figures_3D = {'myfig3D.fig'};
%%
%========Generate dataset filenames, dirs, etc.
[study_ids, dirs, filenames, files] = img_reg_dataset_dirgen(study_ids, dirs, filenames, matlab_libs);
%%
%========create data structs
ds_img_nestedcell = img_struct_cells();

images_o = cell2struct_nested(ds_img_nestedcell);
images_res = cell2struct_nested(ds_img_nestedcell);

%%  =========Load saved preprocessed images or read dicom images
%======== Load saved preprocessed images
load(files.outputs.images{1});
load(files.outputs.images{2});
%=== image dataset prop
results.img.resampled = cell2cellarr_3D(images_res.pvals.gray);
results.img.masked = images_res.ROI.LV3D.SA;

%========Read dicom files
% [images_o.pvals.raw, images_o.map, images_o.info] = dicom_read_2_4D(dirs.images_sorted);
%
%========
% for (tt=1:size(images.img,2))
%     img.original{tt} = reshape([images.img{img.Properties.index_SA(1):img.Properties.index_SA(2),tt}],...
%         img.Properties.img_Dim(1),img.Properties.img_Dim(2),img.Properties.img_Dim(3));
% 
%     img.crop{tt}=img_process_crop(img.original{tt},img.Properties.crop_ROI);
%     img.grayscale{tt}  = mat2gray(double(img.crop{tt}),[0 65535]); %uint8 or unit16
%     img.resampled{tt}=img_process_resample(img.grayscale{tt},img.Properties.resample_ratio);
% end
% results.img.resampled=img.resampled(:);
%========
%%
%========Convert the contours to binary images
montage([results.img.masked{1}(:,:,:)],[1 0 0;0 1 0; 0 0 1]);
%%
%========time steps

%%
%========image reg param 
params.img_reg.smoothing_ratio=1.5;
params.img_reg.iterations=[1000 800 600];
params.img_reg.img_dim=3;
params.img_reg.t_last=16;
params.img_reg.Slice_z=floor(size(results.img.resampled{1},3)/2);
%%
%========image reg 
[results.D, results.img.targetReg] = img_reg_ddemons(...
    results.img.resampled(1:params.img_reg.t_last),...
    params.img_reg.iterations,...
    params.img_reg.smoothing_ratio,...
    params.img_reg.img_dim,...
    params.img_reg.Slice_z);
%%
%%
%========Load Previous results?
% files.outputs.results{1}
%%
%========Calculate the absolute displacements (replace the
%timepoint-to-timepoint w/ a ref to timepoint 1
for tt=1:params.img_reg.t_last-1
    if(tt==1)
        results.D_abs{tt}=results.D{tt};
    else
        results.D_abs{tt}=results.D{tt}+results.D_abs{tt-1};
    end
end
%%
%========Calculate the Strains (Eulerian + Lagrangian), D_mag,...
for tt=1:params.img_reg.t_last-1 %note that for 21 images there wil be 20 disp fields
    results.D_mag{tt}=sqrt(results.D_abs{tt}(:,:,:,1).^2+results.D_abs{tt}(:,:,:,2).^2+results.D_abs{tt}(:,:,:,3).^2);
    results.E_e{tt}=strain_Eulerian_disp(results.D_abs{tt}(:,:,:,1),results.D_abs{tt}(:,:,:,2),results.D_abs{tt}(:,:,:,3));
    results.E_l{tt}=strain_Lagrangian_disp(results.D_abs{tt}(:,:,:,1),results.D_abs{tt}(:,:,:,2),results.D_abs{tt}(:,:,:,3));
end
%%
%========Where is the ROI? it's ==1 for now
for tt=1:params.img_reg.t_last
    temp=results.img.masked{tt};
    temp(temp~=1)=nan; %ROI is 1
    ROI{tt}=temp;
end
%%
%========Filter for the ROI 
maskROI=1;
if(maskROI==1)
    results.D_masked=img_process_maskBYimage(results.D,ROI);
    results.D_mag_masked=img_process_maskBYimage(results.D_mag,ROI);
    results.E_e_masked=img_process_maskBYimage(results.E_e,ROI);
    results.E_l_masked=img_process_maskBYimage(results.E_l,ROI);
end
%%
%========Save results
results.params=params;
save(files.outputs.results{1},'results', '-v7.3');
%%
%========


