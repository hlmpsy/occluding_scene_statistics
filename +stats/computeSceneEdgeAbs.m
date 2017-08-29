function StatsOut = computeSceneEdgeAbs(imIn, envelope, sampleCoords)
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

edgeG           = lib.getGaussianDerivative(ganglionSampR, PPD);

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

%% Compute Similarity at each location in sampleCoords.
for sItr = 1:nSamples

    imgSmall       = lib.cropImage(imIn, sampleCoords(sItr,:), patchSz, [], 1);
    
    im_x = lib.fftconv2(imgSmall(:,:,1), edgeX);
    im_y = lib.fftconv2(imgSmall(:,:,1), edgeY);

    gradNorm   = sqrt(im_x.^2 + im_y.^2);

    im_cos_angle = (im_x .* normX + im_y .* normY)./gradNorm;
    
    im_cos_angle(isnan(im_cos_angle(:))) = 0;

    tCos = sum(abs(im_cos_angle(:) .* boundary(:))) ./ nBoundary;
    
    tCos(isnan(tCos(:))) = 0;

    StatsOut.Eabs(sItr) = tCos;   
end
end
