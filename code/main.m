img=imread('../buffy_s5e2_original/001143.jpg');
seq = 16;
tic
%search top 5 possible L for Torso which gives top 5 minimum macthing cost
possible_L_Torso = searchTorso(img,seq);

%search other parts base on the Torso root
min_energy=2^31-1;
for i=1:length(possible_L_Torso)
    [opt,energy]=searchNeighbors(possible_L_Torso(i),img,seq);
    if(energy<min_energy)
        min_energy=energy;
        opt_L_all=opt;
    end
end

%draw the pose
%figure(1); imshow(img); hold on;
sticks=[];
for i=1:length(opt_L_all)
sticks(:,i)=convertCoor(opt_L_all(i),i);%convert L to endpoints
end
DrawStickman(sticks,img);
toc