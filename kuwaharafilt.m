function J = kuwaharafilt(I, varargin)
%KUWAHARAFILT Kuwahara filtering of images
%
%  J = kuwaharafilt(I) filters image I with 5x5 window
%
%  J = kuwaharafilt(I, r) filters image I with specific filter size.
%  `r` specify the window radius (please see below). This value must be an
%  even number greater than 0.
%
%    Case 1                             Case 2
%    ------                             ------
%    r = 2                              r = 4
%    ( a  a  ab   b  b)                 ( a  a  a  a  ab   b  b  b  b)
%    ( a  a  ab   b  b)                 ( a  a  a  a  ab   b  b  b  b)
%    (ac ac abcd bd bd)                 ( a  a  a  a  ab   b  b  b  b)
%    ( c  c  cd   d  d)                 ( a  a  a  a  ab   b  b  b  b)
%    ( c  c  cd   d  d)                 (ac ac ac ac abcd bd bd bd bd)
%                                       ( c  c  c  c  cd   d  d  d  d)
%    window size: 5x5                   ( c  c  c  c  cd   d  d  d  d)
%    sub-window size: 3x3               ( c  c  c  c  cd   d  d  d  d)
%                                       ( c  c  c  c  cd   d  d  d  d)
%
%                                       window size: 9x9
%                                       sub-window size: 5x5
%
%  Note
%  ----
%    - `variances` contains the sum of variances for each image channel,
%    not the mean.
%    - Variance is calculated by the mean of the square minus the square of
%    the mean.
%
options = parseInputs(I, varargin{:});

r = options.FilterRadius;
swr = r / 2;        % sub-window radius
sws = 2 * swr + 1;  % sub-window size
sz = [size(I) 1];
paddedImage = padarray(double(I), [r r], 'replicate', 'both');

% calculate mean and variance using the integral image method
means = zeros([sz(1:2)+2*swr sz(3)]);
variances = zeros(sz(1:2)+2*swr);
for ch = 1:sz(3)
    iInt1 = integralImage(paddedImage(:, :, ch));
    iInt2 = integralImage(paddedImage(:, :, ch).^2);
    means(:, :, ch) = integralBoxFilter(iInt1, [sws sws]);
    variances = variances...
        + integralBoxFilter(iInt2, [sws sws]) - means(:, :, ch).^2;
end

% rearrange sub-window variances into the 3rd dimension.
vars3D = cat(3,...
    variances(1:sz(1), 1:sz(2)),... a
    variances(1:sz(1), sws:end),... b
    variances(sws:end, 1:sz(2)),... c
    variances(sws:end, sws:end)); % d

% find sub-window that has min variance
[~, minSub] = min(vars3D, [], 3);

% arrange lookup indices
[x, y] = meshgrid((1:sz(2))+swr, (1:sz(1))+swr);
subwinOffsets = [-1 1]*swr + [-1; 1]*swr*(sz(1)+2*swr);
lookupIndices = y + (x-1)*(sz(1)+2*swr) + subwinOffsets(minSub);
channelOffsets = (0:sz(3)-1) * prod(sz(1:2)+2*swr);
lookupIndices = lookupIndices + reshape(channelOffsets, [1 1 sz(3)]);

J = cast(means(lookupIndices), 'like', I);

end

function options = parseInputs(I, varargin)

narginchk(1, 2);

validateImage(I);

options = struct('FilterRadius', 2);
if nargin == 2
    options.FilterRadius = varargin{1};
    validateFilterRadius(varargin{1});
end

end

function validateImage(I)

supportedTypes = {...
    'uint8', 'uint16', 'uint32',...
    'int8', 'int16', 'int32', ...
    'single', 'double'};
supportedAttributes = {'real', 'nonsparse'};
validateattributes(I, supportedTypes, supportedAttributes, mfilename, 'I');

end

function validateFilterRadius(r)

if r < 2 || mod(r, 2) ~= 0
    error('`r` must be an even number greater than 0 (got %d)', r);
end

end
