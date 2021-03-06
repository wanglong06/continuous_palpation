function send_trajectory_relative(positions,robot)
%SEND_TRAJECTORY Sends a trajectory message to a continuous palpation node
%   Positions is a 3xN matrix of positions. The current orientation is kept
%   constant.
msg = rosmessage('geometry_msgs/PoseArray');
msg.Header.Stamp = rostime('now');
curr = robot.position_current_subscriber.LatestMessage.Pose;
for idx = 1:size(positions,2)
    pose = curr.copy();
    pose.Position.X = positions(1,idx) + curr.Position.X;
    pose.Position.Y = positions(2,idx) + curr.Position.Y;
    pose.Position.Z = positions(3,idx) + curr.Position.Z;
    msg.Poses = [msg.Poses;pose];
end
rospublisher('/set_continuous_palpation_trajectory', msg);
end