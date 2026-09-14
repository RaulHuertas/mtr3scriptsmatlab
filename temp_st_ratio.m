function [st_srt] = temp_st_ratio(temperature_celsius)
if temperature_celsius >= 600
    st_srt = 0.549;
elseif temperature_celsius >= 550
    st_srt = 0.672;
elseif temperature_celsius >= 500
    st_srt = 0.768;
elseif temperature_celsius >= 450
    st_srt = 0.843;
elseif temperature_celsius >= 400
    st_srt = 0.9;
elseif temperature_celsius >= 350
    st_srt = 0.943;
elseif temperature_celsius >= 300
    st_srt = 0.975;
elseif temperature_celsius >= 250
    st_srt = 1.0;
elseif temperature_celsius >= 200
    st_srt = 1.02;
elseif temperature_celsius >= 150
    st_srt = 1.025;
elseif temperature_celsius >= 100
    st_srt = 1.02;
elseif temperature_celsius >= 50
    st_srt = 1.01;
elseif temperature_celsius >= 20
    st_srt = 1.0;
else
    st_srt = 1.0;
    
end