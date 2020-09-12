%% Tensor SVD using tensor decompositions - method 2 
%
% Variable A is tensor with dimensions image_height x image_width x no. of
% images. Algorithm returns tensors tensors U, S and V, where for every i,
% matrix U(:, :, i) and V(:, :, i) are unitary and S(:, :, i) is diagonal.
%
function [A_, U_, S_] = tsvd_half(A)
    % FFT
    fftA = fft(A, [], 3);
    m = size(fftA, 3);
    do_pola = m/2 + 1;
    
    % SVD
    for i = 1 : do_pola
        [U1, S1, ~] = svd( fftA( :, :, i) );
        U_( :, :, i) = U1;
        S_( :, :, i) = S1;
    end
    
    % Calculate from m/2 to the end 
    U_ = calculate_rest( U_, m, 2);
    S_ = calculate_rest( S_, m, 2);
    
    % Inverse FFT
    A_ = ifft(fftA, [], 3);
    U = ifft(U_, [], 3); 
    S = ifft(S_, [], 3);
end