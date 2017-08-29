function kernelXY = getGaussianDerivative(ganglionSampling, PPD)
% Description: Compute edge detection kernels based on first derivative
% Gaussian filters.
%
% Author: R. Calen Walshe (November 23, 2016)

kernelSD    = 1/ganglionSampling * PPD;
kernelWidth = floor(5 * kernelSD);

kernelXY = zeros(kernelWidth*2 + 1, kernelWidth*2+1, 2);

[XX, YY] = meshgrid([(-kernelWidth):0,(1:kernelWidth)], [(-kernelWidth):1:0,(1:kernelWidth)]);

g_x_y    = - (XX./kernelSD) .* exp( -(XX.^2 + YY.^2) ./ (2 * kernelSD).^2);
g_y_x    = - (YY./kernelSD) .* exp( -(XX.^2 + YY.^2) ./ (2 * kernelSD).^2);

kernelXY(:,:,1) = g_x_y;
kernelXY(:,:,2) = g_y_x;

end