function plot_saveas_transparent(fig, dir, filename)
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
% Last rev by MK on 2021_12_24
%
%======> This is a work in progress.
%%

tmp1=fullfile(dir, 'temp_black.png');
tmp2=fullfile(dir, 'temp_white.png');
final=fullfile(dir, filename);

exportgraphics(fig, tmp1, 'ContentType', 'image', 'BackgroundColor', 'k'); % black background
exportgraphics(fig, tmp2, 'ContentType', 'image', 'BackgroundColor', 'w'); % white background

% load exported images back in and scale to [0,1]
u = imread(tmp1);
u = double(u) / 255;
v = imread(tmp2);
v = double(v) / 255;

% recover transparency as a
a = 1 - v + u;
a = mean(a, 3);
a = max(0, min(1, a));
m = a > eps;

% recover rgb
c = zeros(size(u));
for i = 1 : 3
    ui = u(:, :, i);
    ci = c(:, :, i);
    ci(m) = ui(m) ./ a(m);
    c(:, :, i) = ci;
end
c = max(0, min(1, c));


imwrite(uint8(c*255), final, 'Alpha', a);


end