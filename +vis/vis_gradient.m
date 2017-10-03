%% function hFig = visualizeGradient(img, boundary)
% Description: The function returns a figure handle. The figure contains an
% image with arrows representing the gradient at the location corresponding
% to the boundary of the target.
function hFig = vis_gradient(im, envelope)
    ganglionSampR = 120;
    PPD           = 60;

    edgeG           = lib.getGaussianDerivative(ganglionSampR, PPD);

    patchSz = 41;
    edgeX    = edgeG(:,:,1);
    edgeY    = edgeG(:,:,2);

    boundary   = occluding_model.lib.getBoundary(envelope);
    boundary      = lib.embedImageinCenter(zeros(patchSz, patchSz), boundary, 1, 8, 0, 0, envelope);
    
    im_x = conv2(im(:,:,1), edgeX, 'same');
    im_y = conv2(im(:,:,1), edgeY, 'same');    
    
    gradNorm   = sqrt(im_x.^2 + im_y.^2);    
    
    gradX = (im_x ./ gradNorm);
    gradY = (im_y ./ gradNorm);
    
    gradX(~boundary) = 0;
    gradY(~boundary) = 0;    
    
    [bX, bY] = find(boundary == 1);
    
    im = sqrt(im ./ (2^14 -1)) * (2^14 - 1);
    imagesc(im, [0, (2^14-1)]); colormap('gray');    
   
    drawArrow = @(x,y) quiver(x(1),y(1),x(2)-x(1),y(2)-y(1),0);    
    
    hold on;
    
    for i = 1:length(bX)
        h = drawArrow([bX(i), bX(i) + gradX(bY(i), bX(i))],[bY(i), bY(i) + gradY(bY(i), bX(i))]);        
    end    
    
   hFig = h;    
end

