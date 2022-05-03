function  myblock = par_block_gen(mydata, max_thread)
%%
%======> This is a work in progress.
%
%======> par_block_gen:
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
% Developed by MK on 2022_01_20
% Last rev by MK on 2022_01_21
%
%======> This is a work in progress.
%%
el_count=numel(mydata);

% par_compute_size = ceil(sqrt(el_count));
% par_thread_size = par_compute_size;

ratio=1;

par_thread_size = max_thread*ratio;
par_compute_size = ceil(el_count/par_thread_size);




myblock = cell(par_thread_size,1);

for ii = 1:par_thread_size
    idx_start = 1+(ii-1)*par_compute_size;
    idx_end = min([idx_start+par_compute_size-1, el_count]);
    myblock{ii} = mydata(idx_start:idx_end);
end


% temp_mydata = nan(par_compute_size,par_thread_size);

end