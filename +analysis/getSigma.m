function tSigma = getSigma(ImgStats, tResponse, nTarget, fpOut)
% tSigma = getCombined_tSigma()
% Description: Take all image databases that have been blurred and
% downsampled. Get the standard deviation of the template response and
% store it in a matrix, print it to a file.
%
% Example: 
% tResponse = 'Epres';
% nTarget   = 4;
% fpOut = '~/Dropbox/Calen/Dropbox/';
%
% Author: R. Calen Walshe The University of Texas at Austin (November 17,
% 2016)

if nargin < 2
    error('Not enough parameters');    
end

nBinDim = 10;
nEcc    = 1;

tSigma = zeros(nBinDim, nBinDim, nBinDim,nTarget,nEcc);
tMean = zeros(nBinDim, nBinDim, nBinDim,nTarget,nEcc);

fidMean = fopen([fpOut, '/', tResponse, '_mean.txt'], 'w');
fidSigma = fopen([fpOut, '/', tResponse, '_sigma.txt'], 'w');

fprintf(fidMean, 'tSigma\tL\tC\tS\tPYRAMIDLVL\tTARGET\n');
fprintf(fidSigma, 'tSigma\tL\tC\tS\tPYRAMIDLVL\tTARGET\n');

for l = 1:nEcc
    for m = 1:nTarget        
        target = ImgStats.Settings.targets(:,:,m);
        switch tResponse
            case 'Eabs'
                response = ImgStats.E;
                tNorm = 1;
            case 'Epres'
                response = ImgStats.Epres(:,:,m);
                tNorm = 1;
            case 'tMatch'
                response = ImgStats.tMatch(:,:,m);
                tNorm = sum(target(:) .* target(:));
            case 'L'
                response = ImgStats.L;
        end
        
        for i = 1:nBinDim
            for j = 1:nBinDim
                for k = 1:nBinDim      
                    patchIdx = ImgStats.patchIndex{m};
                    patchIdx = patchIdx{i, j, k};                      
                    
                    [X, Y] = ind2sub(size(ImgStats.L), patchIdx);
                    
                    natImgIdx = find(ImgStats.bNatural == 1);
                    
                    natPatIdx = patchIdx(find(ismember(Y, natImgIdx) == 1));
                    binResp   = response(natPatIdx);
                    
                    tMean(i,j,k,m,l) = mean(binResp./tNorm);
                    tSigma(i,j,k,m,l) = std(binResp./tNorm);     
                                                                     
                    fprintf(fidMean, '%f\t%i\t%i\t%i\t%i\t%i\n', tMean(i, j, k, m, l), i, j, k, l, m);
                    fprintf(fidSigma, '%f\t%i\t%i\t%i\t%i\t%i\n', tSigma(i, j, k, m, l), i, j, k, l, m);
                end                
            end            
        end        
    end
end
clear('ImgStats');
fclose(fidMean);
fclose(fidSigma);
end