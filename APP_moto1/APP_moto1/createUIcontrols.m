function [] = createUIcontrols
    figure_handle = findobj('Tag','figure_handle');
    
        data = figure_handle.UserData;
        data.Play = 1;
        figure_handle.UserData = data;
    
   btnPause = uicontrol(figure_handle,'Style','pushbutton','String','Pause','Callback',@ PauseCallback,'OuterPosition',[38.8000  686.4000   34.0000   31.0000]);
    btnPlay = uicontrol(figure_handle,'Style','pushbutton','String','Play','Callback',@ PlayCallback,'OuterPosition',[5.0000  686.4000   34.0000   31.0000]);
    btnStop = uicontrol(figure_handle,'Style','pushbutton','String','Stop','Callback',@ StopCallback,'OuterPosition',[73.0000  686.4000   34.0000   31.0000]);

%%
function [] = PauseCallback(source,~)
dat = figure_handle.UserData;
dat.Play = 0;
figure_handle.UserData = dat;

end

function [] = StopCallback(source,~)
dat = figure_handle.UserData;
dat.Play = 0;
dat.Index = 1;

figure_handle.UserData = dat;



% load('stoppie_3.mat','q','qd','t');  q(1),qd(1),t(1)
        animateFram1_1();
end

function [] = PlayCallback(source,~)
Dat = figure_handle.UserData;
Dat.Play = 1;
figure_handle.UserData = Dat;

        i = figure_handle.UserData.Index;
        load('stoppie_3.mat','q','qd','t');
        animateFram1_1(q,qd,t); % q(i:length(q)),qd(i:length(q)),t(i:length(q))

end

end
%%
