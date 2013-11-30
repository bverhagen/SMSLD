function lines = detectAllLines(image)
% This function is an interface to the line segment detector. This
% interface is used for MSLD and derivatives.

% Add path to line segment detector to search path
current_path = mfilename('fullpath');
[path,~,~] = fileparts(current_path);
path_to_add = [path, '/lsd-1.5/'];
addpath(path_to_add);

% standard LSD parameters
scale = 1;       %/* Scale the image by Gaussian filter to 'scale'. */
sigma_scale = 0.6; %/* Sigma for Gaussian filter is computed as sigma = sigma_scale/scale.                    */
quant = 2.0;       %/* Bound to the quantization error on the gradient norm.                                */
ang_th = 22.5;     %/* Gradient angle tolerance in degrees.           */
eps = 0;        % /* Detection threshold, -log10(NFA).              */
density_th = 0.7;  %/* Minimal density of region points in rectangle. */
n_bins = 1024;      %/* Number of bins in pseudo-ordering of gradient modulus.                                       *
max_grad = 255.0;  %/* Gradient modulus in the highest bin. The default value corresponds to the highest gradient modulus on images with gray levels in [0,255].                             */

% scale = 0.8;       %/* Scale the image by Gaussian filter to 'scale'. */
% sigma_scale = 0.6; %/* Sigma for Gaussian filter is computed as sigma = sigma_scale/scale.                    */
% quant = 2.0;       %/* Bound to the quantization error on the gradient norm.                                */
% ang_th = 22.5;     %/* Gradient angle tolerance in degrees.           */
% eps = 0;        % /* Detection threshold, -log10(NFA).              */
% density_th = 0.7;  %/* Minimal density of region points in rectangle. */
% n_bins = 1024;      %/* Number of bins in pseudo-ordering of gradient modulus.                                       *
% max_grad = 255.0;  %/* Gradient modulus in the highest bin. The default value corresponds to the highest gradient modulus on images with gray levels in [0,255].                             */

image_path = 'im.pgm';
imwrite(image,image_path,'pgm');
image = imread(image_path);
lines = lsd(double(image),scale,sigma_scale,quant,ang_th,eps,density_th,n_bins,max_grad);

% Change lines to a better format with cells.
lines = mat2cell(lines,ones(size(lines,1),1),5);
lines = cellfun(@parseLines,lines,'UniformOutput',false);
end

function parsedLine = parseLines(line)
parsedLine = zeros(2,2);
if(line(2) <= line(4))
    parsedLine(1,:) = line([2,1]);
    parsedLine(2,:) = line([4,3]);
else
    parsedLine(2,:) = line([2,1]);
    parsedLine(1,:) = line([4,3]);
end
end