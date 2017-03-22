function [opt,energy] = searchNeighbors( L,img,seq )
%Given the Li of root, search optimal Lj for head, left and right upper/lower arm in neighboring region
%Input: L is the Li for Torso which is the root of the tree, image and image sequence number
%Output: opt has L for all six parts, opt=[L_torso,L_head,L_left_upper_arm,L_right_upper_arm,
%L_left_lower_arm,L_right_lower_arm]

%readAnnotation is used for match_enery_cost, since this readAnnotation function costs much
%time and we only need to read annotation once for match_energy_cost(here I mean we don't need to 
%read annotation every time we call match_energy_cost), so we just move
%this readAnnotation function outside the match_energy_cost function
lF = ReadStickmenAnnotationTxt('../data/buffy_s5e2_sticks.txt'); 

[m,n]=size(img(:,:,1));
dy=[L.y-20*m/50:m/50:L.y]; % the center of head, upper arms are supposed to beyond the center of Torso 
dx=[L.x-7*n/50:n/50:L.x+7*n/50];
theta=[-pi:pi/20:pi-pi/20];
scale=[0.6:0.1:1.4]; % the scale of other parts should be similar to the scale of Torso
opt=[];
%initialize minimum values for left 5 parts
min=[2^31-1;2^31-1;2^31-1;2^31-1;2^31-1];
for i=1:length(dy)
    for j=1:length(dx)
        for p=1:length(theta)
            for q=1:length(scale)
                tempL.x=dx(j); tempL.y=dy(i); tempL.theta=theta(p); tempL.scale=scale(q);
                B_head=deformation_energy_cost(L,tempL,1,6)+match_energy_cost([dx(j),dy(i),theta(p),scale(q)],6,seq,lF);
                B_leftarm=deformation_energy_cost(L,tempL,1,2)+match_energy_cost([dx(j),dy(i),theta(p),scale(q)],2,seq,lF);
                B_rightarm=deformation_energy_cost(L,tempL,1,3)+match_energy_cost([dx(j),dy(i),theta(p),scale(q)],3,seq,lF);
                if(B_head<min(1))
                    min(1)=B_head; opt(1,1).x=dx(j); opt(1,1).y=dy(i); opt(1,1).theta=theta(p); opt(1,1).scale=scale(q);
                end
                if(B_leftarm<min(2))
                    min(2)=B_leftarm; opt(2,1).x=dx(j); opt(2,1).y=dy(i); opt(2,1).theta=theta(p); opt(2,1).scale=scale(q);
                end
                if(B_rightarm<min(3))
                    min(3)=B_rightarm; opt(3,1).x=dx(j); opt(3,1).y=dy(i); opt(3,1).theta=theta(p); opt(3,1).scale=scale(q);
                end
            end
        end
    end
end
opt=[L;opt];
%Based on the optimal location of left and right upper arms, search the L
%for left and right lower arms in neighboring regions
L_left_ua = opt(3);
dy=[L_left_ua.y-7*m/50:m/50:L_left_ua.y+7*m/50]; 
dx=[L_left_ua.x-7*n/50:n/50:L_left_ua.x+7*n/50];
for i=1:length(dy)
    for j=1:length(dx)
        for p=1:length(theta)
            for q=1:length(scale)
                tempL.x=dx(j); tempL.y=dy(i); tempL.theta=theta(p); tempL.scale=scale(q);
                B_lower_leftarm=deformation_energy_cost(L_left_ua,tempL,2,4)+match_energy_cost([dx(j),dy(i),theta(p),scale(q)],4,seq,lF);
                if(B_lower_leftarm<min(4))
                    min(4)=B_lower_leftarm; opt(5,1).x=dx(j); opt(5,1).y=dy(i); opt(5,1).theta=theta(p); opt(5,1).scale=scale(q);
                end
            end
        end
    end
end
L_right_ua = opt(4);
dy=L_right_ua.y-7*m/50:m/50:L_right_ua.y+7*m/50;
dx=L_right_ua.x-7*n/50:n/50:L_right_ua.x+7*n/50;
for i=1:length(dy)
    for j=1:length(dx)
        for p=1:length(theta)
            for q=1:length(scale)
                tempL.x=dx(j); tempL.y=dy(i); tempL.theta=theta(p); tempL.scale=scale(q);
                B_lower_rightarm=deformation_energy_cost(L_right_ua,tempL,3,5)+match_energy_cost([dx(j),dy(i),theta(p),scale(q)],5,seq,lF);
                if(B_lower_rightarm<min(5))
                    min(5)=B_lower_rightarm; opt(6,1).x=dx(j); opt(6,1).y=dy(i); opt(6,1).theta=theta(p); opt(6,1).scale=scale(q);
                end
            end
        end
    end
end
energy=match_energy_cost([opt(1).x,opt(1).y,opt(1).theta,opt(1).scale],1,seq,lF)+...
deformation_energy_cost(opt(1),opt(2),1,6)+match_energy_cost([opt(2).x,opt(2).y,opt(2).theta,opt(2).scale],6,seq,lF)+...
deformation_energy_cost(opt(1),opt(3),1,2)+match_energy_cost([opt(3).x,opt(3).y,opt(3).theta,opt(3).scale],2,seq,lF)+...
deformation_energy_cost(opt(1),opt(4),1,3)+match_energy_cost([opt(4).x,opt(4).y,opt(4).theta,opt(4).scale],3,seq,lF)+...
deformation_energy_cost(opt(3),opt(5),2,4)+match_energy_cost([opt(5).x,opt(5).y,opt(5).theta,opt(5).scale],4,seq,lF)+...
deformation_energy_cost(opt(4),opt(6),3,5)+match_energy_cost([opt(6).x,opt(6).y,opt(6).theta,opt(6).scale],5,seq,lF);
end

