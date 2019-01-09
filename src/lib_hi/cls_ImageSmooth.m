% File Name: cls_ImageSmooth.m
% Author   : Ziwei Chen
% Date     : Sep-20-2018
% Modified : Ziwei Chen
% Date     : Sep-25-2018
% Version  : Ver. 1.1
% Descrip  : This class was to perform gaussian filtering to image. Default
%            function was using MATLAB default conv() function, and 
%            NewWheel function was using a rebuilt func_Conv_1D wheel.
%%
classdef cls_ImageSmooth
    methods (Static)
        % Default MATLAB conv() for Gaussian filter
        function [ImageMatrix_Smoothed] = func_ImageSmooth_Default(ImageMatrix,Sigma)
            % Vertical Process
            waitbarZ = waitbar(0 ,'Smooth Image On Vertical Direction...');
            GassianMask = func_GaussianMask_1D(Sigma,'V');                 % Apply Row Mask
            for index = 1:ImageMatrix.size(1)                              % Row by row conv
                % Extract rows
                ImageMatrix.row{index} = ImageMatrix.raw(index,:);         % Process row by row
                % Perform 1-D Conv w/ Gaussian Mask
                ImageMatrix.smooth.row{index} = conv(ImageMatrix.row{index},...
                    GassianMask,'same');
                % Reformat Data
                ImageMatrix.Vertical(index,:) = ImageMatrix.smooth.row{index};
                
                waitbar(index/ImageMatrix.size(1)/2,waitbarZ,'Smooth Image On Vertical Direction...');
            end
            %%
            % Horizontial Process
            GassianMask = func_GaussianMask_1D(Sigma,'H');                 % Apply Colum Mask
            for index = 1:ImageMatrix.size(2)                              % Colum by colum conv
                % Extract rows
                ImageMatrix.col{index} = ImageMatrix.Vertical(:,index);    % Process by colum
                % Perform 1-D Conv w/ Gaussian Mask
                ImageMatrix.smooth.col{index} = conv(ImageMatrix.col{index},...
                    GassianMask','same');
                % Reformat Data
                ImageMatrix.Bidirectional(:,index) = ImageMatrix.smooth.col{index};
                
                waitbar(index/ImageMatrix.size(2)/2 + 0.5,waitbarZ,'Smooth Image on Horizontial Direction...');
            end
            close(waitbarZ)
            %%
            ImageMatrix_Smoothed.ImageData = ImageMatrix.Bidirectional;
            ImageMatrix_Smoothed.ImageSize = ImageMatrix.size;
        end

        
        % New designed wheel func_Conv_1D for Gaussian filter
        function [ImageMatrix_Smoothed] = func_ImageSmooth_NewWheel(ImageMatrix,Sigma)
            % Vertical Process
            waitbarZ = waitbar(0 ,'Smooth Image On Vertical Direction...');
            GassianMask = func_GaussianMask_1D(Sigma,'V');                 % Apply Row Mask
            for index = 1:ImageMatrix.size(1)                              % Row by row conv
                % Extract rows
                ImageMatrix.row{index} = ImageMatrix.raw(index,:);         % Process row by row
                %ImageMatrix.row{index} = ImageMatrix.row{index};
                % Perform 1-D Conv w/ Gaussian Mask
                ImageMatrix.smooth.row{index} = func_Conv_1D(ImageMatrix.row{index},...
                    GassianMask,'H','M');
                % Reformat Data
                ImageMatrix.Vertical(index,:) = ImageMatrix.smooth.row{index};
                
                waitbar(index/ImageMatrix.size(1)/2,waitbarZ,'Smooth Image On Vertical Direction...');
            end
            %%
            % Horizontial Process
            GassianMask = func_GaussianMask_1D(Sigma,'H');                 % Apply Colum Mask
            for index = 1:ImageMatrix.size(2)                              % Colum by colum conv
                % Extract rows
                ImageMatrix.col{index} = ImageMatrix.Vertical(:,index);    % Process by colum
                % Perform 1-D Conv w/ Gaussian Mask
                ImageMatrix.smooth.col{index} = func_Conv_1D(ImageMatrix.col{index},...
                    GassianMask','V','M');
                % Reformat Data
                ImageMatrix.Bidirectional(:,index) = ImageMatrix.smooth.col{index};
                waitbar(index/ImageMatrix.size(2)/2 + 0.5,waitbarZ,'Smooth Image on Horizontial Direction...');
            end
            close(waitbarZ)
            %%
            ImageMatrix_Smoothed.ImageData = ImageMatrix.Bidirectional;
            ImageMatrix_Smoothed.ImageSize = ImageMatrix.size;
        end
    end
end

