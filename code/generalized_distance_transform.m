function D = generalized_distance_transform(img,part)
[y,x]=size(img(:,:,1));
seq = 1;
disc_x = [x/60 : x/30 : x-x/60];
disc_y = [y/60 : y/30 : y-y/60];
disc_theta = [-pi/4 : pi/(2*19) : pi/4];
disc_scale = [0.5 : 1/9 : 1.5];

k_x = 1;
k_y = 1;
k_theta = 1; 
k_scale = 1;

D = ones(length(disc_x),length(disc_y),length(disc_theta),length(disc_scale));

%Initialize D with f(w) = m_j(I,l_j) for leaf nodes;
%    
lF = ReadStickmenAnnotationTxt('../data/buffy_s5e2_sticks.txt');
for i = 1:length(disc_x)
    for j = 1:length(disc_y)
        for k = 1:length(disc_theta)
            for l = 1:length(disc_scale)
                L = [disc_x(i),disc_y(j),disc_theta(k),disc_scale(l)];
                match_cost = match_energy_cost(L,part,seq,lF);
                D(i,j,k,l) = match_cost;
            end
        end
    end
    display(match_cost);
end

%Forward Pass 
for i = 2:length(disc_x)
    for j = 2:length(disc_y)
        for k = 2:length(disc_theta)
            for l = 2:length(disc_scale)
                D(i,j,k,l) = min([D(i,j,k,l),...
                                 D(i-1,j,k,l) + k_x,...
                                 D(i,j-1,k,l) + k_y,...
                                 D(i,j,k-1,l) + k_theta,...
                                 D(i,j,k,l-1) + k_scale]);
            end
        end
    end
end
display('Done Forward');
%Backward Pass
for i = length(disc_x)-1:1
    for j = length(disc_y)-1:1
        for k = length(disc_theta)-1:1
            for l = length(disc_scale)-1:1
                D(i,j,k,l) = min([D(i,j,k,l),...
                                 D(i+1,j,k,l) + k_x,...
                                 D(i,j+1,k,l) + k_y,...
                                 D(i,j,k+1,l) + k_theta,...
                                 D(i,j,k,l+1) + k_scale]);
            end
        end
    end
end
display('Done Backward');

end
