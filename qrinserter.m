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
    xPos = 62;
    yPos = 89;
    qrDim = 355;
    
    % Insertion point coordinates code
    yPosCode = 705;
    xPosCode = 415;
    codeDim_w = 150;
    codeDim_h = 76;
    
    nHor = 5;
    nVer = 5;

    [tempheight, tempwidth, ~] = size(temp);
    final = zeros(3780,5315,3)*255;
    final = uint8(final);
    final_clean = final;
    final_front = uint8(final);
    
    insertionj = 50;
    
    for j = 1 : nHor
        insertionk = 200;
        for k = 1 : nVer
            final_front(insertionk:insertionk+tempheight-1,insertionj:insertionj+tempwidth-1,:) = temp_front;
            insertionk = insertionk + tempheight;
        end
        insertionj = insertionj + tempwidth;
    end
    
    imwrite(final_front,[pathCurrent '/output_pl/front.tif'],'Resolution', 300);
    
    fileCounter = 1;
    while fileCounter <= length(qrFiles)
        insertionj = 50;
        final = final_clean;
        for j = 1 : nHor
            if fileCounter > length(qrFiles)
                break;
            end
            insertionk = 200;
            for k = 1 : nVer
                if fileCounter > length(qrFiles)
                    break;
                end
                name = qrFiles(fileCounter).name;
                qr = imread([qrFiles(fileCounter).folder '/' qrFiles(fileCounter).name]);
                qr = 255 * repmat(uint8(qr), 1, 1, 3);
                code = imread([codeFiles(fileCounter).folder '/' [name(1:end-4) '-code.png']]);
                [height, width, ~] = size(qr);
                code = code (1:end,1:codeDim_w,:);
                
                if height ~= qrDim || width ~=  qrDim
                    qr = imresize(qr,[qrDim qrDim]);
                    % disp('Resizing QR...');
                end
                
                temp(xPos:xPos+qrDim-1,yPos:yPos+qrDim-1,:) = qr;
                temp(xPosCode:xPosCode+codeDim_h-1,yPosCode:yPosCode+codeDim_w-1,:) = code;
                
                final(insertionk:insertionk+tempheight-1,insertionj:insertionj+tempwidth-1,:) = temp;
                % imshow(final)
                
                fileCounter = fileCounter + 1;
                insertionk = insertionk + tempheight;
            end
            insertionj = insertionj + tempwidth;
        end
        
        imwrite(final,[pathCurrent '/output_pl/' sprintf('%04d',fileCounter-1) '.tif'],'Resolution', 300);
        disp(['<strong>' sprintf('%04d',fileCounter-1)  '</strong>: QR inserted and successfully saved! ' int2str(fileCounter-1) ' QRs saved out of ' int2str(length(qrFiles))])
    end
end
