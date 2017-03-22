function possible_L_Torso = searchTorso(img,seq)
%Divide the image to 50*50 small buckets,search best theta, scale for Torso part in every small bucket
%Input: image and image sequence number 
%Output: the top 5 possible L for Torso which gives top 5 minimum macthing cost
[m,n]=size(img(:,:,1));

%readAnnotation is used for match_enery_cost, since this readAnnotation function costs much
%time and we only need to read annotation once for match_energy_cost(here I mean we don't need to 
%read annotation every time we call match_energy_cost), so we just move
%this readAnnotation function outside the match_energy_cost function
lF = ReadStickmenAnnotationTxt('../data/buffy_s5e2_sticks.txt'); 

box_y=[m/100:m/50:m-m/100];
box_x=[n/100:n/50:n-n/100];
theta=[-pi/4:pi/40:pi/4];
scale=[0.6:0.1:1.4];
%first find optimal theta and scale for each divided bucket
locations=[]; mins=[];
for i=1:length(box_y)
    for j=1:length(box_x)
        locations(i,j).x=box_x(j); locations(i,j).y=box_y(i);
        mins(i,j)=2^31-1; %initialize minimum cost as a large value
        for p=1:length(theta)
            for q=1:length(scale)
                L=[box_x(j),box_y(i),theta(p),scale(q)];
                temp_cost=match_energy_cost(L,1,seq,lF);
                if(temp_cost<mins(i,j))
                    mins(i,j)=temp_cost;
                    locations(i,j).theta=theta(p);
                    locations(i,j).scale=scale(q);
                end
            end
        end
    end
end   
%second get the top 5 bucket gives minimum matching cost with their optimal theta and scale
locations=reshape(locations,2500,1);
mins=reshape(mins,2500,1);
[Y,I]=sort(mins,1,'ascend');
possible_L_Torso=locations(I(1:5,1));
end

