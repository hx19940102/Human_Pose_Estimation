function cost = deformation_energy_cost( Li,Lj,part_i,part_j )
%deformation energy cost of li and lj
%Input: Li and part_index_i, Lj and part_index_j
%Output: Energy cost value
R_i=[cos(Li.theta), -sin(Li.theta);sin(Li.theta), cos(Li.theta)];
R_j=[cos(Lj.theta), -sin(Lj.theta);sin(Lj.theta), cos(Lj.theta)];
w_theta=0.1;%weight for theta is a small value
w_scale=5; w_x=5; w_y=5;
% Torso and Head
if(part_i==1&&part_j==6)
    temp=Li.scale*R_i*[0;-87.5]+[Li.x;Li.y];
    x_i=temp(1); y_i=temp(2);
    temp=Lj.scale*R_j*[0;37.5]+[Lj.x;Lj.y];
    x_j=temp(1); y_j=temp(2);
    cost=w_theta*abs(Li.theta-Lj.theta)+w_scale*abs(log2(Li.scale)-log2(Lj.scale))+w_x*abs(x_i-x_j)+w_y*abs(y_i-y_j);
end
% Torso and Left upper arm
if(part_i==1&&part_j==2)
    temp=Li.scale*R_i*[-50;-60]+[Li.x;Li.y];
    x_i=temp(1); y_i=temp(2);
    temp=Lj.scale*R_j*[57.5;0]+[Lj.x;Lj.y];
    x_j=temp(1); y_j=temp(2);
    cost=w_theta*abs(Li.theta-Lj.theta)+w_scale*abs(log2(Li.scale)-log2(Lj.scale))+w_x*abs(x_i-x_j)+w_y*abs(y_i-y_j);
end
% Torso and Right upper arm
if(part_i==1&&part_j==3)
    temp=Li.scale*R_i*[50;-60]+[Li.x;Li.y];
    x_i=temp(1); y_i=temp(2);
    temp=Lj.scale*R_j*[-57.5;0]+[Lj.x;Lj.y];
    x_j=temp(1); y_j=temp(2);
    cost=w_theta*abs(Li.theta-Lj.theta)+w_scale*abs(log2(Li.scale)-log2(Lj.scale))+w_x*abs(x_i-x_j)+w_y*abs(y_i-y_j);
end
% Left Lower arm - upper arm
if(part_i==2&&part_j==4)
    temp=Li.scale*R_i*[-52.5;0]+[Li.x;Li.y];
    x_i=temp(1); y_i=temp(2);
    temp=Lj.scale*R_j*[37.5;0]+[Lj.x;Lj.y];
    x_j=temp(1); y_j=temp(2);
    cost=w_theta*abs(Li.theta-Lj.theta)+w_scale*abs(log2(Li.scale)-log2(Lj.scale))+w_x*abs(x_i-x_j)+w_y*abs(y_i-y_j);
end
% Right Lower arm - upper arm
if(part_i==3&&part_j==5)
    temp=Li.scale*R_i*[52.5;0]+[Li.x;Li.y];
    x_i=temp(1); y_i=temp(2);
    temp=Lj.scale*R_j*[-37.5;0]+[Lj.x;Lj.y];
    x_j=temp(1); y_j=temp(2);
    cost=w_theta*abs(Li.theta-Lj.theta)+w_scale*abs(log2(Li.scale)-log2(Lj.scale))+w_x*abs(x_i-x_j)+w_y*abs(y_i-y_j);
end
end

