%% HOSVD
% Higher order SVD
function [S, U1, U2] = hosvd(A)
    l = size(A,1);
    m = size(A,2);
    n = size(A,3);
    
    A1 = unfold(A,1);
    A2 = unfold(A,2);
    A3 = unfold(A,3);

    [U1,~,~] = svd(A1);
    [U2,~,~] = svd(A2);
    [U3,~,~] = svd(A3);
    
    S = fold(U1' * A1, 1, l, m, n);
    S = fold(U2' * unfold(S,2), 2, l, m, n);
    S = fold(U3' * unfold(S,3), 3, l, m, n);
end