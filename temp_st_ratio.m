function [st_srt] = temp_st_ratio(temperature_celsius)
%% Shigley fórmula 6-28
if temperature_celsius >= 600
    st_srt = 0.567;
elseif temperature_celsius >= 550
    st_srt = 0.698;
elseif temperature_celsius >= 500
    st_srt = 0.797;
elseif temperature_celsius >= 450
    st_srt = 0.872;
elseif temperature_celsius >= 400
    st_srt = 0.927;
elseif temperature_celsius >= 350
    st_srt = 0.963;
elseif temperature_celsius >= 300
    st_srt = 0.995;
elseif temperature_celsius >= 250
    st_srt = 1.018;
elseif temperature_celsius >= 200
    st_srt = 1.024;
elseif temperature_celsius >= 150
    st_srt = 1.020;
elseif temperature_celsius >= 100
    st_srt = 1.008;
elseif temperature_celsius >= 50
    st_srt = 1.0;
elseif temperature_celsius >= 20
    st_srt = 1.0;
else
    st_srt = 1.0;
end