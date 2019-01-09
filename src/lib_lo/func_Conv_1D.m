% File Name: func_Conv_1D.m
% Author   : Ziwei Chen
% Date     : Sep-20-2018
% Modified : Ziwei Chen
% Date     : Sep-25-2018
% Version  : Ver. 1.1
% Descrip  : This function was to perform 1-D convolution while keep the
%            vector size unchanged
%%
function [ResultVector] = func_Conv_1D(TargetVector,MaskVector, Direction, Patt)

%% Check Matrix Orientation and convert to horizontial
if Direction == 'V'
    TargetVector = TargetVector';
end


%% Pre-Process for read vector length, and perform zero patten
Length.Target = length(TargetVector);
Length.Mask = length(MaskVector);
MaskVector = fliplr(MaskVector);                                           % Flip the Mask Vector for conv

ResultVector = zeros(1, Length.Target + Length.Mask - 1);                  % Create Result Vector
Length.Result = length(ResultVector);
if Patt == 'Z'                                                             % Zero Pattern
    PattVector = zeros(1, Length.Mask - 1);                                % Patt the Target Vector for conv
    PattTarget = cat(2, cat(2, PattVector, TargetVector), PattVector);
elseif Patt == 'M'                                                         % Mirror Pattern
    PattVector.L = ones(1, Length.Mask - 1) * TargetVector(1);             % Patt the Target Vector for conv
    PattVector.R = ones(1, Length.Mask - 1) * TargetVector(Length.Target);
    PattTarget = cat(2, cat(2, PattVector.L, TargetVector), PattVector.R);
end


%% Perform convolution
for TerminalIndex = Length.Mask:Length.Result + Length.Mask - 1            % First Conv Index to last
    ResultIndex = TerminalIndex - Length.Mask + 1;
    for ConvIndex = 1:TerminalIndex                                        % First element to First Conv Index
        ResultVector(ResultIndex) = ResultVector(ResultIndex) + ...
            PattTarget(ConvIndex) * MaskVector(ConvIndex);
    end
    MaskVector = cat(2,0,MaskVector);                                      % Move Mask Forward
end

%% Adjust Matrix Size for output
deltaLength = length(ResultVector) - Length.Target;
while(deltaLength ~= 0)
    ResultVector_Temp = zeros(1, length(ResultVector) - 2);
    if deltaLength > 0
        for index = 2:length(ResultVector) - 1
            ResultVector_Temp(index - 1) = ResultVector(index);
        end
        ResultVector =  ResultVector_Temp;
        deltaLength = length(ResultVector) - Length.Target;
    end
end


%% Check Matrix Orientation and convert to original
if Direction == 'V'
    ResultVector = ResultVector';
end


end