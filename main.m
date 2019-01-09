%% ========================================================================
% Author   : Ziwei Chen
% Date     : Sep-20-2018
% Modified : N/A
% Date     : N/A
% Version  : Ver.1.0
% Descrip  : This is the main file for Canny's Edge Detection.
%% ========================================================================
clear; clc; close all;

addpath(genpath('src'));
addpath(genpath('edge-images'));

% Define Parameters
Threshold_Hi = 0.05 ; Threshold_Lo = Threshold_Hi/2;
Gaussian_Sigma = 3;   InputImage = '100x100_Test_Image.pgm';

% Perform Edge Detection
EdgeImage = func_CannyEdgeDetection(Threshold_Hi,Threshold_Lo,Gaussian_Sigma,InputImage);
