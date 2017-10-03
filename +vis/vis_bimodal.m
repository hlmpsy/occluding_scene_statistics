target   = Settings.targets(:,:,1);
envelope = Settings.envelope;

targetDC  = .183 * (2^14-1);
targetRMS = .33;

target(envelope) = (target(envelope) - mean(target(envelope))) ./ std(target(envelope)) .* targetDC * targetRMS + targetDC;

load('~/Dropbox/Calen/Dropbox/bimodal.mat')

figure;
for i = 1:100
    imgHigh  = saveBimodal(:,:,i,1);
    imgLow = saveBimodal(:,:,i,2);
    
    imgLowT  = lib.embedImageinCenter(imgLow, target, 0, 2^14-1, 0,0, envelope);
    imgHighT = lib.embedImageinCenter(imgHigh, target, 0, 2^14-1, 0,0, envelope);
    
    subplot(2,1,1);
    gradLow = vis.vis_gradient(imgLowT, envelope);
    lib.singlePatchEdgeNorm(imgLow, target, envelope, 1)
    axis square
    subplot(2,1,2);    
    gradHigh = vis.vis_gradient(imgHighT, envelope);
    lib.singlePatchEdgeNorm(imgHigh, target, envelope, 1)
    axis square    
    keyboard
end