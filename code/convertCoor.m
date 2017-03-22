function end_points = convertCoor( L,part )
%convert L=[x,y,theta,scale] to end_points=[x11,y11,x21,y21]
model_len=[160,60,95,95,65,65];
R=[cos(L.theta),-sin(L.theta);sin(L.theta),cos(L.theta)];
end_points=zeros(1,4);
if(part==1)
temp=L.scale*R*[0;model_len(1)/2];
end
if(part==2)
temp=L.scale*R*[0;model_len(2)/2];
end
if(part==3)
temp=L.scale*R*[model_len(3)/2;0];
end
if(part==4)
temp=L.scale*R*[-model_len(4)/2;0];
end
if(part==5)
temp=L.scale*R*[model_len(5)/2;0];
end
if(part==6)
temp=L.scale*R*[-model_len(6)/2;0];
end
end_points(1)=L.x-temp(1);
end_points(2)=L.y-temp(2);
end_points(3)=L.x+temp(1);
end_points(4)=L.y+temp(2);
end

