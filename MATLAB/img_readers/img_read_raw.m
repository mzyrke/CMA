function img=img_read_raw(filename,dim)
%Reads raw 2D or 3D image into unit8
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
fin=fopen(filename,'r');
if(length(dim)==0)
    msg = 'dimension cannot be 0!';
   error(msg);
else
   I=fread(fin,prod(dim),'uint8=>uint8'); 
end

if (length(dim)==4)
   img=reshape(I,dim);
   img=permute(img,[2 1 3 4]);
elseif(length(dim)==3)
    img=reshape(I,dim);
    img=permute(img,[2 1 3]);
elseif(length(dim)==2)
   img=reshape(I,dim);
   img=permute(img,[2 1]);
end

fclose(fin);
end