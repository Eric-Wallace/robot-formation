function goal_angle = findGoalAngle(xr, yr, xg, yg)
    if(xr==yr&&xg==yg)
        goal_angle = 0;
    else
        goal_angle = atan((yg-yr)/(xg-xr)); %Tested and atan is fine with inf or -inf
        if((xg-xr)<0) %atan is only defined from [-pi/2, pi/2] this gets other half of plane
            goal_angle = goal_angle + pi();
        end
        if(goal_angle<0) % ensures that value is in [0, 2pi] range
            goal_angle=goal_angle+2*pi();
        end
    end
end