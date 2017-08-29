function Estats = computeSceneEdgePres(imIn, target, envelope, sampleCoords)
%%COMPUTESCENEEDGE Computes the edge response at pixel values in the image.
%
% Example:
%   Sstats = COMPUTESCENEEDGE(imIn, tarIn, wWin, sampleCoords)
%
% Output:
%   Sstats.E:         edge response
%
%   See also BINIMAGESTATS, COMPUTESCENESTATS.
%
% v1.0, 6/5/2017, R. Calen Walshe <calen.walshe@gmail.com>

%% Compute Similarity
%% Variable set up

ganglionSampR = 120;
PPD           = 120;
edgeG              = lib.getGaussianDerivative(ganglionSampR, PPD);

%%
patchSz  = 41;
nSamples = size(sampleCoords, 1);
edgeX    = edgeG(:,:,1);
edgeY    = edgeG(:,:,2);

%% Vector norm compute
[normX, normY] = lib.getNormalVector(patchSz, envelope, ganglionSampR, PPD);

%% Boundary
boundary   = occluding_model.lib.getBoundary(envelope);
boundary   = lib.embedImageinCenter(zeros(patchSz, patchSz), boundary, 1, 8, 0, 0, envelope);
nBoundary  = 56; %sum(boundary(:) > 0);

targetDC  = .183 * (2^16-1);
targetRMS = .33;

target(envelope) = (target(envelope) - mean(target(envelope))) ./ std(target(envelope)) .* targetDC * targetRMS + targetDC;

%% Compute Similarity at each location in sampleCoords.
for sItr = 1:nSamples
    imgSmall = lib.cropImage(imIn, sampleCoords(sItr,:), patchSz, [], 1);
    imgSmall = lib.embedImageinCenter(imgSmall, target, 0, 2^16-1, 0,0, envelope);

    im_x = lib.fftconv2(imgSmall(:,:,1), edgeX);
    im_y = lib.fftconv2(imgSmall(:,:,1), edgeY);

    gradNorm   = sqrt(im_x.^2 + im_y.^2);

    im_cos_angle = abs(im_x .* normX + im_y .* normY)./gradNorm;
    
    im_cos_angle(isnan(im_cos_angle(:))) = 0;

    tCos = sum((im_cos_angle(:) .* boundary(:))) ./ nBoundary;   

    Estats.Epres(sItr) = tCos;   
end
end
