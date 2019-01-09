% File Name: func_GradientMask_1D.m
% Author   : Ziwei Chen
% Date     : Sep-20-2018
% Modified : Ziwei Chen
% Date     : Sep-25-2018
% Version  : Ver. 1.1
% Descrip  : This function was to create a 1-D Gradient Mask
%%
function [GradientMask_1D] = func_GradientMask_1D(Dir)
% Rotation depending on filter orientation
if Dir == 'H'
    GradientMask_1D = [-1;0;1];
elseif Dir == 'V'
    GradientMask_1D = [-1 0 1];
end
end

