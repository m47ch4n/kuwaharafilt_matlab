# kuwaharafilt_matlab [![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/m47ch4n/kuwaharafilt_matlab/blob/master/LICENSE) [![View Kuwahara filtering of images on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://jp.mathworks.com/matlabcentral/fileexchange/79024-kuwahara-filtering-of-images)

This is an implementation of the Kuwahara filter for MATLAB. It supports color and grayscale images that are real and non-sparse. In addition, it has been optimized by calculation using the integral images and devising the data access.

<img alt="example_out.png" src="https://github.com/m47ch4n/kuwaharafilt_matlab/blob/e62b88939bd9752dac2d00a7a736af0e1591dc04/example_out.png?raw=true" width="100%" />

## Reqirements
- R2015b or later
- Image Processing Toolbox

## Usage

```matlab
J = kuwaharafilt(I);
% filters image I with 5x5 window
% equivalent to `kuwaharafilt(I, 2)`

J = kuwaharafilt(I, r)
% filters image I with specific filter size.
% `r` specify the window radius. This value must be an even number greater than 0.
```
