function retraction = comp_retraction (position)
% compute retraction from 3D to SO(3)
% compute retraction point r(x_i) for each point on sphere 
%%% position = [x y z]
global globalpara % should include numUAV
center_position = globalpara.center_position.';
center_radius = globalpara.center_radius;
for i = 1:globalpara.numUAV
%     factor =  center_radius ./ sqrt(sum(position - center_position) .^ 2);
    factor =  center_radius / norm(position - center_position);
    retraction = factor * (position - center_position) + center_position;
end
end