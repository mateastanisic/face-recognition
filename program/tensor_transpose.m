%% Tensor transpose
% 
% If A is tensor with dimensions l x m x n, then transposed tensor A_ has
% dimensions m x l x n and is created so that every frontal slice of tensor
% A is transposed and the order of frontal slices is shift for 1.
%
function A_ = tensor_transpose(A)
    [l, m, n] = size(A);

    A_ = zeros(m, l, n);
    A_( :, :, 1) = A( :, :, 1)';
    
    j = n;
    for i = 2 : n
       A_( :, :, i) = A( :, :, j)';
       j = j - 1;
    end

end