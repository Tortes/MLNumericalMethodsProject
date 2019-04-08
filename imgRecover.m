function imgOut = imgRecover(imgIn, blkSize, numSample)
% Recover the input image from a small size samples
%
% INPUT:
%   imgIn: input image
%   blkSize: block size
%   numSample: how many samples in each block
%
% OUTPUT:
%   imgOut: recovered image
%
% @ 2011 Huapeng Zhou -- huapengz@andrew.cmu.edu
[L_raw, W_raw] = size(imgIn);
L_block = L_raw / blkSize;
W_block = W_raw / blkSize;

%Store Img in block (blk*blk, pixels)
blockImg = zeros(L_block*W_block, blkSize*blkSize);
n=1;
for i=1:blkSize:L_raw
    for j=1:blkSize:W_raw
        patch = imgIn(i:i+blkSize-1, j:j+blkSize-1);
        blockImg(n,:) = patch(:);
        n=n+1;
    end
end

%calc the coef matrix
% coefMatrix = dctmtx(blkSize);
coefMatrix = zeros(blkSize*blkSize, blkSize*blkSize);
for a = 1:blkSize*blkSize
    %Calc the raw coordinate of a b
    %a -> x = a%cellLength
    %     y = a/cellLength + 1
    %b -> u = b%cellWidth
    %     v = b/cellWidth + 1
    x = floor(a/blkSize) + 1;
    y = max(mod(a, blkSize),1);
    
    for b = 1:blkSize*blkSize
        u = floor(b/blkSize) + 1;
        v = max(mod(b, blkSize),1);
        
        if u == 1
            au = sqrt(1/blkSize);
        else
            au = sqrt(2/blkSize);
        end

        if v == 1   
            bv = sqrt(1/blkSize);
        else
            bv = sqrt(2/blkSize);
        end

        coefMatrix(a,b) = au*bv*cos((pi*(2*x-1)*(u-1)/(2*blkSize)))*cos((pi*(2*y-1)*(v-1)/(2*blkSize)));
    end
end


%OMP and cross val
imgRecover = zeros(L_block*W_block, blkSize*blkSize);
valLength = floor(numSample/6);
trainLength = numSample - valLength;

for blk = 1:L_block*W_block
    %sample
    Index = sort(randsample(blkSize*blkSize, numSample));   %Generate random index of each block
    Img_block = blockImg(blk, :);   %The sample image of each block
    % Img_sample = blockImg(blk, Index);
    % coefMatrix_sample = coefMatrix(Index, :);
    errorArray = zeros(trainLength-4, 1);
    for lambda = 5:trainLength
        for iter = 1:20
            Index_iter = sort(randsample(numSample, trainLength));  %Generate random index of the Index
            Index_train = Index(Index_iter);    % Generate the index of train 
            Index_val = Index;
            Index_val(Index_iter) = [];         % Generate the index of val
            % DCT_coef = OMP(coefMatrix_sample(Index_train, :), Img_train.', lambda);
            % DCT_coef = OMP_ren(Img_block(Index_train).', coefMatrix(Index_train, :), blkSize, lambda);
            DCT_coef = OMP_ren(blockImg(blk, Index_train).', coefMatrix(Index_train, :), blkSize, lambda);
            eps1 = coefMatrix(Index_val,:)*DCT_coef - Img_block(Index_val).';
            errorArray(lambda-4) = errorArray(lambda-4) + sum(eps1.^2)/valLength;
        end
    end
    [minlambda, lambda] = min(errorArray);
    % DCT = OMP_ren(Img_block.', coefMatrix, blkSize, lambda + 4);
    DCT = OMP_ren(Img_block(1,Index).', coefMatrix(Index, :), blkSize, lambda + 4);
    imgRecover(blk, :) = coefMatrix * DCT;
    [blk, lambda + 4]
end

%Resize
imgOut = zeros(L_raw, W_raw);
n=1;
for i=1:blkSize:L_raw
    for j=1:blkSize:W_raw
        imgOut(i:i+blkSize-1,j:j+blkSize-1) = reshape(imgRecover(n,:),blkSize,blkSize);
        n=n+1;
    end
end
imgOut = medfilt2(imgOut, [3,3]);
end
