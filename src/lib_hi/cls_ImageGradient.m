% File Name: cls_ImageGradient.m
% Author   : Ziwei Chen
% Date     : Sep-20-2018
% Modified : Ziwei Chen
% Date     : Sep-25-2018
% Version  : Ver. 1.1
% Descrip  : This class was to Calculate Image Gradient, and find ridge.
%%
classdef cls_ImageGradient
    methods (Static)
        %%
        % Calculate Image Gradient using Handout method
        function ImageMatrix_Gradient = func_ImageGradient_M_Method(ImageMatrix)
            waitbarG = waitbar(0,'Compute Magnitude Using Handhout Mwthod...');
            %% Compute Sqr Magnitude M from Handhout
            waitbar(0,waitbarG,'Compute Magnitude Using Handhout Mwthod...');
            M = zeros(ImageMatrix.ImageSize);
            for indexV = 1:ImageMatrix.ImageSize(1)
                for indexH = 1:ImageMatrix.ImageSize(2)
                    if (indexV >= 2 && indexV <= ImageMatrix.ImageSize(1) - 1) && (indexH >= 2 && indexH <= ImageMatrix.ImageSize(2) - 1)
                        M(indexV,indexH) = (ImageMatrix.ImageData(indexV + 1,indexH) - ImageMatrix.ImageData(indexV - 1,indexH))^2 + ...
                            (ImageMatrix.ImageData(indexV,indexH + 1) - ImageMatrix.ImageData(indexV,indexH - 1))^2;
                    else
                        M(indexV,indexH) = 255;                              % Ignore the boundry pixel
                    end
                end
                waitbar((indexV/(ImageMatrix.ImageSize(1))/3),waitbarG,'Compute Magnitude Using Handhout M...');
            end
            
            %% Vertical Process, Gradient Orientation at Vertical
            GradientMask = func_GradientMask_1D('V');                                  % Apply Row Mask
            for index = 1:ImageMatrix.ImageSize(1)                                     % Row by row conv
                % Extract rows
                ImageMatrix.rowVector{index} = ImageMatrix.ImageData(index,:);         % Process row by row
                % Perform 1-D Conv w/ Gradient Mask
                ImageMatrix.GradientImageData.row{index} = func_Conv_1D(ImageMatrix.rowVector{index},...
                    GradientMask,'H','M');
                % Reformat Data
                ImageMatrix.X(index,:) = ImageMatrix.GradientImageData.row{index};
                waitbar(0.333 + index/ImageMatrix.ImageSize(1)/3,waitbarG,'Compute Vertical Matrix Gradient deltaX by Convolution...');
            end
            %% Horizontial Process, Gradient Orientation at Horizontial
            GradientMask = func_GradientMask_1D('H');                                  % Apply Colum Mask
            for index = 1:ImageMatrix.ImageSize(2)                                     % Colum by colum conv
                % Extract rows
                ImageMatrix.colVector{index} = ImageMatrix.ImageData(:,index);         % Process by colum
                % Perform 1-D Conv w/ Gradient Mask
                ImageMatrix.GradientImageData.col{index} = func_Conv_1D(ImageMatrix.colVector{index},...
                    GradientMask','V','M');
                % Reformat Data
                ImageMatrix.Y(:,index) = ImageMatrix.GradientImageData.col{index};
                waitbar(0.666 + index/ImageMatrix.ImageSize(2)/3,waitbarG,'Compute Horizontial Matrix Gradient deltaY by Convolution...');
            end
            
            %% Assign DeltaX/Y
            ImageMatrix_Gradient.DeltaX = ImageMatrix.X;
            ImageMatrix_Gradient.DeltaY = ImageMatrix.Y;
            %% Assign Final M Value
            ImageMatrix_Gradient.M = M;
            ImageMatrix_Gradient.abs = sqrt(ImageMatrix_Gradient.M);
            close(waitbarG);
        end
        
        
        %%
        % Calculate Image Gradient Using Convolution Method
        function ImageMatrix_Gradient = func_ImageGradient_Conv_Method(ImageMatrix)
            waitbarG = waitbar(0,'Perform Matrix Gradient using Convolution');
            %% Vertical Process, Gradient at Vertical
            GradientMask = func_GradientMask_1D('V');                                  % Apply Row Mask
            for index = 1:ImageMatrix.ImageSize(1)                                     % Row by row conv
                % Extract rows
                ImageMatrix.rowVector{index} = ImageMatrix.ImageData(index,:);         % Process row by row
                % Perform 1-D Conv w/ Gradient Mask
                ImageMatrix.GradientImageData.row{index} = func_Conv_1D(ImageMatrix.rowVector{index},...
                    GradientMask,'H','M');
                % Reformat Data
                ImageMatrix.X(index,:) = ImageMatrix.GradientImageData.row{index};
                waitbar(index/ImageMatrix.ImageSize(1)/2,waitbarG,'Compute Vertical Matrix Gradient deltaX by Convolution...');
            end
            %% Horizontial Process, Gradient at Horizontial
            GradientMask = func_GradientMask_1D('H');                                  % Apply Colum Mask
            for index = 1:ImageMatrix.ImageSize(2)                                     % Colum by colum conv
                % Extract rows
                ImageMatrix.colVector{index} = ImageMatrix.ImageData(:,index);         % Process by colum
                % Perform 1-D Conv w/ Gradient Mask
                ImageMatrix.GradientImageData.col{index} = func_Conv_1D(ImageMatrix.colVector{index},...
                    GradientMask','V','M');
                % Reformat Data
                ImageMatrix.Y(:,index) = ImageMatrix.GradientImageData.col{index};
                waitbar(0.5 + index/ImageMatrix.ImageSize(2)/2,waitbarG,'Compute Horizontial Matrix Gradient deltaY by Convolution...');
            end
            %% Assign DeltaX/Y
            ImageMatrix_Gradient.DeltaX = ImageMatrix.X;
            ImageMatrix_Gradient.DeltaY = ImageMatrix.Y;
            %% Compute Sqr/Sqrt Magnitude using sqr
            ImageMatrix_Gradient.M = (ImageMatrix_Gradient.DeltaX.^2) + (ImageMatrix_Gradient.DeltaY.^2);
            ImageMatrix_Gradient.abs = sqrt(ImageMatrix_Gradient.M);
            close(waitbarG);
        end
        
        %%
        % Find Ridge
        function ImageMatrix_Gradient = func_ImageGradient_Ridge(ImageMatrix)
            waitbarGP = waitbar(0,'Finding Ridge on M...');
            % Compute Unit Vector
            ImageMatrix.unitVector.X = ImageMatrix.DeltaX ./ ImageMatrix.abs;
            ImageMatrix.unitVector.Y = ImageMatrix.DeltaY ./ ImageMatrix.abs;
            % Select Directional Neighboring Pixel
            ImageMatrix.sizeMatrix = size(ImageMatrix.M);
            %%
            for IndexH = 1:ImageMatrix.sizeMatrix(2)
                waitbar(IndexH/(ImageMatrix.sizeMatrix(2)),waitbarGP,'Finding Ridge on M...');
                for IndexV = 1:ImageMatrix.sizeMatrix(1)
                    if (IndexH < 2 || IndexH > ImageMatrix.sizeMatrix(2) - 1) ||...
                            (IndexV < 2 || IndexV > ImageMatrix.sizeMatrix(1) - 1)
                        ImageMatrix.Ridge(IndexV, IndexH) = 0;
                        ImageMatrix.absX(IndexV, IndexH) = 0;
                        ImageMatrix.absY(IndexV, IndexH) = 0;
                    else
                        %% X > 0, Y > 0
                        if ImageMatrix.unitVector.X(IndexV, IndexH) > 0 && ImageMatrix.unitVector.Y(IndexV, IndexH) > 0
                            ImageMatrix.absX(IndexV, IndexH) = abs(ImageMatrix.unitVector.X(IndexV, IndexH));
                            ImageMatrix.absY(IndexV, IndexH) = abs(ImageMatrix.unitVector.Y(IndexV, IndexH));
                            if ImageMatrix.absX(IndexV, IndexH) > ImageMatrix.absY(IndexV, IndexH)
                                % Right
                                P_P = ImageMatrix.M(IndexV, IndexH + 1);
                                P_N = ImageMatrix.M(IndexV, IndexH - 1);
                            else
                                % Up
                                P_P = ImageMatrix.M(IndexV + 1, IndexH);
                                P_N = ImageMatrix.M(IndexV - 1, IndexH);
                            end
                            % Find Peak
                            if ImageMatrix.M(IndexV, IndexH) > P_P &&...
                                    ImageMatrix.M(IndexV, IndexH) >= P_N
                                % This is the peak, keep it
                                ImageMatrix.Ridge(IndexV, IndexH) = ImageMatrix.M(IndexV, IndexH);
                            else
                                % Not Peak, set to zero
                                ImageMatrix.Ridge(IndexV, IndexH) = 0;
                            end
                            %% X > 0, Y < 0
                        elseif ImageMatrix.unitVector.X(IndexV, IndexH) > 0 && ImageMatrix.unitVector.Y(IndexV, IndexH) <= 0
                            ImageMatrix.absX(IndexV, IndexH) = abs(ImageMatrix.unitVector.X(IndexV, IndexH));
                            ImageMatrix.absY(IndexV, IndexH) = abs(ImageMatrix.unitVector.Y(IndexV, IndexH));
                            if ImageMatrix.absX(IndexV, IndexH) > ImageMatrix.absY(IndexV, IndexH)
                                % Right
                                P_P = ImageMatrix.M(IndexV, IndexH + 1);
                                P_N = ImageMatrix.M(IndexV, IndexH - 1);
                            else
                                % Down
                                P_P = ImageMatrix.M(IndexV - 1, IndexH);
                                P_N = ImageMatrix.M(IndexV + 1, IndexH);
                            end
                            % Find Peak
                            if ImageMatrix.M(IndexV, IndexH) > P_P &&...
                                    ImageMatrix.M(IndexV, IndexH) >= P_N
                                % This is the peak, keep it
                                ImageMatrix.Ridge(IndexV, IndexH) = ImageMatrix.M(IndexV, IndexH);
                            else
                                % Not Peak, set to zero
                                ImageMatrix.Ridge(IndexV, IndexH) = 0;
                            end
                            %% X < 0, Y > 0
                        elseif ImageMatrix.unitVector.X(IndexV, IndexH) <= 0 && ImageMatrix.unitVector.Y(IndexV, IndexH) > 0
                            ImageMatrix.absX(IndexV, IndexH) = abs(ImageMatrix.unitVector.X(IndexV, IndexH));
                            ImageMatrix.absY(IndexV, IndexH) = abs(ImageMatrix.unitVector.Y(IndexV, IndexH));
                            if ImageMatrix.absX(IndexV, IndexH) > ImageMatrix.absY(IndexV, IndexH)
                                % Left
                                P_P = ImageMatrix.M(IndexV, IndexH - 1);
                                P_N = ImageMatrix.M(IndexV, IndexH + 1);
                            else
                                % Up
                                P_P = ImageMatrix.M(IndexV + 1, IndexH);
                                P_N = ImageMatrix.M(IndexV - 1, IndexH);
                            end
                            % Find Peak
                            if ImageMatrix.M(IndexV, IndexH) > P_P &&...
                                    ImageMatrix.M(IndexV, IndexH) >= P_N
                                % This is the peak, keep it
                                ImageMatrix.Ridge(IndexV, IndexH) = ImageMatrix.M(IndexV, IndexH);
                            else
                                % Not Peak, set to zero
                                ImageMatrix.Ridge(IndexV, IndexH) = 0;
                            end
                            %% X < 0, Y < 0
                        elseif ImageMatrix.unitVector.X(IndexV, IndexH) <= 0 && ImageMatrix.unitVector.Y(IndexV, IndexH) <= 0
                            ImageMatrix.absX(IndexV, IndexH) = abs(ImageMatrix.unitVector.X(IndexV, IndexH));
                            ImageMatrix.absY(IndexV, IndexH) = abs(ImageMatrix.unitVector.Y(IndexV, IndexH));
                            if ImageMatrix.absX(IndexV, IndexH) > ImageMatrix.absY(IndexV, IndexH)
                                % Left
                                P_P = ImageMatrix.M(IndexV, IndexH - 1);
                                P_N = ImageMatrix.M(IndexV, IndexH + 1);
                            else
                                % Down
                                P_P = ImageMatrix.M(IndexV - 1, IndexH);
                                P_N = ImageMatrix.M(IndexV + 1, IndexH);
                            end
                            % Find Peak
                            if ImageMatrix.M(IndexV, IndexH) > P_P &&...
                                    ImageMatrix.M(IndexV, IndexH) >= P_N
                                % This is the peak, keep it
                                ImageMatrix.Ridge(IndexV, IndexH) = ImageMatrix.M(IndexV, IndexH);
                            else
                                % Not Peak, set to zero
                                ImageMatrix.Ridge(IndexV, IndexH) = 0;
                            end
                        end
                    end
                end
            end
            ImageMatrix.sizeRidge = size(ImageMatrix.Ridge);
            ImageMatrix_Gradient = ImageMatrix;
            close(waitbarGP);
        end
        %%
    end
end

