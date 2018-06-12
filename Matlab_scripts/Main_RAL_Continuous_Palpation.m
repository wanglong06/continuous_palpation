%%  Automatic Continuous palpation
%   to collecting data for Preetham's RAL 2018
clc;close all;clear;
dvrk_init_continous_palp;
dvrk = nripsm('PSM2');
%%  Ros topics
% force_sub = rossubscriber('/atinetft/wrench');
traj_sub = rossubscriber('/trajectory_length');
rate = rosrate(200);
%%  Load a raster trajectory
%   The raster trajectory is generated using the followign command line
%   DefineExplorationMapCorners
% RasterTrajName = 'ExplrMapVURaster';
% RasterTrajName='test1Raster';
RasterTrajName='June10RasterOutputTemp';
Config_mat_path = ...
    [getenv('CONT_PALP_DIR'),filesep,...
    'GenPath',filesep,'Config_Mat'];
LoadedData = load([Config_mat_path,filesep,RasterTrajName]);
PATH = LoadedData.PATH;
TotalLengthTraj = size(PATH.DATA,2);
currentTrajSentIdx = 0;
nextTrajSentIdx = currentTrajSentIdx + 10;

%%  logging while robot in control
i = 0;
fprintf('\nData samples being collected ...\n');
reverseStr = [];
while nextTrajSentIdx<TotalLengthTraj
    send_trajectory(PATH.DATA(2:4,currentTrajSentIdx+1:nextTrajSentIdx),dvrk);
    figure(1)
    cla
    DrawPathPlan(PATH.POINTS)
    scatter3(PATH.DATA(2,currentTrajSentIdx+1),PATH.DATA(3,currentTrajSentIdx+1),PATH.DATA(4,currentTrajSentIdx+1),80,'y','filled');
    scatter3(PATH.DATA(2,nextTrajSentIdx),PATH.DATA(3,nextTrajSentIdx),PATH.DATA(4,nextTrajSentIdx),80,'c','filled');
    drawnow
    
    while traj_sub.LatestMessage.Data<=nextTrajSentIdx
        %         [pos,quat,force]=getRobotData(dvrk,force_sub);
        %         logger.log_position_force_quat(pos,force,quat);
        msg = sprintf('%.0f samples ... ',i);
        fprintf([reverseStr, msg]);
        reverseStr = repmat(sprintf('\b'), 1, length(msg));
        i = i+1;
    end
    currentTrajSentIdx = nextTrajSentIdx;
    nextTrajSentIdx = currentTrajSentIdx + 10;
end
fprintf(' [ok].')

%% Finish experiment and save data
