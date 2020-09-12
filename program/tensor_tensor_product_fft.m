%% Tensor-Tensor Product, using Fourier Domain Computation
% Misha E. Kilmer and Carla D. Martin, 
% Factorization strategies for third-order tensors, Linear Algebra and
% its Applications
%
% When the tensors are dense, we could compute A * B by computing an 
% FFT along each tubal fiber of A and B to obtain A^ and B^, multiply 
% each pair of faces of A^ and B^ to get faces of tensor C^, then take
% an inverse FFT along the tubal fiber of ^ C to get the desired
% result.
%
% Complexity: ~ O(lpm)
%
% A is tensor with dimensions: l x p x n
% B is tensor with dimensions: p x m x n
% C is tensor with dimensions: l x m x n
%
function C = tensor_tensor_product_fft(A, B)
    A_ = fft(A, [], 3);
    B_ = fft(B, [], 3);

    for i = 1 : size(A_,3)
        C_(:, :, i) = A_(:, :, i) * B_(:, :, i);
    end
    
    C = ifft(C_, [], 3);
end