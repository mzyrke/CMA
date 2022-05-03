function handles = plot_pointcloud_by_ROI(coords, pvals_cell, tt, ROIs, roi_ids,dir_save, figprop)
%%
%
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
% Developed by MK on 2021_11_13
% Last rev by MK on 2021_12_24
%
%======> This is a work in progress.
%%

X = cell2arr_1D(coords.X(:,tt));
Y = cell2arr_1D(coords.Y(:,tt));
Z = cell2arr_1D(coords.Z(:,tt));
pvals = cell2arr_1D(pvals_cell(:,tt));

for ii=1:length(roi_ids)

    handles.figure{ii}=figure('visible','on',...
        'units',figprop.units,'position',figprop.position);

    handles.plt{ii} = scatter3(...
        X(ROIs{roi_ids(ii),tt}), Y(ROIs{roi_ids(ii),tt}), Z(ROIs{roi_ids(ii),tt}), ...
        figprop.marker_size{ii}, pvals(ROIs{roi_ids(ii),tt}),...
        'Marker',figprop.marker_shape{ii},...
        'LineWidth',figprop.LineWidth{ii},...
        'MarkerEdgeColor',figprop.marker_edge_c{ii},...
        'MarkerEdgeAlpha',figprop.marker_edge_alpha{ii},...
        'MarkerFaceColor',figprop.marker_face_c{ii},...
        'MarkerFaceAlpha',figprop.marker_face_alpha{ii});

    colormap(figprop.c_map{ii});
    caxis(figprop.c_lim{ii})
    %colorbar
    daspect([1 1 1]);
    pbaspect([1 1 1]);

    set(gca,'view',figprop.gca_view{ii},'color','none')
    grid off;
    box off
%     set(gca,...
%         'xlim', figprop.axis.xlim,...
%         'ylim', figprop.axis.ylim, ...
%         'zlim', figprop.axis.zlim);

    axis off;

%     exportgraphics(handles.figure{ii},fullfile(dir_save,figprop.filename{ii}),...   
%         'ContentType','vector',...
%         'BackgroundColor','none');
    handles.axis{ii}=gca;
end

end