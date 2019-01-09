% File Name: func_GaussianMask_1D.m
% Author   : Ziwei Chen
% Date     : Sep-20-2018
% Modified : Ziwei Chen
% Date     : Dec-11-2018
% Version  : Ver. 1.2
% Descrip  : This function was to create a 1-D Maussian mask
%%
function [GaussianMask_1D] = func_GaussianMask_1D(Sigma, Dir)
% Find Filter Width using rule of thum
Filter_Width_Half = round((4 * Sigma - 1)/2);
Filter_Width_Total = (-Filter_Width_Half:Filter_Width_Half);
GaussianMask_1D = exp( -(Filter_Width_Total).^2 ./ (2*Sigma^2) );

%1 / ( sqrt(2 * pi()) * Sigma) *...
%exp( -(Filter_Width_Total).^2 ./ (2*Sigma^2) );
GaussianMask_1D = GaussianMask_1D/ sum(GaussianMask_1D); % Normailze
    
% Rotation depending on filter orientation
if Dir == 'H'
    GaussianMask_1D = GaussianMask_1D';
elseif Dir == 'V'
    % No Operation
end
end

