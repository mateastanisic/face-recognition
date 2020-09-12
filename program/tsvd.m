%% Tensor SVD using tensor decompositions
%
% Variable A is tensor with dimensions image_height x image_width x no. of
% images. Algorithm returns tensors tensors U, S and V, where for every i,
% matrix U(:, :, i) and V(:, :, i) are unitary and S(:, :, i) is diagonal.
%
function U = tsvd(A)
    % FFT
    A_ = fft(A, [], 3);

    % SVD
    for i = 1 : size( A_, 3 )
        [U1, ~, ~] = svd( A_( :, :, i) );
        U_( :, :, i) = U1;
    end
    
    % inverse FFT
    U = ifft(U_, [], 3); 
end
