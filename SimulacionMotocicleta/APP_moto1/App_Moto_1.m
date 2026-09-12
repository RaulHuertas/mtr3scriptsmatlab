%
%
%
%
%


clear all;  close all;

% make sure the folder is on your MatlaPath (pathdef.m)
%addpath(genpath('folder App_moto'));

%%
figure_handle = figure('Name','motorcycle animation','NumberTitle','off','Position',[100,100,1080,720],'Tag','figure_handle','Resize','off','Visible','off');
createForceElementsMenu; 
createUIcontrols;


%% INITIALIZE       create frequently used objects and store into figure_handle.UserData
    initialize_plot_app;
    initialize_force_elements_app;
    animateFram1_1();
    
    figure_handle.Visible='on';
%%


       load('FirstWheelie1.mat','q','qd','t');% WHEELIE
   %    load('sample_data.mat','q','qd','t'); % SAMPLE_DATA by W.Ooms
    %   load('stoppie_3.mat','q','qd','t');   % STOPPIE


 animateFram1_1(q,qd,t);
 
 
