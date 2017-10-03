function getAllData(ImgStats, tResponse, nTarget, bin, fpOut)
% getAllData(ImgStats, tResponse, nTarget, bin, fpOut)
% Description: For selected bins export all data contained within those
% bins. 
%
%   Example:
%       tResponse = 'Epres';
%       nTarget   = 1;
%       bin       = [5,5,5;10,10,10];
%       fpOut     = '~/Dropbox/';
% Author: R. Calen Walshe The University of Texas at Austin (August 30, 2017)

nBins = size(bin, 1);
nEcc    = 1;

fid = fopen([fpOut, '/', tResponse, '_AllResponse_mean.txt'], 'w');

fprintf(fid, 'resp\tL\tC\tS\tPYRAMIDLVL\tTARGET\tIMGNR\n');

for l = 1:nEcc
    for m = 1:nTarget
        switch tResponse
            case 'Eabs'
                response = ImgStats.E;
            case 'Epres'
                response = ImgStats.Epres;
            case 'tMatch'
                response = ImgStats.tMatch(:,:,m);
            case 'L'
                response = ImgStats.L;
        end
        
        for i = 1:nBins
            patchIdx = ImgStats.patchIndex{m};
            patchIdx = patchIdx{bin(i,1), bin(i,2), bin(i,3)};

            [A, B] = ind2sub(size(ImgStats.L), patchIdx);

            natImgIdx = find(ImgStats.bNatural == 1);

            natPatIdx = patchIdx(find(ismember(B, natImgIdx) == 1));
            
            [X, Y] = ind2sub(size(ImgStats.L), natPatIdx);

            binResp = response(natPatIdx);
          
            nPatches = size(binResp,1);
            dimLab1 = repmat(bin(i,1),nPatches,1);
            dimLab2 = repmat(bin(i,2),nPatches,1);
            dimLab3 = repmat(bin(i,3),nPatches,1);
            ECC     = repmat(l, nPatches, 1);
            TARGET  = repmat(m, nPatches, 1);
            IMGNR   = Y;

            A = [binResp,...
                dimLab1,...
                dimLab2,...
                dimLab3,...
                ECC,...
                TARGET,...
                IMGNR]';           
            
            fprintf(fid, '%f\t%i\t%i\t%i\t%i\t%i\t%i\n', A);
        end
    end
end
clear('ImgStats');
fclose(fid);
end