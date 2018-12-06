function group_isomorphism = lie_group_isomorphism (x)
% global center_position
global globalpara;
% center_radius = globalpara.center_radius;
radius = norm(x);
position = x;
% if ((x(1)^2 + x(2)^2 + x(3)^2) ~= center_radius^2) 
%     print("ERROR: point is not on the sphere");
% else
    cos_beta = position(3)./ radius;
    sin_beta = sqrt(1 - cos_beta ^2);
    cos_alpha = position(1) / radius  / sin_beta;
    sin_alpha = position(2) / radius  / sin_beta;
    group_isomorphism = [cos_beta *cos_alpha  -sin_alpha   sin_beta * cos_alpha;
                         cos_beta *sin_alpha   cos_alpha   sin_beta *sin_alpha;
                                 -sin_beta            0        cos_alpha          ];
end