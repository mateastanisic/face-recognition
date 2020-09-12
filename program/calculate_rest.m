%% Calculate conjugate second half
function A = calculate_rest( Ahalf, m, tensor_or_matrix )
   do_pola = m/2 + 1;
   if tensor_or_matrix == 1
       A = Ahalf;
       for i = do_pola + 1 : m
           A( :, i ) = conj(A( :, m - i + 2 ));
       end
   elseif tensor_or_matrix == 2
       A = Ahalf;
       for i = do_pola + 1 : m
           A( :, :, i ) = conj(A( :, :, m - i + 2 ));
       end 
   elseif tensor_or_matrix == 3
       A = Ahalf;
       for i = do_pola + 1 : m
           A{i} = conj(A{m - i + 2});
       end       
   end
end