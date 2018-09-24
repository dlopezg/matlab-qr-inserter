%% HATMEN (qrinserter.m)
% -------------------------------------------------------------------------
% This script insert all the QR codes located in 'img/qrfiles/' folder
% into a new image (based on the template) at the specified insertion
% point. The program will generate as many images as the number of QR
% codes found.

% HOWTO -  INSTRUCTIONS
% 1. Paste all your QR codes in the 'img/qrfiles/' folder
% 2. Press RUN
% 3. Check out the output folder and ENJOY
% -------------------------------------------------------------------------
%

clc
clear variables

[~,struc] = fileattrib;
pathCurrent = struc.Name;
qrFormat = '*.png';
codeFormat = '*.png';
qrFiles = dir([pathCurrent '/img/qrs/' qrFormat]);
codeFiles = dir([pathCurrent '/img/codes/' codeFormat]);

if isempty(qrFiles)
    disp('<strong>>> Warning:</strong> QR directory is empty. Add your QR files to start.')
else
    % Import template
    temp = imread('img/template/back.png');
    temp_front = imread('img/template/front.png');
    
    % Insertion point coordinates
    xPos = 49;
    yPos = 77;
    qrDim = 355;
    
    % Insertion point coordinates code
    yPosCode = 690;
    xPosCode = 420;
    codeDim_w = 150;
    codeDim_h = 76;
    
    [tempheight, tempwidth, ~] = size(temp);
    
    for i = 1 : length(qrFiles)
        name = qrFiles(i).name;
        qr = imread([qrFiles(i).folder '/' qrFiles(i).name]);
        qr = 255 * repmat(uint8(qr), 1, 1, 3);
        code = imread([codeFiles(i).folder '/' [name(1:end-4) '-code.png']]);
        [height, width, ~] = size(qr);
        code = code (1:end,1:codeDim_w,:);
        
        if height ~= qrDim || width ~=  qrDim
            qr = imresize(qr,[qrDim qrDim]);
        end
        
        temp(xPos:xPos+qrDim-1,yPos:yPos+qrDim-1,:) = qr;
        temp(xPosCode:xPosCode+codeDim_h-1,yPosCode:yPosCode+codeDim_w-1,:) = code;
        
        % imwrite(temp_front,[pathCurrent '/output/front/' sprintf('%04d',i) '.png']);
        imwrite(temp,[pathCurrent '/output/back/' sprintf('%04d',i) '.png']);
        
        disp(['<strong>' sprintf('%04d',i)  '</strong>: QR inserted and successfully saved! ' int2str(i) ' QRs saved out of ' int2str(length(qrFiles))])
    end
end
