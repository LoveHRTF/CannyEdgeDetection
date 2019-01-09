% File Name: cls_PeakDetector.m
% Author   : Ziwei Chen
% Date     : Sep-20-2018
% Modified : Ziwei Chen
% Date     : Sep-25-2018
% Version  : Ver. 1.1
% Descrip  : This class was to threshold the image by using T_Lo and T_Hi,
%            and flip the image to final output
%%
classdef cls_PeakDetector
    methods (Static)
        %%
        % Calculate The Scaled T_Hi and T_Lo as a percent to max pixcal
        % value
        function [T_Hi, T_Lo] = func_Comput_Th(T_Hi_In, T_Lo_In, Ridge)
            maxValue = max(max(Ridge));
            T_Hi = maxValue * T_Hi_In;
            T_Lo = maxValue * T_Lo_In;
        end
        
        
        %%
        function ImagePeakHi = func_PeakFilter_Hi(ImageGradientPeak,T_Hi)
        % Apply T_Hi Filter
            ImagePeakHi.Data = zeros(ImageGradientPeak.sizeRidge);
            for x = 1:ImageGradientPeak.sizeRidge(1)
                for y = 1:ImageGradientPeak.sizeRidge(2)
                    if ImageGradientPeak.Ridge(x,y) > T_Hi
                        ImagePeakHi.Data(x,y) = 255;
                    else
                        % Keep Original
                        ImagePeakHi.Data(x,y) = ImageGradientPeak.Ridge(x,y);
                        
                    end
                end
            end
            ImagePeakHi.Size = size(ImagePeakHi.Data);
        end
        
        
        %%
        % Apply T_Lo Filter to pixels have T_Hi pixel nearby, and flip the
        % image for final output
        function ImageEdge_Out = func_PeakFilter_Lo(ImagePeakHi,T_Lo)
            ImageEdge = zeros(ImagePeakHi.Size);
            ImageEdge_Out = boolean(zeros(ImagePeakHi.Size));
            for x = 1:ImagePeakHi.Size(1) - 1
                for y = 1:ImagePeakHi.Size(2) - 1
                    if ImagePeakHi.Data(x,y) > T_Lo &&...
                            (ImagePeakHi.Data(x,y) == 255 ||...
                            ImagePeakHi.Data(x + 1, y) == 255 || ImagePeakHi.Data(x, y + 1)  == 255 ||...
                            ImagePeakHi.Data(x - 1, y) == 255 || ImagePeakHi.Data(x, y - 1) == 255)
                        ImageEdge(x,y) = 255;
                    else
                        ImageEdge(x,y) = 0;
                    end
                end
            end

            for x = 1:ImagePeakHi.Size(1)
                for y = 1:ImagePeakHi.Size(2)
                    if ImageEdge(x,y) == 255
                        
                        ImageEdge_Out(x,y) = boolean(0);
                    else
                        ImageEdge_Out(x,y) = boolean(1);
                    end
                end
            end
        end
        %%
    end
end

