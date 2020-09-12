function A = fold(Ai, mod, l, m, n)
    dim1 = size(Ai,1);
    dim2 = size(Ai,2);
    A = zeros(l,m,n);
    vertikalni_stack = false;
    
    if mod == 1
        if vertikalni_stack
            % vertikalni stack matrica
            i = 1;
            j = 1;
            for t = 1:dim1
                if( i == l + 1 ) 
                    i = 1;
                    j = j + 1;
                end
                A(i,j,:) = Ai(t,:);
                i = i +1;
            end             
            return
        end
        
        %% Ovdje je dim1 == l, a dim2 == m*n
        %% Pravimo A tako da idemo po svim stupcima u Ai i kopiramo ih u A 
        %% tako da se k pove?ava u svakom koraku dok je < n, a j se pove?a 
        %% za jedan svaki put kad vratimo k na 1
        k = 1;
        j = 1;
        for t = 1:dim2
            if( k == n + 1 ) 
                k = 1;
                j = j + 1;
            end
            A(:,j,k) = Ai(:,t);
            k = k + 1;
        end 
        
        % petar
        %A = zeros(l,m,n);
        %for i = 1:n
        %    A(:,:,i) = Ai(:,((i-1)*m+1):((i-1)*m+m));
        %end
    elseif mod == 2
        if vertikalni_stack
            j = 1;
            k = 1;
            for t = 1:dim1
                if( j == m + 1 ) 
                    j = 1;
                    k = k + 1;
                end
                A(:,j,k) = Ai(t,:);
                j = j + 1;
            end  
            return 
        end
        %% Ovdje je dim1 == m, a dim2 == l*n
        %% Pravimo A tako da idemo po svim stupcima u Ai i kopiramo ih u A 
        %% tako da se i pove?ava u svakom koraku dok je < l, a k se pove?a 
        %% za jedan svaki put kad vratimo i na 1
        i = 1;
        k = 1;
        for t = 1:dim2
            if( i == l + 1 ) 
                i = 1;
                k = k + 1;
            end
            A(i,:,k) = Ai(:,t);
            i = i + 1;
        end
    elseif mod == 3
        if vertikalni_stack
            i = 1;
            k = 1;
            for t = 1:dim1
                if( k == n + 1 ) 
                    k = 1;
                    i = i + 1;
                end
                A(i,:,k) = Ai(t,:);
                k = k + 1;
            end  
            return 
        end
        
        %% Ovdje je dim1 == n, a dim2 == m*n
        %% Pravimo A tako da idemo po svim stupcima u Ai i kopiramo ih u A 
        %% tako da se j pove?ava u svakom koraku dok je < m, a i se pove?a 
        %% za jedan svaki put kad vratimo j na 1
        i = 1;
        j = 1;
        for t = 1:dim2
            if( j == m + 1 ) 
                j = 1;
                i = i + 1;
            end
            A(i,j,:) = Ai(:,t);
            j = j + 1;
        end
    end  
end
