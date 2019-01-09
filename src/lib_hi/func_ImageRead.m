%% ========================================================================
% File Name: func_ImageRead.m
% Author   : Ziwei Chen
% Date     : Sep-20-2018
% Modified : N/A
% Date     : N/A
% Version  : Ver. 1.0
% Descrip  : This function was to convert the input image matrix to double
%            and read the image size.
%% ========================================================================
function [ImageMatrixData] = func_ImageRead(ImageReadData)
% DataType Conversion
img.raw = double(ImageReadData);
% Get Image Size
img.size = size(ImageReadData);
% Output
ImageMatrixData = img;
end

