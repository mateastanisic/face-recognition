%% Tensor (pivoted) QR decomposition of A
function Q = tqr(A)
    A_ = fft(A, [], 3);
    
    [Qi, ~, P] = qr( squeeze( A_(:, :, 1) ) );
    Q_( :, :, 1 ) = Qi;
    
    for i = 2 : size(A_, 3)
        [Qi, ~] = qr( squeeze( A_(:, :, i) ) * P );
        Q_( :, :, i) = Qi;
    end
    
    Q = ifft(Q_, [], 3);
end
