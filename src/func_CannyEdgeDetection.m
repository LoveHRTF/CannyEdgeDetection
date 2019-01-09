function [EdgeImage] = func_CannyEdgeDetection(Threshold_Hi,Threshold_Lo,Gaussian_Sigma,InputImage)
% Define Parameters
T_Hi = Threshold_Hi; T_Lo = Threshold_Lo; sigma = Gaussian_Sigma;
%% ========================================================================
% Import Image
waitbarX = waitbar(0,'Loading Image...');
ImageOriginal = imread(InputImage);
% Step (0): Pre-Process
waitbar(0.05,waitbarX,'Processing Original Image');
ImageMatrixData = func_ImageRead(ImageOriginal);

figure(1); imshow(mat2gray(ImageMatrixData.raw)) % mat2gray() Only for Demo
%% ========================================================================
% Step (1): Apply Gaussian Filter
waitbar(0.1,waitbarX,'Gaussian Filter');
ImageSmoothed_Struct = cls_ImageSmooth.func_ImageSmooth_NewWheel(ImageMatrixData,sigma);

figure(2); imshow(mat2gray(ImageSmoothed_Struct.ImageData))
%% ========================================================================
% Step (2): Comput Gradients
waitbar(0.4,waitbarX,'Gradients');
ImageGradient = cls_ImageGradient.func_ImageGradient_M_Method(ImageSmoothed_Struct);

figure(3); imshow(mat2gray(ImageGradient.DeltaX)) % mat2gray() Only for Demo
figure(4); imshow(mat2gray(ImageGradient.DeltaY)) % mat2gray() Only for Demo
figure(5); imshow(mat2gray(ImageGradient.abs)) % mat2gray() Only for Demo
%% ========================================================================
% Step (3): Comput Ridge
waitbar(0.7,waitbarX,'Find Ridege');
ImageGradientPeak = cls_ImageGradient.func_ImageGradient_Ridge(ImageGradient);

figure(6); imshow(mat2gray(ImageGradientPeak.Ridge)) % mat2gray() Only for Demo
%% ========================================================================
% Step (4.0): Apply High Threshold 
waitbar(0.9,waitbarX,'Hi Peak Filtering...');
[T_Hi,T_Lo] = cls_PeakDetector.func_Comput_Th(T_Hi, T_Lo, ImageGradientPeak.Ridge);
ImagePeakMag_TH = cls_PeakDetector.func_PeakFilter_Hi(ImageGradientPeak, T_Hi);

figure(7); imshow(mat2gray(ImagePeakMag_TH.Data)) % mat2gray() Only for Demo
% Step (4.5): Apply Low Threshold 
waitbar(0.95,waitbarX,'Lo Peak Filtering...');
ImagePeakMag_TL = cls_PeakDetector.func_PeakFilter_Lo(ImagePeakMag_TH, T_Lo);
%% ========================================================================
% Step (5): Finilizing
waitbar(0.99,waitbarX,'Plotting');
close(waitbarX)

EdgeImage = ImagePeakMag_TL; % Output Logical matrix
figure(8); imshow(EdgeImage); % Plot image base on binary matrix
%% ========================================================================

end

