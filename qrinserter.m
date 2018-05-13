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
qrFiles = dir([pathCurrent '/img/qrfiles/' qrFormat]);

if isempty(qrFiles)
    disp('<strong>>> Warning:</strong> QR directory is empty. Add your QR files to start.')
else
    % Import template
    temp = imread('img/template/temp.png');
    
    % Insertion point coordinates
    xPos = 218;
    yPos = 139;
    qrDim = 213;
    
    % QR insertion loop
    for i = 1 : length(qrFiles)
        qr = imread([qrFiles(i).folder '/' qrFiles(i).name]);
        [height, width, ~] = size(qr);
        
        if height ~= qrDim || width ~=  qrDim
            qr = imresize(qr,[qrDim qrDim]);
            disp('Resizing QR...');
        end
        
        temp(xPos:xPos+qrDim-1,yPos:yPos+qrDim-1,:) = qr;
        imwrite(temp,[pathCurrent '/output/' qrFiles(i).name]);
        disp(['<strong>' qrFiles(i).name  '</strong>: QR inserted and successfully saved!'])
    end
end
