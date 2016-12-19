%% Ben Cannon
function [UR, UL] = determine_control_pathfollow(z, L, waypoints)

xr = z(1); yr = z(2); theta = z(3);
% Get to beggining of path (TBA)

%Attempting with two waypoints, will make more later
prev_wp = waypoints(1,:); %previous waypoint
xprev = prev_wp(1);
yprev = prev_wp(2);
next_wp = waypoints(2,:);%next waypoint
xnext = next_wp(1);
ynext = next_wp(2);

% Adaptive lookahead distance (fig. 6 canadian paper)
LAhead = 1; %fixed lookahead distance
w = [xr-xprev, yr-yprev]; % vector from previous waypoint to robot
v = [xnext-xprev, ynext-yprev]; % vector from previous waypoint to next waypoint
bmag = abs(dot(w,v)/dot(v,v));
bx = xprev + bmag*v(1);
by = yprev + bmag*v(2);
b = [bx-xr, by-yr]; %Vector from robot to closest point on line
LAheadErr = sqrt((xr-bx)^2+(yr-by)^2);
LAheadAdapt = LAhead+LAheadErr;

% Create path between waypoints
% inc = 0.01; %increments between points
% Npoints = abs(v(1)+i*v(2))/inc; %how many points to break into CAREFUL THIS IS NOT A INTEGER;
% pathx = xprev:((abs(v(1)+i*v(2))*cos(angle(v(1)+i*v(2))))/Npoints):xnext;
% pathy = yprev:((abs(v(1)+i*v(2))*sin(angle(v(1)+i*v(2))))/Npoints):ynext;
% path = [pathx';pathy'];

% Find goal point
vg = sin(acos(abs(b(1)+i*b(2))/LAheadAdapt)); %How far up v your goal point is ISSUES WITH OPPOSITE DIRECTION OR NOT I THINK.  BELOW MAY BE UNNECESSARY MIGHT HAVE TO MULTIPLY BY PI AND IMPLEMENT BELOW
if(length(vg)==1)
    tmpPoint = [xprev+vg*cos(angle(v(1)+i*v(2))), yprev+vg*sin(angle(v(1)+i*v(2)))];
else
    tmpPoint1 = [xprev+vg(1)*cos(angle(v(1)+i*v(2))), yprev+vg(1)*sin(angle(v(1)+i*v(2)))];
    tmpPoint2 = [xprev+vg(2)*cos(angle(v(1)+i*v(2))), yprev+vg(2)*sin(angle(v(1)+i*v(2)))];
    tmpd1 = sqrt((tmpPoint1(1)-xnext)^2+(tmpPoint1(2)-ynext)^2);
    tmpd2 = sqrt((tmpPoint2(1)-xnext)^2+(tmpPoint2(2)-ynext)^2);
    if(tmpd1<tmpd2)
        tmpPoint = tmpPoint1;
        vg = vg(1);
    else
        tmpPoint = tmpPoint2;
        vg = vg(2);
    end
end


if(vg > abs(v(1)+i*v(2)))
    goalpoint = next_wp;
else
    goalpoint = tmpPoint;
end

% Case when robot is facing directly away from goal
%%%%%%%
% Case when robot is at the end or needs to wait
%%%%%%%

% Using pure pursuit to get to goal point
[UR, UL] = determine_control_pure_pursuit(z, goalpoint(1), goalpoint(2) , L);


end
