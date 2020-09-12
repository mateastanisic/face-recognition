function Ai = unfold(A,mod)
    l = size(A,1);
    m = size(A,2);
    n = size(A,3);
    vertikalni_stack = false;
    
    if mod == 1
        if vertikalni_stack 
            % vertikalni stack
            Ai = reshape(A(:,1,:), l, n);
            for t = 2:m
                Ai = [ Ai; reshape(A(:,t,:), l, n) ];
            end 
            Ai = reshape(Ai,l*m,n);  
            return
        end

        %horizontalni stack
        Ai = reshape(A(:,1,:),n*l, 1);
        for t = 2:m
            Ai = [ Ai; reshape(A(:,t,:),n*l, 1) ];
        end 
        Ai = reshape(Ai,l,n*m) ;
        
        %petar
        %Ai = zeros(l, m*n);
        %for i = 1 : m
        %   tempMat = A(:,i,:);
        %   for j = 1 : n
        %       Ai(:,(j-1)*m+i) = tempMat(:,:,j);
        %   end
        %end        
    elseif mod == 2
        if vertikalni_stack
             Ai = reshape(A(:,:,1)', m, l);
            for t = 2:n
                Ai = [ Ai; reshape(A(:,:,t)', m, l) ];
            end 
            Ai = reshape(Ai,m*n,l); %zbog transponiranja       
            return
        end
        
        Ai = reshape(A(:,:,1)',l*m, 1);
        for t = 2:n
            Ai = [ Ai; reshape(A(:,:,t)',l*m, 1) ];
        end 
        Ai = reshape(Ai,m,l*n); %zbog transponiranja  
    elseif mod == 3
        if vertikalni_stack
            Ai = reshape(squeeze(A(1,:,:))', n, m);
            for t = 2:l
                Ai = [ Ai; reshape(squeeze(A(t,:,:))', n, m) ];
            end 
            Ai = reshape(Ai,n*l,m); %zbog transponiranja      
           return 
        end
        
        Ai = reshape(squeeze(A(1,:,:))',m*n,1);
        for t = 2:l
            Ai = [ Ai; reshape(squeeze(A(t,:,:))',m*n,1) ];
        end 
        Ai = reshape(Ai,n,m*l); %zbog transponiranja
    end  
end
